package aero.developer.bagnet.dialogs;

import android.annotation.SuppressLint;
import android.content.DialogInterface;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.honeywell.aidc.BarcodeReader;
import com.honeywell.aidc.UnsupportedPropertyException;

import java.util.ArrayList;
import java.util.Date;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.CustomViews.AutoresizeTextView;
import aero.developer.bagnet.R;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.scantypes.CognexScanActivity;
import aero.developer.bagnet.scantypes.EngineActivity;
import aero.developer.bagnet.scantypes.HoneyWellScanner_Activity;
import aero.developer.bagnet.utils.BagTagDBHelper;
import aero.developer.bagnet.utils.DataManUtils;
import aero.developer.bagnet.utils.Location_Utils;
import aero.developer.bagnet.utils.Preferences;
import aero.developer.bagnet.utils.SyncManager;
import aero.developer.bagnet.utils.Utils;


/**
 * Created by User on 24-Nov-17.
 */

public class BINGO_Progress_Dialog extends DialogFragment {
    @SuppressLint("StaticFieldLeak")
    public static BINGO_Progress_Dialog instance;
    private ScrollView scrollView;
    private ProgressBar progressBar;
    private TextView txt_progressBagNumber,startContinuousScan;
    Button btn_submit,btn_reset,btn_cancel;
    ImageView caution1,caution2,progressbar_bag,img_scanner;
    AutoresizeTextView bingo,title;
    private EngineActivity engineActivity;
    private int number_of_bags ;
    public boolean BINGO_REACHED ;

    public static BINGO_Progress_Dialog getInstance() {
        if (instance == null) {
            instance = new BINGO_Progress_Dialog();
        }
        return instance;
    }


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(STYLE_NO_FRAME, R.style.AppTheme);
    }

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootview = inflater.inflate(R.layout.bingo_progress_sheet, container, false);
        scrollView = rootview.findViewById(R.id.scrollView);
        startContinuousScan = rootview.findViewById(R.id.startContinuousScan);
        progressbar_bag = rootview.findViewById(R.id.progressbar_bag);
        img_scanner = rootview.findViewById(R.id.img_scanner);
        progressBar = rootview.findViewById(R.id.progressBar);
        txt_progressBagNumber = rootview.findViewById(R.id.txt_progressBagNumber);
        btn_submit = rootview.findViewById(R.id.btn_submit);
        btn_reset = rootview.findViewById(R.id.btn_reset);
        btn_cancel = rootview.findViewById(R.id.btn_cancel);
        caution1 = rootview.findViewById(R.id.caution1);
        caution2 = rootview.findViewById(R.id.caution2);
        title = rootview.findViewById(R.id.title);
        bingo = rootview.findViewById(R.id.bingo);

        number_of_bags = Preferences.getInstance().getBingoBagsnumber(getContext());
        progressBar.setMax(number_of_bags);
        setCancelable(false);
        btn_submit.setOnClickListener(submitListner);
        btn_reset.setOnClickListener(resetListner);
        btn_cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
                progressBar.setProgress(0);
                Preferences.getInstance().resetBingoInfo(getContext());
                engineActivity.onClearTrackingPoint();
                BINGO_REACHED = false;
            }
        });

        BINGO_REACHED = false;
        txt_progressBagNumber.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if( Integer.parseInt(txt_progressBagNumber.getText().toString()) == 0) {
                    bingoReached();
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
        return rootview;
    }

    @Override
    public void onResume() {
        super.onResume();
        updateFields();
        adjustColors();

        if(HoneyWellScanner_Activity.barcodeReader !=null ) {
            try {
                HoneyWellScanner_Activity.barcodeReader.setProperty(BarcodeReader.PROPERTY_TRIGGER_SCAN_MODE,
                        BarcodeReader.TRIGGER_SCAN_MODE_CONTINUOUS);
            } catch (UnsupportedPropertyException e) {
                e.printStackTrace();
            }

        }

        if(!BINGO_REACHED && CognexScanActivity.readerDevice!= null && CognexScanActivity.readerDevice.getDataManSystem() != null ) {
            DataManUtils.enableContinuousMode(CognexScanActivity.readerDevice.getDataManSystem());
            DataManUtils.turnBeepOFF(CognexScanActivity.readerDevice.getDataManSystem());
        }
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                engineActivity.enable2of5Interleaved();
            }
        },2000);
    }

    @SuppressLint("StringFormatInvalid")
    private void bingoReached() {
        caution1.setVisibility(View.GONE);
        caution2.setVisibility(View.GONE);
        bingo.setVisibility(View.VISIBLE);
        btn_submit.setBackground(getResources().getDrawable(R.drawable.btn_green_background));
        btn_submit.setText(getResources().getString(R.string.submit_bags, number_of_bags,number_of_bags));
        BINGO_REACHED = true;
        engineActivity.disable2of5Interleaved();
    }

    private View.OnClickListener submitListner = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            String BingoTempQueue = Preferences.getInstance().getBingoTempQueue(getContext());
            ArrayList TempQueue = new Gson().fromJson(BingoTempQueue, new TypeToken<ArrayList<String>>() {
            }.getType());

            if(BINGO_REACHED) {

                for(int i =0 ;TempQueue!=null && i<TempQueue.size();i++) {
                    BagTag bagTag = new BagTag();
                    bagTag.setBagtag(TempQueue.get(i).toString());
                    bagTag.setContainerid(null);
                    bagTag.setTrackingpoint(Preferences.getInstance().getTrackingLocation(getContext()));
                    bagTag.setDatetime(Utils.formatDate(new Date(), Utils.timeZoneFormatREQUEST));
                    String unknown_bag = Location_Utils.getUnknownBags(Preferences.getInstance().getTrackingLocation(getContext()));
                    if(unknown_bag != null && unknown_bag.equalsIgnoreCase("I")) {
                        BagTagDBHelper.getInstance(getContext()).getBagtagTag().insertOrReplace(bagTag);
                        if (engineActivity != null) {
                            engineActivity.addBagTag(bagTag);
                            SyncManager syncManager = new SyncManager(engineActivity, engineActivity);
                            syncManager.start();
                        }
                    }else {
                        bagTag.setFlightdate(Preferences.getInstance().getFlightDate(getContext()));
                        bagTag.setFlighttype(Preferences.getInstance().getFlightType(getContext()));
                        bagTag.setFlightnum(Preferences.getInstance().getFlightNumber(getContext()));
                        engineActivity.addSyncBag(bagTag);
                    }
                }
                dismiss();
                Preferences.getInstance().deleteTrackingLocation(getContext());
                Preferences.getInstance().resetBingoInfo(getContext());
                engineActivity.setScannedLocation(null);
                BINGO_REACHED = false;
            }else {
                Incomplete_Submit_Dialog incomplete_submit_dialog = Incomplete_Submit_Dialog.getInstance (engineActivity);
                int current_bag_number;
                if(TempQueue!= null && TempQueue.size()>0) {
                    current_bag_number = TempQueue.size();
                }else
                    current_bag_number = 0;

                incomplete_submit_dialog.set_current_bags_number(current_bag_number, engineActivity);
                if(!engineActivity.isFinishing())
                incomplete_submit_dialog.show(engineActivity.getSupportFragmentManager(), "incomplete_submit_dialog");
            }
        }
    };

    private View.OnClickListener resetListner = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            progressBar.setProgress(0);
            Preferences.getInstance().setBingoTempQueue(null);
            BINGO_REACHED = false;
            engineActivity.enable2of5Interleaved();
            updateFields();
            caution1.setVisibility(View.VISIBLE);
            caution2.setVisibility(View.VISIBLE);
            bingo.setVisibility(View.INVISIBLE);
            adjustColors();
        }
    };

    public void setCallback(EngineActivity engineActivity) {
        this.engineActivity = engineActivity;
    }

    @SuppressLint("StringFormatInvalid")
    public void updateFields() {
        String BingoTempQueue = Preferences.getInstance().getBingoTempQueue(getContext());
        ArrayList TempQueue = new Gson().fromJson(BingoTempQueue, new TypeToken<ArrayList<String>>() {
        }.getType());
        if(TempQueue != null) {
            progressBar.setProgress(TempQueue.size());
            btn_submit.setText(getResources().getString(R.string.submit_incomplete,TempQueue.size() ,number_of_bags));
            txt_progressBagNumber.setText(String.valueOf(number_of_bags - TempQueue.size() ));
            if(txt_progressBagNumber.getText().toString().equals("-1")){
                txt_progressBagNumber.setText("0");
                btn_submit.setText(getResources().getString(R.string.submit_bags, number_of_bags ,number_of_bags));
            }
            if(Preferences.getInstance().isNightMode(getContext())) {
                btn_reset.setBackground(getResources().getDrawable(R.drawable.btn_dark_gray_background));
            }else{
                btn_reset.setBackgroundDrawable(getResources().getDrawable(R.drawable.btn_gray_background));
            }

        }else {
            progressBar.setProgress(0);
            btn_submit.setText(getResources().getString(R.string.submit_incomplete, 0 ,number_of_bags));
            txt_progressBagNumber.setText(String.valueOf(number_of_bags));
            if(Preferences.getInstance().isNightMode(getContext())) {
                GradientDrawable btn_reset_drawable = (GradientDrawable)btn_reset.getBackground();
                btn_reset_drawable.setStroke(2,AppController.getInstance().getSecondaryGrayColor());
            }else{
                btn_reset.setBackgroundDrawable(getResources().getDrawable(R.drawable.login_button_shape));
            }
        }
    }

    private void adjustColors() {

        String BingoTempQueue = Preferences.getInstance().getBingoTempQueue(getContext());
        ArrayList TempQueue = new Gson().fromJson(BingoTempQueue, new TypeToken<ArrayList<String>>() {
        }.getType());
        scrollView.setBackgroundColor(AppController.getInstance().getSecondaryColor());
        title.setTextColor(AppController.getInstance().getPrimaryColor());
        bingo.setTextColor(AppController.getInstance().getPrimaryColor());
        startContinuousScan.setTextColor(AppController.getInstance().getPrimaryColor());
        txt_progressBagNumber.setTextColor(AppController.getInstance().getPrimaryColor());

            if (Preferences.getInstance().isNightMode(getContext())) {
                btn_submit.setBackground(getResources().getDrawable(R.drawable.btn_dark_gray_background));
//                btn_reset.setBackground(getResources().getDrawable(R.drawable.btn_dark_gray_background));
            } else {
                btn_submit.setBackground(getResources().getDrawable(R.drawable.btn_gray_background));
//                btn_reset.setBackground(getResources().getDrawable(R.drawable.btn_gray_background));
            }

        if(TempQueue != null) {
            if(Preferences.getInstance().isNightMode(getContext())) {
                btn_reset.setBackground(getResources().getDrawable(R.drawable.btn_dark_gray_background));
            }else{
                btn_reset.setBackgroundDrawable(getResources().getDrawable(R.drawable.btn_gray_background));
            }
        }else {
            if(Preferences.getInstance().isNightMode(getContext())) {
                GradientDrawable btn_reset_drawable = (GradientDrawable)btn_reset.getBackground();
                btn_reset_drawable.setStroke(2,AppController.getInstance().getSecondaryGrayColor());
            }else{
                btn_reset.setBackgroundDrawable(getResources().getDrawable(R.drawable.login_button_shape));
            }
        }
        if(BINGO_REACHED) {
            btn_submit.setBackground(getResources().getDrawable(R.drawable.btn_green_background));
        }

        GradientDrawable btn_cancel_drawable = (GradientDrawable)btn_cancel.getBackground();
        btn_cancel_drawable.setStroke(2,AppController.getInstance().getSecondaryGrayColor());

//        RotateDrawable rotate_drawable = (RotateDrawable) progressBar.getProgressDrawable();
//        GradientDrawable gradient_drawable = (GradientDrawable) rotate_drawable.getDrawable();
//        if(gradient_drawable != null) {
//            gradient_drawable.setColor(AppController.getInstance().getPrimaryOrangeColor());
//        }
//
//
        GradientDrawable progress_bagckground = (GradientDrawable)progressBar.getBackground();
        progress_bagckground.setColor(AppController.getInstance().getPrimaryColor());

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            DrawableCompat.setTint(img_scanner.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(progressbar_bag.getDrawable(), AppController.getInstance().getPrimaryColor());
            DrawableCompat.setTint(caution1.getDrawable().mutate(), AppController.getInstance().getSecondaryColor());
            DrawableCompat.setTint(caution2.getDrawable().mutate(), AppController.getInstance().getSecondaryColor());
        }else {
            img_scanner.setImageDrawable(AppController.getTintedDrawable(img_scanner.getDrawable(),AppController.getInstance().getPrimaryColor()));
            progressbar_bag.setImageDrawable(AppController.getTintedDrawable(progressbar_bag.getDrawable(),AppController.getInstance().getPrimaryColor()));
            caution1.setImageDrawable(AppController.getTintedDrawable(caution1.getDrawable(),AppController.getInstance().getSecondaryColor()));
            caution2.setImageDrawable(AppController.getTintedDrawable(caution2.getDrawable(),AppController.getInstance().getSecondaryColor()));
        }
        btn_cancel.setTextColor(AppController.getInstance().getPrimaryColor());
    }

    public void hideDialog() {
        if(getDialog()!=null && getDialog().isShowing()) {
            getDialog().dismiss();
            instance = null;
        }
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        super.onDismiss(dialog);

        if(CognexScanActivity.readerDevice!=null) {
            DataManUtils.disableContinuousMode(CognexScanActivity.readerDevice.getDataManSystem());
            DataManUtils.turnBeepON(CognexScanActivity.readerDevice.getDataManSystem());

        }
        if(HoneyWellScanner_Activity.barcodeReader!=null) {
            try {
                HoneyWellScanner_Activity.barcodeReader.setProperty(BarcodeReader.PROPERTY_TRIGGER_SCAN_MODE,
                        BarcodeReader.TRIGGER_SCAN_MODE_ONESHOT);
            } catch (UnsupportedPropertyException e) {
                e.printStackTrace();
            }
        }
        engineActivity.disable2of5Interleaved();
        instance = null;
    }
}
