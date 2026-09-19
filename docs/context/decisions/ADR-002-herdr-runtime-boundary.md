# ADR-002 — Herdr reste le runtime de sessions

Statut : accepté · 2026-09-19

## Décision

Agent Desk orchestre l’intention et affiche les preuves ; Herdr reste responsable des workspaces, panes, sessions persistantes et processus. Noosphere ne recrée pas un multiplexeur ni un second scheduler dans V0.

## Conséquences

- L’adaptateur Herdr expose un port limité : lister, inspecter, démarrer/arrêter avec autorisation explicite.
- Un pane idle, une sortie zéro ou une session visible ne prouvent pas que l’acceptation métier est passée.
- Les journaux et transcripts sensibles restent privés et ne sont pas copiés dans GitHub.
