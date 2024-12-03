#!/bin/bash

# Girdi ve çıktı dosyaları
INPUT_FILE="ip.txt"
OUTPUT_FILE="scan_results.json"

# Çıktı dosyasını temizle ve JSON başlangıcı ekle
echo "[" > "$OUTPUT_FILE"

# Domainleri oku ve sırayla işle
first_entry=true
while IFS= read -r domain; do
    if [[ -z "$domain" ]]; then
        continue
    fi

    echo "Tarama başlıyor: $domain"

    # IP adresini al
    ip=$(getent hosts "$domain" | awk '{ print $1 }')
    if [[ -z "$ip" ]]; then
        echo "IP bulunamadı: $domain"
        continue
    fi

    # Nmap taramasını çalıştır ve bitene kadar bekle
    nmap_output=$(nmap -sV --top-ports 100 "$ip" 2>/dev/null)

    # Taramanın tamamlandığından emin ol
    if [[ $? -ne 0 ]]; then
        echo "Nmap taraması başarısız oldu: $domain"
        continue
    fi

    # Port ve servis bilgilerini çıkar
    ports=$(echo "$nmap_output" | grep -E "^[0-9]+/" | sed -E 's/ +/ /g' | awk '{print "{\"port\":\"" $1 "\",\"service\":\"" $3 "\",\"version\":\"" substr($0, index($0,$4)) "\"}"}' | jq -s '.')

    # JSON formatına çevir ve dosyaya ekle
    if $first_entry; then
        first_entry=false
    else
        echo "," >> "$OUTPUT_FILE"
    fi

    echo "{
      \"domain\": \"$domain\",
      \"ip\": \"$ip\",
      \"ports\": $ports
    }" >> "$OUTPUT_FILE"

    echo "Tarama tamamlandı: $domain"

done < "$INPUT_FILE"

# JSON bitişini ekle
echo "]" >> "$OUTPUT_FILE"

echo "Sonuçlar $OUTPUT_FILE dosyasına kaydedildi."

