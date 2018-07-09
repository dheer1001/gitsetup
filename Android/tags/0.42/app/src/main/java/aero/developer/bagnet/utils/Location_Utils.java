package aero.developer.bagnet.utils;

import aero.developer.bagnet.AppController;

/**
 * Created by user on 8/4/2016.
 */
public class Location_Utils {
    private static Location_Utils ourInstance = new Location_Utils();

    public static Location_Utils getInstance(){
        if(ourInstance == null)
        {
            ourInstance = new Location_Utils();
        }
        return ourInstance;
    }

    private Location_Utils() {
    }

    public static String getAirportCode(String scannedBarcode){
        String airportCode=null;
        if(scannedBarcode!=null && DataManUtils.isValidTrackingLocation(scannedBarcode, null)) {
            if (scannedBarcode.length() >= 19) {
                airportCode = scannedBarcode.substring(0, 3);
            }
        }
        return airportCode != null ? airportCode.trim() : null;
    }

    public static String getEventType(String scannedBarcode,boolean trim){
        String eventType=null;
        if(scannedBarcode!=null && DataManUtils.isValidTrackingLocation(scannedBarcode,null)) {
            if (scannedBarcode.length() >= 19) {
                eventType = scannedBarcode.substring(3, 11);
            }
        }
        if(trim) {
            return eventType != null ? eventType.trim() : null;
        }
        return eventType != null ? eventType : null;

    }

    public static String getTrackingLocation(String scannedBarcode,boolean trim){
        String trackLocation=null;
        if(scannedBarcode!=null && DataManUtils.isValidTrackingLocation(scannedBarcode,null)) {
            if (scannedBarcode.length() >= 19) {
                trackLocation = scannedBarcode.substring(11, 21);
            }
        }
        if(trim){
            return trackLocation != null ? trackLocation.trim() : null;
        }
        return trackLocation != null ? trackLocation : null;

    }

    public static String getUnknownBags(String scannedBarcode){
        String unknownBags=null;
        if(scannedBarcode!=null && DataManUtils.isValidTrackingLocation(scannedBarcode,null)) {
            if (scannedBarcode.length() >= 20) {
                unknownBags = scannedBarcode.substring(21,22);
            }
        }
        return unknownBags != null ? unknownBags.trim() : null;
    }

    public static String getContainerInput(String scannedBarcode){
        String containerInput=null;
        if(scannedBarcode!=null && DataManUtils.isValidTrackingLocation(scannedBarcode,null)) {
            if (scannedBarcode.length() >= 21) {
                containerInput = scannedBarcode.substring(22,23);
            }
        }
        return containerInput != null ? containerInput.trim() : null;
    }

    public static String getTypeEvent(String scannedBarcode){
        String typeEvent=null;
        if(scannedBarcode!=null && DataManUtils.isValidTrackingLocation(scannedBarcode,AppController.getInstance().getApplicationContext())) {
            if (scannedBarcode.length() >= 22) {
                typeEvent = scannedBarcode.substring(23);
            }
        }
        return typeEvent != null ? typeEvent.trim() : null;
    }



}
