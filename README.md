# 🚀 GitHub Actions Helper Scripts

![Pipeline Banner](https://raw.githubusercontent.com/bygregonline/actions_utils/refs/heads/main/header.png)

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
| **`find_secrets.sh`** | Runs **Gitleaks** via Docker to detect hardcoded secrets. Enhanced version with better reporting and artifact generation. | `MAX_GITHUB_LEVELS` (Log verbosity) |
| **`run_gitleaks.sh`** | Legacy Gitleaks runner (use `find_secrets.sh` instead). | `MAX_GITHUB_LEVELS` (Log verbosity) |
| **`run_mypy.sh`** | Runs **MyPy** for static type checking. Parses the output into a Markdown table for the summary. | `$1`: Target path (default: `python`) |
| **`run_trivy.sh`** | Runs **Trivy** container image scanning with comprehensive reporting (JSON, HTML, Markdown). | `AMAZON_LINUX_TAR`, `AMAZON_LINUX_CONTAINER` |
| **`build_grype_syft_report.sh`** | Generates SBOM using **Syft** and scans with **Grype**. Creates SARIF, JSON, and Markdown reports. | N/A |
| **`trivy-to-md.sh`** | Converts **Trivy** JSON/SARIF results to Markdown, highlighting **High** and **Critical** vulnerabilities. | `$1`: Input file, `$2`: Output MD, `$3`: Image Title |
| **`trivy-to-md-full.sh`** | Similar to above, but generates a full report of all vulnerabilities found. | Same as above |

### 📊 Testing & Coverage

| Script | Description | Key Variables |
| :--- | :--- | :--- |
| **`run_coverage.sh`** | Sets up a Python environment (using `uv`), runs `pytest` with coverage, and generates badges/reports. Checks if coverage meets a minimum threshold. | `MIN_COVERAGE` (default: 80) |

### 🐳 Container & Infrastructure

| Script | Description |
| :--- | :--- |
| **`show_containers.sh`** | Builds Docker containers and displays them in a formatted table. Calls `docker_ls.sh` internally. |
| **`docker_ls.sh`** | Lists currently available Docker images in a Markdown table format. |

### 📝 Reporting & Utilities

| Script | Description |
| :--- | :--- |
| **`build_headers.sh`** | Generates a standardized header for the Step Summary containing the start time, triggering user, and working directory. |
| **`display_elapsed.sh`** | Calculates execution time, disk usage, and memory usage, appending it to the summary. |
| **`display_message.sh`** | Appends a generic "Success" or "Stop Pipeline" message based on the input argument (`0` for success). |
| **`display_strategy_overview.sh`** | Displays a comprehensive table explaining the security scanning strategy and tool roles. |
| **`consolidate_summary.sh`** | Aggregates multiple step summary files into a single Markdown file (useful for artifact upload). |
| **`upload_to_bucket.sh`** | Creates a timestamped ZIP artifact with all reports and uploads metadata to S3. Requires repo, stage, and bucket parameters. |
| **`stop.sh`** | Writes a "Process Stopped" message to the summary and forces an exit code `1` to fail the pipeline. |
| **`whoami_summary.sh`** | Debugging tool that lists files in the current directory and `src/` to the summary. |
| **`chmod_all.sh`** | Makes all scripts in the directory executable. |

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

      - name: Security Strategy Overview
        run: ./scripts/display_strategy_overview.sh

      - name: Build Containers
        run: ./scripts/show_containers.sh

      - name: Run Secret Detection
        run: ./scripts/find_secrets.sh
        env:
          MAX_GITHUB_LEVELS: -100

      - name: Run Container Scan
        run: ./scripts/run_trivy.sh
        env:
          AMAZON_LINUX_CONTAINER: "amazonlinux:latest"
          AMAZON_LINUX_TAR: "amazon-linux.tar"

      - name: Run SBOM Analysis
        run: ./scripts/build_grype_syft_report.sh

      - name: Run Python SAST
        run: ./scripts/run_bandit.sh python/src

      - name: Run Type Checking
        run: ./scripts/run_mypy.sh python/src

      - name: Run Tests & Coverage
        run: ./scripts/run_coverage.sh
        env:
          MIN_COVERAGE: 85

      - name: Upload Artifacts
        run: ./scripts/upload_to_bucket.sh myrepo dev my-security-bucket
```

## 🖼️ Output Examples

These scripts are designed to populate the **Job Summary** page in GitHub Actions:

### Bandit Report
> | File | Line | Test ID | Severity | Issue |
> |------|------|---------|----------|-------|
> | `main.py` | `12` | B101 | LOW | Use of assert detected |

### Coverage
> ##### Coverage: 🟩 92% covered, 🟥 8% uncovered

### 🛡️ Vulnerability Reports

#### Trivy Container Scan
> | Package | Vulnerability | Severity | Installed | Fixed |
> |---------|---------------|----------|-----------|-------|
> | `openssl` | `CVE-2022-0778` | **CRITICAL** | `1.1.1n` | `1.1.1o` |
> | `curl` | `CVE-2022-27776` | **HIGH** | `7.81.0` | `7.83.0` |

#### SBOM Analysis (Syft + Grype)
> | Package | Version | Severity | ID | Title |
> |:---|:---|:---|:---|:---|
> | `requests` | `2.25.1` | 🔴 CRITICAL | CVE-2023-32681 | Proxy-Authorization header leak |
> | `pillow` | `8.3.2` | 🟠 HIGH | CVE-2022-22817 | Buffer overflow |

### ⏱️ Execution Summary (Elapsed Time)
> | Metric | Value |
> | :--- | :--- |
> | **Start Time** | `2023-10-27 10:00:00 UTC` |
> | **End Time** | `2023-10-27 10:05:23 UTC` |
> | **Duration** | `5m 23s` |
> | **Disk Usage** | `14 GB / 30 GB (46%)` |
> | **Memory** | `2.1 GB / 7 GB` |

### ☁️ Artifact Upload Summary
> | Field | Value |
> | :--- | :--- |
> | **Artifact name** | `security-artifacts-myrepo-20231027-100523-12345-abc1234.zip` |
> | **AWS S3 Path** | `/myrepo/dev/20231027/security-artifacts-myrepo-20231027-100523-12345-abc1234.zip` |
> | **Size** | `2.3M` |
> | **Policy** | High / Critical block production |

---

## 🤝 Contributing

1.  Fork the repository.
2.  Create a feature branch.
3.  Submit a Pull Request.