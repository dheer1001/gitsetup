package aero.developer.bagnet.interfaces;

import android.support.v7.widget.AppCompatEditText;

import aero.developer.bagnet.objects.ChangePasswordResponse;
import retrofit2.Response;

/**
 * Created by User on 16-Oct-17.
 */

public interface ChangePasswordActions {

    void onChangeSuccess(Response<ChangePasswordResponse> response);
    void onChangeFailed(String message);
    AppCompatEditText getOldPasswordView();
    AppCompatEditText getnewPasswordView();
    AppCompatEditText getconfirmPasswordView();
}
