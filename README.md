# For creating an EC2 instance in a private subnet.

### Module Folder contains the reusable modules used for creating the required infrastructure.

### Resources folder contains the main file which creates the infrastructure.

## Few Notes
* Using terraform to generate ssh keys is nota a secure option as the private key can be found in the terraform state file. It is suggested to create your own key outside of terraform and use it.
* State files ideally should be stored in s3 buckets. The code for such is commited but commented as the code was tested locally.
