🛡️ 2. SECURITY.md

`markdown

🔐 Politique de sécurité — REDTeam

La sécurité du projet est une priorité.  
Merci de contribuer à maintenir un environnement sûr et responsable.

---

🐛 Signaler une vulnérabilité

Si tu identifies une faille :

1. Ne crée pas d’issue publique.
2. Contacte directement les mainteneurs :
   - Email : à définir
3. Fournis :
   - Description détaillée
   - Étapes de reproduction
   - Impact potentiel
   - Correctif proposé (si possible)

---

🧪 Analyse interne

Les mainteneurs s’engagent à :

- Accuser réception sous 48h
- Analyser sous 7 jours
- Proposer un correctif selon la sévérité

---

🚫 Ce qui ne doit jamais être soumis

- Exploits réels non contrôlés
- Données personnelles
- Payloads dangereux non isolés
- Informations opérationnelles sensibles

---

🛠️ Bonnes pratiques

- Utiliser .env pour les secrets (jamais commit)
- Vérifier les dépendances :
  `
  pip-audit
  `
- Respecter les règles d’OpSec du dossier docs/opsec.md
`

---
