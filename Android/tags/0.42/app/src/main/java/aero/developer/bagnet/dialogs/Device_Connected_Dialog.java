package aero.developer.bagnet.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.view.Window;
import android.view.WindowManager;
import android.widget.RelativeLayout;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.CustomViews.DialogTextView;
import aero.developer.bagnet.CustomViews.HeaderTextView;
import aero.developer.bagnet.R;
import aero.developer.bagnet.scantypes.EngineActivity;
import aero.developer.bagnet.utils.Analytic;
import aero.developer.bagnet.utils.Preferences;

/**
 * Created by user on 8/9/2016.
 */
public class Device_Connected_Dialog {
    private static Dialog dialog = null;
    private static Device_Connected_Dialog ourInstance;
    private static Context _context;

    public static Device_Connected_Dialog getInstance(Context context) {
        _context = context;
        if(ourInstance==null){
            ourInstance=new Device_Connected_Dialog();
        }
        if (dialog==null){
            dialog = new Dialog(_context);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        }


        return ourInstance;

    }

    private Device_Connected_Dialog() {
    }

    public void showDialog(boolean isConnected) {
        try {
            if (dialog!=null && !dialog.isShowing() ) {
                dialog.setCancelable(true);
                dialog.setContentView(R.layout.device_connected_dialog);
                DialogTextView testing_connection = (DialogTextView) dialog.findViewById(R.id.testing_connection);
                RelativeLayout main_container = (RelativeLayout) dialog.findViewById(R.id.main_container);

                GradientDrawable gradientdrawable = (GradientDrawable)main_container.getBackground();
                gradientdrawable.setColor(AppController.getInstance().getPrimaryGrayColor());
                if(Preferences.getInstance().isNightMode(_context)) {
                    gradientdrawable.setStroke(4, AppController.getInstance().getPrimaryColor());
                }
                else {
                    gradientdrawable.setStroke(4, AppController.getInstance().getSecondaryGrayColor());
                }
                testing_connection.setTextColor(AppController.getInstance().getSecondaryGrayColor());

                WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
                HeaderTextView connectionText = (HeaderTextView) dialog.findViewById(R.id.connectionText);
                Window window = dialog.getWindow();
                lp.copyFrom(window.getAttributes());
                lp.width = WindowManager.LayoutParams.MATCH_PARENT;
                connectionText.setText(isConnected ? R.string.connected : R.string.disconnected);
                connectionText.setTextColor(_context.getResources().getColor(isConnected?R.color.white:R.color.disconnected));
                window.setAttributes(lp);
                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP && !((EngineActivity) _context).isDestroyed())
                dialog.show();
            }
        }catch (Exception e){
            dialog = new Dialog(_context);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            dialog.setCancelable(true);
            dialog.setContentView(R.layout.device_connected_dialog);

            DialogTextView testing_connection = (DialogTextView) dialog.findViewById(R.id.testing_connection);
            RelativeLayout main_container = (RelativeLayout) dialog.findViewById(R.id.main_container);

            GradientDrawable gradientdrawable = (GradientDrawable)main_container.getBackground();
            gradientdrawable.setColor(AppController.getInstance().getPrimaryGrayColor());
            if(Preferences.getInstance().isNightMode(_context)) {
                gradientdrawable.setStroke(1, AppController.getInstance().getPrimaryColor());
            }
            else {
                gradientdrawable.setStroke(1, AppController.getInstance().getSecondaryGrayColor());
            }
            testing_connection.setTextColor(AppController.getInstance().getSecondaryGrayColor());


            WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
            HeaderTextView connectionText = (HeaderTextView) dialog.findViewById(R.id.connectionText);
            Window window = dialog.getWindow();
            lp.copyFrom(window.getAttributes());
            lp.width = WindowManager.LayoutParams.MATCH_PARENT;
            connectionText.setText(isConnected ? R.string.connected : R.string.disconnected);
            if(!isConnected){
                Analytic.getInstance().sendScreen(R.string.EVENT_DEVICE_DISCONNECTED_SCREEN);
            }
            connectionText.setTextColor(_context.getResources().getColor(isConnected?R.color.white:R.color.disconnected));
            window.setAttributes(lp);
            dialog.show();
        }

    }

    public static void hideDialog() {
        if(dialog!=null && dialog.isShowing()){
            dialog.dismiss();
            dialog = null;
        }
    }
    public static void resetDialog(){
        ourInstance = null;
        dialog = null;
    }

}
