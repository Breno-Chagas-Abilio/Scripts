#!/bin/bash

#script basico em shell puro, furutamente teremos um em dialog

#Para a melhor utilização do script recomendo executar ele no directorio /root
#A função InstallR(essa função faz a instalação do Rclone) para que funcione
#O script precisa estar no directorio /root

#variaveis globais.......

P=0

#----------------------------Funções-----------------------------------------
InstallR(){  #funciona apenas para centos
  clear
  echo Instalando o Rclone...
  echo

  curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
  unzip rclone-current-linux-amd64.zip
  cd rclone-*-linux-amd64

  sudo cp rclone /usr/bin/
  sudo chown root:root /usr/bin/rclone
  sudo chmod 755 /usr/bin/rclone

  sudo mkdir -p /usr/local/share/man/man1
  sudo cp rclone.1 /usr/local/share/man/man1/
  sudo mandb 

  rclone config

}
paramentro(){             #parametro referente ao tipo de operação, 

opP=0
  while ((opP<=0))
  do
    
    echo ------------------------------------------------------------------------------------
  
    echo Escolha o parametro
    echo 1- Copy Copia e substitui arquivo com o mesmo nome 
    echo 2- Sync Sincroniza, ou seja deixa a pasta destino igual a origem, cuidado... 
    echo 3- Move Move os arquivos da pasta local para o destino 
    echo 4- Ler mais a respeito dos paramentros  #chamar rclone help
    echo 5- Digitar manualmente um paramentro
    echo ------------------------------------------------------------------------------------
    
    read opP   #variavel de leitura de paramentro

    case "$opP" in    # como fazer essa porra ter um while, e mesmo assim apos a opção escolhida ele sair do while ? 

      1) P="copy" ;;
      2) P="sync" ;; 
      3) P="move" ;;
      4) Rhelp 
        
        echo Precione entrer para continuar
        read '' 
        
        paramentro
      ;;
      5) 
      echo digite o parametro
      read P
       ;;
      *) echo pcao invalidade ;;

    esac 
  
  done 
  
}

OPpasta(){
 clear 

  echo 1- Com pasta ...criando uma pasta com o nome UP com a data e hora
  echo 2- Sem pasta ...NÂO Criando uma pasta com o nome UP com a data e hora
  read opPASTA

  case "$opPASTA"  in
  1) PP="`date +%d-%m-%Y_%H:%M`" ;;
  2) PP="" ;;
  *) Opção invalida ;;
 esac    
}

Update(){

  clear

  echo Digite o serviço de nuvem
  read nuvem

  echo Digite o endereço da pasta local ou arquivo desejada para o upload:
  read pastaO

  clear
  echo listando as pasta da nuvem...
  rclone lsd "$nuvem":
  echo

  echo Digite a pasta da nuvem aonde ira armazear os arquivos:
  read pastaN # se a pasta que o usario digitou não exitir o google vai criar uma...

  ############### OPÇÂO escolha o parametro ##################
  clear
  paramentro

  clear
  OPpasta
  echo executando upload ...

  clear
  echo
  echo quase la...

  echo "...copiando do computador para a nuvem - subir..." >> /var/log/rclone- `date +%d-%m-%Y_%H:%M`.log
  rclone "$P" "$pastaO" "$nuvem":/"$pastaN"/"$PP" --log-file=/var/log/rclone-`date +%d-%m-%Y_%H:%M`.log
  echo ==================================== >> /var/log/rclone-`date +%d-%m-%Y_%H:%M`.log 

  clear
  echo
  echo
  echo -------------------------------
  echo Upload concuido................  
  echo -------------------------------
  echo
  echo Precione entrer para continuar
  read ''

}

Dowloand(){ 
  clear

  echo Digite o serviço de nuvem
  read nuvem

  clear
  echo listando as pasta da nuvem...
  rclone lsd "$nuvem":
  echo

  echo Digite a pasta da nuvem desejada para o dowloand
  read pastaN
  echo Digite a pasta locao aonde ira os armazenar os Dowloand 
  read pastaO 
  
  clear
  paramentro

  echo 
  echo executado dowloand ...
  clear
  echo quase la...

  echo "*** Copiando da nuvem para o computador - baixar ***" >> /var/log/rclone-`date +%d-%m-%Y_%H:%M`.log
  rclone "$P"  "$nuvem":/"$pastaN"/ "$pastaO"/"$PP"  --log-file=/var/log/rclone-`date +%d-%m-%Y_%H:%M`.log
  echo ==================================== >> /var/log/rclone-`date +%d-%m-%Y_%H:%M`.log

 
  echo
  echo -------------------------------
  echo Dowloand concuido..............
  echo -------------------------------
  echo
  echo Precione entrer para continuar
  read ''

}
Lcron(){ #pertence a BackupAUT  ler o conteudo do contrab
  clear
  echo
  echo 

  cat /etc/crontab

  echo
  echo
  echo Digite enter para continuar  
  read ''

BackupAUT
}
AUTDownload(){

  clear
  echo Digite o nome para o script
  read nomeSC
  #Crir o arquivo agora, na pasta /bin/"$nomeSC".sh

  touch /bin/"$nomeSC".sh

  clear
  
  echo Digite o nome do serviço de nuvem
  read nuvem

  echo listando as pasta da nuvem...
  rclone lsd "$nuvem":
  echo

  echo Digite o endereço da pasta ou arquivo da nuvem que desejada automatizar o backup
  read pastaN #endereço da pasta

  echo Digite a pasta local para aonde ira os arquivos da nuvem
  read pastaO
  
  # isso ja vai para dentro de um script que ficara armazeado
  # na pasta autBack_rclone em /root
  
  #escolher o tipo do parametro copy, sync e etc...
  clear
  paramentro
  
  #chama a função OPpasta, nele está a variavel PP, ele que vai dizer se o arquivo selecionado para o script automatico, vai ir para
  #dentro de uma pasta com o data, hora e minuto que foi upado, ou se vai para o local selecionado na nuvem da forma como está 
  clear
  OPpasta

#----------Escrevendo dentro do script-------------------------{


  echo "#!/bin/bash" >> /bin/"$nomeSC".sh 
  echo "echo ...Copiando da nuvem para o computador- subir..." ">> /var/log/rclone- 'date +%d-%m-%Y'.log" >> /bin/"$nomeSC".sh
  echo "rclone "$P"  "$nuvem":/"$pastaN"/ "$pastaO"/"$PP"  --log-file=/var/log/rclone-`date +%d-%m-%Y_%H:%M`.log" >>  /bin/"$nomeSC".sh
  echo "echo quase la..." >> /bin/"$nomeSC".sh
  echo "echo ==================================== >> /var/log/rclone-`date +%d-%m-%Y_%H:%M`.log" >> /bin/"$nomeSC".sh

  echo "echo -------------------------------" >> /bin/"$nomeSC".sh
  echo "echo Script de Upload concuido......" >> /bin/"$nomeSC".sh
  echo "echo -------------------------------" >> /bin/"$nomeSC".sh

  chmod 755 /bin/"$nomeSC".sh

  clear
}

AUTUpload(){
  
  clear
  echo Digite o nome para o script
  read nomeSC
  #Crir o arquivo agora, na pasta /bin/"$nomeSC".sh

  touch /bin/"$nomeSC".sh

  echo Digite o endereço da pasta ou arquivo que desejada automatizar o backup
  read pastaO #endereço da pasta

  echo Digite o nome do serviço de nuvem
  read nuvem

  clear
  echo listando as pasta da nuvem...
  rclone lsd "$nuvem":
  echo

  echo Digite a pasta da nuvem aonde ira armazear os arquivos:
  read pastaN
  
  #isso ja vai para dentro de um script que ficara armazeado
  #na pasta autBack_rclone em /root
  
  #escolher o tipo do parametro copy, sync e etc...
  clear
  paramentro
  
  #chama a função OPpasta, nele está a variavel PP, ele que vai dizer se o arquivo selecionado para o script automatico, vai ir para
  #dentro de uma pasta com o data, hora e minuto que foi upado, ou se vai para o local selecionado na nuvem da forma como está 
  clear
  OPpasta

#----------Escrevendo dentro do script-------------------------{


  echo "#!/bin/bash" >> /bin/"$nomeSC".sh 
  echo "echo "...copiando do computador para a nuvem - subir..." >> /var/log/rclone- `date +%d-%m-%Y_%H:%M`.log" >> /bin/"$nomeSC".sh
  echo "rclone "$P" "$pastaO" "$nuvem":/"$pastaN"/"$PP" --log-file=/var/log/rclone-`date +%d-%m-%Y_%H:%M`.log" >>  /bin/"$nomeSC".sh
  echo "echo quase la..." >> /bin/"$nomeSC".sh
  echo "echo ==================================== >> /var/log/rclone-`date +%d-%m-%Y_%H:%M`.log" >> /bin/"$nomeSC".sh

  echo "echo -------------------------------" >> /bin/"$nomeSC".sh
  echo "echo Script de Upload concuido......" >> /bin/"$nomeSC".sh
  echo "echo -------------------------------" >> /bin/"$nomeSC".sh

  chmod 755 /bin/"$nomeSC".sh

  clear


}


ScriptAUT(){ #pertence a BackupAUT
  
  
  clear
  echo ----------------------------------------------------
  echo 1- Cria um script automatico para Uploads  
  echo 2- Cria um script automatico para Download 
  echo -----------------------------------------------------
  read opAUT

  case "$opAUT" in
  1) AUTUpload ;;
  2) AUTDownload ;; 
  *) echo Opção  invalidade ;; 

  esac 
  #parte do CRON

  clear
  clear
  echo Agendamento...
  echo
  echo Digite o minuto, para deixar em braco digite ' * '    #não pra pra colocar *  pois ele lista o tem no diretocio tem que usar os aspas 
  read min
  echo Digite a hora, para deixar em braco digite ' * ' 
  read hora
  echo Digite o dia, para deixar em branco digite ' * ' 
  read dia
  echo Digite o mês, para deixar em braco digite ' * ' 
  read mes
  echo Digite semana, para deixar em braco digite ' * ' 
  read semana

#Escrever dentro do crontab o endereço aonde esta o script
#criado acima, e escreve o agendamento digitado acima

  echo "" >> /etc/crontab                    #endereço do script     "nome dado pelo usuario"
  echo "$min" "$hora" "$dia" "$mes" "$semana" "root /bin/"$nomeSC".sh" >> /etc/crontab

  
  echo "" >> crontab -e                    #endereço do script     "nome dado pelo usuario"
  echo "$min" "$hora" "$dia" "$mes" "$semana" "root /bin/"$nomeSC".sh" >> crontab -e

  

  echo Digite enter para continuar  
  read ''

BackupAUT

}
BackupAUT(){
x=1
while ((x!=0))
do
  clear
  echo -----------------Menu Script Auto-----------------
  echo 1 Listar script automaticos 
  echo 2 Criar script automatico
  echo 3 Editar CRONTAB
  echo 4 Retormar para o menu principal
  echo 0 exit 
  echo ----------------------------------------
  read opmc

  case "$opmc" in

    1) Lcron;;
    2) ScriptAUT ;; 
    3) vi /etc/crontab;;
    4) menu ;;
    0) exit ;;
    *) opcao invalidade ;;

  esac 
clear
done 
}

Rconfig (){
  clear
  rclone config
}
Rhelp(){
  clear
  rclone --help 
  
  echo Para proseguir aperte entrer
  read '' 
  
  #pausa ate aperta enter
}

Digitar (){
  clear
  echo Digite o seu comando:
  read x

  $x
  echo comando executado...
  read ''

Cmanual 
}

Cmanual(){
x=1
while ((x!=0))
do
  clear
  echo -----------------Menu comandos-----------------
  echo 1 Listar Comandos 
  echo 2 Digitar comando 
  echo 3 Retormar para o menu principal
  echo 0 exit 
  echo ----------------------------------------
  read opmc

  case "$opmc" in

    1) Rhelp;;
    2) Digitar ;; 
    3) menu ;;
    0) exit ;;
    *) opcao invalidade ;;

  esac 

clear

done 
}

#---------------------------------------------------------------------------------------------
#---------------------------MENU--------------------------------------------------------------
menu() {

i=1
while ((i>=1))
  do 
clear

  echo \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ L\ \ O 
  echo \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ C \ \ \ N 
  echo \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ R \ \ \ \ \ E 
  echo \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ E \ \ \ \ \ R 
  echo \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ N \ \ \ C 
  echo \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ O\ \ L 
  echo
  echo -----------------RCLONE_MENU-----------------

#echo 1 Configurações do rlcone {rclone config}
  echo 1 Update
  echo 2 Dowloand 
  echo 3 Rclone Config
  echo 4 Criar Backup automatico
  echo 5 Comando Manual
  echo 6 Instalar Rclone
  echo 0 Sair
  echo -----------------ENOLCR_UNEM-----------------


read opm

 case $opm in
   1)Update ;;
   2)Dowloand ;;
   3)Rconfig ;;
   4)BackupAUT ;;
   5)Cmanual ;; 
   6)InstallR ;;
   0) exit ;; 
   *) echo "opção invalida " ;;

  esac 
done
}
clear
menu 


#---CREDITOS-------------------------------------
#Script produzido por Breno Chagas Abílio
#git: https://github.com/Breno-Chagas-Abilio
#linkedin: https://www.linkedin.com/in/breno-chagas-ab%C3%ADlio-19300a176/
#---CREDITOS-------------------------------------
