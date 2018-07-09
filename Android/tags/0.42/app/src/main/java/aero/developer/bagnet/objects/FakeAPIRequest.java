package aero.developer.bagnet.objects;

/**
 * Created by User on 23-Feb-18.
 */

public class FakeAPIRequest {

    private String user_id;
    private String company_id;
    private String api_key;


    public FakeAPIRequest(String UserID,String CompanyID,String API_KEY) {
        this.user_id = UserID;
        this.company_id = CompanyID;
        this.api_key = API_KEY;
    }

    @Override
    public String toString() {
        return "FakeAPIRequest{" +
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

    public void setCompany_id(String comapny_id) {
        this.company_id = comapny_id;
    }

    public String getApi_key() {
        return api_key;
    }

    public void setApi_key(String api_key) {
        this.api_key = api_key;
    }
}
