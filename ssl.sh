#!/bin/bash

# Sertifika bilgilerini kontrol etmek için OpenSSL ve date komutları kullanılacak

# IP adreslerinin bulunduğu dosya
IP_FILE="ip.txt"
# Çıktı dosyası
OUTPUT_FILE="ssl_expired.txt"

# Sorgulama tarihini ekle
echo "---------------------------------------------" >> "$OUTPUT_FILE"
echo "Sorgulama Tarihi: $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
echo "---------------------------------------------" >> "$OUTPUT_FILE"

# Geçerli dosya kontrolü
if [[ ! -f $IP_FILE ]]; then
  echo "Hata: $IP_FILE dosyası bulunamadı." >> "$OUTPUT_FILE"
  exit 1
fi

# Her bir IP adresi için işlem yapılıyor
while IFS= read -r ip; do
  if [[ -z $ip ]]; then
    continue # Boş satırları atla
  fi

  echo "IP Adresi: $ip" >> "$OUTPUT_FILE"

  # SSL sertifika bitiş tarihi alınıyor
  expire_date=$(echo | openssl s_client -connect "$ip:443" -servername "$ip" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)

  if [[ -z $expire_date ]]; then
    echo "Hata: $ip adresi için SSL sertifikası alınamadı." >> "$OUTPUT_FILE"
    continue
  fi

  # Bitiş tarihini epoch (saniye) formatına çevir
  expire_epoch=$(date -d "$expire_date" +%s 2>/dev/null)
  current_epoch=$(date +%s)

  if [[ -z $expire_epoch ]]; then
    echo "Hata: Bitiş tarihi dönüştürülemedi." >> "$OUTPUT_FILE"
    continue
  fi

  # Kalan süreyi hesapla
  remaining_seconds=$((expire_epoch - current_epoch))

  if ((remaining_seconds <= 0)); then
    echo "Uyarı: Sertifika zaten süresi dolmuş." >> "$OUTPUT_FILE"
    continue
  fi

  # Gün, saat ve dakika olarak kalan süreyi hesapla
  days=$((remaining_seconds / 86400))
  hours=$(((remaining_seconds % 86400) / 3600))
  minutes=$(((remaining_seconds % 3600) / 60))

  echo "Sertifika bitişine kalan süre: ${days} gün, ${hours} saat, ${minutes} dakika." >> "$OUTPUT_FILE"
done < "$IP_FILE"

