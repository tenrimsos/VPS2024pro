tput setaf 7 ; tput setab 4 ; tput bold ; printf '%50s%s\n' "Main.5 by Tenrimsos" ; tput sgr0

user=""
pass=""
host=""
ip=""
wireguardExist=""

preConfig() {
   #Preconfigurar el sistema
   echo ""; tput sgr0 ; tput setaf 7
   #sudo apt update -y
   #sudo apt install net-tools -y
   #sudo apt-get install apache2-utils -y
   # Agregando usuario ssh
   echo ""; tput sgr0 ; tput setaf 4
   echo "Agregando usuario ssh"; tput sgr0 ; tput setaf 7
   #useradd $user
   #passwd $user
   echo ""; tput sgr0 ; tput setaf 2
   echo "Preconfiguracion correcta!"; tput sgr0 ; tput setaf 7
   #configVPS
}

installAll() {
echo ""; tput sgr0 ; tput setaf 7
read -p "Deseas escribir un nombre de usuario? [s/n]: " -e -i n UserResponse
if [[ "$UserResponse" = 's' ]]; then
   read -p "Usuario: " -e -i freehttp user
   read -p "Password: " -e -i 12345 pass
   preConfig
else
   user="freehttp"
   pass="12345"
   preConfig
fi

exit
}


echo "Seleccionar el tipo de configuración que desea instalar: "
echo "   1) v2ray"
echo "   2) hysteria2"
echo "   3) stunnel"
echo "   4) dropbear"
echo "   5) badVPN"
echo "   6) squid"
echo "   7) shadowsocks"
echo "   8) openVPN"
echo "   9) IKEv2"
echo "  10) Wireguard"
echo "  11) Extras"
echo "  12) Todo"
read -rp "Configuración [12]: " CONFIG_TYPE
until [[ -z "$CONFIG_TYPE" || "$CONFIG_TYPE" =~ ^[1-12]$ ]]; do
   echo "$CONFIG_TYPE: seleccion invalida."
   read -rp "Configuración [12]: " CONFIG_TYPE
done

if [[ "$CONFIG_TYPE" = '12' ]]; then
   installAll
else
   echo "Vas a instalar la configuración $CONFIG_TYPE"
fi