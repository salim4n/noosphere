# Sécurité et périmètre de confiance

Ces règles sont des exigences de conception, pas la description de contrôles déjà déployés.

## Machine

Utiliser un périmètre de développement dédié, non-root, sans accès production ni données clients. Ne pas partager le contexte de confiance des workers avec une base production. L'absence de popups dans un agent n'est pas une protection.

Les worktrees et les consignes de prompt ne sont pas une sandbox. Tester les droits effectifs : utilisateur isolé, conteneur rootless ou VM selon les contraintes qualifiées. Ne pas monter le socket Docker hôte ni donner sudo au worker. Limiter mémoire, CPU, nombre de processus, disque et accès réseau selon le besoin.

## Secrets

Les caches OAuth et clés sont des secrets. Les conserver hors dépôt avec accès minimal. Ne pas copier le home complet dans un conteneur. Un secret accessible au processus agent peut aussi l'être aux outils qu'il lance : cette exposition doit être mesurée, pas masquée par une règle textuelle.

Séparer le contexte d'exécution du contexte qui publie une PR. Les workers ne reçoivent pas les droits administrateur GitHub. Un `.gitignore` est une aide, pas un dispositif anti-exfiltration.

## Entrées publiques

Aucune issue, PR ou commentaire externe ne déclenche directement un worker. Un humain approuve projet, commit, périmètre et checks. Ne pas concaténer un texte de ticket dans une commande shell. Valider chemins réels, symlinks, refs, origine des skills et commandes de vérification.

Aucun workflow de ce dépôt public ne doit recevoir un cache d'authentification personnel ou déclencher les abonnements de l'opérateur. Les éventuels tests CI restent hors réseau avec faux adaptateurs.

## Résultats et actions

Transcripts et détails du VPS restent privés. Ne publier que des résumés et preuves expurgés. Tester expiration de session, quota, timeout, sortie invalide, modification hors périmètre et interruption. Une PR, fusion, suppression ou dépense n'est jamais une conséquence implicite d'un message « terminé ».

Les recommandations d'authentification éditeur sont référencées dans [compatibility.md](compatibility.md).
