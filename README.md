# Terraform Beginner Bootcamp 2023

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



Reference: 
![Terraform-CLI Install](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
![Wikipedia - Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))
![Wikipedia - CHMOD](https://en.wikipedia.org/wiki/Chmod)
![Gitpod - Tasks in Workspaces](https://www.gitpod.io/docs/configure/workspaces/tasks)