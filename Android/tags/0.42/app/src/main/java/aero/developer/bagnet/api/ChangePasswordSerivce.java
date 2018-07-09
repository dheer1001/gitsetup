package aero.developer.bagnet.api;

import aero.developer.bagnet.Constants;
import aero.developer.bagnet.objects.ChangePasswordResponse;
import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.POST;

/**
 * Created by User on 16-Oct-17.
 */

public interface ChangePasswordSerivce {

    @FormUrlEncoded
    @POST(Constants.CHANGE_PASSWORD)
    Call<ChangePasswordResponse> resetUserPassword(@Field("request") String request);
}
