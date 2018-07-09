package aero.developer.bagnet.objects;

import java.io.Serializable;

public class Warning implements Serializable {
    private String warning_code = null;
    private String warning_message = null;


    @Override
    public String toString() {
        return "Warning{" +
                "warning_code='" + warning_code + '\'' +
                ", warning_message='" + warning_message + '\'' +
                '}';
    }

    public String getWarning_code() {
        return warning_code;
    }

    public void setWarning_code(String warning_code) {
        this.warning_code = warning_code;
    }

    public String getWarning_message() {
        return warning_message;
    }

    public void setWarning_message(String warning_message) {
        this.warning_message = warning_message;
    }
}
