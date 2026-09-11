plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.personalmoneytracker.mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.personalmoneytracker.mobile"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val storePath = project.findProperty("MONEY_TRACKER_RELEASE_STORE_FILE") as String?
            val storePasswordValue = project.findProperty("MONEY_TRACKER_RELEASE_STORE_PASSWORD") as String?
            val keyAliasValue = project.findProperty("MONEY_TRACKER_RELEASE_KEY_ALIAS") as String?
            val keyPasswordValue = project.findProperty("MONEY_TRACKER_RELEASE_KEY_PASSWORD") as String?
            if (storePath != null && storePasswordValue != null && keyAliasValue != null && keyPasswordValue != null) {
                storeFile = file(storePath)
                storePassword = storePasswordValue
                keyAlias = keyAliasValue
                keyPassword = keyPasswordValue
            }
        }
    }

    buildTypes {
        release {
            // Production CI supplies these four properties to sign the APK.
            // Local verification remains buildable as an unsigned release APK.
            if (project.findProperty("MONEY_TRACKER_RELEASE_STORE_FILE") != null) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }

    packaging {
        jniLibs {
            keepDebugSymbols.add("**/libflutter.so")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
