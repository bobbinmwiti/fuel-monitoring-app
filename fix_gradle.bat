@echo off
echo Creating custom Gradle wrapper to override JAVA_HOME...

cd %~dp0\android

echo @echo off > gradlew_fixed.bat
echo rem Setting correct JAVA_HOME >> gradlew_fixed.bat
echo set "JAVA_HOME=C:\Program Files\Java\jdk-17" >> gradlew_fixed.bat
echo set "PATH=%JAVA_HOME%\bin;%%PATH%%" >> gradlew_fixed.bat
echo echo Using JAVA_HOME: %JAVA_HOME% >> gradlew_fixed.bat
echo. >> gradlew_fixed.bat
echo call gradlew.bat %%* >> gradlew_fixed.bat

echo Custom Gradle wrapper created at android\gradlew_fixed.bat
echo.
echo Now you can build your Flutter app using this wrapper
echo.
echo Press any key to return to your project...
pause
cd ..
