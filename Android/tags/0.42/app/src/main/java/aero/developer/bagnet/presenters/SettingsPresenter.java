package aero.developer.bagnet.presenters;

import android.content.Context;
import android.view.View;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.io.IOException;

import aero.developer.bagnet.api.ApiCalls;
import aero.developer.bagnet.dialogs.SettingsDialog;
import aero.developer.bagnet.interfaces.SettingsActions;
import aero.developer.bagnet.objects.LoginData;
import aero.developer.bagnet.objects.SignoutRequest;
import aero.developer.bagnet.objects.SignoutResponse;
import aero.developer.bagnet.utils.Preferences;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * Created by User on 13-Oct-17.
 */

public class SettingsPresenter  implements Callback<SignoutResponse> {

    private Context context;
    private SettingsActions settingsActions;

    public SettingsPresenter(Context context,SettingsActions settingsActions){
        this.context = context;
        this.settingsActions = settingsActions;
    }

    public void signoutApi() {
        String user_id = Preferences.getInstance().getUserID(context);
        String company_id = Preferences.getInstance().getCompanyID(context);

        String json = Preferences.getInstance().getLoginResponse(context);
        LoginData loginData =  new Gson().fromJson(json, new TypeToken<LoginData>() {
        }.getType());


        if(loginData!= null) {
            String api_key = loginData.getApi_key();
            if (SettingsDialog.getInstance().getProgressbar() != null) {
                SettingsDialog.getInstance().getProgressbar().setVisibility(View.VISIBLE);
            }
            SignoutRequest signoutRequest = new SignoutRequest(user_id, company_id, api_key);
            ApiCalls.getInstance().signout(signoutRequest, this);
        }
    }


    @Override
    public void onResponse(Call<SignoutResponse> call, Response<SignoutResponse> response) {
        SignoutResponse signoutResponse = null;
        Gson gson = new Gson();
        if (response.body()!=null) {
            signoutResponse = response.body();
        } else {

                try {
                    signoutResponse = gson.fromJson(response.errorBody().string(), SignoutResponse.class);
                } catch (IOException e) {
                    e.printStackTrace();
            }
        }
        if(signoutResponse == null ) {
            settingsActions.onsignOutClicked();
        }
        if(signoutResponse!= null && signoutResponse.isSuccess() ) {
            settingsActions.onsignOutClicked();
        }else  if (signoutResponse!=null && signoutResponse.getErrors()!=null && signoutResponse.getErrors().size()>0){
            settingsActions.onsignOutClicked();
//            settingsActions.onSignoutFailed(signoutResponse.getErrors().get(0).getError_description());
        }
        if( SettingsDialog.getInstance().getProgressbar()!=null)
            SettingsDialog.getInstance().getProgressbar().setVisibility(View.GONE);

    }

    @Override
    public void onFailure(Call<SignoutResponse> call, Throwable t) {
        if (SettingsDialog.getInstance().getProgressbar() != null) {
            SettingsDialog.getInstance().getProgressbar().setVisibility(View.GONE);
        }
        settingsActions.onsignOutClicked();
    }
}
