#!/bin/bash

Bmaquina(){
 echo Digite a pasta origem
    read pastaO
    echo Digite a pasta destino
    read pastaD
  rsync -avg "$pastaO" "$pastaD"
 
  Menu
}

Remoto(){
 echo Digite a pasta origem
    read pastaO
    echo O nome do servidor
    read serv
    echo Digite o nome do usario destino
    read user
    echo Digite o ip do servidor
    read ip_serv
    echo digite a pasta destino
    read pastaD
  rsync -avz "$pastaO" "$user"@"$ip_serv":"$pastaD"
  Menu 
 }
 clear

menu2(){
  clear

echo Escolha uma opção
echo Include ? sim 1 -- não 0
read opm2
if [opm2 == 1 ]
  then 
    echo Digite o include: 
    read includ
    echo Digite o exclude: 
    read exclud
  else 
    echo ok
fi
echo Progress ? Sim 1 -- não 0 
read op2m2
if [op1m2 == 1 ]
  then 
    Progress
  else 
    echo ok
fi

echo 3- Manualmente 
echo 4- sair 
echo -------------------------------

read opcao1
case $opcao1 in 
  1) Bmaquina ;; 
  2) Remoto ;; 
  3) Manualmente ;;
  4) exit ;; 
  #*) "opcao desconhecia." ; echo
esac 
}


Menu (){

clear
echo ________________________________
echo \ \ \ \ \ \ \ \ \ \ \ \ Bem vindo 
echo \ \ \ \ \ \ \ \ \ \ \ backup rsync
echo --------------------------------
echo Escolha uma opção
echo 1- backup para a mesma maquina
echo 2- backup para outra maquina 
echo 3- Manualmente # falta criar dar a opção do usuario digitar o comando que ele quiser
echo 4- sair 
echo --------------------------------

read opcao1
case $opcao1 in 
  1) Bmaquina ;; 
  2) Remoto ;; 
  3) Manualmente ;;
  4) exit ;; 
  #*) "opcao desconhecia." ; echo
esac 

}
Menu 
