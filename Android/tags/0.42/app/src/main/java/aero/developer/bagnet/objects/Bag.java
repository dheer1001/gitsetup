package aero.developer.bagnet.objects;

import java.io.Serializable;

public class Bag implements Serializable {

    /**
     *
     */
    private static final long serialVersionUID = 6395814288874961448L;
    private String bagtag = null;
    private String passenger_first_name = null;
    private String passenger_last_name = null;
    private String no_of_checked_bags = null;
    private String weight_indicator = null;
    private String total_weight_of_checkedin_bags = null;

    public Bag() {

    }

    public Bag(String bagtag, String passenger_first_name,
               String passenger_last_name, String no_of_checked_bags,
               String weight_indicator, String total_weight_of_checkedin_bags) {
        this.bagtag = bagtag;
        this.passenger_first_name = passenger_first_name;
        this.passenger_last_name = passenger_last_name;
        this.no_of_checked_bags = no_of_checked_bags;
        this.weight_indicator = weight_indicator;
        this.total_weight_of_checkedin_bags = total_weight_of_checkedin_bags;
    }

    public String getBagtag() {
        return bagtag;
    }

    public void setBagtag(String bagtag) {
        this.bagtag = bagtag;
    }

    public String getPassenger_first_name() {
        return passenger_first_name;
    }

    public void setPassenger_first_name(String passenger_first_name) {
        this.passenger_first_name = passenger_first_name;
    }

    public String getPassenger_last_name() {
        return passenger_last_name;
    }

    public void setPassenger_last_name(String passenger_last_name) {
        this.passenger_last_name = passenger_last_name;
    }

    @Override
    public String toString() {
        return "Bag [bagtag=" + bagtag + ", passenger_first_name="
                + passenger_first_name + ", passenger_last_name="
                + passenger_last_name + ", no_of_checked_bags="
                + no_of_checked_bags + ", weight_indicator=" + weight_indicator
                + ", total_weight_of_checkedin_bags="
                + total_weight_of_checkedin_bags + "]";
    }

    public String getNo_of_checked_bags() {
        return no_of_checked_bags;
    }

    public void setNo_of_checked_bags(String no_of_checked_bags) {
        this.no_of_checked_bags = no_of_checked_bags;
    }

    public String getWeight_indicator() {
        return weight_indicator;
    }

    public void setWeight_indicator(String weight_indicator) {
        this.weight_indicator = weight_indicator;
    }

    public String getTotal_weight_of_checkedin_bags() {
        return total_weight_of_checkedin_bags;
    }

    public void setTotal_weight_of_checkedin_bags(
            String total_weight_of_checkedin_bags) {
        this.total_weight_of_checkedin_bags = total_weight_of_checkedin_bags;
    }

}
