echo -e "\e[36m>>>>>disable mysql 5.7<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>>set up repo file<<<<\e[0m"
cp /root/roboshop_shell/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>install mysql server<<<<\e[0m"
dnf install mysql-community-server -y

echo -e "\e[36m>>>>>start server<<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e "\e[36m>>>>>set up root pass<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1
