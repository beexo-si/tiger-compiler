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

TMPFILE=testing_tmp.out
for tfile in $(find "${DIR}" -name "*.tig"); do
	correct=${tfile%.*}.out
	if [ -f "${correct}" ]; then
		echo Testing case "${tfile#$DIR/}"...
		"${TIGER}" "${tfile}" > $TMPFILE 2>&1
		diff $TMPFILE "${correct}"
		if [ $? -eq 0 ]; then
    			OK
		fi
	fi
done
printf "Finishing..."
rm -f $TMPFILE || true
OK
