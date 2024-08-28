#!/bin/bash

# Dosya adı: ip_scan.sh

# 1. Ağdaki IP'leri tara ve listeye ekle
nmap -sn 192.168.1.0/24 | grep "Nmap scan report" | awk '{print $NF}' > ip_list.txt

# Sonsuz döngü: Yeni IP gelince haber ver
while true; do
    new_ip=$(diff ip_list.txt <(nmap -sn 192.168.1.0/24 | grep "Nmap scan report" | awk '{print $NF}'))
    if [ -n "$new_ip" ]; then
        echo "Yeni IP: $new_ip"
    fi
    sleep 60  # Her dakika kontrol et
done &

# 3. IP'lerdeki portları yazdır
nmap -p 1-65535 -iL ip_list.txt > port_list.txt

# 4. Mevcut IP'lerde yeni port olursa yazdır
while true; do
    diff port_list.txt <(nmap -p 1-65535 -iL ip_list.txt) | grep "<" | awk '{print $2}' > new_ports.txt
    if [ -s new_ports.txt ]; then
        echo "Yeni portlar:"
        cat new_ports.txt
    fi
    sleep 60  # Her dakika kontrol et
done &

# 5. SSL son kullanma tarihlerini yazdır
for ip in $(cat ip_list.txt); do
    echo "IP: $ip"
    openssl s_client -connect "$ip":443 2>/dev/null | openssl x509 -noout -dates
done