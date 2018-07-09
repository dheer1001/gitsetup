package aero.developer.bagnet.scantypes;


import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentManager;
import android.view.View;
import android.widget.ImageView;

import com.cognex.dataman.sdk.CameraMode;
import com.cognex.dataman.sdk.ConnectionState;
import com.cognex.dataman.sdk.DataManSystem;
import com.cognex.dataman.sdk.DmccResponse;
import com.cognex.dataman.sdk.PreviewOption;
import com.cognex.mobile.barcode.sdk.ReadResult;
import com.cognex.mobile.barcode.sdk.ReadResults;
import com.cognex.mobile.barcode.sdk.ReaderDevice;
import com.manateeworks.BarcodeScanner;
import com.manateeworks.CameraManager;

import java.util.Timer;
import java.util.TimerTask;

import aero.developer.bagnet.PermissionRequester;
import aero.developer.bagnet.R;
import aero.developer.bagnet.dialogs.AboutDialog;
import aero.developer.bagnet.dialogs.ApiResponseDialog;
import aero.developer.bagnet.dialogs.BagDetailDialog;
import aero.developer.bagnet.dialogs.IdentifiedContainerDialog;
import aero.developer.bagnet.dialogs.InternetConnectionStatusDialog;
import aero.developer.bagnet.dialogs.SettingsDialog;
import aero.developer.bagnet.interfaces.PermissionHandler;
import aero.developer.bagnet.utils.Analytic;
import aero.developer.bagnet.utils.BagLogger;
import aero.developer.bagnet.utils.DataManUtils;
import aero.developer.bagnet.utils.Preferences;
import aero.developer.bagnet.utils.Utils;


public class SoftScannerActivity extends EngineActivity implements ReaderDevice.OnConnectionCompletedListener,ReaderDevice.ReaderDeviceListener {

    public static boolean isScanning = false;
    public static ReaderDevice readerDevice;
    private int zoomLevel = 0;
    private int firstZoom = 150;
    private int secondZoom = 300;
    ImageView zoomButton,buttonFlash,close;
    public boolean flashOn = false;
    Timer softScanner_timer;
    private boolean showFloatingButtonWhenReturn =false;
    private void init() {
        readerDevice = ReaderDevice.getPhoneCameraDevice(this,
                CameraMode.NO_AIMER, PreviewOption.NO_ZOOM_BUTTON | PreviewOption.NO_ILLUMINATION_BUTTON,
                fullCameraScreen);

        readerDevice.connect(SoftScannerActivity.this);
        readerDevice.setReaderDeviceListener(this);
        readerDevice.startAvailabilityListening();
    }

    @Override
    protected void onStart() {
        super.onStart();
        init();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        buttonFlash = findViewById(R.id.flashButton);
        zoomButton = findViewById(R.id.zoomButton);
        close = findViewById(R.id.close);

        close.setOnClickListener(new View.OnClickListener() {
                        @Override
            public void onClick(View v) {
                adjustDialogsWhenStopScanning();

            }
        });

        ic_soft_scan.setVisibility(View.VISIBLE);
        scannerConnectivity.setVisibility(View.INVISIBLE);
        deviceStatus.setText(getResources().getString(R.string.soft_scan));
        tapToScan.setVisibility(View.VISIBLE);
        float scale = getResources().getDisplayMetrics().density;
        int dpAsPixels = (int) (10*scale + 0.5f);
        tapToScan.setPadding(dpAsPixels,0,0,0);
        deviceStatus.setPadding(dpAsPixels,0,0,0);

        connectivity_container.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Utils.checkPermission(SoftScannerActivity.this, PermissionRequester.CAMERA, new PermissionHandler() {
                    @Override
                    public void onGranted() {
                        new Handler().postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                startCamera();
                            }
                        }, 500);
                    }

                    @Override
                    public void onDenied() {
                    }
                });
            }
        });

        zoomButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Analytic.getInstance().sendScreen(R.string.Scan_zoom);
                zoomLevel++;
                if (zoomLevel > 2) {
                    zoomLevel = 0;
                }

                switch (zoomLevel) {
                    case 0:
                        CameraManager.get().setZoom(100);
                        break;
                    case 1:
                        CameraManager.get().setZoom(firstZoom);
                        break;
                    case 2:
                        CameraManager.get().setZoom(secondZoom);
                        break;
                    default:
                        break;
                }

            }
        });

        buttonFlash.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                flashOn = !flashOn;
                if (buttonFlash != null) {
                    Analytic.getInstance().sendScreen(R.string.Scan_Flash);
                    if (!CameraManager.get().isTorchAvailable()) {
                        buttonFlash.setVisibility(View.GONE);
                        return;

                    }else {
                        buttonFlash.setVisibility(View.VISIBLE);
                    }

                    if (flashOn) {
                        buttonFlash.setImageResource(R.drawable.netscan_flashbuttonon);
                    }else {
                        buttonFlash.setImageResource(R.drawable.netscan_flashbuttonoff);
                    }
                    CameraManager.get().setTorch(flashOn);
                    buttonFlash.postInvalidate();
                }
            }
        });


        isBottomAligned(true);

    }

    @Override
    public void onResume() {
        super.onResume();
        if (Preferences.getInstance().getTrackingLocation(getApplicationContext()) == null) {
            scanPromptView.setPromptForLocation();
        }
        if (!Utils.canContinueScanwithNoInternet(this)) {
            InternetConnectionStatusDialog.getInstance(this).showDialog(true);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (readerDevice != null && readerDevice.getConnectionState() == ConnectionState.Connected) {
            readerDevice.disconnect();
            adjustDialogsWhenStopScanning();
        }
    }

    @Override
    public void onStop() {
        super.onStop();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    private void startCamera() {
        if(readerDevice.getConnectionState() != ConnectionState.Connected) {
            if (readerDevice != null) {
                adjustDialogsWhenStopScanning();
            }
            init();
        }else {
            if ((ApiResponseDialog.getInstance() != null && !ApiResponseDialog.getInstance().isShown()) &&
                    (SettingsDialog.getInstance() != null && !SettingsDialog.getInstance().isShown())) {
                adjustDialogsWhenStartScanning();
            }
        }

    }

    @Override
    public void onConnected() {
        super.onConnected();
    }

    @Override
    public void onDisconnected() {
        super.onDisconnected();
    }

    @Override
    public void onUsbConnected() {
        super.onUsbConnected();
    }

    @Override
    public void onConnectionCompleted(ReaderDevice readerDevice, Throwable throwable) {
    }

    @Override
    public void onConnectionStateChanged(ReaderDevice reader) {
        if (reader.getConnectionState() == ConnectionState.Connected) {
            readerConnected();
        } else if (reader.getConnectionState() == ConnectionState.Disconnected) {
            readerDisconnected();
        }
    }

    @Override
    public void onReadResultReceived(ReaderDevice readerDevice, ReadResults results) {
        if (results.getCount() > 0) {
            ReadResult result = results.getResultAt(0);

            if (result.isGoodRead()) {
                if(DataManUtils.isValidTrackingLocation(result.getReadString(),getApplicationContext())) {
                    showFloatingButtonWhenReturn = false;
                }
                adjustDialogsWhenStopScanning();
                onBarcodeScanned(result.getReadString());

            }
        }
    }


    @Override
    public void onAvailabilityChanged(ReaderDevice reader) {
        if (reader.getAvailability() == ReaderDevice.Availability.AVAILABLE) {
            readerDevice.connect(SoftScannerActivity.this);
            super.onConnected();
        } else {
            // DISCONNECTED USB DEVICE
            readerDevice.disconnect();

        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        if(isScanning){
            adjustDialogsWhenStopScanning();
        }
    }

    private void readerConnected() {
        readerDevice.getDataManSystem().sendCommand("SET SYMBOL.PDF417 ON");
    }

    private void readerDisconnected() {
        zoomButton.setVisibility(View.GONE);
        buttonFlash.setVisibility(View.GONE);
        close.setVisibility(View.GONE);
        if (softScanner_timer != null) {
            softScanner_timer.cancel();
            softScanner_timer.purge();
            softScanner_timer = null;
        }
    }

    @Override
    public void enableCode128() {
        BagLogger.log("Enable code128");
        super.enableCode128();
        BarcodeScanner.MWBsetActiveCodes(BarcodeScanner.MWB_CODE_MASK_PDF | BarcodeScanner.MWB_CODE_MASK_128 | BarcodeScanner.MWB_CODE_MASK_QR);
    }

    @Override
    public void disableCode128() {
        BagLogger.log("Disable code128");
        super.disableCode128();
        BarcodeScanner.MWBsetActiveCodes(BarcodeScanner.MWB_CODE_MASK_PDF | BarcodeScanner.MWB_CODE_MASK_QR);
    }

    @Override
    public void enablePDF417() {
        BagLogger.log("enablePDF417");
        super.enablePDF417();
        BarcodeScanner.MWBsetActiveCodes(BarcodeScanner.MWB_CODE_MASK_PDF | BarcodeScanner.MWB_CODE_MASK_QR);

    }

    @Override
    public void disablePDF417() {
        BagLogger.log("disablePDF417");
        super.disablePDF417();
        BarcodeScanner.MWBsetActiveCodes(BarcodeScanner.MWB_CODE_MASK_NONE);
    }

    @Override
    public void disable2of5Interleaved() {
        BagLogger.log("disable2of5Interleaved");
        super.disable2of5Interleaved();
        BarcodeScanner.MWBsetActiveCodes(BarcodeScanner.MWB_CODE_MASK_PDF | BarcodeScanner.MWB_CODE_MASK_128 | BarcodeScanner.MWB_CODE_MASK_QR);
    }

    @Override
    public void enable2of5Interleaved() {
        BagLogger.log("enable2of5Interleaved");
        super.enable2of5Interleaved();
        int status = BarcodeScanner.MWBsetActiveCodes(BarcodeScanner.MWB_CODE_MASK_PDF | BarcodeScanner.MWB_CODE_MASK_25 | BarcodeScanner.MWB_CODE_MASK_128 | BarcodeScanner.MWB_CODE_MASK_QR);
        if (status == BarcodeScanner.MWB_RT_OK) {
            BarcodeScanner.MWBsetActiveSubcodes(BarcodeScanner.MWB_CODE_MASK_25, BarcodeScanner.MWB_SUBC_MASK_C25_INTERLEAVED | BarcodeScanner.MWB_SUBC_MASK_C25_STANDARD | BarcodeScanner.MWB_SUBC_MASK_C25_ITF14 | BarcodeScanner.MWB_CODE_MASK_QR);
        }
    }


    @Override
    public boolean isConnected() {
        return super.isConnected();
    }

    @Override
    public void disableScanner() {}

    private void adjustDialogsWhenStartScanning() {
        if (readerDevice.getConnectionState() == ConnectionState.Connected) {
           if(softScanner_timer!=null)
           {
               softScanner_timer.cancel();
               softScanner_timer.purge();
           }
            setTimer();

            readerDevice.startScanning();
            isScanning = true;
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    zoomButton.setVisibility(View.VISIBLE);
                    buttonFlash.setVisibility(View.VISIBLE);
                    close.setVisibility(View.VISIBLE);
                    buttonFlash.setImageResource(R.drawable.netscan_flashbuttonoff);
                    if (floatingActionButton.getVisibility() == View.VISIBLE) {
                        floatingActionButton.setVisibility(View.GONE);
                        showFloatingButtonWhenReturn = true;
                    }
                }
            }, 400);

        if (InternetConnectionStatusDialog.getInstance(this) != null && InternetConnectionStatusDialog.getInstance(this).isShown()) {
            InternetConnectionStatusDialog.hideDialog();
        }

        if (BagDetailDialog.getInstance(this) != null && BagDetailDialog.getInstance(this).isShown()) {
            BagDetailDialog.hideDialog();
        }

        }

    }

    private void adjustDialogsWhenStopScanning() {
        if (readerDevice.getConnectionState() == ConnectionState.Connected) {
            if (readerDevice != null) {
                readerDevice.stopScanning();
                isScanning = false;
                zoomButton.setVisibility(View.GONE);
                buttonFlash.setVisibility(View.GONE);
                close.setVisibility(View.GONE);
                flashOn = false;
            }

            if (softScanner_timer != null) {
                softScanner_timer.cancel();
                softScanner_timer.purge();
                softScanner_timer = null;
            }
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    if (showFloatingButtonWhenReturn) {
                        if (IdentifiedContainerDialog.instance == null) {
                            floatingActionButton.setVisibility(View.VISIBLE);
                        } else {
                            if (!IdentifiedContainerDialog.instance.isShown()) {
                                floatingActionButton.setVisibility(View.VISIBLE);
                            }
                        }

                    }
                }
            }, 500);

            if (!Utils.canContinueScanwithNoInternet(this)) {
                InternetConnectionStatusDialog.getInstance(this).showDialog(true);
            }
        }

    }

    private void setTimer() {
        softScanner_timer = null;
        softScanner_timer = new Timer();
        final int[] timeout = {60};//default is 60

        if (readerDevice != null && readerDevice.getDataManSystem() != null) {
            readerDevice.getDataManSystem().sendCommand("GET LIGHT.AIMER-TIMEOUT", new DataManSystem.OnResponseReceivedListener() {
                @Override
                public void onResponseReceived(DataManSystem dataManSystem, DmccResponse dmccResponse) {
                    if (dmccResponse != null && dmccResponse.getPayLoad() != null) {
                        timeout[0] = Integer.parseInt(dmccResponse.getPayLoad());
                        if (softScanner_timer != null){
                            softScanner_timer.schedule(new TimerTask() {
                                @Override
                                public void run() {
                                    runOnUiThread(new Runnable() {
                                        @Override
                                        public void run() {
                                            adjustDialogsWhenStopScanning();
                                        }
                                    });

                                }
                            }, timeout[0] * 1000);
                        }
                    }
                }
            });
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

    }

    @Override
    public void onCreditsClicked(String cognexFirmwareVersion, String cognexBatteryLevel, String socketFirmwareVersion, String socketBattery,
                                 String fullDecodeVersion,String controlLogicVersion) {
        FragmentManager fm = getSupportFragmentManager();
        AboutDialog fragment = AboutDialog.getInstance();
        fragment.setStyle(DialogFragment.STYLE_NORMAL, R.style.Dialog_FullScreen);
        fragment.show(fm, "about_dialog");
    }

}
