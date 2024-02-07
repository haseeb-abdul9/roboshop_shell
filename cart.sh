echo -e "\e[36m>>>>>Disable nodejs 10 & enable nodejs 18<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[36m>>>>>install nodejs<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[36m>>>>>add user<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>create app directory<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>download & unzip app content<<<<<\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip

echo -e "\e[36m>>>>>download & install<<<<<\e[0m"
cd /app
npm install

echo -e "\e[36m>>>>>setup service file<<<<<\e[0m"
cp /root/roboshop_shell/cart.service /etc/systemd/system/cart.service


echo -e "\e[36m>>>>>start service<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl start cart























