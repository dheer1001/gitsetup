package aero.developer.bagnet.api;

import aero.developer.bagnet.Constants;
import aero.developer.bagnet.objects.TrackingResponse;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Path;

/**
 * Created by User on 09-Jan-18.
 */

public interface TrackingService {

    @GET(Constants.GET_TRACKING)
    Call<TrackingResponse> getTrackingService(@Path("service_id") String service_id, @Path("airport_code") String airport_code);
}
