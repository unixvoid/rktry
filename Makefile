OS_PERMS=sudo
DOCKER_PREFIX=sudo
ACBUILD_VER=v0.4.0
ACTOOL_VER=v0.8.8
ARCH=amd64

all: bootstrap enter

bootstrap: createfs open

pull-bootstrap: pullfs opengz

package: createfs compress

enter:
	$(OS_PERMS) systemd-nspawn -D rktry-layout/rootfs/

build: bootstrap fetch-actool
	cp deps/rktry.sh rktry-layout/rootfs/
	cp deps/manifest.json rktry-layout/manifest
	$(OS_PERMS) systemd-nspawn -D rktry-layout/rootfs/ /rktry.sh
	$(OS_PERMS) appc/actool build rktry-layout rktry.aci
	appc/actool --debug validate rktry.aci

createfs:
	$(DOCKER_PREFIX) docker run -it --name alpine-test alpine /bin/true
	$(DOCKER_PREFIX) docker export alpine-test > rootfs.tar
	$(DOCKER_PREFIX) docker rm alpine-test
	tar --delete -f rootfs.tar .dockerenv
	#tar --delete -f rootfs.tar .dockerinit

pullfs:
	wget -O rootfs.tar.gz https://cryo.unixvoid.com/bin/filesystem/alpine/linux-latest-$(ARCH).rootfs.tar.gz

compress:
	gzip rootfs.tar

open:
	mkdir -p rktry-layout/rootfs/
	tar -xf rootfs.tar -C rktry-layout/rootfs/
	rm rootfs.tar

opengz:
	mkdir -p rktry-layout/rootfs/
	tar -xzf rootfs.tar.gz -C rktry-layout/rootfs/
	rm rootfs.tar.gz

fetch-acbuild:
	wget https://github.com/containers/build/releases/download/$(ACBUILD_VER)/acbuild-$(ACBUILD_VER).tar.gz
	tar xzf acbuild-$(ACBUILD_VER).tar.gz
	rm acbuild-$(ACBUILD_VER).tar.gz
	mv acbuild-$(ACBUILD_VER) acbuild
	deps/invoke.acbuild.sh

fetch-actool:
	wget https://github.com/appc/spec/releases/download/$(ACTOOL_VER)/appc-$(ACTOOL_VER).tar.gz
	tar xzf appc-$(ACTOOL_VER).tar.gz
	rm appc-$(ACTOOL_VER).tar.gz
	mv appc-$(ACTOOL_VER) appc

test:
	deps/testrkt.sh $(OS_PERMS)

cleanrkt:
	$(OS_PERMS) rkt rm `$(OS_PERMS) rkt list --no-legend | awk '{ print $1 }'`

cleanrktimage:
	$(OS_PERMS) rkt image rm `$(OS_PERMS) rkt image list --no-legend --fields=id`

clean:
	rm -rf rootfs/
	rm -f rootfs.tar
	rm -f rootfs.tar.gz
	$(OS_PERMS) rm -rf rktry-layout/
	rm -rf acbuild*
	rm -rf actool*
	rm -rf appc*
	rm -f rktry.aci
