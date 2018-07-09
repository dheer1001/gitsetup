package aero.developer.bagnet.loginutils;

/**
 * Created by User on 8/2/2016.
 */
public interface LoginView {

    String getUserId();
    String getPassword();
    String getCompanyId();
    void setUserIdError(int resourceId);
    void setPasswordError(int resourceId);
    void setCompanyIdError(int resourceId);
    boolean isUserIdValid();
    boolean isPasswordValid();
    boolean isCompanyIdValid();
    void doLogin();
}
