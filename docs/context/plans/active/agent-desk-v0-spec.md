# Spécification — Agent Desk V0 : du ticket à la preuve

Statut : brouillon de synthèse, à valider avant publication des tickets.

## Problem Statement

Noosphere possède aujourd’hui un cadrage d’architecture, mais aucun parcours exécutable. L’opérateur ne peut pas partir d’une tâche GitHub, lancer un worker isolé, suivre sa session Herdr, rejouer les checks et obtenir une livraison revue avec des preuves.

## Solution

Construire un vertical slice privé et manuel : un projet autorisé est réconcilié depuis GitHub Projects v2, une carte porte un contrat de tâche validé, un run est créé sur un commit immuable dans un worktree, Herdr supervise la session et Agent Desk affiche séparément l’exécution, la validation et la livraison. Les documents sont lus depuis le dépôt et leurs modifications passent par branche et PR brouillon.

La V0 reste bornée à deux workers maximum, sans webhook public, auto-merge, déploiement production ni fallback payant implicite.

## User Stories

1. En tant qu’opérateur, je veux lier un dépôt et un Project GitHub autorisés afin de voir les tâches réelles.
2. En tant qu’opérateur, je veux voir la fraîcheur et la source de chaque statut afin de distinguer une donnée actuelle d’une projection stale.
3. En tant qu’opérateur, je veux ouvrir une carte et voir son contrat, ses dépendances, ses checks et son périmètre avant de lancer un worker.
4. En tant qu’opérateur, je veux qu’un ticket invalide soit bloqué avec une erreur ciblée plutôt que corrigé silencieusement.
5. En tant qu’opérateur, je veux préparer un run depuis un commit de base résolu afin que le résultat soit attribuable.
6. En tant qu’opérateur, je veux qu’un worktree distinct soit attribué à chaque tâche afin d’éviter les collisions de fichiers.
7. En tant qu’opérateur, je veux voir la session Herdr, le pane, le harness et le modèle effectivement observé afin de savoir ce qui a réellement tourné.
8. En tant qu’opérateur, je veux voir séparément l’état d’exécution et l’état de validation afin qu’une sortie zéro ne masque pas un check échoué.
9. En tant qu’opérateur, je veux relancer une tentative explicitement après quota, timeout, interruption ou erreur de permission.
10. En tant qu’opérateur, je veux lire les documents du dépôt dans l’interface afin de garder les décisions près du code.
11. En tant qu’opérateur, je veux proposer une modification documentaire dans une branche et une PR brouillon afin que `main` ne soit jamais écrit directement.
12. En tant qu’opérateur, je veux voir une preuve de base SHA, diff, checks, code de sortie et timestamps avant de demander une revue.
13. En tant qu’opérateur, je veux que les changements GitHub externes soient réconciliés sans créer un Kanban concurrent.
14. En tant qu’opérateur, je veux utiliser l’interface sur 390 px et sur desktop avec les mêmes destinations principales.
15. En tant qu’opérateur, je veux qu’une indisponibilité GitHub ou Herdr affiche une action de reprise explicite et conserve la dernière donnée connue.

## Implementation Decisions

- GitHub Projects v2 est l’autorité du Kanban ; la projection locale ne conserve que binding, curseurs, fraîcheur et audit.
- Herdr reste le runtime des workspaces et panes ; Agent Desk ne devient pas un second multiplexeur ou scheduler.
- Le contrat de tâche est validé avant création d’un run ; les checks sont des identifiants approuvés, pas des commandes issues d’un ticket.
- Chaque run possède `baseSha`, ticket, worktree, état d’exécution, état de validation, tentatives et livraison.
- Les mutations externes utilisent une clé d’idempotence et refusent les écritures directes sur `main`.
- Les documents sont lus depuis `docs/` et publiés par branche/PR.
- Les comptes, tokens, providers et modèles sont qualifiés séparément ; les labels Astra/Luna/Grok ne sont pas convertis en identifiants supposés.
- La V0 utilise des adaptateurs injectés et des fakes pour les tests ; aucun accès réel payant n’est requis pour les tests unitaires.
- Les états P0 de l’interface sont empty, loading, success, error, stale/reconnecting lorsque l’intégration le nécessite.

## Testing Decisions

- Tester les comportements observables aux seams d’adaptateur : validation de ticket, réconciliation idempotente, transitions de run, conflit de version GitHub et proposition documentaire.
- Utiliser des fakes GitHub, Herdr et Git pour les tests unitaires et d’intégration hors réseau.
- Garder une fixture jetable pour la démonstration de deux worktrees depuis le même SHA.
- Vérifier explicitement quota, timeout, permission refusée, doublon d’événement, reprise après reconnexion et modification hors périmètre.
- La preuve V0 est un scénario authentifié et séparé des tests unitaires ; elle ne doit pas être remplacée par un écran Herdr idle ou un exit code zéro.

## Out of Scope

Multi-tenant, application native iOS/Android, webhook public, polling automatique d’issues arbitraires, dispatcher DAG V1, auto-merge, déploiement production, secrets dans Git et changement de facturation.

## Further Notes

Les maquettes dans `design/` sont le contrat UX de référence, pas du code de production. Les décisions d’authentification GitHub et de nommage initial des workspaces Herdr restent à confirmer dans la qualification VPS.
