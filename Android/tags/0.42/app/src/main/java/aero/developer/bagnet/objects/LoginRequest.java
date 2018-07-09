package aero.developer.bagnet.objects;

/**
 * Created by Mohamad Itani on 11-Oct-17.
 */

public class LoginRequest {
    private String user_id = null;
    private String company_id = null;
    private String password = null;

    public LoginRequest (String user_id , String company_id , String password) {
        this.user_id = user_id;
        this.company_id = company_id;
        this.password = password;
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "LoginRequest{" +
                "user_id='" + user_id + '\'' +
                ", company_id='" + company_id + '\'' +
                ", password='" + password + '\'' +
                '}';
    }
}
