package aero.developer.bagnet.objects;

/**
 * Created by user on 12/15/2016.
 */

public class AssociatedData {
    private String pnr;
    private String passenger_last_name;
    private String passenger_first_name;
    private String inbound_airline_code;
    private String inbound_flight_date;
    private String origin_airport;
    private String outbound_airline_code;
    private String outbound_flight_date;
    private String destination_airport;
    private String inbound_flight_num;
    private String outbound_flight_num;

    public AssociatedData(String pnr, String passenger_last_name, String passenger_first_name, String inbound_airline_code, String inbound_flight_date, String origin_airport, String outbound_airline_code, String outbound_flight_date, String destination_airport, String inbound_flight_num, String outbound_flight_num) {
        this.pnr = pnr;
        this.passenger_last_name = passenger_last_name;
        this.passenger_first_name = passenger_first_name;
        this.inbound_airline_code = inbound_airline_code;
        this.inbound_flight_date = inbound_flight_date;
        this.origin_airport = origin_airport;
        this.outbound_airline_code = outbound_airline_code;
        this.outbound_flight_date = outbound_flight_date;
        this.destination_airport = destination_airport;
        this.inbound_flight_num = inbound_flight_num;
        this.outbound_flight_num = outbound_flight_num;
    }

    public String getPnr() {
        return pnr;
    }

    public void setPnr(String pnr) {
        this.pnr = pnr;
    }

    public String getPassenger_last_name() {
        return passenger_last_name;
    }

    public void setPassenger_last_name(String passenger_last_name) {
        this.passenger_last_name = passenger_last_name;
    }

    public String getPassenger_first_name() {
        return passenger_first_name;
    }

    public void setPassenger_first_name(String passenger_first_name) {
        this.passenger_first_name = passenger_first_name;
    }

    public String getInbound_airline_code() {
        return inbound_airline_code;
    }

    public void setInbound_airline_code(String inbound_airline_code) {
        this.inbound_airline_code = inbound_airline_code;
    }

    public String getInbound_flight_date() {
        return inbound_flight_date;
    }

    public void setInbound_flight_date(String inbound_flight_date) {
        this.inbound_flight_date = inbound_flight_date;
    }

    public String getOrigin_airport() {
        return origin_airport;
    }

    public void setOrigin_airport(String origin_airport) {
        this.origin_airport = origin_airport;
    }

    public String getOutbound_airline_code() {
        return outbound_airline_code;
    }

    public void setOutbound_airline_code(String outbound_airline_code) {
        this.outbound_airline_code = outbound_airline_code;
    }

    public String getOutbound_flight_date() {
        return outbound_flight_date;
    }

    public void setOutbound_flight_date(String outbound_flight_date) {
        this.outbound_flight_date = outbound_flight_date;
    }

    public String getDestination_airport() {
        return destination_airport;
    }

    public void setDestination_airport(String destination_airport) {
        this.destination_airport = destination_airport;
    }

    public String getInbound_flight_num() {
        return inbound_flight_num;
    }

    public void setInbound_flight_num(String inbound_flight_num) {
        this.inbound_flight_num = inbound_flight_num;
    }

    public String getOutbound_flight_num() {
        return outbound_flight_num;
    }

    public void setOutbound_flight_num(String outbound_flight_num) {
        this.outbound_flight_num = outbound_flight_num;
    }

    @Override
    public String toString() {
        return "AssociatedData{" +
                "pnr='" + pnr + '\'' +
                ", passenger_last_name='" + passenger_last_name + '\'' +
                ", passenger_first_name='" + passenger_first_name + '\'' +
                ", inbound_airline_code='" + inbound_airline_code + '\'' +
                ", inbound_flight_date='" + inbound_flight_date + '\'' +
                ", origin_airport='" + origin_airport + '\'' +
                ", outbound_airline_code='" + outbound_airline_code + '\'' +
                ", outbound_flight_date='" + outbound_flight_date + '\'' +
                ", destination_airport='" + destination_airport + '\'' +
                ", inbound_flight_num='" + inbound_flight_num + '\'' +
                ", outbound_flight_num='" + outbound_flight_num + '\'' +
                '}';
    }
}
