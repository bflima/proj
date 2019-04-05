#!/bin/bash

##############################################################################
#FUNCOES
##############################################################################

function testa_ip()
{
#Testa se foi passado o parâmetro para a função.
if [ $# -ne 1 ]
then
    echo "Exemplo: de ip valido -> 192.168.10.10"
    exit
fi

#IP digitado fica armazenado na variavel IP
IP=$1

#Verifica caracteres inválidos
VALIDA=`echo ${IP} | sed "s/[0-9\.]//g"`;

if [ "${VALIDA}" != "" ];
then
    echo "Voce digitou caracteres invalidos para um ip";
    exit;
fi

#Recebe os dados se for um ip válido
ipvalido=$(echo $IP | egrep '^(([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){3}([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$')

if [ "$ipvalido" != "" ];
then
    echo -e "\n"
    #echo "O ip $ipvalido é um ip válido";
else
    tput setaf 1; tput setab 7; echo "O ip $IP e invalido"; tput sgr0
    exit 123
fi

}

##############################################################################
function testa_gw()
{
#Testa se foi passado o parâmetro.

if [ $# -ne 1 ] 
then
    echo "Exemplo: de gw valido -> 192.168.10.10"
    exit
fi

GW=$1

#Verifica caracteres inválidos
VALIDA=`echo ${GW} | sed "s/[0-9\.]//g"`;

if [ "${VALIDA}" != "" ];
then
	echo "Voce digitou caracteres invalidos para um gateway";
	exit;
fi

#Recebe os dados se for um ip válido
ipvalido=$(echo $GW | egrep '^(([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){3}([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$')

if [ "$ipvalido" != "" ];
then
    echo -e "\n"
    #echo "O ip $ipvalido é um ip válido";
else
    tput setaf 1; tput setab 7; echo "O GATEWAY $GW e invalido"; tput sgr0
fi
}

##############################################################################
function testa_dns()
{
#Testa se foi passado o parâmetro.

if [ $# -ne 1 ] 
then
    echo "Exemplo: de dns valido -> 8.8.8.8"
	exit
fi

DNS=$1

#Verifica caracteres inválidos
VALIDA=`echo ${DNS} | sed "s/[0-9\.]//g"`;

if [ "${VALIDA}" != "" ];
then
    echo "Voce digitou caracteres invalidos para um DNS";
    exit;
fi

#Recebe os dados se for um ip válido
ipvalido=$(echo $DNS | egrep '^(([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){3}([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$')
if [ "$ipvalido" != "" ];
then
    echo -e "\n"
    #echo "O ip $ipvalido é um ip válido";
else
    tput setaf 1; tput setab 7; echo "O DNS $DNS e invalido"; tput sgr0
fi
}

##############################################################################
testar_dep()
{
sleep 1
clear
#Verifica se comando which existe, senão realiza a instalação
which expect || yum install expect -y
which ntpdate || yum install ntpdate -y && ntpdate a.ntp.br
which vim || yum vim -y
echo "Sucesso na instalacao"
}

##############################################################################
#Funcao realiza ajuste no vim
#Facilitando configuração

function config_vim()
{
    FILE="/tmp/vim.txt"
    LOCAL_VIM=$(whereis vimrc |cut -d " " -f2) 
    echo "$FILE"

    if [ ! -e "$FILE" ] ; then
        echo "Criando arquivo de configuracao"
        sed -i 's/set\ nocompatible/set\ bg\=\dark\nset\ nocompatible/'     $LOCAL_VIM
        sed -i 's/set\ nocompatible/set\ tabstop\=4\nset\ nocompatible/'    $LOCAL_VIM
        sed -i 's/set\ nocompatible/set\ shiftwidth\=4\nset\ nocompatible/' $LOCAL_VIM
        sed -i 's/set\ nocompatible/set\ expandtab\nset\ nocompatible/'     $LOCAL_VIM
        sed -i 's/set\ nocompatible/syntax\ on\nset\ nocompatible/'         $LOCAL_VIM
        sed -i 's/set\ nocompatible/set\ number\nset\ nocompatible/'        $LOCAL_VIM
        echo "Configuracao realizada" > $FILE
    fi

    head -n 20 /etc/vimrc
    echo $LOCAL_VIM

}

##############################################################################
#Funcao para desabilitar o firewall
function disabilitar_fw()
{
    FILE="/tmp/firewall_e_selinux.txt"
    if [ ! -e "$FILE" ] ; then
      systemctl stop firewalld
      systemctl disable firewalld
      sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config && cat /etc/selinux/config
    else
    echo "Configuracao realizada, para repetir a instalacao remover esse arquivo $FILE"
    fi
}
###############################################################################
#Menu
function menu()
{
    echo -e "\n

    MMMMMMMM               MMMMMMMM                                                        
    M:::::::M             M:::::::M                                                        
    M::::::::M           M::::::::M                                                        
    M:::::::::M         M:::::::::M                                                        
    M::::::::::M       M::::::::::M    eeeeeeeeeeee    nnnn  nnnnnnnn    uuuuuu    uuuuuu  
    M:::::::::::M     M:::::::::::M  ee::::::::::::ee  n:::nn::::::::nn  u::::u    u::::u  
    M:::::::M::::M   M::::M:::::::M e::::::eeeee:::::een::::::::::::::nn u::::u    u::::u  
    M::::::M M::::M M::::M M::::::Me::::::e     e:::::enn:::::::::::::::nu::::u    u::::u  
    M::::::M  M::::M::::M  M::::::Me:::::::eeeee::::::e  n:::::nnnn:::::nu::::u    u::::u  
    M::::::M   M:::::::M   M::::::Me:::::::::::::::::e   n::::n    n::::nu::::u    u::::u  
    M::::::M    M:::::M    M::::::Me::::::eeeeeeeeeee    n::::n    n::::nu::::u    u::::u  
    M::::::M     MMMMM     M::::::Me:::::::e             n::::n    n::::nu:::::uuuu:::::u  
    M::::::M               M::::::Me::::::::e            n::::n    n::::nu:::::::::::::::uu
    M::::::M               M::::::M e::::::::eeeeeeee    n::::n    n::::n u:::::::::::::::u
    M::::::M               M::::::M  ee:::::::::::::e    n::::n    n::::n  uu::::::::uu:::u
    MMMMMMMM               MMMMMMMM    eeeeeeeeeeeeee    nnnnnn    nnnnnn    uuuuuuuu  uuuu


1 - Alterar IP
2 - Instalar Glpi

"
echo -e "Digite a escolha"

}

#############################################################################
#Testa componentes do GLPI
function TESTAR_GLPI()
{
FILE="/tmp/glpi_inst.txt"
clear
if [ ! -e "$FILE" ] ; then
    #Verifica se comando which existe, senão realiza a instalação
    which expect || yum install expect -y
    sleep 1
    which ntpdate || yum install ntpdate -y && ntpdate a.ntp.br
    sleep 1
    which wget || yum install wget -y
    sleep 1
    which curl || yum install curl -y
    echo "Sucesso na instalacao"
    sleep 1
    clear
    #Baixar Mysql e instalar versão 5.7
    wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
    rpm -ivh mysql57-community-release-el7-9.noarch.rpm
    yum install mysql-server -y
    clear
    sleep 1
    systemctl start mysqld
    systemctl enable mysqld
    echo "Configuracao realizada, para repetir a instalaacao remover esse arquivo $FILE" > $FILE
    clear
else 
    echo "Configuracao realizada, para repetir a instalacao remover esse arquivo $FILE"
fi
}
##############################################################################
#Função para desabilitar complexidade de senha no mysql
DESABILITAR_COMPLEX_SENHA()
{
    FILE="/tmp/glpi_sec_mysql.txt"
    clear
    if [ ! -e "$FILE" ] ; then
    MYSQL=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $11}')
    TMP_PASS="Senha.123"
    NEW_PASS="admin@123"

    expect <<EOF
    log_user 0
    spawn mysql -u root -p
    expect "Enter password:"
    send "$MYSQL\r"
    expect "mysql>"
    send "ALTER USER 'root'@'localhost' IDENTIFIED BY '$TMP_PASS';\r"
    expect "mysql>"
    send "uninstall plugin validate_password;\r"
    expect "mysql>"
    send "ALTER USER 'root'@'localhost' IDENTIFIED BY '$NEW_PASS';\r"
    expect "mysql>"
    send "exit\r"
    log_user 1
    expect eof
EOF
    echo "Configuracao realizada" > $FILE
    systemctl restart mysqld
    systemctl status mysqld
else
    echo "Configuracao realizada, para repetir a instalacao remover esse arquivo $FILE"
fi
}
##############################################################################
#Desabilitar secure pass
INST_SEGURA_GLPI()
{
    FILE="/tmp/glpi_inst_seg.txt"
    if [ ! -e "$FILE" ] ; then
        NEW_PASS="admin@123"
        expect <<FIM
        set timeout 10
        spawn mysql_secure_installation
        expect "Enter password for user root:"
        send "$NEW_PASS\r"
        expect "Press y|Y for Yes, any other key for No:"
        send "n\r"
        expect "Change the password for root ? ((Press y|Y for Yes, any other key for No) :"
        send "n\r"
        expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
        send "y\r"
        expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) :"
        send "y\r"
        expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) :"
        send "y\r"
        expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) :"
        send "y\r"
        expect eof
        ")
FIM
        echo "Configuracao realizada" > $FILE
else
        echo "Configuracao realizada, para repetir a instalacao remover esse arquivo $FILE"
fi
}
#############################################################################
#Criar banco de dados no GLPI
CRIAR_BANCO_GLPI()
{
    #Here document para criar banco
    FILE="/tmp/glpi_banco.txt"
    if [ ! -e "$FILE" ] ; then
        BANCO="/tmp/banco.sql"
        GLPI_DB="glpi"
        GLPI_USER="glpiuser"
        GLPI_PASS="admin@123"
cat > $BANCO << EOF
CREATE DATABASE $GLPI_DB;
CREATE USER $GLPI_USER@localhost;
SET PASSWORD for $GLPI_USER@localhost = PASSWORD("$GLPI_PASS");
GRANT ALL PRIVILEGES ON $GLPI_DB. * TO $GLPI_USER@localhost IDENTIFIED BY "$GLPI_PASS";
FLUSH PRIVILEGES;
exit
EOF
        mysql -u root -p < $BANCO
        #rm -rf $BANCO
        echo "Configuracao realizada" > $FILE
    else
    echo "Configuracao realizada, para repetir a instalacao remover esse arquivo $FILE"
fi
}
#############################################################################
BAIXAR_GLPI()
{
sleep 1
clear
FILE="/tmp/glpi_pacote.txt"
if [ ! -e "$FILE" ] ; then
    #Desabilitar o firewalld
    systemctl stop firewalld
    systemctl disable firewalld

    #Instalar repositorio EPEL
    yum install epel-release.noarch -y
    yum install epel-release yum-utils -y

    #Atualizar sistema
    yum update -y

    #Instalar dependencias
    yum install -y yum wget php-ldap php php-gd php-pear php-snmp php-pecl-zendopcache php-mbstring php-mysqli php-mysql httpd httpd-devel gcc php-mcrypt php-curl php-imap php-xmlrpc php-apcu php-pecl-zendopcache vim curl

    #Atualizar php para versão 7.0
    yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
    #Habilitar php 7
    yum-config-manager --enable remi-php70 -y
    #Atualizar pacotes
    yum update -y
    #instalar CAS
    yum install php-pear-CAS.noarch -y

    #Habilita e reinicia o serviço do apache
    systemctl start httpd.service
    systemctl enable httpd.service

    #Baixar Glpi versao 9.3.3, e extrair para o caminho /var/www/html/glpi
    cd /opt
    wget https://github.com/glpi-project/glpi/releases/download/9.3.3/glpi-9.3.3.tgz
    tar -zxvf glpi-9.3.3.tgz -C /var/www/html/

    #permissionar o apache, para uar o GLPI
    chown apache.apache /var/www/html/glpi -R
    chmod 775 /var/www/html/glpi/files -R
    chmod 775 /var/www/html/glpi/config -R
    echo "Configuracao realizada" > $FILE
else
    echo "Configuracao realizada, para repetir a instalacao remover esse arquivo $FILE"
fi
}
############################################################################
INST_GLPI()
{
FILE="/tmp/glpi_httpd.txt"
if [ ! -e "$FILE" ] ; then

#Criar Here document para acesso Web GLPI, no caminho /etc/httpd/conf.d/glpi.conf
    touch /etc/httpd/conf.d/glpi.conf
    echo "<Directory /var/www/html/glpi>" >> /etc/httpd/conf.d/glpi.conf
    echo "       AllowOverride All" >> /etc/httpd/conf.d/glpi.conf
    echo "</Directory>" >> /etc/httpd/conf.d/glpi.conf
    echo "" >> /etc/httpd/conf.d/glpi.conf
    echo "<Directory /var/www/html/glpi/config>" >> /etc/httpd/conf.d/glpi.conf
    echo "        Options -Indexes" >> /etc/httpd/conf.d/glpi.conf
    echo "</Directory>" >> /etc/httpd/conf.d/glpi.conf
    echo "" >> /etc/httpd/conf.d/glpi.conf
    echo "<Directory /var/www/html/glpi/files>" >> /etc/httpd/conf.d/glpi.conf
    echo "        Options -Indexes" >> /etc/httpd/conf.d/glpi.conf
    echo "</Directory>" >> /etc/httpd/conf.d/glpi.conf

    sed -i 's/^;date\.timezone[[:space:]]=.*$/date.timezone = "America\/Sao_Paulo"/' /etc/php.ini
    sed -ie 's/memory_limit\ =\ 128M/memory_limit\ =\ 256M/g' /etc/php.ini
    sed -ie 's/^max_execution_time\ =\ 30/max_execution_time\ =\ 600/g' /etc/php.ini
    sed -ie 's/upload_max_filesize\ =\ 2M/upload_max_filesize\ =\ 10M/g' /etc/php.ini
    sed -ie 's/post_max_size\ =\ 8M/post_max_size\ =\ 16M/g' /etc/php.ini
    echo "magic_quotes_sybase = off" >> /etc/php.ini

    systemctl restart httpd.service
    systemctl restart mysqld.service
    echo "Configuracao realizada" > $FILE
else
    echo "Configuracao realizada, para repetir a instalacao remover esse arquivo $FILE"
fi
}

#############################################################################


