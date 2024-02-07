echo -e "\e[36m>>>>>install golang<<<<<\e[0m"
dnf install golang -y

echo -e "\e[36m>>>>>add user & navigate to app directory<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>create app directory<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>download & unzip app content<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip

echo -e "\e[36m>>>>download the dependencies & build the software<<<<<\e[0m"
cd /app
go mod init dispatch
go get
go build

echo -e "\e[36m>>>>>setup service file<<<<<\e[0m"
cp /home/centos/roboshop_shell/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[36m>>>>>start service<<<<<\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch










































