plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.upino.upino"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Scheduled reminders use java.time on phones older than it.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.upino.upino"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // One fixed key for every build. Without it each CI runner made its own
    // debug key, so every new APK had a different signature and Android
    // refused to install it over the previous one ("App not installed").
    // A debug key is not a secret; a store release needs its own key.
    signingConfigs {
        getByName("debug") {
            storeFile = file("upino-debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
    }

    // Two ways the app reaches a phone.
    //
    // direct — the APK people install from the release link. It does not
    //   declare READ_SMS: Google Play Protect blocks any sideloaded app
    //   that asks to read SMS ("App blocked to protect your device"),
    //   because banking malware uses it to steal one-time codes.
    // play   — for a Play Store release once Google has approved the SMS
    //   permission declaration. Adds READ_SMS (src/play/AndroidManifest.xml)
    //   and the app shows the "Read bank messages" switch.
    //
    // The inbox code is the same in both; without the permission it reads
    // nothing and the switch is not offered.
    flavorDimensions += "distribution"
    productFlavors {
        create("direct") { dimension = "distribution" }
        create("play") { dimension = "distribution" }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
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

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
