#!/bin/bash
# environment variables that can be set
if [ -z "$DOCKER_VERSION" ]; then
	DOCKER_VERSION=1.0.0
fi
if [ -z "$DOCKER_USER" ]; then
	DOCKER_USER="maproulette"
fi
#This line gets the latest commit hash to use as the cachebust, when it changes the
#it will break the cache on the line just before we pull the code. So that it won't use
#the cache and instead will pull the latest and repackage
export CACHEBUST=`git ls-remote https://github.com/maproulette/maproulette2.git | grep HEAD | cut -f 1`
export FRONTCACHEBUST=`git ls-remote https://github.com/osmlab/maproulette3.git | grep HEAD | cut -f 1`
docker build -t $DOCKER_USER/maproulette2:$DOCKER_VERSION --build-arg CACHEBUST=$CACHEBUST --build-arg FRONTCACHEBUST=$FRONTCACHEBUST .

if [ "$wipe_db" == true ]; then
	echo "Stopping and removing mr2-postgis container"
	docker stop mr2-postgis
	docker rm mr2-postgis
fi

instance=$(docker ps -a | grep mdillon/postgis)
if [ -z "$instance" ]; then
	echo "Building new mr2-postgis container"
	docker run --name mr2-postgis \
		-e POSTGRES_DB=mr2_prod \
		-e POSTGRES_USER=mr2dbuser \
		-e POSTGRES_PASSWORD=mr2dbpassword \
		-d mdillon/postgis
	sleep 10
fi
instance=$(docker ps | grep mdillon/postgis)
if [ -z "$instance" ]; then
	echo "Restarting mr2-postgis container"
	docker start mr2-postgis
fi

echo "Stopping and removing maproulette2 container"
docker stop maproulette2
docker rm maproulette2
echo "Building maproulette2 container"
docker run -t --privileged -d -p 80:80 \
	--name maproulette2 \
	--link mr2-postgis:db \
	$DOCKER_USER/maproulette2:$DOCKER_VERSION

docker ps
