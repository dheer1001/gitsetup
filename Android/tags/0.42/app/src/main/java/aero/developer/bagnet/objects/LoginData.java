package aero.developer.bagnet.objects;

import java.io.Serializable;

/**
 * Created by User on 12-Oct-17.
 */
public class LoginData implements Serializable {

    private static final long serialVersionUID = 1513909706547467891L;
    private boolean success;
    private String success_code;
    private String success_message;
    private String user_group;
    private String service_id;
    private String airports;
    private String airlines;
    private String api_key;
    private boolean pii_data_sharing;


    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public boolean isPii_data_sharing() {
        return pii_data_sharing;
    }

    public void setPii_data_sharing(boolean pii_data_sharing) {
        this.pii_data_sharing = pii_data_sharing;
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

    @Override
    public String toString() {
        return "LoginData{" +
                "success=" + success +
                ", success_code='" + success_code + '\'' +
                ", success_message='" + success_message + '\'' +
                ", user_group='" + user_group + '\'' +
                ", service_id='" + service_id + '\'' +
                ", airports='" + airports + '\'' +
                ", airlines='" + airlines + '\'' +
                ", api_key='" + api_key + '\'' +
                ", pii_data_sharing=" + pii_data_sharing +
                '}';
    }
}
