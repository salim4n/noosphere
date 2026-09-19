# docs/context/current-state.md — AS-IS / Ground Truth

Last assessed: 2026-09-19
Assessed complexity: Architectural
Mode: Mode B — Reverse Engineering

## What is true right now

### Product snapshot

- **Archetype** : future web application privée de pilotage d’agents, utilisable sur desktop et mobile.
- **Issue produit de référence** : [#11](https://github.com/salim4n/noosphere/issues/11), Agent Desk avec synchronisation GitHub Projects, documentation de dépôt et contrôle Herdr.
- **Parcours cible** : choisir un projet → voir les tâches GitHub → ouvrir un document versionné → préparer un run → superviser Herdr → examiner les preuves et la PR.

### Ground truth sources

- **Source code** : aucun code applicatif ; le dépôt contient README, consignes, documentation, schéma JSON, exemple, template et `scripts/doctor.sh`.
- **Tests** : aucun test applicatif ni validateur de schéma. Les seuls checks déclarés sont `bash -n scripts/doctor.sh` et `bash scripts/doctor.sh --help`.
- **Dépendances** : aucun `package.json`, `bun.lock`, `go.mod`, `requirements.txt` ou fichier de build.
- **Branches** : le travail architectural est sur `architecture/agent-desk`, basé sur `docs/noosphere-foundation`; `main` ne contient que l’initialisation.

## AS-IS architecture summary

### Observed structure

```text
README.md / AGENTS.md          cadrage et règles de contribution
docs/*.md                      architecture, sécurité, bootstrap, compatibilité, roadmap
schemas/task.schema.json       contrat proposé, non validé par un runtime
examples/                      exemple de ticket
templates/                     modèle Markdown de ticket
config/                        exemple de configuration, non consommée
scripts/doctor.sh              inventaire local lecture seule
```

Il n’y a pas encore de couches interface, application, domaine ou infrastructure exécutables. Il n’existe donc pas de violation d’import à déclarer ; toute architecture applicative reste une proposition.

### Behavior and constraints already stated

- GitHub Projects v2 est la source de vérité du Kanban.
- Les Issues et PR restent les cartes durables ; l’UI ne doit pas créer un second Kanban.
- Le dépôt est la source de vérité des documents sous `docs/`.
- Herdr supervise les sessions et processus, mais ne définit pas la réussite métier.
- L’état d’exécution d’un run est distinct du statut Kanban.
- Les éditions de documents passent par branche et PR ; pas d’écriture directe sur `main`.
- Deux workers au maximum en V0, déclenchement manuel, revue indépendante et décision humaine.

### External integrations

GitHub Projects/Issues/PR, Herdr, puis Codex/Cursor/Pi via adaptateurs explicitement qualifiés. Les comptes, tokens, modèles et capacités ne sont pas vérifiés dans ce dépôt.

## Risks, gaps and open questions

| Finding | Evidence | Impact |
|---|---|---|
| Aucun runtime | absence de dépendances et d’entrypoint | impossible de démontrer synchronisation, auth ou contrôle Herdr |
| Contrat de ticket non validé | issue #7 ouverte, pas de validateur | tickets potentiellement ambigus ou hors périmètre |
| Auth UI non décidée | issue #11, open input | surface d’accès et permissions inconnues |
| Mapping Project/Herdr inconnu | issue #11, open input | impossible de relier une carte à un run de façon fiable |
| Maquettes absentes avant ce travail | aucun `design/` sur `origin/main` | risque de coder une interface sans états d’erreur/empty/mobile |

Les violations Clean Architecture classiques ne sont pas « absentes parce que le système est sain » : elles sont non observables tant qu’aucune source applicative n’existe.
