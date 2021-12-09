# CLI module

Module to download CLIs into local bin directory. This module is primarily intended to be used as a submodule within other modules. The CLIs currently supported are:

- jq
- yq v3
- yq v4
- igc

The module outputs the bin directory for use by other modules.

### Command-line tools

- curl

### Terraform providers

None

## Module dependencies

None

## Example usage

```hcl-terraform
module "clis" {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}
```

