package aero.developer.bagnet.dialogs;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.LoginActivity;
import aero.developer.bagnet.R;
import aero.developer.bagnet.utils.Preferences;

public class PasswordWarningDialog extends DialogFragment {

    @SuppressLint("StaticFieldLeak")
    public static PasswordWarningDialog instance;
    private static Dialog dialog = null;
    @SuppressLint("StaticFieldLeak")
    private static Context _context;
    Button changePasswordNow, later;

    public static PasswordWarningDialog getInstance(Context context) {
        _context = context;
        if (instance == null) {
            instance = new PasswordWarningDialog();
        }
        if (dialog == null) {
            dialog = new Dialog(_context, R.style.DialogTheme);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        }
        return instance;
    }

    @SuppressLint("StringFormatInvalid")
    public void showDialog(int dayDiff, final LoginActivity activity) {
        try {
            if (!((AppCompatActivity) _context).isFinishing()) {
                dialog.setCancelable(false);
                dialog.setContentView(R.layout.password_warning_dialog);
                dialog.setCancelable(false);
                RelativeLayout main_container = (RelativeLayout) dialog.findViewById(R.id.main_container);
                ImageView img_info = (ImageView) dialog.findViewById(R.id.img_info);
                TextView txt_details = (TextView) dialog.findViewById(R.id.txt_details);
                TextView txt_title = (TextView) dialog.findViewById(R.id.txt_title);
                later = (Button) dialog.findViewById(R.id.later);
                changePasswordNow = (Button) dialog.findViewById(R.id.changePasswordNow);

                if (dayDiff <= 0) {
                    txt_details.setText(_context.getResources().getString(R.string.passwordExpiryMessage, _context.getResources().getString(R.string.today)));
                } else if (dayDiff == 1) {
                    txt_details.setText(_context.getResources().getString(R.string.passwordExpiryMessage, _context.getResources().getString(R.string.tomorrow)));
                } else {
                    txt_details.setText(_context.getResources().getString(R.string.passwordExpiryMessage, " in " + String.valueOf(dayDiff) + " days"));
                }

                later.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (dialog != null) {
                            hideDialog();
                            activity.setupAirportAirlineDialogs();
                        }
                    }
                });
                changePasswordNow.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        FragmentManager fragmentManager = activity.getSupportFragmentManager();
                        FragmentTransaction ft = fragmentManager.beginTransaction();
                        ChangepasswordFragment changepasswordFragment = new ChangepasswordFragment();
                        if (!changepasswordFragment.isAdded()) {
                            hideDialog();
                            Bundle bundle = new Bundle();
                            bundle.putBoolean("showSubtitle",true);
                            changepasswordFragment.setArguments(bundle);
                            changepasswordFragment.show(ft, "changepasswordFragment");
                        }
                    }
                });
                //adjust colors
                if (Preferences.getInstance().isNightMode(_context)) {
                    main_container.setBackground(activity.getResources().getDrawable(R.drawable.night_dialog_background));
                    changePasswordNow.setBackground(activity.getResources().getDrawable(R.drawable.btn_dark_gray_background));
                } else {
                    main_container.setBackground(activity.getResources().getDrawable(R.drawable.connection_box));
                    changePasswordNow.setBackground(activity.getResources().getDrawable(R.drawable.btn_gray_background));
                }
                txt_title.setTextColor(AppController.getInstance().getPrimaryColor());
                txt_details.setTextColor(AppController.getInstance().getPrimaryColor());

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    DrawableCompat.setTint(img_info.getDrawable(), AppController.getInstance().getPrimaryColor());
                } else {
                    img_info.setImageDrawable(AppController.getTintedDrawable(img_info.getDrawable(), AppController.getInstance().getPrimaryColor()));
                }


                later.setTextColor(AppController.getInstance().getPrimaryColor());
                GradientDrawable later_drawable = (GradientDrawable) later.getBackground();
                later_drawable.setStroke(1, AppController.getInstance().getSecondaryGrayColor());

                WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
                Window window = dialog.getWindow();
                if (window != null) {
                    lp.copyFrom(window.getAttributes());
                    lp.width = WindowManager.LayoutParams.MATCH_PARENT;
                    lp.gravity = Gravity.CENTER_VERTICAL;
                    window.setAttributes(lp);
                }
                dialog.show();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void hideDialog() {
        if (dialog != null && dialog.isShowing()) {
            dialog.dismiss();
        }
        dialog = null;
        instance = null;
    }
}
