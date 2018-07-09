package aero.developer.bagnet.api;

import aero.developer.bagnet.Constants;
import aero.developer.bagnet.objects.TrackBagResponse;
import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.POST;

/**
 * Created by User on 8/5/2016.
 */
public interface BagsService {

    @FormUrlEncoded
    @POST(Constants.BAG_TRACK)
    Call<TrackBagResponse> trackBag(@Field("request") String request);
}
