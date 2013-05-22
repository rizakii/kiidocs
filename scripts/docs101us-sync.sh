#!/bin/sh

dests="kiidocs@docs101us.internal.kii.com"

for d in $dests ; do
  echo "Uploading to: $d"
  rsync -rlptD --chmod=u+rw,g+r,o+r --chmod=Da+x --delete-after --progress _site/ "$d":/ext/ebs/html
  echo "...uploaded"
  echo "Restarting nginx: $d"
  ssh $d 'sudo kill -HUP `cat /var/run/nginx.pid`'
  echo "...restarted"
  echo ""
  echo ""
done
