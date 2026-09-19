# Architecture specification — Noosphere Agent Desk V0

Statut : blueprint issu du reverse-architecture pass, 2026-09-19. Ce document ne prétend pas que les composants existent.

## 1. Produit et utilisateurs

Noosphere est une console privée pour un opérateur qui planifie des tâches de code, suit leur statut GitHub, consulte les documents du dépôt et supervise des runs d’agents hébergés par Herdr.

L’utilisateur doit pouvoir, en moins de cinq minutes : ouvrir un projet autorisé, comprendre ce qui demande son attention, inspecter une carte, lancer un run validé et voir une preuve exploitable quand il s’arrête.

## 2. Bounded contexts

| Context | Responsabilité | Autorité |
|---|---|---|
| Project binding | repo, Project ID, mapping, docs root, workspace Herdr | configuration versionnée + permission opérateur |
| Work tracking | cartes, statuts et liens Issues/PR | GitHub Projects v2 |
| Repository docs | lecture, édition, diff et PR | Git + GitHub |
| Agent runs | tickets, worktrees, sessions, tentatives, preuves | Agent Desk + Herdr pour l’exécution |
| Reconciliation | cursors, idempotency, stale/error state | projection locale auditable |

## 3. Domain model

```mermaid
erDiagram
  PROJECT_BINDING ||--o{ SYNC_CURSOR : owns
  PROJECT_BINDING ||--o{ AGENT_RUN : scopes
  WORK_ITEM ||--o{ AGENT_RUN : may_start
  AGENT_RUN ||--o{ RUN_ATTEMPT : contains
  AGENT_RUN ||--o{ RUN_EVENT : emits
  AGENT_RUN ||--o| DELIVERY : produces
  PROJECT_BINDING {
    uuid id PK
    string repository UK
    string github_project_id UK
    string docs_root
    string herdr_workspace
    string status_mapping_version
    datetime updated_at
  }
  WORK_ITEM {
    string github_node_id PK
    string issue_or_pr_url
    string title
    string external_status
    datetime observed_at
  }
  AGENT_RUN {
    uuid id PK
    uuid binding_id FK
    string work_item_id FK
    string base_sha
    string state
    string validation_state
    datetime created_at
  }
  RUN_ATTEMPT {
    uuid id PK
    uuid run_id FK
    int number
    string harness
    string observed_model
    string worktree
    int exit_code
    datetime started_at
    datetime ended_at
  }
  RUN_EVENT {
    uuid id PK
    uuid run_id FK
    string kind
    string redacted_payload
    datetime occurred_at
  }
  DELIVERY {
    uuid id PK
    uuid run_id FK
    string branch
    string pull_request_url
    string review_state
  }
  SYNC_CURSOR {
    uuid id PK
    uuid binding_id FK
    string stream UK
    string cursor
    datetime observed_at
  }
```

Invariants: un run ne peut référencer qu’un `baseSha` résolu ; une tentative ne peut écrire que dans son worktree ; un `Delivery` ne peut publier qu’après checks et revue ; une mutation externe répétée ne crée pas de doublon.

## 4. Component blueprint

```mermaid
graph TD
  UI[Responsive private UI] --> API[Interface/API]
  API --> UC[Application use cases]
  UC --> DOM[Domain policies]
  UC --> GH[GitHub Projects/Issues/PR adapter]
  UC --> HR[Herdr adapter]
  UC --> GIT[Git/worktree adapter]
  UC --> STORE[(Audit/projection store)]
  GH --> GITHUB[(GitHub)]
  HR --> HERDR[(Herdr)]
  GIT --> REPO[(Authorized repository)]
```

Use cases V0 : `ListProjectAttention`, `ReconcileProject`, `ReadDocument`, `ProposeDocumentChange`, `PrepareRun`, `StartRun`, `InspectRun`, `StopRun`, `PublishDraftPullRequest`.

## 5. API contract (proposed)

| Endpoint | Méthode | Résultat |
|---|---|---|
| `/api/projects` | GET | projets autorisés + fraîcheur + erreurs |
| `/api/projects/:id/reconcile` | POST | curseur et résumé idempotent de réconciliation |
| `/api/projects/:id/board` | GET/PATCH | projection GitHub et mutation de statut avec version observée |
| `/api/projects/:id/docs` | GET | index versionné sous `docs/` |
| `/api/projects/:id/docs/*path` | GET | document + SHA |
| `/api/projects/:id/doc-changes` | POST | branche/patch proposé, jamais écriture directe |
| `/api/runs` | POST | run préparé depuis ticket validé, état `queued` |
| `/api/runs/:id` | GET | état d’exécution et validation distincts |
| `/api/runs/:id/actions/start` | POST | démarrage autorisé, idempotency key |
| `/api/runs/:id/actions/stop` | POST | arrêt explicite et événement auditable |

Toutes les réponses d’intégration portent `freshness`, `source`, `observedAt` et une erreur actionnable quand la source est indisponible.

## 6. Critical journey

```mermaid
sequenceDiagram
  actor Salim
  participant UI as Agent Desk
  participant API as Application API
  participant GH as GitHub
  participant HR as Herdr
  Salim->>UI: ouvre le projet
  UI->>API: GET board + attention
  API->>GH: lire Project/Issues/PR
  GH-->>API: projection + cursor
  API-->>UI: statut frais ou stale
  Salim->>UI: prépare un run sur une carte validée
  UI->>API: POST /runs (base SHA + contrat)
  API->>HR: créer/inspecter session autorisée
  HR-->>API: session + pane + état
  API-->>UI: run queued/running
  Salim->>UI: consulte preuves et diff
  UI->>API: POST draft PR après checks
  API->>GH: créer branche/PR brouillon
  GH-->>UI: URL PR + review pending
```

## 7. UX package

Les maquettes dans [`design/`](../../design/index.html) couvrent : tableau de bord/attention, Kanban GitHub, documents/diff et détail d’un run. Chaque écran contient empty/loading/error/success, est mobile-first à 390 px et utilise les mêmes tokens.

## 8. Validation et observabilité

Les tests unitaires couvrent mapping, idempotence, transitions d’état et permissions simulées. Les tests d’intégration utilisent GitHub/Herdr fake ou sandboxés. Les preuves d’un run incluent SHA, ticket, tentative, modèle observé, exit code, checks, diff et timestamps redigés. Aucun transcript privé ne part dans la PR.
