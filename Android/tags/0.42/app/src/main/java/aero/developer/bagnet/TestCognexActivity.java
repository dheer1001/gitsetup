package aero.developer.bagnet;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.drawable.GradientDrawable;
import android.hardware.usb.UsbAccessory;
import android.hardware.usb.UsbDevice;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.cognex.dataman.sdk.discovery.UsbDiscoverer;

import java.util.HashMap;

import aero.developer.bagnet.CustomViews.HeaderTextView;
import aero.developer.bagnet.dialogs.Cognex_Reset_Barcode_Dialog;
import aero.developer.bagnet.dialogs.Cognex_Setup_Barcode_Dialog;
import aero.developer.bagnet.interfaces.Cognex_Setup_Reset_Interface;
import aero.developer.bagnet.scantypes.CognexScanActivity;
import aero.developer.bagnet.utils.BagLogger;
import aero.developer.bagnet.utils.Preferences;

public class TestCognexActivity extends AppCompatActivity implements Cognex_Setup_Reset_Interface {
    ImageView img_scanner,img_couldnot_connect;
    com.wang.avi.AVLoadingIndicatorView progress;
    Cognex_Reset_Barcode_Dialog reset_fragment;
    Cognex_Setup_Barcode_Dialog setup_fragment;
    Button btn_setup, btn_reset, btn_cancel;
    RelativeLayout main_container;
    HeaderTextView connecting_scanner;
    LinearLayout lowerConatiner;
    Boolean scannerConnected=false;
    private static Cognex_Setup_Reset_Interface cognex_setup_reset_interface;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test_cognex);

        img_scanner = (ImageView) findViewById(R.id.img_scanner);
        img_couldnot_connect = (ImageView) findViewById(R.id.img_couldnot_connect);
        connecting_scanner = (HeaderTextView) findViewById(R.id.connecting_scanner);
        progress = (com.wang.avi.AVLoadingIndicatorView) findViewById(R.id.Progress);
        main_container = (RelativeLayout) findViewById(R.id.main_container);
        lowerConatiner = (LinearLayout) findViewById(R.id.lowerConatiner);
        btn_setup = (Button) findViewById(R.id.btn_setup);
        btn_reset = (Button) findViewById(R.id.btn_reset);
        btn_cancel = (Button) findViewById(R.id.btn_cancel);

        cognex_setup_reset_interface = this;
        btn_setup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(cognex_setup_reset_interface!=null){
                    cognex_setup_reset_interface.OpenSetupDialog();
                }
            }
        });

        btn_reset.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(cognex_setup_reset_interface!=null){
                    cognex_setup_reset_interface.OpenResetDialog();
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

    @Override
    protected void onResume() {
        super.onResume();

        HashMap<String, UsbDevice> usbDevices = UsbDiscoverer.getDataManDevices(this);
        UsbAccessory[] accessories = UsbDiscoverer.getDataManAccessories(this);
        BagLogger.log("Sizes "+usbDevices.size()+"   "+accessories.length);
        if (usbDevices.size() > 0) {
            scannerConnected = true;
            progress.setVisibility(View.GONE);
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                DrawableCompat.setTint(img_scanner.getDrawable(),getResources().getColor(R.color.connected));
            }else{
                img_scanner.setImageDrawable(AppController.getTintedDrawable(img_scanner.getDrawable(),getResources().getColor(R.color.connected)));
            }
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    startActivity(new Intent(TestCognexActivity.this,CognexScanActivity.class));
                    finish();
                }
            },1000);



        } else if (accessories.length > 0) {
            scannerConnected = true;
            progress.setVisibility(View.GONE);
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                DrawableCompat.setTint(img_scanner.getDrawable(),getResources().getColor(R.color.connected));
            }else{
                img_scanner.setImageDrawable(AppController.getTintedDrawable(img_scanner.getDrawable(),getResources().getColor(R.color.connected)));
            }

            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    startActivity(new Intent(TestCognexActivity.this,CognexScanActivity.class));
                    finish();
                }
            },1000);
        } else {
            scannerConnectionError();
        }
        adjustColors();

    }



    @Override
    public void OpenResetDialog() {
        FragmentManager fm = getSupportFragmentManager();
        if (reset_fragment == null) {
            reset_fragment = Cognex_Reset_Barcode_Dialog.getInstance();
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
            setup_fragment = Cognex_Setup_Barcode_Dialog.getInstance(cognex_setup_reset_interface);
            setup_fragment.setStyle(DialogFragment.STYLE_NORMAL, R.style.Dialog_FullScreen);
        }
        if (setup_fragment != null && !setup_fragment.isAdded()) {
            setup_fragment.show(fm, "setup_barcode");
        }
    }



    @Override
    public void onBackPressed() {
        super.onBackPressed();
        Preferences.getInstance().setTrackingMap(getApplicationContext(),null);
        Intent back=new Intent(this,LoginActivity.class);
        startActivity(back);
    }

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
    }

    private void ScannerConnected(){
        progress.setVisibility(View.GONE);
        lowerConatiner.setVisibility(View.GONE);
        connecting_scanner.setText(getResources().getString(R.string.connecting_to_scanner));
        img_couldnot_connect.setVisibility(View.GONE);
    }
    private void adjustColors() {
        main_container.setBackgroundColor(AppController.getInstance().getSecondaryColor());
        connecting_scanner.setTextColor(AppController.getInstance().getPrimaryColor());
        btn_cancel.setTextColor(AppController.getInstance().getPrimaryColor());

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            if(!scannerConnected) {
                DrawableCompat.setTint(img_scanner.getDrawable(), AppController.getInstance().getPrimaryColor());
            }
            DrawableCompat.setTint(img_couldnot_connect.getDrawable(), AppController.getInstance().getPrimaryOrangeColor());
        }else{
            if(!scannerConnected) {
                img_scanner.setImageDrawable(AppController.getTintedDrawable(img_scanner.getDrawable(), AppController.getInstance().getPrimaryColor()));
            }
            img_couldnot_connect.setImageDrawable(AppController.getTintedDrawable(img_couldnot_connect.getDrawable(),AppController.getInstance().getPrimaryOrangeColor()));
        }
        if(scannerConnected){
            ScannerConnected();
        }
        GradientDrawable btn_cancel_drawable = (GradientDrawable)btn_cancel.getBackground();
        btn_cancel_drawable.setStroke(1,AppController.getInstance().getSecondaryGrayColor());
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

    }
    @SuppressLint("MissingSuperCall")
    @Override
    protected void onSaveInstanceState(Bundle outState) {
    }

}
