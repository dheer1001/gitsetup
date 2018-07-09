package aero.developer.bagnet;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.PorterDuff;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.InputFilter;
import android.text.Spanned;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.regex.Pattern;

import aero.developer.bagnet.CustomViews.CostumEditText;
import aero.developer.bagnet.CustomViews.CustomButton;
import aero.developer.bagnet.CustomViews.DialogTextView;
import aero.developer.bagnet.CustomViews.DigitalTextView;
import aero.developer.bagnet.utils.Location_Utils;
import aero.developer.bagnet.utils.Preferences;
import aero.developer.bagnet.utils.Utils;

public class BINGO_Activity extends AppCompatActivity implements SharedPreferences.OnSharedPreferenceChangeListener{
    LinearLayout additional_information_container;
    CustomButton departure,arrival,save,cancel;
    Spinner dateSpinner;
    EditText input_flight_number,txt_NbBags;
    String flightType;
    String [] date;
    ScrollView scrollView;
    RelativeLayout flight_number,layout_date,Nb_bagsContainer;
    DialogTextView additional_information,txt_header;

    DigitalTextView txt_progressBagNumber;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bingo);
        scrollView = (ScrollView) findViewById(R.id.scrollView);
        flight_number = (RelativeLayout) findViewById(R.id.flight_number);
        layout_date = (RelativeLayout) findViewById(R.id.layout_date);
        additional_information = (DialogTextView) findViewById(R.id.additional_information);
        Nb_bagsContainer = (RelativeLayout) findViewById(R.id.Nb_bagsContainer);
        additional_information_container = (LinearLayout) findViewById(R.id.additional_information_container);
        departure = (CustomButton) findViewById(R.id.departure);
        arrival = (CustomButton) findViewById(R.id.arrival);
        cancel = (CustomButton) findViewById(R.id.cancel);
        save = (CustomButton) findViewById(R.id.save);
        dateSpinner = (Spinner) findViewById(R.id.dateSpinner);
        input_flight_number = (CostumEditText) findViewById(R.id.input_flight_number);
        txt_NbBags = (CostumEditText) findViewById(R.id.txt_NbBags);
        txt_progressBagNumber = (DigitalTextView) findViewById(R.id.txt_progressBagNumber);
        txt_header = (DialogTextView) findViewById(R.id.txt_header);

        String tracking_location = Preferences.getInstance().getTrackingLocation(getApplicationContext());

        Preferences.getSharedPreferences(getApplicationContext()).registerOnSharedPreferenceChangeListener(this);

        if(tracking_location != null && Location_Utils.getUnknownBags(tracking_location).equalsIgnoreCase("I")){
            additional_information_container.setVisibility(View.INVISIBLE);
        }else {
            additional_information_container.setVisibility(View.VISIBLE);
        }

        InputFilter filter = new InputFilter() {
            @Override
            public CharSequence filter(CharSequence source, int start, int end, Spanned dest, int dstart, int dend) {
                for (int i = start; i < end; ++i) {
                    if (!Pattern.compile("[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789]*").matcher(String.valueOf(source.charAt(i))).matches()) {
                        return "";
                    }
                }

                return null;
            }
        };
        input_flight_number.setFilters(new InputFilter[]{filter, new InputFilter.AllCaps(), new InputFilter.LengthFilter(7)});
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                Preferences.getInstance().setBingoTempQueue(null);
                Preferences.getInstance().resetBingoInfo(getApplicationContext());

                finish();
            }
        });

        departure.setOnClickListener(departureButtonListner);
        arrival.setOnClickListener(arrivalButtonListner);

        departure.setEnabled(true);
        departure.callOnClick();
        final Calendar c = Calendar.getInstance();
        String today = Utils.formatDate(c.getTime(), Utils.DATE_FORMAT);
        c.add(Calendar.DATE, -1);
        String yesterday = Utils.formatDate(c.getTime(), Utils.DATE_FORMAT);
        c.add(Calendar.DATE, +2);
        String tomorrow = Utils.formatDate(c.getTime(), Utils.DATE_FORMAT);
        date = new String[]{
                getApplicationContext().getString(R.string.selectDate),
                yesterday,
                today,
                tomorrow
        };

        final List<String> plantsList = new ArrayList<>(Arrays.asList(date));


        // Initializing an ArrayAdapter
        final ArrayAdapter<String> spinnerArrayAdapter = new ArrayAdapter<String>(getApplicationContext(), R.layout.spinner_item, plantsList) {
            @Override
            public boolean isEnabled(int position) {
                if (position == 0) {
                    return false;
                } else {
                    return true;
                }
            }

            @Override
            public View getDropDownView(int position, View convertView,
                                        ViewGroup parent) {
                View view = super.getDropDownView(position, convertView, parent);
                DialogTextView tv = (DialogTextView) view;

                if (position == 0) {
                    tv.setTextColor(getContext().getResources().getColor(R.color.disabled_gray));
                } else {
                    tv.setTextColor(getContext().getResources().getColor(R.color.white));
                }
                return view;
            }
        };

//        if(Preferences.getInstance().isNightMode(getApplicationContext())) {
//            spinnerArrayAdapter.setDropDownViewResource(R.layout.night_spinner_item);
//        }
//        else
//        {
            spinnerArrayAdapter.setDropDownViewResource(R.layout.spinner_item);

//        }
        dateSpinner.setAdapter(spinnerArrayAdapter);
        dateSpinner.setDropDownWidth(850);
        dateSpinner.setOnTouchListener(new View.OnTouchListener() {
            @SuppressLint("ClickableViewAccessibility")
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                InputMethodManager imm=(InputMethodManager)getApplicationContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                if(imm != null) {
                    imm.hideSoftInputFromWindow(input_flight_number.getWindowToken(), 0);
                }
                return false;
            }
        }) ;
        dateSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                                                  @Override
                                                  public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                                                      if (getResources() != null && parent.getChildAt(0) != null) {
                                                          ((TextView) parent.getChildAt(0)).setTextColor(AppController.getInstance().getPrimaryColor());
                                                      }
                                                  }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        dateSpinner.setSelection(0);
        save.setOnClickListener(saveButtonListner);
        adjustColors();

    }

    private boolean isDataValid(String flightNumber, String flightType, int flightDate,String numberOfBags) {
        String unknown_bag = Location_Utils.getUnknownBags(Preferences.getInstance().getTrackingLocation(getApplicationContext()));

        //only number of bags is inputted
        if(unknown_bag!= null &&  unknown_bag.equalsIgnoreCase("I")) {
            if(!numberOfBags.equals("") && Integer.parseInt(numberOfBags) >= 2 && Integer.parseInt(numberOfBags) <= 999 ){
                return true;
            }
            txt_NbBags.setError(getApplicationContext().getString(R.string.invalid_bag_number));
            return false;
        }else {
            if (flightNumber == null || flightNumber.equalsIgnoreCase("") || flightNumber.length() < 4) {
                input_flight_number.setError(getApplicationContext().getString(R.string.invalidFlightNumber));
                return false;
            }else{
                input_flight_number.setError(null);
            }

            if (flightDate == 0 || date[flightDate] == null || date[flightDate].equalsIgnoreCase("")) {
                ((TextView)dateSpinner.getChildAt(0)).setError(getApplicationContext().getString(R.string.invalidFlightNumber));
                return false;
            }
            if (flightType == null || flightType.equalsIgnoreCase("")) {

                return false;
            }

            if(numberOfBags.equals("") || (!numberOfBags.equals("") && (Integer.parseInt(numberOfBags) <2 || Integer.parseInt(numberOfBags) >999 ))){
                txt_NbBags.setError(getApplicationContext().getString(R.string.invalid_bag_number));
                return false;
            }

            return true;
        }

    }

    private View.OnClickListener departureButtonListner =new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if(!Preferences.getInstance().isNightMode(getApplicationContext())) {
                departure.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.arrival_departure_active));
                arrival.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.arrival_departure_default));

                final GradientDrawable arrival_drawable = (GradientDrawable)arrival.getBackground();
                final GradientDrawable departure_drawable = (GradientDrawable)departure.getBackground();

                arrival_drawable.setStroke(1,AppController.getInstance().getSecondaryGrayColor());
                departure_drawable.setStroke(1,AppController.getInstance().getSecondaryGrayColor());
            }
            else {
                departure.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.arrival_departure_default));
                arrival.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.arrival_departure_active));


                final GradientDrawable arrival_drawable = (GradientDrawable)arrival.getBackground();
                final GradientDrawable departure_drawable = (GradientDrawable)departure.getBackground();

                arrival_drawable.setStroke(1,AppController.getInstance().getPrimaryColor());
                departure_drawable.setStroke(1,AppController.getInstance().getPrimaryColor());


            }
            flightType = "D";
        }
    };

    private View.OnClickListener arrivalButtonListner =new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if(!Preferences.getInstance().isNightMode(getApplicationContext())) {
                arrival.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.arrival_departure_active));
                departure.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.arrival_departure_default));

                final GradientDrawable arrival_drawable = (GradientDrawable)arrival.getBackground();
                final GradientDrawable departure_drawable = (GradientDrawable)departure.getBackground();

                arrival_drawable.setStroke(1,AppController.getInstance().getSecondaryGrayColor());
                departure_drawable.setStroke(1,AppController.getInstance().getSecondaryGrayColor());

            }
            else {
                arrival.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.arrival_departure_default));
                departure.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.arrival_departure_active));

                final GradientDrawable arrival_drawable = (GradientDrawable)arrival.getBackground();
                final GradientDrawable departure_drawable = (GradientDrawable)departure.getBackground();

                arrival_drawable.setStroke(1,AppController.getInstance().getPrimaryColor());
                departure_drawable.setStroke(1,AppController.getInstance().getPrimaryColor());



            }
            flightType = "A";
        }
    };

    View.OnClickListener saveButtonListner =new View.OnClickListener() {
        @Override
        public void onClick(View v) {

            if (isDataValid(input_flight_number.getText().toString(), flightType, dateSpinner.getSelectedItemPosition(),txt_NbBags.getText().toString())) {
                //saving info in preferences
                String unkownBag = Location_Utils.getUnknownBags(Preferences.getInstance().getTrackingLocation(getApplicationContext()));
                if(unkownBag!= null && unkownBag.equalsIgnoreCase("S")) {
                    Preferences.getInstance().saveBingoInfo(getApplicationContext(),
                            date[dateSpinner.getSelectedItemPosition()], input_flight_number.getText().toString(), flightType, Integer.parseInt(txt_NbBags.getText().toString()));
                }else {
                    Preferences.getInstance().setBingoBagsNumber(getApplicationContext(), Integer.parseInt(txt_NbBags.getText().toString()));
                }
                Intent returnIntent = new Intent();
                returnIntent.putExtra("isFrom_BINGO_Activity",true);
                setResult(Activity.RESULT_OK, returnIntent);
//                Preferences.getInstance().setBingoTempQueue(null);
                finish();

            }
            }
    };

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    public void onBackPressed() {
//        if(CognexScanActivity.readerDevice.getDataManSystem()!=null) {
//            DataManUtils.disableContinuousMode(CognexScanActivity.readerDevice.getDataManSystem());
//        }
        super.onBackPressed();
     }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Preferences.getSharedPreferences(getApplicationContext()).unregisterOnSharedPreferenceChangeListener(this);

    }

    private void adjustColors(){
        scrollView.setBackgroundColor(AppController.getInstance().getSecondaryColor());
        txt_header.setTextColor(AppController.getInstance().getPrimaryColor());
        GradientDrawable btn_cancel_drawable = (GradientDrawable)cancel.getBackground();
        btn_cancel_drawable.setStroke(2,AppController.getInstance().getSecondaryGrayColor());

        if(Preferences.getInstance().isNightMode(getApplicationContext())) {
            flight_number.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.night_edit_text_shape));
            Nb_bagsContainer.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.night_edit_text_shape));

            layout_date.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.night_edit_text_shape));
            dateSpinner.getBackground().setColorFilter(AppController.getInstance().getPrimaryColor(), PorterDuff.Mode.SRC_ATOP);
//            input_flight_number.setHintTextColor(AppController.getInstance().getPrimaryColor());
//            txt_NbBags.setHintTextColor(AppController.getInstance().getPrimaryColor());
        }
        else {
            flight_number.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.edit_text_shape));
            layout_date.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.edit_text_shape));
            Nb_bagsContainer.setBackground(getApplicationContext().getResources().getDrawable(R.drawable.edit_text_shape));

            dateSpinner.getBackground().setColorFilter(AppController.getInstance().getPrimaryColor(), PorterDuff.Mode.SRC_ATOP);
//            input_flight_number.setHintTextColor(AppController.getInstance().getSecondaryGrayColor());
//            txt_NbBags.setHintTextColor(AppController.getInstance().getSecondaryGrayColor());

        }

        input_flight_number.setHintTextColor(AppController.getInstance().getPrimaryColor());
        input_flight_number.setTextColor(AppController.getInstance().getPrimaryColor());

        txt_NbBags.setHintTextColor(AppController.getInstance().getPrimaryColor());
        txt_NbBags.setTextColor(AppController.getInstance().getPrimaryColor());

        additional_information.setTextColor(AppController.getInstance().getPrimaryOrangeColor());
//        input_flight_number.setTextColor(getApplicationContext().getResources().getColor(R.color.white));
        cancel.setTextColor(AppController.getInstance().getPrimaryColor());
    }


    @Override
    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {

        if(key.equalsIgnoreCase(Preferences.TACKINGLOCATION)) {
            Preferences.getInstance().resetBingoInfo(getApplicationContext());
//            Preferences.getInstance().setBingoTempQueue(null);
            View view = this.getCurrentFocus();
            if (view != null) {
                InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
            }

            setResult(2);

            finish();
        }
    }

}
