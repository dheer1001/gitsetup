package aero.developer.bagnet;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;

import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.security.ProviderInstaller;

import aero.developer.bagnet.scantypes.HoneyWellScanner_Activity;
import aero.developer.bagnet.scantypes.SoftScannerActivity;
import aero.developer.bagnet.socketmobile.TestSocketScannerActivity;
import aero.developer.bagnet.utils.Preferences;

public class ProxyActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        updateAndroidSecurityProvider(this);
        if (Preferences.getInstance().getLoginResponse(getApplicationContext()) == null) {
             Intent intent = new Intent(ProxyActivity.this, LoginActivity.class);
             intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
             startActivity(intent);
             finish();
            } else {
                    if (Preferences.getInstance().getScannerType(getApplicationContext()).equalsIgnoreCase(getResources().getString(R.string.socket_mobile_bt))) {
                        Intent intent = new Intent(getApplicationContext(), TestSocketScannerActivity.class);
                        startActivity(intent);
                        finish();
                    } else if (Preferences.getInstance().getScannerType(getApplicationContext()).equalsIgnoreCase(getResources().getString(R.string.cognex_scanner))) {
                        Intent intent = new Intent(getApplicationContext(), TestCognexActivity.class);
                        startActivity(intent);
                        ActivityCompat.finishAffinity(this);
                    } else if(Preferences.getInstance().getScannerType(getApplicationContext()).equalsIgnoreCase(getResources().getString(R.string.soft_scan))) {
                        Intent intent = new Intent(getApplicationContext(), SoftScannerActivity.class);
                        startActivity(intent);
                        finish();
                    }else if(Preferences.getInstance().getScannerType(getApplicationContext()).equalsIgnoreCase(getResources().getString(R.string.honeywell_ct50_scanner))) {
                        Intent intent = new Intent(getApplicationContext(), HoneyWellScanner_Activity.class);
                        startActivity(intent);
                        finish();
                    }
            }

        }
    private void updateAndroidSecurityProvider(Activity callingActivity) {
        try {
            ProviderInstaller.installIfNeeded(this);
        } catch (GooglePlayServicesRepairableException e) {
            // Thrown when Google Play Services is not installed, up-to-date, or enabled
            // Show dialog to allow users to install, update, or otherwise enable Google Play services.
            GooglePlayServicesUtil.getErrorDialog(e.getConnectionStatusCode(), callingActivity, 0);
        } catch (GooglePlayServicesNotAvailableException e) {
//            Log.e("SecurityException", "Google Play Services not available.");
        }
    }


    }
