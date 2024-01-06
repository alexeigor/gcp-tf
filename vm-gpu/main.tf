# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

provider "google" {
  credentials = file("/Users/agorodilov/.config/gcloud/application_default_credentials.json")

  project = "agor1-409007"
  zone    = "us-east1-b"
}

resource "google_compute_address" "static" {
  name = "ipv4-address"
}

resource "google_compute_instance" "instance-2" {
  boot_disk {
    auto_delete = true
    device_name = "instance-1"

    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20231213a"
      size  = 150
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  guest_accelerator {
    count = 0
    # type  = "projects/agor1-409007/zones/us-east1-b/acceleratorTypes/nvidia-tesla-a100"
    type  = "nvidia-tesla-a100"
  }

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  # machine_type = "g2-standard-4"
  machine_type = "a2-highgpu-1g"

  metadata = {
    ssh-keys = "agorodilov:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCklyTVEZ8GqPikVOTtcsPpooJ4Kr8h2fB5FTzG8s/PUAOZkcHRq90s/FfHJqTbJkk17NWL83XsqdmZavtBBP6cEDHxS8wG7xQch2yLzd95iZcjendPoA1Y2A0aon5KAL+l2nMhYaDlQiYYvJQxE2NQih4S5YznfhfdzyaiPkRe7xnm0HO88Ef0M0LrqCETUf9hyU5VH1ClB5VhDp4gTtSrmR+8/4cJYhbcvGBCXF1NlV13EwLgKTHP6JE5ZyABawqt53GrlO2pF46orMoCAnAf6oVjXdVp8v35FioQk3d+lHfN3M/+YmhCOJTz9gF4W9XjQHZbrYt1dw0XxzPzMrJV agorodilov@Mac-mini-Alexey.local"
  }

  name = "instance-gpu"

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  scheduling {
    automatic_restart   = false
    on_host_maintenance = "TERMINATE"
    preemptible         = true
    provisioning_model  = "SPOT"
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

}
