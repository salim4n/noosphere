# Guide opérateur V0

**Aucune installation automatique n'est fournie à ce stade.** Ne pas chercher une commande de lancement Noosphere : le runtime reste à construire.

## Inventaire local

Depuis la racine d'une copie du dépôt, sur la machine à qualifier :

```bash
bash scripts/doctor.sh
```

Le script lit quelques informations système et détecte des exécutables dans le PATH. Il ne lance pas les CLI agents, ne lit pas leurs caches d'authentification, n'installe rien et ne fait aucun appel réseau. Un code de sortie 0 signifie uniquement que l'inventaire a pu s'exécuter, pas que le VPS est prêt.

Relever ensuite, dans un rapport privé, versions réelles, services présents, contraintes de ressources et accès de secours. L'adresse et les informations de compte ne vont pas dans GitHub.

## Séquence de mise en service

Traiter #2 avant #3. Valider manuellement le plan du bootstrap sur une machine jetable, puis seulement sur le VPS existant. Aucun changement automatique de SSH, pare-feu, reboot ou service production.

Installer puis authentifier chaque CLI séparément selon les sources de [compatibility.md](compatibility.md). Les clés et codes de connexion restent entre l'opérateur et l'éditeur.

La première preuve utilise une fixture jetable et des tests hors réseau. Deux workers maximum, puis intégration et revue. La démonstration finale est décrite dans #8 et la [roadmap](roadmap.md).

`config/noosphere.example.json` décrit une intention ; aucun code ne la consomme encore. Tous les adaptateurs y sont désactivés et aucun projet n'y est autorisé.
