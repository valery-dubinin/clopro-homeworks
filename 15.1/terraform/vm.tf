#NAT-инстанс
resource "yandex_compute_instance" "nat-instance" {
  name        = "nat-instance"
  hostname    = "nat-instance"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat        = true
  }

  metadata = {
            user-data = "${file("meta.yml")}"
            serial-port-enable = 1
  }

  scheduling_policy {
    preemptible = true
  }
}

#Public VM
resource "yandex_compute_instance" "public-vm" {
  name     = "public-vm"
  hostname = "public-vm"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu20.image_id
      type = "network-hdd"
      size = 15
    }   
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
            user-data = "${file("meta.yml")}"
            serial-port-enable = 1
  }
  
  scheduling_policy {
    preemptible = true
  }  
}

#Private VM
resource "yandex_compute_instance" "private-vm" {
  name     = "private-vm"
  hostname = "private-vm"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu20.image_id
      type = "network-hdd"
      size = 15
    }   
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
  }

  metadata = {
            user-data = "${file("meta.yml")}"
            serial-port-enable = 1
  }
  
  scheduling_policy {
    preemptible = true
  }
}