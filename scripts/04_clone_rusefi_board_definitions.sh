#!/bin/bash

# check for firmware repo: (we only need the config board files)
FIRMWARE_FOLDER=$(readlink -f rusefi_fw )
echo $FIRMWARE_FOLDER
if [ -d rusefi_fw ]; then
    cd rusefi_fw
    git pull

else
    git clone -n --depth=1 --filter=tree:0 https://github.com/rusefi/rusefi.git rusefi_fw
    cd rusefi_fw
    git sparse-checkout set --no-cone firmware/config/boards
    git checkout
fi

cd ..
echo "--------------------------------------------------------------"
echo "Select the board to be used by the new runner:"

META_INFO_FILES=$(find "./rusefi_fw/firmware/config/boards" -name "meta-info*.env" | awk -F '/' '{print $(NF-1),$0}' | sort | cut -d' ' -f 2-)
OPTS=()
while IFS= read -r M; do
    # Get the name of the directory
    DIR=$(basename $(dirname "$M"))
    # Get the build name part of the meta-info file
    NAME=$(basename "$M" | sed -r 's/meta-info-(.*)\.env/\1/')
    # NAME will contain meta-info.env if the regex didn't match
    if [ "$NAME" == "meta-info.env" ]; then
        NAME="default"
    fi
    OPTS+=("$DIR $NAME")
done <<<"$META_INFO_FILES"

select OPT in "${OPTS[@]}"; do
    # REPLY is the index
    MI=$(echo "$META_INFO_FILES" | head -n $REPLY | tail -n 1)
    break
done

# https://stackoverflow.com/questions/19661267/replace-spaces-with-underscores-via-bash
OPT="${OPT// /-}"

export RUNNER_NAME="hw-ci-$OPT"