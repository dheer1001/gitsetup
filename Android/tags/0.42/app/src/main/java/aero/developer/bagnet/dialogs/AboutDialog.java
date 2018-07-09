package aero.developer.bagnet.dialogs;


import android.app.Activity;
import android.app.Dialog;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.DialogFragment;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.WindowManager;

import aero.developer.bagnet.CustomViews.ScrollableTextView;
import aero.developer.bagnet.R;
import aero.developer.bagnet.objects.BlurBuilder;
import aero.developer.bagnet.scantypes.CognexScanActivity;
import aero.developer.bagnet.scantypes.HoneyWellScanner_Activity;
import aero.developer.bagnet.scantypes.SocketMobileScanActivity;

public class AboutDialog extends DialogFragment {

    private static AboutDialog mInstance = null;
    private boolean dismissSettingsDialog;

    public static AboutDialog getInstance() {
        if (mInstance == null) {
            mInstance = new AboutDialog();
        }
        return mInstance;
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        return new Dialog(getActivity(), getTheme()){
            @Override
            public void onBackPressed() {
                dismissSettingsDialog = false;
                dismissDialog();
            }
        };
    }

    public View onCreateView(final LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        if(getDialog() != null && getDialog().getWindow() != null) {
            getDialog().getWindow().addFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);
            getDialog().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        }
        final View layout = inflater.inflate(R.layout.about_dialog, container, false);
        final Activity activity = getActivity();
        final View content = activity.findViewById(android.R.id.content).getRootView();
        if (content.getWidth() > 0) {
            Bitmap image = BlurBuilder.blur(content);
            getDialog().getWindow().setBackgroundDrawable(new BitmapDrawable(activity.getResources(), image));
        } else {
            content.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
                @Override
                public void onGlobalLayout() {
                    Bitmap image = BlurBuilder.blur(content);
                    getDialog().getWindow().setBackgroundDrawable(new BitmapDrawable(activity.getResources(), image));
                }
            });
        }
        setHasOptionsMenu(true);
        return layout;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        view.findViewById(R.id.blockBtn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismissSettingsDialog = false;
                dismissDialog();
            }
        });

        final ScrollableTextView marquee = (ScrollableTextView) view.findViewById(R.id.marquee);

        PackageManager manager = getContext().getPackageManager();
        PackageInfo info = null;
        try {
            info = manager.getPackageInfo(getContext().getPackageName(), 0);
            Activity activity = getActivity();

            if(activity instanceof CognexScanActivity) {
                String cognexFirmwareVersion = getArguments().getString("cognexFirmwareVersion");
                String cognexBatteryLevel = getArguments().getString("cognexBatteryLevel");

                marquee.setText(getContext().getString(R.string.creditsText,info.versionName+"("+info.versionCode+")" ,
                        "\nCOGNEX firmware v"+ cognexFirmwareVersion, "\nBattery charge : " + cognexBatteryLevel + "%" ) );
            }
            else if(activity instanceof SocketMobileScanActivity) {
                String socketFirmware = getArguments().getString("socketFirmwareVersion");
                String socketBattery = getArguments().getString("socketBattery");

                marquee.setText(getContext().getString(R.string.creditsText,info.versionName+"("+info.versionCode+")" ,
                        "\nSocketMobile firmware v"+ socketFirmware, "\nBattery charge : " + socketBattery + "%" ) );

            } else if(activity instanceof HoneyWellScanner_Activity) {
                String fullDecodeVersion = getArguments().getString("fullDecodeVersion");
                String controlLogicVersion = getArguments().getString("controlLogicVersion");
                String device_battery = getArguments().getString("device_battery");

                marquee.setText(getContext().getString(R.string.creditsText,info.versionName+"("+info.versionCode+")" ,
                        "\n"+ fullDecodeVersion, controlLogicVersion + "Battery charge : "+ device_battery + "%") );
            }
            else {
                marquee.setText(getContext().getString(R.string.creditsText,info.versionName+"("+info.versionCode+")" ,"" , "" ) );
            }
            marquee.setVisibility(View.INVISIBLE);

            view.postDelayed(new Runnable() {
                @Override
                public void run() {
                    DisplayMetrics displaymetrics = getResources().getDisplayMetrics();

                    marquee.getTextView().scrollTo(0,-(displaymetrics.heightPixels));
                    marquee.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            marquee.setVisibility(View.VISIBLE);
                            marquee.startMarquee();
                        }
                    },50);
                }
            },150);


        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

    }


    public void dismissDialog() {
        dismiss();
    }

    @Override
    public void onResume() {
        super.onResume();
        dismissSettingsDialog = true;

    }

    @Override
    public void onPause() {
        super.onPause();
        dismissDialog();
        if(dismissSettingsDialog) {
            if (SettingsDialog.getInstance() != null)
                SettingsDialog.getInstance().dismiss();
        }
    }
}
