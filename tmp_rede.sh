#!/bin/bash

##############################################################################
#FUNCOES
##############################################################################
source /tmp/func.sh
##################PROGRAMA PRINCIPAL##########################################

IP=$(whiptail --title "Qual endereco de ip" --inputbox "Ip atual $(hostname -I)" --fb 10 60 3>&1 1>&2 2>&3)
if [ $? -eq 1 ] || [[ $IP == " " ]]
then
    echo " "
	whiptail --title "Erro" --backtitle "Valor nao informado do IP" --msgbox "Finalizando o script." --fb 15 50
	kill $$
fi

testa_ip $IP

MASK=$(whiptail --title "Qual a mascara de rede" --inputbox "Ex: 8 16 24)" --fb 10 60 3>&1 1>&2 2>&3)
if [ $? -eq 1 ] || [[ $MASK == " " ]]
then
    echo " "
    whiptail --title "Erro" --backtitle "Valor nao informado da mascara" --msgbox "Finalizando o script." --fb 15 50
    kill $$
fi

GW=$(whiptail --title "Qual endereco do Gateway" --inputbox "Ex: $(ip -o -4 route show to default |awk '{print $3}' |tail -n 1)" --fb 10 60 3>&1 1>&2 2>&3)
if [ $? -eq 1 ] || [[ $GW == " " ]]
then
    echo " "
    whiptail --title "Erro" --backtitle "Valor nao informado do Gateway" --msgbox "Finalizando o script." --fb 15 50
    kill $$
fi

testa_gw $GW

DNS=$(whiptail --title "Qual endereco de DNS" --inputbox "Ex 8.8.8.8" --fb 10 60 3>&1 1>&2 2>&3)
if [ $? -eq 1 ] || [[ $DNS == " " ]]
then
    echo " "
    whiptail --title "Erro" --backtitle "Valor nao informado do DNS" --msgbox "Finalizando o script." --fb 15 50
    kill $$
fi

testa_dns $DNS


REDE=$(ip -o -4 route show to default | awk '{print $5}' | uniq)


nome=$(whiptail --title "Escolha a interface de rede abaixo" --inputbox "$REDE" --fb 10 60 3>&1 1>&2 2>&3)

if [ $? -eq 1 ] || [[ $nome == " " ]]
then
   whiptail --title "Erro" --backtitle "Valor nao informado do nome da reded" --msgbox "Finalizando o script." --fb 15 50
   kill $$
fi

echo "$IP"
echo "$MASK"
echo "$GW"
echo "$DNS"
echo "$nome"


#Here document para criar banco
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



