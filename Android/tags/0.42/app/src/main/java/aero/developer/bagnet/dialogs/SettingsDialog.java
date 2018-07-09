package aero.developer.bagnet.dialogs;


import android.app.Activity;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.cognex.dataman.sdk.DataManSystem;
import com.cognex.dataman.sdk.DmccResponse;
import com.honeywell.aidc.ScannerUnavailableException;
import com.socketmobile.scanapi.ISktScanObject;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.CustomViews.CustomButton;
import aero.developer.bagnet.R;
import aero.developer.bagnet.interfaces.SettingsActions;
import aero.developer.bagnet.interfaces.SignoutActions;
import aero.developer.bagnet.objects.BlurBuilder;
import aero.developer.bagnet.presenters.SettingsPresenter;
import aero.developer.bagnet.scantypes.CognexScanActivity;
import aero.developer.bagnet.scantypes.HoneyWellScanner_Activity;
import aero.developer.bagnet.scantypes.SocketMobileScanActivity;
import aero.developer.bagnet.socketmobile.BagnetApplication;
import aero.developer.bagnet.socketmobile.ICommandContextCallback;
import aero.developer.bagnet.socketmobile.ScanApiHelper;
import aero.developer.bagnet.utils.Analytic;
import aero.developer.bagnet.utils.BagLogger;
import aero.developer.bagnet.utils.Preferences;

public class SettingsDialog extends DialogFragment implements View.OnClickListener,SignoutActions {

    public static SettingsDialog mInstance = null;
    private String cognexFirmwareVersion,cognexBattery;
    private String socketFirmwareVersion , socketBattery;
    private String fullDecodeVersion,controlLogicVersion;
    private LinearLayout progressbarContainer;
    public LinearLayout linearLayout2;
    public void setSettingsActions(SettingsActions settingsActions) {
        this.settingsActions = settingsActions;
    }


    SettingsActions settingsActions;
    public static SettingsDialog getInstance() {
        if (mInstance == null) {
            mInstance = new SettingsDialog();
        }
        return mInstance;
    }


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(DialogFragment.STYLE_NORMAL, R.style.AppTheme);
    }


    @Override
    public View onCreateView(final LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        final View layout = inflater.inflate(R.layout.setting_dialog, container, false);
           final Activity activity = getActivity();
           final View content = activity.findViewById(android.R.id.content).getRootView();

           if (content.getWidth() > 0) {
               Bitmap image = BlurBuilder.blur(content);
               if (getDialog() != null && getDialog().getWindow() != null)
                   getDialog().getWindow().setBackgroundDrawable(new BitmapDrawable(activity.getResources(), image));

           } else {
               content.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
                   @Override
                   public void onGlobalLayout() {
                       Bitmap image = BlurBuilder.blur(content);
                       if (getDialog() != null && getDialog().getWindow() != null)
                           getDialog().getWindow().setBackgroundDrawable(new BitmapDrawable(activity.getResources(), image));
                   }
               });
           }

           cognexFirmwareVersion = cognexBattery = socketFirmwareVersion = socketBattery = "";
           if (activity instanceof CognexScanActivity) {
               DataManSystem dataManSystem = ((CognexScanActivity) getActivity()).getDataManSystem();
               if (dataManSystem != null && dataManSystem.isConnected()) {
                   dataManSystem.sendCommand("GET DEVICE.FIRMWARE-VER", new DataManSystem.OnResponseReceivedListener() {
                       @Override
                       public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                           BagLogger.log("GET DEVICE.FIRMWARE-VER " + response.getPayLoad());
                           cognexFirmwareVersion = response.getPayLoad();

                       }
                   });

                   dataManSystem.sendCommand("GET BATTERY.CHARGE", new DataManSystem.OnResponseReceivedListener() {
                       @Override
                       public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                           BagLogger.log("GET BATTERY.CHARGE " + response.getPayLoad());
                           cognexBattery = response.getPayLoad();

                       }
                   });
               }
           }
           if (activity instanceof SocketMobileScanActivity) {
               getSocketMobileBattery();
//               socketBattery = BagnetApplication.getApplicationInstance().socketBattery;
               socketFirmwareVersion = BagnetApplication.getApplicationInstance().socketFirmwareVersion;
           }
        if(activity instanceof HoneyWellScanner_Activity) {
            try {
                fullDecodeVersion = HoneyWellScanner_Activity.barcodeReader.getInfo().getFullDecodeVersion();
                controlLogicVersion = HoneyWellScanner_Activity.barcodeReader.getInfo().getControlLogicVersion();
            } catch (ScannerUnavailableException e) {
                e.printStackTrace();
            }
        }
           return layout;
       }

    public void getSocketMobileBattery () {
        ScanApiHelper _scanApiHelper = BagnetApplication.getApplicationInstance()._scanApiHelper;
        if(BagnetApplication.getApplicationInstance().DeviceInformation!= null) {
            _scanApiHelper.postGetBattery(BagnetApplication.getApplicationInstance().DeviceInformation, socketBatteryCallback);
        }else {
            socketBattery = BagnetApplication.getApplicationInstance().socketBattery;
        }
    }
    protected ICommandContextCallback socketBatteryCallback = new ICommandContextCallback() {
        @Override
        public void run(ISktScanObject scanObj) {
            byte[] bytearr = AppController.getInstance().longToBytes(scanObj.getProperty().getUlong());
            if(bytearr.length >6) {
                socketBattery = String.valueOf(bytearr[6]);
            }
        }
    };

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        Analytic.getInstance().sendScreen(R.string.EVENT_MENU_SCREEN);
        CustomButton change_password = (CustomButton) view.findViewById(R.id.change_password);
        CustomButton clear_container = (CustomButton) view.findViewById(R.id.clear_container);
        CustomButton clear_flight = (CustomButton) view.findViewById(R.id.clear_flight);
        CustomButton clear_tracking_point = (CustomButton) view.findViewById(R.id.clear_tracking_point);
        CustomButton credits = (CustomButton) view.findViewById(R.id.credits);
        CustomButton sign_out = (CustomButton) view.findViewById(R.id.sign_out);
        CustomButton restart = (CustomButton) view.findViewById(R.id.restart);
        TextView txt_userId = (TextView) view.findViewById(R.id.txt_userId);
        progressbarContainer = (LinearLayout) view.findViewById(R.id.progressbarContainer);
        LinearLayout backContainer = (LinearLayout) view.findViewById(R.id.backContainer);
        linearLayout2 = (LinearLayout)  view.findViewById(R.id.linearLayout2);
        txt_userId.setText(Preferences.getInstance().getUserID(getContext()));
        clear_container.setVisibility((Preferences.getInstance().getContaineruld(getContext()) != null && !Preferences.getInstance().getContaineruld(getContext()).equalsIgnoreCase("")) ? View.VISIBLE : View.GONE);
        clear_flight.setVisibility(Preferences.getInstance().getFlightNumber(getContext()) != null ? View.VISIBLE : View.GONE);
        clear_tracking_point.setVisibility(Preferences.getInstance().getTrackingLocation(getContext()) != null ? View.VISIBLE : View.GONE);
        backContainer.setOnClickListener(this);
        change_password.setOnClickListener(this);
        clear_container.setOnClickListener(this);
        clear_flight.setOnClickListener(this);
        clear_tracking_point.setOnClickListener(this);
        credits.setOnClickListener(this);
        sign_out.setOnClickListener(this);
        restart.setOnClickListener(this);



    }

    @Override
    public void onClick(View v) {
        if (this.settingsActions != null) {
            switch (v.getId()) {
                case R.id.backContainer:
                    this.dismiss();
                    break;
                case R.id.change_password:
                    Analytic.getInstance().sendScreen(R.string.EVENT_CHANGE_PASSWORD_SCREEN);
                    FragmentManager fragmentManager = getFragmentManager();
                    FragmentTransaction ft = fragmentManager.beginTransaction();
                    ChangepasswordFragment changepasswordFragment = new ChangepasswordFragment();
                    if (!changepasswordFragment.isAdded()) {
                        Bundle bundle = new Bundle();
                        bundle.putBoolean("showSubtitle",false);
                        changepasswordFragment.setArguments(bundle);
                        changepasswordFragment.show(ft, "changepasswordFragment");
                    }
                    break;
                case R.id.clear_container:
                    Analytic.getInstance().sendScreen(R.string.EVENT_CLEAR_CONTAINER_SCREEN);
                    this.settingsActions.onClearContainer();
                    break;
                case R.id.clear_flight:
                    Analytic.getInstance().sendScreen(R.string.EVENT_CLEAR_FLIGHT_INFORMATION_SCREEN);
                    this.settingsActions.onClearFlight();
                    break;
                case R.id.clear_tracking_point:
                    Analytic.getInstance().sendScreen(R.string.EVENT_CLEAR_TRACKING_POINT_SCREEN);
                    this.settingsActions.onClearTrackingPoint();
                    break;
                case R.id.credits:
                    Analytic.getInstance().sendScreen(R.string.EVENT_CLEAR_ABOUT_SCREEN);
                    this.settingsActions.onCreditsClicked(cognexFirmwareVersion , cognexBattery,socketFirmwareVersion, socketBattery,fullDecodeVersion,controlLogicVersion);
                    break;
                case R.id.restart:
                    this.settingsActions.onRestartClicked();
                    break;
                case R.id.sign_out:
                    SettingsPresenter presenter = new SettingsPresenter(getActivity(),settingsActions);
                    presenter.signoutApi();
                    break;
            }
        }
    }

    public void dismissDialog() {
        dismiss();
    }



    @Override
    public LinearLayout getProgressbar() {
        return progressbarContainer;
    }

    @Override
    public void onPause() {
        super.onPause();
        dismiss();
    }
    @Override
    public void onDismiss(DialogInterface dialog) {
        super.onDismiss(dialog);
    }

    public boolean isShown(){
        boolean shown=false;
        if(getDialog()!=null && getDialog().isShowing()){
            shown=true;
        }
        return shown;
    }
}
