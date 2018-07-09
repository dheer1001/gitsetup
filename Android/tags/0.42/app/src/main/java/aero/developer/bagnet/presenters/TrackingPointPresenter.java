package aero.developer.bagnet.presenters;

import android.content.Context;

import com.google.gson.Gson;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.api.ApiCalls;
import aero.developer.bagnet.interfaces.RefreshCallback;
import aero.developer.bagnet.objects.LoginResponse;
import aero.developer.bagnet.objects.TrackingResponse;
import aero.developer.bagnet.utils.Preferences;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * Created by User on 09-Jan-18.
 */

public class TrackingPointPresenter implements Callback<TrackingResponse> {
    private Context context;
    private RefreshCallback refreshCallback;
    public static final String CONFIGURATIONS = "configurations";

    public TrackingPointPresenter(Context context ) {
    this.context = context;
    }

    public void TrackingLoopCalls(RefreshCallback refreshCallback) {
        this.refreshCallback = refreshCallback;
        Gson gson = new Gson();
        String loginResponse = Preferences.getInstance().getLoginResponse(context);
        LoginResponse loginresponse = gson.fromJson(loginResponse, LoginResponse.class);
        String service_id = Preferences.getInstance().getServiceid(context);
        if(loginresponse!=null && loginresponse.getAirports() !=null){
            List<String> airportlist = AppController.getInstance().getAirportAirlineFromString(loginresponse.getAirports());
            for (String airport: airportlist) {
                ApiCalls.getInstance().getTrackingService(service_id,airport,this);
            }
        }
    }

    @Override
    public void onResponse(Call<TrackingResponse> call, Response<TrackingResponse> response) {
        TrackingResponse trackingresponse = null;
        Gson gson = new Gson();
        if (response.body()!=null) {
            trackingresponse = response.body();
        } else {
            if (response.isSuccessful()) {
                try {
                    trackingresponse = gson.fromJson(response.errorBody().string(), TrackingResponse.class);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        if(trackingresponse == null) {
            if (refreshCallback != null) {
                refreshCallback.onFinished();
            }
        }
        if (trackingresponse !=null && trackingresponse.isSuccess()) {
            // first call
            if(Preferences.getInstance().getTrackingMap(context)==null) {
                HashMap<String, String> map_list = new HashMap<>();
                if(trackingresponse.getConfigurations()!=null) {
                    map_list.put(trackingresponse.getConfigurations().get(0).getAirport_code(), gson.toJson(trackingresponse));
                    String finalMap = gson.toJson(map_list);
                    Preferences.getInstance().setTrackingMap(context, finalMap);
                }
            }else {// appending preference map
                String mapString = Preferences.getInstance().getTrackingMap(context);
                HashMap<String,Object> map= new HashMap<>();
                map= (HashMap<String,Object>) gson.fromJson(mapString, map.getClass());
                if(trackingresponse.getConfigurations()!=null) {
                    map.put(trackingresponse.getConfigurations().get(0).getAirport_code(), gson.toJson(trackingresponse));
                }
                Preferences.getInstance().setTrackingMap(context,gson.toJson(map));

            }
        }else if(trackingresponse!=null)
        { // response failed
            if(Preferences.getInstance().getTrackingMap(context)==null) {
                HashMap<String, String> map_list = new HashMap<>();
                if(trackingresponse.getConfigurations()!=null && trackingresponse.getConfigurations().size()>0) {
                    map_list.put(trackingresponse.getConfigurations().get(0).getAirport_code(), null);
                    String finalMap = gson.toJson(map_list);
                    Preferences.getInstance().setTrackingMap(context, finalMap);
                }
            }else {// appending preference map
                String mapString = Preferences.getInstance().getTrackingMap(context);
                HashMap<String,Object> map= new HashMap<>();
                map= (HashMap<String,Object>) gson.fromJson(mapString, map.getClass());
                Preferences.getInstance().setTrackingMap(context,gson.toJson(map));
                Preferences.getInstance().setTrackingMap(context,gson.toJson(map));
            }
        }
        if (trackingresponse != null && trackingresponse.getConfigurations() != null && trackingresponse.getConfigurations().size() > 0) {
            if (trackingresponse.getConfigurations().get(0).getAirport_code().equalsIgnoreCase(Preferences.getInstance().getAirportcode(context))) {
                if (refreshCallback != null) {
                    refreshCallback.onFinished();
                }
            }
        }
    }

    @Override
    public void onFailure(Call<TrackingResponse> call, Throwable t) {
        if (refreshCallback != null) {
            refreshCallback.onFinished();
        }
    }
}
