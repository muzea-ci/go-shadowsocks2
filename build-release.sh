#!/bin/bash
set -ex
BUILD_DIR=$(dirname "$0")/build
mkdir -p $BUILD_DIR
cd $BUILD_DIR

VERSION=`date -u +%Y%m%d`
LDFLAGS="-X main.VERSION=$VERSION -s -w"
GCFLAGS=""
BINNAME="go-shadowsocks2"
REPO="https://github.com/shadowsocks/go-shadowsocks2.git"

git clone $REPO
cd $BINNAME

# AMD64
OSES=(linux)
for os in ${OSES[@]}; do
	suffix=""
	if [ "$os" == "windows" ]
	then
		suffix=".exe"
	fi
	env CGO_ENABLED=0 GOOS=$os GOARCH=amd64 go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o ${BINNAME}_${os}_amd64${suffix}
	tar -zcf ${BINNAME}-${os}-amd64-$VERSION.tar.gz ${BINNAME}_${os}_amd64${suffix}
	mv ${BINNAME}-${os}-amd64-$VERSION.tar.gz ..
done

# ARM64
env CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags "$LDFLAGS" -gcflags "$GCFLAGS" -o ${BINNAME}_linux_arm64
tar -zcf ${BINNAME}-linux-arm64-$VERSION.tar.gz ${BINNAME}_linux_arm64
mv ${BINNAME}-linux-arm64-$VERSION.tar.gz ..
