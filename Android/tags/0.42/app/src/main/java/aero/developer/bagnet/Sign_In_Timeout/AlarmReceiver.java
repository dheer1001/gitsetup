package aero.developer.bagnet.Sign_In_Timeout;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.cognex.dataman.sdk.DataManSystem;
import com.cognex.dataman.sdk.DmccResponse;
import com.google.gson.Gson;

import aero.developer.bagnet.Constants;
import aero.developer.bagnet.R;
import aero.developer.bagnet.api.ApiCalls;
import aero.developer.bagnet.interfaces.SettingsActions;
import aero.developer.bagnet.objects.FakeAPIRequest;
import aero.developer.bagnet.objects.FakeAPIResponse;
import aero.developer.bagnet.objects.LoginResponse;
import aero.developer.bagnet.presenters.SettingsPresenter;
import aero.developer.bagnet.scantypes.CognexScanActivity;
import aero.developer.bagnet.utils.Preferences;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

import static aero.developer.bagnet.scantypes.EngineActivity.engineActivity;

/**
 * Created by Mohamad Itani on 23-Feb-18.
 */

public class AlarmReceiver extends BroadcastReceiver implements Callback<FakeAPIResponse>, SettingsActions {
    int counter;
    Context context;
    @Override
    public void onReceive(final Context context, Intent intent) {
        int counter = Preferences.getInstance().getAlarmCounter(context);
        this.context = context;
        if (counter < Constants.AlarmMaxTriggers) {
            this.counter = counter;
            if (Preferences.getInstance().getScannerType(context).equalsIgnoreCase(context.getString(R.string.cognex_scanner))) {
                if (CognexScanActivity.readerDevice != null && CognexScanActivity.readerDevice.getDataManSystem() != null && CognexScanActivity.readerDevice.getDataManSystem().isConnected()) {
                    CognexScanActivity.readerDevice.getDataManSystem().sendCommand("GET POWER.EXTERNAL", new DataManSystem.OnResponseReceivedListener() {
                        @Override
                        public void onResponseReceived(DataManSystem dataManSystem, DmccResponse response) {
                            String ischargingScanner = response.getPayLoad();
                            if (ischargingScanner!=null && ischargingScanner.equalsIgnoreCase("ON")) {
                                SettingsPresenter presenter = new SettingsPresenter(context, AlarmReceiver.this);
                                presenter.signoutApi();
                            } else {
                                executeFakeBagDetailsAPI(context);
                            }
                        }
                    });
                } else {
                    executeFakeBagDetailsAPI(context);
                }
            } else {
                executeFakeBagDetailsAPI(context);
            }

        } else {
            SettingsPresenter presenter = new SettingsPresenter(context, AlarmReceiver.this);
//            presenter.setFromAlarmManager(true);
            presenter.signoutApi();

        }
    }

    public void executeFakeBagDetailsAPI(final Context context) {
        Gson gson = new Gson();
        LoginResponse loginResponse = null;
        if(Preferences.getInstance()!= null && Preferences.getInstance().getLoginResponse(context)!= null) {
            loginResponse = gson.fromJson(Preferences.getInstance().getLoginResponse(context), LoginResponse.class);
        }
        if (loginResponse != null) {
            String user_id = Preferences.getInstance().getUserID(context);
            String company_id = Preferences.getInstance().getCompanyID(context);
            String api_key = loginResponse.getApi_key();
            FakeAPIRequest fakeAPIRequest = new FakeAPIRequest(user_id, company_id, api_key);
            ApiCalls.getInstance().fakeAPICall(fakeAPIRequest, AlarmReceiver.this);
        }
    }

    @Override
    public void onResponse(Call<FakeAPIResponse> call, Response<FakeAPIResponse> response) {
        FakeAPIResponse fakeAPIResponse = response.body();
        if (fakeAPIResponse == null) {
            try {
                Gson gson = new Gson();
                fakeAPIResponse = gson.fromJson(response.errorBody().string(), FakeAPIResponse.class);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (fakeAPIResponse != null && fakeAPIResponse.isSuccess()) {
            Preferences.getInstance().setAlarmCounter(counter + 1,context);
            AlarmHelper.getInstance(context).setAlarm(true);
            String login_response = Preferences.getInstance().getLoginResponse(context);
            Gson gson = new Gson();
            LoginResponse loginResponse_Object = gson.fromJson(login_response,LoginResponse.class);
            loginResponse_Object.setApi_key(fakeAPIResponse.getApi_key());
            Preferences.getInstance().setLoginResponse(context,gson.toJson(loginResponse_Object));
        } else {
            AlarmHelper.getInstance(context).cancel();
        }
    }

    @Override
    public void onFailure(Call<FakeAPIResponse> call, Throwable t) {
        t.printStackTrace();
        Preferences.getInstance().setAlarmCounter(counter + 1,context);
        AlarmHelper.getInstance(context).setAlarm(true);
    }

    @Override
    public void onClearContainer() {
    }

    @Override
    public void onClearFlight() {
    }

    @Override
    public void onClearTrackingPoint() {
    }

    @Override
    public void onCreditsClicked(String cognexFirmwareVersion, String cognexBattery, String socketFirmwareVersion, String socketBattery, String fullDecodeVersion, String controlLogicVersion) {
    }

    @Override
    public void onsignOutClicked() {
        if (engineActivity != null) {
            engineActivity.onsignOutClicked();
        } else {
            Preferences.getInstance().setLoginResponse(context, null);
            Preferences.getInstance().setAirportCode(context, null);
            Preferences.getInstance().setAirlineCode(context, null);
            Preferences.getInstance().setTrackingMap(context, null);
            Preferences.getInstance().deleteTrackingLocation(context);
            AlarmHelper.getInstance(context).cancel();
        }
    }

    @Override
    public void onRestartClicked() {
    }

    @Override
    public void onSignoutFailed(String error_message) {
    }
}


