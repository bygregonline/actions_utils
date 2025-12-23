# 🚀 GitHub Actions Helper Scripts

![Pipeline Banner](https://via.placeholder.com/1200x300?text=GitHub+Actions+Security+%26+Quality+Pipeline)

![Bash](https://img.shields.io/badge/language-bash-black?logo=gnu-bash)
![GitHub Actions](https://img.shields.io/badge/CI-GitHub_Actions-blue?logo=github-actions)
![Security](https://img.shields.io/badge/Security-SAST_%26_SCA-red)
![License](https://img.shields.io/badge/license-MIT-green)

This repository contains a collection of **Bash scripts** designed to streamline GitHub Actions workflows. They automate the execution of security tools, code analysis, and testing, while generating rich, formatted reports directly into the **GitHub Step Summary** (`$GITHUB_STEP_SUMMARY`).

## 📋 Prerequisites

These scripts rely on standard CI tools. Ensure your runner (e.g., Ubuntu-latest) has the following installed:
*   `jq` (JSON processor - **Critical**)
*   `docker` (For Gitleaks, Grype, SonarQube)
*   `curl`
*   `python` / `uv` (For Python-related scripts)

## 🛠️ Setup

Before using the scripts in your pipeline, ensure they are executable. You can use the provided helper:

```bash
./scripts/chmod_all.sh
```

## 📂 Script Reference

### 🛡️ Security & Static Analysis

| Script | Description | Key Variables |
| :--- | :--- | :--- |
| **`install_security_tools.sh`** | Installs **Syft**, **Trivy**, and pulls Docker images for **Grype**, **Gitleaks**, and **SonarQube**. | N/A |
| **`run_bandit.sh`** | Runs **Bandit** (Python SAST) on a target directory. Generates HTML/JSON reports and appends a summary table to the GitHub UI. | `$1`: Target path (default: `python/fastapi`) |
| **`run_gitleaks.sh`** | Runs **Gitleaks** via Docker to detect hardcoded secrets. Converts the JSON report to Markdown. | `MAX_GITHUB_LEVELS` (Log verbosity) |
| **`run_mypy.sh`** | Runs **MyPy** for static type checking. Parses the output into a Markdown table for the summary. | `$1`: Target path (default: `python`) |
| **`trivy-to-md.sh`** | Converts **Trivy** JSON results to Markdown, highlighting **High** and **Critical** vulnerabilities with badges. | `$1`: Input JSON, `$2`: Output MD, `$3`: Image Title |
| **`trivy-to-md-full.sh`** | Similar to above, but generates a full report of all vulnerabilities found. | Same as above |

### 📊 Testing & Coverage

| Script | Description | Key Variables |
| :--- | :--- | :--- |
| **`run_coverage.sh`** | Sets up a Python environment (using `uv`), runs `pytest` with coverage, and generates badges/reports. Checks if coverage meets a minimum threshold. | `MIN_COVERAGE` (default: 80) |

### 📝 Reporting & Utilities

| Script | Description |
| :--- | :--- |
| **`build_headers.sh`** | Generates a standardized header for the Step Summary containing the start time, triggering user, and working directory. |
| **`display_elapsed.sh`** | Calculates execution time, disk usage, and memory usage, appending it to the summary. |
| **`display_message.sh`** | Appends a generic "Success" or "Stop Pipeline" message based on the input argument (`0` for success). |
| **`consolidate_summary.sh`** | Aggregates multiple step summary files into a single Markdown file (useful for artifact upload). |
| **`docker_ls.sh`** | Lists currently available Docker images in a Markdown table format. |
| **`stop.sh`** | Writes a "Process Stopped" message to the summary and forces an exit code `1` to fail the pipeline. |
| **`whoami_summary.sh`** | Debugging tool that lists files in the current directory and `src/` to the summary. |

### 🔄 Converters (Internal Helpers)

These are typically called by the main scripts above but can be used standalone:
*   `convert_bandit_to_md.sh`: JSON -> Markdown table for Bandit.
*   `convert_gitleaks_json_to_md.sh`: JSON -> Markdown table for Gitleaks.
*   `elapsed.sh`: Helper logic for time calculation.

---

## 💡 Usage Example in GitHub Actions

Here is how you might use these scripts in your `.github/workflows/pipeline.yml`:

```yaml
name: Security and Quality Pipeline

on: [push]

jobs:
  quality-gate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Make scripts executable
        run: chmod +x scripts/*.sh

      - name: Pipeline Header
        run: ./scripts/build_headers.sh

      - name: Install Tools
        run: ./scripts/install_security_tools.sh

      - name: Run Secret Detection
        run: ./scripts/run_gitleaks.sh

      - name: Run Python SAST
        run: ./scripts/run_bandit.sh python/src

      - name: Run Type Checking
        run: ./scripts/run_mypy.sh python/src

      - name: Run Tests & Coverage
        run: ./scripts/run_coverage.sh
        env:
          MIN_COVERAGE: 85
```

## 🖼️ Output Examples

These scripts are designed to populate the **Job Summary** page in GitHub Actions:

### Bandit Report
> | File | Line | Test ID | Severity | Issue |
> |------|------|---------|----------|-------|
> | `main.py` | `12` | B101 | LOW | Use of assert detected |

### Coverage
> ##### Coverage: 🟩 92% covered, 🟥 8% uncovered

### 🛡️ Vulnerability Report (Syft / Grype / Trivy)
> | Package | Version | Severity | ID | Title |
> |:---|:---|:---|:---|:---|
> | `openssl` | `1.1.1n` | 🔴 CRITICAL | CVE-2022-0778 | Infinite loop in BN_mod_sqrt() |
> | `curl` | `7.81.0` | 🟠 HIGH | CVE-2022-27776 | Credential leak |

### ⏱️ Execution Summary (Elapsed Time)
> | Metric | Value |
> | :--- | :--- |
> | **Start Time** | `2023-10-27 10:00:00 UTC` |
> | **End Time** | `2023-10-27 10:05:23 UTC` |
> | **Duration** | `5m 23s` |
> | **Disk Usage** | `14 GB / 30 GB (46%)` |
> | **Memory** | `2.1 GB / 7 GB` |

---

## 🤝 Contributing

1.  Fork the repository.
2.  Create a feature branch.
3.  Submit a Pull Request.