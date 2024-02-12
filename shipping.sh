script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
mysql_root_pass=$1
component=shipping
load_schema=mysql

if [ -z "$mysql_root_pass" ]; then
    echo mysql_root_pass missing
    exit 1
fi


func_Java