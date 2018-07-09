package aero.developer.bagnet.dialogs;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.AppCompatActivity;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.Date;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.scantypes.EngineActivity;
import aero.developer.bagnet.utils.BagTagDBHelper;
import aero.developer.bagnet.utils.Location_Utils;
import aero.developer.bagnet.utils.Preferences;
import aero.developer.bagnet.utils.SyncManager;
import aero.developer.bagnet.utils.Utils;

/**
 * Created by User on 27-Nov-17.
 */

public class Incomplete_Submit_Dialog extends DialogFragment {

    private static Incomplete_Submit_Dialog instance;
    private static Context _context;
    private static Dialog dialog = null;
    private TextView title,details;
    private Button btn_submit,btn_cancel;
    private RelativeLayout main_container;
    private int current_bags_number;
    private EngineActivity engineActivity;
    public static Incomplete_Submit_Dialog getInstance(Context context) {
        _context = context;
        if(instance==null){
            instance=new Incomplete_Submit_Dialog();
        }
        if (dialog==null){
            dialog=new Dialog(_context,R.style.DialogTheme);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        }
        return instance;
    }

    public void set_current_bags_number(int nb, EngineActivity engineActivity){
        this.current_bags_number = nb;
        this.engineActivity = engineActivity;
    }

    @SuppressLint("StringFormatInvalid")
    @NonNull
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
            dialog.setContentView(R.layout.incomplete_submit_dialog);
            int max_bags_number = Preferences.getInstance().getBingoBagsnumber(_context);
            main_container = (RelativeLayout) dialog.findViewById(R.id.main_container);
            title = (TextView) dialog.findViewById(R.id.title);
            details = (TextView) dialog.findViewById(R.id.details);
            title.setText(getResources().getString(R.string.bags_incomplete, current_bags_number, max_bags_number));
            details.setText(getResources().getString(R.string.incomplete_bags_details_dialog, max_bags_number, current_bags_number));
            btn_cancel = (Button) dialog.findViewById(R.id.btn_cancel);
            btn_submit = (Button) dialog.findViewById(R.id.btn_submit);
            WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
            Window window = dialog.getWindow();
            if (window != null) {
                lp.copyFrom(window.getAttributes());
                lp.width = WindowManager.LayoutParams.MATCH_PARENT;
                lp.gravity = Gravity.CENTER_VERTICAL;
                window.setAttributes(lp);
            }

            btn_cancel.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    dismiss();
                }
            });
            btn_submit.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    String BingoTempQueue = Preferences.getInstance().getBingoTempQueue(getContext());
                    ArrayList TempQueue = new Gson().fromJson(BingoTempQueue, new TypeToken<ArrayList<String>>() {
                    }.getType());
                    for (int i = 0; TempQueue != null && i < TempQueue.size(); i++) {
                        BagTag bagTag = new BagTag();
                        bagTag.setBagtag(TempQueue.get(i).toString());
                        bagTag.setContainerid(null);
                        bagTag.setTrackingpoint(Preferences.getInstance().getTrackingLocation(getContext()));
                        bagTag.setDatetime(Utils.formatDate(new Date(), Utils.timeZoneFormatREQUEST));
                        String unknown_bag = Location_Utils.getUnknownBags(Preferences.getInstance().getTrackingLocation(getContext()));
                        if (unknown_bag != null && unknown_bag.equalsIgnoreCase("I")) {
                            BagTagDBHelper.getInstance(getContext()).getBagtagTag().insertOrReplace(bagTag);
                            if (engineActivity != null) {
                                engineActivity.addBagTag(bagTag);
                            }
                        } else {
                            bagTag.setFlightdate(Preferences.getInstance().getFlightDate(getContext()));
                            bagTag.setFlighttype(Preferences.getInstance().getFlightType(getContext()));
                            bagTag.setFlightnum(Preferences.getInstance().getFlightNumber(getContext()));
                            engineActivity.addSyncBag(bagTag);
                        }

                    }
                    SyncManager syncManager = new SyncManager(engineActivity, engineActivity);
                    syncManager.start();

                    dismiss();
                    BINGO_Progress_Dialog.getInstance().hideDialog();
                    Preferences.getInstance().deleteTrackingLocation(getContext());
                    Preferences.getInstance().resetBingoInfo(getContext());
                    engineActivity.setScannedLocation(null);
                }
            });
            try {
                if (!((AppCompatActivity) _context).isFinishing()) {
                    dialog.show();
                    adjustColors();

                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        return dialog;
    }

    private void adjustColors() {
        GradientDrawable main_container_drawable = (GradientDrawable) main_container.getBackground();
        main_container_drawable.setStroke(4, AppController.getInstance().getSecondaryGrayColor());
        main_container_drawable.setColor(AppController.getInstance().getPrimaryGrayColor());

//        GradientDrawable btn_sign_in_drawable = (GradientDrawable)btn_cancel.getBackground();
//        btn_sign_in_drawable.setStroke(4,AppController.getInstance().getSecondaryGrayColor());

        if(Preferences.getInstance().isNightMode(getContext())) {
            btn_submit.setBackgroundColor(AppController.getInstance().getSecondaryGrayColor());
//            btn_submit.setBackground(getResources().getDrawable(R.drawable.btn_dark_gray_background));
        }else {
            btn_submit.setBackground(getResources().getDrawable(R.drawable.btn_gray_background));
        }

        title.setTextColor(AppController.getInstance().getPrimaryColor());
        details.setTextColor(AppController.getInstance().getPrimaryColor());

    }


}
