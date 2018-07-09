package aero.developer.bagnet.objects;

/**
 * Created by User on 13-Oct-17.
 */

public class SignoutRequest {
    private String user_id = null;
    private String company_id = null;
    private String api_key = null;

    public SignoutRequest(String user_id, String company_id, String api_key) {
        this.user_id = user_id;
        this.company_id = company_id;
        this.api_key = api_key;
    }


    @Override
    public String toString() {
        return "SignoutRequest{" +
                "user_id='" + user_id + '\'' +
                ", company_id='" + company_id + '\'' +
                ", api_key='" + api_key + '\'' +
                '}';
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getCompany_id() {
        return company_id;
    }

    public void setCompany_id(String company_id) {
        this.company_id = company_id;
    }

    public String getApi_key() {
        return api_key;
    }

    public void setApi_key(String api_key) {
        this.api_key = api_key;
    }
}
