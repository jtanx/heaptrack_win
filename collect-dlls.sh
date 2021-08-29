#!/usr/bin/bash
#set -e
MSYSROOT=`cygpath -w /`
BINROOT=`cygpath -w $(dirname $(realpath "${1}"))`

echo $MSYSROOT
echo $BINROOT

libs=`ntldd -D "$(dirname \"${1}\")" -R "$1" \
| grep dll \
| sed -e '/^[^\t]/ d'  \
| sed -e 's/\t//'  \
| sed -e 's/.*=..//'  \
| sed -e 's/ (0.*)//' \
| grep -F -e "$MSYSROOT" -e "$BINROOT" \
`

echo Collecting libraries...
for f in $libs; do
    cp -v "$f" .
    #echo $f
done

echo Done.