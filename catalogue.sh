echo -e "\e[36m>>>>>Disable nodejs 10 & enable nodejs 18<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[36m>>>>>install nodejs<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[36m>>>>>add user & navigate to app directory<<<<<\e[0m"
useradd roboshop
mkdir /app

echo -e "\e[36m>>>>>download & unzip app content<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>download & install<<<<<\e[0m"
cd /app
npm install

echo -e "\e[36m>>>>>setup service file<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>start service<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[36m>>>>>set up repo file<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-org-shell -y
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js