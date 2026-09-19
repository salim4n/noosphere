# ADR-001 — GitHub Projects v2 est la source de vérité du Kanban

Statut : accepté dans l’issue #11 · 2026-09-19

## Décision

Agent Desk lit et met à jour les éléments GitHub Projects v2 via un adaptateur. Il conserve seulement un binding de projet, des curseurs de synchronisation et des identifiants externes nécessaires à la réconciliation.

## Pourquoi

Le dépôt et GitHub portent déjà Issues, PR et historique. Dupliquer le statut dans une base Noosphere créerait des conflits et rendrait les changements externes invisibles.

## Conséquences

- Les commandes de lecture doivent tolérer retard, pagination et éléments supprimés.
- Les mises à jour utilisent une clé d’idempotence et vérifient la version observée.
- Un cache local est une projection avec fraîcheur explicitement affichée, jamais une autorité.
