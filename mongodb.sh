cp mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-org -y

#edit listen address

systemctl enable mongod
systemctl start mongod