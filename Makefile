OS_PERMS=sudo
DOCKER_PREFIX=sudo
ACBUILD_VER=v0.4.0
ACTOOL_VER=v0.8.8

all: bootstrap enter

bootstrap: createfs open

package: createfs compress

enter:
	$(OS_PERMS) systemd-nspawn -D rktry-layout/rootfs/

createfs:
	$(DOCKER_PREFIX) docker run -it --name alpine-test alpine /bin/true
	$(DOCKER_PREFIX) docker export alpine-test > rootfs.tar
	$(DOCKER_PREFIX) docker rm alpine-test
	tar --delete -f rootfs.tar .dockerenv
	tar --delete -f rootfs.tar .dockerinit

compress:
	gzip rootfs.tar

open:
	mkdir -p rktry-layout/rootfs/
	tar -xf rootfs.tar -C rktry-layout/rootfs/
	rm rootfs.tar

fetch-acbuild:
	wget https://github.com/containers/build/releases/download/$(ACBUILD_VER)/acbuild-$(ACBUILD_VER).tar.gz
	tar xzf acbuild-$(ACBUILD_VER).tar.gz
	rm acbuild-$(ACBUILD_VER).tar.gz
	mv acbuild-$(ACBUILD_VER) acbuild

fetch-actool:
	wget https://github.com/appc/spec/releases/download/$(ACTOOL_VER)/appc-$(ACTOOL_VER).tar.gz
	tar xzf appc-$(ACTOOL_VER).tar.gz
	rm appc-$(ACTOOL_VER).tar.gz
	mv appc-$(ACTOOL_VER) appc
clean:
	rm -rf rootfs/
	rm -f rootfs.tar
	rm -f rootfs.tar.gz
	$(OS_PERMS) rm -rf rktry-layout/
	rm -rf acbuild*
	rm -rf actool*
	rm -rf appc*
