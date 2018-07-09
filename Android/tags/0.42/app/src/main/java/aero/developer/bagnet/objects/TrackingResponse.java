package aero.developer.bagnet.objects;

import java.util.ArrayList;

/**
 * Created by User on 09-Jan-18.
 */

public class TrackingResponse {
    private boolean success = false;
    private ArrayList<TrackingConfiguration> configurations;


    @Override
    public String toString() {
        return "TrackingResponse{" +
                "success=" + success +
                ", configurations=" + configurations +
                '}';
    }

    public ArrayList<TrackingConfiguration> getConfigurations() {
        return configurations;
    }

    public void setConfigurations(ArrayList<TrackingConfiguration> configurations) {
        this.configurations = configurations;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }
}
