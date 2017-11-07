#!/bin/bash

dir=$(dirname "$0") || exit $?

echo ">>Copying scripts to /usr/local/bin/"
find "$dir" -type f -not -name $(basename "$0") -and \( -name "*.sh" -or -name "*.py" \) |\
    while read f; do
        echo "  $f"
        fn=$(basename "$f") && \
            /bin/cp -a "$f" /usr/local/bin/ && \
            /bin/chmod 755 /usr/local/bin/$fn
    done || exit $?

echo ">>DONE."
exit
