# Azure Virtual Machine with Keycloak and Postgres Setup

## Project Requirements
### Objective
Create a virtual machine (VM) in Azure with a minimal container environment, and deploy:
- A **Keycloak container**.
- An **attached Postgres database**.
- A **web server** with a static web page controlled by Keycloak.

### Implementation Guidelines
- The project is to be implemented on **GitHub**:
  - Use **Git workflow**.
  - Include minimal but meaningful **documentation** (with architecture).

- **Infrastructure**:
  - Use **Terraform** for creating all infrastructure components.
  - Necessary managed identities/service principals are **not part of the task**.

### Justifications
- **Choice of Components**:
  - Why were these components chosen?
  - Why were other components not used?
- **Choice of Images**:
  - Justify the container images used.
- **Network Configuration**:
  - Explain the network setup.

### Configuration
- Use **Ansible** for configuring infrastructure wherever possible.
- Justify the choice of the **container environment**.

### Automation with GitHub Actions
- Create GitHub Actions workflows for:
  - Rolling out the project.
  - Configuring the project.
  - Disassembling the project.

### Extensions
- Propose possible features to extend the project and describe the benefits of the features added.

---

## How to Use This Project
1. Clone the repository from GitHub.
2. Follow the documentation to deploy the infrastructure and services.
3. Use GitHub Actions to automate the deployment, configuration, and teardown.

---

## Documentation and Architecture
Include a simple architecture diagram here (e.g., using a tool like **Lucidchart**, **Diagrams.net**, or **Markdown Mermaid**).

---

## Features for Future Extensions
1. **Monitoring and Logging**:
   - Add Prometheus and Grafana for monitoring.
   - Benefits: Improved observability and performance tracking.
2. **Scalability**:
   - Integrate Kubernetes to handle scaling for Keycloak and Postgres.
   - Benefits: Easier scaling for high traffic loads.
3. **High Availability**:
   - Use Azure Load Balancer or Traffic Manager.
   - Benefits: Improved reliability and fault tolerance.
