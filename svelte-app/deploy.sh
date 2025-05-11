#!/bin/sh

git pull
buildversion=$(git rev-parse HEAD)
echo "building $buildversion"
npm run build
npm ci --omit dev
sudo systemctl restart solarwars
