script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
mysql_root_pass=$1
component=payment

if [ -z "mysql_root_pass" ]; then
    echo mysql_root_pass missing
    exit
fi

func_python