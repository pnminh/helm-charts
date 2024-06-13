#!/bin/bash
# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_DIR="$SCRIPT_DIR/."
BUILD_DIR=build
PUBLISH_DIR=helm-repo
mkdir -p $BUILD_DIR
for dir in $REPO_DIR/*/ ; do
  echo $dir
  if [ -f "$dir/Chart.yaml" ]; then
    helm dependency update $dir
    helm package "$dir" --destination $BUILD_DIR
  fi
done
git clone --branch main git@github.wwt.com:phammi/$PUBLISH_DIR.git
cp -n build/* $PUBLISH_DIR/
rm -rf build
helm repo index $PUBLISH_DIR --url https://github.wwt.com/pages/phammi/$PUBLISH_DIR
cd $PUBLISH_DIR
git add .
git commit -m "Update Helm charts and index" || exit 0
git push origin main
cd ..
rm -rf $PUBLISH_DIR