# Architecture proposée

## Séparer décision et exécution

L'architecte prépare un ticket et un context pack concis : objectif, décisions, interfaces, périmètre, critères et checks. L'opérateur approuve un snapshot du plan. En V0, il lance les tâches manuellement ; la conversation n'est pas une API accessible depuis le VPS.

Le harness exécute les outils avec les droits qui lui sont accordés. Herdr héberge les terminaux et aide à superviser les sessions ; il ne remplace pas notre définition d'une tâche réussie. Les capacités décrites par les éditeurs sont regroupées dans [compatibility.md](compatibility.md).

Pi, Codex et Cursor sont des chemins alternatifs. On n'empile pas obligatoirement Pi devant Codex ou Cursor. La priorité est de vérifier les CLI officiels et les accès existants ; Pi pourra accueillir des extensions spécifiques après qualification.

## Un run V0

1. L'opérateur choisit un projet autorisé et résout `baseRef` en commit immuable.
2. Deux tâches indépendantes au maximum reçoivent chacune branche, worktree, contexte et limites.
3. Les adaptateurs lancent les CLI avec arguments séparés et environnement minimal.
4. Ils enregistrent localement identité du run/ticket/tentative, timestamps, modèle observé, code de sortie, diff et événements utiles.
5. Un contexte de validation rejoue les checks approuvés ; les changements sont assemblés séquentiellement sur une branche d'intégration puis retestés.
6. Une session distincte réalise la revue. L'opérateur autorise la publication d'une PR en brouillon puis décide de la fusion.

## Deux axes d'état

Exécution : `queued`, `running`, `blocked`, `completed`, `failed`, `cancelled`, `timed_out`, `interrupted`.

Validation : `pending`, `passed`, `failed`, `not_run`.

Un processus terminé, un écran Herdr idle ou une sortie 0 ne signifie pas que les critères sont satisfaits. La validation doit être reliée au commit final. Une dépendance ne devient disponible qu'après la validation exigée par son contrat.

## Parallélisme réel

Les tâches doivent avoir des interfaces stabilisées et des ressources compatibles. Les worktrees séparent les arbres Git, pas les droits système. Ports, bases de test, migrations et lockfiles partagés nécessitent séparation, verrou ou séquencement. Voir [security.md](security.md).

## Routage et budgets

`architect`, `executor_fast` et `reviewer` sont des rôles. Leur mapping harness/provider/model se fait dans une configuration privée après vérification du compte. Aucun modèle n'est supposé meilleur pour un type de code sans mesure. Un quota bloque la file ; il ne déclenche ni achat ni changement de compte.

## V1 seulement après preuve V0

Le dispatcher TypeScript ajoutera DAG, validation des dépendances, état durable, concurrence bornée et réconciliation après crash. Il ne sera pas piloté par un LLM. Le redémarrage doit distinguer reprise d'une session et relance d'effets déjà exécutés. Pas de promesse d'exécution exactement une fois pour les actions externes.
