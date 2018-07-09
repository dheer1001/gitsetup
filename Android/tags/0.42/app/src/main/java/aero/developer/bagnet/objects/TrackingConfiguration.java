package aero.developer.bagnet.objects;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by User on 09-Jan-18.
 */

public class TrackingConfiguration implements Serializable{
    @SerializedName("group_name")
    private String group_name;
    @SerializedName("airport_code")
    private String airport_code;
    @SerializedName("tracking_id")
    private String tracking_id;
    @SerializedName("system_event")
    private String system_event;
    @SerializedName("description")
    private String description;
    @SerializedName("location")
    private String location;
    @SerializedName("entity")
    private String entity;
    @SerializedName("purpose")
    private String purpose;
    @SerializedName("indicator_for_container_scanning")
    private String indicator_for_container_scanning;
    @SerializedName("indicator_for_unknown_bag_mgmt")
    private String indicator_for_unknown_bag_mgmt;
    @SerializedName("bingo_sheet_scanning")
    private String bingo_sheet_scanning;


    public TrackingConfiguration(String group_name,String airport_code,String tracking_id,String location,String purpose,
                                 String indicator_for_unknown_bag_mgmt,String indicator_for_container_scanning,String Bingo_Sheet_Scanning) {
        this.group_name = group_name;
        this.airport_code = airport_code;
        this.tracking_id = tracking_id;
        this.location = location;
        this.purpose = purpose;
        this.indicator_for_container_scanning = indicator_for_container_scanning;
        this.indicator_for_unknown_bag_mgmt = indicator_for_unknown_bag_mgmt;
        this.bingo_sheet_scanning = Bingo_Sheet_Scanning;
    }
    @Override
    public String toString() {
        return "TrackingConfiguration{" +
                "group_name='" + group_name + '\'' +
                ", airport_code='" + airport_code + '\'' +
                ", tracking_id='" + tracking_id + '\'' +
                ", system_event='" + system_event + '\'' +
                ", description='" + description + '\'' +
                ", location='" + location + '\'' +
                ", entity='" + entity + '\'' +
                ", purpose='" + purpose + '\'' +
                ", indicator_for_container_scanning='" + indicator_for_container_scanning + '\'' +
                ", indicator_for_unknown_bag_mgmt='" + indicator_for_unknown_bag_mgmt + '\'' +
                ", bingo_sheet_scanning='" + bingo_sheet_scanning + '\'' +
                '}';
    }


    public String getGroup_name() {
        return group_name;
    }

    public void setGroup_name(String group_name) {
        this.group_name = group_name;
    }

    public String getAirport_code() {
        return airport_code;
    }

    public void setAirport_code(String airport_code) {
        this.airport_code = airport_code;
    }

    public String getTracking_id() {
        return tracking_id;
    }

    public void setTracking_id(String tracking_id) {
        this.tracking_id = tracking_id;
    }

    public String getSystem_event() {
        return system_event;
    }

    public void setSystem_event(String system_event) {
        this.system_event = system_event;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getEntity() {
        return entity;
    }

    public void setEntity(String entity) {
        this.entity = entity;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public String getIndicator_for_container_scanning() {
        return indicator_for_container_scanning;
    }

    public void setIndicator_for_container_scanning(String indicator_for_container_scanning) {
        this.indicator_for_container_scanning = indicator_for_container_scanning;
    }

    public String getIndicator_for_unknown_bag_mgmt() {
        return indicator_for_unknown_bag_mgmt;
    }

    public void setIndicator_for_unknown_bag_mgmt(String indicator_for_unknown_bag_mgmt) {
        this.indicator_for_unknown_bag_mgmt = indicator_for_unknown_bag_mgmt;
    }

    public String getBingo_sheet_scanning() {
        return bingo_sheet_scanning;
    }

    public void setBingo_sheet_scanning(String bingo_sheet_scanning) {
        this.bingo_sheet_scanning = bingo_sheet_scanning;
    }
}
