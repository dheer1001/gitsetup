package aero.developer.bagnet.scantypes;
/*
1)Goal of this activity:
Socket Scanner Dialog is used to Read Scanned Barcodes and process the "Bag Journey Netscan Overflow"

2) How To get the scanned bar-code step by step:
   2.a) In "onResume()" Create Intent Filter "NOTIFY_DECODED_DATA" and Register Receiver "_newItemsReceiver".
   increaseViewCount() in "On Resume".
   2.b) When Broadcast Receiver " _newItemsReceiver" is Reached ( Scan Barcode is done) then "NOTIFY_DECODED_DATA" is called
   get The Scanned Barcode "EXTRA_DECODEDDATA" and send it to Cognex Activity "onBarcodeScanned(dataValue)" to do the "Bag Journey Netscan Overflow"
   2.c) In "onPause()" Unregister Receiver "_newItemsReceiver" and decreaseViewCount()".

3) How to Enable and Disable Bar-codes:

If Device Information is not null, _scanApiHelper is not null and  is open ==>call method "postSetSymbologyInfo" in "Scan Api Helper" Class
and send these parameters for each enable and disable type of barcodes:

   3.a) enablePDF417(): DeviceInfo: DeviceInformation, Symbology: ISktScanSymbology.id.kSktScanSymbologyPdf417, Status: true

 Note: Status=false if disabled scanning barcodes and true if enabled scanning barcodes.

   3.b) disablePDF417(): DeviceInfo: DeviceInformation, Symbology: ISktScanSymbology.id.kSktScanSymbologyPdf417, Status: false

   3.c) enable2of5Interleaved():DeviceInformation, Symbology: ISktScanSymbology.id.kSktScanSymbologyInterleaved2of5 Status: true

   3.d) disable2of5Interleaved():DeviceInformation, Symbology: ISktScanSymbology.id.kSktScanSymbologyInterleaved2of5, Status: false

   3.e) enableCode128():DeviceInformation, Symbology: ISktScanSymbology.id.kSktScanSymbologyCode128 Status: true

   3.f) disableCode128():DeviceInformation, Symbology: ISktScanSymbology.id.kSktScanSymbologyCode128 Status: false

   3.g) enableScanner(): To enable scanning of Barcodes: Claim the Ownership "_scanApiOwnership", Remove all Commands of _scanApiHelper and Open _scanApiHelper.

   3.h) disableScanner(): To disable scanning of Barcodes: Release OwnerShip " _scanApiOwnership" and close  _scanApiHelper.


 */

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentManager;

import aero.developer.bagnet.R;
import aero.developer.bagnet.dialogs.AboutDialog;
import aero.developer.bagnet.socketmobile.BagnetApplication;
import aero.developer.bagnet.utils.BagLogger;
import aero.developer.bagnet.utils.Utils;


public class SocketMobileScanActivity extends EngineActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        isBottomAligned(false);


    }

    @Override
    protected void onPostCreate(@Nullable Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        //adding handler to delay 1 second before displaying the scanned bag.


    }

    private final BroadcastReceiver _newItemsReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, final Intent intent) {
             if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_DECODED_DATA)) {
                char[] data = intent.getCharArrayExtra(BagnetApplication.EXTRA_DECODEDDATA);
                 String dataValue = String.valueOf(data).trim();
                onBarcodeScanned(dataValue);
            }else if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_SCANNER_ARRIVAL)){
                 onConnected();
            }else if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_SCANNER_REMOVAL)) {
                onDisconnected();
            }
        }
    };



    @Override
    protected void onResume() {
        super.onResume();
        IntentFilter filter;
        filter = new IntentFilter(BagnetApplication.NOTIFY_DECODED_DATA);
        filter.addAction(BagnetApplication.NOTIFY_SCANNER_ARRIVAL);
        filter.addAction(BagnetApplication.NOTIFY_SCANNER_REMOVAL);
        registerReceiver(this._newItemsReceiver, filter);
        BagnetApplication.getApplicationInstance().increaseViewCount();
        CheckLocationStatus();
    }


    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected  void onPause(){
        super.onPause();
        //BagnetApplication.getApplicationInstance().enableQRCode();
        BagnetApplication.getApplicationInstance().decreaseViewCount();
        unregisterReceiver(_newItemsReceiver);
        BagLogger.log("ScanningService should start on destory");
        Utils.startScanningService();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void enableScanner(){

        BagnetApplication.getApplicationInstance().enableScanner();
    }

    @Override
    public void  disableScanner(){
        BagnetApplication.getApplicationInstance().disableScanner();
    }


    @Override
    public void enableCode128() {
        super.enableCode128();
        BagnetApplication.getApplicationInstance().enableCode128();
        //BagnetApplication.getApplicationInstance().enableQRCode();
    }

    @Override
    public void disableCode128() {
        super.disableCode128();
        BagnetApplication.getApplicationInstance().disableCode128();
        //BagnetApplication.getApplicationInstance().disableQRCode();

    }

    @Override
    public void enablePDF417() {
        super.enablePDF417();
        BagnetApplication.getApplicationInstance().enablePDF417();
        BagnetApplication.getApplicationInstance().enableQRCode();
    }

    @Override
    public void disablePDF417() {
        super.disablePDF417();
        BagnetApplication.getApplicationInstance().disablePDF417();
    }

    @Override
    public void disable2of5Interleaved() {
        super.disable2of5Interleaved();
        BagnetApplication.getApplicationInstance().disableCode2of5();

    }

    @Override
    public void enable2of5Interleaved() {
        super.enable2of5Interleaved();
        BagnetApplication.getApplicationInstance().enableCode2of5();
    }

    @Override
    public void onBarcodeScanned(String readString) {
        super.onBarcodeScanned(readString);

    }

    @Override
    public void onCreditsClicked(String cognexFirmwareVersion, String cognexBatteryLevel, String socketFirmwareVersion, String socketBattery,
                                 String fullDecodeVersion,String controlLogicVersion) {
        FragmentManager fm = getSupportFragmentManager();
        AboutDialog fragment = AboutDialog.getInstance();
        Bundle bundle = new Bundle();
        bundle.putString("socketFirmwareVersion", socketFirmwareVersion);
        bundle.putString("socketBattery", socketBattery);
        fragment.setArguments(bundle);
        fragment.setStyle(DialogFragment.STYLE_NORMAL, R.style.Dialog_FullScreen);
        fragment.show(fm, "about_dialog");
    }

}
