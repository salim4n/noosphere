# Backend decisions — Agent Desk V0

Date : 2026-09-19 · Statut : architecture proposée, à confirmer pendant l’implémentation

## Décisions déjà prises

| Sujet | Décision | Raison | Preuve attendue |
|---|---|---|---|
| Autorité Kanban | GitHub Projects v2 | éviter un second système de statut | lecture et mutation idempotentes d’un Project de test |
| Documents | dépôt Git sous `docs/` | historique, diff et revue natifs | PR brouillon créée depuis une proposition |
| Runtime agent | Herdr | sessions/panes persistants déjà ciblés | session survivant à une reconnexion |
| Exécution | worktree par tentative | isoler les arbres Git | deux diffs sans collision |
| Orchestration | manuelle en V0 | réduire la surface avant preuve | parcours déclenché par l’opérateur |
| Concurrence | deux workers maximum | ressources et débogage bornés | test parallèle sur fixture jetable |
| Livraison | PR brouillon, revue humaine, pas d’auto-merge | protéger `main` | branche et PR liées au run |

## Décomposition backend

```text
Interface HTTP/UI
  -> cas d’usage applicatifs
     -> ports de domaine (GitHub, Herdr, Git, store, horloge)
        -> adapters infrastructure
```

Le domaine ne connaît ni HTTP, ni SDK GitHub, ni Herdr, ni ORM. Les cas d’usage orchestrent sans instancier directement un client externe. La composition des adapters est faite dans un seul point de démarrage contrôlé.

## État et idempotence

- `WorkItem.externalStatus` est une projection observée, jamais une autorité locale.
- Chaque réconciliation porte `bindingId`, `stream`, `cursor`, `observedAt` et une clé d’opération.
- Chaque mutation externe accepte une clé d’idempotence et vérifie la version observée avant écriture.
- Chaque run possède deux axes : `executionState` et `validationState`.
- Une reconnexion reprend l’observation ; elle ne relance pas automatiquement un effet externe déjà envoyé.
- Une tentative de relance crée un numéro de tentative distinct et conserve l’échec initial.

## API backend proposée

Les handlers restent fins : validation d’entrée, authentification, appel d’un cas d’usage, traduction d’erreur et réponse. Les réponses d’intégration exposent toujours `source`, `observedAt`, `freshness` et `errorCode` lorsque la source n’est pas disponible.

| Cas d’usage | Port principal | Mutation externe |
|---|---|---|
| `ReconcileProject` | `GitHubProjectPort` | non, lecture/cursor |
| `MoveWorkItem` | `GitHubProjectPort` | oui, idempotente |
| `ReadDocument` | `RepositoryContentPort` | non |
| `ProposeDocumentChange` | `GitPort` + `PullRequestPort` | oui, branche/PR |
| `PrepareRun` | `TaskContractPort` + `WorktreePort` | worktree local |
| `StartRun` | `HerdrSessionPort` + `HarnessPort` | oui, session/processus |
| `InspectRun` | `HerdrSessionPort` + `RunStore` | non |
| `StopRun` | `HerdrSessionPort` | oui, arrêt explicite |

## Authentification et secrets

Le choix GitHub OAuth/App reste à confirmer. Les tokens restent dans un secret store ou un environnement privé ; ils ne sont jamais copiés dans un worktree, un transcript ou une PR. Les workers ne reçoivent pas de droit administrateur GitHub. Les comptes et modèles sont qualifiés séparément et aucun abonnement n’est converti par hypothèse en API.

## Persistance

Un store transactionnel local est requis seulement pour bindings, curseurs, idempotence, runs, tentatives, événements redigés et livraisons. PostgreSQL est la proposition de départ si la qualification confirme le besoin ; aucune base ni ORM n’est encore choisi ou installé. Les données GitHub et les documents restent dans leurs systèmes d’autorité.

## Observabilité

Chaque événement d’exécution conserve un identifiant de run, tentative, timestamp, état, code de sortie et référence au worktree. Les secrets et transcripts sont redigés. Les métriques utiles sont la fraîcheur des projections, les erreurs d’adapter, la durée d’une tentative et le nombre de runs bloqués ; aucun KPI décoratif n’est requis.
