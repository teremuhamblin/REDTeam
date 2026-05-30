###### ARCHITECTURE.md >> markdown 
# 🏗️ Structure du projet
```text
REDTeam/
│
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   ├── PULLREQUESTTEMPLATE/
│   │   └── pull_request.md
│   └── workflows/
│       ├── ci.yml
│       └── security-scan.yml
│
├── docs/
│   ├── README.md
│   ├── architecture.md
│   ├── glossary.md
│   ├── opsec.md
│   ├── rules-of-engagement.md
│   └── methodology.md
│
├── rtops/                  # Core Python package
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
│   ├── opsec_checklist.sh
│   ├── infralabsetup.sh
│   ├── generate_reports.sh
│   └── template.sh
│
├── reports/
│   ├── templates/
│   │   ├── executive_summary.md
│   │   ├── technical_report.md
│   │   └── findings_template.md
│   └── README.md
│
├── tests/
│   ├── test_recon.py
│   ├── test_utils.py
│   └── README.md
│
├── .env.example
├── .gitignore
├── LICENSE
├── Makefile
├── pyproject.toml
├── requirements.txt
├── requirements-dev.txt
└── README.md
```

---
