#!/bin/bash
. .env

ENVIRONMENT=$1

case $ENVIRONMENT in

uat)
  echo "creates files from template..."
  mkdir -p dist

  echo "copies files to distribute..."
  cp Dockerfile dist/

  echo "distributes dist/ folder..."
  scp -r dist ${UAT_HOST}:/mnt/msata/build/uat

  echo "builds image on UAT"
  ssh -t ${UAT_HOST} \
    sudo podman build \
      -f /mnt/msata/build/uat/Dockerfile \
      --target=uat \
      -t acbilson/comments-uat:alpine-3.12 \
      /mnt/msata/build/uat
;;

prod)
  echo "creates files from template..."
  mkdir -p dist && \
    envsubst < template/container-comments.service > dist/container-comments.service

  echo "copies files to distribute..."
  cp Dockerfile dist/

  echo "distributes dist/ folder..."
  scp -r dist ${PROD_HOST}:/mnt/msata/build/prod

  echo "builds image on production"
  ssh -t ${PROD_HOST} \
    sudo podman build \
      -f /mnt/msata/build/prod/Dockerfile \
      --target=prod \
      -t acbilson/comments:alpine-3.12 \
      /mnt/msata/build/prod
;;

*)
  echo "please provide one of the following as the first argument: uat, prod."
  exit 1

esac
