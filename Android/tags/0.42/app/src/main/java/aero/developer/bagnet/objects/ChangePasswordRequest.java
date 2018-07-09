package aero.developer.bagnet.objects;

/**
 * Created by User on 16-Oct-17.
 */
public class ChangePasswordRequest {
    private String user_id = null;
    private String company_id = null;
    private String old_password = null;
    private String new_password = null;
    private String confirm_password = null;

    public ChangePasswordRequest(String user_id,String company_id,String old_password,String new_password,String confirmation_password){
        this.user_id = user_id;
        this.company_id = company_id;
        this.old_password = old_password;
        this.new_password = new_password;
        this.confirm_password = confirmation_password;
    }

    @Override
    public String toString() {
        return "ChangePasswordRequest{" +
                "user_id='" + user_id + '\'' +
                ", company_id='" + company_id + '\'' +
                ", old_password='" + old_password + '\'' +
                ", new_password='" + new_password + '\'' +
                ", confirmation_password='" + confirm_password + '\'' +
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

    public String getOld_password() {
        return old_password;
    }

    public void setOld_password(String old_password) {
        this.old_password = old_password;
    }

    public String getNew_password() {
        return new_password;
    }

    public void setNew_password(String new_password) {
        this.new_password = new_password;
    }

    public String getConfirmation_password() {
        return confirm_password;
    }

    public void setConfirmation_password(String confirmation_password) {
        this.confirm_password = confirmation_password;
    }
}
