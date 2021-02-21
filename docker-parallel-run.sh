#!/usr/bin/env bash

mkdir reports
rm -f reports/*

docker build -t testhive-journeys .
docker stop $(docker ps -aq -f "name=th-journeys") || true && docker rm $(docker ps -aq -f "name=th-journeys") || true

features_to_run="features/journey_tests/"
index=0

for file in "$features_to_run"/*
do
  index=$(( $index + 1 ))
  docker run -d -e features_to_run=${file} --name th-journeys${index} testhive-journeys
done
docker wait $(docker ps -q -f "name=th-journeys")

rm reports/build_logs.txt

for i in $(seq 1 $index); do
    docker logs th-journeys${i} >> reports/build_logs.txt
    docker cp th-journeys${i}:/app/reports .
done

run_exit_code=$(docker wait $(docker ps -q -f "name=th-journeys"))
exit $run_exit_code