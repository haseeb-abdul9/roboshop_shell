echo -e "\e[36m>>>>>download and install nodejs 18<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo -e "\e[36m>>>>>add user & navigate to app directory<<<<<\e[0m"
useradd roboshop
mkdir /app

echo -e "\e[36m>>>>>download & unzip app content<<<<<\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip

echo -e "\e[36m>>>>>download & install<<<<<\e[0m"
cd /app
npm install

echo -e "\e[36m>>>>>setup service file<<<<<\e[0m"
cp /root/roboshop_shell/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>start service<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user


