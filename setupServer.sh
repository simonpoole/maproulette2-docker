#!/bin/bash
# If you don't set
if [ -z "$MAPROULETTE_DB_URL" ]; then
	MAPROULETTE_DB_URL="CHANGE_ME"
fi
if [ -z "$MAPROULETTE_CONSUMER_KEY" ]; then
	MAPROULETTE_CONSUMER_KEY="CHANGE_ME"
fi
if [ -z "$MAPROULETTE_CONSUMER_SECRET" ]; then
	MAPROULETTE_CONSUMER_SECRET="CHANGE_ME"
fi
port=$1
if [ -z "$port" ]; then
	port="80"
fi

/MapRouletteV2/bin/maproulettev2 -Dhttp.port=$port -Dconfig.resource=docker.conf \
	-DAPI_HOST='maproulette.org' \
	-DMR_DATABASE_URL=$MAPROULETTE_DB_URL \
	-DMR_CONSUMER_KEY=$MAPROULETTE_CONSUMER_KEY \
	-DMR_CONSUMER_SECRET=$MAPROULETTE_CONSUMER_SECRET \
	-DMR_SUPER_ACCOUNTS=8909 \
	-Djavax.net.ssl.trustStore=/MapRouletteV2/conf/osmcacerts \
	-Djavax.net.ssl.trustStorePassword=openstreetmap