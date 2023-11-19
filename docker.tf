resource "proxmox_vm_qemu" "docker" {
  count = 1
  name = "docker"
  target_node = var.proxmox_host

  clone = var.template_name
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 2
  cpu = "host"
  memory = 10240
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  disk {
    slot = 0
    size = "20G"
    type = "scsi"
    storage = "local-lvm"
    # Required to be 0 for no error on deployment
    iothread = 0
  }
  
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  
  ipconfig0 = var.ipconfig_docker
  
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
