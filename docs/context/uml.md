# UML et flux — Noosphere Agent Desk V0

Ces diagrammes décrivent le modèle cible proposé. Ils ne signifient pas que les tables ou services sont déjà implémentés.

## Entités et relations

```mermaid
erDiagram
  PROJECT_BINDING ||--o{ SYNC_CURSOR : maintains
  PROJECT_BINDING ||--o{ WORK_ITEM : projects
  PROJECT_BINDING ||--o{ AGENT_RUN : scopes
  WORK_ITEM ||--o{ AGENT_RUN : triggers
  AGENT_RUN ||--o{ RUN_ATTEMPT : retries
  AGENT_RUN ||--o{ RUN_EVENT : records
  AGENT_RUN ||--o| DELIVERY : proposes
  PROJECT_BINDING {
    uuid binding_id PK
    string repository UK
    string github_project_node_id UK
    string docs_root
    string herdr_workspace
    json status_mapping
    datetime created_at
    datetime updated_at
  }
  SYNC_CURSOR {
    uuid cursor_id PK
    uuid binding_id FK
    string stream UK
    string value
    datetime observed_at
  }
  WORK_ITEM {
    string github_node_id PK
    uuid binding_id FK
    string issue_url
    string title
    string external_status
    string observed_sha
    datetime observed_at
  }
  AGENT_RUN {
    uuid run_id PK
    uuid binding_id FK
    string work_item_node_id FK
    string base_sha
    string execution_state
    string validation_state
    datetime created_at
    datetime updated_at
  }
  RUN_ATTEMPT {
    uuid attempt_id PK
    uuid run_id FK
    int sequence
    string harness
    string observed_model
    string worktree_path
    string herdr_session
    int exit_code
    datetime started_at
    datetime ended_at
  }
  RUN_EVENT {
    uuid event_id PK
    uuid run_id FK
    uuid attempt_id FK
    string kind
    json redacted_payload
    datetime occurred_at
  }
  DELIVERY {
    uuid delivery_id PK
    uuid run_id FK
    string branch
    string pull_request_url
    string review_state
    datetime created_at
  }
```

## États d’un run

```mermaid
stateDiagram-v2
  [*] --> queued
  queued --> running: session accepted
  queued --> blocked: quota/permission/resource
  running --> completed: process ended
  running --> failed: provider/contract error
  running --> timed_out: deadline reached
  running --> interrupted: session lost or explicit stop
  blocked --> queued: operator resolves blocker
  failed --> queued: explicit retry
  timed_out --> queued: explicit retry
  interrupted --> queued: explicit retry
  completed --> [*]
  failed --> [*]
  timed_out --> [*]
  interrupted --> [*]
```

`validationState` est indépendant : `pending`, `passed`, `failed`, `not_run`. Un état `completed` ne change pas cette valeur automatiquement.

## Séquence carte → run → PR

```mermaid
sequenceDiagram
  actor Operator
  participant UI as Agent Desk UI
  participant App as Application API
  participant GH as GitHub adapter
  participant Git as Worktree adapter
  participant HR as Herdr adapter
  Operator->>UI: ouvre une carte validée
  UI->>App: PrepareRun(contract, baseRef)
  App->>GH: resolve baseRef + verify project item
  GH-->>App: immutable baseSha
  App->>Git: create isolated worktree
  Git-->>App: worktreePath
  App->>HR: ensure workspace + pane
  HR-->>App: sessionId/paneId
  App-->>UI: run queued
  Operator->>UI: démarre explicitement
  UI->>App: StartRun(idempotencyKey)
  App->>HR: launch harness in pane
  HR-->>App: running + observed model
  App-->>UI: running
  HR-->>App: exit code + events
  App->>Git: collect diff and checks
  Git-->>App: evidence
  App-->>UI: validation pending
  Operator->>UI: autorise la livraison
  UI->>App: PublishDraftPR
  App->>GH: create branch + draft PR
  GH-->>App: pullRequestUrl
  App-->>UI: review pending
```

## Dépendances et frontières

```mermaid
graph LR
  Interface[HTTP + responsive UI] --> Application[Use cases]
  Application --> Domain[Invariants + ports]
  GitHub[GitHub adapter] --> Domain
  Herdr[Herdr adapter] --> Domain
  Git[Git/worktree adapter] --> Domain
  Store[Audit/projection store] --> Domain
  Application --> GitHub
  Application --> Herdr
  Application --> Git
  Application --> Store
```
