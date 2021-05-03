FROM alpine:3.12 AS base
RUN apk add wget tar git go

FROM base as uat-build
WORKDIR /src

# install arm7 remark42
RUN wget https://github.com/umputun/remark42/releases/download/v1.7.1/remark42.linux-arm.tar.gz -O remark42.linux-arm.tar.gz && tar xzf remark42.linux-arm.tar.gz

# install boltbrowser to view remark42 db
RUN wget https://git.bullercodeworks.com/brian/boltbrowser/releases/download/2.0/boltbrowser.linuxarm.zip -O boltbrowser.linuxarm.zip && unzip boltbrowser.linuxarm.zip

FROM alpine:3.12 as uat
COPY --from=uat-build /src/boltbrowser.linuxarm /usr/local/bin/boltbrowser
COPY --from=uat-build /src/remark42.linux-arm /usr/local/bin/remark42
ENTRYPOINT ["remark42", "server"]
