package aero.developer.bagnet.presenters;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;

import com.google.gson.Gson;
import com.honeywell.aidc.ScannerNotClaimedException;
import com.honeywell.aidc.ScannerUnavailableException;

import java.io.IOException;
import java.util.List;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.Constants;
import aero.developer.bagnet.LoginActivity;
import aero.developer.bagnet.R;
import aero.developer.bagnet.Sign_In_Timeout.AlarmHelper;
import aero.developer.bagnet.api.ApiCalls;
import aero.developer.bagnet.dialogs.ApiResponseDialog;
import aero.developer.bagnet.interfaces.OnTrackBag;
import aero.developer.bagnet.interfaces.SettingsActions;
import aero.developer.bagnet.objects.AssociatedData;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.objects.Error;
import aero.developer.bagnet.objects.TrackBagResponse;
import aero.developer.bagnet.scantypes.CognexScanActivity;
import aero.developer.bagnet.scantypes.EngineActivity;
import aero.developer.bagnet.socketmobile.BagnetApplication;
import aero.developer.bagnet.utils.DataManUtils;
import aero.developer.bagnet.utils.Preferences;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

import static aero.developer.bagnet.Constants.SESSION_ERROR_1;
import static aero.developer.bagnet.Constants.SESSION_ERROR_2;
import static aero.developer.bagnet.Constants.SESSION_ERROR_3;
import static aero.developer.bagnet.scantypes.HoneyWellScanner_Activity.barcodeReader;
import static android.content.Context.ACTIVITY_SERVICE;

/**
 * Created by User on 8/17/2016.
 */
public class TrackingBagPresenter implements Callback<TrackBagResponse>,SettingsActions {

    private BagTag mBagTag = null;
    private OnTrackBag callback = null;
    private Context context;
    private ProgressDialog progressBar;
    public TrackingBagPresenter(OnTrackBag callback) {
        this.callback = callback;
    }

    public void setCallback(OnTrackBag callback) {
        this.callback = callback;
    }

    public void trackBag(Context context, BagTag bag) {
        this.mBagTag = bag;
        this.context = context;
        ApiCalls.getInstance().trackBag(context, bag, this);
    }

    @Override
    public void onResponse(Call<TrackBagResponse> call, Response<TrackBagResponse> response) {
        TrackBagResponse bagResponse=null;
        String errorCode = "";
        if (this.callback != null) {
            if (response.body()!=null){
                bagResponse = response.body();
            }else{
                try {
                    Gson gson = new Gson();
                    bagResponse = gson.fromJson(response.errorBody().string(), TrackBagResponse.class);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            if (bagResponse!=null && bagResponse.isSuccess()) {

                AlarmHelper.getInstance(context).cancel();
                AlarmHelper.getInstance(context).setAlarm(true);

                AssociatedData associatedData = bagResponse.getAssociated_data();
                if(associatedData!=null){
                    mBagTag.setPnr(associatedData.getPnr());
                    mBagTag.setPassenger_last_name(associatedData.getPassenger_last_name());
                    mBagTag.setPassenger_first_name(associatedData.getPassenger_first_name());
                    mBagTag.setInbound_airline_code(associatedData.getInbound_airline_code());
                    mBagTag.setInbound_flight_date(associatedData.getInbound_flight_date());
                    mBagTag.setOrigin_airport(associatedData.getOrigin_airport());
                    mBagTag.setOutbound_airline_code(associatedData.getOutbound_airline_code());
                    mBagTag.setOutbound_flight_date(associatedData.getOutbound_flight_date());
                    mBagTag.setDestination_airport(associatedData.getDestination_airport());
                    mBagTag.setInbound_flight_num(associatedData.getInbound_flight_num());
                    mBagTag.setOutbound_flight_num(associatedData.getOutbound_flight_num());
                }
                this.callback.trackSuccess(mBagTag);
            } else {
                String errors="";
                if (bagResponse!=null && bagResponse.getErrors()!=null && bagResponse.getErrors().size()>0){
                    for (Error error:bagResponse.getErrors()){
                        errors+= error.getError_description()+"\n";
                    }
                }
                if( bagResponse!=null && bagResponse.getErrors()!=null && bagResponse.getErrors().size()>0 && (
                        bagResponse.getErrors().get(0).getError_code().equals(SESSION_ERROR_1) || bagResponse.getErrors().get(0).getError_code().equals(SESSION_ERROR_2) ||
                                bagResponse.getErrors().get(0).getError_code().equals(SESSION_ERROR_3))) {
                    errorCode = bagResponse.getErrors().get(0).getError_code();
                    ApiResponseDialog.getInstance().showDialog(context.getResources().getString(R.string.expired_login),false,false,true,Constants.ResponseDialogExpireTime,false);
                    new Handler().postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            progressBar = new ProgressDialog(context, R.style.ProgressDialog);
                            progressBar.setCancelable(false);
                            if(context instanceof EngineActivity &&!((AppCompatActivity) context).isFinishing()) {
                                progressBar.show();
                            }
                            SettingsPresenter presenter = new SettingsPresenter(context,TrackingBagPresenter.this);
                            presenter.signoutApi();
                        }
                    }, Constants.ResponseDialogExpireTime);
                }
                if (this.callback != null) {
                    mBagTag.setLocked(true);
                    mBagTag.setErrorMsg(errors);
                    Doublebeep();
                    this.callback.trackFailed(mBagTag, errorCode);
                }
            }
        }
    }

    private void Doublebeep() {
        String scannerType = Preferences.getInstance().getScannerType(context);
        if (scannerType.equalsIgnoreCase(context.getResources().getString(R.string.socket_mobile_bt))) {
            BagnetApplication.getApplicationInstance().beepBadScan(false);
            BagnetApplication.getApplicationInstance().beepBadScan(false);
        } else if (scannerType.equalsIgnoreCase(context.getResources().getString(R.string.cognex_scanner))) {
            DataManUtils.fireBeepTwice(CognexScanActivity.readerDevice.getDataManSystem());
        } else if (scannerType.equalsIgnoreCase(context.getResources().getString(R.string.honeywell_ct50_scanner))) {

            try {
                barcodeReader.aim(true);
                barcodeReader.light(true);
                barcodeReader.decode(true);
            } catch (ScannerNotClaimedException | ScannerUnavailableException e) {
                e.printStackTrace();
            }
            try {
                barcodeReader.aim(false);
                barcodeReader.light(false);
                barcodeReader.decode(false);
            } catch (ScannerNotClaimedException | ScannerUnavailableException e) {
                e.printStackTrace();
            }
        }
    }
    @Override
    public void onFailure(Call<TrackBagResponse> call, Throwable t) {

        if (this.callback != null) {
            mBagTag.setLocked(false);
            mBagTag.setErrorMsg(AppController.getInstance().getResources().getString(R.string.Network_Connection_Issue));
            this.callback.onConnectionFailed(mBagTag);
        }
    }

    @Override
    public void onsignOutClicked() {
        Preferences.getInstance().setLoginResponse(context,null);
        Preferences.getInstance().setAirportCode(context,null);
        Preferences.getInstance().setAirlineCode(context,null);
        Preferences.getInstance().setTrackingMap(context,null);
        Preferences.getInstance().deleteTrackingLocation(context);

        AlarmHelper.getInstance(context).cancel();


        if (progressBar!= null && context instanceof EngineActivity && !((Activity)context).isFinishing()) {
           progressBar.dismiss();
       }
        ActivityManager mngr = (ActivityManager)context.getSystemService( ACTIVITY_SERVICE );
        if (mngr != null) {

            List<ActivityManager.RunningTaskInfo> taskList = mngr.getRunningTasks(10);

            //current activity is the only one in back stack
            if(taskList.get(0).numActivities == 1 &&
                    taskList.get(0).topActivity.getClassName().equals(context.getClass().getName())) {
                context.startActivity(new Intent(context, LoginActivity.class));
            }
        }

        ((Activity) context).finish();
    }


    @Override
    public void onClearContainer() {}

    @Override
    public void onClearFlight() {}

    @Override
    public void onClearTrackingPoint() {}

    @Override
    public void onCreditsClicked(String cognexFirmwareVersion, String cognexBattery, String socketFirmwareVersion, String socketBattery
    ,String fullDecodeVersion,String controlLogicVersion) {}

    @Override
    public void onRestartClicked() {}

    @Override
    public void onSignoutFailed(String error_message) {
        progressBar.dismiss();
        ApiResponseDialog.getInstance().showDialog(error_message,false,false,true,Constants.ResponseDialogExpireTime,false);
    }
}
