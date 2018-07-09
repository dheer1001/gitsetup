package aero.developer.bagnet.objects;

/**
 * Created by User on 8/17/2016.
 */
public class TrackBagRequest {
    private String service_id = null;
    private String airport_code = null;
    private String airline_code = null;
    private String tracking_point_id = null;
    private String response_required = "D";
    private String container_id = null;
    private String tracking_location = null;
    private String LPN = null;
    private String GUID = null;
    private String timestamp = null;
    private String flight_num = null;
    private String flight_date = null;
    private String flight_type = null;

    public TrackBagRequest() {

    }

    public TrackBagRequest(String service_Id, String airport_Code, String airline_Code, String tracking_point_id, String response_required, String container_id, String tracking_location, String LPN, String GUID, String timestamp, String flight_num, String flight_date, String flight_type) {
        this.service_id = service_Id;
        this.airport_code = airport_Code;
        this.airline_code = airline_Code;
        this.tracking_point_id = tracking_point_id;
        this.response_required = response_required;
        this.container_id = container_id;
        this.tracking_location = tracking_location;
        this.LPN = LPN;
        this.GUID = GUID;
        this.timestamp = timestamp;
        this.flight_num = flight_num;
        this.flight_date = flight_date;
        this.flight_type = flight_type;
    }

    @Override
    public String toString() {
        return "TrackBagRequest{" +
                "service_Id='" + service_id + '\'' +
                ", airport_Code='" + airport_code + '\'' +
                ", airline_Code='" + airline_code + '\'' +
                ", tracking_point_id='" + tracking_point_id + '\'' +
                ", response_required='" + response_required + '\'' +
                ", container_id='" + container_id + '\'' +
                ", tracking_location='" + tracking_location + '\'' +
                ", LPN='" + LPN + '\'' +
                ", GUID='" + GUID + '\'' +
                ", timestamp='" + timestamp + '\'' +
                ", flight_num='" + flight_num + '\'' +
                ", flight_date='" + flight_date + '\'' +
                ", flight_type='" + flight_type + '\'' +
                '}';
    }

    public String getService_Id() {
        return service_id;
    }

    public void setService_Id(String service_Id) {
        this.service_id = service_Id;
    }

    public String getAirport_Code() {
        return airport_code;
    }

    public void setAirport_Code(String airport_Code) {
        this.airport_code = airport_Code;
    }

    public String getAirline_Code() {
        return airline_code;
    }

    public void setAirline_Code(String airline_Code) {
        this.airline_code = airline_Code;
    }

    public String getTracking_point_id() {
        return tracking_point_id;
    }

    public void setTracking_point_id(String tracking_point_id) {
        this.tracking_point_id = tracking_point_id;
    }

    public String getResponse_required() {
        return response_required;
    }

    public void setResponse_required(String response_required) {
        this.response_required = response_required;
    }

    public String getContainer_id() {
        return container_id;
    }

    public void setContainer_id(String container_id) {
        this.container_id = container_id;
    }

    public String getTracking_location() {
        return tracking_location;
    }

    public void setTracking_location(String tracking_location) {
        this.tracking_location = tracking_location;
    }

    public String getLPN() {
        return LPN;
    }

    public void setLPN(String LPN) {
        this.LPN = LPN;
    }

    public String getGUID() {
        return GUID;
    }

    public void setGUID(String GUID) {
        this.GUID = GUID;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getFlight_num() {
        return flight_num;
    }

    public void setFlight_num(String flight_num) {
        this.flight_num = flight_num;
    }

    public String getFlight_date() {
        return flight_date;
    }

    public void setFlight_date(String flight_date) {
        this.flight_date = flight_date;
    }

    public String getFlight_type() {
        return flight_type;
    }

    public void setFlight_type(String flight_type) {
        this.flight_type = flight_type;
    }
}
