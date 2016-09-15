#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TIGER_DIR="${DIR}"/../src
TIGER="${TIGER_DIR}"/tiger

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

cd "${DIR}"
function OK(){
	echo -e "${GREEN}OK${NC}"
}

echo ${DIR}
printf "Compiling... "
make -C "${TIGER_DIR}"
if [ $? -ne 0 ]; then
    exit 1
fi
OK

if [ -f "${1}" ]; then
	correct=${1%.*}.out
	echo Adding case "${1#$DIR/}"...
	"${TIGER}" "${1}" > "${correct}" 2>&1;
	OK
else
	echo -e "${RED}File not found.${NC}"
fi
