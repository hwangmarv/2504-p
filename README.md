# 2504-p

# timevault_hwangmarvin

A new Flutter project.

## Getting Started

1. add these into the pubspec.yaml dependency and dev_dependency list:
    dependencies:
  flutter:
    sdk: flutter
  intl: ^0.17.0
  flutter_slidable: ^0.6.0
  hive: ^2.0.4
  hive_flutter: ^1.1.0
  http: ^0.13.3

    dev_dependencies:
    hive_generator: ^1.1.1
    build_runner: ^2.1.4

2. run "flutter pub get"

3. go to this file here: android >>> app >>> src >>> main >>> AndroidManifest.xml. The top should look like this:
    <manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="timevault_hwangmarvin"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:enableOnBackInvokedCallback="true">

4. go to this file here: android >>> app >>> build.gradle. Expand this range. Copy and paste this below and save it in your build.gradle:
    plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    }

    def localProperties = new Properties()
    def localPropertiesFile = rootProject.file('local.properties')
    if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
    }

    def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
    if (flutterVersionCode == null) {
        flutterVersionCode = '1'
    }

    def flutterVersionName = localProperties.getProperty('flutter.versionName')
    if (flutterVersionName == null) {
        flutterVersionName = '1.0'
    }

    android {
        namespace "com.example.timevault_hwangmarvin"
        compileSdkVersion flutter.compileSdkVersion
        ndkVersion flutter.ndkVersion
        compileSdkVersion 34

        compileOptions {
            sourceCompatibility JavaVersion.VERSION_1_8
            targetCompatibility JavaVersion.VERSION_1_8
        }

        kotlinOptions {
            jvmTarget = '1.8'
        }

        sourceSets {
            main.java.srcDirs += 'src/main/kotlin'
        }

        defaultConfig {
            // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
            applicationId "com.example.timevault_hwangmarvin"
            // You can update the following values to match your application needs.
            // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
            minSdkVersion flutter.minSdkVersion
            targetSdkVersion flutter.targetSdkVersion
            versionCode flutterVersionCode.toInteger()
            versionName flutterVersionName
        }

        buildTypes {
            release {
                // TODO: Add your own signing config for the release build.
                // Signing with the debug keys for now, so `flutter run --release` works.
                signingConfig signingConfigs.debug
            }
        }
    }

    flutter {
        source '../..'
    }

    dependencies {}

5. save the project.

6. use "flutter run"