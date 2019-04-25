#!/bin/bash
# A script to install dependencies and setup all configurations for production deployment.


export USER=ubuntu

echo "Installing Dependencies..."

sudo apt-get update
yes Y | sudo apt-get upgrade

yes Y | sudo apt-get install mongodb mysql-server nginx python3-dev python3-pip git virtualenv cron


echo "Done Installing Dependencies."


### BUILDING VIRTUAL ENVIRONMENT ###
echo "Building Virtual Environment..."
pip3 install virtualenv virtualenvwrapper
mkdir $HOME/.envs/

echo 'export PATH=$PATH:$HOME/.local/bin' | sudo tee -a $HOME/.bashrc
echo 'VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3' | sudo tee -a $HOME/.bashrc
echo 'export WORKON_HOME=$HOME/.envs' | sudo tee -a $HOME/.bashrc
echo '. ~/.local/bin/virtualenvwrapper.sh' | sudo tee -a $HOME/.bashrc
source ~/.bashrc

mkvirtualenv cc

# customize the postactivate functionality of virtualenvwrapper #
echo 'cd $VIRTUAL_ENV' | sudo tee -a $HOME/.envs/postactivate
echo 'source $VIRTUAL_ENV/postactivate' | sudo tee -a $HOME/.envs/postactivate
touch $HOME/.envs/cc/postactivate

# configure postactivate w/ the necessary environemental variables #
echo "echo 'Activating CrymeClarity Virtual Environment...'" | sudo tee -a $HOME/.envs/cc/postactivate
echo "cd ./CrymeClarity" | sudo tee -a $HOME/.envs/cc/postactivate
echo "export SOCRATA_APP_TOKEN=''" | sudo tee -a $HOME/.envs/cc/postactivate
echo "export DB_URL=mongodb://localhost:27017" | sudo tee -a $HOME/.envs/cc/postactivate
echo "export DB_NAME=crymeclarity" | sudo tee -a $HOME/.envs/cc/postactivate
echo "export MYSQL_URL=mysql://root@localhost/crymeweb?serverTimezone=UTC" | sudo tee -a $HOME/.envs/cc/postactivate
echo "export MONGO_URL=mongodb://localhost:27017/crymeclarity" | sudo tee -a $HOME/.envs/cc/postactivate
echo "export SECRET_KEY=''" | sudo tee -a $HOME/.envs/cc/postactivate
echo "export STATIC_ROOT=/home/ubuntu/static" | sudo tee -a $HOME/.envs/cc/postactivate
echo "export DJANGO_DEBUG=False" | sudo tee -a $HOME/.envs/cc/postactivate


source $HOME/.bashrc
echo "Virtual Environment built. Use command 'workon cc' to activate it."

### ADDING CONFIGURATION TO MYSQL, MONGODB, NGINX, GUNICORN ETC
cd $HOME/.envs/cc
git clone https://github.com/bwhitesell/CrymeClarity.git

sudo mv $HOME/.envs/cc/CrymeClarity/ops/mysql/my.cnf /etc/mysql/




sudo mv $HOME/.envs/cc/CrymeClarity/ops/nginx/nginx.conf /etc/nginx/
systemctl enable nginx.service


sudo mv $HOME/.envs/cc/CrymeClarity/ops/gunicorn/gunicorn.socket /etc/systemd/system
sudo mv $HOME/.envs/cc/CrymeClarity/ops/gunicorn/gunicorn.service /etc/systemd/system

sudo touch /etc/tmpfiles.d/gunicorn.conf
echo "d /run/gunicorn 0755 $USER www-data -" | sudo tee -a /etc/tmpfiles.d/gunicorn.conf

sudo systemctl enable gunicorn.socket

sudo systemctl start gunicorn.socket






