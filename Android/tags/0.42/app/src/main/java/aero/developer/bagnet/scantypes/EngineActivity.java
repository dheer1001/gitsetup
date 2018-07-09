package aero.developer.bagnet.scantypes;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.LayerDrawable;
import android.net.ConnectivityManager;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Vibrator;
import android.support.annotation.RequiresApi;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.cognex.dataman.sdk.DataManSystem;
import com.cognex.dataman.sdk.DmccResponse;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.socketmobile.scanapi.ISktScanObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.TimeUnit;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.BINGO_Activity;
import aero.developer.bagnet.Constants;
import aero.developer.bagnet.CustomViews.AutoresizeTextView;
import aero.developer.bagnet.CustomViews.BagsGridWidget;
import aero.developer.bagnet.CustomViews.DigitalTextView;
import aero.developer.bagnet.CustomViews.HeaderTextView;
import aero.developer.bagnet.CustomViews.ScanPromptView;
import aero.developer.bagnet.LoginActivity;
import aero.developer.bagnet.R;
import aero.developer.bagnet.Sign_In_Timeout.AlarmHelper;
import aero.developer.bagnet.connectivity.ConnectivityChecker;
import aero.developer.bagnet.connectivity.OnConnectionChange;
import aero.developer.bagnet.dialogs.ApiResponseDialog;
import aero.developer.bagnet.dialogs.BINGO_Progress_Dialog;
import aero.developer.bagnet.dialogs.BagContainer_InputDialog;
import aero.developer.bagnet.dialogs.BagDetailDialog;
import aero.developer.bagnet.dialogs.Device_Connected_Dialog;
import aero.developer.bagnet.dialogs.Flight_Screen_Dialog;
import aero.developer.bagnet.dialogs.IdentifiedContainerDialog;
import aero.developer.bagnet.dialogs.InternetConnectionStatusDialog;
import aero.developer.bagnet.dialogs.LocationSuccessDialog;
import aero.developer.bagnet.dialogs.LocationSuccessFullDialog;
import aero.developer.bagnet.dialogs.SelectAirlineFragment;
import aero.developer.bagnet.dialogs.SelectAirportFragment;
import aero.developer.bagnet.dialogs.SelectTrackingFragment;
import aero.developer.bagnet.dialogs.SettingsDialog;
import aero.developer.bagnet.interfaces.BagActions;
import aero.developer.bagnet.interfaces.EngineInterface;
import aero.developer.bagnet.interfaces.OnBagTagListener;
import aero.developer.bagnet.interfaces.OnGlobalFlightDataSaved;
import aero.developer.bagnet.interfaces.OptionSelectionCallback;
import aero.developer.bagnet.interfaces.QueueCallBacks;
import aero.developer.bagnet.interfaces.ReadStringListener;
import aero.developer.bagnet.interfaces.SettingsActions;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.objects.BagTagDao;
import aero.developer.bagnet.objects.LoginData;
import aero.developer.bagnet.objects.LoginResponse;
import aero.developer.bagnet.presenters.SettingsPresenter;
import aero.developer.bagnet.socketmobile.BagnetApplication;
import aero.developer.bagnet.socketmobile.ICommandContextCallback;
import aero.developer.bagnet.socketmobile.ScanApiHelper;
import aero.developer.bagnet.utils.BagLogger;
import aero.developer.bagnet.utils.BagTagDBHelper;
import aero.developer.bagnet.utils.DataManUtils;
import aero.developer.bagnet.utils.Location_Utils;
import aero.developer.bagnet.utils.Preferences;
import aero.developer.bagnet.utils.ScanManager;
import aero.developer.bagnet.utils.SyncManager;
import aero.developer.bagnet.utils.Utils;
import de.greenrobot.dao.query.DeleteQuery;

@SuppressLint("Registered")
public class EngineActivity extends AppCompatActivity implements SettingsActions, OnBagTagListener,
        OnConnectionChange, OnGlobalFlightDataSaved, BagActions, EngineInterface,
        ReadStringListener, QueueCallBacks, OptionSelectionCallback, SharedPreferences.OnSharedPreferenceChangeListener {

    View include,batteryDash_1,batteryDash_2,batteryDash_3,batteryDash_4,batteryDash_5;
    RelativeLayout parentView;
    ImageView connectivityImage = null;
    ImageView scannerConnectivity = null;
    ImageView ic_charging,ic_soft_scan;
    TextView connectionStatus = null;
    TextView deviceStatus = null;
    public RelativeLayout fullCameraScreen;
    HeaderTextView gateText,tapToScan;

    BagsGridWidget queue;
    LinearLayout top_view_layout,batteryContainer;
    private DigitalTextView timerText;
    private CountDownTimer countDownTimer = null;
    boolean hasSurface;
    ConnectivityChecker connectivityChecker;
    boolean isBottomAligned = false;
    private ScanManager scanManager;
    private SyncManager syncManager;
    RelativeLayout connectivity_container, gateLayout, online_layout;
    ImageView gps;
    RelativeLayout AirportContainer, AirlineContainer;
    TextView txt_airport, txt_airline;
    ImageView ic_airport, ic_airline;
    String loginresponseStr;
    LoginData loginData;
    BINGO_Progress_Dialog bingo_progress_dialog;
    boolean canAddBingoActivity;
    Timer timer;
    public ScanPromptView scanPromptView;
    public LinearLayout locationLayout;
    public HeaderTextView txt_TapToSelectTrackingPoint;
    public AutoresizeTextView noTrackingPoints;
    public FloatingActionButton floatingActionButton;

    @SuppressLint("StaticFieldLeak")
    public static EngineActivity engineActivity;


    @Override
    protected void onStart() {
        super.onStart();
        hideAllDialogs();
        fullCameraScreen =  findViewById(R.id.fullCameraScreen);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        engineActivity = EngineActivity.this;
        setContentView(R.layout.activity_main);
        syncManager = new SyncManager(this, this);
        scanManager = new ScanManager(syncManager, EngineActivity.this, this, this, this, this);
        Preferences.getSharedPreferences(this).registerOnSharedPreferenceChangeListener(this);
        resetDialogs();
        hasSurface = false;
        include = findViewById(R.id.include);
        connectivity_container = findViewById(R.id.connectivity_container);
        gateLayout = findViewById(R.id.gateLayout);
        online_layout = findViewById(R.id.online_layout);
        ic_soft_scan = findViewById(R.id.ic_soft_scan);
        scannerConnectivity = findViewById(R.id.scannerConnectivity);
        connectivityImage = findViewById(R.id.connectivityImage);
        connectionStatus = findViewById(R.id.connectionStatus);
        deviceStatus = findViewById(R.id.deviceStatus);
        batteryContainer = findViewById(R.id.batteryContainer);
        batteryDash_1 = findViewById(R.id.batteryDash_1);
        batteryDash_2 = findViewById(R.id.batteryDash_2);
        batteryDash_3 = findViewById(R.id.batteryDash_3);
        batteryDash_4 = findViewById(R.id.batteryDash_4);
        batteryDash_5 = findViewById(R.id.batteryDash_5);
        ic_charging = findViewById(R.id.ic_charging);
        timerText = findViewById(R.id.timeTxt);
        queue = findViewById(R.id.queue);
        top_view_layout = findViewById(R.id.top_view_layout);
        parentView = findViewById(R.id.parentView);
        gps = findViewById(R.id.gps);
        gateText = findViewById(R.id.gateText);
        tapToScan = findViewById(R.id.tapToScan);
        txt_TapToSelectTrackingPoint = findViewById(R.id.txt_TapToSelectTrackingPoint);

        AirportContainer = findViewById(R.id.AirportContainer);
        AirlineContainer = findViewById(R.id.AirlineContainer);
        txt_airport = findViewById(R.id.txt_airport);
        txt_airline = findViewById(R.id.txt_airline);
        ic_airport = findViewById(R.id.ic_airport);
        ic_airline = findViewById(R.id.ic_airline);

        scanPromptView = findViewById(R.id.scanPromptView);
        noTrackingPoints = findViewById(R.id.noTrackingPoints);

        floatingActionButton = findViewById(R.id.floatingActionButton);

        txt_airport.setText(Preferences.getInstance().getAirportcode(getApplicationContext()));
        txt_airline.setText(Preferences.getInstance().getAirlinecode(getApplicationContext()));

        locationLayout = findViewById(R.id.locationLayout);
        loginresponseStr = Preferences.getInstance().getLoginResponse(getApplicationContext());
        loginData = new Gson().fromJson(loginresponseStr, new TypeToken<LoginData>() {
        }.getType());


        gateLayout.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if(AppController.getInstance().isSelectedAirportHaveTrackingConfigurations()) {
                    FragmentManager fragmentManager = getSupportFragmentManager();
                    FragmentTransaction ft = fragmentManager.beginTransaction();
                    SelectTrackingFragment selectTrackingFragment = SelectTrackingFragment.getInstance();
                    if (!selectTrackingFragment.isAdded()) {
                        selectTrackingFragment.show(ft, "selectTrackingFragment");
                    }
                }

            }
//                }
//            }
        });
        bingo_progress_dialog = BINGO_Progress_Dialog.getInstance();

        if (loginData != null && loginData.getAirports() != null && AppController.getInstance().getAirportAirlineFromString(loginData.getAirports()).size() > 1) {

            AirportContainer.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View v) {
                    FragmentManager fragmentManager = getSupportFragmentManager();
                    FragmentTransaction ft = fragmentManager.beginTransaction();
                    SelectAirportFragment selectAirportFragment = new SelectAirportFragment();
                    selectAirportFragment.setType(true, EngineActivity.this);
                    if (!selectAirportFragment.isAdded())
                        selectAirportFragment.show(ft, "selectAirportFragment");
                }
            });
        } else {
            AirportContainer.setOnClickListener(null);
        }

        if (loginData!= null && loginData.getAirlines()!=null && AppController.getInstance().getAirportAirlineFromString(loginData.getAirlines()).size() > 1) {
            AirlineContainer.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View v) {
                    FragmentManager fragmentManager = getSupportFragmentManager();
                    FragmentTransaction ft = fragmentManager.beginTransaction();
                    SelectAirlineFragment selectAirlineFragment = new SelectAirlineFragment();
                    selectAirlineFragment.setType(true, EngineActivity.this);
                    if (!selectAirlineFragment.isAdded())
                        selectAirlineFragment.show(ft, "selectAirlineFragment");
                }
            });
        } else {
            AirlineContainer.setOnClickListener(null);
        }

        top_view_layout.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                FragmentManager fm = getSupportFragmentManager();
                SettingsDialog fragment;
                fragment = SettingsDialog.getInstance();
                fragment.setSettingsActions(EngineActivity.this);
                SettingsDialog prev = (SettingsDialog) fm.findFragmentByTag("setting_dialog");
                if (!fragment.isAdded()) {
                    if (prev != null && prev.isAdded()) {
                        fm.popBackStackImmediate();
                    }
                    FragmentTransaction ft = fm.beginTransaction();
                    ft.add(fragment, "setting_dialog");
                    ft.commit();

                }
            }
        });
        queue.setOnBagTagListener(this);
        BagDetailDialog.setOnBagTagListener(this);
        disableCode128();
        disable2of5Interleaved();
        CheckLocationStatus(Preferences.getInstance().getTrackingLocation(this));
        Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                syncManager.start();
            }
        }, 2000);

        if(this instanceof CognexScanActivity) {
            timer = new Timer();
            TimerTask timerTask = new TimerTask() {
                @Override
                public void run() {
                    getCognexBattery();
                }
            };
            timer.schedule(timerTask, 0l, 1000 * 60);
        }else if(this instanceof SocketMobileScanActivity) {
            timer = new Timer();
            TimerTask timerTask = new TimerTask() {
                @Override
                public void run() {
                    getSocketMobileBattery();
                }
            };
            timer.schedule(timerTask, 0l, 1000 * 60);
        }

        floatingActionButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                if (Preferences.getInstance().getIs2of5Enabled(getApplicationContext())
                        || Preferences.getInstance().getIsCode128Enabled(getApplicationContext())) {
                    FragmentManager fragmentManager = getSupportFragmentManager();
                    FragmentTransaction ft = fragmentManager.beginTransaction();
                    BagContainer_InputDialog bagContainer_inputDialog = new BagContainer_InputDialog();
                    if (!bagContainer_inputDialog.isAdded())
                        bagContainer_inputDialog.show(ft, "bagContainer_inputDialog");
                }
            }
        });
    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
    @Override
    public void onTrackingLocationScannedExtraActions(final String trackingLocation) {
        initBags();
        hideAllDialogs();
        setScannedLocation(trackingLocation);
        if (loginData != null && AppController.getInstance().getAirportAirlineFromString(loginData.getAirlines()).size() == 1) {
            LocationSuccessDialog.getInstance().setOnDismissListener(new DialogInterface.OnDismissListener() {
                @Override
                public void onDismiss(DialogInterface dialog) {
                    floatingActionButton.setVisibility(View.VISIBLE);
                    whatToDoAfterLocationScan();
                }
            });
        } else {
            LocationSuccessFullDialog.getInstance(this).setOnDismissListener(new DialogInterface.OnDismissListener() {
                @Override
                public void onDismiss(DialogInterface dialog) {
                    floatingActionButton.setVisibility(View.VISIBLE);
                    whatToDoAfterLocationScan();
                }
            });
        }

        if (AppController.getInstance().getAirportAirlineFromString(loginData.getAirlines()).size() > 1) {
            LocationSuccessFullDialog.getInstance(EngineActivity.this).showDialog(EngineActivity.this);
        } else {
            LocationSuccessDialog.getInstance().showDialog(isBottomAligned);
            scanPromptView.hideView();
            floatingActionButton.setVisibility(View.GONE);
        }
    }

    @Override
    public void onContainerScannedExtraActions(String trackingLocation) {
        scanManager.whatToDoAfterContainerScan();
    }

    @Override
    public void onBagScannedExtraActions(BagTag bagTag) {
        BagDetailDialog.getInstance(this).showDialog(bagTag, true, syncManager, this);
    }

    @Override
    public void whatToDoAfterContainerScanExtraActions(final String containerInput) {
        if (containerInput != null && containerInput.equalsIgnoreCase("N")) {
            if (!LocationSuccessFullDialog.getInstance(getApplicationContext()).isShown())
                scanPromptView.setPromptForBags();
            floatingActionButton.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void initBags() {
        queue.initBags();
    }

    @Override
    public void addBagTag(BagTag bagTag) {
        queue.addBagTag(bagTag);
    }

    private void setInternetConnectivityIcon(boolean isConnected) {
        connectivityImage.setImageResource(isConnected ? R.drawable.ic_signal_wifi : R.drawable.ic_signal_wifi_off);
        connectionStatus.setText(isConnected ? R.string.networkOnline : R.string.networkOffline);

        if (isConnected) {
            setInternetConnectivityHeaderColor();
        } else {
            connectivityImage.setColorFilter(getResources().getColor(isConnected ? R.color.gray : R.color.disconnected));
            connectionStatus.setTextColor(getResources().getColor(isConnected ? R.color.gray : R.color.disconnected));
        }

    }

    public void setScannerConnectivityIcon(boolean isConnected) {
        deviceStatus.setText(isConnected ? R.string.scannerConnected : R.string.scannerDisConnected);
        if (isConnected) {
            if(this instanceof CognexScanActivity || this instanceof SocketMobileScanActivity || this instanceof HoneyWellScanner_Activity) {
                batteryContainer.setVisibility(View.VISIBLE);
            }
            if (!Preferences.getInstance().isNightMode(getApplicationContext())) {
                deviceStatus.setTextColor(getResources().getColor(R.color.gray));
                scannerConnectivity.setColorFilter(getResources().getColor(R.color.gray));
                ic_soft_scan.setColorFilter(getResources().getColor(R.color.gray));
            }
        } else {
            if(this instanceof CognexScanActivity || this instanceof SocketMobileScanActivity || this instanceof HoneyWellScanner_Activity) {
                batteryContainer.setVisibility(View.GONE);
            }
            deviceStatus.setTextColor(getResources().getColor(R.color.disconnected));
            scannerConnectivity.setColorFilter(getResources().getColor(R.color.disconnected));
            ic_soft_scan.setColorFilter(getResources().getColor(R.color.disconnected));

        }
        if(this instanceof CognexScanActivity) {
            getCognexBattery();
        }

    }

    private void CheckLocationStatus(String location) {
        if (location == null) {
            Preferences.getInstance().resetFlightInfo(EngineActivity.this);
            Preferences.getInstance().resetContaineruld(EngineActivity.this);
            scanPromptView.setPromptForLocation();
            if(AppController.getInstance().isSelectedAirportHaveTrackingConfigurations()) {
                if(locationLayout.getVisibility()== View.GONE) {
                    txt_TapToSelectTrackingPoint.setVisibility(View.VISIBLE);
                    noTrackingPoints.setVisibility(View.GONE);
                }
                locationLayout.setVisibility(View.GONE);
            }
        } else {
            setScannedLocation(location);
        }
    }

    public void setScannedLocation(String location) {
        if (location != null) {
            setTimer();
        } else {
            Preferences.getInstance().resetFlightInfo(EngineActivity.this);
            Preferences.getInstance().resetContaineruld(EngineActivity.this);
            scanPromptView.setPromptForLocation();
        }
        setLocationDataOnHeader();

    }

    private void setTimer() {
        long startedTrackingTime = Preferences.getInstance().getStartTrackingTime(this);
        txt_TapToSelectTrackingPoint.setVisibility(View.GONE);
        noTrackingPoints.setVisibility(View.GONE);

        if (startedTrackingTime > 0) {
            Date currentDate = new Date();
            if ((startedTrackingTime + Constants.TrackingLocationExpireTime) > currentDate.getTime()) {
                long timeLeft = (startedTrackingTime + Constants.TrackingLocationExpireTime) - currentDate.getTime();
                if (timeLeft > 0) {
                    generateTimer(timeLeft);
                }
            } else {
                BagLogger.log("Should Delete Tracking");
                Preferences.getInstance().deleteTrackingLocation(EngineActivity.this);
            }
        } else {
            BagLogger.log("Started Tracking Time<0");
            Preferences.getInstance().deleteTrackingLocation(EngineActivity.this);
        }
    }

    private void generateTimer(long timeLeft) {
        if (countDownTimer != null) {
            countDownTimer.cancel();
            countDownTimer = null;
        }
        countDownTimer = new CountDownTimer(timeLeft, 1000) {
            public void onTick(long millisUntilFinished) {
                timerText.setText(formatTimeLeft(millisUntilFinished));
            }

            public void onFinish() {
                onClearTrackingPoint();
            }
        };
        countDownTimer.start();
    }

    private void enableDisableScanTypes() {
        whatToDoAfterLocationScan();
    }

    public void hideAllDialogs() {
        Flight_Screen_Dialog.dismissDialog();
        BagDetailDialog.hideDialog();
        if (loginData != null && AppController.getInstance().getAirportAirlineFromString(loginData.getAirlines()).size() == 1)
            LocationSuccessDialog.getInstance(). hideDialog();
        IdentifiedContainerDialog.hideDialog();
        InternetConnectionStatusDialog.hideDialog();
    }


    private String formatTimeLeft(long millis) {

        long mintues = TimeUnit.MILLISECONDS.toMinutes(millis);
        long seconds = TimeUnit.MILLISECONDS.toSeconds(millis) -
                TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(millis));

        return String.format("%s:%s",
                ("00" + Long.toString(mintues)).substring(Long.toString(mintues).length()),
                ("00" + Long.toString(seconds)).substring(Long.toString(seconds).length())

        );
    }

    public void setLocationDataOnHeader() {
        String trackingLocation = Preferences.getInstance().getTrackingLocation(this);
        txt_TapToSelectTrackingPoint = findViewById(R.id.txt_TapToSelectTrackingPoint);
        noTrackingPoints = findViewById(R.id.noTrackingPoints);
        if (trackingLocation != null) {
            gateText.setText(Location_Utils.getTrackingLocation(trackingLocation,true));
            locationLayout.setVisibility(View.VISIBLE);
        } else {
            locationLayout.setVisibility(View.GONE);
            if(AppController.getInstance().isSelectedAirportHaveTrackingConfigurations()) {
                if(locationLayout.getVisibility()== View.GONE) {
                    txt_TapToSelectTrackingPoint.setVisibility(View.VISIBLE);
                    noTrackingPoints.setVisibility(View.GONE);
                }
            }else {
                txt_TapToSelectTrackingPoint.setVisibility(View.GONE);
                noTrackingPoints.setVisibility(View.VISIBLE);
            }
        }
    }

    public void ShowNotConnectedDialog() {
        setScannerConnectivityIcon(false);
        Device_Connected_Dialog.getInstance(this).showDialog(false);
    }

    @Override
    protected void onStop() {
        hideAllDialogs();
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        engineActivity = null;
        txt_TapToSelectTrackingPoint = null;
        noTrackingPoints = null;
        if(timer!= null) {
            timer.cancel();
        }
        Preferences.getSharedPreferences(this).unregisterOnSharedPreferenceChangeListener(this);
    }

    public void resetDialogs() {
        BagLogger.log("New Instance created!! reset called!");
        Device_Connected_Dialog.resetDialog();
        Flight_Screen_Dialog.resetDialog();
        InternetConnectionStatusDialog.resetDialog();

        if (loginData != null && AppController.getInstance().getAirportAirlineFromString(loginData.getAirlines()).size() == 1)
            LocationSuccessDialog.resetDialog();
        else
            LocationSuccessDialog.resetDialog();

        BagDetailDialog.hideDialog();
        ApiResponseDialog.resetDialog();
    }

    //menu callbacks
    @Override
    public void onClearTrackingPoint() {
        floatingActionButton.setVisibility(View.GONE);
        Preferences.getInstance().deleteTrackingLocation(this);
        Preferences.getInstance().setBingoTempQueue(null);
        if (SettingsDialog.getInstance().getDialog() != null) {
            SettingsDialog.getInstance().dismissDialog();
        }
        hideAllDialogs();
        disable2of5Interleaved();
        disableCode128();
        enablePDF417();
        String currentLocation = Preferences.getInstance().getTrackingLocation(this);
        setScannedLocation(currentLocation);
        initBags();
        if(txt_TapToSelectTrackingPoint != null)
        if(AppController.getInstance().isSelectedAirportHaveTrackingConfigurations()) {
            txt_TapToSelectTrackingPoint.setVisibility(View.VISIBLE);
        }else {
            noTrackingPoints.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void onClearContainer() {
        Preferences.getInstance().resetContaineruld(this);
        SettingsDialog.getInstance().dismissDialog();
        whatToDoAfterLocationScan();
    }

    @Override
    public void onClearFlight() {
        Preferences.getInstance().resetFlightInfo(this);
        SettingsDialog.getInstance().dismissDialog();
        whatToDoAfterLocationScan();
    }

    //override in scanners Activities
    @Override
    public void onCreditsClicked(String cognexFirmwareVersion, String cognexBatteryLevel, String socketFirmwareVersion, String socketBattery,
                                 String fullDecodeVersion,String controlLogicVersion) {
    }

    @Override
    public void onsignOutClicked() {
        Preferences.getInstance().setLoginResponse(getApplicationContext(), null);
        Preferences.getInstance().setAirportCode(getApplicationContext(), null);
        Preferences.getInstance().setAirlineCode(getApplicationContext(), null);
        Preferences.getInstance().setTrackingMap(getApplicationContext(), null);
        Preferences.getInstance().deleteTrackingLocation(getApplicationContext());

        AlarmHelper.getInstance(getApplicationContext()).cancel();

        ActivityManager mngr = (ActivityManager) getSystemService(ACTIVITY_SERVICE);
        if(mngr!=null) {
            List<ActivityManager.RunningTaskInfo> taskList = mngr.getRunningTasks(10);
            //current activity is the only one in back stack
            if (taskList.get(0).numActivities == 1 &&
                    taskList.get(0).topActivity.getClassName().equals(this.getClass().getName())) {
                startActivity(new Intent(EngineActivity.this, LoginActivity.class));
            }
        }
        Device_Connected_Dialog.hideDialog();
        finish();
    }

    @Override
    public void onRestartClicked() {

        onClearTrackingPoint();
        onClearFlight();
        onClearContainer();
        Preferences.getInstance().setAirportCode(getApplicationContext(), null);
        Preferences.getInstance().setAirlineCode(getApplicationContext(), null);
        List<String> airportlist = AppController.getInstance().getAirportAirlineFromString(loginData.getAirports());
        List<String> airlinelist = AppController.getInstance().getAirportAirlineFromString(loginData.getAirlines());

        if (airportlist.size() == 1) {
            Preferences.getInstance().setAirportCode(getApplicationContext(), airportlist.get(0));

            if (airlinelist.size() > 1) {
                FragmentManager fragmentManager = getSupportFragmentManager();
                FragmentTransaction ft = fragmentManager.beginTransaction();
                SelectAirlineFragment selectAirlineFragment = new SelectAirlineFragment();
                if (!selectAirlineFragment.isAdded()) {
                    selectAirlineFragment.setType(true, EngineActivity.this);
//                    selectAirlineFragment.setCancelable(false);
                    selectAirlineFragment.show(ft, "selectAirlineFragment");
                }

            } else {
                Preferences.getInstance().setAirlineCode(getApplicationContext(), airlinelist.get(0));
            }
        } else {
            FragmentManager fragmentManager = getSupportFragmentManager();
            FragmentTransaction ft = fragmentManager.beginTransaction();
            SelectAirportFragment selectAirportFragment = new SelectAirportFragment();
            if (!selectAirportFragment.isAdded()) {

                if (airlinelist.size() == 1) {
                    Preferences.getInstance().setAirlineCode(getApplicationContext(), airlinelist.get(0));
                    selectAirportFragment.setType(true, EngineActivity.this);
                } else
                    selectAirportFragment.setType(false, EngineActivity.this);

//                selectAirportFragment.setCancelable(false);
                selectAirportFragment.show(ft, "selectAirportFragment");
            }
        }

    }

    //Bag Info Actions
    @Override
    public void onResetStatusClicked(BagTag bagTag) {
        BagDetailDialog.hideDialog();
        syncManager.resetAllStatus(bagTag.getErrorMsg(),this);
    }

    @Override
    public void onRemoveBagClicked(BagTag bagTag) {
        BagDetailDialog.hideDialog();
        BagTagDBHelper.getInstance(this).getBagtagTag().delete(bagTag);
        initBags();
    }

    @Override
    public void onDeleteAllSimilarClicked(BagTag bagTag) {
        BagDetailDialog.hideDialog();
        final DeleteQuery<BagTag> tableDeleteQuery = BagTagDBHelper.getInstance(getApplicationContext()).getBagtagTag().
                queryBuilder().where(BagTagDao.Properties.Locked.eq(true)).where(BagTagDao.Properties.ErrorMsg.eq(bagTag.getErrorMsg())).buildDelete();
        tableDeleteQuery.executeDeleteWithoutDetachingEntities();
        initBags();
    }

    @Override
    public void onTryAgainClicked(BagTag bagTag) {
        BagDetailDialog.hideDialog();
        bagTag.setErrorMsg(null);
        bagTag.setLocked(false);
        long id = BagTagDBHelper.getInstance(EngineActivity.this).getBagtagTag().insertOrReplace(bagTag);
        BagLogger.log("Replaced ID = " + id);
        addBagTag(bagTag);
        BagLogger.log("-Sync failed : " + bagTag.getErrorMsg());
        syncManager.start();
    }



    @Override
    public void onSignoutFailed(String error_message) {
        ApiResponseDialog.getInstance().showDialog(error_message, false,false,true,Constants.ResponseDialogExpireTime,false);
    }

    @Override
    public void onBagTagClicked(BagTag bagTag) {
        BagDetailDialog.getInstance(this).showDialog(bagTag,false,null,null);
    }

    @Override
    public void updateBagTagwithFlightData(String flightNumber, String flightType, String flightdate, BagTag bagTag) {
        enable2of5Interleaved();
        Preferences.getInstance().saveFlightInfo(this, flightdate, flightNumber, flightType);
        scanManager.updateBagintoDB(flightNumber, flightType, flightdate, bagTag);
        Flight_Screen_Dialog.dismissDialog();
        Flight_Screen_Dialog.getInstance(this).setOnGlobalFlightDataSaved(null);
        syncManager.start();
    }


    @Override
    public void flightDataSaved(String flightNumber, String flightType, String flightdate) {
        Preferences.getInstance().saveFlightInfo(this, flightdate, flightNumber, flightType);
        String trackingLocation = Preferences.getInstance().getTrackingLocation(this);
        whatToDoforContainer(trackingLocation);
        Flight_Screen_Dialog.getInstance(this).setOnGlobalFlightDataSaved(null);
        Flight_Screen_Dialog.dismissDialog();
        floatingActionButton.setVisibility(View.VISIBLE);
        //enableCode128();
        whatToDoAfterLocationScan();
    }

    @Override
    public void addSyncBag(BagTag bagTag) {
        enable2of5Interleaved();
        BagTagDBHelper.getInstance(this).getBagtagTag().insertOrReplace(bagTag);
        addBagTag(bagTag);
        syncManager.start();
    }

    @Override
    public void connected() {
        setInternetConnectivityIcon(true);
        whatToDoAfterLocationScan();
        InternetConnectionStatusDialog.hideDialog();
        syncManager.start();
    }

    @Override
    protected void onResume() {
        super.onResume();
        initBags();
        setupDialogs();
        connectivityChecker = new ConnectivityChecker(EngineActivity.this);
        registerReceiver(connectivityChecker, new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION));
        Utils.stopScanningService();
        canAddBingoActivity = true;
        if (Preferences.getInstance().isNightMode(getApplicationContext())) {
            tapToScan.setTextColor(getResources().getColor(R.color.dark_gray));
            deviceStatus.setTextColor(getResources().getColor(R.color.dark_gray));
            scannerConnectivity.setColorFilter(getResources().getColor(R.color.dark_gray));
            ic_soft_scan.setColorFilter(getResources().getColor(R.color.dark_gray));
        }

        boolean isMXConnectInstalled = appInstalledOrNot(getResources().getString(R.string.mx_connect_packagename));

        if (!isMXConnectInstalled && Preferences.getInstance().getScannerType(getApplicationContext()).equals(getResources().getString(R.string.cognex_scanner))) {
            SettingsPresenter presenter = new SettingsPresenter(getApplicationContext(), this);
            presenter.signoutApi();
        }

        adjustColors();
    }

    @Override
    public void notConnected() {
        hideAllDialogs();
        setInternetConnectivityIcon(false);
        String trackingLocation = Preferences.getInstance().getTrackingLocation(this);
        if (trackingLocation != null) {
            if (Utils.canContinueScanwithNoInternet(this)) {
                InternetConnectionStatusDialog.hideDialog();
            } else {
                disable2of5Interleaved();
                disableCode128();
                InternetConnectionStatusDialog.getInstance(this).showDialog(isBottomAligned);
            }
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        unregisterReceiver(connectivityChecker);
    }

    @Override
    public void onConnected() {
        if (isConnected()) {
            enablePDF417();
            disable2of5Interleaved();
            disableCode128();
        }
        setScannerConnectivityIcon(true);
        Device_Connected_Dialog.hideDialog();
        CheckLocationStatus(Preferences.getInstance().getTrackingLocation(this));
         enableDisableScanTypes();
        if (getIntent() != null && getIntent().hasExtra("bagTag")) {
            final BagTag bagTag = getIntent().getParcelableExtra("bagTag");
            String typeEvent = Location_Utils.getTypeEvent(Preferences.getInstance().getTrackingLocation(getApplicationContext()));
            String unkownBags = Location_Utils.getUnknownBags(Preferences.getInstance().getTrackingLocation(getApplicationContext()));

            if (typeEvent != null && unkownBags != null) {
                if (unkownBags.equalsIgnoreCase("U")) {
                    Flight_Screen_Dialog.getInstance(this).setReturnToBagDetails(true, syncManager, this);
                    Flight_Screen_Dialog.getInstance(this).showDialog(bagTag);
                }
            }
            getIntent().removeExtra("bagTag");
        }
    }

    @Override
    public void onDisconnected() {
        disablePDF417();
        disableCode128();
        disable2of5Interleaved();
        setScannerConnectivityIcon(false);
        hideAllDialogs();
        if (!isFinishing()) {
            Device_Connected_Dialog.getInstance(this).showDialog(false);
        }
        whatToDoAfterLocationScan();
        BagnetApplication.getApplicationInstance().socketBattery = BagnetApplication.getApplicationInstance().socketFirmwareVersion = "";

    }

    public void onBarcodeScanned(final String readString) {
        System.out.println("ReadString = " + readString);
        //handeling Tracking Location section
        final boolean isValidTrackingLocation = DataManUtils.isValidTrackingLocation(readString,EngineActivity.this);
        if (isValidTrackingLocation) {
            if (BINGO_Progress_Dialog.getInstance().getDialog() != null) {
                BINGO_Progress_Dialog.getInstance().getDialog().dismiss();
                Preferences.getInstance().resetBingoInfo(this);
            }
            scanManager.handleScannedTrackingLocation(readString);
        }


        // handeling Container Section
        boolean isValidContainerWithoutSpaces = DataManUtils.checkifThisContainerWithoutSpaces(readString);
        boolean isValidContainer = DataManUtils.isValidContainer(readString);
        if (isValidContainerWithoutSpaces || isValidContainer) {
            floatingActionButton.setVisibility(View.VISIBLE);
            scanManager.handleScannedContainer(readString);
        }


        boolean isValidBag = DataManUtils.isValidBag(readString);
        String trackingLocation = Preferences.getInstance().getTrackingLocation(this);
        String containerInput = Location_Utils.getContainerInput(trackingLocation);
        String container = Preferences.getInstance().getContaineruld(this);
        String type_event = Location_Utils.getTypeEvent(trackingLocation);
        boolean canScanBag = (type_event != null && type_event.equalsIgnoreCase("B")) || trackingLocation != null && containerInput != null && (containerInput.equalsIgnoreCase("N")
                || ((containerInput.equalsIgnoreCase("Y") && container != null && !container.equalsIgnoreCase(""))));
        if (!(isValidContainer || isValidContainerWithoutSpaces) && !isValidTrackingLocation && isValidBag && canScanBag) { // then its a bag!!!
            floatingActionButton.setVisibility(View.VISIBLE);
            scanManager.handleScannedBag(readString);
        }

        Vibrator v = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
        if(v!= null) {
            v.vibrate(100);
        }

    }

    public void whatToDoAfterLocationScan() {
        if (Utils.canContinueScanwithNoInternet(this)) {
            String trackingLocation = Preferences.getInstance().getTrackingLocation(this);
            if (Flight_Screen_Dialog.getInstance(this).isShown()) {
                Flight_Screen_Dialog.dismissDialog();
                Flight_Screen_Dialog.getInstance(this).setOnGlobalFlightDataSaved(null);
            }
            if (isConnected()) {
                if (trackingLocation != null) {
                    bingo_progress_dialog = BINGO_Progress_Dialog.getInstance();
                    //BINGO MODE
                    String event_type = Location_Utils.getTypeEvent(trackingLocation);
                    if (event_type != null && event_type.equalsIgnoreCase("B")) {
                        enablePDF417();
                        FragmentManager fragmentManager = getSupportFragmentManager();
                        FragmentTransaction ft = fragmentManager.beginTransaction();

                        if (Preferences.getInstance().getBingoBagsnumber(getApplicationContext()) == 0 &&
                                !LocationSuccessFullDialog.getInstance(getApplicationContext()).isShown()) {
                            if(canAddBingoActivity) {
                                canAddBingoActivity = false;
                                startActivityForResult(new Intent(EngineActivity.this, BINGO_Activity.class), 1);
                            }
                        } else if (Preferences.getInstance().getBingoBagsnumber(getApplicationContext()) != 0 && !bingo_progress_dialog.isAdded()) {
                            try {
                                bingo_progress_dialog.setCallback(this);
                                ft.add(bingo_progress_dialog, "bingo_progress_dialog");
                                ft.commitAllowingStateLoss();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                        return;
                    }

                    String unkownBags = Location_Utils.getUnknownBags(trackingLocation);
                    String flightNumber = Preferences.getInstance().getFlightNumber(this);
                    if(unkownBags != null) {
                        if (!unkownBags.equalsIgnoreCase("I")) {
                            if (unkownBags.equalsIgnoreCase("S") && flightNumber == null) {
                                if (!LocationSuccessFullDialog.getInstance(getApplicationContext()).isShown()) {
                                    scanPromptView.hideView();
                                    Flight_Screen_Dialog.getInstance(this).showDialog(null);
                                    Flight_Screen_Dialog.getInstance(this).setOnGlobalFlightDataSaved(this);
                                    floatingActionButton.setVisibility(View.GONE);
                                }
                            } else {
                                enableCode128();
                                whatToDoforContainer(trackingLocation);
                            }
                        } else {
                            enableCode128();
                            whatToDoforContainer(trackingLocation);
                        }
                    }
                }

            }
        } else {
            if (!isFinishing()) {
                if (Utils.canContinueScanwithNoInternet(this)) {
                    InternetConnectionStatusDialog.hideDialog();
                } else {
                    InternetConnectionStatusDialog.getInstance(this).showDialog(isBottomAligned);
                }
            }
        }

    }

    private void whatToDoforContainer(String trackingLocation) {
        final String containerInput = Location_Utils.getContainerInput(trackingLocation);
        String containerULD = Preferences.getInstance().getContaineruld(this);

        if ((containerULD == null || containerULD.equalsIgnoreCase("")) && containerInput != null) {
            if (containerInput.equalsIgnoreCase("N")) {
                scanManager.whatToDoAfterContainerScan();
            } else {
                floatingActionButton.setVisibility(View.VISIBLE);
                disable2of5Interleaved();
                if( containerInput.equalsIgnoreCase("C")) {
                    scanPromptView.setPromptForContainersOnly();
                }else {
                    scanPromptView.setPromptForContainer();
                }
            }
        } else {
            //already container scanned and user is resuming this activity
            scanManager.whatToDoAfterContainerScan();
        }
    }

    public void onUsbConnected() {
        setScannerConnectivityIcon(true);
        Device_Connected_Dialog.hideDialog();
    }

    @Override
    public void enableCode128() {
        Preferences.getInstance().setIsCode128Enabled(getApplicationContext(), true);
    }

    @Override
    public void disableCode128() {
        Preferences.getInstance().setIsCode128Enabled(getApplicationContext(), false);

    }

    @Override
    public void enablePDF417() {
    }

    @Override
    public void disablePDF417() {
    }

    @Override
    public void disable2of5Interleaved() {
        Preferences.getInstance().setIs2of5Enabled(getApplicationContext(), false);

    }

    @Override
    public void enable2of5Interleaved() {
        Preferences.getInstance().setIs2of5Enabled(getApplicationContext(), true);

    }

    @Override
    public void getSelectedAirport(String selectedAirport) {
        txt_airport.setText(selectedAirport);
    }

    @Override
    public void getSelectedAirline(String selectedAirline) {
        txt_airline.setText(selectedAirline);
    }

    @Override
    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
        switch (key) {
            case Preferences.TRACKING_MAP:
                String trackingPoint = Preferences.getInstance().getTrackingLocation(getApplicationContext());
                if (AppController.getInstance().isSelectedAirportHaveTrackingConfigurations()) {
                    if (txt_TapToSelectTrackingPoint != null && noTrackingPoints != null && trackingPoint == null) {
                        if (locationLayout.getVisibility() == View.GONE) {
                            txt_TapToSelectTrackingPoint.setVisibility(View.VISIBLE);
                            noTrackingPoints.setVisibility(View.GONE);
                        }
                    }
                } else {
                    txt_TapToSelectTrackingPoint.setVisibility(View.GONE);
                    noTrackingPoints.setVisibility(View.VISIBLE);
                }
                break;
            case Preferences.TACKINGLOCATION:
                if (Preferences.getInstance().getTrackingLocation(getApplicationContext()) == null) {
                    floatingActionButton.setVisibility(View.GONE);
                }
                break;
        }
    }

    @Override
    public boolean isConnected() {
        return true;
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


    public void isBottomAligned(boolean isBottom) {
        isBottomAligned = isBottom;
    }

    public void CheckLocationStatus() {
        CheckLocationStatus(Preferences.getInstance().getTrackingLocation(this));
    }

    private void adjustColors() {
        parentView.setBackgroundColor(AppController.getInstance().getSecondaryColor());

        LayerDrawable connectivity_container_layer = (LayerDrawable) connectivity_container.getBackground();
        GradientDrawable connectivity_container_border = (GradientDrawable) connectivity_container_layer.findDrawableByLayerId(R.id.border);
        GradientDrawable connectivity_container_body = (GradientDrawable) connectivity_container_layer.findDrawableByLayerId(R.id.body);


        LayerDrawable online_layout_layer = (LayerDrawable) online_layout.getBackground();
        GradientDrawable online_layout_border = (GradientDrawable) online_layout_layer.findDrawableByLayerId(R.id.border);
        GradientDrawable online_layout_body = (GradientDrawable) online_layout_layer.findDrawableByLayerId(R.id.body);


        GradientDrawable gateLayout_body = (GradientDrawable) gateLayout.getBackground();


        if (Preferences.getInstance().isNightMode(getApplicationContext())) {
            connectivity_container_border.setStroke(1, AppController.getInstance().getPrimaryColor());
            online_layout_border.setStroke(1, AppController.getInstance().getPrimaryColor());
            gateLayout_body.setStroke(1, AppController.getInstance().getPrimaryColor());

        } else {
            connectivity_container_border.setStroke(1, AppController.getInstance().getSecondaryGrayColor());
            online_layout_body.setStroke(1, AppController.getInstance().getSecondaryGrayColor());
            gateLayout_body.setStroke(1, AppController.getInstance().getSecondaryGrayColor());
        }
        txt_TapToSelectTrackingPoint.setTextColor(AppController.getInstance().getPrimaryOrangeColor());
        noTrackingPoints.setTextColor(AppController.getInstance().getPrimaryOrangeColor());

        if (AppController.getInstance().getAirportAirlineFromString(loginData.getAirports()).size() > 1) {
            txt_airport.setTextColor(AppController.getInstance().getPrimaryColor());
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                DrawableCompat.setTint(ic_airport.getDrawable(), AppController.getInstance().getPrimaryColor());
            } else {
                ic_airport.setImageDrawable(AppController.getTintedDrawable(ic_airport.getDrawable(), AppController.getInstance().getPrimaryColor()));
            }
        } else {
            txt_airport.setTextColor(AppController.getInstance().getSecondaryGrayColor());
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                DrawableCompat.setTint(ic_airport.getDrawable(), AppController.getInstance().getSecondaryGrayColor());
            } else {
                ic_airport.setImageDrawable(AppController.getTintedDrawable(ic_airport.getDrawable(), AppController.getInstance().getSecondaryGrayColor()));
            }

        }
        if (AppController.getInstance().getAirportAirlineFromString(loginData.getAirlines()).size() > 1) {
            txt_airline.setTextColor(AppController.getInstance().getPrimaryColor());
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {

                DrawableCompat.setTint(ic_airline.getDrawable(), AppController.getInstance().getPrimaryColor());
            } else {
                ic_airline.setImageDrawable(AppController.getTintedDrawable(ic_airline.getDrawable(), AppController.getInstance().getPrimaryColor()));
            }

        } else {
            txt_airline.setTextColor(AppController.getInstance().getSecondaryGrayColor());
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                DrawableCompat.setTint(ic_airline.getDrawable(), AppController.getInstance().getSecondaryGrayColor());
            } else {
                ic_airline.setImageDrawable(AppController.getTintedDrawable(ic_airline.getDrawable(), AppController.getInstance().getSecondaryGrayColor()));
            }
        }

        timerText.setTextColor(AppController.getInstance().getPrimaryOrangeColor());
        gateLayout_body.setColor(AppController.getInstance().getPrimaryGrayColor());
        connectivity_container_body.setColor(AppController.getInstance().getPrimaryGrayColor());
        online_layout_body.setColor(AppController.getInstance().getPrimaryGrayColor());
        gps.setColorFilter(AppController.getInstance().getSecondaryGrayColor());
        gateText.setTextColor(AppController.getInstance().getSecondaryGrayColor());
    }

    private void setInternetConnectivityHeaderColor() {
        connectionStatus.setTextColor(AppController.getInstance().getSecondaryGrayColor());
        connectivityImage.setColorFilter(AppController.getInstance().getSecondaryGrayColor());
    }

    @Override
    public void onBackPressed() {
        //do nothing
    }

    private void setupDialogs() {

        Gson gson = new Gson();
        LoginResponse loginData = gson.fromJson(Preferences.getInstance().getLoginResponse(getApplicationContext()), LoginResponse.class);
        List<String> airportlist = new ArrayList<>();
        List<String> airlinelist = new ArrayList<>();

        if (loginData != null && loginData.getAirports() != null) {
            airportlist = AppController.getInstance().getAirportAirlineFromString(loginData.getAirports());
        }
        if (loginData != null && loginData.getAirlines() != null) {
            airlinelist = AppController.getInstance().getAirportAirlineFromString(loginData.getAirlines());
        }
        if (Preferences.getInstance().getAirlinecode(getApplicationContext()) == null ||
                Preferences.getInstance().getAirportcode(getApplicationContext()) == null) {
            if (airportlist.size() == 1) {
                Preferences.getInstance().setAirportCode(getApplicationContext(), airportlist.get(0));

                if (airlinelist.size() == 1) {
                    Preferences.getInstance().setAirlineCode(getApplicationContext(), airlinelist.get(0));
                } else {
                    FragmentManager fragmentManager = getSupportFragmentManager();
                    FragmentTransaction ft = fragmentManager.beginTransaction();
                    SelectAirlineFragment selectAirlineFragment = new SelectAirlineFragment();
                    if (!selectAirlineFragment.isAdded()) {
                        selectAirlineFragment.setType(true, EngineActivity.this);
                        selectAirlineFragment.show(ft, "selectAirlineFragment");
                    }
                }
            }
            //more than one airport
            else if (airportlist.size() > 1) {
                FragmentManager fragmentManager = getSupportFragmentManager();
                FragmentTransaction ft = fragmentManager.beginTransaction();
                SelectAirportFragment selectAirportFragment = new SelectAirportFragment();
                if (!selectAirportFragment.isAdded()) {
                    if (airlinelist.size() == 1) {
                        Preferences.getInstance().setAirlineCode(getApplicationContext(), airlinelist.get(0));
                        selectAirportFragment.setType(true, EngineActivity.this);
                    } else
                        selectAirportFragment.setType(false, EngineActivity.this);

                    selectAirportFragment.show(ft, "selectAirportFragment");
                }
            }
        }
    }

    private boolean appInstalledOrNot(String package_name) {
        PackageManager pm = getPackageManager();
        try {
            pm.getPackageInfo(package_name, PackageManager.GET_ACTIVITIES);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        if (requestCode == 1) {
            if (resultCode == Activity.RESULT_OK) {
                boolean isFrom_BINGO_Activity = data.getBooleanExtra("isFrom_BINGO_Activity", false);

                if (!isFinishing() && isFrom_BINGO_Activity &&
                        Preferences.getInstance().getBingoBagsnumber(getApplicationContext()) != 0) {
                    FragmentManager fragmentManager = getSupportFragmentManager();
                    FragmentTransaction ft = fragmentManager.beginTransaction();
                    BINGO_Progress_Dialog bingo_progress_dialog = BINGO_Progress_Dialog.getInstance();
                    bingo_progress_dialog.setCallback(this);
                    ft.add(bingo_progress_dialog, "bingo_progress_dialog");
                    ft.commitAllowingStateLoss();
                }
            } else {
                if (resultCode == 2) {
                } else
                    onClearTrackingPoint();
            }
        }

    }

    @SuppressLint("MissingSuperCall")
    @Override
    protected void onSaveInstanceState(Bundle outState) {
    }

    private void  getCognexBattery() {
        if (CognexScanActivity.readerDevice != null && CognexScanActivity.readerDevice.getDataManSystem() != null) {

            CognexScanActivity.readerDevice.getDataManSystem().sendCommand("GET BATTERY.CHARGE", new DataManSystem.OnResponseReceivedListener() {
                @Override
                public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                    BagLogger.log("GET BATTERY.CHARGE " + response.getPayLoad());
                    String cognegBattery = response.getPayLoad();
                    if(cognegBattery!=null) {
                        updateBatteryView(Integer.parseInt(cognegBattery),false);
                    }
                }
            });
        }
    }


    public void getSocketMobileBattery () {
        ScanApiHelper _scanApiHelper = BagnetApplication.getApplicationInstance()._scanApiHelper;
        if(BagnetApplication.getApplicationInstance().DeviceInformation!= null)
            _scanApiHelper.postGetBattery(BagnetApplication.getApplicationInstance().DeviceInformation, socketBatteryCallback);
    }

    protected ICommandContextCallback socketBatteryCallback = new ICommandContextCallback() {
        @Override
        public void run(ISktScanObject scanObj) {
            byte[] bytearr =AppController.getInstance().longToBytes(scanObj.getProperty().getUlong());
            if(bytearr.length >6) {
                String socketBattery = String.valueOf(bytearr[6]);
                updateBatteryView(Integer.parseInt(socketBattery),false);
            }
        }
    };

    public void updateBatteryView(final int batteryLevel, final boolean ischarging) {
        this.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                updateBatteryUI(batteryLevel,ischarging);
            } });
    }

    private void updateBatteryUI(int batterylevel, boolean ischarging) {
        if(ischarging) {
            ic_charging.setVisibility(View.VISIBLE);
        }else {
            ic_charging.setVisibility(View.GONE);
        }
        if(batterylevel >=0 && batterylevel<20){
            batteryDash_1.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_red));
            batteryDash_2.setBackground(getResources().getDrawable(R.drawable.battery_rectangle));
            batteryDash_3.setBackground(getResources().getDrawable(R.drawable.battery_rectangle));
            batteryDash_4.setBackground(getResources().getDrawable(R.drawable.battery_rectangle));
            batteryDash_5.setBackground(getResources().getDrawable(R.drawable.battery_rectangle));
        }else if(batterylevel>=20 && batterylevel<40){
            batteryDash_1.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_red));
            batteryDash_2.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_red));
            batteryDash_3.setBackground(getResources().getDrawable(R.drawable.battery_rectangle));
            batteryDash_4.setBackground(getResources().getDrawable(R.drawable.battery_rectangle));
            batteryDash_5.setBackground(getResources().getDrawable(R.drawable.battery_rectangle));
        }else if(batterylevel>=40 && batterylevel<60) {
            batteryDash_1.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_orange));
            batteryDash_2.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_orange));
            batteryDash_3.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_orange));
            batteryDash_4.setBackground(getResources().getDrawable(R.drawable.battery_rectangle));
            batteryDash_5.setBackground(getResources().getDrawable(R.drawable.battery_rectangle));
        }else if (batterylevel>=60 && batterylevel<80) {
            batteryDash_1.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_green));
            batteryDash_2.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_green));
            batteryDash_3.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_green));
            batteryDash_4.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_green));
            batteryDash_5.setBackground(getResources().getDrawable(R.drawable.battery_rectangle));
        }else {
            batteryDash_1.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_green));
            batteryDash_2.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_green));
            batteryDash_3.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_green));
            batteryDash_4.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_green));
            batteryDash_5.setBackground(getResources().getDrawable(R.drawable.battery_rectangle_green));
        }
    }
}
