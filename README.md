# Project

> This repo has been populated by an initial template to help get you started. Please
> make sure to update the content to build a great experience for community-building.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.


## Setting up Access
```
In a browser go to: https://github.com/microsoft/cheriot-safe
Click on the purple squigily item in the upper right corner. 
Select Settings
Select SSH and GPG keys
Add your SSH key
Authenticate key.
```
## Checking out the Repo
```
git clone git@github.com:microsoft/cheriot-safe.git  <ws>
cd <ws>
git submodule update --init --recursive
```

## Building and running a simulation
1. Review the ./sim/Makefile for the correct path to the vcs simulator.
2. Execute: ./trun hello_world
3. Test output is in ./out/run/hello_world/...
