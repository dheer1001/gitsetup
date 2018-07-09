package aero.developer.bagnet.objects;

import java.io.Serializable;

public class Flight_info_item implements Serializable {
    /**
     *
     */
    private static final long serialVersionUID = 7478072025934114427L;
    private String date = null;
    private String dest_airport = null;
    private String flight = null;
    private String airline = null;

    public Flight_info_item() {
    }

    public Flight_info_item(String date, String dest_airport, String flight,
                            String airline) {
        this.date = date;
        this.dest_airport = dest_airport;
        this.flight = flight;
        this.airline = airline;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getDest_airport() {
        return dest_airport;
    }

    public void setDest_airport(String dest_airport) {
        this.dest_airport = dest_airport;
    }

    public String getFlight() {
        return flight;
    }

    public void setFlight(String flight) {
        this.flight = flight;
    }

    public String getAirline() {
        return airline;
    }

    public void setAirline(String airline) {
        this.airline = airline;
    }

    @Override
    public String toString() {
        return "Flight_info_item [date=" + date + ", dest_airport="
                + dest_airport + ", flight=" + flight + ", airline=" + airline
                + "]";
    }

}
