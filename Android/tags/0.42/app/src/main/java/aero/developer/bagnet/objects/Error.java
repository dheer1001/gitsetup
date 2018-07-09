package aero.developer.bagnet.objects;

import java.io.Serializable;

public class Error implements Serializable {
    /**
     *
     */
    private static final long serialVersionUID = -6261633480312891723L;
    private String error_code = null;
    private String error_description = null;

    public Error() {
    }

    public Error(String error_code, String error_description) {
        this.error_code = error_code;
        this.error_description = error_description;
    }

    public String getError_code() {
        return error_code;
    }

    public void setError_code(String error_code) {
        this.error_code = error_code;
    }

    public String getError_description() {
        return error_description;
    }

    public void setError_description(String error_description) {
        this.error_description = error_description;
    }

    @Override
    public String toString() {
        return "Error [error_code=" + error_code + ", error_description="
                + error_description + "]";
    }

}
