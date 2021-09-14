#!/bin/bash
cd website
make html
cd ../web
cp -r ../website/_build/html/* .
echo "Uploading files"
lftp -u wwwsystinfo,N32RtnnHN5 -e "set sftp:auto-confirm yes ; mirror --reverse --ignore-time . ; exit" sftp://sftp.uclouvain.be
cd ..
