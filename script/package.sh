# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
for dir in $SCRIPT_DIR/../*/ ; do
  echo $dir
  if [ -f "$dir/Chart.yaml" ]; then
    helm dependency update $dir
    helm package "$dir"
  fi
done
helm repo index . --url https://pnminh.github.io/helm-charts