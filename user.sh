script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
component=user
load_schema=mongo

func_nodejs