# 🚀 Cloud-Native Homelab (DevOps Expert Path)

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)
![ArgoCD](https://img.shields.io/badge/argocd-%23eb5b34.svg?style=for-the-badge&logo=argocd&logoColor=white)
![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)

Un laboratoire d'infrastructure complet, entièrement automatisé ("Infrastructure as Code"), simulant un environnement de production d'entreprise sur une architecture locale (Apple Silicon / ARM64).

## 🏗️ Architecture & Technologies

Ce projet est construit sur une approche **GitOps** et **Cloud-Native**.

| Couche                | Technologie                | Rôle                                                                  | Statut        |
| :-------------------- | :------------------------- | :-------------------------------------------------------------------- | :------------ |
| **Virtualisation**    | **Multipass**              | Création de VMs Ubuntu légères sur macOS (M1).                        | ✅ Validé     |
| **Provisioning**      | **Terraform**              | Déploiement IaC des machines virtuelles (CPU, RAM, Disque).           | ✅ Validé     |
| **Configuration**     | **Ansible**                | Installation automatisée du cluster et des outils.                    | ✅ Validé     |
| **Orchestration**     | **K3s**                    | Distribution Kubernetes légère certifiée CNCF.                        | ✅ Validé     |
| **Stockage**          | **Longhorn**               | Stockage distribué persistant (Block Storage) et haute disponibilité. | ✅ Validé     |
| **Réseau**            | **MetalLB**                | Load Balancer Bare-Metal (IPs dédiées pour les services).             | ✅ Validé     |
| **Ingress**           | **Traefik + Cert-Manager** | Reverse Proxy et gestion automatique des certificats TLS/HTTPS.       | ✅ Validé     |
| **GitOps**            | **ArgoCD**                 | Déploiement continu des applications (CD).                            | ✅ Validé     |
| **Monitoring**        | **Prometheus & Grafana**   | Métriques, Alerting et Tableaux de bord en temps réel.                | ✅ Validé     |
| **Object Storage**    | **MinIO**                  | Stockage S3 compatible auto-hébergé.                                  | ✅ Validé     |
| **Disaster Recovery** | **Velero**                 | Sauvegarde et restauration complète du cluster vers S3.               | ✅ Validé     |
| **Logs**              | **Loki**                   | Agrégation centralisée des logs (Stack PLG).                          | 🚧 _En cours_ |
| **Secrets**           | **Sealed Secrets**         | Gestion sécurisée des secrets chiffrés dans Git.                      | 🗓️ _Prévu_    |
| **CI/CD**             | **GitHub Actions**         | Pipelines d'intégration continue.                                     | 🗓️ _Prévu_    |

## 🛠️ Installation Rapide

### Prérequis

- macOS (Apple Silicon recommandé) ou Linux.
- `brew`, `terraform`, `ansible`, `multipass`, `kubectl`.

### Déploiement (From Scratch)

1.  **Infrastructure (Terraform) :**

    ```bash
    cd infrastructure
    terraform init && terraform apply -auto-approve
    ```

2.  **Configuration (Ansible) :**
    _Mettre à jour `inventory.ini` avec les IPs générées._

    ```bash
    cd configuration
    # Déploiement en chaîne
    ansible-playbook playbooks/install_k3s.yml
    ansible-playbook playbooks/deploy_storage.yml    # Longhorn
    ansible-playbook playbooks/deploy_metallb.yml    # Réseau
    ansible-playbook playbooks/deploy_monitoring.yml # Stack Obs
    ansible-playbook playbooks/deploy_argocd.yml     # GitOps
    ```

3.  **Accès aux Services :**
    - **Jellyfin :** `https://jellyfin.lab`
    - **Grafana :** `https://grafana.lab`
    - **ArgoCD :** `https://argocd.lab`
    - **MinIO :** `https://minio.lab`
    - **Longhorn :** `http://longhorn.lab`

## 🧪 Scénarios de Test (Validés)

- [x] **Persistance des données :** Destruction d'un Pod Jellyfin -> Les données utilisateur sont conservées (Longhorn PVC).
- [x] **GitOps Self-Healing :** Modification manuelle d'un déploiement -> ArgoCD détecte la dérive (OutOfSync) et corrige automatiquement.
- [x] **Disaster Recovery :** Suppression totale d'un Namespace critique -> Restauration complète via Velero/MinIO en < 2min.
- [x] **Architecture Multi-Arch :** Adaptation des images Docker (Bitnami/Nginx) pour compatibilité ARM64.

---

_Projet maintenu par [maxez77]._
