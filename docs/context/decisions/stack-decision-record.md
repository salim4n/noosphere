# Stack decision record — Agent Desk

Statut : **proposition à valider pendant l’implémentation**. Aucun choix ci-dessous n’est encore installé dans le dépôt.

| Couche | Proposition | Justification | À vérifier |
|---|---|---|---|
| Interface | application web responsive, contrat API séparé | macOS et smartphone, états synchronisés et accès privé | préférence de framework et auth opérateur |
| Backend | monolithe modulaire avec ports/adapters | équipe réduite, intégrations cohérentes, déploiement simple | langage/runtime réellement retenus |
| Persistance | PostgreSQL seulement si l’état de projection/audit le justifie | transactions pour bindings, cursors, idempotence et audit | volumétrie et politique de rétention |
| Kanban | GitHub Projects v2 adapter | source de vérité acceptée dans #11 | permissions et API GraphQL disponibles |
| Runtime | Herdr adapter | sessions et supervision déjà ciblées | CLI/API et modèle d’autorisation |
| Documents | Git worktree + branche + PR | historique et revue natifs du dépôt | limites GitHub et conflits |
| Queue | aucune queue dédiée en V0 | déclenchement manuel, deux workers maximum | V1 seulement si la démonstration le justifie |
| Auth | session privée + GitHub OAuth/App à choix explicite | éviter un token personnel copié dans les workers | modèle exact et rotation |

Le stack final sera une décision d’implémentation après qualification #2. Aucun nom de modèle (« Astra », « Luna », « Grok ») n’est codé en dur.
