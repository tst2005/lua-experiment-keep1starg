#!/bin/sh

for f in a1 a2 a3 a4 a5; do
	echo "${f}.lua total: $(
		${@:-luac} -l -p solutions/${f}.lua \
		| sed 's/0x[0-9a-f]*//g' \
		| tee analysis/${f}.txt \
		| grep -o '[0-9]\+ instruction' \
		| awk '{ total+=$1 } END {print total}'
	) instructions"
	grep 'param.*slot.*upvalue.*local.*constant.*function' analysis/${f}.txt
        echo ""
done
