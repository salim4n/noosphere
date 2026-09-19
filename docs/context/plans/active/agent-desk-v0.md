# Plan actif — Agent Desk V0

Statut : **proposé, non exécuté**. Référence : [issue #11](https://github.com/salim4n/noosphere/issues/11), dépendant des contrats V0 (#2–#8).

## Ordre de réalisation

1. **Contrats et contexte (#7)**
   - implémenter la validation JSON et les contrôles hors schéma ;
   - figer les identifiants de checks approuvés et le format du context pack.
2. **Qualification et bootstrap (#2, #3)**
   - produire un rapport privé des CLI, comptes, modèles, ressources et permissions ;
   - ne rien installer ni exposer sans preuve et approbation.
3. **Adapters d’exécution (#4–#6)**
   - connecter Herdr, Git worktrees et les harnesses via ports testables ;
   - imposer deux workers maximum et un environnement minimal.
4. **Agent Desk UI (#11)**
   - ajouter le binding projet versionné ;
   - lire et réconcilier GitHub Projects v2 ;
   - afficher les documents ;
   - proposer les changements via branche/PR ;
   - lire l’état des runs Herdr sans devenir un scheduler implicite.
5. **Démonstration V0 (#8)**
   - fixture jetable, même commit de base, deux worktrees, deux workers, checks, revue et PR brouillon ;
   - conserver les preuves et les états d’échec.

## Garde-fous d’implémentation

- Toute mutation externe est idempotente, journalisée et liée à un identifiant d’opération.
- Une erreur de permission, quota, expiration ou conflit devient `blocked`/`failed`; elle ne devient jamais un succès vide.
- Aucun webhook ou texte d’issue publique ne déclenche directement un worker.
- Aucune fusion automatique, publication production ou dépense n’est implicite.
- Le runtime doit être implémenté avant de déclarer l’issue #11 terminée.

## Critères de sortie

Les critères de #11 et de l’epic #1 sont tous vérifiés sur une fixture : mouvement Kanban aller-retour avec GitHub, édition documentaire avec PR, run lié à une Issue/PR, états mobile/desktop et tests de reprise/erreur.

## Issues publiées

- [#12 — Spec Agent Desk V0](https://github.com/salim4n/noosphere/issues/12)
- [#13 — Lier un projet et réconcilier le Kanban GitHub](https://github.com/salim4n/noosphere/issues/13)
- [#14 — Lire les documents du dépôt et proposer une PR](https://github.com/salim4n/noosphere/issues/14)
- [#15 — Préparer et superviser un run Herdr dans un worktree](https://github.com/salim4n/noosphere/issues/15)
- [#16 — Relier carte, document, run et livraison dans Agent Desk](https://github.com/salim4n/noosphere/issues/16)
- [#17 — Démontrer deux workers parallèles avec preuves](https://github.com/salim4n/noosphere/issues/17)

Les tickets sont publiés avec le label `ready-for-agent`. Les blocages sont déclarés dans chaque issue ; #2 et #7 sont les prérequis existants qualifiés et marqués `ready-for-agent`.
