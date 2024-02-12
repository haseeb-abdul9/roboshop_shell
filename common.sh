app_user=roboshop
mysql_root_pass=$1
log_file=/tmp/roboshop.log

func_print_head() {
  echo -e "\e[36m>>>>>>>$1<<<<<<<\e[0m"
  echo -e "\e[36m>>>>>>>$1<<<<<<<\e[0m" &>>${log_file}
}

func_stat_check() {
  if [ $1 -eq 0 ]; then
      echo -e "\e[32mSuccess\e[0m"
  else
      echo -e "\e[31mFailure\e[0m"
      echo -e "refer /tmp/roboshop.log for more information"
      exit 1
  fi
}

func_load_schema() {
  if [ "$load_schema" == "mongo" ]; then
      func_print_head  "Setup repo file"
      cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
      func_stat_check $?

      func_print_head "Install Mongo client"
      dnf install mongodb-org-shell -y &>>${log_file}
      func_stat_check $?

      func_print_head "load schema"
      mongo --host mongodb.haseebdevops.online </app/schema/catalogue.js &>>${log_file}
      func_stat_check $?
  fi
  if [ "$load_schema" == "mysql" ]; then
      func_print_head "Load schema"
      dnf install mysql -y &>>${log_file}
      func_stat_check $?

      func_print_head "Change mysql default password"
      mysql -h mysql.haseebdevops.online -uroot -p${mysql_root_pass} < /app/schema/shipping.sql &>>${log_file}
      func_stat_check $?
  fi
}

func_systemd_setup() {
  func_print_headset "set Service file"
  cp /root/roboshop_shell/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  func_stat_check $?

  func_print_head "Start service"
  systemctl daemon-reload &>>${log_file}
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
  func_stat_check $?
}

func_app_prereq() {
  func_print_head "add application user"
  id ${app_user} &>>$log_file
    if [ $? -ne 0 ]; then
      useradd ${app_user} &>>$log_file
    fi
  func_stat_check $?

  func_print_head "Navigate to app directory"
  rm -rf /app &>>$log_file
  mkdir /app &>>$log_file
  func_stat_check $?

  func_print_head "Download app content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  cd /app &>>$log_file
  func_stat_check $?

  func_print_head "Unzip app content"
  unzip /tmp/${component}.zip &>>$log_file
  func_stat_check $?
}

func_nodejs() {
  func_print_head "Disable Nodejs"
  dnf module disable nodejs -y &>>$log_file
  func_stat_check $?

  func_print_head "Enable Nodejs 18"
  dnf module enable nodejs:18 -y &>>$log_file
  func_stat_check $?

  func_print_head "Install Nodejs"
  dnf install nodejs -y &>>$log_file
  func_stat_check $?

  func_app_prereq
  func_print_head "Install dependencies"
  npm install &>>$log_file
  func_stat_check $?

  func_systemd_setup
  func_load_schema
}

func_golang() {
  func_print_head "Install Golang"
  dnf install golang -y &>>$log_file
  func_stat_check $?
  
  func_app_prereq
  
  func_print_head "Download dependencies & build software"
  go mod init ${component} &>>$log_file
  go get &>>$log_file
  go build &>>$log_file
  func_stat_check $?
  
  func_systemd_setup
}

func_python() {
  func_print_head "Install Python"
  dnf install python36 gcc python3-devel -y &>>$log_file
  func_stat_check $?
  
  func_app_prereq
  
  func_print_head "Install dependencies"
  pip3.6 install -r requirements.txt &>>$log_file
  func_stat_check $?
  
  func_print_head "Change pass"
  sed -i -e "s|mysql_root_pass|${mysql_root_pass}" ${script_path}/${component}.service &>>$log_file
  func_stat_check $?
  func_systemd_setup
}

func_Java() {
  func_print_head "Install Java"
  dnf install maven -y &>>$log_file
  func_stat_check $?

  func_app_prereq
  
  func_print_head "Download dependencies"
  mvn clean package &>>$log_file
  mv target/${component}-1.0.jar ${component}.jar &>>$log_file
  func_stat_check $?
  
  func_systemd_setup
  func_load_schema
}
