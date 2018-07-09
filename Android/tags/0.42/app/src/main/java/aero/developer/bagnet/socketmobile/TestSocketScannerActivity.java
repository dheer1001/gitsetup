package aero.developer.bagnet.socketmobile;

/*
1) Goal of this activity:
TestSocketScannerActivity Test the connection to socket Mobile through Bluetooth. Two Cases: Failed or Success.

2) How To Connect to Scanner Step by Step:

a) Register the Intent Filter "onResume()" with "BroadcastReceiver _newItemsReceiver"

   a.a) NOTIFY_SCANPI_INITIALIZED: It Notify when scanner Api is initialized.
   a.b) NOTIFY_EZ_PAIR_COMPLETED: It Notify when Socket Scanner Device is paired.
   a.c) NOTIFY_SCANNER_ARRIVAL: It Notify when Socket Scanner is arrived and ready to decode data.
   a.d) NOTIFY_SCANNER_REMOVAL: It Notify when scanner is removed and not connected.
   a.e) NOTIFY_ERROR_MESSAGE: It Notify if there is error while trying to connect to socket scanner.
   a.f) NOTIFY_CLOSE_ACTIVITY: It Notify when TestSocketScanner Activity is closed.

   Note: In "onResume()"  Use "BagnetApplication.getApplicationInstance().increaseViewCount()" to increase the view count. this is called typically on each Activity.onCreate If the view count was 0 then it asks this application object
     to register for ScanAPI ownership notification and to open ScanAPI.

b) When Broadcast Receive the Intent and NOTIFY_SCANAPI_INITIALIZED is received we call a handler and wait for 15 min.

In "configHandler" We Get the list of BluetoothAdapterand we Obtain the host bluetooth address of device. Then from the
BlueToothAdapter we got list of Bonded Devices.

Showing "Reset Setup Dialog"

   b.a) If there are no Bonded Devices then we Show "Reset Setup Dialog" to Facilitate initialization
of socket mobile by Scanning " Reset" and "Setup" Bar-codes.
   b.b) If there is bonded devices but device name"Socket 7Xi" is not founded in the list of bonded devices then we
show the "Reset Setup Dialog".

If there is bonded devices then we search for the device name "Socket 7Xi"and get its position in array then we send Broadcast
"START_EZ_PAIR" with extra:"EXTRA_EZ_PAIR_DEVICE" -->  _deviceSelectedToPairWith= Name + address of "Socket 7Xi", and
"EXTRA_EZ_PAIR_HOST_ADDRESS" --> _hostBluetoothAddress = address of bluetoothAdapter.

** After 15 min:

c) upon NOTIFY_EZ_PAIR_COMPLETED we send Broadcast to stop "STOP_EZ_PAIR".
d) upon "NOTIFY_SCANNER_ARRIVAL" we Open "SocketMobileScanActivity" to start decoding data.
e) If "NOTIFY_ERROR_MESSAGE" is reached the we show "Reset SetupDialog". Note: this case is reached if the socket scanner is already paired and we reinstall
the application.

d) Unregister the reciever in "onPause()"

Note: In "onPause()" use BagnetApplication.getApplicationInstance().decreaseViewCount(). decrease the view count. this is called typically on each Activity.onDestroy
     If the view Count comes to 0 then it will try to close ScanAPI and unregister for ScanAPI ownership notification unless
     this decreaseViewCount is happening because of a screen rotation

 */


import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.provider.Settings;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import java.util.Set;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.CustomViews.HeaderTextView;
import aero.developer.bagnet.LoginActivity;
import aero.developer.bagnet.R;
import aero.developer.bagnet.dialogs.Reset_Barcode_Dialog;
import aero.developer.bagnet.dialogs.Reset_Setup_Interface;
import aero.developer.bagnet.dialogs.Setup_Barcode_Dialog;
import aero.developer.bagnet.dialogs.SocketScannerDialog;
import aero.developer.bagnet.scantypes.SocketMobileScanActivity;
import aero.developer.bagnet.utils.BagLogger;
import aero.developer.bagnet.utils.Preferences;

public class TestSocketScannerActivity extends AppCompatActivity implements Reset_Setup_Interface{


    private String _deviceSelectedToPairWith;
    private String _hostBluetoothAddress;
    boolean registerReceiver=false;
    ImageView img_scanner,img_couldnot_connect;
    com.wang.avi.AVLoadingIndicatorView progress;
    Reset_Setup_Interface reset_setup_Interface;
    Reset_Barcode_Dialog reset_fragment;
    Setup_Barcode_Dialog setup_fragment;
    Button btn_setup,btn_reset,btn_cancel;
    RelativeLayout main_container;
    HeaderTextView connecting_scanner;
    LinearLayout lowerConatiner;
    final Handler handler = new Handler();
    private static Reset_Setup_Interface interface_setup_reset;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.test_socket_scanner_v2);

        interface_setup_reset = this;
        _newItemsReceiver = new BroadcastReceiver() {

            @Override
            public void onReceive(Context context, final Intent intent) {
                // ScanAPI is initialized/
                BagLogger.log("Action " + intent.getAction());
                if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_SCANPI_INITIALIZED)) {
                    handler.postDelayed(configHandler, 15000);  //the time is in miliseconds

                }

                // a img_scanner has connected
                else if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_SCANNER_ARRIVAL)) {
                    handler.removeCallbacks(configHandler);
                    progress.setVisibility(View.GONE);
                    img_scanner.setColorFilter(getResources().getColor(R.color.connected));
                    // go to home screen
                    new Handler().postDelayed(new Runnable() {
                        public void run() {
                            unregisterReceiver(_newItemsReceiver);
                            Intent intentHome = new Intent(TestSocketScannerActivity.this, SocketMobileScanActivity.class);
                            startActivity(intentHome);
                            _newItemsReceiver = null;
                            finish();
                        }
                    }, 200);

                } else if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_ERROR_MESSAGE)) {
                    String text = intent.getStringExtra(BagnetApplication.EXTRA_ERROR_MESSAGE);
                    BagLogger.log("Error:::: " + text);

                    if (!SocketScannerDialog.getInstance(TestSocketScannerActivity.this, reset_setup_Interface).isDialogShown()) {
                        scannerConnectionError();
//                        SocketScannerDialog.getInstance(TestSocketScannerActivity.this, reset_setup_Interface).showDialog();

                    }
                    BagnetApplication.getApplicationInstance().decreaseViewCount();
                } else if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_EZ_PAIR_COMPLETED)) {
                    Intent intents = new Intent(BagnetApplication.STOP_EZ_PAIR);
                    sendBroadcast(intents);
                }

                // a img_scanner has disconnected
                else if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_SCANNER_REMOVAL)) {
                    BagnetApplication.getApplicationInstance().decreaseViewCount();
                }


            }
        };
        img_scanner =(ImageView) findViewById(R.id.img_scanner);
        img_couldnot_connect = (ImageView) findViewById(R.id.img_couldnot_connect);
        connecting_scanner = (HeaderTextView) findViewById(R.id.connecting_scanner);
        progress=(com.wang.avi.AVLoadingIndicatorView) findViewById(R.id.Progress);
//        progress.getIndeterminateDrawable().setColorFilter(getResources().getColor(R.color.white), android.graphics.PorterDuff.Mode.MULTIPLY);
        lowerConatiner = (LinearLayout) findViewById(R.id.lowerConatiner);
        btn_setup = (Button) findViewById(R.id.btn_setup);
        btn_reset = (Button) findViewById(R.id.btn_reset);
        btn_cancel = (Button) findViewById(R.id.btn_cancel);
        SocketScannerDialog.resetDialog();

        main_container = (RelativeLayout) findViewById(R.id.main_container);

        //adjust colors
        main_container.setBackgroundColor(AppController.getInstance().getSecondaryColor());
        connecting_scanner.setTextColor(AppController.getInstance().getPrimaryColor());
        btn_cancel.setTextColor(AppController.getInstance().getPrimaryColor());

        GradientDrawable btn_cancel_drawable = (GradientDrawable)btn_cancel.getBackground();
        btn_cancel_drawable.setStroke(1,AppController.getInstance().getSecondaryGrayColor());

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            DrawableCompat.setTint(img_scanner.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(img_couldnot_connect.getDrawable(), AppController.getInstance().getPrimaryOrangeColor());
        }else{
            img_scanner.setImageDrawable(AppController.getTintedDrawable(img_scanner.getDrawable(),AppController.getInstance().getPrimaryColor()));
            img_couldnot_connect.setImageDrawable(AppController.getTintedDrawable(img_couldnot_connect.getDrawable(),AppController.getInstance().getPrimaryOrangeColor()));
        }
        if(Preferences.getInstance().isNightMode(getApplicationContext())) {
            progress.setIndicatorColor(AppController.getInstance().getPrimaryColor());
            btn_setup.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.btn_dark_gray_background));
            btn_reset.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.btn_dark_gray_background));

            btn_setup.setTextColor(AppController.getInstance().getPrimaryGrayColor());
            btn_reset.setTextColor(AppController.getInstance().getPrimaryGrayColor());

        }
        else
        {
            btn_reset.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.btn_gray_background));
            btn_setup.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.btn_gray_background));
            btn_setup.setTextColor(AppController.getInstance().getPrimaryColor());
            btn_reset.setTextColor(AppController.getInstance().getPrimaryColor());
        }



        btn_setup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // recall connection
                if(interface_setup_reset!=null){
                    interface_setup_reset.OpenSetupDialog();
                }
            }
        });
        btn_reset.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(interface_setup_reset!=null){
                    interface_setup_reset.OpenResetDialog();
                }
            }
        });

        btn_cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
    }




    final Runnable configHandler =new Runnable() {
        @Override
        public void run() {
            BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
            if (bluetoothAdapter != null) {

                if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.LOLLIPOP_MR1) {
                    _hostBluetoothAddress = bluetoothAdapter.getAddress();
                } else {
                    _hostBluetoothAddress = Settings.Secure.getString(getContentResolver(), "bluetooth_address");
                }
                _hostBluetoothAddress = _hostBluetoothAddress.replace(":", "");

                Set<BluetoothDevice> pairedDevices = bluetoothAdapter.getBondedDevices();
                // If there are paired devices, add each one to the ArrayAdapter
                if (pairedDevices.size() > 0) {

                    for (BluetoothDevice device : pairedDevices) {
                        if(device.getName().contains("Socket 7Xi")){
                            _deviceSelectedToPairWith=device.getName() + "\n" + device.getAddress();
                        }
                    }
                    registerReceiver=true;
                    if (_deviceSelectedToPairWith == null) {
                        //show error dialog
                        scannerConnectionError();
                    }
                    if(_deviceSelectedToPairWith!=null) {
                        //if(!_status.getText().toString().contains("Socket 7Xi")) {
                            //try to do it with out show dialog
                            Intent intent = new Intent(BagnetApplication.START_EZ_PAIR);
                            // remove the bluetooth address and keep only the device friendly name
                            if (_deviceSelectedToPairWith != null) {
                                if (_deviceSelectedToPairWith.length() > 18) {
                                    _deviceSelectedToPairWith = _deviceSelectedToPairWith
                                            .substring(0, _deviceSelectedToPairWith.length() - 18);
                                }
                                intent.putExtra(BagnetApplication.EXTRA_EZ_PAIR_DEVICE,
                                        _deviceSelectedToPairWith);
                                intent.putExtra(BagnetApplication.EXTRA_EZ_PAIR_HOST_ADDRESS,
                                        _hostBluetoothAddress);
                                sendBroadcast(intent);
                            }

                        //}

                    }
                }
                else{
                    scannerConnectionError();
//                   SocketScannerDialog.getInstance(TestSocketScannerActivity.this,reset_setup_Interface).showDialog();
                }
            }

        }
    } ;

    private BroadcastReceiver _newItemsReceiver = null;

    private void scannerConnectionError() {
        progress.setVisibility(View.GONE);
        lowerConatiner.setVisibility(View.VISIBLE);
        connecting_scanner.setText(getResources().getString(R.string.scanner_connection_error));
        img_couldnot_connect.setVisibility(View.VISIBLE);
    }

    private void scannertryingToConnect() {
        progress.setVisibility(View.VISIBLE);
        lowerConatiner.setVisibility(View.GONE);
        connecting_scanner.setText(getResources().getString(R.string.connecting_to_scanner));
        img_couldnot_connect.setVisibility(View.GONE);
    }



    @Override
    protected void onResume() {
        super.onResume();
        Connection();

    }



    @Override
    protected  void onPause(){
        super.onPause();

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        BagnetApplication.getApplicationInstance().decreaseViewCount();
        if (_newItemsReceiver!=null) {
            unregisterReceiver(_newItemsReceiver);
        }

    }


    @Override
    public void OpenResetDialog() {
        FragmentManager fm = getSupportFragmentManager();
        if (reset_fragment == null) {
            reset_fragment = Reset_Barcode_Dialog.getInstance();
            reset_fragment.setStyle(DialogFragment.STYLE_NORMAL, R.style.Dialog_FullScreen);
        }
        if (reset_fragment != null && !reset_fragment.isAdded()) {
            reset_fragment.show(fm, "reset_barcode");
        }
    }

    @Override
    public void OpenSetupDialog() {
        FragmentManager fm = getSupportFragmentManager();
        if (setup_fragment == null) {
            setup_fragment = Setup_Barcode_Dialog.getInstance(reset_setup_Interface);
            setup_fragment.setStyle(DialogFragment.STYLE_NORMAL, R.style.Dialog_FullScreen);
        }
        if (setup_fragment != null && !setup_fragment.isAdded()) {
            setup_fragment.show(fm, "setup_barcode");
        }
    }

    @Override
    public void Connection() {
        BagLogger.log("Connection to Socket img_scanner");
        img_scanner.setColorFilter(AppController.getInstance().getPrimaryColor());
        scannertryingToConnect();
        IntentFilter filter;
        filter = new IntentFilter(BagnetApplication.NOTIFY_SCANPI_INITIALIZED);

        filter.addAction(BagnetApplication.NOTIFY_SCANNER_ARRIVAL);
        filter.addAction(BagnetApplication.NOTIFY_SCANNER_REMOVAL);
        filter.addAction(BagnetApplication.NOTIFY_CLOSE_ACTIVITY);
        filter.addAction(BagnetApplication.NOTIFY_ERROR_MESSAGE);
        filter.addAction(BagnetApplication.NOTIFY_EZ_PAIR_COMPLETED);

        registerReceiver(this._newItemsReceiver, filter);
        BagnetApplication.getApplicationInstance().increaseViewCount();
    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
        Preferences.getInstance().setTrackingMap(getApplicationContext(),null);
        Intent back=new Intent(this,LoginActivity.class);
        startActivity(back);
    }}
