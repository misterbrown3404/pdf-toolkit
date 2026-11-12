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

# General optimization settings
-dontwarn io.flutter.**
-dontwarn com.google.android.gms.**
-dontwarn com.android.vending.billing.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**

