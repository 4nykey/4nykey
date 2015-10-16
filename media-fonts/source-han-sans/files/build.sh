#!/bin/sh
source /etc/afdko
for x in $(find "${S}" -mindepth 1 -maxdepth 1 -type d -name '[A-Z]*')
do
	pushd "${x}" >& /dev/null
	/bin/sh "${S}"/cmd.sh
	mv -f *.otf "${S}"
	popd >& /dev/null
done

