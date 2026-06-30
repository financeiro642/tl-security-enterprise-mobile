@echo off
cd /d "%~dp0"
C:\flutter\bin\flutter.bat create --platforms=android .
C:\flutter\bin\flutter.bat pub get
C:\flutter\bin\flutter.bat build apk --debug
pause
