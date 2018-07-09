package aero.developer.bagnet.loginutils;

import aero.developer.bagnet.R;

/**
 * Created by User on 8/2/2016.
 */
public class LoginPresenter {
    private LoginView loginView;

    public LoginPresenter(LoginView loginView) {
        this.loginView = loginView;
    }


    public void login(){
        if(loginView.isUserIdValid()){
            loginView.setUserIdError(0);
        }else{
            loginView.setUserIdError(R.string.invalid_userID);
        }

        if(loginView.isCompanyIdValid()){
            loginView.setCompanyIdError(0);
        }else{
            loginView.setCompanyIdError(R.string.invalid_companyID);
        }
        
        if(loginView.isPasswordValid()){
            loginView.setPasswordError(0);
        }else{
            loginView.setPasswordError(R.string.invalid_password);
        }

        if (canContinueLogin()){
            loginView.doLogin();
        }
    }

    private boolean canContinueLogin(){
        return loginView.isUserIdValid() && loginView.isPasswordValid() && loginView.isCompanyIdValid();
    }
}
