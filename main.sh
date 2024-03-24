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
   choiceInstalation
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


echo "Selecciona las configuraciones que deseas instalar. Separa los números con espacios:"
opciones=("v2ray" "hysteria2" "stunnel" "dropbear" "squid" "BadVPN" "shadowsocks+obfs" "OpenVPN" "IKEv2" "Wireguard" "Extras" "Instalar Todo" "Finalizar y Salir")
seleccionadas=()

while true; do
    # Mostrar opciones que no han sido seleccionadas
    for i in "${!opciones[@]}"; do
        if [[ ! " ${seleccionadas[@]} " =~ " ${opciones[$i]} " ]]; then
            echo "$((i+1))) ${opciones[$i]}"
        fi
    done

    read -p "Introduce las opciones seleccionadas: " input
    # Dividir el input en un array
    elegidos=($input)

    for elegido in "${elegidos[@]}"; do
        # Restar 1 porque el array comienza en 0
        indice=$((elegido-1))

        # Verificar si la opción es válida y no ha sido seleccionada previamente
        if [[ $indice -ge 0 && $indice -lt ${#opciones[@]} && ! " ${seleccionadas[@]} " =~ " ${opciones[$indice]} " ]]; then
            seleccionadas+=("${opciones[$indice]}")
            echo "Has seleccionado: ${opciones[$indice]}"
            # Aquí irían los comandos para instalar la configuración seleccionada
            case $opciones[$indice] in
				        1)
				            echo "Instalando v2ray..."
				            # Comandos para instalar v2ray
				            ;;
				        2)
				            echo "Instalando hysteria2..."
				            # Comandos para instalar hysteria2
				            ;;
				        3)
				            echo "Instalando stunnel..."
				            # Comandos para instalar stunnel
				            ;;
				        4)
				            echo "Instalando dropbear..."
				            # Comandos para instalar dropbear
				            ;;
				        5)
				            echo "Instalando squid..."
				            # Comandos para instalar squid
				            ;;
				        6)
				            echo "Instalando BadVPN..."
				            # Comandos para instalar BadVPN 
				            ;;
				        7)
				            echo "Instalando shadowsocks+obfs..."
				            # Comandos para instalar shadowsocks+obfs
				            ;;
				        8)
				            echo "Instalando OpenVPN..."
				            # Comandos para instalar OpenVPN
				            ;;
				        9)
				            echo "Instalando IKEv2..."
				            # Comandos para instalar IKEv2
				            ;;
				        10)
				            echo "Instalando Wireguard..."
				            # Comandos para instalar Wireguard
				            ;;
				        11)
				            echo "Instalando Extras..."
				            # Comandos para instalar extras
				            ;;
				        12)
				            echo "Instalando todos los servicios..."
				            # Comandos para instalar todo
				            installAll
				            ;;
				        13)
				            echo "Saliendo del programa..."
				            ;;
				    esac
        elif [[ $elegido -eq ${#opciones[@]} ]]; then
            echo "Finalizando selección..."
            break 2
        else
            echo "Opción no válida o ya seleccionada: $elegido"
        fi
    done
done

echo "Instalación completa."




