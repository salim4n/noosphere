# Noosphere

**Une forge personnelle pour planifier avec soin, exécuter en parallèle et livrer avec des preuves.**

## État du projet

Socle de conception et backlog. Le seul outil exécutable fourni ici est un inventaire local en lecture seule. **Le bootstrap, les adaptateurs et le dispatcher ne sont pas encore implémentés ; aucun VPS n'a été configuré par cette initialisation.**

## Le flux visé

```text
Salim + Astra : architecture, tickets, contrats, critères d'acceptation
                              |
                    approbation du plan
                              |
               VPS / Herdr : sessions et supervision
                       |                 |
                 worker Codex      worker Cursor
                 worktree A        worktree B
                       |                 |
                vérifications et intégration
                              |
              revue indépendante -> PR -> décision humaine
```

Pi est un harness supplémentaire à qualifier, pas un prérequis bloquant. La V1 ajoutera un dispatcher TypeScript déterministe, après la démonstration V0.

« Astra » et « Luna » expriment le choix de l'architecte et d'exécuteurs rapides souhaité par l'opérateur. Ils ne sont pas des identifiants API codés en dur : le modèle effectif doit être vérifié dans chaque CLI et chaque compte. La planification peut rester dans ChatGPT ; aucune connexion automatique de cette conversation au VPS n'est supposée.

## Commencer

Lire [l'architecture](docs/architecture.md), [la sécurité](docs/security.md) et [le guide opérateur](docs/bootstrap.md). Pour un inventaire sans installation, depuis la racine du dépôt :

```bash
bash scripts/doctor.sh
```

Ce script ne contacte aucun fournisseur et ne vérifie ni les comptes ni leurs quotas.

Le [backlog](docs/roadmap.md) commence par la qualification du VPS et le contrat de ticket, réalisables en parallèle. L'[epic V0](https://github.com/salim4n/noosphere/issues/1) décrit les critères de sortie.

## Reprise Agent Desk

Le blueprint issu du reverse-architecture pass est dans [`docs/context/architecture-spec.md`](docs/context/architecture-spec.md). Il est accompagné de l’état réel du dépôt, des décisions, du plan V0 et de maquettes HTML statiques dans [`design/`](design/index.html). Ces artefacts préparent l’implémentation de l’issue [#11](https://github.com/salim4n/noosphere/issues/11) ; ils ne signalent pas qu’un runtime est déjà installé.

## Contenu

- `AGENTS.md` : consignes pour les contributeurs humains et agents.
- `docs/` : architecture, compatibilité, sécurité, démarrage et roadmap.
- `schemas/`, `examples/`, `templates/` : proposition de contrat de ticket, exemple non exécutable et modèle rédactionnel.
- `config/noosphere.example.json` : proposition de configuration, sans consommateur logiciel à ce stade.
- `scripts/doctor.sh` : inventaire indicatif local.

## Limites de départ

Deux workers au maximum, déclenchement manuel, branches séparées, preuves de tests et revue humaine. Ni auto-merge, ni production, ni secrets dans Git, ni lancement depuis une issue publique. Aucun achat ni fallback API payant implicite.
