package aero.developer.bagnet.objects;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by User on 8/17/2016.
 */
public class TrackBagResponse {
    List<Error> errors = new ArrayList<>();
    private boolean success = false;
    private String success_code = null;
    private String success_message = null;
    private AssociatedData associated_data=null;
    private List<Warning> warnings = new ArrayList<>();

    public List<Warning> getWarnings() {
        return warnings;
    }

    public void setWarnings(List<Warning> warnings) {
        this.warnings = warnings;
    }

    public TrackBagResponse(List<Error> errors, boolean success, String success_message, String success_code, AssociatedData associated_data) {
        this.errors = errors;
        this.success = success;
        this.success_message = success_message;
        this.success_code = success_code;
        this.associated_data = associated_data;
    }

    public TrackBagResponse() {

    }

    public AssociatedData getAssociated_data() {
        return associated_data;
    }

    public void setAssociated_data(AssociatedData associated_data) {
        this.associated_data = associated_data;
    }


    public List<Error> getErrors() {
        return errors;
    }

    public void setErrors(List<Error> errors) {
        this.errors = errors;
    }

    @Override
    public String toString() {
        return "TrackBagResponse{" +
                "errors=" + errors +
                ", success=" + success +
                ", success_code='" + success_code + '\'' +
                ", success_message='" + success_message + '\'' +
                ", associated_data=" + associated_data +
                ", warnings=" + warnings +
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
}
