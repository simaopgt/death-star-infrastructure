# Death Star Infrastructure

![GitHub last commit](https://img.shields.io/github/last-commit/simaopgt/death-star-infrastructure?style=for-the-badge)
![Repo size](https://img.shields.io/github/repo-size/simaopgt/death-star-infrastructure?style=for-the-badge)
![License](https://img.shields.io/github/license/simaopgt/death-star-infrastructure?style=for-the-badge)

This repository contains the standardized development environment (Dev Container) and all Infrastructure as Code (IaC) for the "Death Star" project. The infrastructure is managed using Terraform and provisions resources on the Google Cloud Platform (GCP).

## 🚀 Overview

The primary goal of this component is to define and manage the entire cloud infrastructure required to run the Death Star application stack. It also provides a fully configured, portable, and reproducible development environment to ensure consistency for all developers across any operating system.

The environment comes pre-installed with all necessary tooling, including:
* Terraform
* Google Cloud CLI (`gcloud`)
* GitHub CLI (`gh`)
* TFLint for code quality

## 📋 Prerequisites

Before you begin, ensure you have the following installed on your local machine:

1.  **Docker Desktop:** The engine used to run the Dev Container.
2.  **Cursor (or VS Code):** An IDE that supports Dev Containers.
3.  **Dev Containers Extension:** The official Microsoft extension (`ms-vscode-remote.remote-containers`) must be installed in your IDE.

## 🛠️ How to Use

### 1. Launching the Environment

To get the development environment up and running, follow these steps:

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/simaopgt/death-star-infrastructure.git](https://github.com/simaopgt/death-star-infrastructure.git)
    cd death-star-infrastructure
    ```
2.  **Open in IDE:** Open the `death-star-infrastructure` folder in Cursor or VS Code.
3.  **Launch the Dev Container:** Open the Command Palette (`Cmd + Shift + P` or `Ctrl + Shift + P`) and run `Dev Containers: Rebuild and Reopen in Container`.

The IDE will build the Docker image and launch the environment. Once complete, your terminal will be connected to the container.

### 2. Basic Terraform Workflow

Once inside the Dev Container, you can manage the infrastructure with standard Terraform commands:

* **Initialize Terraform:** (Run this first)
    ```bash
    terraform init
    ```
* **Check for changes:**
    ```bash
    terraform plan
    ```
* **Apply changes:**
    ```bash
    terraform apply
    ```

## 🗺️ Roadmap

The high-level roadmap for the infrastructure is tracked through the project's milestones in GitHub Projects.
* [X] **M0: Foundation & Setup** (Current)
* [ ] **M1-M5:** Provisioning of core application services (Cloud Run, Cloud SQL, etc.).

See the [GitHub Project board](<https://github.com/users/simaopgt/projects/3>) for more details.

## 🏛️ Architectural Decisions

* **Custom Dockerfile over "Features"**: We use a custom `Dockerfile` to define the environment's tooling. This approach was chosen over the standard "Features" system to ensure maximum build reliability and portability.
* **Infrastructure as Code (IaC)**: All infrastructure is managed declaratively using Terraform to ensure it is versioned, repeatable, and automated.
* **Code Quality**: TFLint is included in the environment to enforce Terraform best practices and catch potential errors before deployment.

##🤝 Contributing

As this is a solo portfolio project, direct contributions are not expected. However, suggestions and issue reports are welcome. Please feel free to open an issue for any bugs or ideas.

## 📄 License

This project is distributed under the MIT License. See `LICENSE` for more information.
