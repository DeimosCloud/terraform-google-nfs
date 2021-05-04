variable "project" {
  description = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  default     = null
}

variable "region" {
  description = "Region where the instances should be created."
  default     = null
}

variable "network" {
  description = "Network to deploy to. Only one of network or subnetwork should be specified."
  default     = null
}

variable "zone" {
  description = "The Compute Instance Zone"
  default     = null
}

variable "subnetwork" {
  description = "Subnet to deploy to. Only one of network or subnetwork should be specified."
  default     = null
}

variable "image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "source_image_project" {
  type    = string
  default = "ubuntu-os-cloud"
}

variable "service_account" {
  default = {
    email  = null
    scopes = []
  }
  type = object({
    email  = string,
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
}


variable "metadata" {
  description = "Metadata to be added to the compute instance, provided as a map"
  default     = {}
}

variable "network_tier" {
  description = "IP Address Network Tier"
  default     = "STANDARD"
}

variable "tags" {
  description = "Additional network tags to attach to the instance nfs instance"
  default     = []
}

variable "name_prefix" {
  description = "The name prefix for the instance."
  default     = "nfs-instance-template"
}

variable "labels" {
  description = " (Optional) Resource labels to represent user-provided metadata."
  default     = {}
}


variable "capacity_gb" {
  description = " File share capacity in GiB."
  default     = "50"
}

variable "machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  default     = "f1-micro"
}

variable "attach_public_ip" {
  description = "Whether to make the instance public or not"
  default     = false
}

variable "export_paths" {
  description = "Paths to exports"
  default     = ["/share"]
}

variable "auto_delete_disk" {
  description = "Whether or not the boot disk should be auto-deleted"
  default     = false
}

variable "disk_type" {
  description = "(Optional) The GCE disk type. Can be either pd-ssd, local-ssd, pd-balanced or pd-standard"
  default     = "pd-standard"
}
