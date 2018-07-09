package aero.developer.bagnet.permissions;

import android.content.DialogInterface;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Build;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.PermissionChecker;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;

import java.util.ArrayList;
import java.util.List;

import aero.developer.bagnet.R;

public abstract class PermissionActivity extends AppCompatActivity implements OnPermissionListener {
    public static final int REQUEST_CODE_ASK_MULTIPLE_PERMISSIONS = 1;

    public static final String LOCATION_PERMISSION = "android.permission.ACCESS_FINE_LOCATION";
    public static final String READ_CALENDAR = "android.permission.READ_CALENDAR";
    public static final String WRITE_CALENDAR = "android.permission.WRITE_CALENDAR";
    public static final String CAMERA = "android.permission.CAMERA";
    public static final String READ_CONTACTS = "android.permission.READ_CONTACTS";
    public static final String WRITE_CONTACTS = "android.permission.WRITE_CONTACTS";
    public static final String GET_ACCOUNTS = "android.permission.GET_ACCOUNTS";
    public static final String COARSE_LOCATION = "android.permission.ACCESS_COARSE_LOCATION";
    public static final String RECORD_AUDIO = "android.permission.RECORD_AUDIO";
    public static final String READ_PHONE_STATE = "android.permission.READ_PHONE_STATE";
    public static final String CALL_PHONE = "android.permission.CALL_PHONE";
    public static final String READ_CALL_LOG = "android.permission.READ_CALL_LOG";
    public static final String WRITE_CALL_LOG = "android.permission.WRITE_CALL_LOG";
    public static final String USE_SIP = "android.permission.USE_SIP";
    public static final String PROCESS_OUTGOING_CALL = "android.permission.PROCESS_OUTGOING_CALLS";
    public static final String BODY_SENSOR = "android.permission.BODY_SENSORS";
    public static final String SEND_SMS = "android.permission.SEND_SMS";
    public static final String RECIEVE_SMS = "android.permission.RECEIVE_SMS";
    public static final String READ_SMS = "android.permission.READ_SMS";
    public static final String RECEIVE_WAP_PUSH = "android.permission.RECEIVE_WAP_PUSH";
    public static final String RECEIVE_MMS = "android.permission.RECEIVE_MMS";
    public static final String READ_EXTERNAL_STORAGE = "android.permission.READ_EXTERNAL_STORAGE";
    public static final String WRITE_EXTERNAL_STORAGE = "android.permission.WRITE_EXTERNAL_STORAGE";

    int targetSdkVersion;

    public void checkPermission(List<String> permissionsList) {


        List<String> notGrantedPermissions = new ArrayList<>();

        for (String permission : permissionsList) {
            if (!isPermissionGranted(permission)) {
                notGrantedPermissions.add(permission);
            }
        }
        if (notGrantedPermissions.size() > 0) {
            ActivityCompat.requestPermissions(this, notGrantedPermissions.toArray(new String[notGrantedPermissions.size()]),
                    REQUEST_CODE_ASK_MULTIPLE_PERMISSIONS);
            return;
        }
        permissionGranted();
    }


    public boolean isPermissionGranted(String permission) {
        // For Android < Android M, self permissions are always granted.
        boolean result = true;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {

            if (targetSdkVersion >= Build.VERSION_CODES.M) {
                // targetSdkVersion >= Android M, we can
                // use Context#checkSelfPermission
                result = checkSelfPermission(permission) == PackageManager.PERMISSION_GRANTED;
            } else {
                // targetSdkVersion < Android M, we have to use PermissionChecker
                result = PermissionChecker.checkSelfPermission(this, permission) == PermissionChecker.PERMISSION_GRANTED;
            }
        }

        return result;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        switch (requestCode) {
            case REQUEST_CODE_ASK_MULTIPLE_PERMISSIONS: {
                boolean allGranted = true;
                for (int grantResult : grantResults) {
                    if (grantResult == PackageManager.PERMISSION_DENIED) {
                     showDeniedPermissionDialog();
                        permissionDenied();
                        allGranted = false;
                        break;
                    }
                }

                if (allGranted) {
                    permissionGranted();
                }
            }
            break;
            default:
                super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }

    @Override
    public void permissionGranted() {

    }

    @Override
    public void permissionDenied() {

    }
    public void showDeniedPermissionDialog(){
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        alertDialogBuilder.setMessage(getResources().getString(R.string.some_permission_denied));
        alertDialogBuilder.setNegativeButton(getResources().getString(android.R.string.ok),new DialogInterface.OnClickListener() {
           @ Override
            public void onClick(DialogInterface dialog, int which) {
               dialog.dismiss();

            }
        });
        AlertDialog alertDialog = alertDialogBuilder.create();
        alertDialog.show();
        alertDialog.getButton(alertDialog.BUTTON_NEGATIVE).setTextColor(Color.BLUE);
    }

}


interface OnPermissionListener {
    public void permissionGranted();

    public void permissionDenied();
}
