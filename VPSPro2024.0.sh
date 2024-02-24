tput setaf 7 ; tput setab 4 ; tput bold ; printf '%50s%s%-20s\n' "VPSPro Setup 2024.0 by Tenrimsos" ; tput sgr0

user=""
pass=""
host=""
vpsIP=""

echo ""; tput setaf 7

read -p "Deseas escribir un nombre de usuario? [s/n]: " -e -i n UserResponse
if [[ "$UserResponse" = 's' ]]; then
   read -p "Usuario: " -e -i freehttp user
   read -p "Password: " -e -i 12345 pass
   preConfig()
else
   user="freehttp"
   pass="12345"
   preConfig()
fi

preConfig() {
   #Preconfigurar el sistema
   echo ""; tput setaf 3 ; tput bold
   apt update -y
   apt install net-tools
   echo ""; tput setaf 3 ; tput bold
   # Agregando usuario ssh
   echo "Avregando usuario ssh"; tput sgr0 ; tput setaf 4
   useradd user
   passed user
   echo "Preconfiguracion correcta!"
   configVPS()
}

### [v2ray] ###
v2rayInstall() {
   # Instalar v2ray server
   echo ""; tput setaf 3 ; tput bold
   sudo apt install curl unzip
   echo "Descargando script"; tput sgr0 ; tput setaf 4
   curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
   # iniciar script
   echo "Ejecutando acript para instalar v2ray"; tput sgr0 ; tput setaf 4
   sudo bash install-release.sh
   #sudo systemctl status v2ray
   sudo systemctl restart v2ray
   sudo systemctl enable v2ray
   timedatectl
   echo "v2ray instalado correctamente"; tput sgr0 ; tput setaf 4
   # Editando /usr/local/etc/v2ray/config.json
   #
   wget -O /usr/local/etc/v2ray/config.json "https://raw.githubusercontent.com/tenrimsos/VPS2024pro/main/v2ray_config.json"
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Deseas agregar un ID diferente? [s/n]: " -e -i n v2rayIDResponse
   if [[ "$v2rayIDResponse" = 's' ]]; then
      read -p "ID: " -e -i a94a6d2e-97b3-42ec-af46-d6f67cedd3e2 v2rayID
      sed -i s/a94a6d2e-97b3-42ec-af46-d6f67cedd3e2/$v2rayID/g /usr/local/etc/v2ray/config.json
   else
      echo "Usando configuracion default"
   fi
   #
   sudo systemctl restart v2ray
   sudo ss -lnpt | grep v2ray
   # Instalando nginx
   sudo apt install nginx -y
   # Editando /etc/nginx/conf.d/v2ray.conf
   #
   echo "Escribe el host para firmar el certificado de conexion."
   read -p "Host: " -e -i example.com v2rayHost
   wget -O /etc/nginx/conf.d/v2ray.conf "https://raw.githubusercontent.com/tenrimsos/VPS2024pro/main/v2ray.conf"
   sed -i s/example.com/$v2rayHost/g /etc/nginx/conf.d/v2ray.conf
   #
   sudo nginx -t
   sudo systemctl reload nginx
   echo "nginx instalado correctamente"; tput sgr0 ; tput setaf 4
   # Instalando snapd
   sudo apt install snapd -y
   sudo snap install certbot --classic
   sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
   # Instalando certificado
   sudo /snap/bin/certbot --webroot -i nginx --agree-tos --hsts --staple-ocsp -d $host -w /usr/share/nginx/html/
   # Abriendo puertos
   echo "Abriendo puertos 80 y 443"; tput sgr0 ; tput setaf 4
   sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
   sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT
   echo "v2ray configurado correctamente"
}

### [hysteria2] ###
hysteria2Install() {
   # Instalar hysteria2 server
   echo ""; tput setaf 3 ; tput bold
   # Descargando script
   echo "Descargando script"; tput sgr0 ; tput setaf 4
   wget -N --no-check-certificate https://raw.githubusercontent.com/evozi/hysteria-install/main/hy2/hysteria2.sh && bash hysteria2.sh
   # Abriendo puerto
   echo "Abriendo puerto 9999"; tput sgr0 ; tput setaf 4
   iptables -A INPUT -p udp --dport 9999 -j ACCEPT
   # Ejecutando script
   echo "Ejecutando acript para instalar hysteria2"; tput sgr0 ; tput setaf 4
   bash hysteria2.sh
   echo "hysteria2 configurado correctamente"
}

### [stunnel] ###
stunnelInstall() {
   # Instalar stunnel
   echo ""; tput setaf 3 ; tput bold
   # Instalando stunnel
   apt-get install stunnel4
   echo "stunnel instalado correctamente"; tput sgr0 ; tput setaf 4
   # Crear certificado openssl
   openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -sha256 -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem
   echo "Certificado OpenSSL creado correctamente"; tput sgr0 ; tput setaf 4
   wget -O /etc/stunnel/stunnel.conf "https://www.dropbox.com/s/mugm9kgnqi2x3ty/stunnel.conf"
   # Editando /etc/stunnel/stunnel.conf
   #cert = /etc/stunnel/stunnel.pem
   #client = no
   #socket = a:SO_REUSEADDR=1
   #socket = l:TCP_NODELAY=1
   #socket = r:TCP_NODELAY=1
   #
   #[ssh]
   #accept = 143
   #connect = 127.0.0.1:444
   #
   #[squid]
   #accept = 8888
   #connect = 127.0.0.1:8080
   
   sed -i s/accept = 443/accept = 143/g /etc/stunnel/stunnel.conf
   
   #nano /etc/stunnel/stunnel.conf
   # Editando /etc/stunnel/stunnel4
   
   echo "ENABLED=1" >> /etc/stunnel/stunnel4
   
   #nano /etc/default/stunnel4
   stunnel /etc/stunnel/stunnel.conf
   echo "Abriendo puerto 143"; tput sgr0 ; tput setaf 4
   iptables -A INPUT -p tcp --dport 143 -j ACCEPT
   echo "stunnel configurado correctamente"
}

### [dropbear] ###
dropbearInstall() {
   # Instalar droobear
   echo ""; tput setaf 3 ; tput bold
   echo "Instalando dropbear"; tput sgr0 ; tput setaf 4
   sudo apt install dropbear
   # Editando /etc/default/dropbear
   cp /etc/default/dropbear /etc/default/dropbear.backup
	 sed -i s/NO_START=1/NO_START=0/g /etc/default/dropbear
	 sed -i s/DROPBEAR_PORT=22/DROPBEAR_PORT=444/g /etc/default/dropbear
	 sed -i s/DROPBEAR_EXTRA_ARGS=/'DROPBEAR_EXTRA_ARGS="-p 343"'/g /etc/default/dropbear
	 sed -i s/'DROPBEAR_BANNER=""'/'DROPBEAR_BANNER="\/etc\/issue.net"'/g /etc/default/dropbear
   #Reiniciando aervicio
   service dropbear start
   update-rc.d dropbear defaults
   service dropbear restart
   # Abriendo puerto
   echo "Abriendo puerto 444"; tput sgr0 ; tput setaf 4
   iptables -A INPUT -p tcp --dport 444 -j ACCEPT
   echo "dropbear configurado correctamente"
}

### [badVPN] ###
badVPNInstall() {
   # Instalar badVPN
   echo ""; tput setaf 3 ; tput bold
   apt-get install screen -y
   # Descargando script
   echo "Descargando script"; tput sgr0 ; tput setaf 4
   wget -O /usr/bin/badvpn-udpgw "https://www.dropbox.com/s/zjuytljwn95tp5l/badvpn-udpgw64"
   chmod +x /usr/bin/badvpn-udpgw
   badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/nul &
   echo "BadVPN configurado correctamente"
}

### [squid] ###
squidInstall() {
   # Instalar squid
   echo ""; tput setaf 3 ; tput bold
   echo "Instalando squid proxy"; tput sgr0 ; tput setaf 4
   sudo apt install squid
   cp /etc/squid/squid.conf /etc/squid/squid.conf.bak
   rm /etc/squid/squid.conf
   
   # Editando /etc/squid/squid.conf
   ip=$(wget -qO - icanhazip.com)

   echo "# PUERTOS DE ACCESO A SQUID" > /etc/squid/squid.conf
   echo "http_port 8080" >> /etc/squid/squid.conf
   echo "" >> /etc/squid/squid.conf
   echo "" >> /etc/squid/squid.conf
   echo "# NOMBRE DEL SERVIDOR" >> /etc/squid/squid.conf
   echo "visible_hostname PremiumProxy" >> /etc/squid/squid.conf
   echo "" >> /etc/squid/squid.conf
   echo "" >> /etc/squid/squid.conf
   echo "# ACL DE CONEXION" >> /etc/squid/squid.conf
   echo "#acl accept src $ip" >> /etc/squid/squid.conf
   echo "#acl ip url_regex -i $ip" >> /etc/squid/squid.conf
   echo "" >> /etc/squid/squid.conf
   echo "acl adminports port 8080" >> /etc/squid/squid.conf
   echo "acl userports port 8080" >> /etc/squid/squid.conf
   echo "" >> /etc/squid/squid.conf
   echo "acl ip src $ip" >> /etc/squid/squid.conf
   echo "acl ipregex url_regex -i $ip" >> /etc/squid/squid.conf
   echo "" >> /etc/squid/squid.conf
   echo "auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/authusers" >> /etc/squid/squid.conf
   echo "acl Admins proxy_auth locobyte tenrimsos" >> /etc/squid/squid.conf
   echo "acl Users proxy_auth jonjon jrh janet premiumhttp" >> /etc/squid/squid.conf 
   echo "" >> /etc/squid/squid.conf
   echo "" >> /etc/squid/squid.conf
   echo "# ACESSOS ACL" >> /etc/squid/squid.conf
   echo "#http_access allow accept" >> /etc/squid/squid.conf
   echo "#http_access allow ip"  >> /etc/squid/squid.conf
   echo "http_access allow ipregex Admins" >> /etc/squid/squid.conf
   echo "http_access allow ipregex Users"  >> /etc/squid/squid.conf
   echo "http_access allow !ipregex Admins"  >> /etc/squid/squid.conf
   echo "http_access deny all" >> /etc/squid/squid.conf
   echo "cache deny all" >> /etc/squid/squid.conf
   
   useradd $user
   echo -e "$pass\n$pass\n" | sudo  passwd $user

   echo ""; tput sgr0 ; tput setaf 7
   read -p "Deseas agregar autentificación al proxy? [s/n]: " -e -i n AuthResponse
   if [[ "$AuthResponse" = 's' ]]; then
      echo ""; tput sgr0 ; tput setaf 2
      echo "Agregando usuario proxy..."

      htpasswd -b -c /etc/squid/authusers userdd passwd
      systemctl start squid.service

      echo ""; tput sgr0 ; tput setaf 2
      echo "Autentificacion agregada correctamente!"
   else
      echo ""; tput sgr0 ; tput setaf 3
      echo "Proxy no seguro!"
   fi
   
   # Abriendo puerto
   echo "Abriendo puerto 8080"; tput sgr0 ; tput setaf 4
   sudo iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
   echo "squid configurado correctamente"
}

### [Shadowsocks] ###
shadowsocksInstall() {
   # Instalar shadowsocks
   sudo apt install shadowsocks-libev -y
   # Editando /etc/shadowsocks-libev/config.json
   # https://www.dropbox.com/scl/fi/pmi9uenkk4x7ndfbch5ws/shadowsocks_config.json
   #
   #
   echo "Escribe la IP para el servicio shadowsocks"
   read -p "IP: " -e -i 127.0.0.1 shadowsocksIP
   wget -O /etc/shadowsocks-libev/config.json "https://raw.githubusercontent.com/tenrimsos/VPS2024pro/main/shadowsocks_config.json"
   sed -i s/myip/$shadowsocksIP/g /etc/shadowsocks-libev/config.json
   sudo systemctl start shadowsocks-libev.service
   sudo systemctl enable shadowsocks-libev.service
   # Abriendo puertos
   echo "Abriendo puerto 8388 tcp y udp"; tput sgr0 ; tput setaf 4
   sudo iptables -I INPUT -p tcp --dport 8388 -j ACCEPT
   sudo iptables -I INPUT -p udp --dport 8388 -j ACCEPT
   echo "shadowsocks configurado correctamente"
}

### [OpenVPN] ###
openVPNInstall() {
   # Instalar OpenVPN
   echo "Descargando script"; tput sgr0 ; tput setaf 4
   curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
   chmod +x openvpn-install.sh
   echo "Ejecutando script para instalar OpenVPN"; tput sgr0 ; tput setaf 4
   ./openvpn-install.sh
   # Abriendo puertos
   echo "Abriendo puerto 1194"; tput sgr0 ; tput setaf 4
   iptables -A INPUT -p udp --dport 1194 -j ACCEPT
   iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
   # Ejecutando servidor web
   echo "Ejecutando servidor web para descargar configuracion del cliente..."; tput sgr0 ; tput setaf 4
   cd /root && python3 -m http.server
   echo "OpenVPN configurado correctamente"
}

### [StrongSwam IKEv2] ###
strongswamInstall() {
   # Instalar StrongSwam IKEv2
   echo "Descargando script"; tput sgr0 ; tput setaf 4
   wget https://get.vpnsetup.net -O vpn.sh
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Deseas definir los valores de instalacion? [s/n]: " -e -i n strongswamResponse
   if [[ "$strongswamResponse" = 's' ]]; then
      echo "Ejecutando script para instalar StrongSwam IKEv2"; tput sgr0 ; tput setaf 4
      echo ""
      read -p "VPN_IPSEC_PSK: " -e -i vpnipsecaea0085b2024 sVPN_IPSEK_PSK
      read -p "VPN_USER: " -e -i freehttp sVPN_USER
      read -p "VPN_PASSWORD: " -e -i Free.098 sVPN_PASS
      
      sudo VPN_IPSEC_PSK="$sVPN_IPSEK_PSK" \
      VPN_USER="$sVPN_USER" \
      VPN_PASSWORD="$sVPN_PASS" \
      sh vpn.sh
   else
      echo "Ejecutando script para instalar StrongSwam IKEv2"; tput sgr0 ; tput setaf 4
      sudo sh vpn.sh
   fi
   
   # Ejecutando servidor web
   echo "Ejecutando servidor web para descargar configuracion del cliente..."; tput sgr0 ; tput setaf 4
   cd /root && python3 -m http.server
   echo "StrongSwam IKEv2 configurado correctamente"
}


### [Wireguard] ###
wireguardInstall() {
   # Instalar Wireguard server
   echo "Descargando script"; tput sgr0 ; tput setaf 4
   wget -O wireguard.sh https://get.vpnsetup.net/wg
   echo "Ejecutando script para instalar StrongSwam IKEv2"; tput sgr0 ; tput setaf 4
   sudo bash wireguard.sh --auto
   echo "Wireguard configurado correctamente"
}

### Configurando VPS ###
configVPS() {
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Deseas editar el banner? [s/n]: " -e -i n BannerResponse
   if [[ "$BannerResponse" = 's' ]]; then
      echo ""; tput setaf 2 ; tput sgr0
      echo "Editando banners..."
      echo "Editando /etc/issue.net..."
      nano /etc/issue.net
   else
      echo ""
   fi
   
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Deseas editar el inicio? [s/n]: " -e -i n motdResponse
   if [[ "$motdResponse" = 's' ]]; then
      echo ""; tput setaf 2 ; tput sgr0
      echo "Editando motd..."
      echo "Editando /etc/motd..."
      nano /etc/motd
   else
      echo "VPS personal para internet libre." >> /etc/motd
      echo "Sin saldo o redes." >> /etc/motd
      echo "" >> /etc/motd
      echo "" >> /etc/motd
   fi
   
   read -p "Instalar v2ray? [s/n]: " -e -i n v2rayIresponse
   if [[ "$v2rayIresponse" = 's' ]]; then
      v2rayInstall()
   fi
   read -p "Instalar hysteria2? [s/n]: " -e -i n hysteria2Iresponse
   if [[ "$hysteria2Iresponse" = 's' ]]; then
      hysteria2Install()
   fi
   read -p "Instalar stunnel? [s/n]: " -e -i n stunnelIresponse
   if [[ "$stunnelIresponse" = 's' ]]; then
      stunnelInstall()
   fi
   read -p "Instalar dropbear? [s/n]: " -e -i n dropbearIresponse
   if [[ "$dropbearIresponse" = 's' ]]; then
      droobearInstall()
   fi
   read -p "Instalar BadVPN? [s/n]: " -e -i n badVPNIresponse
   if [[ "$badVPNIresponse" = 's' ]]; then
      badVPNInstall()
   fi
   read -p "Instalar squid? [s/n]: " -e -i n squidIresponse
   if [[ "$squidIresponse" = 's' ]]; then
      squidInstall()
   fi
   read -p "Instalar shadowsocks? [s/n]: " -e -i n shadowsocksIresponse
   if [[ "$shadowsocksIresponse" = 's' ]]; then
      shadowsocksInstall()
   fi
   read -p "Instalar OpenVPN? [s/n]: " -e -i n openVPNIresponse
   if [[ "$openVPNIresponse" = 's' ]]; then
      openVPNInstall()
   fi
   read -p "Instalar StrongSwam? [s/n]: " -e -i n strongswamIresponse
   if [[ "$strongswamIresponse" = 's' ]]; then
      strongswamInstall()
   fi
   read -p "Instalar Wireguard? [s/n]: " -e -i n wireguardIresponse
   if [[ "$wireguardIresponse" = 's' ]]; then
      wireguardInstall()
   fi


   echo ""
   sleep 3
   echo "Reiniciando servicios..."
   stunnel /etc/stunnel/stunnel.conf
   service dropbear restart
   systemctl restart squid
   echo ""
   echo "VPS configurada correctamente!"
}


echo "$user:$pass"
echo "SSH: 22" 
echo "Dropbear: 444"
echo "BadVPN: 3700"
echo "Auth: $user:$pass"
echo "Proxy: 8080"
echo "TLS/SSL: 143"
echo "v2ray: 443"
echo "Hysteria2: 9999"
echo "shadowsocks: 8388"
echo "OpenVPN: "
echo "IKEv2: "
echo "Wireguard: "
echo ""; tput sgr0
exit
