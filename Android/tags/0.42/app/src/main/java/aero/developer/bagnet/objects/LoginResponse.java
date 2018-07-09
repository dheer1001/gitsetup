package aero.developer.bagnet.objects;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by User on 11-Oct-17.
 */

public class LoginResponse {

    private boolean success = false;
    private String success_code = null;
    private String success_message = null;
    private List<Error> errors = new ArrayList<>();
    private String user_group;
    private String service_id;
    private String airports;
    private String airlines;
    private String api_key;
    private String password_expiry_date;
    private boolean pii_data_sharing;
    private LoginData loginData;

    public boolean isPii_data_sharing() {
        return pii_data_sharing;
    }

    public void setPii_data_sharing(boolean pii_data_sharing) {
        this.pii_data_sharing = pii_data_sharing;
    }

    public String getUser_group() {
        return user_group;
    }

    public void setUser_group(String user_group) {
        this.user_group = user_group;
    }

    public String getService_id() {
        return service_id;
    }

    public void setService_id(String service_id) {
        this.service_id = service_id;
    }

    public String getAirports() {
        return airports;
    }

    public void setAirports(String airports) {
        this.airports = airports;
    }

    public String getAirlines() {
        return airlines;
    }

    public void setAirlines(String airlines) {
        this.airlines = airlines;
    }

    public String getApi_key() {
        return api_key;
    }

    public void setApi_key(String api_key) {
        this.api_key = api_key;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getSuccess_code() {
        return success_code;
    }

    public void setSuccess_code(String success_code) {
        this.success_code = success_code;
    }

    public String getSuccess_message() {
        return success_message;
    }

    public void setSuccess_message(String success_message) {
        this.success_message = success_message;
    }

    public List<Error> getErrors() {
        return errors;
    }

    public void setErrors(List<Error> errors) {
        this.errors = errors;
    }

    public LoginData getLoginData() {
        return loginData;
    }

    public String getPassword_expiry_date() {
        return password_expiry_date;
    }

    public void setPassword_expiry_date(String password_expiry_date) {
        this.password_expiry_date = password_expiry_date;
    }

    public void setLoginData(LoginData loginData) {
        this.loginData = loginData;
    }

    @Override
    public String toString() {
        return "LoginResponse{" +
                "success=" + success +
                ", success_code='" + success_code + '\'' +
                ", success_message='" + success_message + '\'' +
                ", errors=" + errors +
                ", user_group='" + user_group + '\'' +
                ", service_id='" + service_id + '\'' +
                ", airports='" + airports + '\'' +
                ", airlines='" + airlines + '\'' +
                ", api_key='" + api_key + '\'' +
                ", password_expiry_date='" + password_expiry_date + '\'' +
                ", pii_data_sharing=" + pii_data_sharing +
                ", loginData=" + loginData +
                '}';
    }
}
