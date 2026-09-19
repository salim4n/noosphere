# ADR-003 — Les documents sont versionnés et publiés par PR

Statut : accepté · 2026-09-19

## Décision

Le navigateur lit `docs/` depuis le dépôt. Toute création ou modification passe par un worktree, une branche et une PR brouillon. `main` n’est jamais écrit directement par l’UI.

## Conséquences

- Le composant d’édition doit présenter diff, base SHA et checks avant publication.
- Les permissions GitHub doivent séparer lecture, branche et création de PR.
- Un conflit de branche devient un état récupérable, pas une écriture forcée.
