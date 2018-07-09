package aero.developer.bagnet.dialogs;

import android.app.Dialog;
import android.app.DialogFragment;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.os.CountDownTimer;
import android.os.Handler;
import android.support.annotation.RequiresApi;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import java.util.Date;
import java.util.concurrent.TimeUnit;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.Constants;
import aero.developer.bagnet.CustomViews.DialogTextView;
import aero.developer.bagnet.CustomViews.DigitalTextView;
import aero.developer.bagnet.CustomViews.HeaderTextView;
import aero.developer.bagnet.R;
import aero.developer.bagnet.scantypes.EngineActivity;
import aero.developer.bagnet.utils.Location_Utils;
import aero.developer.bagnet.utils.Preferences;

/**
 * Created by user on 8/9/2016.
 */
public class LocationSuccessDialog extends DialogFragment {
    private static LocationSuccessDialog ourInstance;
    private static Dialog dialog = null;
    private static Context _context;
    private CountDownTimer countDownTimer = null;
    private Runnable hideDialogRunnable;
    Handler handler = new Handler();

    public void setOnDismissListener(DialogInterface.OnDismissListener onDismissListener) {
        this.onDismissListener = onDismissListener;
    }

    private DialogInterface.OnDismissListener onDismissListener;

    public static LocationSuccessDialog getInstance() {
        _context = EngineActivity.engineActivity;
        if(ourInstance==null){
            ourInstance=new LocationSuccessDialog();
        }
        if (dialog==null){
            if(_context!= null) {
                dialog = new Dialog(_context);
                dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            }
        }
        return ourInstance;
    }

    DigitalTextView timerText;
    HeaderTextView Txtgate;
    RelativeLayout main_container;
    DialogTextView location_identified,timeout;
    ImageView my_location;

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
    public void showDialog(boolean isBottom) {
        if (!((AppCompatActivity)_context).isFinishing()) {
            try {
            dialog.setCancelable(false);
            dialog.setOnDismissListener(this.onDismissListener);
            dialog.setContentView(R.layout.location_success_dialog);
            main_container = (RelativeLayout) dialog.findViewById(R.id.main_container);
            location_identified = (DialogTextView) dialog.findViewById(R.id.location_identified);
            timeout = (DialogTextView) dialog.findViewById(R.id.timeout);
            my_location = (ImageView) dialog.findViewById(R.id.my_location);
            timerText = (DigitalTextView) dialog.findViewById(R.id.time);
            Txtgate = (HeaderTextView) dialog.findViewById(R.id.Txtgate);

            //adjust Colors
            GradientDrawable gradientdrawable = (GradientDrawable) main_container.getBackground();
            gradientdrawable.setColor(AppController.getInstance().getPrimaryGrayColor());

            if (Preferences.getInstance().isNightMode(_context)) {
                gradientdrawable.setStroke(4, AppController.getInstance().getPrimaryColor());

            } else {
                gradientdrawable.setStroke(4, AppController.getInstance().getSecondaryGrayColor());


            }
            Txtgate.setTextColor(AppController.getInstance().getPrimaryColor());
                timerText.setTextColor(AppController.getInstance().getPrimaryOrangeColor());

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                if (my_location.getDrawable() != null)
                    DrawableCompat.setTint(my_location.getDrawable(), AppController.getInstance().getSecondaryGrayColor());
            } else {
                my_location.setImageDrawable(AppController.getTintedDrawable(my_location.getDrawable(), AppController.getInstance().getSecondaryGrayColor()));

            }
            location_identified.setTextColor(AppController.getInstance().getSecondaryGrayColor());
            timeout.setTextColor(AppController.getInstance().getSecondaryGrayColor());

            WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
            Window window = dialog.getWindow();
            if(window != null) {
                lp.copyFrom(window.getAttributes());
                lp.width = WindowManager.LayoutParams.MATCH_PARENT;
                if(!((AppCompatActivity)_context).isFinishing() && !((AppCompatActivity)_context).isDestroyed())
                window.setAttributes(lp);
                dialog.show();

                hideDialogRunnable = new Runnable() {
                    @Override
                    public void run() {
                        hideDialog();
                    }
                };

                handler.postDelayed(hideDialogRunnable, Constants.ResponseDialogExpireTime);
                setData();
            }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
    }

    public void hideDialog() {
        if(dialog!=null && dialog.isShowing()){
            dialog.dismiss();

        }
        if (countDownTimer != null) {
            countDownTimer.cancel();
            countDownTimer = null;
        }
        ourInstance = null;
        dialog = null;
        _context=null;
        handler.removeCallbacks(hideDialogRunnable);
    }

    private void setData() {
        long startedTrackingTime = Preferences.getInstance().getStartTrackingTime(_context);
        String trackingLocation = Preferences.getInstance().getTrackingLocation(_context);
        Txtgate.setText(Location_Utils.getTrackingLocation(trackingLocation,true));
        if (startedTrackingTime > 0) {
            Date currentDate = new Date();

            if ((startedTrackingTime + Constants.TrackingLocationExpireTime) > currentDate.getTime()) {
                long timeLeft = (startedTrackingTime + Constants.TrackingLocationExpireTime) - currentDate.getTime();
                generateTimer(timeLeft);
            }
        }
    }

    private void generateTimer(long timeLeft) {
        if (countDownTimer!=null){
            countDownTimer.cancel();
        }
        countDownTimer = new CountDownTimer(timeLeft, 1000) {
            public void onTick(long millisUntilFinished) {
                timerText.setText(formatTimeLeft(millisUntilFinished));
            }

            public void onFinish() {
                hideDialog();
            }
        };
        countDownTimer.start();
    }

    private String formatTimeLeft(long millis) {

        long mintues = TimeUnit.MILLISECONDS.toMinutes(millis);
        long seconds = TimeUnit.MILLISECONDS.toSeconds(millis) -
                TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(millis));

        return String.format("%s:%s",
                ("00" + Long.toString(mintues)).substring(Long.toString(mintues).length()),
                ("00" + Long.toString(seconds)).substring(Long.toString(seconds).length())

        );
    }

    public static void resetDialog(){
        ourInstance = null;
        dialog = null;
    }

    public boolean isShown(){
        boolean shown=false;
        if(dialog!=null && dialog.isShowing()){
            shown=true;
        }
        return shown;
    }


}

