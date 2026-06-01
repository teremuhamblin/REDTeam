###### ARCHITECTURE.md >> markdown 
# 🏗️ Structure
- Schémas
```text
REDTeam/
├── .github/
│   ├── .gitkeep
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yml
│   │   └── feature_request.yml
│   ├── PULLREQUESTTEMPLATE/
│   │   └── pull_request.yml
│   └── workflows/
│       ├── ci.yml
│       └── security-scan.yml
│
├── docs/
│   ├── .gitkeep
│   ├── README.md
│   ├── tool.md
│   ├── information.md
│   ├── architecture.md
│   ├── glossary.md
│   ├── opsec.md
│   ├── rules-of-engagement.md
│   └── methodology.md
│
├── rtops/   (# Core Python package)
│   ├── .gitkeep
│   ├── README.md 
│   ├── init.py
│   ├── cli.py
│   ├── recon/
│   │   ├── init.py
│   │   ├── passive_recon.py
│   │   └── active_recon.py
│   ├── initial_access/
│   │   ├── init.py
│   │   └── phishing_sim.py
│   ├── lateral_movement/
│   │   ├── init.py
│   │   └── smb_enum.py
│   ├── persistence/
│   │   ├── init.py
│   │   └── basic_persistence.py
│   └── utils/
│       ├── init.py
│       ├── logging_utils.py
│       └── config_loader.py
│
├── scripts/
│   ├── .gitkeep
│   ├── README.md 
│   ├── opsec_checklist.sh
│   ├── infralabsetup.sh
│   ├── generate_reports.sh
│   └── template.sh
│
├── reports/
│   ├── .gitkeep
│   ├── templates/
│   │   ├── executive_summary.md
│   │   ├── technical_report.md
│   │   └── findings_template.md
│   └── README.md
│
├── tests/
│   ├── .gitkeep
│   ├── test_recon.py
│   ├── test_utils.py
│   └── README.md
├── .gitkeep
├── CHANGELOG.md 
├── ROADMAP.md 
├── .env.example
├── .gitignore
├── LICENSE
├── Makefile
├── pyproject.toml
├── requirements.txt
├── requirements-dev.txt
└── README.md
```

### Architecture du projet REDTeam
>Résumé
```text
But :
>> - documenter la conception technique, les responsabilités des composants,
>> - les flux principaux et les exigences opérationnelles pour le dépôt REDTeam.
>> - audience : développeurs, ingénieurs sécurité, testeurs, responsables DevOps et relecteurs de code.
```

---

### Objectifs
```text
- Clarté : expliquer la structure du dépôt et le rôle de chaque module.
- Maintenabilité : fournir des règles et bonnes pratiques pour étendre le projet.
- Sécurité : lister les contrôles OpSec et les points sensibles.
- Déploiement : décrire les étapes de build, test et intégration continue.
```

---

> Vue d'ensemble de l'architecture
Le projet est organisé en couches logiques séparant l'infrastructure de support, le code applicatif, les scripts d'automatisation, la documentation et les artefacts de reporting.

```text
- Couche d'orchestration CI/CD : .github/workflows/ — pipelines d'intégration continue et scans de sécurité.
- Documentation : docs/ — guides, méthodologie, règles d'engagement et fiches OpSec.
- Package applicatif : rtops/ — coeur Python modulaire (recon, initialaccess, lateralmovement, persistence, utils).
- Scripts d'automatisation : scripts/ — tâches shell réutilisables pour setup et génération de rapports.
- Rapports : reports/ — templates et guides pour livrables.
- Tests : tests/ — suites unitaires et d'intégration.
```

---

### Composants et responsabilités
>Core Python Package
  - rtops/cli.py  
  Rôle : point d'entrée CLI ; orchestration des commandes utilisateur.
  - rtops/recon/  
  Rôle : modules de reconnaissance passive et active ; collecte et normalisation des données.
  - rtops/initial_access/  
  Rôle : simulations d'accès initial (ex : phishing_sim).
  - rtops/lateral_movement/  
  Rôle : outils d'énumération et de propagation (ex : smb_enum).
  - rtops/persistence/  
  Rôle : mécanismes de persistance et démonstrations contrôlées.
  - rtops/utils/  
  Rôle : utilitaires transverses (logging, chargement de config).

### Infrastructure et CI
  - .github/workflows/ci.yml  
  Rôle : linting, tests unitaires, packaging.
  - .github/workflows/security-scan.yml  
  Rôle : scans SAST/DAST, dépendances vulnérables.

### Scripts
>- scripts/infralabsetup.sh : provisionnement d'un environnement de laboratoire isolé.
>- scripts/opsec_checklist.sh : checklist OpSec automatisée avant exécution.
>- scripts/generate_reports.sh : génération automatisée des rapports à partir de templates.

### Documentation et rapports
>- docs/ : guides opérationnels, méthodologie et règles d'engagement.
>- reports/templates/ : modèles pour executivesummary, technicalreport, findings_template.

---

### Flux de données et scénarios d'utilisation
> - Scénario Recon Passive  
  1. rtops/cli.py déclenche recon.passive_recon.  
  2. Données collectées stockées temporairement dans un répertoire de travail chiffré.  
  3. Résultats normalisés envoyés au module de reporting pour génération de livrable.
> - Scénario Phishing Simulation  
  1. initialaccess/phishingsim.py génère campagne simulée.  
  2. Logs et métriques anonymisés exportés vers reports/templates/ pour analyse.
> - Scénario CI  
  1. Push déclenche ci.yml.  
  2. Exécution des tests tests/, linting, et scan de sécurité.  
  3. Artefacts (coverage, rapports SAST) archivés dans le pipeline.

---

### Sécurité Déploiement Tests
- Sécurité et OpSec
   - Isolation : tout test offensif doit s'exécuter dans un lab isolé; ne jamais pointer vers des cibles réelles sans autorisation écrite.  
   - Secrets : utiliser des variables d'environnement et gestionnaire de secrets; ne pas committer .env réels. .env.example sert de modèle.  
   - Logs : anonymiser les données sensibles avant stockage ou partage.  
   - Revue : tout changement dans rtops/ doit passer par PR et revue de sécurité.

### Déploiement
   - Environnements : local (dev), lab (test isolé), ci (intégration).  
   - Étapes recommandées : installer dépendances via requirements.txt, exécuter scripts/infralabsetup.sh, lancer tests pytest, puis pipeline CI.

### Tests et qualité
    - Unitaires : tests/test_*.py — couverture minimale recommandée 80% pour modules critiques.  
    - Intégration : scénarios end-to-end dans un lab isolé.  
    - Static Analysis : linters (flake8/ruff), formatters (black), et scanners de dépendances dans CI.

---

### Bonnes pratiques et contribution
  - Structure des modules : chaque sous-module doit exposer une API claire et des tests unitaires.  
  - Commits : messages clairs, liés à une issue si applicable.  
  - PR : inclure description, tests ajoutés, et checklist OpSec complétée.  
  - Versioning : suivre Semantic Versioning dans pyproject.toml.  
  - Licences : respecter la licence du dépôt (fichier LICENSE).

---

### Annexes
- Fichiers clés :  
  - pyproject.toml : configuration du package.  
  - Makefile : commandes récurrentes (test, lint, build).  
  - requirements-dev.txt : outils de développement.  
- Contacts : référencer l'équipe responsable et la procédure d'escalade dans docs/README.md.

---Voici architecture.md, version premium, complète, stylée, avec diagrammes ASCII, schémas d’architecture, explications détaillées, et une cohérence totale avec ton framework REDTeam.  
Le fichier est prêt à être collé dans docs/architecture.md.

---

### 🏗️ Architecture du Projet REDTeam
- Framework Cyber‑Offensif Modulaire — Unité CYBER
> “Structure drives capability. Capability drives dominance.”

Ce document décrit l’architecture complète du projet REDTeam, incluant :  
- la structure logicielle  
- les modules Python (rtops/)  
- les scripts opérationnels (scripts/)  
- les templates de rapports  
- les workflows CI/CD  
- les interactions internes  
- les diagrammes d’architecture

---

1. 📦 Vue d’ensemble du projet
```text
REDTeam/
├── rtops/               → Core Python package (TTPs, modules offensifs)
├── scripts/             → Automatisation, OpSec, lab, reporting
├── reports/             → Templates & génération de rapports
├── docs/                → Documentation technique & opérationnelle
├── tests/               → Tests unitaires & intégration
└── .github/             → Workflows CI/CD, templates PR/Issues
```

Cette architecture suit trois principes :  
- Modularité : chaque domaine offensif est isolé.  
- Traçabilité : tout est documenté, testé, versionné.  
- OpSec : aucune donnée sensible n’est stockée ou exposée.

---

### 2. 🧩 Architecture logique (diagramme global)
```text
                   ┌──────────────────────────┐
                   │        REDTeam CLI        │
                   │     (scripts + rtops)     │
                   └──────────────┬───────────┘
                                  │
                     ┌────────────┴────────────┐
                     │                         │
             ┌───────▼───────┐         ┌──────▼────────┐
             │   rtops/       │         │   scripts/     │
             │  Python Core   │         │ Bash Automation │
             └───────┬───────┘         └──────┬─────────┘
                     │                         │
     ┌───────────────┼─────────────────────────┼──────────────────────────┐
     │               │                         │                          │
┌────▼────┐    ┌─────▼────┐             ┌──────▼──────┐           ┌──────▼──────┐
│ Recon   │    │ Initial   │             │ Lab Setup    │           │ Reporting   │
│ Module  │    │ Access    │             │ Automation   │           │ Generator   │
└─────────┘    └───────────┘             └──────────────┘           └─────────────┘
```

---

### 3. 🐍 Architecture du package >Python rtops/
```text
rtops/
├── cli.py                 → Entrée CLI Python
├── utils/                 → Logging, config, helpers
├── recon/                 → Reconnaissance passive & active
├── initial_access/        → Phishing, exploitation simulée
├── lateral_movement/      → SMB, pivoting, enumeration
└── persistence/           → Techniques de persistance
```

### 3.1 Diagramme interne du package
```text
                   ┌──────────────────────────────┐
                   │            cli.py             │
                   │   (commande principale)       │
                   └───────────────┬──────────────┘
                                   │
                     ┌─────────────┼────────────────┐
                     │             │                │
             ┌───────▼──────┐ ┌────▼────────┐ ┌────▼────────┐
             │ recon/        │ │ initial     │ │ lateral     │
             │ passive/active│ │ access/      │ │ movement/    │
             └───────────────┘ └──────────────┘ └──────────────┘
                     │             │                │
                     └──────┬──────┴──────┬────────┘
                            │             │
                     ┌──────▼──────┐ ┌────▼────────┐
                     │ persistence/ │ │ utils/      │
                     └──────────────┘ └─────────────┘
```

### 3.2 Rôle des modules

| Module | Rôle |
|--------|------|
| recon/ | OSINT, scans, fingerprinting |
| initial_access/ | Phishing simulé, exploitation contrôlée |
| lateral_movement/ | SMB, pivoting, enumeration interne |
| persistence/ | Techniques low‑noise |
| utils/ | Logging, configuration, helpers |

---

### 4. 🛠️ Architecture des scripts
>(scripts/)
```text
scripts/
├── opsec_checklist.sh      → Vérification OpSec avant opération
├── infralabsetup.sh        → Déploiement d’un lab cyber isolé
├── generate_reports.sh      → Génération automatique de rapports
└── template.sh              → Template standardisé pour nouveaux scripts
```

### 4.1 Diagramme d’interaction
```text
┌──────────────────────┐
│  opsec_checklist.sh  │
│  (pré‑opération)      │
└───────────┬──────────┘
            │
┌───────────▼──────────┐
│  infralabsetup.sh     │
│  (environnement)       │
└───────────┬──────────┘
            │
┌───────────▼──────────┐
│ generate_reports.sh   │
│ (post‑opération)       │
└────────────────────────┘
```

---

### 5. 📄 Architecture des rapports
>(reports/)
```text
reports/
├── templates/
│   ├── executive_summary.md
│   ├── technical_report.md
│   └── findings_template.md
└── README.md
```

### 5.1 Pipeline de génération
```text
┌───────────────────────────────┐
│   Données opérationnelles      │
└───────────────┬───────────────┘
                │
       ┌────────▼────────┐
       │ generate_reports │
       │     .sh          │
       └────────┬────────┘
                │
       ┌────────▼────────┐
       │  Templates MD    │
       └────────┬────────┘
                │
       ┌────────▼────────┐
       │ Rapport final    │
       └──────────────────┘
```

---

### 6. 🧪 Architecture des tests
>(tests/)
```text
tests/
├── test_recon.py
├── test_utils.py
└── README.md
```

Les tests couvrent :  
- les modules Python (rtops/)  
- les fonctions critiques (utils/)  
- la cohérence des outputs  

---

### 7. 🔄 Architecture CI/CD
>(.github/workflows/)
```text
.github/workflows/
├── ci.yml              → Tests + linting + build
└── security-scan.yml   → Analyse SAST + dépendances
```

### 7.1 Diagramme CI/CD
```text
Push / PR
   │
   ├──► ci.yml
   │       ├── Lint
   │       ├── Tests
   │       └── Build
   │
   └──► security-scan.yml
           ├── SAST
           ├── Dependency Scan
           └── Secret Detection
```

---

### 8. 🧬 Architecture conceptuelle
>(vue cyber‑opérationnelle)
```text
┌──────────────────────────────────────────────────────────────┐
│                          REDTeam                              │
│                                                              │
│  Recon → Initial Access → Execution → LM → Persistence → EXF │
│                                                              │
│  (Modules Python)         (Scripts)         (Rapports)        │
└──────────────────────────────────────────────────────────────┘
```

---

### 9. 🧱 Principes d’architecture
### 9.1 Modularité
Chaque domaine offensif est isolé dans un module dédié.

### 9.2 Séparation des responsabilités
- Python = logique offensive  
- Bash = orchestration / automatisation  
- Markdown = documentation / reporting  

### 9.3 OpSec by design
- Pas de données sensibles  
- Pas d’artefacts persistants  
- Isolation stricte  

### 9.4 Scalabilité
L’architecture permet d’ajouter facilement :  
- de nouveaux modules Python  
- de nouveaux scripts  
- de nouveaux templates de rapports  

---

### 10. 🔚 Conclusion
L’architecture REDTeam est conçue pour être :  
- modulaire  
- sécurisée  
- scalable  
- professionnelle  
- alignée avec les standards Red Team modernes

Elle permet d’opérer, documenter, automatiser et tester l’ensemble du cycle offensif dans un cadre contrôlé, éthique et OpSec‑safe.

---
