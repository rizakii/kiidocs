#!/bin/sh

dests="kiidocs@docs101us.internal.kii.com:/ext/ebs/html kiidocs@docs102us.internal.kii.com:/ext/ebs/html"

for d in $dests ; do
  echo "Uploading to: $d"
  rsync -rlptD --chmod=u+rw,g+r,o+r --chmod=Da+x --delete-after --progress _site/ "$d"
  echo "...uploaded"
  echo ""
  echo ""
done
