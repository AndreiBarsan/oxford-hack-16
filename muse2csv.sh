#!/usr/bin/env bash

# Note: won't work with spaces in paths, because hackathon.

doneWork=0
for museFile in $(ls recordings/*.muse); do
  fullFilename=$(basename "$museFile")
  extension="${fullFilename##*.}"
  filename="${fullFilename%.*}"

  if ! [[ -f "recordings/$filename.csv" ]]; then
    echo "Will convert $filename."
    doneWork=1
    muse-player -f recordings/$fullFilename -C "recordings/${filename}.csv"
  fi
done

if [[ $doneWork -eq 0 ]]; then
  echo "Nothing to do."
fi
