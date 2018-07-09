package aero.developer.bagnet;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.drawable.GradientDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;

import aero.developer.bagnet.CustomViews.CustomButton;
import aero.developer.bagnet.CustomViews.HeaderTextView;
import aero.developer.bagnet.interfaces.PermissionHandler;
import aero.developer.bagnet.utils.Preferences;

import static android.text.TextUtils.isEmpty;

public class PermissionRequester extends AppCompatActivity {

    private static PermissionHandler callback = null;
    private String permissionToRequest = "";
    public static final String CAMERA = Manifest.permission.CAMERA;
    public static final String STORAGE = Manifest.permission.WRITE_EXTERNAL_STORAGE;
    private final int PERMISSIONS_REQUEST_CODE = 19;
    private final int REQUEST_PERMISSION_SETTING = 40;
    private SharedPreferences preferences;
    private boolean isPermissionShownBefore = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_permission_requester);

        preferences = getSharedPreferences("PERMISSIONS_PREFERENCES", Context.MODE_PRIVATE);

        LinearLayout mainContainer = (LinearLayout) findViewById(R.id.mainContainer);
        CustomButton btnGrant = (CustomButton) findViewById(R.id.btnGrant);
        CustomButton btnDeny = (CustomButton) findViewById(R.id.btnDeny);
        ImageView permissionIconView = (ImageView) findViewById(R.id.permissionIconView);
        HeaderTextView txtPermissionName = (HeaderTextView) findViewById(R.id.permissionName);
        HeaderTextView txtPermissionDescription = (HeaderTextView) findViewById(R.id.permissionDescription);

        if (getIntent() != null && getIntent().getExtras() != null
                && getIntent().getExtras().getString("permissionToRequest") != null
                && !isEmpty(getIntent().getExtras().getString("permissionToRequest"))) {
            permissionToRequest = getIntent().getExtras().getString("permissionToRequest");
        }
        isPermissionShownBefore = preferences.getBoolean(permissionToRequest, false);

        String permissionName = "";
        String permissionDescription = "";
        int permissionIcon;

        if (CAMERA.equalsIgnoreCase(permissionToRequest)) {
            permissionIcon = R.mipmap.ic_camera_icon;
            permissionName = getString(R.string.permission_camera_title);
            if (isPermissionShownBefore) {
                permissionDescription = getString(R.string.permission_camera_denied);
            } else {
                permissionDescription = getString(R.string.permission_camera);
            }
        } else if (STORAGE.equalsIgnoreCase(permissionToRequest)) {
            permissionIcon = R.mipmap.baseline_storage_black_36;
            permissionName = getString(R.string.permission_storage_title);
            permissionDescription = getString(R.string.permission_storage);
        } else {
            //No Permission Defined
            denyAccess();
            return;
        }
        txtPermissionName.setText(permissionName);
        txtPermissionDescription.setText(permissionDescription);
        permissionIconView.setImageResource(permissionIcon);

        btnDeny.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                denyAccess();
            }
        });

        btnGrant.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//                Set this permission is shown before to true
                preferences.edit().putBoolean(permissionToRequest, true).apply();

                if (isPermissionShownBefore && !ActivityCompat.shouldShowRequestPermissionRationale(PermissionRequester.this, permissionToRequest)) {
//                  User Checked Never Ask Again, take him to settings screen
                    Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                    Uri uri = Uri.fromParts("package", getPackageName(), null);
                    intent.setData(uri);
                    startActivityForResult(intent, REQUEST_PERMISSION_SETTING);
                } else {
                    ActivityCompat.requestPermissions(PermissionRequester.this, new String[]{permissionToRequest}, PERMISSIONS_REQUEST_CODE);
                }
            }
        });

        // adjust colors
        boolean isNightMode = Preferences.getInstance().isNightMode(this);
        if (isNightMode) {
            mainContainer.setBackgroundColor(AppController.getInstance().getSecondaryColor());
            txtPermissionName.setTextColor(AppController.getInstance().getPrimaryColor());
            txtPermissionDescription.setTextColor(AppController.getInstance().getPrimaryColor());
            if (permissionIconView.getBackground() != null && permissionIconView.getBackground() instanceof GradientDrawable) {
                GradientDrawable permissionIconView_background = (GradientDrawable) permissionIconView.getBackground();
                permissionIconView_background.setColor(AppController.getInstance().getPrimaryColor());
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    DrawableCompat.setTint(permissionIconView.getDrawable(), AppController.getInstance().getSecondaryColor());
                } else {
                    permissionIconView.setImageDrawable(AppController.getTintedDrawable(permissionIconView.getDrawable(), AppController.getInstance().getSecondaryColor()));
                }
            }
            if (btnGrant.getBackground() != null && btnGrant.getBackground() instanceof GradientDrawable) {
                GradientDrawable btnGrant_background = (GradientDrawable) btnGrant.getBackground();
                btnGrant_background.setColor(AppController.getInstance().getPrimaryColor());
                btnGrant_background.setStroke(1, AppController.getInstance().getPrimaryColor());
                btnGrant.setTextColor(AppController.getInstance().getSecondaryColor());
            }
            if (btnDeny.getBackground() != null && btnDeny.getBackground() instanceof GradientDrawable) {
                GradientDrawable btnDeny_background = (GradientDrawable) btnDeny.getBackground();
                btnDeny_background.setColor(AppController.getInstance().getPrimaryColor());
                btnDeny_background.setStroke(1, AppController.getInstance().getPrimaryColor());
                btnDeny.setTextColor(AppController.getInstance().getSecondaryColor());
            }
        }
    }

    public static void setCallback(PermissionHandler callback) {
        PermissionRequester.callback = callback;
    }

    private void grantAccess() {
        finish();

        if (callback != null) {
            callback.onGranted();
        }
    }

    private void denyAccess() {
            finish();
        if (callback != null) {
            callback.onDenied();
        }
    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
        denyAccess();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        callback = null;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            grantAccess();
        } else {
            denyAccess();
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_PERMISSION_SETTING) {
            if (ContextCompat.checkSelfPermission(PermissionRequester.this, permissionToRequest) == PackageManager.PERMISSION_GRANTED) {
                grantAccess();
            } else {
                denyAccess();
            }
        }
    }
}
