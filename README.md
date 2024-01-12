# Infrastructure Code for VPC Peering 
This will create a peering connection between to VPCs. Used for regional
connections

### Note : make sure to enable DNS resolving on both sides once this is done

```shell
  terraform init -reconfigure
  terraform plan -var-file=vars.tfvars -out tfplan
  terraform apply "tfplan"
```
