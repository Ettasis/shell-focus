# Repository Hakkında

Sunucu üzerinde keşif yaparak, focus uygulamasını besleyecek shell dosyalarını reposudur. 
İzinsiz hiç bir şekilde kopyalanamaz / kullanılamaz. 

## API oAuth2.0 Entegrasyon işlemi

env: Test
url: https://focus.api.qa.ettasis.com/

AUT/Tokens POST istediğinde bulunulur.

### Kullanıcı adı ve şifre ile token alınması
```
{
  "grant_type": "password",
  "client_id": "86e3cd3cc66a44159e552686dbfe885f", 
  "client_secret": "d3850652c6d64c889e9ae5fdb0fb9e07",  
  "username": "SISTEM",
  "password": "Deumuhet35@"
}
```

### Refresh token ile token alınması
```
{
  "grant_type": "refresh_token",
  "client_id": "86e3cd3cc66a44159e552686dbfe885f", 
  "client_secret": "d3850652c6d64c889e9ae5fdb0fb9e07", 
  "refresh_token": "KULLANICI ADI VE ŞİFRE İLE ALINAN TOKEN"
}
```

## Logout işlemi

AUT/Tokens DELETE istediğinde bulunulur.

```
guid bilgisine 'currentUser' gönderilecek
```

## Giriş yapan kullanıcı bilgilerinin bulunaması.

```
USR/Kullanicilar 'currentUser' ile çağrıldığında gelecek.
```

## Oturuma ait bilgilerin sunucuya gönderilmesi

AUT/Sessions PUT isteğinde bulunulur. Guid olarak 'currentUser' gönderilir 

```
{
  "pushNotificationCode": "string"
}
```

## Header bilgisi

Yetkisiz çağırım
```
"Content-Type": "application/json;charset=UTF-8"
"Access-Control-Allow-Origin": "*"
```

Yetkili çağırım
```
"Content-Type": "application/json;charset=UTF-8"
"Access-Control-Allow-Origin": "*"
Authorization: TOKEN
ScreenName: IstekYapilanEkranKodu,
```
