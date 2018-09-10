#!/bin/bash

if [ "$(whoami)" != "root"  ]; then
 	echo "Ingrese como root, para seguir y ejecute install.sh"
 	exit
fi


MY_ORACLE_DOWNLOAD='/home/ivan/Downloads/oracle-xe-11g/files'
PATH_ORACLE_INSTALL='/home/ivan/Documents/Test/how-to-install/oracle-xe-11g-debian'
ORACLE_FILE_NAME='oracle-xe-11.2.0-1.0.x86_64'
BASHRC='/etc/bash.bashrc'

# No modifique de aqui en adelante

if [ ! -d "$MY_ORACLE_DOWNLOAD" ]; then
	echo "MY_ORACLE_DOWNLOAD no corresponde a un PATH que exista"
	exit
fi


PATH_UNZIPED="$PATH_ORACLE_INSTALL/unziped"

msg="\n\n
	
	### \n

	Acceda al link, ingrese y descargue la versión de oracle 11g xe para linux\n

  	[ http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html ] 

   	\n\n ### \n
"
clear
echo $msg
echo "\n"

# Crea la carpeta donde descomprimimos el oracle
if [ -d "$PATH_UNZIPED" ]; then
	rm -rv "$PATH_UNZIPED"
fi

mkdir "$PATH_UNZIPED"
chmod 777 -R -v "$PATH_UNZIPED"

# Se descomprime el archivo
# Setea permisos de el archivo oracle-xe
chmod 777 -R -v "$MY_ORACLE_DOWNLOAD/$ORACLE_FILE_NAME.rpm.zip"
unzip "$MY_ORACLE_DOWNLOAD/$ORACLE_FILE_NAME.rpm.zip" -d "$PATH_UNZIPED/files"

# Se convierte el archivo
alien -c "$PATH_UNZIPED/files/Disk1/$ORACLE_FILE_NAME.rpm" generated



# Se copian archivos de configuración e iniciación
cp -rv "$PATH_ORACLE_INSTALL/chkconfig" "/sbin/chkconfig"
chmod 755 "/sbin/chkconfig"

df -k
cp -rv "$PATH_ORACLE_INSTALL/S01shm_load" "/etc/rc2.d/S01shm_load"


# Instalación del paquete .deb
dpkg -i "$(pwd)/oracle-xe_11.2.0-2_amd64.deb"


echo "\n ###	Instalación $ORACLE_FILE_NAME. Se asignaran las variables de entorno, para luego configrar el inicio. ###
"

tail -n 1 "$BASHRC" | wc -c | xargs -I {} truncate "$BASHRC" -s -{}

# Agregamos variables de entorno archivo 
echo "export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe" >> "$BASHRC"
echo "export ORACLE_SID=XE" >> "$BASHRC"
echo "export NLS_LANG=\$ORACLE_HOME/bin/nls_lang.sh" >> "$BASHRC"
echo "export ORACLE_BASE=/u01/app/oracle" >> "$BASHRC"
echo "export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:\$LD_LIBRARY_PATH" >> "$BASHRC"
echo "export PATH=\$ORACLE_HOME/bin:\$PATH" >> "$BASHRC"
echo "export PATH" >> "$BASHRC"


# Compilacion del archivo, de varible
source "$BASHRC"


