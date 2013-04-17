#!/bin/sh

rsync -rlptDv --chmod=u+rw,g+r,o+r --chmod=Da+x --delete-after _site/ "kiidocs@docs101us.internal.kii.com:/ext/ebs/html"
