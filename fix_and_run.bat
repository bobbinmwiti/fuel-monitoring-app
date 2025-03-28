@echo off
echo ===================================================
echo Flutter Build Helper with JAVA_HOME Fix
echo ===================================================
echo.

echo Step 1: Setting correct JAVA_HOME environment variable...
set "JAVA_HOME=C:\Program Files\Java\jdk-17"
set "PATH=%JAVA_HOME%\bin;%PATH%"
echo JAVA_HOME is now set to: %JAVA_HOME%
echo.

echo Step 2: Removing problematic local.properties file...
if exist "android\local.properties" del "android\local.properties"
echo.

echo Step 3: Creating new local.properties file with correct encoding...
echo sdk.dir=C:/Users/hp/AppData/Local/Android/sdk> "android\local.properties"
echo java.home=C:/Program Files/Java/jdk-17>> "android\local.properties"
echo.

echo Step 4: Updating gradle.properties with correct Java home...
echo org.gradle.java.home=C:/Program Files/Java/jdk-17> "android\gradle.properties.new"
echo flutter.sdk=C:/Users/hp/dev/flutter>> "android\gradle.properties.new"
echo.>> "android\gradle.properties.new"
echo org.gradle.jvmargs=-Xmx4G>> "android\gradle.properties.new"
echo android.useAndroidX=true>> "android\gradle.properties.new"
echo android.enableJetifier=true>> "android\gradle.properties.new"
echo org.gradle.parallel=true>> "android\gradle.properties.new"
echo org.gradle.daemon=true>> "android\gradle.properties.new"
echo.>> "android\gradle.properties.new"
echo android.suppressUnsupportedCompileSdk=33,34,35>> "android\gradle.properties.new"
echo android.defaults.buildfeatures.buildconfig=true>> "android\gradle.properties.new"
echo android.nonTransitiveRClass=false>> "android\gradle.properties.new"
echo android.nonFinalResIds=false>> "android\gradle.properties.new"
echo kotlin.code.style=official>> "android\gradle.properties.new"
echo kotlin.incremental=true>> "android\gradle.properties.new"
echo android.useNewApkCreator=true>> "android\gradle.properties.new"
echo kotlin.daemon.jvmargs=-Xmx2048M>> "android\gradle.properties.new"
copy /Y "android\gradle.properties.new" "android\gradle.properties"
del "android\gradle.properties.new"
echo.

echo Step 5: Creating gradle.bat wrapper to force JAVA_HOME...
echo @echo off> "android\gradlew_fixed.bat"
echo set "JAVA_HOME=C:\Program Files\Java\jdk-17">> "android\gradlew_fixed.bat"
echo set "PATH=%JAVA_HOME%\bin;%%PATH%%">> "android\gradlew_fixed.bat"
echo call gradlew.bat %%*>> "android\gradlew_fixed.bat"
echo.

echo Step 6: Cleaning Flutter project...
call flutter clean
echo.

echo Step 7: Getting dependencies...
call flutter pub get
echo.

echo Step 8: Running Flutter app with explicit JAVA_HOME...
echo.
cd android
call gradlew_fixed.bat --stop
cd ..
call flutter run -d emulator-5554

echo.
echo If the app failed to run, try running Android Studio and selecting the correct JDK path:
echo 1. Open Android Studio
echo 2. Go to File > Settings > Build, Execution, Deployment > Build Tools > Gradle
echo 3. Set "Gradle JDK" to "17 Oracle OpenJDK 17.0.12 C:\Program Files\Java\jdk-17"
echo 4. Click Apply and OK

pause
