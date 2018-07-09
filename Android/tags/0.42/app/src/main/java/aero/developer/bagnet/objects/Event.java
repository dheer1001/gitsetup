package aero.developer.bagnet.objects;

import java.io.Serializable;
public class Event implements Serializable {
    /**
     *
     */
    private static final long serialVersionUID = 844614801092634719L;
    private String airport = null;
    private EventStatus event_code = null;
    private String event_desc = null;
    private String local_date_time = null;
    private String passenger_status = null;
    private String utc_date_time = null;
    private Flight_info flight_info = null;
    private Flight_info_item flight_loading_info = null;
    private Flight_info_item connection_flight_info = null;
    private String read_location = null;
    private String sent_location = null;
    private String frequent_flyer = null;
    private String pnr = null;
    private String aircraft_compartment = null;

    public Event() {
    }

    public Event(String airport, EventStatus event_code, String event_desc,
                 String local_date_time, String passenger_status,
                 String utc_date_time, Flight_info flight_info,
                 Flight_info_item flight_loading_info,
                 Flight_info_item connection_flight_info, String read_location,
                 String sent_location, String frequent_flyer, String pnr,
                 String aircraft_compartment) {
        super();
        this.airport = airport;
        this.event_code = event_code;
        this.event_desc = event_desc;
        this.local_date_time = local_date_time;
        this.passenger_status = passenger_status;
        this.utc_date_time = utc_date_time;
        this.flight_info = flight_info;
        this.flight_loading_info = flight_loading_info;
        this.connection_flight_info = connection_flight_info;
        this.read_location = read_location;
        this.sent_location = sent_location;
        this.frequent_flyer = frequent_flyer;
        this.pnr = pnr;
        this.setAircraft_compartment(aircraft_compartment);
    }

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public String getAirport() {
        return airport;
    }

    public void setAirport(String airport) {
        this.airport = airport;
    }

    public void setEvent_code(EventStatus event_code) {
        this.event_code = event_code;
    }

    public String getEvent_desc() {
        return event_desc;
    }

    public void setEvent_desc(String event_desc) {
        this.event_desc = event_desc;
    }

    public String getLocal_date_time() {
        return local_date_time;
    }

    public void setLocal_date_time(String local_date_time) {
        this.local_date_time = local_date_time;
    }

    public String getPassenger_status() {
        return passenger_status;
    }

    public void setPassenger_status(String passenger_status) {
        this.passenger_status = passenger_status;
    }

    public void setUtc_date_time(String utc_date_time) {
        this.utc_date_time = utc_date_time;
    }

    public Flight_info getFlight_info() {
        return flight_info;
    }

    public void setFlight_info(Flight_info flight_info) {
        this.flight_info = flight_info;
    }

    public Flight_info_item getFlight_loading_info() {
        return flight_loading_info;
    }

    public void setFlight_loading_info(Flight_info_item flight_loading_info) {
        this.flight_loading_info = flight_loading_info;
    }

    public Flight_info_item getConnection_flight_info() {
        return connection_flight_info;
    }

    public void setConnection_flight_info(
            Flight_info_item connection_flight_info) {
        this.connection_flight_info = connection_flight_info;
    }

    public String getRead_location() {
        return read_location;
    }

    public void setRead_location(String read_location) {
        this.read_location = read_location;
    }

    public String getSent_location() {
        return sent_location;
    }

    public void setSent_location(String sent_location) {
        this.sent_location = sent_location;
    }

    public String getFrequent_flyer() {
        return frequent_flyer;
    }

    public void setFrequent_flyer(String frequent_flyer) {
        this.frequent_flyer = frequent_flyer;
    }

    public String getPnr() {
        return pnr;
    }

    public void setPnr(String pnr) {
        this.pnr = pnr;
    }

    /**
     * @return the aircraft_compartment
     */
    public String getAircraft_compartment() {
        return aircraft_compartment;
    }

    /**
     * @param aircraft_compartment the aircraft_compartment to set
     */
    public void setAircraft_compartment(String aircraft_compartment) {
        this.aircraft_compartment = aircraft_compartment;
    }

    @Override
    public String toString() {
        return "Event [airport=" + airport + ", event_code=" + event_code
                + ", event_desc=" + event_desc + ", local_date_time="
                + local_date_time + ", passenger_status=" + passenger_status
                + ", utc_date_time=" + utc_date_time + ", flight_info="
                + flight_info + ", flight_loading_info=" + flight_loading_info
                + ", connection_flight_info=" + connection_flight_info
                + ", read_location=" + read_location + ", sent_location="
                + sent_location + ", frequent_flyer=" + frequent_flyer
                + ", pnr=" + pnr + ", aircraft_compartment="
                + aircraft_compartment + "]";
    }

}
