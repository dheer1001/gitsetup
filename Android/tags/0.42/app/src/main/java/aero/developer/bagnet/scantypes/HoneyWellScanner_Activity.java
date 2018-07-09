package aero.developer.bagnet.scantypes;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.RequiresApi;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentManager;

import com.honeywell.aidc.AidcManager;
import com.honeywell.aidc.BarcodeFailureEvent;
import com.honeywell.aidc.BarcodeReadEvent;
import com.honeywell.aidc.BarcodeReader;
import com.honeywell.aidc.ScannerNotClaimedException;
import com.honeywell.aidc.ScannerUnavailableException;
import com.honeywell.aidc.TriggerStateChangeEvent;
import com.honeywell.aidc.UnsupportedPropertyException;

import java.util.HashMap;
import java.util.Map;

import aero.developer.bagnet.R;
import aero.developer.bagnet.dialogs.AboutDialog;
import aero.developer.bagnet.utils.BagLogger;

public class HoneyWellScanner_Activity extends EngineActivity implements BarcodeReader.BarcodeListener,
        BarcodeReader.TriggerListener  {

    public static BarcodeReader barcodeReader;
    private AidcManager manager;
    Map<String, Object> properties;
    int device_battery;

    private BroadcastReceiver mBatInfoReceiver = new BroadcastReceiver(){
        @RequiresApi(api = Build.VERSION_CODES.M)
        @Override
        public void onReceive(Context ctxt, Intent intent) {
            device_battery = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, 0);
            int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
            boolean isCharging =    status == BatteryManager.BATTERY_STATUS_CHARGING ||
                    status == BatteryManager.BATTERY_STATUS_FULL;
            System.out.println("Battery Level " + device_battery);
            updateBatteryView(device_battery,isCharging);
        }
    };
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        properties = new HashMap<String, Object>();
        super.onCreate(savedInstanceState);
        isBottomAligned(false);
        this.registerReceiver(this.mBatInfoReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));

        AidcManager.create(this, new AidcManager.CreatedCallback() {
            @Override
            public void onCreated(AidcManager aidcManager) {
                manager = aidcManager;
                barcodeReader = manager.createBarcodeReader();
                    try {
                        barcodeReader.claim();
                        setScannerConnectivityIcon(true);
                        if (barcodeReader != null) {

                            // register bar code event listener
                            barcodeReader.addBarcodeListener(HoneyWellScanner_Activity.this);
                            // set the trigger mode to client control
                            try {
                                barcodeReader.setProperty(BarcodeReader.PROPERTY_TRIGGER_CONTROL_MODE,
                                        BarcodeReader.TRIGGER_CONTROL_MODE_CLIENT_CONTROL);
                            } catch (UnsupportedPropertyException e) {
                                e.printStackTrace();
                            }
                            barcodeReader.addTriggerListener(HoneyWellScanner_Activity.this);

                            properties.put(BarcodeReader.PROPERTY_INTERLEAVED_25_ENABLED, false);
                            properties.put(BarcodeReader.PROPERTY_CODE_128_ENABLED, false);

                            properties.put(BarcodeReader.PROPERTY_PDF_417_ENABLED, true);
                            // Turn on center decoding
                            properties.put(BarcodeReader.PROPERTY_CENTER_DECODE, true);
                            // Disable bad read response, handle in onFailureEvent
                            properties.put(BarcodeReader.PROPERTY_NOTIFICATION_BAD_READ_ENABLED, true);
                            // Apply the settings
                            barcodeReader.setProperties(properties);
                        }
                    } catch (ScannerUnavailableException e) {
                        e.printStackTrace();
                    }
            }
        });
    }

    @Override
    public void onResume() {
        super.onResume();
        if(barcodeReader!=null) {
            setScannerConnectivityIcon(true);
            try {
                barcodeReader.claim();
            } catch (ScannerUnavailableException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        if(barcodeReader!= null) {
            barcodeReader.release();
        }
//        Utils.startScanningService();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        unregisterReceiver(mBatInfoReceiver);
        if (barcodeReader != null) {
                // close BarcodeReader to clean up resources.
                barcodeReader.close();
                barcodeReader = null;
            }
            if (manager != null) {
                // close AidcManager to disconnect from the scanner service.
                // once closed, the object can no longer be used.
                manager.close();
            }
    }

    @Override
    public void onBarcodeEvent(final BarcodeReadEvent barcodeReadEvent) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                onBarcodeScanned(barcodeReadEvent.getBarcodeData());
            }
        });
    }

    @Override
    public void onFailureEvent(BarcodeFailureEvent barcodeFailureEvent) {}

    @Override
    public void onTriggerEvent(TriggerStateChangeEvent triggerStateChangeEvent) {
        try {
            // only handle trigger presses
            // turn on/off aimer, illumination and decoding
            barcodeReader.aim(triggerStateChangeEvent.getState());
            barcodeReader.light(triggerStateChangeEvent.getState());
            barcodeReader.decode(triggerStateChangeEvent.getState());

        } catch (ScannerNotClaimedException | ScannerUnavailableException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void enablePDF417() {
        BagLogger.log("enablePDF417");
        super.enablePDF417();
        if(barcodeReader !=null) {
            properties.put(BarcodeReader.PROPERTY_PDF_417_ENABLED, true);
            barcodeReader.setProperties(properties);
        }


    }

    @Override
    public void disablePDF417() {
        BagLogger.log("disablePDF417");
        super.disablePDF417();
        if(barcodeReader != null) {
            properties.put(BarcodeReader.PROPERTY_PDF_417_ENABLED, false);
            barcodeReader.setProperties(properties);
        }

    }

    @Override
    public void enableCode128() {
        BagLogger.log("Enable code128");
        super.enableCode128();
        if(barcodeReader !=null) {
            properties.put(BarcodeReader.PROPERTY_CODE_128_ENABLED, true);
            barcodeReader.setProperties(properties);
        }
    }

    @Override
    public void disableCode128() {
        BagLogger.log("Disable code128");
        super.disableCode128();
        if(barcodeReader !=null) {
            properties.put(BarcodeReader.PROPERTY_CODE_128_ENABLED, false);
            barcodeReader.setProperties(properties);

        }
    }

    @Override
    public void enable2of5Interleaved() {
        BagLogger.log("enable2of5Interleaved");
        super.enable2of5Interleaved();
        if(barcodeReader !=null) {
            properties.put(BarcodeReader.PROPERTY_INTERLEAVED_25_ENABLED, true);
            barcodeReader.setProperties(properties);
        }
    }

    @Override
    public void disable2of5Interleaved() {
        BagLogger.log("disable2of5Interleaved");
        super.disable2of5Interleaved();
        if(barcodeReader !=null) {
            properties.put(BarcodeReader.PROPERTY_INTERLEAVED_25_ENABLED, false);
            barcodeReader.setProperties(properties);
        }
    }

    @Override
    public void onCreditsClicked(String cognexFirmwareVersion, String cognexBatteryLevel, String socketFirmwareVersion, String socketBattery,
                                 String fullDecodeVersion,String controlLogicVersion) {
        FragmentManager fm = getSupportFragmentManager();
        AboutDialog fragment = AboutDialog.getInstance();
        Bundle bundle = new Bundle();
        bundle.putString("fullDecodeVersion",fullDecodeVersion);
        bundle.putString("controlLogicVersion",controlLogicVersion);
        bundle.putString("device_battery", String.valueOf(device_battery));
        fragment.setArguments(bundle);
        fragment.setStyle(DialogFragment.STYLE_NORMAL, R.style.Dialog_FullScreen);
        fragment.show(fm, "about_dialog");
    }
}
