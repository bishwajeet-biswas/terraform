//provider
provider "google" {
  credentials = file("service-account.json")
  project     = "xap-test1"
  region      = "us-central1"
}
// module to create vpc and subnet

module "vpc_subnet" {
  source = "./module/vpc_subnet"
  vpc_name = "vpc-test-01"
  sub_name = "subnet-test-01"
  region = "us-central1"
  primary_range = "10.2.0.0/16"
  second_range = "192.168.10.0/24"
}

// module to create firewall

module "firewall" {
  source = "./module/firewall"
  fire_name = "test-firewall"
  tags = ["chai"]
  ip_access = ["146.196.35.231/32"]
  vpc_name = module.vpc_subnet.vpc_named
}


module "instance" {
  source = "./module"
  vm_name = "terraformserver-1"
  machine_type = "custom-1-2048"
  zone = "us-central1-a"
  image = "debian-cloud/debian-9"
  # additional_disk = module.additional_disk.additional_disk_named
  extra_disk = module.disk.additional_disk_named
  sshkeys = <<EOT
jeet:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCa5uyZQyBMdTa+qmnHF2NBlzgn60imAkDytb96p5Js8pfaWAg68p6jAuTrPhOn5IYHL+9XeabSIrHcQQHp58l/8oijxSLqrzYQZs+UnPSpiHQ1tsIgWglEmhFYdAa+cJYvHxRlulWHqs6gIRh55qFN+/Bx7juCXP4eDW+/dzU1rp2CfNqh4ITgSHHoHUEu4DF5dGbkbCehJcwY+FDzDpTR4zQ5pn6anAufVkUzQj8P74e0RpKfWfSVxlryhI4994Dc08BN8BLi9aRuQub6Klz+k7iPVUeoEhdhZkBAGblUVRZ5896BbDFq0Vo3aojJLzkXjehIMBdUGpweEjQnixhkk9FKCsTbi3vw1h+yQAm7R8yYqJDXMlaLZ+gvGtg2LPfcOxDe8Ysybeoq2/trwcd6bgnMbLBQ4P6ju6XpZ9M9JtpM+KCzl/LeR7FsVmPf1kPxiAlXnclbjZ/9PCteKGhp1fvBQDMhVThQ5zK70JeiI8jDmMP1d97GkYjmdzEqIMs= jeet

EOT

  tags = ["chai"]
  vpc_named = module.vpc_subnet.vpc_named
  subnetwork = module.vpc_subnet.subnetwork_named
  
###### labels##
  label_env = "test"
  label_created_by = "bishwajeet"
  label_creation_date = "8th-april"
  label_owner = "jeet"
  label_requester = "testing-me"
}

# ## Additional disk

module "disk" {
  source = "./module/disk"
  //vm_named = module.instance.vm_named
  disk_name = "datadisk-01"
  //extra_disk = module.disk.additional_disk_named
  zone = "us-central1-a"
  disk_size = "20"
  label_env = "test"
  label_created_by = "bishwajeet"
  label_creation_date = "8th-april"
  label_owner = "jeet"
  label_requester = "testing-me"
}
