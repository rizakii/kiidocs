#!/bin/sh

rsync -rlptDv --delete-after _site/ "kiidoc@kiidoc.muraoka-design.com:htdocs"
