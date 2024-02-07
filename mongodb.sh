echo -e "\e[36m>>>>>copy repo file<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>install mongodb<<<<<\e[0m"
dnf install mongodb-org -y

echo -e "\e[36m>>>>>change listen port<<<<<\e[0m"
sed -i -e 's|127.0.0.0|0.0.0.0' /etc/mongod.conf

echo -e "\e[36m>>>>>start service<<<<<\e[0m"
systemctl enable mongod
systemctl start mongod