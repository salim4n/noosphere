# Roadmap

[Epic V0](https://github.com/salim4n/noosphere/issues/1) : deux workers supervisés, preuves de validation, une PR sans fusion automatique.

| Ticket | Livrable | Dépendances |
| --- | --- | --- |
| [#2](https://github.com/salim4n/noosphere/issues/2) | Qualification VPS, CLI, modèles et comptes | Aucune |
| [#3](https://github.com/salim4n/noosphere/issues/3) | Bootstrap reproductible | #2 |
| [#4](https://github.com/salim4n/noosphere/issues/4) | Herdr, sessions et supervision | #3 |
| [#5](https://github.com/salim4n/noosphere/issues/5) | Worktrees et isolation | #3 ; coordination #7 |
| [#6](https://github.com/salim4n/noosphere/issues/6) | Adaptateurs Codex/Cursor, Pi optionnel | #2, #5, #7 |
| [#7](https://github.com/salim4n/noosphere/issues/7) | Contrat de ticket et context pack | Aucune |
| [#8](https://github.com/salim4n/noosphere/issues/8) | Démonstration et validation V0 | #4, #5, #6, #7 |
| [#9](https://github.com/salim4n/noosphere/issues/9) | Dispatcher déterministe V1 | V0 validée via #8 |

Commencer par #2 et #7 en parallèle. Ne pas paralléliser l'implémentation de contrats encore mouvants.

Ces dépendances sont documentaires : aucun ordonnanceur ni blocage automatique GitHub n'est installé. Les cases des issues ne sont cochées qu'après preuve de réalisation.
