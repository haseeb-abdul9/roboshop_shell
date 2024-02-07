echo -e "\e[36m>>>>>Disable nodejs 10 & enable nodejs 18<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[36m>>>>>install nodejs<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[36m>>>>>add user & navigate to app directory<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>create app directory<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>download app content<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[36m>>>>>unzip app content<<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>install dependencies<<<<<\e[0m"
cd /app
npm install

echo -e "\e[36m>>>>>setup service file<<<<<\e[0m"
cp /root/roboshop_shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>start service<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[36m>>>>>set up mongodb repo file<<<<<\e[0m"
cp /root/roboshop_shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>install mongodb client<<<<<\e[0m"
dnf install mongodb-org-shell -y
mongo --host mongodb.haseebdevops.online </app/schema/catalogue.js