@echo off

setlocal

REM -----------------------------------------------------
REM
REM Update the path below according to your system
REM Please notice that we use the SDK of Android P (28)
REM instead of the default lollipop (22) used by Delphi.
REM This because we want the text selection
REM like https://developer.android.com/about/versions/marshmallow/android-6.0-changes.html#behavior-text-selection
REM Please install the SDK build tools and the SDK Platform 
REM of Android P (28) using SDK Manager.exe
REM
REM JDK 1.8/1.7 Compatibility Gotcha: http://www.draconianoverlord.com/2014/04/01/jdk-compatibility.html
REM
REM -----------------------------------------------------

if x%ANDROID% == x set ANDROID="C:\SDKs\android-sdk-windows"
set ANDROID_PLATFORM=%ANDROID%\platforms\android-28
set FMX_JAR="C:\Program Files (x86)\Embarcadero\Studio\19.0\lib\android\release\fmx.jar"
set JDK_PATH="C:\Program Files\Java\jdk1.8.0_131\bin"
set JDK_PATH1_7="C:\Program Files\Java\jdk1.7.0_80\bin"
set CONFIRM=%1
if x%CONFIRM% == x set CONFIRM=on

SET FileName=lib\jar\com.alcinoe\*.jar
del %FileName% /s
if exist %FileName% goto ERROR

SET FileName=lib\jar\com.alcinoe\res
IF EXIST %FileName% rmdir /s /q %FileName%
IF EXIST %FileName% goto ERROR

SET FileName=source\output
IF EXIST %FileName% rmdir /s /q %FileName%
IF EXIST %FileName% goto ERROR

echo Compiling the Java Sources
mkdir source\output 2> nul
%JDK_PATH%\javac -source 1.7 -target 1.7 -bootclasspath %JDK_PATH1_7%\jre\lib\rt.jar -Xlint:unchecked -Xlint:deprecation -cp^
 %ANDROID_PLATFORM%\android.jar;%FMX_JAR%;^
lib\jar\me.leolin\shortcutbadger.jar;^
lib\jar\com.facebook.android\facebook-common.jar;^
lib\jar\com.android.support\support-core-utils.jar;^
lib\jar\com.android.support\support-fragment.jar;^
lib\jar\com.android.support\support-compat.jar;^
lib\jar\com.android.support\support-annotations.jar;^
lib\jar\com.google.android.gms\play-services-base.jar;^
lib\jar\com.google.android.gms\play-services-basement.jar;^
lib\jar\com.google.android.gms\play-services-location.jar;^
lib\jar\com.google.android.gms\play-services-tasks.jar;^
lib\jar\com.google.firebase\firebase-iid.jar;^
lib\jar\com.google.firebase\firebase-messaging.jar^
 -d source\output^
 source\java\android\view\*.java^
 source\java\com\android\internal\*.java^
 source\java\com\alcinoe\*.java^
 source\java\com\alcinoe\content\*.java^
 source\java\com\alcinoe\location\*.java^
 source\java\com\alcinoe\util\*.java^
 source\java\com\alcinoe\view\*.java^
 source\java\com\alcinoe\view\menu\*.java^
 source\java\com\alcinoe\view\inputmethod\*.java^
 source\java\com\alcinoe\app\*.java^
 source\java\com\alcinoe\widget\*.java^
 source\java\com\alcinoe\text\method\*.java^
 source\java\com\alcinoe\facebook\*.java^
 source\java\com\alcinoe\firebase\iid\*.java^
 source\java\com\alcinoe\firebase\messaging\*.java
IF ERRORLEVEL 1 goto ERROR

SET FileName=source\output\com\alcinoe\*.class
del %FileName%
if exist %FileName% goto ERROR

echo Creating jar containing the new classes
%JDK_PATH1_7%\jar cf lib\jar\com.alcinoe\alcinoe.jar -C source\output com\alcinoe\
IF ERRORLEVEL 1 goto ERROR

SET FileName=source\output
IF EXIST %FileName% rmdir /s /q %FileName%
IF EXIST %FileName% goto ERROR

xcopy source\data\android\res lib\jar\com.alcinoe\res\ /s
IF ERRORLEVEL 1 goto ERROR

echo Jar created successfully
if x%CONFIRM% == xon PAUSE 
goto EXIT

:ERROR
pause

:EXIT

endlocal
