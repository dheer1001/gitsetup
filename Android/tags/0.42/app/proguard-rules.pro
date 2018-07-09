#-keep class !aero.developer.iTravel.foo.Constants { *; }
-dontnote **.**
-dontwarn **.**

#-allowaccessmodification
#-overloadaggressively
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontpreverify
#-verbose
#-dump class_files.txt
#-printseeds seeds.txt
#-printusage unused.txt
#-printmapping mapping.txt

# The -optimizations option disables some arithmetic simplifications that Dalvik 1.0 and 1.5 can't handle.
-optimizations !code/simplification/arithmetic

-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class com.google.gson
-keep class org.apache.** {*;}

# Add any classes the interact with gson
-keep class aero.developer.bagnet.objects.** { *; }
#-keep class aero.sita.airportcollaboration.utils.** { *; }
-keep class android.support.v7.widget.** { *; }


-keep class biz.smartengines.swig.**{*;}
-keepattributes Signature, *Annotation*


#-keep public class * extends android.view.View {
#public <init>(android.content.Context);
#public <init>(android.content.Context, android.util.AttributeSet);
#public <init>(android.content.Context, android.util.AttributeSet, int);
#public void set*(...);
#public void init*(...);
#
#}

## Also keep - Enumerations. Keep the special static
## methods that are required in enumeration classes.
-keepclassmembers enum  * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Platform calls Class.forName on types which do not exist on Android to determine platform.
-dontnote retrofit2.Platform
# Platform used when running on RoboVM on iOS. Will not be used at runtime.
-dontnote retrofit2.Platform$IOS$MainThreadExecutor
# Platform used when running on Java 8 VMs. Will not be used at runtime.
-dontwarn retrofit2.Platform$Java8
# Retain generic type information for use by reflection by converters and adapters.
-keepattributes Signature
# Retain declared checked exceptions for use by a Proxy instance.
-keepattributes Exceptions

# for the custom loader library
-keep class com.wang.avi.** { *; }
-keep class com.wang.avi.indicators.** { *; }
