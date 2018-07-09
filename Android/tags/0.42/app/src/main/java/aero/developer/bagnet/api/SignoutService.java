package aero.developer.bagnet.api;

import aero.developer.bagnet.Constants;
import aero.developer.bagnet.objects.SignoutResponse;
import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.POST;

/**
 * Created by User on 13-Oct-17.
 */

public interface SignoutService {


    @FormUrlEncoded
    @POST(Constants.APP_SIGNOUT)
    Call<SignoutResponse> authenticateUser (@Field("request") String request);
}