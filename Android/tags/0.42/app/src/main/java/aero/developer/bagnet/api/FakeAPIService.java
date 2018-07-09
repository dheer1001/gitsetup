package aero.developer.bagnet.api;

import aero.developer.bagnet.Constants;
import aero.developer.bagnet.objects.FakeAPIResponse;
import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.POST;

/**
 * Created by User on 23-Feb-18.
 */

public interface FakeAPIService {

    @FormUrlEncoded
    @POST(Constants.FAKE_API)
    Call<FakeAPIResponse> revalidateapikey(@Field("request") String request);
}
