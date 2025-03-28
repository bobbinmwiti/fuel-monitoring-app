@echo off
echo Stopping all Gradle daemons...
gradlew.bat --stop

echo Cleaning Flutter build...
cd ..
flutter clean

echo Removing problematic Gradle cache directories...
rmdir /S /Q "%USERPROFILE%\.gradle\caches\8.9\transforms" 2>nul
rmdir /S /Q "%USERPROFILE%\.gradle\caches\8.9\groovy-dsl" 2>nul

echo Running Gradle with clean environment...
set GRADLE_OPTS=-Dorg.gradle.caching=false
gradlew.bat clean --no-daemon
