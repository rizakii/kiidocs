#!/bin/sh

rsync -rlptDv --delete-after _site/ "koron@dev.muraoka-design.com:htdocs/kiidoc"
