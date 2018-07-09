package aero.developer.bagnet.services;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Vibrator;
import android.provider.Settings;
import android.support.annotation.Nullable;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.TaskStackBuilder;

import java.util.Set;

import aero.developer.bagnet.R;
import aero.developer.bagnet.connectivity.ConnectivityChecker;
import aero.developer.bagnet.connectivity.OnConnectionChange;
import aero.developer.bagnet.interfaces.EngineInterface;
import aero.developer.bagnet.interfaces.BagActions;
import aero.developer.bagnet.interfaces.OnTrackBag;
import aero.developer.bagnet.interfaces.ReadStringListener;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.presenters.TrackingBagPresenter;
import aero.developer.bagnet.scantypes.SocketMobileScanActivity;
import aero.developer.bagnet.socketmobile.BagnetApplication;
import aero.developer.bagnet.utils.BagLogger;
import aero.developer.bagnet.utils.BagTagDBHelper;
import aero.developer.bagnet.utils.DataManUtils;
import aero.developer.bagnet.utils.Location_Utils;
import aero.developer.bagnet.utils.Preferences;
import aero.developer.bagnet.utils.ScanManager;
import aero.developer.bagnet.utils.SyncManager;
import aero.developer.bagnet.utils.Utils;

/**
 * Created by User on 5/16/2017.
 */

public class ScanningService extends Service implements ReadStringListener, EngineInterface, BagActions, OnConnectionChange,OnTrackBag {
    private String _deviceSelectedToPairWith;
    boolean registerReceiver = false;
    private ScanManager scanManager;
    private SyncManager syncManager;
    private static final int notificationID = 101;
    private static final int ConnectionnotificationID = 102;
    private ConnectivityChecker connectivityChecker;


    final Handler handler = new Handler();
    final Runnable configHandler = new Runnable() {
        @Override
        public void run() {
            BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
            if (bluetoothAdapter != null) {

                String _hostBluetoothAddress;
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
                        if (device.getName().contains("Socket 7Xi")) {
                            _deviceSelectedToPairWith = device.getName() + "\n" + device.getAddress();
                        }
                    }
                    registerReceiver = true;
                    if (_deviceSelectedToPairWith == null) {
                        //show error dialog
                    }
                    if (_deviceSelectedToPairWith != null) {
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
                } else {
                }
            }

        }
    };

    private final BroadcastReceiver _newItemsReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, final Intent intent) {
            // ScanAPI is initialized/
            BagLogger.log("Action " + intent.getAction());
            if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_SCANPI_INITIALIZED)) {
                handler.postDelayed(configHandler, 15000);  //the time is in miliseconds

            }

            // a Scanner has connected
            else if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_SCANNER_ARRIVAL)) {
                handler.removeCallbacks(configHandler);
                // go to home screen
                /*new Handler().postDelayed(new Runnable() {
                    public void run() {
                        Intent intentHome = new Intent(ScanningService.this, SocketMobileScanActivity.class);
                        startActivity(intentHome);
                    }
                }, 200);
                */

            } else if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_ERROR_MESSAGE)) {
                String text = intent.getStringExtra(BagnetApplication.EXTRA_ERROR_MESSAGE);
            } else if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_EZ_PAIR_COMPLETED)) {
                Intent intents = new Intent(BagnetApplication.STOP_EZ_PAIR);
                sendBroadcast(intents);
            } else if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_DECODED_DATA)) {
                char[] data = intent.getCharArrayExtra(BagnetApplication.EXTRA_DECODEDDATA);
                final String readString = String.valueOf(data).trim();


                //handeling Tracking Location section
                final boolean isValidTrackingLocation = DataManUtils.isValidTrackingLocation(readString,null);
                if (isValidTrackingLocation) {
                    scanManager.handleScannedTrackingLocation(readString);
                }


                // handeling Container Section
                boolean isValidContainerWithoutSpaces = DataManUtils.checkifThisContainerWithoutSpaces(readString);
                boolean isValidContainer = DataManUtils.isValidContainer(readString);
                if (isValidContainerWithoutSpaces || isValidContainer) {
                    scanManager.handleScannedContainer(readString);
                }


                boolean isValidBag = DataManUtils.isValidBag(readString);
                String trackingLocation = Preferences.getInstance().getTrackingLocation(ScanningService.this);
                String containerInput = Location_Utils.getContainerInput(trackingLocation);
                String container = Preferences.getInstance().getContaineruld(ScanningService.this);
                boolean canScanBag = trackingLocation != null && containerInput != null && (containerInput.equalsIgnoreCase("N") || ((containerInput.equalsIgnoreCase("Y") && container != null)));
                if (!(isValidContainer || isValidContainerWithoutSpaces) && !isValidTrackingLocation && isValidBag && canScanBag) { // then its a bag!!!
                    scanManager.handleScannedBag(readString);
                }

                BagLogger.log("String read: " + readString);

                Vibrator v = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
                v.vibrate(100);


            }

            // a Scanner has disconnected
            else if (intent.getAction().equalsIgnoreCase(BagnetApplication.NOTIFY_SCANNER_REMOVAL)) {

            }
        }
    };

    @Override
    public void onCreate() {
        super.onCreate();
        BagLogger.log("ScanningService Created");
        syncManager = new SyncManager(this, null);
        scanManager = new ScanManager(syncManager, this, this, this, null, this);
        Connection();
        connectivityChecker = new ConnectivityChecker(this);
        registerReceiver(connectivityChecker, new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION));

    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {

        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }

    @Override
    public void onStart(Intent intent, int startId) {


    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        unregisterReceiver(_newItemsReceiver);
        unregisterReceiver(connectivityChecker);
        BagnetApplication.getApplicationInstance().decreaseViewCount();
    }

    public void Connection() {
        BagLogger.log("Connection to Socket Scanner");
        IntentFilter filter;
        filter = new IntentFilter(BagnetApplication.NOTIFY_SCANPI_INITIALIZED);
        registerReceiver(this._newItemsReceiver, filter);

        filter = new IntentFilter(BagnetApplication.NOTIFY_SCANNER_ARRIVAL);
        registerReceiver(this._newItemsReceiver, filter);

        filter = new IntentFilter(BagnetApplication.NOTIFY_SCANNER_REMOVAL);
        registerReceiver(this._newItemsReceiver, filter);

        filter = new IntentFilter(BagnetApplication.NOTIFY_CLOSE_ACTIVITY);
        registerReceiver(this._newItemsReceiver, filter);


        filter = new IntentFilter(BagnetApplication.NOTIFY_ERROR_MESSAGE);
        registerReceiver(this._newItemsReceiver, filter);

        filter = new IntentFilter(BagnetApplication.NOTIFY_EZ_PAIR_COMPLETED);
        registerReceiver(this._newItemsReceiver, filter);

        filter = new IntentFilter(BagnetApplication.NOTIFY_DECODED_DATA);
        registerReceiver(this._newItemsReceiver, filter);

        BagnetApplication.getApplicationInstance().increaseViewCount();
    }

    @Override
    public void onTrackingLocationScannedExtraActions(String trackingLocation) {
        whatToDoAfterLocationScan();
    }

    @Override
    public void onContainerScannedExtraActions(String container) {
        scanManager.whatToDoAfterContainerScan();
    }

    @Override
    public void onBagScannedExtraActions(BagTag bagTag) {
        TrackingBagPresenter trackingBagPresenter = new TrackingBagPresenter(this);
        trackingBagPresenter.trackBag(getApplicationContext(), bagTag);
    }

    @Override
    public void whatToDoAfterContainerScanExtraActions(String containerInput) {
    }


    /***************************************************/
    public void whatToDoAfterLocationScan() {
        BagLogger.log("whatToDoAfterLocationScan from service");
        if (Utils.canContinueScanwithNoInternet(this)) {
            String trackingLocation = Preferences.getInstance().getTrackingLocation(this);

            if (trackingLocation != null) {
                String unkownBags = Location_Utils.getUnknownBags(trackingLocation);
                String flightNumber = Preferences.getInstance().getFlightNumber(this);
                String event_type = Location_Utils.getTypeEvent(trackingLocation);
                BagLogger.log("unkownBags from service = " + unkownBags);

                if(event_type!=null && event_type.equalsIgnoreCase("B")) {
                    enable2of5Interleaved();
                    disableCode128();
                    return;
                }

                if (unkownBags != null && !unkownBags.equalsIgnoreCase("I")) {
                    if (unkownBags.equalsIgnoreCase("S") && flightNumber == null) {
                        BagLogger.log("beepBadScan from service");
                        showAddFlightInfoNotification(null);
                        //send notification to ask the user to enter information
                    } else {
                        BagLogger.log("enableCode128/whatToDoforContainer from service");
                        enableCode128();
                        whatToDoforContainer(trackingLocation);
                    }
                } else {
                    enableCode128();
                    whatToDoforContainer(trackingLocation);
                }
            }

        } else {
            BagLogger.log("am here!!!");
            showConnectionFailureNotification();
        }

    }

    private void whatToDoforContainer(String trackingLocation) {
        BagLogger.log("This is called!");
        String containerInput = Location_Utils.getContainerInput(trackingLocation);
        String containerULD = Preferences.getInstance().getContaineruld(this);
        BagLogger.log("containerULD = " + containerULD);

        if ((containerULD == null || containerULD.equalsIgnoreCase("")) && containerInput != null) {
            BagLogger.log("containerInput = " + containerInput);
            if (containerInput.equalsIgnoreCase("N")) {
                scanManager.whatToDoAfterContainerScan();
                //user scan bags directly
            } else {
                BagLogger.log("User should scan container to continue");
                disable2of5Interleaved();
                if (!containerInput.equalsIgnoreCase("C")) {
                    //should fire notification asking the user to scan a container
                    //BagnetApplication.getApplicationInstance().beepBadScan();
                    /*
                    RequiredContaierDialog.getInstance(this).setOnDismissListener(new DialogInterface.OnDismissListener() {
                        @Override
                        public void onDismiss(DialogInterface dialog) {
                            enable2of5Interleaved();
                            //user can now scan bags when scanning a container
                            BagLogger.log("Called dismiss ");
                        }
                    });
                    */
                }

            }
        } else {
            //already container scanned and user is resuming this activity
            scanManager.whatToDoAfterContainerScan();
        }
    }

    @Override
    public void onConnected() {

    }

    @Override
    public void onDisconnected() {

    }

    @Override
    public void enableCode128() {
        BagnetApplication.getApplicationInstance().enableCode128();
        //BagnetApplication.getApplicationInstance().enableQRCode();
    }

    @Override
    public void disableCode128() {
        BagnetApplication.getApplicationInstance().disableCode128();
        //BagnetApplication.getApplicationInstance().disableQRCode();

    }

    @Override
    public void enablePDF417() {
        BagnetApplication.getApplicationInstance().enablePDF417();
        BagnetApplication.getApplicationInstance().enableQRCode();
    }

    @Override
    public void disablePDF417() {
        BagnetApplication.getApplicationInstance().disablePDF417();
    }

    @Override
    public void disable2of5Interleaved() {
        BagnetApplication.getApplicationInstance().disableCode2of5();

    }

    @Override
    public void enable2of5Interleaved() {
        BagnetApplication.getApplicationInstance().enableCode2of5();
    }

    @Override
    public boolean isConnected() {
        return false;
    }

    @Override
    public void enableScanner() {

    }

    @Override
    public void disableScanner() {

    }

    @Override
    public void restartPreviewAndDecode() {

    }

    @Override
    public void addSyncBag(BagTag bagTag) {
        enable2of5Interleaved();
        BagTagDBHelper.getInstance(this).getBagtagTag().insertOrReplace(bagTag);
        syncManager.start();
    }

    public void showAddFlightInfoNotification(BagTag bagTag) {
        BagnetApplication.getApplicationInstance().beepBadScan(true);
        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(this)
                        .setSmallIcon(R.mipmap.ic_notification)
                        .setAutoCancel(true)
                        .setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_LIGHTS | Notification.DEFAULT_VIBRATE)
                        //.setContentTitle("My notification")
                        .setContentText(getString(R.string.notification_enterflightInfo));

        // Creates an explicit intent for an Activity in your app

        Intent resultIntent = new Intent(this, SocketMobileScanActivity.class);
        if (bagTag != null) {

            resultIntent.putExtra("bagTag", bagTag);
        }

        // The stack builder object will contain an artificial back stack for the
        // started Activity.
        // This ensures that navigating backward from the Activity leads out of
        // your application to the Home screen.
        TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
        // Adds the back stack for the Intent (but not the Intent itself)
        stackBuilder.addParentStack(SocketMobileScanActivity.class);
        // Adds the Intent that starts the Activity to the top of the stack

        stackBuilder.addNextIntent(resultIntent);
        PendingIntent resultPendingIntent =
                stackBuilder.getPendingIntent(
                        0,
                        PendingIntent.FLAG_CANCEL_CURRENT | PendingIntent.FLAG_ONE_SHOT
                );
        mBuilder.setContentIntent(resultPendingIntent);
        NotificationManager mNotificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        // mId allows you to update the notification later on.
        mNotificationManager.notify(notificationID, mBuilder.build());
    }

    public void showConnectionFailureNotification() {
        BagnetApplication.getApplicationInstance().beepBadScan(true);
        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(this)
                        .setSmallIcon(R.mipmap.ic_notification)
                        .setAutoCancel(true)
                        .setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_LIGHTS | Notification.DEFAULT_VIBRATE)
                        .setContentText(getString(R.string.notification_noInternetConnection));

        // Creates an explicit intent for an Activity in your app


        NotificationManager mNotificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        // mId allows you to update the notification later on.
        mNotificationManager.notify(ConnectionnotificationID, mBuilder.build());
    }

    public void cancelConnectionNotification() {
        NotificationManager mNotificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        // mId allows you to update the notification later on.
        mNotificationManager.cancel(ConnectionnotificationID);
    }

    @Override
    public void connected() {
        cancelConnectionNotification();
        whatToDoAfterLocationScan();
        syncManager.start();
    }

    @Override
    public void notConnected() {
        String trackingLocation = Preferences.getInstance().getTrackingLocation(this);
        if (trackingLocation != null) {
            if (Utils.canContinueScanwithNoInternet(this)) {
                cancelConnectionNotification();
            } else {
                disable2of5Interleaved();
                disableCode128();
                showConnectionFailureNotification();
            }
        }
    }

    @Override
    public void trackSuccess(BagTag bagTag) {

    }

    @Override
    public void trackFailed(BagTag bagTag,String errorCode) {
        showAddFlightInfoNotification(bagTag);
    }

    @Override
    public void onConnectionFailed(BagTag bagTag) {

    }
}
