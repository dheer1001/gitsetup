package aero.developer.bagnet.api;

import aero.developer.bagnet.Constants;
import aero.developer.bagnet.objects.LoginResponse;
import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.POST;

/**
 * Created by User on 11-Oct-17.
 */

public interface LoginService {

    @FormUrlEncoded
    @POST(Constants.APP_LOGIN)
    Call<LoginResponse> authenticateUser(@Field("request") String request);
}
