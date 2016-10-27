DOCKER_PREFIX=sudo

stage: createfs open

package: createfs compress

createfs:
	$(DOCKER_PREFIX) docker run -it --name alpine-test alpine /bin/true
	$(DOCKER_PREFIX) docker export alpine-test > rootfs.tar
	$(DOCKER_PREFIX) docker rm alpine-test
	tar --delete -f rootfs.tar .dockerenv
	tar --delete -f rootfs.tar .dockerinit

compress:
	gzip rootfs.tar

open:
	mkdir -p rktryfs/
	tar -xf rootfs.tar -C rktryfs/
	rm rootfs.tar

clean:
	rm -rf rootfs/
	rm -f rootfs.tar
	rm -f rootfs.tar.gz
