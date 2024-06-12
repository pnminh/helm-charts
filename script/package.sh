# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_DIR="$SCRIPT_DIR/../helm-repo"
for dir in $SCRIPT_DIR/../charts/*/ ; do
  echo $dir
  if [ -f "$dir/Chart.yaml" ]; then
    helm dependency update $dir
    helm package "$dir" --destination $REPO_DIR
  fi
done
helm repo index $REPO_DIR --url https://pnminh.github.io/helm-charts