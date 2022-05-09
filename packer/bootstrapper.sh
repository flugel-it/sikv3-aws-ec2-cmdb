#!/bin/bash

set -e

#Simple shellscript that installs all the required packages in the AMI
#Author Flugel-IT

#Install required components for CMDBuild
sudo apt update; sudo apt-get -y install joe tree unzip fastjar tomcat9 tomcat9-admin postgresql #postgis
sudo systemctl stop tomcat9
cd /tmp

sudo mv tomcat-users.xml /etc/tomcat9/tomcat-users.xml
wget https://netcologne.dl.sourceforge.net/project/cmdbuild/3.2/cmdbuild-3.2.war
mkdir cmdbuild; ( cd cmdbuild; jar -xf ../cmdbuild-3.2.war )
sudo mv cmdbuild /var/lib/tomcat9/webapps/
cd /var/lib/tomcat9; sudo mkdir conf/cmdbuild; sudo chown -R tomcat conf/cmdbuild webapps/cmdbuild

sudo ed /lib/systemd/system/tomcat9.service << EOF
/ReadWritePaths
a
ReadWritePaths=/var/lib/tomcat9/conf/cmdbuild/
ReadWritePaths=/var/lib/tomcat9/conf/
.
wq
EOF
sudo systemctl daemon-reload

cd /tmp
wget https://jdbc.postgresql.org/download/postgresql-42.2.10.jar
sudo mv postgresql-42.2.10.jar /usr/share/java
cd /usr/share/tomcat9/lib; sudo ln -s ../../java/postgresql-42.2.10.jar
sudo su - postgres -c psql <<EOF
alter role postgres password 'postgres' login;
EOF

sudo systemctl start tomcat9
sudo systemctl enable tomcat9