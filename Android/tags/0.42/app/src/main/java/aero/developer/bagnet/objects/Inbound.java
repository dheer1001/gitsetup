package aero.developer.bagnet.objects;

import java.io.Serializable;

public class Inbound implements Serializable {

    /**
     *
     */
    private static final long serialVersionUID = 4243773959023958686L;
    private String date = null;
    private String flight = null;
    private String airline = null;
    private String orig_airport = null;

    public Inbound() {
    }

    public Inbound(String date, String flight, String airline,
                   String orig_airport) {
        this.date = date;
        this.flight = flight;
        this.airline = airline;
        this.orig_airport = orig_airport;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
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

    public String getOrig_airport() {
        return orig_airport;
    }

    public void setOrig_airport(String orig_airport) {
        this.orig_airport = orig_airport;
    }

    @Override
    public String toString() {
        return "Inbound [date=" + date + ", flight=" + flight + ", airline="
                + airline + ", orig_airport=" + orig_airport + "]";
    }
}
