package aero.developer.bagnet.api;

import android.content.Context;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.io.IOException;
import java.security.cert.CertificateException;
import java.util.Collections;
import java.util.concurrent.TimeUnit;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.Constants;
import aero.developer.bagnet.R;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.objects.ChangePasswordRequest;
import aero.developer.bagnet.objects.ChangePasswordResponse;
import aero.developer.bagnet.objects.FakeAPIRequest;
import aero.developer.bagnet.objects.FakeAPIResponse;
import aero.developer.bagnet.objects.LoginData;
import aero.developer.bagnet.objects.LoginRequest;
import aero.developer.bagnet.objects.LoginResponse;
import aero.developer.bagnet.objects.SignoutRequest;
import aero.developer.bagnet.objects.SignoutResponse;
import aero.developer.bagnet.objects.TrackBagRequest;
import aero.developer.bagnet.objects.TrackBagResponse;
import aero.developer.bagnet.objects.TrackingResponse;
import aero.developer.bagnet.utils.Analytic;
import aero.developer.bagnet.utils.BagLogger;
import aero.developer.bagnet.utils.Location_Utils;
import aero.developer.bagnet.utils.Preferences;
import aero.developer.bagnet.utils.Utils;
import okhttp3.ConnectionSpec;
import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.TlsVersion;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.converter.scalars.ScalarsConverterFactory;

/**
 * Created by User on 8/5/2016.
 */
public class ApiCalls {
    private static ApiCalls ourInstance = new ApiCalls();
    BagsService service = null;
    LoginService loginService = null;
    SignoutService signoutService = null;
    ChangePasswordSerivce changePasswordSerivce = null;
    TrackingService trackingService = null;
    FakeAPIService fakeAPIService = null;
    public static ApiCalls getInstance() {
        return ourInstance;
    }

    private ApiCalls() {

        /*
        */
        OkHttpClient.Builder httpClient = new OkHttpClient.Builder();
        httpClient.addInterceptor(new Interceptor() {
            @Override
            public Response intercept(Interceptor.Chain chain) throws IOException {
                Request original = chain.request();

                Request request = original.newBuilder()
                        .header("api_key", Constants.api_key)
                        .method(original.method(), original.body())
                        .build();

                return chain.proceed(request);
            }
        });

        ConnectionSpec spec = new ConnectionSpec.Builder(ConnectionSpec.MODERN_TLS)
                .tlsVersions(TlsVersion.TLS_1_0,TlsVersion.TLS_1_1,TlsVersion.TLS_1_2,TlsVersion.SSL_3_0)
                .supportsTlsExtensions(true)
                .allEnabledTlsVersions()
                .allEnabledCipherSuites()
                .build();


        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
        interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);





        /*OkHttpClient client = httpClient.connectionSpecs(Collections.singletonList(spec)).addInterceptor(interceptor)
                .build();
        */
        OkHttpClient client =getUnsafeOkHttpClient().connectionSpecs(Collections.singletonList(spec)).addInterceptor(interceptor).connectTimeout(100, TimeUnit.SECONDS)
                .readTimeout(60,TimeUnit.SECONDS).build();


        Retrofit retrofit = new Retrofit.Builder()
                //.client(getUnsafeOkHttpClient())
                .client(client)
                .baseUrl(Constants.BASE_URL)
                .addConverterFactory(ScalarsConverterFactory.create())
                .addConverterFactory(GsonConverterFactory.create())
                .build();


        service = retrofit.create(BagsService.class);
        loginService = retrofit.create(LoginService.class);
        signoutService = retrofit.create(SignoutService.class);
        changePasswordSerivce = retrofit.create(ChangePasswordSerivce.class);
        trackingService = retrofit.create(TrackingService.class);
        fakeAPIService = retrofit.create(FakeAPIService.class);
    }

    public void getTrackingService(String service_id , String airport_code,Callback<TrackingResponse> callback) {
        Call<TrackingResponse> call = trackingService.getTrackingService(service_id,airport_code);
        call.enqueue(callback);
    }


    public void login(LoginRequest loginRequest, Callback<LoginResponse> callback) {
        Gson gson = new Gson();
        String stringRequest = gson.toJson(loginRequest);
        BagLogger.log(stringRequest);
        Call<LoginResponse> call = loginService.authenticateUser(stringRequest);
        call.enqueue(callback);
    }

    public void signout(SignoutRequest signoutRequest, Callback<SignoutResponse> callback) {
        Gson gson = new Gson();
        String stringRequest = gson.toJson(signoutRequest);
        BagLogger.log(stringRequest);
        Call<SignoutResponse> call = signoutService.authenticateUser(stringRequest);
        call.enqueue(callback);
    }

    public void changePassword(ChangePasswordRequest changePasswordRequest, Callback<ChangePasswordResponse> callback) {
        Gson gson = new Gson();
        String stringRequest = gson.toJson(changePasswordRequest);
        BagLogger.log(stringRequest);
        Call<ChangePasswordResponse> call = changePasswordSerivce.resetUserPassword(stringRequest);
        call.enqueue(callback);
    }



    public void trackBag(Context context, BagTag bagTag, Callback<TrackBagResponse> callback){
        TrackBagRequest request = new TrackBagRequest();
        request.setService_Id(Preferences.getInstance().getServiceid(context));
        request.setAirport_Code(Location_Utils.getAirportCode(bagTag.getTrackingpoint()));
        request.setTracking_point_id(Location_Utils.getEventType(bagTag.getTrackingpoint(),true));

        if (bagTag.getContainerid()!=null && !bagTag.getContainerid().equalsIgnoreCase("")) {
            request.setContainer_id(bagTag.getContainerid().replace(" ",""));
        }
        request.setTracking_location(Location_Utils.getTrackingLocation(bagTag.getTrackingpoint(),true));
        String bagTagstring =bagTag.getBagtag();
        if(bagTagstring!=null){
            request.setLPN(bagTagstring);
        }
        request.setTimestamp(Utils.dateTimeUTC(bagTag.getDatetime()));

        if (bagTag.getFlightnum()!=null){
            request.setFlight_num(bagTag.getFlightnum());
            request.setFlight_type(bagTag.getFlighttype());
            request.setFlight_date(bagTag.getFlightdate());
        }
        if (request.getLPN()!=null){
            // its a bag
            Analytic.getInstance().sendScreen(R.string.EVENT_BAG_TRACK_SYNCHED_SCREEN);
        }else{
            //its a container
            Analytic.getInstance().sendScreen(R.string.EVENT_CONTAINER_TRACK_SYNCHED_SCREEN);
        }
        String airLineCode = Preferences.getInstance().getAirlinecode(context);
        if (airLineCode!=null && !airLineCode.equalsIgnoreCase("<ALL>")) {
            BagLogger.log("airLineCode==== "+airLineCode);
            request.setAirline_Code(airLineCode);
        }else {
            request.setAirline_Code("");
        }

        Gson gson = new Gson();
        String stringRequest = gson.toJson(request);
        BagLogger.log(stringRequest);
        Call<TrackBagResponse> call = service.trackBag(stringRequest);
        call.enqueue(callback);
    }

    public void fakeAPICall(FakeAPIRequest fakeAPIRequest,Callback<FakeAPIResponse> callback) {
        Gson gson = new Gson();
        String stringRequest = gson.toJson(fakeAPIRequest);
        BagLogger.log(stringRequest);
        Call<FakeAPIResponse> call = fakeAPIService.revalidateapikey(stringRequest);
        call.enqueue(callback);
    }

    private static OkHttpClient.Builder getUnsafeOkHttpClient() {
        try {
            final TrustManager[] trustAllCerts = new TrustManager[]{
                    new X509TrustManager() {
                        @Override
                        public void checkClientTrusted(java.security.cert.X509Certificate[] chain, String authType) throws CertificateException {
                        }

                        @Override
                        public void checkServerTrusted(java.security.cert.X509Certificate[] chain, String authType) throws CertificateException {
                        }

                        @Override
                        public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                            return new java.security.cert.X509Certificate[]{};
                        }
                    }
            };

            // Install the all-trusting trust manager
            final SSLContext sslContext = SSLContext.getInstance("SSL");
            sslContext.init(null, trustAllCerts, new java.security.SecureRandom());
            // Create an ssl socket factory with our all-trusting manager
            final SSLSocketFactory sslSocketFactory = sslContext.getSocketFactory();

            OkHttpClient.Builder builder = new OkHttpClient.Builder();
            builder.sslSocketFactory(sslSocketFactory);
            builder.hostnameVerifier(new HostnameVerifier() {
                @Override
                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            });

            builder.addInterceptor(new Interceptor() {
                @Override
                public Response intercept(Interceptor.Chain chain) throws IOException {
                    Request original = chain.request();

                    String api_key = "";
                    LoginData loginData =  new Gson().fromJson(Preferences.getInstance().getLoginResponse(AppController.getInstance().getApplicationContext()), new TypeToken<LoginData>() {
                    }.getType());

                    if(original.url().url().getPath().contains("history/v1.0/tag/")) {
                        Request request = original.newBuilder()
                                .method(original.method(), original.body())
                                .header("api_key", Constants.api_key)
                                .build();
                        return chain.proceed(request);
                    }

                    if(original.url().url().getPath().contains("trackingconfiguration")) {
                        if(loginData!= null && loginData.getApi_key()!=null) {
                            api_key = loginData.getApi_key();
                        }
                        Request request = original.newBuilder()
                                .method(original.method(), original.body())
                                .header("api_key", api_key)
                                .build();
                        return chain.proceed(request);
                    }

                    if(original.url().url().getPath().contains("revalidateapikey")) {
                        Request request = original.newBuilder()
                                .method(original.method(), original.body())
                                .build();
                        return chain.proceed(request);
                    }
                    else{
                    if(loginData!= null && loginData.getApi_key()!=null) {
                        api_key = loginData.getApi_key();
                    }
                        Request request = original.newBuilder()
                                .header("api_key", api_key)
                                .method(original.method(), original.body())
                                .build();
                        return chain.proceed(request);

                    }


                }
            });
            HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
            interceptor.setLevel(HttpLoggingInterceptor.Level.HEADERS);
            builder.addInterceptor(interceptor);

            //OkHttpClient okHttpClient = builder;
            return builder;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

}
