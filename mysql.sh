script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
mysql_root_pass=$1

if [ -z "mysql_root_pass" ]; then
    echo mysql_root_pass missing
    exit
fi
func_print_head "configure mysql repo"
dnf module disable mysql -y &>>$log_file
func_stat_check $?

func_print_head "copy mysql repo"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_stat_check $?

func_print_head "install mysql server"
dnf install mysql-community-server -y &>>$log_file
func_stat_check $?

func_print_head "start service"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
func_stat_check $?

func_print_head "Setup root pass"
mysql_secure_installation --set-root-pass ${mysql_root_pass} &>>$log_file
func_stat_check $?