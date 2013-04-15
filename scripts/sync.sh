#!/bin/sh

rsync -rlptDv --delete-after _site/ "kiidocs@docs101us.internal.kii.com:/ext/ebs/html"
