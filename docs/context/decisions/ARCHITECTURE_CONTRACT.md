# Architecture contract — Agent Desk V0

Ce contrat décrit les frontières à faire respecter quand le runtime sera implémenté. Il n’est pas encore exécuté par un guardian ; le dépôt ne contient pas de source applicative.

## Boundaries

```text
interface → application → domain
                         ↑
infrastructure ──────────┘
```

- `domain` : invariants et types purs ; aucun HTTP, ORM, SDK GitHub ou Herdr.
- `application` : cas d’usage et ports ; aucune création directe de client externe.
- `infrastructure` : GitHub, Herdr, Git, stockage et auth concrète ; aucune dépendance vers `interface`.
- `interface` : HTTP/UI et validation d’entrée ; délègue aux cas d’usage.

## Mandatory contracts

- Chaque synchronisation externe possède une clé d’idempotence, un curseur et un état d’erreur explicite.
- Aucun statut Kanban concurrent n’est enregistré comme autorité.
- Chaque run garde `baseSha`, ticket, worktree, tentative, modèle effectivement observé, code de sortie, validation et diff.
- Les opérations de branche/PR requièrent une approbation humaine et refusent `main` en écriture directe.
- Les transcripts, secrets, tokens et détails privés du VPS ne franchissent pas la frontière de publication.
- Les checks viennent d’une configuration approuvée ; le contenu d’une issue ne fournit jamais une commande shell.
- Deux workers est la limite V0 ; ressources partagées incompatibles imposent séquencement ou verrou.

## Guardian backlog

Quand le code existera, ajouter un check CI pour détecter : imports externes dans `domain`, clients SDK dans `application`, accès GitHub/Herdr depuis `interface`, écritures directes sur `main`, commandes shell non résolues et absence d’idempotence sur les mutations.
