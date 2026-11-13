# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Mobile Ads
-keep public class com.google.android.gms.ads.** {
   public *;
}
-keep public class com.google.ads.** {
   public *;
}

# In-App Purchase (Google Play Billing)
-keep class com.android.vending.billing.** { *; }
-keep class com.google.android.play.core.** { *; }

# PDF Rendering & PDFium (pdfrx)
-keep class com.tom_roush.pdfbox.** { *; }
-keep class io.legado.pdfrx.** { *; }

# Image Compression
-keep class com.fluttercandies.flutter_image_compress.** { *; }

# AndroidX WorkManager & Room (Prevents Failed to create an instance of WorkDatabase)
-keep class * extends androidx.room.RoomDatabase {
    public <init>();
    *;
}
-keep class androidx.room.** { *; }
-keep class androidx.work.** { *; }
-keep class androidx.work.impl.** { *; }
-keep class androidx.work.impl.WorkDatabase { *; }
-keep class androidx.work.impl.WorkDatabase_Impl {
    public <init>();
    *;
}
-keep class * extends androidx.work.Worker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}
-keep class * extends androidx.work.ListenableWorker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}
-keep class androidx.startup.** { *; }
-keep class * extends androidx.startup.Initializer { *; }
-keep class androidx.sqlite.** { *; }
-keep class androidx.datastore.** { *; }
-keep class com.google.firebase.datastorage.** { *; }

# Firebase & Crashlytics
-keepattributes SourceFile,LineNumberTable
-keep public class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# General optimization settings
-dontwarn androidx.work.**
-dontwarn androidx.room.**
-dontwarn androidx.startup.**
-dontwarn androidx.sqlite.**
-dontwarn androidx.datastore.**
-dontwarn io.flutter.**
-dontwarn com.google.android.gms.**
-dontwarn com.android.vending.billing.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**

