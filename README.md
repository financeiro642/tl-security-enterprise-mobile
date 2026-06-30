# TL Security Enterprise Mobile V2

Projeto Flutter fonte. Para criar a estrutura Android completa e gerar APK:

```powershell
cd "C:\Users\Guilherme G Gomes\Downloads\TL_Security_Enterprise_Mobile_V2"
C:\flutter\bin\flutter.bat create --platforms=android .
C:\flutter\bin\flutter.bat pub get
C:\flutter\bin\flutter.bat build apk --debug
```

APK:
`build\app\outputs\flutter-apk\app-debug.apk`

API usada:
`http://zabbix.tlconsultorias.com.br:8090`
