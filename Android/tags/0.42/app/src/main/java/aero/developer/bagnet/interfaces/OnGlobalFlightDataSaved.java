package aero.developer.bagnet.interfaces;

import aero.developer.bagnet.objects.BagTag;

/**
 * Created by User on 8/11/2016.
 */
public interface OnGlobalFlightDataSaved {
    void flightDataSaved(String flightNumber,String flightType,String flightdate);
    void updateBagTagwithFlightData(String flightNumber, String flightType, String flightdate, BagTag bagTag);
}
