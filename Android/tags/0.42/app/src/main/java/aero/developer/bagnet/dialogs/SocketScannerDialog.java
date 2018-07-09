package aero.developer.bagnet.dialogs;

/*
1)Goal of this activity:
Socket Scanner Dialog is used to Read Scanned Barcodes and process the "Bag Journey Netscan Overflow"

2)
 */

import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.RelativeLayout;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.CustomViews.DialogTextView;
import aero.developer.bagnet.R;
import aero.developer.bagnet.utils.Preferences;

public class SocketScannerDialog {
    private static Dialog dialog;
    private static Context _context;
    private static Reset_Setup_Interface interface_setup_reset;

    private static SocketScannerDialog ourInstance = new SocketScannerDialog();

    public static SocketScannerDialog getInstance(Context context,Reset_Setup_Interface Reset_Setup_interface) {
        _context = context;
        interface_setup_reset=Reset_Setup_interface;

        if (ourInstance == null) {
            ourInstance = new SocketScannerDialog();
        }
        if (dialog == null) {
            dialog = new Dialog(_context);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        }
        return ourInstance;
    }

    private SocketScannerDialog() {

    }
    public void showDialog(){
        if (!((AppCompatActivity)_context).isFinishing()) {
            dialog.setContentView(R.layout.error_dialog);

            dialog.setTitle(null);
            dialog.setCancelable(true);
            WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
            Window window = dialog.getWindow();
            lp.copyFrom(window.getAttributes());
            lp.width = WindowManager.LayoutParams.WRAP_CONTENT;
            lp.height=WindowManager.LayoutParams.WRAP_CONTENT;
            window.setAttributes(lp);
            if (!((AppCompatActivity)_context).isFinishing())
            dialog.show();
            DialogTextView testing_connection = (DialogTextView) dialog.findViewById(R.id.testing_connection);
            RelativeLayout main_container = (RelativeLayout) dialog.findViewById(R.id.main_container);
            Button SetUp=(Button) dialog.findViewById(R.id.btn_setup);
            Button Reset=(Button) dialog.findViewById(R.id.reset_btn);

            GradientDrawable gradientdrawable = (GradientDrawable)main_container.getBackground();
            gradientdrawable.setColor(AppController.getInstance().getprimaryBackroundViewColor());
            if(Preferences.getInstance().isNightMode(_context)) {
                SetUp.setBackground(_context.getResources().getDrawable(R.drawable.btn_dark_gray_background));
                Reset.setBackground(_context.getResources().getDrawable(R.drawable.btn_dark_gray_background));

                gradientdrawable.setStroke(4, AppController.getInstance().getPrimaryColor());
                SetUp.setTextColor(AppController.getInstance().getPrimaryGrayColor());
                Reset.setTextColor(AppController.getInstance().getPrimaryGrayColor());
                testing_connection.setTextColor(AppController.getInstance().getPrimaryGrayColor());

            }
            else
            {
                gradientdrawable.setStroke(4, AppController.getInstance().getSecondaryGrayColor());
                Reset.setBackground(_context.getResources().getDrawable(R.drawable.btn_gray_background));
                SetUp.setBackground(_context.getResources().getDrawable(R.drawable.btn_gray_background));
                SetUp.setTextColor(AppController.getInstance().getPrimaryColor());
                Reset.setTextColor(AppController.getInstance().getPrimaryColor());
                testing_connection.setTextColor(AppController.getInstance().getSecondaryGrayColor());
            }



            SetUp.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    dialog.dismiss();
                    // recall connection
                    if(interface_setup_reset!=null){
                        interface_setup_reset.OpenSetupDialog();
                    }
                }
            });
            Reset.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                   if(interface_setup_reset!=null){
                       interface_setup_reset.OpenResetDialog();
                   }
                }
            });
        }
    }

    public boolean isDialogShown(){
        boolean shown=false;
        if(dialog!=null && dialog.isShowing()){
            shown=true;
        }
        return shown;

    }

    public static void resetDialog(){
        ourInstance = null;
        dialog = null;
    }

}
