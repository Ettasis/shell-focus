#!/bin/bash

# Subdomains.txt dosyasını okuma
input_file="subdomains.txt"
api_url="https://focus.api.qa.ettasis.com/INV/Envanterler"
bearer_token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOlsiODZlM2NkM2NjNjZhNDQxNTllNTUyNjg2ZGJmZTg4NWYiLCJTZWN1cml0eSJdLCJzaWQiOiIzMDY0ZGZjN2FkZmQ0NGUyOGMwMGU0YWRkYzJhMjllOSIsImlhdCI6IjEyLzA0LzIwMjQgMTA6Mzk6MTMiLCJzdWIiOiJmZjIyY2VhOGVhNjQ0YmZlYjk4NDNkNWEyNjQ0N2I0NSIsInVuaXF1ZV9uYW1lIjoiU0lTVEVNIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbIlVzZXIiLCJUZW5hbnRBZG1pbiIsIlN5c3RlbUFkbWluIl0sIm5iZiI6MTczMzMwODc1MywiZXhwIjoxNzMzOTA4NzUzLCJpc3MiOiJTZWN1cml0eS5XZWJBcGkifQ.2HKf8qC6-H6PnFp52_8bWrGqJlf11wDZzrPs89bGh5Y"

# Subdomainleri dosyadan okuma ve API'ye POST isteği gönderme
while IFS= read -r subdomain; do
    echo "Subdomain: $subdomain API'ye gönderiliyor..."

    # POST isteğini gönder
    response=$(curl -s -o response.txt -w "%{http_code}" -X POST "$api_url" \
        -H "Authorization: Bearer $bearer_token" \
        -H "Content-Type: application/json" \
        -d "{\"subdomain\":\"$subdomain\"}")

    # API yanıtını kontrol et
    http_code=$(tail -n 1 response.txt)
    
    if [ "$http_code" -eq 200 ]; then
        echo "Başarıyla gönderildi: $subdomain"
    else
        echo "Hata oluştu: $subdomain, HTTP kodu: $http_code"
    fi
done < "$input_file"

