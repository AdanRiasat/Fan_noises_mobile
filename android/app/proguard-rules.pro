# R8 shrinks/renames anything it cannot prove is reachable. The libraries below are
# reached by reflection (class lookup by string name), which R8 cannot see -- without
# these keeps they get stripped and the release build fails at runtime while debug works.

# Flutter engine and embedding: plugin classes are instantiated by name.
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# just_audio ships ExoPlayer / Media3, which resolves renderers and extractors by name.
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**

# Google Mobile Ads (banner, interstitial, UMP consent forms) loads mediation adapters
# by class name.
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.android.ump.** { *; }
-dontwarn com.google.android.gms.ads.**

# Some ad formats render in a WebView and call back into Java from JavaScript, so the
# bridge methods are only ever invoked by name.
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Play Core is referenced by the Flutter embedding for deferred components, which this
# app does not use -- silence the missing-class warnings instead of adding the dependency.
-dontwarn com.google.android.play.core.**
