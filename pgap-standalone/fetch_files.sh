#!/bin/bash
set -euo pipefail

VERSION=`cat VERSION`
curl -O https://github.com/ncbi/pgap/archive/${VERSION}-beta.tar.gz
curl -O https://s3.amazonaws.com/pgap-data/input-${VERSION}.tgz
