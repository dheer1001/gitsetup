    package aero.developer.bagnet;

/**
 * Created by User on 8/3/2016.
 */
public class Constants {
    public static final String BAGJOURNEY_TOKEN = "token=cji0i47nnha117pj1cckvq1q8";
    public static final long TrackingLocationExpireTime = 3600*1000;
    public static final boolean enableDebug = false;
    public static long ResponseDialogExpireTime = 1500;
    public static final int numSeconds = 600 * 1000;
    public static final int AlarmMaxTriggers = 50;
    public static long CHANGE_PASSWORD_MESSAGE_TIME = 5 * 1000;

    public static final String api_key="bb0fcf1ffcf7d2348729ff37315c8436";
    public static final String BASE_URL ="https://bagjourney.sita.aero/baggage/";
    //public static final String api_key="8c82bedff96031b9deadf2a24fd109cb";
    //public static final String BASE_URL ="https://bagjourney.sita.aero/baggage/";

    public static final String BAG_HISTORY ="history/v1.0/tag/{bagtag}/flightdate/{flightdate}";


    public static final String BAG_TRACK="/baggage/tracking/v1.0/";

    public static final String MANATEE_USER = "adrien.sangliersita.aero.pr_WUNMS2EW40WPG";
    public static final String MANATEE_CODE_25 = "1A0D4119193EA9195439D21312C17559BEE17BB8E4C069740640388E4781274A";
    public static final String MANATEE_CODE_128 = "9AA93263FD9F4A50F10D7BD00E7A56921E5410DE18CB4F81F7F41078934F91B2";
    public static final String MANATEE_CODE_PDF = "78A382C8E9E660E30C66C5AD817FE5C903EF2A6433179EE387688221FB2A8A77";
//    public static final String MANATEE_LICENSE = "NEcVQmBbts5EtPb3p0t9U0iHNh6/oqGWDx1YK4vIXs4=";

    public static final String APP_LOGIN = "/baggage/applogin/v1.0";

    public static final String APP_SIGNOUT = "/baggage/applogout/v1.0";

    public static final String CHANGE_PASSWORD = "/baggage/resetpassword/v1.0";

    public static final String GET_TRACKING ="trackingconfiguration/v1.0/service_id/{service_id}/airport_code/{airport_code}";

    public static final String FAKE_API = "/baggage/revalidateapikey/v1.0";

    public static final String SESSION_ERROR_1 = "BJYTAPI053";
    public static final String SESSION_ERROR_2 = "BJYTAPI054";
    public static final String SESSION_ERROR_3 = "BJYTAPI032";

}
