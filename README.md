# Terraform Beginner Bootcamp 2023
### Index
- 0.1.0: Semantic Versioning
- 0.2.0: Install the Terraform CLI
- 0.3.0: 
- 0.4.0: 
- 0.5.0: 
- 0.6.0: 
- 0.7.0: Terraform Cloud & Terraform Login
- 0.8.0: Terraform Login Workaround
- 0.9.0: Terraform Alias (`tf`)
## 0.1.x Semantic Versioning :mage:
This project will use semantic versioning for tagging.
![Semantic Versioning 2.0](https://semver.org/)


Given a version number [MAJOR.MINOR.PATCH] increment (ex 0.4.1):
- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## 0.2.x Install the Terraform CLI 

### Considerations for Linux Distribution
This project is built against Ubuntu. 
Please consider checking your Linux Distribution and change accordingly to distribution needs.
**Example of output from checking the OS**
```
#output from 'cat /etc/os-release'
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```
### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keyring changes. So the original gitpod.yml So we needed to refer to the latest install CLI instructions via Terraform Documentation and change  the scripting for install.
[Terraform-CLI Install](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Refactoring into Bash Scripts
While fixing the Terraform CLI gpg depreciation issues we noticed that installation steps for the bash script were a considerable amount of code and required a dedicated script to be referenced by the gitpod.yml file.
This script is located in the bin sub directory: [.bin/install_terraform_cli]

- This will keep the Gitpod Task file ([.gitpod.yml](.gitpod.yml)) tidy.
- This will allow us an easier way to debug and execute manually.
- This will allow for better portability for other projects that require Terraform CLI

#### Shebang '#' 

A Shebang (pronounced Sha-Bang) tells the bash script what interpreter program will interpret the script '#!/bin/bash'

**Shebang Considerations**
The format of '#!/usr/bin/env bash' was recommended to us by ChatGPT for portability between OS
[Wikipedia - CHMOD](https://en.wikipedia.org/wiki/Chmod)

#### Execution Considerations

When executing the bash script we can use the './' shorthand notation to execute the bash script.
ex) './bin/install_terraform_cli'

If we are using a script in the .gitpod.yml we need to point the script to a program to interpret it.

#### Linux Permissions Considerations
In order for the bash script to be executable we need to change the user mode permission to include the 'executable' parameter.

chmod u+x ./bin/install_terraform_cli


[Wikipedia - CHMOD](https://en.wikipedia.org/wiki/Chmod)

### GitHub Lifecycle (Before, Init, Command)
We need to be careful when using the Init because it will not re-run if we restart an existing workspace. 
Made change in the .gitpod.yml on line #3 from Init to Before.

### Working with Environmental Variables (Env Vars)

We can list out all Env Vars using the 'env' command.
We can filter specific results of that command by piping the results to the 'grep' command [env | grep <capitalization sensitive variable>]

#### Setting & Unsetting Env Vars

In the terminal we can set variables by using 'export HELLO='Hello World!''
We can also unset that variable by using 'unset HELLO'

We can set a temporary variable by running a command 
```sh
HELLO ='Hello world!' ./bin/print_message
```
Within a bash script we can also set an Env Var without export
```sh
HELLO= 'Hello world!'

echo $HELLO
```

#### Printing Vars

We can print an Env Var using echo (eg. 'echo $HELLO')

#### Scoping of Env Vars
When you open up new bash terminals in VSCode, it will not be aware of env vars that you have set in another window.
If you want to Env Vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. (eg. 'bash_profile')

#### Persisting Env Vars in Gitpod
We can persist env vars into gitpod by storing them in Gitpod 'Secret Storage' 

```
gp env HELLO='Hello World!'
```
All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.
You can also set Env Vars in the '.gitpod.yml' but this can only non-sensitive Env Vars. ( we will use both)



### AWS CLI Installation

AWS CLI is installed for this project via the bash script ['./bin/install_aws_cli']


[Getting Started Install (CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

We can check if our AWS credentials are configured correctly by running the following AWS CLI command:
```sh
aws sts get-caller-identity
```
The results should looks similar to this: 
```json
{
    "UserId": "JUMBLEOFLETTERSANDNUMS",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```
We will need to generate AWS CLI credentials from IAM user in order to use the AWS user.
#### Creating the AWS CLI IAM User

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)


## Terraform Basics

### Terraform Registry

Terraform sources their proviers and modules from the Terraform registry which located at [registry.terraform.io](https://registry.terraform.io)

- **Providers** - Interfaces to APIs that will allow you to create resources in terraform.

[Terraform Random Provider](https://registry.terraform.io/providers/hashicorp/random/latest)

- **Modules** - Are a way to refactor, or make large amount of Terraform code modular, portable, & shareable.

### Terraform Console

We can see a list of all the Terraform commands by simply typing: `terraform`

#### Terraform Init

At the start of a new Terraform project we will run `terraform init` to download the binaries for the terraform providers

#### Terraform Plan

`terraform plan`
This will generate a changeset, about the state of our infrastructure and what will be changed.

We can output this changeset ie. "plan" to be passed to an apply, but often you can ignor outputting.

#### Terraform Apply

`terraform apply`
This will run a plan and pass the changeset to be executed by Terraform. Apply should prompt us to confirm [Yes|No].

If we want to automatically approve an apply we can provide the auto approve flag, eg. `terraform apply --auto-approve`

#### Terraform Destroy

`terraform destroy` 
This will destroy resources. This can also leverage the `--auto-approve` flag to not require you to make those changes.

### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that shoudl be used with this project.

The Terraform Lock File **should** be committed to your Version Control System (VCS) eg. Github

### Terraform State Files

`.terraform.tfstate` contains information about the current state of your infrastructure

The Terraform State files **should not** be commited to your VCS.

This file can contain sensitive data. If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state.

### Terraform Directory

`.terraform` directory contains binaries of terraform proviers.

### AWS S3 Buckets

To have Terraform create an S3 bucket, we need to add in the provider component into the (main.tf)[./main.tf] file and add the resource in as well.
Reference [Registry.Terraform.io](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) for the documentation and code samples of those components.

**S3 Buckets have requirements for naming**: of which some of the most important for this project are
- 10-64 characters in length
- No upper case
- Can contain lower case, numbers, and some basic symbols
- Name must start and end with a letter or number (not a symbol)
- Must be unique

[AWS S3 Bucket Naming Requirements](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)

## Terraform Cloud 

Using the Terraform Cloud allows you to create a workspace in a project to be used with your Gitpod environment.
A quick note for reference in Terraform Cloud terminology:
- **Project:** It an conceptual container of workspaces and could exist without a workspace.
- **Workspace:** Specific to an environment and used in a project.

In the environment you will see the normal Terraform plans to make your life easier
```
# Log into Terraform Cloud
terraform login

# Initialize Terraform
terraform init

# Have Terraform evaluate the plan
terraform plan

# Tell Terraform to run the plan
terraform apply

# Walking back the changes from the plan
terraform destroy
```

### Terraform Login 

**Steps to resolve Terraform Cloud Login & Gitpod Workspace**
Using the command `terraform login` will allow you to log into the Terraform Cloud space however on running it for the first time, you will need to create a token for use. 

The workaround is manually generating a token in the Terraform CLI

```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```

Then create & open the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (place the token in the file):

```json
{
    "credentials":{
        "app.terraform.io":{
            "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
        }
    }
}
```

We have automated the process as a workaround with the following bash script [bin/generate_tfrc_credentials](bin/generate_tfrc_credentials)
