# Compatibilité : documentation versus preuve locale

Documentation consultée le **19 septembre 2026**. Aucun accès au VPS ou aux comptes n'a été testé lors de cette initialisation. Une fonctionnalité documentée n'implique pas sa disponibilité avec le modèle, la version ou l'abonnement de l'opérateur.

| Brique | Base documentaire | À vérifier localement |
| --- | --- | --- |
| Herdr | Workspaces/panes, supervision et primitives d'automatisation. | Version, IDs renvoyés, SSH, persistance et comportements d'interruption. |
| Codex CLI | Connexion ChatGPT ou clé API ; exécution `exec` et événements JSON. | Modèles autorisés, quotas, sandbox, auth headless et comportement des checks. |
| Cursor CLI | Auth par compte ou clé Cursor ; mode print et sorties structurées. | Binaire installé, modèles dont Grok si disponible, écriture effective et limites du compte. |
| Pi | Harness extensible avec modes interactif, print/JSON, RPC et SDK. | Provider, modèle, droits, auth autorisée et compatibilité des extensions. |

## Points à ne pas supposer

Codex distingue accès par abonnement et facturation API. Sa documentation recommande la clé API comme défaut pour l'automatisation, et traite la réutilisation d'auth personnelle sur runners comme un scénario avancé de confiance, pas un exemple à déployer sur les workflows de ce dépôt public. Le choix V0 vise un usage personnel supervisé sur VPS ; toute évolution en service automatisé doit être requalifiée.

La documentation Cursor consultée utilise `agent`. Le mode print sans option d'écriture peut seulement proposer des changements. Vérifier permissions et comportement réel avant de retenir une commande. Une clé Cursor n'est pas une clé directe pour xAI ou un autre fournisseur.

Pi possède ses propres intégrations de providers : ni Cursor ni un abonnement ChatGPT ne doivent être convertis par hypothèse en API générique. Vérifier les méthodes officiellement documentées avant d'activer un chemin.

## Sources primaires

- [Herdr : automatisation](https://herdr.dev/docs/agent-automation/)
- [Herdr : travail distant](https://herdr.dev/docs/how-to-work/)
- [Codex : authentification](https://developers.openai.com/codex/auth)
- [Codex : non-interactif](https://developers.openai.com/codex/noninteractive)
- [Cursor : authentification](https://cursor.com/docs/cli/reference/authentication)
- [Cursor : headless](https://cursor.com/docs/cli/headless)
- [Pi : présentation](https://pi.dev/)
- [Pi : démarrage](https://pi.dev/docs/latest/quickstart)

L'issue #2 doit compléter cette page avec versions, date des essais et statut `vérifié / bloqué / non testé`, sans détails de compte sensibles.
