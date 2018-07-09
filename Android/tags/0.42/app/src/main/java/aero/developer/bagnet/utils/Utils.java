package aero.developer.bagnet.utils;

import android.annotation.SuppressLint;
import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.support.v4.content.ContextCompat;
import android.widget.TextView;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

import aero.developer.bagnet.PermissionRequester;
import aero.developer.bagnet.R;
import aero.developer.bagnet.connectivity.NetworkUtil;
import aero.developer.bagnet.interfaces.PermissionHandler;
import aero.developer.bagnet.services.ScanningService;
import aero.developer.bagnet.socketmobile.BagnetApplication;

import static aero.developer.bagnet.scantypes.EngineActivity.engineActivity;

/**
 * Created by User on 8/11/2016.
 */
public class Utils {
    public static final String DATE_FORMAT = "yyyy-MM-dd";
    public static final String INFO_DATE_FORMAT = "MMM d, yyyy";//"MM dd, yyyy";
    public static final String timeZoneFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    public static final String timeZoneFormatREQUEST = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";


    public static String formatDate(Date date, String format) {
        if (date != null) {
            // String errorMessage = "";
            if (format != null) {
                SimpleDateFormat sdf = new SimpleDateFormat(format, Locale.ENGLISH);
                String retDate;

                try {
                    retDate = sdf.format(date);
                    return retDate;
                } catch (Exception e) {

                    return null;
                }

            } else {

            }
        }
        return null;
    }

    /**
     * Re format Date String as a String-Date. Change from one String format to
     * String another.
     *
     * @param date   String
     * @param format String
     * @return String date
     */
    public static String formatDate(String date,String oldFormat, String format) {

        Date orgionalDate= getDate(date,oldFormat);

        return formatDate(orgionalDate,format);
    }

    /**
     * Convert String date to Date Object.
     *
     * @param d      String
     * @param format String
     * @return Date
     */
    public static Date getDate(String d, String format) {
        @SuppressLint("SimpleDateFormat") SimpleDateFormat sdf = new SimpleDateFormat(format);
        Date retDate = null;

        try {
            retDate = sdf.parse(d);

        } catch (ParseException e) {
            return null;
        } catch (NullPointerException e) {
            // retDate = new Date();
            return null;
        }

        return retDate;
    }
    public static boolean canContinueScanwithNoInternet(Context context) {
        String trackingLocation = Preferences.getInstance().getTrackingLocation(context);
        if (trackingLocation != null) {
            String TypeEvent = Location_Utils.getTypeEvent(trackingLocation);
            String unknownBag = Location_Utils.getUnknownBags(trackingLocation);
            if (NetworkUtil.getConnectivityStatus(context) == NetworkUtil.NETWORK_STATUS_NOT_CONNECTED
                    && TypeEvent!= null && unknownBag!= null &&
                    (unknownBag.equalsIgnoreCase("U") ||  TypeEvent.equalsIgnoreCase("B" )) ) {
                if(engineActivity!= null && engineActivity.scanPromptView!= null) {
                    engineActivity.scanPromptView.hideView();
                }
                return false;
            }
        }
        if(engineActivity!= null && engineActivity.scanPromptView!= null) {
            engineActivity.scanPromptView.showView();
        }
        return true;
    }

    @SuppressLint("StringFormatInvalid")
    public static void setVersion(Context context, TextView Version){
        String PACKAGE_CODE="";
        if(context!=null && Version!=null) {
            try {
                Calendar calendar = Calendar.getInstance();
                int year = calendar.get(Calendar.YEAR);
                PACKAGE_CODE = context.getString(R.string.version, year, context.getPackageManager().getPackageInfo(context.getPackageName(), 0).versionName);
                Version.setText(PACKAGE_CODE);

            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }
        }
    }

    public static String dateTimeUTC(String dtStart){


        @SuppressLint("SimpleDateFormat") SimpleDateFormat format = new SimpleDateFormat(Utils.timeZoneFormatREQUEST);
        try {
            Date myDate = format.parse(dtStart);
            Calendar calendar = Calendar.getInstance();
            calendar.setTimeZone(TimeZone.getTimeZone("UTC"));
            calendar.setTime(myDate);
            Date time = calendar.getTime();
            @SuppressLint("SimpleDateFormat") SimpleDateFormat outputFmt = new SimpleDateFormat(Utils.timeZoneFormatREQUEST);
            outputFmt.setTimeZone(TimeZone.getTimeZone("UTC"));
            String dateAsString = outputFmt.format(time);
            return dateAsString;

        } catch (ParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        /*SimpleDateFormat lv_formatter = new SimpleDateFormat(Utils.timeZoneFormatREQUEST);
        lv_formatter.setTimeZone(TimeZone.getTimeZone("UTC"));
        System.out.println(date);
        System.out.println(lv_formatter.format(date));*/
        //return lv_formatter.format(date);
        return "";
    }
     private static boolean isServiceRunning(Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) BagnetApplication.getApplicationInstance().getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                return true;
            }
        }
        return false;
    }
    public static void stopScanningService(){
        if (isServiceRunning(ScanningService.class)){
            BagnetApplication.getApplicationInstance().stopService(new Intent(BagnetApplication.getApplicationInstance().getApplicationContext(),ScanningService.class));
        }
    }
    public static void startScanningService(){
        if (!isServiceRunning(ScanningService.class)){
            BagnetApplication.getApplicationInstance().startService(new Intent(BagnetApplication.getApplicationInstance().getApplicationContext(),ScanningService.class));
        }else{
            BagLogger.log("Service is running");
        }
    }

    public static void checkPermission(Context context, String permission, PermissionHandler callback) {
        if (ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED) {
            if (callback != null) {
                callback.onGranted();
            }
        } else {
            Intent requestPermission = new Intent(context, PermissionRequester.class);
            requestPermission.putExtra("permissionToRequest", permission);
            context.startActivity(requestPermission);
            PermissionRequester.setCallback(callback);
        }
    }

}
