#!/bin/bash
. .env

ENVIRONMENT=$1

case $ENVIRONMENT in

uat)
  echo "runs container in uat..."
  ssh -t ${UAT_HOST} \
    sudo podman run --rm -d \
      --expose ${UAT_EXPOSED_PORT} -p ${UAT_EXPOSED_PORT}:6000 \
      -e "REMARK_URL=${UAT_SITE}" \
      -e "REMARK_PORT=6000" \
      -e "SITE=remark42" \
      -e "AUTH_ANON=false" \
      -e "EMOJI=true" \
      -e "STORE_BOLT_PATH=/mnt/var/db" \
      -e "SECRET=${UAT_REMARK42_SECRET}" \
      -e "AUTH_GITHUB_CID=${GITHUB_CLIENT_ID}" \
      -e "AUTH_GITHUB_CSEC=${GITHUB_CLIENT_SECRET}" \
      -e "AUTH_FACEBOOK_CID=${FACEBOOK_CLIENT_ID}" \
      -e "AUTH_FACEBOOK_CSEC=${FACEBOOK_CLIENT_SECRET}" \
      -e "AUTH_GOOGLE_CID=${GOOGLE_CLIENT_ID}" \
      -e "AUTH_GOOGLE_CSEC=${GOOGLE_CLIENT_SECRET}" \
      -v ${UAT_DB_PATH}:/mnt/var/db \
      --name comments-uat \
      acbilson/comments-uat:alpine-3.12
;;

prod)
  echo "enabling micropub service..."
  ssh -t ${PROD_HOST} sudo systemctl daemon-reload
  ssh -t ${PROD_HOST} sudo systemctl enable --now container-webhook.service
;;

*)
  echo "please provide one of the following as the first argument: uat, prod."
  exit 1

esac
