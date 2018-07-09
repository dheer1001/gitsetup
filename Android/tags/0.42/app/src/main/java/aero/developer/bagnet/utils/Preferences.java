package aero.developer.bagnet.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

import java.util.Date;

import aero.developer.bagnet.AppController;

public class Preferences {

    static Preferences instance = null;

    public static Preferences getInstance(){
        if (instance==null){
            instance = new Preferences();
        }
        return instance;
    }

    public Context context;

    private static final String SERVICEID = "SERVICE_ID";
    private static final String selected_Airport = "SELECTED_AIRPORT";
    private static final String selected_Airline = "SELECTED_AIRLINE";
    public static final String TACKINGLOCATION = "TRACKING_LOCATION";
    public static final String CONTAINERULD = "CONTAINER_ULD";
    private static final String TRACKINGTIMESTART = "TRACKING_TIME_START";
    private static final String ScannerType="scannertype";
    private static final String BingoTempQueue = "BingoTempQueue";

    private static final String FLIGHTDATE = "FLIGHT_DATE";
    public static final String FLIGHTNUMBER = "FLIGHT_NUMBER";
    private static final String FLIGHTTYPE = "FLIGHT_TYPE";
    private static final String BINGO_NUMBEROFBAGS = "BINGO_NUMBEROFBAGS";

    private static final String IS_NIGHT_MODE = "isNightMode";
    private static final String USER_ID = "USER_ID";
    private static final String COMPANY_ID = "COMPANY_ID";
    private static final String LOGIN_RESPONSE = "LOGIN_RESPONSE";
    private static final String PASSWORD = "PASSWORD";
    public static final String TRACKING_MAP = "TRACKING_MAP";
    private static final String ALARMCOUNTER = "ALARM_COUNTER";
    private static final String TRACKING_RECENTLY_USED = "TRACKING_RECENTLY_USED";

    private static final String IS_CODE_128_ENABLED = "IS_CODE_128_ENABLED";
    private static final String IS_2of5_ENABLED = "IS_2of5_ENABLED";

    private static final String IS_FORCE_CHARGING_ENABLED = "IS_FORCE_CHARGING_ENABLED";

    public static SharedPreferences getSharedPreferences(Context c) {
        return c.getSharedPreferences("BagNetPref", Context.MODE_PRIVATE);
    }

    public static Editor getEditor(Context c) {
        return getSharedPreferences(c).edit();
    }

    private Preferences() {
    }

    public void setIS_NIGHT_MODE(Context context,boolean isNightMode){
        Editor editor = getEditor(context);
        editor.putBoolean(IS_NIGHT_MODE,isNightMode).apply();
    }

    public String getServiceid(Context context){
        return getSharedPreferences(context).getString(SERVICEID,null);
    }

    public String getBingoTempQueue(Context context){
        return getSharedPreferences(context).getString(BingoTempQueue,null);
    }

    public void setBingoTempQueue(String queue) {
        Editor editor = getEditor(AppController.getInstance().getApplicationContext());
        editor.putString(BingoTempQueue,queue).apply();
        }

    public void setServiceID(Context context, String serviceID){
        Editor editor = getEditor(context);
        editor.putString(SERVICEID,serviceID).apply();
    }


    public int getBingoBagsnumber(Context context){
       return getSharedPreferences(context).getInt(BINGO_NUMBEROFBAGS,0);
    }

    public void setBingoBagsNumber(Context context, int Nb){
        Editor editor = getEditor(context);
        editor.putInt(BINGO_NUMBEROFBAGS,Nb).apply();
    }


        public void saveScannerType(Context context,String scannerType){
            this.context = context;
            Editor editor = getEditor(context);
            editor.putString(ScannerType,scannerType).apply();
        }

    public boolean isNightMode(Context context){
        return getSharedPreferences(context).getBoolean(IS_NIGHT_MODE,false);
    }

    public String getScannerType(Context context){
        return  getSharedPreferences(context).getString(ScannerType,null);
    }

    public String getTrackingMap(Context context){
        return getSharedPreferences(context).getString(TRACKING_MAP,null);
    }

    public void setTrackingMap(Context context, String mapString){
        Editor editor = getEditor(context);
        editor.putString(TRACKING_MAP,mapString).apply();
    }

    public String getRecentlyUsedTracking(Context context){
        return getSharedPreferences(context).getString(TRACKING_RECENTLY_USED,null);
    }

    public void setRecentlyUsedTracking(Context context, String freqUsedString){
        Editor editor = getEditor(context);
        editor.putString(TRACKING_RECENTLY_USED,freqUsedString).apply();
    }

    public String getTrackingLocation(Context context){
        return getSharedPreferences(context).getString(TACKINGLOCATION,null);
    }

    public void saveTrackingLocation(Context context,String trackingLocation){
        Editor editor = getEditor(context);
        editor.putString(TACKINGLOCATION,trackingLocation).apply();
    }


    public String getContaineruld(Context context){
        return getSharedPreferences(context).getString(CONTAINERULD,"");
    }

    public void saveContaineruld(Context context,String containeruld){
        Editor editor = getEditor(context);
        editor.putString(CONTAINERULD,containeruld).apply();
    }
    public void resetContaineruld(Context context){
        Editor editor = getEditor(context);
        editor.remove(CONTAINERULD).apply();
    }


    public void saveStartTrackingTime(Context context,Date date){
        Editor editor = getEditor(context);
        editor.putLong(TRACKINGTIMESTART,date.getTime()).apply();
    }
    public long getStartTrackingTime(Context context){
        return getSharedPreferences(context).getLong(TRACKINGTIMESTART,0);
    }

    public void deleteTrackingLocation(Context context){
        Editor editor = getEditor(context);
        editor.remove(TACKINGLOCATION).apply();
        editor.remove(TRACKINGTIMESTART).apply();

        resetFlightInfo(context);
        resetContaineruld(context);
    }

    public void saveFlightInfo(Context context,String flightDate,String flightNumber,String flightType){
        Editor editor = getEditor(context);
        editor.putString(FLIGHTDATE,flightDate);
        editor.putString(FLIGHTNUMBER,flightNumber);
        editor.putString(FLIGHTTYPE,flightType);
        editor.apply();
    }

    public void saveBingoInfo(Context context,String flightDate , String flightNumber,String flightType,int Nb_Bags){
        Editor editor = getEditor(context);
        editor.putString(FLIGHTDATE,flightDate);
        editor.putString(FLIGHTNUMBER,flightNumber);
        editor.putString(FLIGHTTYPE,flightType);
        editor.putInt(BINGO_NUMBEROFBAGS,Nb_Bags);
        editor.apply();
    }

    public void resetBingoInfo(Context context){
        Editor editor = getEditor(context);
        editor.putString(FLIGHTDATE,null);
        editor.putString(FLIGHTNUMBER,null);
        editor.putString(FLIGHTTYPE,null);
        editor.putInt(BINGO_NUMBEROFBAGS,0);
        setBingoTempQueue(null);
        editor.apply();
    }

    public String getFlightDate(Context context){
        return getSharedPreferences(context).getString(FLIGHTDATE,null);
    }
    public String getFlightNumber(Context context){
        return getSharedPreferences(context).getString(FLIGHTNUMBER,null);
    }
    public String getFlightType(Context context){
        return getSharedPreferences(context).getString(FLIGHTTYPE,null);
    }

    public void resetFlightInfo(Context context){
        Editor editor = getEditor(context);
        editor.remove(FLIGHTDATE);
        editor.remove(FLIGHTNUMBER);
        editor.remove(FLIGHTTYPE);
        editor.apply();
    }

    public String getUserID(Context context){
        String userID = getSharedPreferences(context).getString(USER_ID, null);
        if (userID != null && userID.length() == 0) {
            userID = null;
        }
        return userID;
    }

    public void setUserID(Context context, String userId){
        Editor editor = getEditor(context);
        if (userId != null && userId.length() > 0) {
            editor.putString(USER_ID, userId).apply();
        }else{
            editor.remove(selected_Airline).apply();
        }
    }

    public String getCompanyID(Context context){
        String companyID = getSharedPreferences(context).getString(COMPANY_ID, null);
        if (companyID != null && companyID.length() == 0) {
            companyID = null;
        }
        return companyID;
    }

    public void setCompanyID(Context context, String companyId){
        Editor editor = getEditor(context);
        if (companyId != null && companyId.length() > 0) {
            editor.putString(COMPANY_ID, companyId).apply();
        }else{
            editor.remove(COMPANY_ID).apply();
        }
    }

//    public String getpassword(Context context){
//        String password = getSharedPreferences(context).getString(PASSWORD, null);
//        if (password != null && password.length() == 0) {
//            password = null;
//        }
//        return password;
//    }

    public void setpassword(Context context, String password){
        Editor editor = getEditor(context);
        if (password != null && password.length() > 0) {
            editor.putString(PASSWORD,AppController.getInstance().sha256(password)).apply();
        }else{
            editor.remove(PASSWORD).apply();
        }
    }


    public String getLoginResponse(Context context) {
        return getSharedPreferences(context).getString(LOGIN_RESPONSE,null);
    }

    public void setLoginResponse(Context context,String login_responseStr) {
        Editor editor = getEditor(context);
        editor.putString(LOGIN_RESPONSE,login_responseStr).apply();
    }

    public String getAirportcode(Context context){
        return getSharedPreferences(context).getString(selected_Airport,null);
    }

    public void setAirportCode(Context context, String airportCode){
        Editor editor = getEditor(context);
        editor.putString(selected_Airport,airportCode).apply();
    }

    public String getAirlinecode(Context context){
        String airline_code = getSharedPreferences(context).getString(selected_Airline, null);
        if (airline_code != null && airline_code.length() == 0) {
            airline_code = null;
        }
        return airline_code;
    }

    public void setAirlineCode(Context context, String airlineCode){
        Editor editor = getEditor(context);
        if (airlineCode != null && airlineCode.length() > 0) {
            editor.putString(selected_Airline, airlineCode).apply();
        }else{
            editor.remove(selected_Airline).apply();
        }
    }



    public void setAlarmCounter(int counter,Context context) {
        Editor editor = getEditor(context);
        editor.putInt(ALARMCOUNTER, counter).apply();
    }

    public int getAlarmCounter(Context context) {
        return getSharedPreferences(context).getInt(ALARMCOUNTER, 0);
    }

    public void removeAlarmCounter(Context context) {
        Editor editor = getEditor(context);
        editor.remove(ALARMCOUNTER).apply();
    }

    public void setIsCode128Enabled(Context context,boolean isCode128Enabled) {
        Editor editor = getEditor(context);
        editor.putBoolean(IS_CODE_128_ENABLED,isCode128Enabled).apply();
    }

    public void setIs2of5Enabled(Context context,boolean is2of5Enabled) {
        Editor editor = getEditor(context);
        editor.putBoolean(IS_2of5_ENABLED,is2of5Enabled).apply();
    }

    public boolean getIsCode128Enabled(Context context){
        return getSharedPreferences(context).getBoolean(IS_CODE_128_ENABLED,false);
    }
    public boolean getIs2of5Enabled(Context context){
        return getSharedPreferences(context).getBoolean(IS_2of5_ENABLED,false);
    }

    public void setIS_FORCE_CHARGING_ENABLED(Context context,boolean ISFORCECHARGINGENABLED) {
        Editor editor = getEditor(context);
        editor.putBoolean(IS_FORCE_CHARGING_ENABLED,ISFORCECHARGINGENABLED).apply();
    }

    public boolean getIS_FORCE_CHARGING_ENABLED(Context context){
        return getSharedPreferences(context).getBoolean(IS_FORCE_CHARGING_ENABLED,false);
    }




}
