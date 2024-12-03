#!/bin/bash

# Alt domain bulmak için gereken araç: assetfinder veya benzeri bir araç kullanılabilir

# Domain/IP adreslerini içeren dosya
INPUT_FILE="ip.txt"
# Alt domain çıktısını kaydedeceğimiz dosya
OUTPUT_FILE="subdomains.txt"

# Çıktı dosyasını temizle
> "$OUTPUT_FILE"

# Geçerli dosya kontrolü
if [[ ! -f $INPUT_FILE ]]; then
  echo "Hata: $INPUT_FILE dosyası bulunamadı."
  exit 1
fi

# Her bir domain/IP adresi için işlem yapılıyor
while IFS= read -r domain; do
  if [[ -z $domain ]]; then
    continue # Boş satırları atla
  fi

  # Sorgulama tarihini yaz
  echo "Sorgulama Tarihi: $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
  echo "Domain/IP: $domain" >> "$OUTPUT_FILE"

  # Alt domainleri bulmak için assetfinder kullanılıyor
  subdomains=$(assetfinder --subs-only "$domain" 2>/dev/null)

  if [[ -z $subdomains ]]; then
    echo "Hata: $domain için alt domain bulunamadı." >> "$OUTPUT_FILE"
    continue
  fi

  # Alt domainleri dosyaya yazdır
  echo "$subdomains" >> "$OUTPUT_FILE"
  echo "---------------------------------------------" >> "$OUTPUT_FILE"
done < "$INPUT_FILE"

# İşlem tamamlandı mesajı
echo "Alt domainler $OUTPUT_FILE dosyasına kaydedildi."

