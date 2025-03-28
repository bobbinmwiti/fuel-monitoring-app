@echo off
echo Setting correct JAVA_HOME environment variable...
set JAVA_HOME=C:\Program Files\Java\jdk-17
set PATH=%JAVA_HOME%\bin;%PATH%

echo JAVA_HOME is now set to: %JAVA_HOME%
echo.
echo Running Flutter app...
flutter run

pause
