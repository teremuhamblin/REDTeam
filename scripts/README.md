###### README.md >> markdown
```text
>> REDTeam/ scripts/ README.md
```
# 🟥🔥 Scripts
- REDTeam Framework

Ce dossier contient l’ensemble des scripts opérationnels, utilitaires et d’automatisation du projet REDTeam.  
Ils constituent la couche “orchestrateur” du framework : installation d’outils, gestion du lab, génération de rapports, OpSec, CLI centralisé, etc.

Chaque script est conçu pour être :
- modulaire
- compatible multi‑OS (Debian/Ubuntu/Kali/Arch/Fedora)
- sécurisé (OpSec-first)
- intégré avec tools.json et rtops/
- utilisable en standalone ou via redteamctl

---

📁 Structure du dossier

`
scripts/
├── redteamctl.sh          # CLI officiel du framework
├── infralabsetup.sh       # Setup du lab d'entraînement
├── tools.sh               # Installateur d’outils (legacy)
├── tools-sync.sh          # Synchronisation / parsing tools.json
├── generate_reports.sh    # Génération automatisée de rapports
├── opsec_checklist.sh     # Checklist OpSec interactive
├── template.sh            # Template standard pour nouveaux scripts
└── README.md              # Ce fichier
`

---

🟥 1. redteamctl.sh — CLI officiel du projet

Le point d’entrée principal du framework REDTeam.

🎯 Rôle
- Centralise toutes les actions du framework
- Interface unique pour :
  - rtops (core Python)
  - installation d’outils
  - gestion du lab
  - génération de rapports
  - consultation de la documentation
  - scénarios de cyber‑range

🧩 Commandes principales

`
redteamctl rtops <module> <action>
redteamctl tools install <module|all>
redteamctl lab setup
redteamctl reports generate <id>
redteamctl docs opsec
redteamctl range list
`

⭐ Points forts
- Couleurs, UX moderne
- Auto‑détection OS
- Intégration totale avec tools.json
- Navigation fluide dans la doc et les scénarios

---

🟥 2. infralabsetup.sh — Setup du lab d’entraînement

Script responsable de la mise en place du cyber‑range local.

🎯 Rôle
- Préparer /opt/redteam-lab/
- Installer les dépendances système
- Créer le workdir (/tmp/redteam_workdir)
- Proposer un menu TUI (fzf) :
  - Reconnaissance
  - Initial Access
  - Lateral Movement
  - Persistence
  - Utilities
  - FULL LAB

⭐ Points forts
- Multi‑distro
- Logs propres
- Mode FULL LAB
- Intégration avec tools.json

---

🟥 3. tools.sh — Installateur d’outils (ancienne version)

🎯 Rôle
- Ancien installateur d’outils Red Team
- Toujours fonctionnel mais remplacé par :
  - redteam-tools-install.sh (via redteamctl tools install)
  - tools-sync.sh

⭐ Utilisation
`
bash tools.sh
`

📌 Note
Ce script reste présent pour compatibilité, mais la version moderne est gérée via tools.json.

---

🟥 4. tools-sync.sh — Synchronisation des outils

🎯 Rôle
- Lire et parser tools.json
- Lister les modules disponibles
- Vérifier la cohérence du fichier
- Utilisé par :
  - redteamctl tools
  - rtops/utils/tools_loader.py

⭐ Utilisation
`
bash tools-sync.sh
`

---

🟥 5. generate_reports.sh — Génération automatisée de rapports

🎯 Rôle
- Générer un set complet de rapports pour un engagement :
  - Executive Summary
  - Technical Report
  - Findings
- Utilise les templates dans reports/templates/
- Intégration avec redteamctl reports generate

⭐ Utilisation
`
redteamctl reports generate engagement-001
`

---

🟥 6. opsec_checklist.sh — Checklist OpSec interactive

🎯 Rôle
- Vérifier les prérequis OpSec avant un engagement
- Checklist interactive :
  - anonymisation
  - environnement isolé
  - logs désactivés
  - VPN/Tor
  - segmentation
  - règles d’engagement

⭐ Utilisation
`
bash opsec_checklist.sh
`

---

🟥 7. template.sh — Template standard pour nouveaux scripts

🎯 Rôle
- Fournir un squelette propre pour créer de nouveaux scripts
- Inclut :
  - couleurs
  - logs
  - gestion d’erreurs
  - structure modulaire
  - header REDTeam

⭐ Utilisation
`
cp template.sh nouveau_script.sh
`

---

🟥 8. Intégration globale dans le framework

Tous les scripts sont conçus pour fonctionner ensemble :

| Script | Fonction |
|--------|----------|
| redteamctl.sh | Interface centrale |
| infralabsetup.sh | Préparation du lab |
| tools-sync.sh | Gestion de tools.json |
| tools.sh | Installateur legacy |
| generate_reports.sh | Génération de rapports |
| opsec_checklist.sh | Sécurité & conformité |
| template.sh | Création de nouveaux scripts |

---

🟦 Recommandations d’utilisation

- Toujours passer par redteamctl pour une expérience optimale  
- Ne jamais exécuter les scripts en environnement non isolé  
- Lire docs/opsec.md avant toute utilisation  
- Mettre à jour régulièrement tools.json  
- Utiliser make si un Makefile est ajouté (optionnel)

---

🟩 Conclusion

Le dossier scripts/ constitue la colonne vertébrale opérationnelle du framework REDTeam.  
Il permet d’automatiser, orchestrer et sécuriser toutes les actions du projet, du lab aux outils, en passant par les rapports et la documentation.
