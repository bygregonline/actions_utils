#!/bin/bash

touch .pipeline_start_marker

START_TIME=$(date +"%Y-%m-%d %H:%M:%S")
TRIGGER_USER=${GITHUB_TRIGGERING_ACTOR:-${GITHUB_ACTOR:-unknown}}
OS_USER=$(whoami)

{
  echo "#### 🛡️ CI/CD Security & Compliance Overview"
  echo " "
echo "![SLSA](https://img.shields.io/badge/SLSA-aligned-green) \
![NIST](https://img.shields.io/badge/NIST-SSDF%20%7C%20800--53-green) \
![ISO](https://img.shields.io/badge/ISO-27001%20aligned-green) \
![EO14028](https://img.shields.io/badge/EO-14028-green) \
![OWASP](https://img.shields.io/badge/OWASP-Top%2010%20%7C%20ASVS-green) \
![CIS](https://img.shields.io/badge/CIS-Controls%20v8-green) \
![OpenSSF](https://img.shields.io/badge/OpenSSF-Best%20Practices-green) \
![SOC2](https://img.shields.io/badge/SOC%202-Technical%20Controls-green) \
![PCI](https://img.shields.io/badge/PCI--DSS-v4.0-green) \
![HIPAA](https://img.shields.io/badge/HIPAA-Technical%20Safeguards-green) \
![FedRAMP](https://img.shields.io/badge/FedRAMP-Technical%20Alignment-green) \
![EU%20CRA](https://img.shields.io/badge/EU-CRA%20Ready-green)"

  echo " "
  echo "#### 🔐 Security & Compliance Alignment"
  echo " "
  echo "This CI/CD pipeline provides **continuous security assurance** and is aligned with"
  echo "**industry-recognized security and compliance frameworks**, including:"
  echo " "
  echo "- **SLSA (Supply-chain Levels for Software Artifacts)**"
  echo "- **NIST Secure Software Development Framework (SSDF – SP 800-218)**"
  echo "- **NIST SP 800-53 (selected technical controls)**"
  echo "- **ISO/IEC 27001 (Secure SDLC & Vulnerability Management alignment)**"
  echo "- **U.S. Executive Order 14028 (Software Supply Chain Security)**"
  echo "- **OWASP Top 10 & OWASP ASVS (automated verification coverage)**"
  echo "- **CIS Critical Security Controls v8**"
  echo "- **OpenSSF Best Practices**"
  echo "- **SOC 2 (Security & Confidentiality – technical controls support)**"
  echo "- **PCI-DSS v4.0 (Secure SDLC & vulnerability scanning support)**"
  echo "- **HIPAA Security Rule (technical safeguards – partial)**"
  echo "- **FedRAMP / FISMA (technical control alignment – partial)**"
  echo "- **EU Cyber Resilience Act (CRA – supply chain readiness)**"
  echo " "
  echo "> ⚠️ *Alignment indicates technical support and evidence generation."
  echo "> This does not imply formal certification or regulatory approval.*"

  echo " "
  echo "---"
  echo " "
  echo "### 🧾 Consolidated Steps Report"
  echo "##### 🔍 Execution Context"
  echo " "
  echo '```'
  echo "⏰ Starting at: $START_TIME"
  echo "🏎️💨 Triggered by: $TRIGGER_USER"
  echo "👤 User: $OS_USER"
  echo "📁 Working directory: $(pwd)"
  echo '```'
  echo " "
} >> "$GITHUB_STEP_SUMMARY"