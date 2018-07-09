package aero.developer.bagnet.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Build;
import android.os.CountDownTimer;
import android.support.v4.app.FragmentActivity;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.util.Date;
import java.util.concurrent.TimeUnit;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.Constants;
import aero.developer.bagnet.CustomViews.DialogTextView;
import aero.developer.bagnet.CustomViews.DigitalTextView;
import aero.developer.bagnet.CustomViews.HeaderTextView;
import aero.developer.bagnet.R;
import aero.developer.bagnet.adapter.AirportAirlineAdapter;
import aero.developer.bagnet.interfaces.OptionSelectionCallback;
import aero.developer.bagnet.objects.LoginData;
import aero.developer.bagnet.utils.Location_Utils;
import aero.developer.bagnet.utils.Preferences;

/**
 * Created by User on 13-Oct-17.
 */

public class LocationSuccessFullDialog  {
    private static LocationSuccessFullDialog instance;
    private static Dialog dialog = null;
    private static Context _context;

    DigitalTextView timerText;
    HeaderTextView Txtgate;
    RelativeLayout upper_container;
    DialogTextView location_identified,timeout;
    ImageView my_location,ic_airline;
    TextView txt_select_airline;
    RecyclerView airport_airline_recycleView;
    AirportAirlineAdapter adapter;
    private CountDownTimer countDownTimer = null;
    private DialogInterface.OnDismissListener onDismissListener;

    public void setOnDismissListener(DialogInterface.OnDismissListener onDismissListener) {
        this.onDismissListener = onDismissListener;
    }

    public static LocationSuccessFullDialog getInstance(Context context) {
        _context = context;
        if(instance==null){
            instance=new LocationSuccessFullDialog();
        }
        if (dialog==null){
            dialog=new Dialog(_context,android.R.style.Theme_Black_NoTitleBar_Fullscreen);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        }
        return instance;
    }
    private LocationSuccessFullDialog() {}

    public void showDialog(OptionSelectionCallback optionSelectionCallback) {
        try {

            if(dialog != null && dialog.getWindow() != null) {
                dialog.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);
                dialog.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
            }
            dialog.setCancelable(false);
            dialog.setContentView(R.layout.location_success_full_dialog);
            upper_container = (RelativeLayout) dialog.findViewById(R.id.upper_container);
            location_identified = (DialogTextView) dialog.findViewById(R.id.location_identified);
            timeout = (DialogTextView) dialog.findViewById(R.id.timeout);
            my_location = (ImageView) dialog.findViewById(R.id.my_location);
            timerText = (DigitalTextView) dialog.findViewById(R.id.time);
            Txtgate = (HeaderTextView) dialog.findViewById(R.id.Txtgate);
            airport_airline_recycleView = (RecyclerView) dialog.findViewById(R.id.airport_airline_recycleView);
            ic_airline = (ImageView) dialog.findViewById(R.id.ic_airline);
            txt_select_airline = (TextView) dialog.findViewById(R.id.txt_select_airline);

            String json = Preferences.getInstance().getLoginResponse(_context);
            LoginData loginData = new Gson().fromJson(json, new TypeToken<LoginData>() {
            }.getType());
            adapter = new AirportAirlineAdapter(_context, AppController.getInstance().getAirportAirlineFromString(loginData.getAirlines())
                    , ((FragmentActivity) _context), false, true, optionSelectionCallback);
            GridLayoutManager mLayoutManager = new GridLayoutManager(_context, 2, StaggeredGridLayoutManager.VERTICAL, false);

            airport_airline_recycleView.setLayoutManager(mLayoutManager);
            airport_airline_recycleView.setAdapter(adapter);


            WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
            Window window = dialog.getWindow();
            lp.copyFrom(window.getAttributes());
            lp.width = WindowManager.LayoutParams.MATCH_PARENT;
            lp.height = WindowManager.LayoutParams.MATCH_PARENT;
            window.setAttributes(lp);
            dialog.setOnDismissListener(this.onDismissListener);
            dialog.show();
            setData();

            //adjust colors
            upper_container.setBackgroundColor(AppController.getInstance().getSecondaryColor());
            Txtgate.setTextColor(AppController.getInstance().getPrimaryColor());
            timerText.setTextColor(AppController.getInstance().getPrimaryOrangeColor());
            txt_select_airline.setTextColor(AppController.getInstance().getPrimaryOrangeColor());
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                DrawableCompat.setTint(my_location.getDrawable(), AppController.getInstance().getSecondaryGrayColor());
                DrawableCompat.setTint(ic_airline.getDrawable(), AppController.getInstance().getPrimaryColor());
            } else {
                my_location.setImageDrawable(AppController.getTintedDrawable(my_location.getDrawable(), AppController.getInstance().getSecondaryGrayColor()));
                ic_airline.setImageDrawable(AppController.getTintedDrawable(ic_airline.getDrawable(), AppController.getInstance().getPrimaryColor()));

            }
            location_identified.setTextColor(AppController.getInstance().getSecondaryGrayColor());
            timeout.setTextColor(AppController.getInstance().getSecondaryGrayColor());
        }catch (Exception e){
            dialog=new Dialog(_context,android.R.style.Theme_Black_NoTitleBar_Fullscreen);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            showDialog(optionSelectionCallback);
        }
    }


    public static void hideDialog() {
        if(dialog!=null && dialog.isShowing()){
            dialog.dismiss();
            dialog = null;
        }
    }
    private void setData() {
        long startedTrackingTime = Preferences.getInstance().getStartTrackingTime(_context);
        String trackingLocation = Preferences.getInstance().getTrackingLocation(_context);
        Txtgate.setText(Location_Utils.getTrackingLocation(trackingLocation,false));
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
        instance = null;
        dialog = null;
    }

    public boolean isShown(){
        boolean shown=false;
        if(dialog!=null && dialog.isShowing()){
            shown=true;
        }
        return shown;
    }

    public void onFinish() {
        hideDialog();

    }
}
