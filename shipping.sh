echo -e "\e[36m>>>>>install maven<<<<\e[0m"
dnf install maven -y

echo -e "\e[36m>>>>>add user & navigate to app directory<<<<<\e[0m"
useradd roboshop
mkdir /app

echo -e "\e[36m>>>>>download & unzip app content<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>download dependencies<<<<<\e[0m"
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>copy service file<<<<<\e[0m"
cp shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>start service<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping

echo -e "\e[36m>>>>>load schema & restart service<<<<<\e[0m"
dnf install mysql -y
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql
systemctl restart shipping





























