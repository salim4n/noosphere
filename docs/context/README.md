# docs/context/README.md — Noosphere Agent Desk

Last updated: 2026-09-19

## Purpose

Ce dossier conserve le contexte d’architecture durable produit pour Noosphere. Il sépare les faits observés, les décisions prises et les plans qui restent à exécuter.

## Structure

```text
docs/context/
├── README.md
├── current-state.md
├── architecture-spec.md
├── decisions/
│   ├── stack-decision-record.md
│   ├── ADR-001-github-projects-source-of-truth.md
│   ├── ADR-002-herdr-runtime-boundary.md
│   ├── ADR-003-document-edits-through-pr.md
│   ├── ADR-004-run-state-separate-from-kanban.md
│   └── ARCHITECTURE_CONTRACT.md
└── plans/
    ├── active/agent-desk-v0.md
    └── archived/
```

## Quick navigation

- **AS-IS** : [`current-state.md`](current-state.md)
- **Blueprint et contrats** : [`architecture-spec.md`](architecture-spec.md)
- **Décisions backend** : [`decisions/backend-decision-record.md`](decisions/backend-decision-record.md)
- **UML et flux** : [`uml.md`](uml.md)
- **Décisions** : [`decisions/`](decisions/)
- **Plan actif** : [`plans/active/agent-desk-v0.md`](plans/active/agent-desk-v0.md)
- **UX et inventaire d’écrans** : [`ux-spec.md`](ux-spec.md)
- **Maquettes UX** : [`../../design/index.html`](../../design/index.html)

## Règle d’utilisation

Un agent commence par `current-state.md`, vérifie les décisions applicables, puis suit le plan actif. Une modification de frontière, de source de vérité ou de permission doit ajouter un ADR avant le code. Les maquettes HTML sont des artefacts de conception et ne constituent pas le runtime.
