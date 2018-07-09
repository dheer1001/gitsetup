package aero.developer.bagnet.scantypes;

import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentManager;

import com.cognex.dataman.sdk.ConnectionState;
import com.cognex.dataman.sdk.DataManSystem;
import com.cognex.mobile.barcode.sdk.ReadResult;
import com.cognex.mobile.barcode.sdk.ReadResults;
import com.cognex.mobile.barcode.sdk.ReaderDevice;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.dialogs.AboutDialog;
import aero.developer.bagnet.utils.BagLogger;
import aero.developer.bagnet.utils.DataManUtils;
import aero.developer.bagnet.utils.Location_Utils;
import aero.developer.bagnet.utils.Preferences;


public class CognexScanActivity extends EngineActivity implements ReaderDevice.OnConnectionCompletedListener, ReaderDevice.ReaderDeviceListener {

    private DataManSystem dataManSystem;
    public static ReaderDevice readerDevice;
    private static boolean isReaderinitialized;

    public DataManSystem getDataManSystem() {
        return  dataManSystem;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        BagLogger.log("On Created");
        isBottomAligned(false);
    }

    @Override
    protected void onStart(){
        super.onStart();
        BagLogger.log("On Start");
        if( readerDevice == null ||  readerDevice.getConnectionState() != ConnectionState.Connected)
            initDevice();
    }

    @Override
    protected void onResume() {
            BagLogger.log("OnResume()");
        super.onResume();
    }

    @Override
    protected void onPause() {
        super.onPause();
        BagLogger.log("onPause");
        String type_event = Location_Utils.getTypeEvent(Preferences.getInstance().getTrackingLocation(getApplicationContext()));
        if(type_event != null && type_event.equalsIgnoreCase("B")) {
            return;
        }
        if (readerDevice != null && readerDevice.getConnectionState() == ConnectionState.Connected) {
            readerDevice.disconnect();
            isReaderinitialized = false;
        }
    }
    @Override
    protected void onStop() {
        String type_event = Location_Utils.getTypeEvent(Preferences.getInstance().getTrackingLocation(getApplicationContext()));
        if(type_event != null && type_event.equalsIgnoreCase("B")) {
            super.onStop();
            return;
        }
            try {
                readerDevice.stopAvailabilityListening();
                isReaderinitialized = false;
            } catch (Exception e) {
                e.printStackTrace();
            }

        super.onStop();
    }

    @Override
    protected void onDestroy() {
        BagLogger.log("On Destroy");
        Preferences.getInstance().setIS_FORCE_CHARGING_ENABLED(this,false);

        super.onDestroy();
    }

    private void initDevice() {
//        Toast.makeText(getApplicationContext(),"init",Toast.LENGTH_SHORT).show();
        isReaderinitialized = true;
        readerDevice = null;
        readerDevice = ReaderDevice.getMXDevice(getApplicationContext());
        readerDevice.startAvailabilityListening();
        readerDevice.setReaderDeviceListener(this);
        readerDevice.connect(CognexScanActivity.this);
    }


    @Override
    public void onConnectionCompleted(ReaderDevice readerDevice, Throwable error) {
//        Toast.makeText(getApplicationContext(),"onConnectionCompleted",Toast.LENGTH_SHORT).show();

        if (error != null) {
           CognexScanActivity.readerDevice.disconnect();
            CognexScanActivity.readerDevice.getDataManSystem().disconnect();
            readerDevice.disconnect();
            CognexScanActivity.readerDevice.stopAvailabilityListening();
            isReaderinitialized = false;
            readerDisconnected();
        }
    }

    @Override
    public void onReadResultReceived(ReaderDevice readerDevice, ReadResults readResults) {

        if (readResults.getCount() > 0) {
            ReadResult result = readResults.getResultAt(0);
            if (result.isGoodRead()) {
                ReaderDevice.Symbology symbology = result.getSymbology();
                if (symbology != null) {
                    onBarcodeScanned(result.getReadString());
                }
            }
        }
    }

    @Override
    public void onConnectionStateChanged(ReaderDevice reader) {
//        Toast.makeText(getApplicationContext(),reader.getConnectionState().toString(),Toast.LENGTH_SHORT).show();

        if (reader.getConnectionState() == ConnectionState.Connected ) {
            readerConnected();
        } else if (reader.getConnectionState() == ConnectionState.Disconnected) {
            readerDisconnected();
        }
    }

    @Override
    public void onAvailabilityChanged(ReaderDevice reader) {
        if (reader.getAvailability() == ReaderDevice.Availability.AVAILABLE) {
            readerDevice.connect(CognexScanActivity.this);
        } else {
            readerDevice.disconnect();
            readerDisconnected();
        }
    }

     private void readerDisconnected() {
             BagLogger.log("onDisconnected");
             ShowNotConnectedDialog();
             super.onDisconnected();
         }

     private void readerConnected() {
        dataManSystem = readerDevice.getDataManSystem();
        BagLogger.log("onConnected");
        if(dataManSystem != null) {
            DataManUtils.powerOff(dataManSystem);
            DataManUtils.uploadScript(dataManSystem);
            if(!Preferences.getInstance().getIS_FORCE_CHARGING_ENABLED(AppController.getInstance().getApplicationContext())) {
                DataManUtils.forceChargingMode(dataManSystem);
            }
        }
//            readerDevice.setSymbologyEnabled(ReaderDevice.Symbology.DATAMATRIX,true,null );
//            readerDevice.getDataManSystem().sendCommand("SET SYMBOL.MICROPDF417 ON");
            super.onConnected();
    }

    @Override
    public void enableCode128() {
        super.enableCode128();
        BagLogger.log("enableCode128");
        DataManUtils.enableCode128(this.dataManSystem);

    }

    @Override
    public void disableCode128() {
        super.disableCode128();
        BagLogger.log("disableCode128");
        DataManUtils.disableCode128(this.dataManSystem);
    }

    @Override
    public void enablePDF417() {
        super.enablePDF417();
        BagLogger.log("enablePDF417");
        DataManUtils.enablePDF417(this.dataManSystem);
    }

    @Override
    public void disablePDF417() {
        super.disablePDF417();
        BagLogger.log("disablePDF417");
        DataManUtils.disablePDF417(this.dataManSystem);
    }

    @Override
    public void disable2of5Interleaved() {
        super.disable2of5Interleaved();
        BagLogger.log("disable2of5Interleaved");
        DataManUtils.disable2of5Interleaved(dataManSystem);
    }

    @Override
    public void enable2of5Interleaved() {
        super.enable2of5Interleaved();
        BagLogger.log("enable2of5Interleaved");
        DataManUtils.enable2of5Interleaved(dataManSystem);
    }

    @Override
    public void onCreditsClicked(String cognexFirmwareVersion, String cognexBatteryLevel, String socketFirmwareVersion, String socketBattery,
                                 String fullDecodeVersion,String controlLogicVersion) {
        FragmentManager fm = getSupportFragmentManager();
        AboutDialog fragment = AboutDialog.getInstance();
        Bundle bundle = new Bundle();
        bundle.putString("cognexFirmwareVersion", cognexFirmwareVersion);
        bundle.putString("cognexBatteryLevel", cognexBatteryLevel);
        fragment.setArguments(bundle);
        fragment.setStyle(DialogFragment.STYLE_NORMAL, R.style.Dialog_FullScreen);
        fragment.show(fm, "about_dialog");
    }
}
