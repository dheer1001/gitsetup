package aero.developer.bagnet.dialogs;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.os.Handler;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.scantypes.EngineActivity;
import aero.developer.bagnet.utils.Preferences;

import static aero.developer.bagnet.LoginActivity.loginActivity;

/**
 * Created by User on 12-Oct-17.
 */

public class ApiResponseDialog extends DialogFragment {
    @SuppressLint("StaticFieldLeak")
    public static ApiResponseDialog instance;
    @SuppressLint("StaticFieldLeak")
    private static Context activity;
    private static Dialog dialog = null;
    Handler handler = new Handler();
    Runnable hideDialogRunnable;
    private ChangepasswordFragment changePasswordInstance = null;

    public ApiResponseDialog() {}


    public static ApiResponseDialog getInstance() {
        if(EngineActivity.engineActivity == null) {
            activity = loginActivity;
        }else {
            activity = EngineActivity.engineActivity;
        }
            instance=new ApiResponseDialog();
            dialog=new Dialog(activity,R.style.DialogTheme);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        return instance;
    }

    public void showDialog(String message, boolean isSuccess, boolean iscancelable, boolean showimage, long displayTime, boolean keepDialog) {
            try {
                dialog.setCancelable(iscancelable);
                dialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
                    @Override
                    public void onDismiss(DialogInterface dialogInterface) {
                        if(changePasswordInstance != null) {
                            changePasswordInstance.closeAndDismiss();
                        }
                        hideDialog();
                    }
                });
                hideDialogRunnable = new Runnable() {
                    @Override
                    public void run() {
                        hideDialog();
                    }
                };


                dialog.setContentView(R.layout.api_response_dialog);
                TextView txt_message = dialog.findViewById(R.id.txt_message);
                ImageView image = dialog.findViewById(R.id.image);
                RelativeLayout main_container = dialog.findViewById(R.id.main_container);

                if(showimage){
                    image.setVisibility(View.VISIBLE);
                }else {
                    image.setVisibility(View.GONE);
                }

                txt_message.setText(message);

                if (isSuccess)
                    txt_message.setTextColor(activity.getResources().getColor(R.color.connected));
                else
                    txt_message.setTextColor(activity.getResources().getColor(R.color.disconnected));

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    DrawableCompat.setTint(image.getDrawable(), AppController.getInstance().getPrimaryColor());
                } else {
                    image.setImageDrawable(AppController.getTintedDrawable(image.getDrawable(), AppController.getInstance().getPrimaryColor()));
                }

                //adjust colors
                GradientDrawable gradientdrawable = (GradientDrawable) main_container.getBackground();
                gradientdrawable.setColor(AppController.getInstance().getPrimaryGrayColor());

                if (Preferences.getInstance().isNightMode(activity)) {
                    gradientdrawable.setStroke(4, AppController.getInstance().getPrimaryColor());

                } else {
                    gradientdrawable.setStroke(4, AppController.getInstance().getSecondaryGrayColor());
                }

                WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
                Window window = dialog.getWindow();
                if (window != null) {
                    lp.copyFrom(window.getAttributes());
                    lp.width = WindowManager.LayoutParams.MATCH_PARENT;
                    lp.gravity = Gravity.CENTER_VERTICAL;
                    window.setAttributes(lp);
                }
                dialog.show();

                if (!keepDialog) {
                    handler.postDelayed(hideDialogRunnable, displayTime);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
    }

    public void hideDialog() {
        try {
            if (!((Activity) activity).isFinishing() && dialog != null && dialog.isShowing()) {
                dialog.dismiss();
            }
            dialog = null;
            instance = null;
            activity = null;
            handler.removeCallbacks(hideDialogRunnable);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    public static void resetDialog() {
            dialog = null;
            instance = null;
            activity = null;
    }

    public boolean isShown(){
        boolean shown=false;
        if(dialog!=null && dialog.isShowing()){
            shown=true;
        }
        return shown;
    }

    public void setChangePasswordInstance(ChangepasswordFragment changePasswordInstance) {
        this.changePasswordInstance = changePasswordInstance;
    }
}
