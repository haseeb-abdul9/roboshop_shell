script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
mysql_root_pass=$1

if [ -z "mysql_root_pass" ]; then
    echo mysql_root_pass missing
    exit
fi

func_print_head "download repo files"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
func_stat_check $?
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_stat_check $?

func_print_head "Install rabbitmq server"
dnf install rabbitmq-server -y &>>$log_file
func_stat_check $?

func_print_head "Start service"
systemctl enable rabbitmq-server &>>$log_file
systemctl restart rabbitmq-server &>>$log_file
func_stat_check $?

func_print_head "Username pass & permissions"
rabbitmqctl add_user roboshop ${mysql_root_pass} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
func_stat_check $?




































