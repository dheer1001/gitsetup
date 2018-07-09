package aero.developer.bagnet.objects;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Flight_info implements Serializable {
    /**
     *
     */
    private static final long serialVersionUID = 4178019363463080456L;
    private Flight_info_item outbound = null;
    private Inbound inbound = null;
    private List<Flight_info_item> onward = new ArrayList<Flight_info_item>();

    public Flight_info() {
    }

    public Flight_info(Flight_info_item outbound, Inbound inbound,
                       List<Flight_info_item> onward) {
        this.outbound = outbound;
        this.inbound = inbound;
        this.onward = onward;
    }

    public Flight_info_item getOutbound() {
        return outbound;
    }

    public void setOutbound(Flight_info_item outbound) {
        this.outbound = outbound;
    }

    public Inbound getInbound() {
        return inbound;
    }

    public void setInbound(Inbound inbound) {
        this.inbound = inbound;
    }

    public List<Flight_info_item> getOnward() {
        return onward;
    }

    public void setOnward(List<Flight_info_item> onward) {
        this.onward = onward;
    }

    @Override
    public String toString() {
        return "Flight_info [outbound=" + outbound + ", inbound=" + inbound
                + ", onward=" + onward + "]";
    }

}
