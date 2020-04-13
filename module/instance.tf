## variables #####
variable "vm_name" {}
variable "machine_type" {}
variable "zone" {}
variable "tags" {}
variable "image" {}
#variable "nic" {}
variable "sshkeys" {}
variable "vpc_named" {}
variable "subnetwork" {}
variable "label_env" {}
variable "label_created_by" {}
variable "label_creation_date" {}
variable "label_requester" {}
variable "label_owner" {}
variable "extra_disk" {}

# variable "additional_disk" {}

# variable "gce_ssh_user" {}
# variable "gce_ssh_pub_key_file" {}

#################disk ##############



#########################

resource "google_compute_instance" "default" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  tags = var.tags
  labels = {
    environment = var.label_env
    created_by = var.label_created_by
    creation_date = var.label_creation_date
    requester = var.label_requester
    owner = var.label_owner
    creation_mode = "terraform"
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  

  attached_disk {
    source = var.extra_disk
    //device_name = "disk-1"
   }

  // Local SSD disk
  # scratch_disk {
  #   interface = "SCSI"
  # }

  network_interface {
      network = var.vpc_named
      subnetwork = var.subnetwork
    # network = module.firewall.google_compute_network.custom-test.name
      

    access_config {
      // Ephemeral IP
    }
  }

  # metadata = {
  #   sshKeys = var.keys
  # }


 metadata = {
    "ssh-keys" = var.sshkeys
  
  }

  # metadata = {
  #   ssh-Keys = "${var.gce_ssh_user}:${var.gce_ssh_pub_key_file}"
  # }  

# sshkeys="${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"

  metadata_startup_script = file("${path.module}/mount.sh")
  

  service_account {
     scopes = ["compute-rw"]
    #scopes = ["storagesa@xap-test1.iam.gserviceaccount.com"]
  }
}

//outputs

output "vm_named" {
  value = google_compute_instance.default.name
}


// "[#!/bin/bash \ sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb \ sudo mkdir -p /mnt/disks/data \ sudo mount -o discard,defaults /dev/sdb /mnt/disks/data \ sudo chmod a+w /mnt/disks/data \ sudo cp /etc/fstab /etc/fstab.backup \ sudo blkid /dev/sdb >uiid.txt \ echo UUID=`sudo blkid -s UUID -o value /dev/sdb` /mnt/disks/data ext4 discard,defaults,nofail 0 2 | sudo tee -a /etc/fstab >result.txt ]"