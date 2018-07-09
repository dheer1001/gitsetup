package aero.developer.bagnet.objects;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by User on 23-Feb-18.
 */

public class FakeAPIResponse {

    private boolean success;
    private String success_code;
    private String success_message;
    private String api_key;
    private List<Error> errors = new ArrayList<>();


    @Override
    public String toString() {
        return "FakeAPIResponse{" +
                "success=" + success +
                ", success_code='" + success_code + '\'' +
                ", success_message='" + success_message + '\'' +
                ", api_key='" + api_key + '\'' +
                ", errors=" + errors +
                '}';
    }

    public List<Error> getErrors() {
        return errors;
    }

    public void setErrors(List<Error> errors) {
        this.errors = errors;
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

    public String getApi_key() {
        return api_key;
    }

    public void setApi_key(String api_key) {
        this.api_key = api_key;
    }
}
