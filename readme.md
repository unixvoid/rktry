#rktry

##Makefile
supported commands:
```
make               : create the rootfs execute a shell in alpine for creation
make fetch-acbuild : pull an acbuild binary and ready an acbuild environment
make fetch-actool  : pull an actool binary for later use

make bootstrap     : stage filesystem directory
make pull-bootstrap: pull filesystem tarball and open
make package       : package up rootfs for later use
make clean         : clean up project directory
```

##Usage
There are two ways to build an ACI with this tool: manual and scripted.  

- The manual way will set up an alpine filesystem and allow you to install
packages in this environment to prep for deployment.  After the packages are
installed rktry will launch acbuild and allow you setup a manifest file.
- Steps for manual: `make`, `make fetch-acbuild`

- The scripted way will allow you to create commands to run inside the alpine
filesystem to prep for deployment and take a supplied manifest file to create
the ACI.
