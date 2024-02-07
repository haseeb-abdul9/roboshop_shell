echo -e "\e[36m>>>>>install nginx<<<<<\e[0m"
dnf install nginx -y

echo -e "\e[36m>>>>>create conf file<<<<<\e[0m"
cp /home/centos/roboshop_shell/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m>>>>>remove nginx content<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m>>>>>download & unzip app content<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>start service<<<<<\e[0m"
systemctl restart nginx
systemctl enable nginx