#!/bin/bash

##############################################################################
#FUNCOES
##############################################################################
source /tmp/func.sh
##################PROGRAMA PRINCIPAL##########################################

ESCOLHA=0
menu
read ESCOLHA

case $ESCOLHA in
    1)
        IP=$(whiptail --title "Qual endereco de ip" --inputbox "Ip atual $(hostname -I)" --fb 10 60 3>&1 1>&2 2>&3)
        if [ $? -eq 1 ] || [[ $IP == " " ]]
        then
            echo " "
            whiptail --title "Erro" --backtitle "Valor nao informado do IP" --msgbox "Finalizando o script." --fb 15 50
            kill $$
        fi

        testa_ip $IP

        clear
        MASK=$(whiptail --title "Qual a mascara de rede" --inputbox "Ex: 8 16 24)" --fb 10 60 3>&1 1>&2 2>&3)
        if [ $? -eq 1 ] || [[ $MASK == " " ]]
        then
            echo " "
            whiptail --title "Erro" --backtitle "Valor nao informado da mascara" --msgbox "Finalizando o script." --fb 15 50
            kill $$
        fi
        clear

        GW=$(whiptail --title "Qual endereco do Gateway" --inputbox "Ex: $(ip -o -4 route show to default |awk '{print $3}' |tail -n 1)" --fb 10 60 3>&1 1>&2 2>&3)
        if [ $? -eq 1 ] || [[ $GW == " " ]]
        then
            echo " "
            whiptail --title "Erro" --backtitle "Valor nao informado do Gateway" --msgbox "Finalizando o script." --fb 15 50
            kill $$
        fi

        testa_gw $GW

        clear
        DNS=$(whiptail --title "Qual endereco de DNS" --inputbox "Ex 8.8.8.8" --fb 10 60 3>&1 1>&2 2>&3)
        if [ $? -eq 1 ] || [[ $DNS == " " ]]
        then
            echo " "
            whiptail --title "Erro" --backtitle "Valor nao informado do DNS" --msgbox "Finalizando o script." --fb 15 50
            kill $$
        fi

        testa_dns $DNS

        clear
        REDE=$(ip -o -4 route show to default | awk '{print $5}' | uniq)


        nome=$(whiptail --title "Escolha a interface de rede abaixo" --inputbox "$REDE" --fb 10 60 3>&1 1>&2 2>&3)

        if [ $? -eq 1 ] || [[ $nome == " " ]]
        then
           whiptail --title "Erro" --backtitle "Valor nao informado do nome da reded" --msgbox "Finalizando o script." --fb 15 50
           kill $$
        fi

        clear

        echo "Ip Atual          ->$IP"
        echo "Mascara atual     ->$MASK"
        echo "GATEWAY ATUAL     ->$GW"
        echo "DNS atual         ->$DNS"
        echo "Nome da interface ->$nome"

#Here document para criar arquivo de rede
cat > /etc/sysconfig/network-scripts/ifcfg-$nome << EOF
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=$nome
DEVICE=$nome
ONBOOT=yes
IPADDR=$IP
PREFIX=$MASK
GATEWAY=$GW
DNS1=$DNS
EOF
        #Reiniciar rede
        sleep 2
        systemctl restart network
;;


2)
    TESTAR_GLPI
    DESABILITAR_COMPLEX_SENHA
    INST_SEGURA_GLPI
    CRIAR_BANCO_GLPI
    BAIXAR_GLPI
    INST_GLPI
;;

esac









