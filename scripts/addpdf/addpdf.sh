#!/bin/bash

TMPDIR='/tmp/dlfm'
USERAGENT='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36'

mkdir -p $TMPDIR

curl "$1" -o $TMPDIR/_tmp.pdf --user-agent "$USERAGENT"

gs \
  -dDownsampleColorImages=true \
  -dDownsampleGrayImages=true \
  -dDownsampleMonoImages=true \
  -dColorImageResolution=72 \
  -dGrayImageResolution=72 \
  -dMonoImageResolution=72 \
  -sDEVICE=pdfwrite \
  -sOutputFile=$TMPDIR/tmp.pdf \
  -dNOPAUSE \
  -dBATCH \
  $TMPDIR/_tmp.pdf

pdf2htmlEX $TMPDIR/tmp.pdf \
  --zoom 1.5 \
  --embed cFIjo \
  --dest-dir $TMPDIR \
  >/dev/null 2>&1

python add.py $TMPDIR/tmp.html $TMPDIR/tmp.css "$2"

rm -rf $TMPDIR
