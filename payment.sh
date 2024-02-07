echo -e "\e[36m>>>>>install python<<<<<\e[0m"
dnf install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>add user and navigate to app directory<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>create app directory<<<<<\e[0m"
rm -rf /app
mkdir /app


echo -e "\e[36m>>>>>download & unzip app content<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip

echo -e "\e[36m>>>>>download dependencies<<<<<\e[0m"
cd /app
pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>set up service file<<<<\e[0m"
cp /root/roboshop_shell/payment.service /etc/systemd/system/payment.service

echo -e "\e[36m>>>>>start service<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl start payment













































