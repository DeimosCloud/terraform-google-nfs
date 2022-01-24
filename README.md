# Terraform-google-NFS
A terraform module to setup NFS on a VM on GCP. This is not FileStore. Filestore minimum storage is 1TB which is $200 per month. For testing purposes, a smaller NFS setup is required. This compensates for that.


## Usage

```hcl
# NFS server VM to be used by apps such as magento
module "nfs" {
  source = "."

  name_prefix = "${var.project_name}-nfs-${var.environment}"
  labels      = local.common_labels
  subnetwork  = module.vpc.public_subnetwork
  project     = var.project_id
  network     = local.vpc_name
  export_paths = [
    "/share/media",
    "/share/static",
  ]
  capacity_gb = "100"
}

```

## Contributing

Report issues/questions/feature requests on in the issues section.

Full contributing guidelines are covered [here](CONTRIBUTING.md).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attach\_public\_ip | Whether to make the instance public or not | `bool` | `false` | no |
| auto\_delete\_disk | Whether or not the boot disk should be auto-deleted | `bool` | `false` | no |
| capacity\_gb | File share capacity in GiB. | `string` | `"50"` | no |
| disk\_type | (Optional) The GCE disk type. Can be either pd-ssd, local-ssd, pd-balanced or pd-standard | `string` | `"pd-standard"` | no |
| export\_paths | Paths to exports | `list` | <pre>[<br>  "/share"<br>]</pre> | no |
| image\_family | n/a | `string` | `"ubuntu-2004-lts"` | no |
| labels | (Optional) Resource labels to represent user-provided metadata. | `map` | `{}` | no |
| machine\_type | Machine type to create, e.g. n1-standard-1 | `string` | `"f1-micro"` | no |
| metadata | Metadata to be added to the compute instance, provided as a map | `map` | `{}` | no |
| name\_prefix | The name prefix for the instance. | `string` | `"nfs-instance-template"` | no |
| network | Network to deploy to. Only one of network or subnetwork should be specified. | `any` | `null` | no |
| network\_tier | IP Address Network Tier | `string` | `"STANDARD"` | no |
| project | (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `any` | `null` | no |
| region | Region where the instances should be created. | `any` | `null` | no |
| service\_account | Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account. | <pre>object({<br>    email  = string,<br>    scopes = set(string)<br>  })</pre> | <pre>{<br>  "email": null,<br>  "scopes": []<br>}</pre> | no |
| source\_image\_project | n/a | `string` | `"ubuntu-os-cloud"` | no |
| subnetwork | Subnet to deploy to. Only one of network or subnetwork should be specified. | `any` | `null` | no |
| tags | Additional network tags to attach to the instance nfs instance | `list` | `[]` | no |
| zone | The Compute Instance Zone | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| disk\_size | Size of disk used for NFS |
| internal\_ip | Instance Internal IP |
| public\_ip | Instance Public IP |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
