package aero.developer.bagnet.utils;

import android.content.Context;

import com.cognex.dataman.sdk.DataManSystem;
import com.cognex.dataman.sdk.DmccResponse;

import java.io.IOException;
import java.io.InputStream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.Constants;
import aero.developer.bagnet.R;
import aero.developer.bagnet.dialogs.ApiResponseDialog;

/**
 * Created by User on 8/2/2016.
 */
public class DataManUtils {

    public static void disablePDF417(DataManSystem dataManSystem){
        if (dataManSystem!=null && dataManSystem.isConnected()){
            executePDF417Command(dataManSystem,"OFF");
        }

    }
    public static void enablePDF417(DataManSystem dataManSystem){
        if (dataManSystem!=null && dataManSystem.isConnected()){
            executePDF417Command(dataManSystem,"ON");
            enableQRCode(dataManSystem);
        }

    }

    private static void executePDF417Command(DataManSystem dataManSystem, final String status) {
        dataManSystem.sendCommand("SET SYMBOL.PDF417 "+status,new DataManSystem.OnResponseReceivedListener() {

            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                BagLogger.log("BARCODE Status = SET SYMBOL.PDF417  is " + status);
            }
        });
    }


    public static void disable2of5Interleaved(DataManSystem dataManSystem){
        if (dataManSystem!=null && dataManSystem.isConnected()){
            execute2of5InterleavedCommand(dataManSystem,"OFF");
        }

    }
    public static void enable2of5Interleaved(DataManSystem dataManSystem){
        if (dataManSystem!=null && dataManSystem.isConnected()){
            execute2of5InterleavedCommand(dataManSystem,"ON");
        }

    }

    private static void execute2of5InterleavedCommand(DataManSystem dataManSystem, final String status) {
        dataManSystem.sendCommand("SET SYMBOL.I2O5 "+status,new DataManSystem.OnResponseReceivedListener() {

            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                BagLogger.log("BARCODE Status = SET SYMBOL.I2O5  is " + status);
            }
        });
    }




    public static void disableCode128(DataManSystem dataManSystem){
        if (dataManSystem!=null && dataManSystem.isConnected()){
            executeCode128Command(dataManSystem,"OFF");
        }

    }
    public static void enableCode128(DataManSystem dataManSystem){
        if (dataManSystem!=null && dataManSystem.isConnected()){
            executeCode128Command(dataManSystem,"ON");
        }

    }

    public static void enableQRCode(DataManSystem dataManSystem){
        if (dataManSystem!=null && dataManSystem.isConnected()){
            executeQRCommand(dataManSystem,"ON");
        }

    }

    private static void executeCode128Command(DataManSystem dataManSystem, final String status) {
        dataManSystem.sendCommand("SET SYMBOL.C128 " + status, new DataManSystem.OnResponseReceivedListener() {

            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                BagLogger.log("BARCODE Status = SET SYMBOL.C128 is " + status);
            }
        });
    }
    private static void executeQRCommand(DataManSystem dataManSystem, final String status) {
        dataManSystem.sendCommand("SET SYMBOL.QR " + status, new DataManSystem.OnResponseReceivedListener() {

            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                BagLogger.log("BARCODE Status = SET SYMBOL.QR is " + status);
            }
        });
    }


    public static void isCode128Active(DataManSystem dataManSystem){
        if (dataManSystem!=null && dataManSystem.isConnected()) {
            dataManSystem.sendCommand("GET SYMBOL.C39", new DataManSystem.OnResponseReceivedListener() {

                @Override
                public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                    BagLogger.log("CHECK-YMBOL.C39 " + response.getPayLoad());
                }
            });
        }

    }
    public static void is2of5Active(DataManSystem dataManSystem){
        if (dataManSystem!=null && dataManSystem.isConnected()) {
            dataManSystem.sendCommand("GET SYMBOL.I2O5", new DataManSystem.OnResponseReceivedListener() {

                @Override
                public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                    BagLogger.log("CHECK-SYMBOL.I2O5 " + response.getPayLoad());
                }
            });
        }

    }


    public static boolean isValidTrackingLocation(String trackingLocation, final Context context) {
        //noinspection Annotator
        String regularExpressionOfBarcode = "^[A-Za-z_\\s]{3}[A-Za-z0-9_\\s]{8}[A-Za-z0-9_\\s]{10}([ISU]){1}([YNC]){0,1}([LTB]){0,1}$";
        String message = "";
        if (trackingLocation != null ) {

            // Not Valid BINGO
            if(context != null && trackingLocation.length()>22 && trackingLocation.substring(23).equalsIgnoreCase("B")) {
                if (Preferences.getInstance().getScannerType(context).equalsIgnoreCase(context.getResources().getString(R.string.soft_scan))) {
                    message = context.getResources().getString(R.string.invalid_location_scanner);
                } else {
                    if (!trackingLocation.substring(22, 23).equalsIgnoreCase("N") || (!trackingLocation.substring(21, 22).equalsIgnoreCase("I") &&
                            !trackingLocation.substring(21, 22).equalsIgnoreCase("S"))) {
                        message = context.getResources().getString(R.string.invalid_location);
                    }
                }
                if (!message.equalsIgnoreCase("")) {
                    ApiResponseDialog.getInstance().showDialog(message,false,false,true,Constants.ResponseDialogExpireTime,false);
                    return false;
                }
            }
            Pattern p = Pattern.compile(regularExpressionOfBarcode);
            Matcher m = p.matcher(trackingLocation);
                if (m.matches()) {
                    String selected_airport = Preferences.getInstance().getAirportcode(AppController.getInstance());
                    if(context != null && selected_airport!=null && !selected_airport.equalsIgnoreCase("<ALL>") &&
                            !selected_airport.equalsIgnoreCase(trackingLocation.substring(0,3)) ) {
                                ApiResponseDialog.getInstance().showDialog(context.getResources().getString(R.string.trackingPointValidationError), false,true,false,Constants.ResponseDialogExpireTime * 2,false);
                        return false;
                    }
                }
            return m.matches();
        }
        return false;
    }

    public static boolean isValidTrackingLocationWithoutErrorDialog(String trackingLocation, Context context) {
        //noinspection Annotator
        String regularExpressionOfBarcode = "^[A-Za-z]{3}[A-Za-z0-9_\\s]{8}[A-Za-z0-9_\\s]{10}([ISU]){1}([YNC]){0,1}([LTB]){0,1}$";
        if (trackingLocation != null ) {
            if (context != null &&
                    (( (trackingLocation.length()>22 && trackingLocation.substring(23).equalsIgnoreCase("B") &&
                            (trackingLocation.substring(22, 23).equalsIgnoreCase("C") || trackingLocation.substring(22, 23).equalsIgnoreCase("Y")|| trackingLocation.substring(21, 22).equalsIgnoreCase("U") ||
                                    Preferences.getInstance().getScannerType(context).equalsIgnoreCase(context.getResources().getString(R.string.soft_scan))) ) ))) {
                return false;
            }
            Pattern p = Pattern.compile(regularExpressionOfBarcode);
            Matcher m = p.matcher(trackingLocation);

            return m.matches();
        }
        return false;
    }

    @SuppressWarnings("Annotator")
    public static  boolean isValidContainer(String containerCode){
        if(AppController.getInstance().getApplicationContext() !=null) {
            String trackingLocation = Preferences.getInstance().getTrackingLocation(AppController.getInstance().getApplicationContext());
            String containerInput = Location_Utils.getContainerInput(trackingLocation);
            if (containerInput != null && containerInput.equalsIgnoreCase("N")) {
                return false;
            }
        }
        String containerSpec = "^[^CEIOTceiot]{1}([^C-Fc-fT-Zt-z H-Jh-j Oo]){1}[^Q-T q-t Ii Oo Ww]{1}\\s[0-9]{5}\\s[A-Za-z]{2,3}$";
        if(containerCode!=null) {
            Pattern p = Pattern.compile(containerSpec);
            Matcher m = p.matcher(containerCode);
            return m.matches();
        }
        return false;
    }

    public static boolean checkifThisContainerWithoutSpaces(String containerCode){
        @SuppressWarnings("Annotator") String containerSpec = "^[^CEIOTceiot]{1}([^C-Fc-fT-Zt-z H-Jh-j Oo]){1}[^Q-T q-t Ii Oo Ww]{1}[0-9]{5}[A-Za-z]{2,3}$";
        if(containerCode!=null) {
            Pattern p = Pattern.compile(containerSpec);
            Matcher m = p.matcher(containerCode);
            return m.matches();
        }
        return false;
    }


    public static  boolean isValidBag(String bagTag){
        String containerSpec = "^[A-Za-z0-9_]{10}$";
        if(bagTag!=null) {
            Pattern p = Pattern.compile(containerSpec);
            Matcher m = p.matcher(bagTag);
            return m.matches();
        }
        return false;
    }


    public static void powerOff(DataManSystem dataManSystem) {
        dataManSystem.sendCommand("SET POWER.POWEROFF-TIMEOUT " + (2640), new DataManSystem.OnResponseReceivedListener() {

            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                BagLogger.log("SET POWER.POWEROFF-TIMEOUT " + (2640) + response.getPayLoad());
            }
        });

        dataManSystem.sendCommand("SET POWER.HIBERNATE-TIMEOUT " + (2640), new DataManSystem.OnResponseReceivedListener() {

            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                BagLogger.log("SET POWER.HIBERNATE-TIMEOUT " + (2640) + response.getPayLoad());
            }
        });


    }

    public static void reboot(DataManSystem dataManSystem) {
        BagLogger.log("executing reboot");
        dataManSystem.sendCommand("REBOOT" , new DataManSystem.OnResponseReceivedListener() {

            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                BagLogger.log("REBOOT " + response.getPayLoad());
            }


        });
    }

    public static void saveConfig(DataManSystem dataManSystem) {
        dataManSystem.sendCommand("CONFIG.SAVE", new DataManSystem.OnResponseReceivedListener() {
            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                BagLogger.log("CONFIG.SAVE" + response.getPayLoad());
            }
        });
    }

    public static void forceChargingMode(DataManSystem dataManSystem) {
        dataManSystem.sendCommand("SET ANDROID.ROLE 2", new DataManSystem.OnResponseReceivedListener() {
            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                BagLogger.log("SET ANDROID.ROLE 2" + response.getPayLoad());
                Preferences.getInstance().setIS_FORCE_CHARGING_ENABLED(AppController.getInstance().getApplicationContext(),true);
                saveConfig(dataManSystem);
            }
        });

        dataManSystem.sendCommand("SET ANDROID.AOA-SWITCH-TIMEOUT 0", new DataManSystem.OnResponseReceivedListener() {
            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                BagLogger.log("SET ANDROID.AOA-SWITCH-TIMEOUT 0" + response.getPayLoad());
            }
        });
    }

    public static void uploadScript(DataManSystem dataManSystem) {
        byte[] format_byteArr = format_script_ByteArray();
        dataManSystem.sendCommand("SCRIPT.LOAD " + format_byteArr.length, format_byteArr, 5*1000, false, new DataManSystem.OnResponseReceivedListener() {
            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse dmccResponse) {
            }
        });

        byte[] com_script_byteArr = com_script_ByteArray();
        dataManSystem.sendCommand("SET COM.SCRIPT " + com_script_byteArr.length, com_script_byteArr, 5*1000, false, new DataManSystem.OnResponseReceivedListener() {
            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse dmccResponse) {
            }
        });
    }

    public static void enableContinuousMode(DataManSystem dataManSystem) {
        dataManSystem.sendCommand("SET COM.SCRIPT-ENABLED ON", new DataManSystem.OnResponseReceivedListener() {
            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
            }
        });

        dataManSystem.sendCommand("SET FORMAT.MODE 1", new DataManSystem.OnResponseReceivedListener() {
            @Override
            public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
            }
        });
    }

    public static void turnBeepOFF(DataManSystem dataManSystem) {
        dataManSystem.sendCommand("SET BEEP.GOOD 0 1");
    }

    public static void turnBeepON(DataManSystem dataManSystem) {
        dataManSystem.sendCommand("SET BEEP.GOOD 1 1");
    }

    public static void fireBeep(DataManSystem dataManSystem ) {
        dataManSystem.sendCommand("BEEP 1 1");
    }

    public static void fireBeepTwice(DataManSystem dataManSystem ) {
        dataManSystem.sendCommand("BEEP 2 2");
    }

    public static void disableContinuousMode(DataManSystem dataManSystem) {

        dataManSystem.sendCommand("SET COM.SCRIPT-ENABLED OFF");
    }

    private static byte [] format_script_ByteArray()  {
        InputStream inputStream = AppController.getInstance().getApplicationContext().getResources().openRawResource(R.raw.format_script);
        try {
            int size = inputStream.available();
            byte[] buffer = new byte[size];
            inputStream.read(buffer);
            inputStream.close();
            return buffer;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    private static byte [] com_script_ByteArray()  {
        InputStream inputStream = AppController.getInstance().getApplicationContext().getResources().openRawResource(R.raw.com_script);
        try {
            int size = inputStream.available();
            byte[] buffer = new byte[size];
            inputStream.read(buffer);
            inputStream.close();
            return buffer;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }


}