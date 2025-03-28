@echo off
echo Setting correct JAVA_HOME environment variable...
set "JAVA_HOME=C:\Program Files\Java\jdk-17"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo JAVA_HOME is now set to: %JAVA_HOME%
echo.

REM Create a temporary gradle.properties file with the correct Java home
echo Creating temporary gradle.properties file...
echo org.gradle.java.home=C:\\Program Files\\Java\\jdk-17 > "%TEMP%\gradle.properties"
echo flutter.sdk=C:/Users/hp/dev/flutter >> "%TEMP%\gradle.properties"
echo org.gradle.jvmargs=-Xmx4G >> "%TEMP%\gradle.properties"
echo android.useAndroidX=true >> "%TEMP%\gradle.properties"
echo android.enableJetifier=true >> "%TEMP%\gradle.properties"
echo org.gradle.parallel=true >> "%TEMP%\gradle.properties"
echo org.gradle.daemon=true >> "%TEMP%\gradle.properties"

REM Copy the temporary file to the project's gradle.properties
copy /Y "%TEMP%\gradle.properties" "android\gradle.properties"

echo.
echo Running Flutter with correct Java configuration...
echo.

REM Run the Flutter command passed as arguments
flutter %*

echo.
echo Command completed.
pause
