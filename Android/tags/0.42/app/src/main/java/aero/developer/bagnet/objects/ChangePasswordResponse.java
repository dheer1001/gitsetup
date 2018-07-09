package aero.developer.bagnet.objects;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by User on 16-Oct-17.
 */
public class ChangePasswordResponse {

    private boolean success = false;
    private String success_code = null;
    private String success_message = null;
    private List<Error> errors = new ArrayList<>();


    @Override
    public String toString() {
        return "ChangePasswordResponse{" +
                "success=" + success +
                ", success_code='" + success_code + '\'' +
                ", success_message='" + success_message + '\'' +
                ", errors=" + errors +
                '}';
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
}
