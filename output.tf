output "public_ip" {
  description = "Instance Public IP"
  value       = var.attach_public_ip == false ? "" : google_compute_instance_from_template.compute_instance.network_interface.0.access_config.0.nat_ip
}

output "internal_ip" {
  description = "Instance Internal IP"
  value       = google_compute_instance_from_template.compute_instance.network_interface.0.network_ip
}

output "disk_size" {
  description = "Size of disk used for NFS"
  value       = var.capacity_gb
}

output "nfs_disk" {
  description = "Persistent disk for NFS instance"
  value       = google_compute_disk.default
}
