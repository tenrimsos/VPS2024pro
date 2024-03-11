tput setaf 7 ; tput setab 4 ; tput bold ; printf '%50s%s%-20s\n' "VPSPro Setup 2024.5 by Tenrimsos" ; tput sgr0

user=""
pass=""
host=""
ip=""
wireguardExist=""

preConfig() {
   #Preconfigurar el sistema
   echo ""; tput sgr0 ; tput setaf 7
   sudo apt update -y
   sudo apt install net-tools -y
   sudo apt-get install apache2-utils -y
   # Agregando usuario ssh
   echo ""; tput sgr0 ; tput setaf 4
   echo "Agregando usuario ssh"; tput sgr0 ; tput setaf 7
   useradd $user
   passwd $user
   echo ""; tput sgr0 ; tput setaf 2
   echo "Preconfiguracion correcta!"; tput sgr0 ; tput setaf 7
   configVPS
}

### [v2ray] ###
v2rayInstall() {
   # Instalar v2ray server
   echo ""; tput sgr0 ; tput setaf 7
   sudo apt install curl unzip -y
   echo ""; tput sgr0 ; tput setaf 4
   echo "Descargando script"; tput sgr0 ; tput setaf 7
   curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
   # iniciar script
   echo ""; tput sgr0 ; tput setaf 4
   echo "Ejecutando acript para instalar v2ray"; tput sgr0 ; tput setaf 7
   sudo bash install-release.sh
   #sudo systemctl status v2ray
   sudo systemctl restart v2ray
   sudo systemctl enable v2ray
   timedatectl
   
   #sudo apt install curl unzip
   #curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
   #sudo bash install-release.sh
   #sudo systemctl status v2ray
   #sudo systemctl restart v2ray
   #sudo systemctl enable v2ray
   #timedatectl
   #sudo nano /usr/local/etc/v2ray/config.json
   #sudo systemctl restart v2ray
   #sudo ss -lnpt | grep v2ray
   #sudo apt install nginx
   #sudo nano /etc/nginx/conf.d/v2ray.conf
   #sudo nginx -t
   #sudo systemctl reload nginx
   #sudo apt install snapd
   #sudo snap install certbot --classic
   #sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
   #sudo /snap/bin/certbot --webroot -i nginx --agree-tos --hsts --staple-ocsp -d svv2ray.shop -w /usr/share/nginx/html/
   #sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT

   echo ""; tput sgr0 ; tput setaf 4
   echo "v2ray instalado correctamente"; tput sgr0 ; tput setaf 7
   #
   # Editando /usr/local/etc/v2ray/config.json
   #
   wget -O /usr/local/etc/v2ray/config.json "https://raw.githubusercontent.com/tenrimsos/VPS2024pro/main/v2ray_config.json"
   read -p "Deseas agregar un ID diferente? [s/n]: " -e -i n v2rayIDResponse
   if [[ "$v2rayIDResponse" = 's' ]]; then
      read -p "ID: " -e -i a94a6d2e-97b3-42ec-af46-d6f67cedd3e2 v2rayID
      sed -i s/a94a6d2e-97b3-42ec-af46-d6f67cedd3e2/$v2rayID/g /usr/local/etc/v2ray/config.json
   else
      echo ""; tput sgr0 ; tput setaf 4
      echo "Usando configuracion default"; tput sgr0 ; tput setaf 7
   fi
   #
   sudo systemctl restart v2ray
   sudo ss -lnpt | grep v2ray
   # Instalando nginx
   sudo apt install nginx -y
   #
   # Editando /etc/nginx/conf.d/v2ray.conf
   #
   echo "Escribe el host para firmar el certificado de conexion."
   read -p "Host: " -e -i example.com v2rayHost
   wget -O /etc/nginx/conf.d/v2ray.conf "https://raw.githubusercontent.com/tenrimsos/VPS2024pro/main/v2ray.conf"
   sudo sed -i s/example.com/$v2rayHost/g /etc/nginx/conf.d/v2ray.conf
   #
   sudo nginx -t
   sudo systemctl reload nginx
   echo ""; tput sgr0 ; tput setaf 4
   echo "nginx instalado correctamente"; tput sgr0 ; tput setaf 7
   # Instalando snapd
   sudo apt install snapd -y
   sudo snap install certbot --classic
   sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
   # Instalando certificado
   sudo /snap/bin/certbot --webroot -i nginx --agree-tos --hsts --staple-ocsp -d $v2rayHost -w /usr/share/nginx/html/
   # Abriendo puertos
   echo ""; tput sgr0 ; tput setaf 4
   echo "Abriendo puertos 80 y 443"
   sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
   sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT
   echo ""; tput sgr0 ; tput setaf 2
   echo "v2ray configurado correctamente"; tput sgr0 ; tput setaf 7
}

### [Certbot] ###
certbotInstall() {
   echo ""; tput sgr0 ; tput setaf 7
   echo "Escribe el host para firmar el certificado de conexion."
   read -p "Host: " -e -i example.com certbotHost
   
   echo ""; tput sgr0 ; tput setaf 4
   echo "Instaando certificado"
   echo ""; tput sgr0 ; tput setaf 7
   # Instalando certificado
   sudo /snap/bin/certbot --webroot -i nginx --agree-tos --hsts --staple-ocsp -d $certbotHost -w /usr/share/nginx/html/
   echo ""; tput sgr0 ; tput setaf 2
   echo "Certificafo (certbot) instalado correctamente"; tput sgr0 ; tput setaf 7
}

### [hysteria2] ###
hysteria2Install() {
   # Instalar hysteria2 server
   echo ""; tput sgr0 ; tput setaf 7
   # Descargando script
   wget -N --no-check-certificate https://raw.githubusercontent.com/evozi/hysteria-install/main/hy2/hysteria2.sh
   # Abriendo puerto
   echo ""; tput sgr0 ; tput setaf 4
   echo "Abriendo puerto 9999"; tput sgr0 ; tput setaf 4
   sudo iptables -A INPUT -p udp --dport 9999 -j ACCEPT
   # Ejecutando script
   echo "Ejecutando acript para instalar hysteria2"; tput sgr0 ; tput setaf 7
   sudo bash hysteria2.sh
   echo ""; tput sgr0 ; tput setaf 2
   echo "hysteria2 configurado correctamente"; tput sgr0 ; tput setaf 7
}

### [stunnel] ###
stunnelInstall() {
   # Instalar stunnel
   echo ""; tput sgr0 ; tput setaf 7
   # Instalando stunnel
   sudo apt-get install stunnel4 -y
   echo ""; tput sgr0 ; tput setaf 4
   echo "stunnel instalado correctamente"; tput sgr0 ; tput setaf 7
   # Crear certificado openssl
   sudo openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -sha256 -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem
   echo ""; tput sgr0 ; tput setaf 4
   echo "Certificado OpenSSL creado correctamente"; tput sgr0 ; tput setaf 7
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
   
   sudo sed -i s/443/143/g /etc/stunnel/stunnel.conf
   
   #nano /etc/stunnel/stunnel.conf
   # Editando /etc/default/stunnel4
   
   echo "ENABLED=1" >> /etc/default/stunnel4
   
   #nano /etc/default/stunnel4
   stunnel /etc/stunnel/stunnel.conf
   echo ""; tput sgr0 ; tput setaf 4
   echo "Abriendo puerto 143"; tput sgr0 ; tput setaf 7
   iptables -A INPUT -p tcp --dport 143 -j ACCEPT
   echo ""; tput sgr0 ; tput setaf 2
   echo "stunnel configurado correctamente"; tput sgr0 ; tput setaf 7
}

### [dropbear] ###
dropbearInstall() {
   # Instalar droobear
   echo ""; tput sgr0 ; tput setaf 7
   sudo apt install dropbear -y
   # Editando /etc/default/dropbear
   cp /etc/default/dropbear /etc/default/dropbear.backup
	 sed -i s/NO_START=1/NO_START=0/g /etc/default/dropbear
	 sed -i s/DROPBEAR_PORT=22/DROPBEAR_PORT=444/g /etc/default/dropbear
	 #sed -i s/DROPBEAR_EXTRA_ARGS=/'DROPBEAR_EXTRA_ARGS="-p 343"'/g /etc/default/dropbear
	 sed -i s/'DROPBEAR_BANNER=""'/'DROPBEAR_BANNER="\/etc\/issue.net"'/g /etc/default/dropbear
   #Reiniciando aervicio
   service dropbear start
   update-rc.d dropbear defaults
   service dropbear restart
   # Abriendo puerto
   echo ""; tput sgr0 ; tput setaf 4
   echo "Abriendo puerto 444"; tput sgr0 ; tput setaf 7
   iptables -A INPUT -p tcp --dport 444 -j ACCEPT
   echo ""; tput sgr0 ; tput setaf 2
   echo "dropbear configurado correctamente"; tput sgr0 ; tput setaf 7
}

### [badVPN] ###
badVPNInstall() {
   # Instalar badVPN
   echo ""; tput sgr0 ; tput setaf 7
   apt-get install screen -y
   # Descargando script
   echo ""; tput sgr0 ; tput setaf 4
   echo "Descargando script"; tput sgr0 ; tput setaf 7
   wget -O /usr/bin/badvpn-udpgw "https://www.dropbox.com/s/zjuytljwn95tp5l/badvpn-udpgw64"
   chmod +x /usr/bin/badvpn-udpgw
   badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/null &
   echo ""; tput sgr0 ; tput setaf 2
   echo "BadVPN configurado correctamente"; tput sgr0 ; tput setaf 7
}

### [squid] ###
squidInstall() {
   # Instalar squid
   echo ""; tput sgr0 ; tput setaf 7
   sudo apt install squid -y
   cp /etc/squid/squid.conf /etc/squid/squid.conf.bak
   rm /etc/squid/squid.conf
   
   # Obtener IP del servidor
   ip=$(wget -qO - icanhazip.com)
   
   #useradd $user
   #echo -e "$pass\n$pass\n" | sudo  pass $user
   
   # Abriendo puerto
   echo ""; tput sgr0 ; tput setaf 4
   echo "Abriendo puerto 8080"; tput sgr0 ; tput setaf 7
   sudo iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
   
   # Configurando squid
   squidConfig
}

squidConfig() {
   # Obtener IP del servidor
   ip=$(wget -qO - icanhazip.com)
   poxyUser=""
   proxyPass=""
   
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Deseas agregar autentificación al proxy? [s/n]: " -e -i n AuthResponse
   if [[ "$AuthResponse" = 's' ]]; then
      echo ""; tput sgr0 ; tput setaf 4
      echo "Agregando usuario proxy..."; tput sgr0 ; tput setaf 7
      
      # Leer los valores de autentificacion del proxy
      if [[ "$user" != '' ]]; then
         read -p "Usuario: " -e -i $user proxyUser
         read -p "Password: " -e -i $pass proxyPass
      else
         read -p "Usuario: " -e -i freehttp proxyUser
         read -p "Password: " -e -i free.098 proxyPass
      fi
      
      # Agregar valores de autentificacion d3l proxy
      htpasswd -b -c /etc/squid/authusers $proxyUser $proxyPass
      systemctl start squid.service
      
      # Editando /etc/squid/squid.conf
      echo "# PUERTOS DE ACCESO A SQUID" > /etc/squid/squid.conf
      echo "http_port 8080" >> /etc/squid/squid.conf
      echo "" >> /etc/squid/squid.conf
      echo "# NOMBRE DEL SERVIDOR" >> /etc/squid/squid.conf
      echo "visible_hostname PremiumProxy" >> /etc/squid/squid.conf
      echo "" >> /etc/squid/squid.conf
      echo "# ACL DE CONEXION" >> /etc/squid/squid.conf
      echo "acl localhost src 127.0.0.1/32 ::1" >> /etc/squid/squid.conf
      echo "acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1" >> /etc/squid/squid.conf
      echo "acl SSL_ports port 443 143" >> /etc/squid/squid.conf
      echo "" >> /etc/squid/squid.conf
      echo "acl CONNECT method CONNECT" >> /etc/squid/squid.conf
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
      echo "# ACESSOS ACL" >> /etc/squid/squid.conf
      echo "#http_access allow accept" >> /etc/squid/squid.conf
      echo "#http_access allow ip"  >> /etc/squid/squid.conf
      echo "http_access allow ipregex Admins" >> /etc/squid/squid.conf
      echo "http_access allow ipregex Users"  >> /etc/squid/squid.conf
      echo "http_access allow !ipregex Admins"  >> /etc/squid/squid.conf
      echo "http_access deny all" >> /etc/squid/squid.conf
      echo "cache deny all" >> /etc/squid/squid.conf

      echo ""; tput sgr0 ; tput setaf 4
      echo "Autentificacion agregada correctamente!"; tput sgr0 ; tput setaf 7
   else
      # Editando /etc/squid/squid.conf
      echo "# PUERTOS DE ACCESO A SQUID" > /etc/squid/squid.conf
      echo "http_port 8080" >> /etc/squid/squid.conf
      echo "" >> /etc/squid/squid.conf
      echo "# NOMBRE DEL SERVIDOR" >> /etc/squid/squid.conf
      echo "visible_hostname PremiumProxy" >> /etc/squid/squid.conf
      echo "" >> /etc/squid/squid.conf
      echo "# ACL DE CONEXION" >> /etc/squid/squid.conf
      echo "acl ip src $ip" >> /etc/squid/squid.conf
      echo "acl ipregex url_regex -i $ip" >> /etc/squid/squid.conf
      echo "" >> /etc/squid/squid.conf
      echo "# ACESSOS ACL" >> /etc/squid/squid.conf
      echo "http_access allow all"  >> /etc/squid/squid.conf
      echo "cache allow all" >> /etc/squid/squid.conf
      
      echo ""; tput sgr0 ; tput setaf 3
      echo "Proxy no seguro!"; tput sgr0 ; tput setaf 7
   fi
   
   #systemctl restart squid.service
   echo ""; tput sgr0 ; tput setaf 2
   echo "squid configurado correctamente"; tput sgr0 ; tput setaf 7
}

### [Shadowsocks] ###
shadowsocksInstall() {
   # Instalar shadowsocks
   echo ""; tput sgr0 ; tput setaf 7
   sudo apt install shadowsocks-libev -y
   # Editando /etc/shadowsocks-libev/config.json
   # https://www.dropbox.com/scl/fi/pmi9uenkk4x7ndfbch5ws/shadowsocks_config.json
   #
   #
   echo ""; tput sgr0 ; tput setaf 4
   echo "Escribe la IP para el servicio shadowsocks"; tput sgr0 ; tput setaf 7
   read -p "IP: " -e -i $ip shadowsocksIP
   wget -O /etc/shadowsocks-libev/config.json "https://raw.githubusercontent.com/tenrimsos/VPS2024pro/main/shadowsocks_config.json"
   sed -i s/myip/$shadowsocksIP/g /etc/shadowsocks-libev/config.json
   sudo systemctl start shadowsocks-libev.service
   sudo systemctl enable shadowsocks-libev.service
   sudo systemctl restart shadowsocks-libev.service
   # Abriendo puertos
   echo ""; tput sgr0 ; tput setaf 4
   echo "Abriendo puerto 8388 tcp y udp"; tput sgr0 ; tput setaf 7
   sudo iptables -I INPUT -p tcp --dport 8388 -j ACCEPT
   sudo iptables -I INPUT -p udp --dport 8388 -j ACCEPT
   echo ""; tput sgr0 ; tput setaf 2
   echo "shadowsocks configurado correctamente"; tput sgr0 ; tput setaf 7
}

### [OpenVPN] ###
openVPNInstall() {
   # Instalar OpenVPN
   echo ""; tput sgr0 ; tput setaf 7
   curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
   chmod +x openvpn-install.sh
   echo ""; tput sgr0 ; tput setaf 4
   echo "Ejecutando script para instalar OpenVPN"; tput sgr0 ; tput setaf 7
   ./openvpn-install.sh
   # Abriendo puertos
   echo ""; tput sgr0 ; tput setaf 4
   echo "Abriendo puerto 1194"; tput sgr0 ; tput setaf 7
   iptables -A INPUT -p udp --dport 1194 -j ACCEPT
   iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
   # Ejecutando servidor web
   echo ""; tput sgr0 ; tput setaf 6
   echo "Ejecutando servidor web para descargar configuracion del cliente..."
   python3 -m http.server
   echo ""; tput sgr0 ; tput setaf 2
   echo "OpenVPN configurado correctamente"; tput sgr0 ; tput setaf 7
}

### [StrongSwam IKEv2] ###
strongswamInstall() {
   # Instalar StrongSwam IKEv2
   echo ""; tput sgr0 ; tput setaf 7
   wget https://get.vpnsetup.net -O vpn.sh
   read -p "Deseas definir los valores de instalacion? [s/n]: " -e -i n strongswamResponse
   if [[ "$strongswamResponse" = 's' ]]; then
      echo ""; tput sgr0 ; tput setaf 4
      echo "Ejecutando script para instalar StrongSwam IKEv2"; tput sgr0 ; tput setaf 7
      echo ""
      read -p "VPN_IPSEC_PSK: " -e -i vpnipsecaea0085b2024 sVPN_IPSEK_PSK
      read -p "VPN_USER: " -e -i freehttp sVPN_USER
      read -p "VPN_PASSWORD: " -e -i Free.098 sVPN_PASS
      
      sudo VPN_IPSEC_PSK="$sVPN_IPSEK_PSK" \
      VPN_USER="$sVPN_USER" \
      VPN_PASSWORD="$sVPN_PASS" \
      sh vpn.sh
   else
      echo ""; tput sgr0 ; tput setaf 4
      echo "Ejecutando script para instalar StrongSwam IKEv2"; tput sgr0 ; tput setaf 7
      sudo sh vpn.sh
   fi
   
   #Cambiando nombre de clientes con el user
   cp /root/vpnclient.sswan $sVPN_USER.sswan
   cp /root/vpnclient.p12 $sVPN_USER.p12
   cp /root/vpnclient.mobileconfig $sVPN_USER.mobileconfig
   
   # Ejecutando servidor web
   echo ""; tput sgr0 ; tput setaf 6
   echo "Ejecutando servidor web para descargar configuracion del cliente..."
   python3 -m http.server
   echo ""; tput sgr0 ; tput setaf 2
   echo "StrongSwam IKEv2 configurado correctamente"; tput sgr0 ; tput setaf 7
}


### [Wireguard] ###
wireguardInstall() {
   # Instalar Wireguard server
   echo ""; tput sgr0 ; tput setaf 7
   wget -O wireguard.sh https://get.vpnsetup.net/wg
   
   wireguardExist=$(ss -lnpt | grep wireguard)
   if [[ "$user" = '' ]]; then
      user="client"
   fi
   
   echo $wireguardExist
   
   #if [[ "$wireguardExist" = '' ]]; then
   if [[ ! -e /etc/wireguard/wg0.conf ]]; then
      read -p "Deseas definir los valores de instalacion? [s/n]: " -e -i n wireguardResponse
      if [[ "$wireguardResponse" = 's' ]]; then
         echo ""; tput sgr0 ; tput setaf 4
         echo "Ejecutando script para instalar StrongSwam IKEv2"; tput sgr0 ; tput setaf 7
         echo
         #sudo bash wireguard.sh <<ANSWERS n 41194 freehttp 2 y ANSWERS
         #sudo bash wireguard.sh
         read -p "Cliente: " -e -i $user WIREGUARD_USER
         read -p "Puerto: " -e -i 41194 WIREGUARD_PORT
         
         echo "Seleccionar a DNS server para el cliente:"
         echo "   1) Current system resolvers"
         echo "   2) Google Public DNS"
         echo "   3) Cloudflare DNS"
         echo "   4) OpenDNS"
         echo "   5) Quad9"
         echo "   6) AdGuard DNS"
         echo "   7) Custom"
         read -rp "DNS server [3]: " WIREGUARD_DNS
         until [[ -z "$WIREGUARD_DNS" || "$WIREGUARD_DNS" =~ ^[1-7]$ ]]; do
            echo "$WIREGUARD_DNS: seleccion invalida."
            read -rp "DNS server [3]: " WIREGUARD_DNS
         done
         
         #sudo bash wireguard.sh <<ANSWERS 
         #n
         #$WIREGUARD_PORT
         #$WIREGUARD_USER
         #$WIREGUARD_DNS
         #y 
         #ANSWERS
         
         #Ejecutar script con los parametros definidos
         printf '%s\n' N $WIREGUARD_PORT $WIREGUARD_USER $WIREGUARD_DNS Y | sudo bash wireguard.sh
         
         #Copiar archivo de configuracion
         mv /root/$WIREGUARD_USER.conf $WIREGUARD_USER.conf
      else
         echo ""; tput sgr0 ; tput setaf 4
         echo "Ejecutando script para instalar StrongSwam IKEv2"; tput sgr0 ; tput setaf 7
         sudo bash wireguard.sh --auto
      
         mv /root/client.conf client.conf
      fi
      
      # Ejecutando servidor web
      echo ""; tput sgr0 ; tput setaf 6
      echo "Ejecutando servidor web para descargar configuracion del cliente..."
      python3 -m http.server
   else
      sudo bash wireguard.sh
   fi
   
   echo ""; tput sgr0 ; tput setaf 2
   echo "Wireguard configurado correctamente"; tput sgr0 ; tput setaf 7
}

### Configurando VPS ###
configVPS() {
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Deseas editar el banner? [s/n]: " -e -i n BannerResponse
   if [[ "$BannerResponse" = 's' ]]; then
      echo ""; tput sgr0 ; tput setaf 4
      echo "Editando /etc/issue.net"; tput sgr0 ; tput setaf 4
      nano /etc/issue.net
   else
      echo ""; tput sgr0 ; tput setaf 7
   fi
   
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Deseas editar el inicio? [s/n]: " -e -i n motdResponse
   if [[ "$motdResponse" = 's' ]]; then
      echo ""; tput sgr0 ; tput setaf 4
      echo "Editando /etc/motd"
      nano /etc/motd
   else
      echo "VPS personal para internet libre." >> /etc/motd
      echo "Sin saldo o redes." >> /etc/motd
      echo "" >> /etc/motd
      echo "" >> /etc/motd
      echo ""; tput sgr0 ; tput setaf 7
   fi
   
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Instalar v2ray? [s/n]: " -e -i n v2rayIresponse
   if [[ "$v2rayIresponse" = 's' ]]; then
      v2rayInstall
   fi
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Instalar hysteria2? [s/n]: " -e -i n hysteria2Iresponse
   if [[ "$hysteria2Iresponse" = 's' ]]; then
      hysteria2Install
   fi
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Instalar stunnel? [s/n]: " -e -i n stunnelIresponse
   if [[ "$stunnelIresponse" = 's' ]]; then
      stunnelInstall
   fi
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Instalar dropbear? [s/n]: " -e -i n dropbearIresponse
   if [[ "$dropbearIresponse" = 's' ]]; then
      dropbearInstall
   fi
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Instalar BadVPN? [s/n]: " -e -i n badVPNIresponse
   if [[ "$badVPNIresponse" = 's' ]]; then
      badVPNInstall
   fi
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Instalar squid? [s/n]: " -e -i n squidIresponse
   if [[ "$squidIresponse" = 's' ]]; then
      squidInstall
      systemctl restart squid.service
   fi
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Instalar shadowsocks? [s/n]: " -e -i n shadowsocksIresponse
   if [[ "$shadowsocksIresponse" = 's' ]]; then
      shadowsocksInstall
   fi
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Instalar OpenVPN? [s/n]: " -e -i n openVPNIresponse
   if [[ "$openVPNIresponse" = 's' ]]; then
      openVPNInstall
   fi
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Instalar StrongSwam IKEv2? [s/n]: " -e -i n strongswamIresponse
   if [[ "$strongswamIresponse" = 's' ]]; then
      strongswamInstall
   fi
   echo ""; tput sgr0 ; tput setaf 7
   read -p "Instalar Wireguard? [s/n]: " -e -i n wireguardIresponse
   if [[ "$wireguardIresponse" = 's' ]]; then
      wireguardInstall
   fi

   sleep 3
   echo ""; tput sgr0 ; tput setaf 4
   echo "Reiniciando servicios..."; tput sgr0 ; tput setaf 7
   stunnel /etc/stunnel/stunnel.conf
   service dropbear restart
   systemctl restart squid
   echo ""; tput sgr0 ; tput setaf 2
   echo "VPS configurada correctamente!"; tput sgr0 ; tput setaf 2
}

configPorts() {
   # Configurar puertos necesarios
   echo
   echo "   1) Iptables"
   echo "   2) firewalld"
   read -rp "Elige el tipo de configuracion [1]: " pcsResponse
   
   until [[ -z "$pcsResponse" || "$pcsResponse" =~ ^[1-2]$ ]]; do
      echo "$pcsResponse: seleccion invalida."
      read -rp "Elige el tipo de configuracion [1]: " pcsResponse
   done
   
   #Configuracion de puertos con iptables
   if [[ "$pcsResponse" = '1' ]]; then
      configIptables
   #Configuracion de puertos con firewalld
   elif [[ "$pcsResponse" = '2' ]]; then
      configFirewalld
   fi
}

configIptables() {
   # v2ray
   sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT
   sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
   # hysteria2
   sudo iptables -I INPUT -p udp --dport 9999 -j ACCEPT
   # stunnel
   sudo iptables -I INPUT -p tcp --dport 143 -j ACCEPT
   # dropbear
   sudo iptables -I INPUT -p tcp --dport 444 -j ACCEPT
   # BadVPN
   # squid
   sudo iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
   # shadowscks
   sudo iptables -I INPUT -p tcp --dport 8388 -j ACCEPT
   sudo iptables -I INPUT -p udp --dport 8388 -j ACCEPT
   # OpenVPN
   sudo iptables -A INPUT -p udp --dport 1194 -j ACCEPT
   # IKEv2
   sudo iptables -A INPUT -p udp --dport 500 -j ACCEPT
   sudo iptables -A INPUT -p udp --dport 4500 -j ACCEPT
   # wireguard
   sudo iptables -A INPUT -p tcp --dport 41194 -j ACCEPT
   # webserver
   sudo iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
}

configFirewalld() {
   sudo apt install firewalld -y
   sudo systemctl enable firewalld
  
   # v2ray
   sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
   sudo firewall-cmd --permanent --zone=public --add-port=443/tcp
   # hysteria2
   sudo firewall-cmd --permanent --zone=public --add-port=9999/udp
   # stunnel
   sudo firewall-cmd --permanent --zone=public --add-port=143/tcp
   # dropbear
   sudo firewall-cmd --permanent --zone=public --add-port=444/tcp
   # BadVPN
   # squid
   sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
   # shadowscks
   sudo firewall-cmd --permanent --zone=public --add-port=8388/tcp
   sudo firewall-cmd --permanent --zone=public --add-port=8388/udp
   # OpenVPN
   sudo firewall-cmd --permanent --zone=public --add-port=1194/udp
   # IKEv2
   sudo firewall-cmd --permanent --zone=public --add-port=500/udp
   sudo firewall-cmd --permanent --zone=public --add-port=4500/udp
   # wireguard
   sudo firewall-cmd --permanent --zone=public --add-port=41194/udp
   # webserver
   sudo firewall-cmd --permanent --zone=public --add-port=8000/tcp
   
   sudo firewall-cmd --reload
}

showHelp() {
   tput setaf 4 ; tput setab 7 ; tput bold ; printf '%50s%s%-20s\n' "Ayuda" ; tput sgr0
   echo ""
   
   echo "$(tput setaf 7)-v2ray    $(tput setaf 7) instala el servidor $(tput setaf 4)v2ray$(tput sgr 0)"
   echo "$(tput setaf 7)-hysteria $(tput setaf 7) instala el servidor $(tput setaf 4)hysteria2$(tput sgr 0)"
   echo "$(tput setaf 7)-squid    $(tput setaf 7) instala el servidor $(tput setaf 4)squid$(tput sgr 0)"
}

### Solo instalar el servidor indicado en las opciones del script
if [[ "$1" != '' ]]; then
## Si se ejecuta VPSPro2024.1.sh -v2ray
if [[ "$1" = '-v2ray' ]]; then
   v2rayInstall
   sudo ss -lnput | grep v2ray
   exit
## Si se ejecuta VPSPro2024.1.sh -hysteria
elif [[ "$1" = '-hysteria' ]]; then
   hysteria2Install
   sudo ss -lnput | grep hysteria
   exit
## Si se ejecuta VPSPro2024.1.sh -stunnel
elif [[ "$1" = '-stunnel' ]]; then
   stunnelInstall
   sudo ss -lnput | grep stunnel
   exit
## Si se ejecuta VPSPro2024.1.sh -dropbear
elif [[ "$1" = '-dropbear' ]]; then
   dropbearInstall
   sudo ss -lnput | grep dropbear
   exit
## Si se ejecuta VPSPro2024.1.sh -badVPN
elif [[ "$1" = '-badVPN' ]]; then
   badVPNInstall
   sudo ss -lnput | grep BadVPN
   exit
## Si se ejecuta VPSPro2024.1.sh -squid
elif [[ "$1" = '-squid' ]]; then
   squidInstall
   sudo ss -lnput | grep squid
   exit
## Si se ejecuta VPSPro2024.1.sh -squidConfig
elif [[ "$1" = '-squidConfig' ]]; then
   squidConfig
   systemctl restart squid.service
   sudo ss -lnput | grep squid
   exit
## Si se ejecuta VPSPro2024.1.sh -shadowsocks
elif [[ "$1" = '-shadowsocks' ]]; then
   shadowsocksInstall
   sudo ss -lnput | grep ss
   exit
## Si se ejecuta VPSPro2024.1.sh -openVPN
elif [[ "$1" = '-openVPN' ]]; then
   openVPNInstall
   sudo ss -lnput | grep openvpn
   exit
## Si se ejecuta VPSPro2024.1.sh -IKEv2
elif [[ "$1" = '-IKEv2' ]]; then
   strongswamInstall
   sudo ss -lnput | grep xl2tpd
   exit
## Si se ejecuta VPSPro2024.1.sh -wireguard
elif [[ "$1" = '-wireguard' ]]; then
   wireguardInstall
   sudo ss -lnput | grep wireguard
   exit
## Si se ejecuta VPSPro2024.1.sh -portsOpen
elif [[ "$1" = '-configPorts' ]]; then
   configPorts
   sudo ss -ltun
   exit
## Si se ejecuta VPSPro2024.1.sh -certbot
elif [[ "$1" = '-certbot' ]]; then
   certbotInstall
   exit
elif [[ "$1" = '-h' || "$1" = '--h' || "$1" = '-help' || "$1" = '--help' ]]; then
   showHelp
   exit
else
   echo ""; tput sgr0 ; tput setaf 4
   echo "El argumento no es una opcion valida!"; tput sgr0 ; tput setaf 1
   echo "Saliendo..."; tput sgr0 ; tput setaf 7
   sleep 5
   exit
fi
fi


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

echo ""; tput sgr0 ; tput setaf 6
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
echo "OpenVPN: 1194"
echo "IKEv2: 500, 4500"
echo "Wireguard: "
echo ""; tput sgr0
exit
