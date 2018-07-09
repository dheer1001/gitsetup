package aero.developer.bagnet.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.support.v7.app.AppCompatActivity;
import android.view.Window;
import android.view.WindowManager;
import android.widget.RelativeLayout;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.CustomViews.DialogTextView;
import aero.developer.bagnet.R;
import aero.developer.bagnet.utils.Preferences;

import static aero.developer.bagnet.scantypes.SoftScannerActivity.isScanning;


public class InternetConnectionStatusDialog {

    private static Dialog dialog = null;
    private static InternetConnectionStatusDialog ourInstance;
    private static Context _context;

    public static InternetConnectionStatusDialog getInstance(Context context) {
        _context = context;
        if(ourInstance==null){
            ourInstance=new InternetConnectionStatusDialog();
        }
        if (dialog==null){
            dialog = new Dialog(_context);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        }


        return ourInstance;
    }

    private InternetConnectionStatusDialog() {
    }
    public void showDialog(boolean isBottom) {
        if (!((AppCompatActivity)_context).isFinishing()) {

            if (dialog != null && !dialog.isShowing() && !isScanning) {
                dialog.setCancelable(false);
                dialog.setContentView(R.layout.internet_connection_status_dialog);
                WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
                Window window = dialog.getWindow();
                if(window!= null) {
                    window.setFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL, WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL);
                    window.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
                    lp.copyFrom(window.getAttributes());
                    lp.width = WindowManager.LayoutParams.MATCH_PARENT;
                    window.setAttributes(lp);
                }
                DialogTextView testing_connection = (DialogTextView) dialog.findViewById(R.id.testing_connection);
                RelativeLayout main_container = (RelativeLayout) dialog.findViewById(R.id.main_container);

                GradientDrawable gradientdrawable = (GradientDrawable)main_container.getBackground();
                gradientdrawable.setColor(AppController.getInstance().getPrimaryGrayColor());
                if(Preferences.getInstance().isNightMode(_context))
                    gradientdrawable.setStroke(4,AppController.getInstance().getPrimaryColor());
                else {
                    gradientdrawable.setStroke(4, AppController.getInstance().getSecondaryGrayColor());
                }
                testing_connection.setTextColor(AppController.getInstance().getSecondaryGrayColor());
                dialog.show();
            }
        }
    }

    public static void hideDialog() {
        if(dialog!=null && dialog.isShowing()){
            dialog.dismiss();
            dialog= null;
        }
    }
    public static void resetDialog(){
        ourInstance = null;
        dialog = null;
    }
    public boolean isShown() {
        return dialog != null && dialog.isShowing();
    }

}
