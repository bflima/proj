#!/bin/bash

#Funções usadas no programa

#Função instalar
#Instala pacotes necessario para o funcionamento do programa
function _instalar()
{
#Verifica se o arquivo existe se não existir executa o update
FILE="/tmp/inicial.txt"
echo "$FILE"
  if [ ! -e "$FILE" ] ; then
    apt-get update -y
    apt-get upgrade -y

    apt-get install curl git wget unzip vim apache2 php5 git ntpdate mysql-server php5-mysql curl php5-mcrypt -y

    #realiza ajuste no vim
    sed -i 's/^"syntax.*/syntax on/' /etc/vim/vimrc
    sed -i 's/"set background.*/set background=dark/' /etc/vim/vimrc
    sed -i '21s/^/\n'/ /etc/vim/vimrc    
    sed -i '20s/^/set number'/ /etc/vim/vimrc
    ntpdate a.ntp.br


    curl -sS https://getcomposer.org/installer | php
    echo "Configuracao realizada instalação" > $FILE
  fi
}

#Função Composer
#Função para instalar o composer, painel-web e triagem-touch
function _composer()
{
#Verifica se o arquivo existe se não existir executa a instalação
FILE="/tmp/composer.txt"
echo "$FILE"
  if [ ! -e "$FILE" ] ; then
    php composer.phar create-project novosga/novosga /var/www/html/novosga "1.*"
    chown -R www-data:www-data /var/www/html/novosga/
    cd /var/www/html/novosga/
    
    wget https://github.com/novosga/triagem-touch/archive/v1.4.0.tar.gz
    tar -zxvf v1.4.0.tar.gz -C /var/www/html/
    mv /var/www/html/triagem-touch-1.4.0 /var/www/html/triagem-touch
    chown -R www-data:www-data /var/www/html/triagem-touch
    
    wget https://github.com/novosga/painel-web/archive/v1.3.0.tar.gz
    tar -zxvf v1.3.0.tar.gz -C /var/www/html/
    mv /var/www/html/painel-web-1.3.0 /var/www/html/painel-web
    chown -R www-data:www-data /var/www/html/painel-web

    mv v1.* /root/

cat > /etc/apache2/sites-available/000-default.conf << EOF
<Directory "/var/www/">
  AllowOverride All
Require all granted
  </Directory>
EOF
    sed -ie 's/memory_limit\ =\ 128M/memory_limit\ =\ 256M/g' /etc/php5/apache2/php.ini
    php5enmod mcrypt
    a2enmod rewrite
    invoke-rc.d apache2 restart

  echo "Configuracao realizada composer" > $FILE
fi
}

function _banco()
{
FILE="/tmp/banco.txt"
echo "$FILE"
  if [ ! -e "$FILE" ] ; then

cat > /tmp/banco.sql << EOF
create database novosga;
create user 'novosga'@'%' identified by 'sga123';
grant all privileges on novosga.* to 'novosga'@'%' identified by 'sga123';
exit
EOF
    clear
    echo "Digite a senha do uuario root do mysql"
    mysql -u root -p < /tmp/banco.sql
    sed -i s'/127.0.0.1/0.0.0.0/' /etc/mysql/my.cnf
    /etc/init.d/mysql restart
    echo "Configuracao realizada composer" > $FILE
  fi

}
########################################################################################################
#Chamada de função
_instalar
_composer
_banco

