terraform {
  required_providers {
    multipass = {
      source  = "larstobi/multipass"
      version = "~> 1.4.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "multipass" {}

# 1. On lit ta clé SSH publique sur ton Mac
data "local_file" "ssh_key" {
  filename = pathexpand("~/.ssh/id_homelab.pub")
}

# 2. ÉTAPE CRUCIALE : On génère les fichiers cloud-init AVANT de créer les VMs
resource "local_file" "cloud_init_config" {
  count = 3
  # Le fichier sera créé dans le même dossier : user-data-0.yaml, etc.
  filename = "${path.module}/user-data-${count.index}.yaml"

  # On remplit le fichier avec le template et ta clé SSH
  content = templatefile("${path.module}/cloud-init/user-data.yaml", {
    ssh_key = trimspace(data.local_file.ssh_key.content)
  })
}

# 3. Création des 3 VMs
resource "multipass_instance" "k8s_nodes" {
  count  = 3
  name   = "node-${count.index}"
  cpus   = 2
  memory = "4G"
  disk   = "30G"
  image  = "jammy"

  # On dit à Terraform : "Utilise le fichier que tu as créé à l'étape 2"
  cloudinit_file = local_file.cloud_init_config[count.index].filename
}
