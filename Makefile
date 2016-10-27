DOCKER_PREFIX=sudo

createfs:
	$(DOCKER_PREFIX) docker run -it --name alpine-test alpine /bin/true
	$(DOCKER_PREFIX) docker export alpine-test > rootfs.tar
	$(DOCKER_PREFIX) docker rm alpine-test
	tar --delete -f rootfs.tar .dockerenv
	tar --delete -f rootfs.tar .dockerinit
