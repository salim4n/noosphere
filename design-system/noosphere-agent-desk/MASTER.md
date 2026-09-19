# Design System Master File

> Direction visuelle pour les maquettes statiques de Noosphere Agent Desk. Les parcours et états définis dans `docs/context/ux-spec.md` restent prioritaires sur l’habillage.

**Project:** Noosphere Agent Desk  
**Updated:** 2026-09-19  
**Direction:** Swiss editorial / premium developer tool

## Intention

Agent Desk doit donner une impression de calme et de maîtrise : l’opérateur voit une décision, sa fraîcheur et sa prochaine action sans traverser un mur de panneaux. La grille est stricte, les surfaces sont claires, les lignes sont fines et l’accent lime sert uniquement à guider l’action.

## Tokens

Le bloc `:root` doit rester identique dans les quatre écrans `design/screen-*.html`.

- **Fond** `#f4f6f1`, surface `#ffffff`, surface secondaire `#eef1ec`, bordure `#d8dfd8`.
- **Encre** `#111613`, texte secondaire `#3f4942`, métadonnées `#68736b`.
- **Accent** `#b7ef51` avec premier plan `#13200c`.
- **Sémantique** : succès `#287a57`, avertissement `#916d15`, danger `#aa3f3b` avec fonds dédiés.
- **Typographie** : pile système sans-serif ; mono pour SHA, chemins et commandes.
- **Rythme** : 4, 8, 12, 16, 24, 32, 48, 72 px ; rayons 8, 14 et pill.

## Règles de composition

- Une page commence par une intention claire, puis une seule zone d’attention prioritaire.
- Préférer une ligne et un espace vide à une carte imbriquée supplémentaire.
- Utiliser une ombre légère seulement pour une priorité active ; la profondeur principale vient de la grille, du contraste et des bordures.
- Garder une action primaire visible sur mobile, avec des cibles tactiles d’au moins 44 px.
- Présenter la fraîcheur, la source et les états bloquants près de la donnée concernée.
- Aucun dégradé, glassmorphism, animation décorative ou emoji utilisé comme icône.

## Accessibilité et responsive

- Contraste courant visé à 4,5:1 minimum.
- `:focus-visible` doit rester visible au clavier.
- `prefers-reduced-motion` désactive les animations et transitions non essentielles.
- Vérifier les largeurs 375, 768, 1024 et 1440 px ; les colonnes du Kanban défilent sur petit écran.
