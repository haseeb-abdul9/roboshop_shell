script=$(realpath "$0")
script_path=$(dirname "$script")
source=$script_path/common.sh

func_print_head "Install Nginx"
dnf install nginx -y &>>$log_file
func_stat_check $?

func_print_head "Copy conf file"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_stat_check $?

func_print_head "Remove Nginx content"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_stat_check $?

func_print_head "Download app content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_stat_check $?
cd /usr/share/nginx/html &>>$log_file
func_stat_check $?
unzip /tmp/frontend.zip &>>$log_file
func_stat_check $?

func_print_head "Start service"
systemctl restart nginx &>>$log_file
func_stat_check $?
systemctl enable nginx &>>$log_file
func_stat_check $?