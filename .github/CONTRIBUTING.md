🧩 1. CONTRIBUTING.md

`markdown

🤝 Contribuer au projet REDTeam

Merci de ton intérêt pour contribuer au framework REDTeam.  
Ce projet suit des standards stricts d’OpSec, de qualité et de traçabilité.

---

📌 Principes généraux

- Aucune donnée sensible, clé API, token ou information opérationnelle réelle.
- Les contributions doivent respecter les règles d’engagement (RoE) du dossier docs/.
- Le code doit être reproductible, documenté et testé.
- Toute fonctionnalité offensive doit être justifiée et cloisonnée.

---

🔀 Workflow Git

1. Fork du dépôt  
2. Créer une branche dédiée :
   `
   git checkout -b feature/ma-fonction
   `
3. Commits clairs et normalisés :
   - feat: nouvelle fonctionnalité
   - fix: correction
   - docs: documentation
   - test: ajout/MAJ de tests
4. Pousser la branche :
   `
   git push origin feature/ma-fonction
   `
5. Ouvrir une Pull Request via le template fourni.

---

🧪 Tests

Avant toute PR :

- Lancer la suite de tests :
  `
  pytest -q
  `
- Vérifier la qualité du code :
  `
  ruff check .
  `
- Vérifier la sécurité :
  `
  bandit -r rtops/
  `

---

📄 Documentation

Toute nouvelle fonctionnalité doit inclure :

- un README ou une section dans docs/
- des exemples d’usage
- une description technique claire

---

🔐 OpSec

- Pas de noms de cibles réelles.
- Pas de reproduction d’attaques réelles hors lab.
- Pas de diffusion de payloads dangereux non contrôlés.

---

📬 Contact

Pour toute question, ouvre une discussion dans :

👉 https://github.com/Teremu/REDTeam/discussions
`

---
