# ADR-004 — L’état d’exécution est distinct du statut Kanban

Statut : accepté · 2026-09-19

## Décision

Le statut GitHub (`Todo`, `In progress`, `Done`, ou mapping configuré) décrit le travail. Le run possède son propre état (`queued`, `running`, `blocked`, `completed`, `failed`, `cancelled`, `timed_out`, `interrupted`) et une validation (`pending`, `passed`, `failed`, `not_run`).

## Pourquoi

Un agent peut terminer son processus avec une sortie zéro tandis que les checks échouent, ou un ticket peut être `In progress` sans run actif. Fusionner les deux rendrait les erreurs invisibles.
