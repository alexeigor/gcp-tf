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
  name = "instance-gpu"
  # machine_type = "g2-standard-4"
  machine_type = "a2-highgpu-1g"
  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  boot_disk {
    auto_delete = true
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 150
    }
  }

  guest_accelerator {
    count = 1
    type  = "nvidia-tesla-a100"
  }

  metadata = {
    ssh-keys = "agorodilov:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCfiiRIq2IGLfGv3GiKo96puAP0dwipW91RxKR5pTJ4FfwR+XMzU6caCG9EOyzD9SyfEgr5+iB76oCLz4OrE3qjRqKOxQJQ5QvGMzdayeLHNB4SKV+rOmVuBAclNMlYM+tBhxsp+VgYFWhZ2qWjbruz1M9H3I6ThUy+3p8jDEJ6bPYDL8LkIkbAUX0WmOBrMhoqgf9pX3UXCqXw/HV3YgFeH/S76o1MBEDHbPRl7fSSjKFw+WrVHf32Rd0vJMSaMnHpQ35YenLb2YSTE81ECXEOt0Q74TcyKhhWoTJCFRJX/cbLJE7ueV1p/hOzxz49Hsrlem2MAFLUmOFnb1dz2vqRGSepKF4AE0+r915HPTeu5ZxfK7scV/TgWpFvG0k66BQ7CczyjApuTO05+SoQA5kwbz9+qBFq/3P+A7PLLCpz6txXC4T1vlOYUJzsVAz1E9KD30gEFvECPiAP2HeVE3uh8NRYmMU9sLrMi3TgWLaFSlFZji+t2dsyna4D3aZhHiqfzPMoumbVnlKE0GJkH9db0NL9BSpltNHX4qV+G9fBqDPoLuvmi4jEXLnd2MmyJ5H1MUQ+DBj0qunCcBWpG9VsEidoulCNpEscMUA5mkoKVMlUdK7oopW3G65uCgc82Jgi0ZfGv+vdI2kj3SIozi2q28glgqchMz/Q2JjOFkmu6w== agorodilov@Alexeys-MacBook-Pro.local"
  }

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
