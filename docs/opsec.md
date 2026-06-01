# 🛡️ OPSEC — Operational Security Guidelines  
**REDTeam / Unité CYBER**

> *“Security is not a feature. It is a discipline.”*

Ce document définit les règles d’OpSec obligatoires pour toute activité menée dans le cadre du projet **REDTeam**.  
Il vise à réduire les risques d’exposition, de compromission, de fuite d’information ou d’attribution.

---

## 🎯 Objectifs OpSec
- Protéger l’identité des opérateurs.
- Prévenir toute fuite d’information sensible.
- Garantir la non‑attribution des opérations.
- Maintenir un environnement d’exécution isolé, contrôlé et traçable.
- Assurer la conformité légale et éthique.

---

## 🔐 1. Hygiène OpSec personnelle
- Utiliser **des identités opérationnelles distinctes** (emails, comptes, alias).
- Ne jamais mélanger **environnements personnels et opérationnels**.
- Ne jamais utiliser un compte personnel pour :
  - GitHub
  - VPN
  - Cloud
  - Messagerie
- Utiliser un **navigateur dédié** (Firefox ESR hardened / Tor Browser selon contexte).
- Désactiver toute synchronisation automatique.

---

## 🧪 2. Environnement technique
- Utiliser des machines virtuelles **éphémères** (Kali, Parrot, Windows LTSC).
- Utiliser un hyperviseur local (VMware, VirtualBox, QEMU) ou un lab isolé.
- Interdiction d’utiliser l’environnement hôte pour :
  - scanner
  - exécuter du code offensif
  - stocker des données sensibles
- Chiffrement obligatoire :
  - LUKS / VeraCrypt / BitLocker
  - Chiffrement des snapshots
  - Chiffrement des exports

---

## 🌐 3. Réseau & anonymisation
- Utilisation obligatoire d’un **VPN multi‑hop** ou d’un **proxy chainé**.
- Interdiction d’utiliser une IP personnelle.
- Rotation régulière des sorties réseau.
- Utilisation de **DNS sécurisés** (DoH/DoT).
- Isolation réseau stricte :
  - VLAN
  - Sandbox
  - Firewall local restrictif

---

## 📁 4. Gestion des données
- Stockage uniquement dans des répertoires chiffrés.
- Suppression sécurisée (shred, srm).
- Interdiction de stocker :
  - credentials réels
  - données personnelles
  - informations non anonymisées
- Utilisation de **données factices** dans les rapports.

---

## 🧭 5. GitHub & OpSec
- Ne jamais pousser :
  - logs réels
  - IP réelles
  - captures d’écran sensibles
  - outputs d’outils offensifs
- Utiliser `.gitignore` pour :
  - dumps
  - captures
  - outputs
  - environnements virtuels
- Vérification OpSec obligatoire avant chaque PR.

---

## ⚠️ 6. Règles de non‑attribution
- Pas de signature personnelle dans les scripts.
- Pas de métadonnées dans les documents.
- Pas d’horodatage révélateur.
- Pas de commentaires internes compromettants.

---

## 📝 7. Checklist OpSec (rapide)
| Élément | Statut |
|--------|--------|
| Identité opérationnelle isolée | ☐ |
| VM éphémère chiffrée | ☐ |
| VPN multi‑hop actif | ☐ |
| Aucun artefact sensible dans Git | ☐ |
| Logs purgés | ☐ |
| Métadonnées nettoyées | ☐ |

---

## 🔚 Conclusion
L’OpSec n’est pas une option : c’est une **discipline quotidienne**.  
Toute violation entraîne un **arrêt immédiat des opérations** et une revue complète.
