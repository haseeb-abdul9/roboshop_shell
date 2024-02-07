echo -e "\e[36m>>>>>install redis repo<<<<\e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[36m>>>>>enable & install redis 6.2<<<<\e[0m"
dnf module enable redis:remi-6.2 -y
dnf install redis -y

echo -e "\e[36m>>>>>change listen port<<<<\e[0m"
sed -i -e "s|127.0.0.0|0.0.0.0|" /etc/redis/redis.conf /etc/redis.conf

echo -e "\e[36m>>>>>start service<<<<\e[0m"
systemctl enable redis
systemctl start redis
