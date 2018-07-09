package aero.developer.bagnet.utils;

import android.util.Log;

import com.google.android.gms.analytics.ExceptionReporter;
import com.google.android.gms.analytics.GoogleAnalytics;
import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.StandardExceptionParser;
import com.google.android.gms.analytics.Tracker;

import aero.developer.bagnet.BuildConfig;
import aero.developer.bagnet.R;
import aero.developer.bagnet.socketmobile.BagnetApplication;

public class Analytic {

    private static Tracker tracker;
    private static Analytic instance;

    private Analytic() {
        instance = this;
        GoogleAnalytics analytics = GoogleAnalytics.getInstance(BagnetApplication.getInstance().getApplicationContext());
        tracker = analytics.newTracker(R.xml.analytic_config);
        ExceptionReporter myHandler = new ExceptionReporter(
                tracker,
                Thread.getDefaultUncaughtExceptionHandler(),
                BagnetApplication.getInstance().getApplicationContext());
        StandardExceptionParser exceptionParser = new StandardExceptionParser(BagnetApplication.getInstance().getApplicationContext(), null) {
            @Override
            public String getDescription(String threadName, Throwable t) {
                return BuildConfig.VERSION_CODE + " testing " + " {" + threadName + "} " + Log.getStackTraceString(t);
            }
        };
        myHandler.setExceptionParser(exceptionParser);
        // Make myHandler the new default uncaught exception handler.
        Thread.setDefaultUncaughtExceptionHandler(myHandler);
    }

    public static Analytic getInstance() {
        if (instance == null) {
            new Analytic();
        }
        return instance;
    }

    public void sendEvent(String category) {
        tracker.send(new HitBuilders.EventBuilder()
                .setCategory(category)
                .build());
    }

    public void sendEvent(String category, String action) {
        tracker.send(new HitBuilders.EventBuilder()
                .setCategory(category)
                .setAction(action)
                .build());
    }

    public void sendEvent(String category, String action, String label) {
        tracker.send(new HitBuilders.EventBuilder()
                .setCategory(category)
                .setAction(action)
                .setLabel(label)
                .build());
    }

    public void sendEvent(String category, String action, String label, long value) {
        tracker.send(new HitBuilders.EventBuilder()
                .setCategory(category)
                .setAction(action)
                .setLabel(label)
                .setValue(value)
                .build());
    }

    public void sendScreen(String screenName) {
        Log.e("ANALYTICS: ", "sendScreen" + screenName);
        tracker.setScreenName(screenName);
        tracker.send(new HitBuilders.ScreenViewBuilder().build());
    }

    public void sendScreen(int screenName) {
        Log.d("ANALYTICS: ", "sendScreen" + BagnetApplication.getInstance().getApplicationContext().getString(screenName));
        tracker.setScreenName(BagnetApplication.getInstance().getApplicationContext().getString(screenName));
        tracker.send(new HitBuilders.ScreenViewBuilder().build());
    }

    public void sendTransaction(HitBuilders.ScreenViewBuilder builder, String currency) {

        tracker.setScreenName("transaction");
        tracker.set("&cu", currency);
        tracker.send(builder.build());
    }
}
