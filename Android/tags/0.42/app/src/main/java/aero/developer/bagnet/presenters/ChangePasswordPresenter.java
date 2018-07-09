package aero.developer.bagnet.presenters;

import android.content.Context;

import com.google.gson.Gson;

import java.io.IOException;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.api.ApiCalls;
import aero.developer.bagnet.interfaces.ChangePasswordActions;
import aero.developer.bagnet.objects.ChangePasswordRequest;
import aero.developer.bagnet.objects.ChangePasswordResponse;
import aero.developer.bagnet.utils.Preferences;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * Created by User on 16-Oct-17.
 */

public class ChangePasswordPresenter implements Callback<ChangePasswordResponse> {
    private Context context;
    ChangePasswordActions changePasswordActions;

    public ChangePasswordPresenter(Context context,ChangePasswordActions changePasswordActions){
        this.context = context;
        this.changePasswordActions = changePasswordActions;
    }

    public void changePasswordApi() {

        ChangePasswordRequest changePasswordRequest = new ChangePasswordRequest(
                Preferences.getInstance().getUserID(context),
                Preferences.getInstance().getCompanyID(context),
                AppController.getInstance().sha256(changePasswordActions.getOldPasswordView().getText().toString()),
                AppController.getInstance().sha256(changePasswordActions.getnewPasswordView().getText().toString()),
                AppController.getInstance().sha256(changePasswordActions.getconfirmPasswordView().getText().toString())
                );

        ApiCalls.getInstance().changePassword(changePasswordRequest,this);

    }

    @Override
    public void onResponse(Call<ChangePasswordResponse> call, Response<ChangePasswordResponse> response) {
        ChangePasswordResponse changePasswordResponse = null;
        Gson gson = new Gson();
        if (response.body() != null) {
            changePasswordResponse = response.body();
        } else {
            if (response.isSuccessful()) {
                try {
                    changePasswordResponse = gson.fromJson(response.errorBody().string(), ChangePasswordResponse.class);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        if(changePasswordResponse == null) {
            changePasswordActions.onChangeFailed(context.getResources().getString(R.string.Network_Connection_Issue));
        }
        if (changePasswordResponse != null && changePasswordResponse.isSuccess()) {
            changePasswordActions.onChangeSuccess(response);
        } else if (changePasswordResponse != null && changePasswordResponse.getErrors() != null && changePasswordResponse.getErrors().size() > 0) {
            changePasswordActions.onChangeFailed(changePasswordResponse.getErrors().get(0).getError_description());

        }
    }

    @Override
    public void onFailure(Call<ChangePasswordResponse> call, Throwable t) {
        changePasswordActions.onChangeFailed(context.getResources().getString(R.string.Network_Connection_Issue));
    }
}
