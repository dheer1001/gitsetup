package aero.developer.bagnet.dialogs;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.AppCompatEditText;
import android.text.InputFilter;
import android.text.Spanned;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.regex.Pattern;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.CustomViews.CustomButton;
import aero.developer.bagnet.CustomViews.DialogTextView;
import aero.developer.bagnet.CustomViews.HeaderTextView;
import aero.developer.bagnet.R;
import aero.developer.bagnet.interfaces.OnGlobalFlightDataSaved;
import aero.developer.bagnet.interfaces.QueueCallBacks;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.scantypes.EngineActivity;
import aero.developer.bagnet.utils.Analytic;
import aero.developer.bagnet.utils.Preferences;
import aero.developer.bagnet.utils.SyncManager;
import aero.developer.bagnet.utils.Utils;


public class Flight_Screen_Dialog {
    private static Dialog dialog = null;
    @SuppressLint("StaticFieldLeak")
    private static Context context;
    @SuppressLint("StaticFieldLeak")
    private static Flight_Screen_Dialog ourInstance;
    private String[] date;
    private boolean returnToBagDetails = false;
    private SyncManager syncManager;
    private QueueCallBacks queueCallBacks;
    private AppCompatEditText input_flight_number;
    private Spinner dateSpinner;
    private OnGlobalFlightDataSaved onGlobalFlightDataSaved;
    private String flightType = null;
    private EngineActivity activity;
    public void setReturnToBagDetails(boolean returnToBagDetails, SyncManager syncManager, QueueCallBacks queueCallBacks) {
        this.returnToBagDetails = returnToBagDetails;
        this.syncManager = syncManager;
        this.queueCallBacks = queueCallBacks;

    }

    public void setOnGlobalFlightDataSaved(OnGlobalFlightDataSaved onGlobalFlightDataSaved) {
        this.onGlobalFlightDataSaved = onGlobalFlightDataSaved;
    }


    public static Flight_Screen_Dialog getInstance(Context _context) {
        context = _context;
        _context = context;
        if (ourInstance == null) {
            ourInstance = new Flight_Screen_Dialog();
        }
        if (dialog == null) {
            dialog = new Dialog(_context);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        }
        return ourInstance;
    }

    private Flight_Screen_Dialog() { }

    public void showDialog(final BagTag bagTag) {
        if (!((AppCompatActivity) context).isFinishing() && dialog != null) {
            if (dialog.getWindow() != null) {
                dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_NOTHING);
                dialog.setCancelable(false);
            }
            if (context instanceof EngineActivity) {
                activity = (EngineActivity) (context);
            }

            dialog.setContentView(R.layout.flight_dialog);
            final ScrollView scrollView = (ScrollView) dialog.findViewById(R.id.scrollView);
            final CustomButton arrival = (CustomButton) dialog.findViewById(R.id.arrival);
            final CustomButton departure = (CustomButton) dialog.findViewById(R.id.departure);
            dateSpinner = (Spinner) dialog.findViewById(R.id.spinner);
            input_flight_number = (AppCompatEditText) dialog.findViewById(R.id.input_flight_number);
            RelativeLayout flight_number = (RelativeLayout) dialog.findViewById(R.id.flight_number);
            ImageView flight_image = (ImageView) dialog.findViewById(R.id.flight_image);
            RelativeLayout layout_date = (RelativeLayout) dialog.findViewById(R.id.layout_date);
            HeaderTextView bagtagText = (HeaderTextView) dialog.findViewById(R.id.bagtagText);
            DialogTextView additional_information = (DialogTextView) dialog.findViewById(R.id.additional_information);
            TextView txt_cancel = (TextView) dialog.findViewById(R.id.txt_cancel);

            //adjust colors
            GradientDrawable scrollView_drawable = (GradientDrawable) scrollView.getBackground();
            if(Preferences.getInstance().isNightMode(context)) {
                flight_number.setBackground(context.getResources().getDrawable(R.drawable.night_edit_text_shape));
                layout_date.setBackground(context.getResources().getDrawable(R.drawable.night_edit_text_shape));

                scrollView_drawable.setStroke(4, AppController.getInstance().getPrimaryColor());
                dateSpinner.getBackground().setColorFilter(AppController.getInstance().getSecondaryColor(), PorterDuff.Mode.SRC_ATOP);
                input_flight_number.setHintTextColor(context.getResources().getColor(R.color.white));
            }
            else {
                flight_number.setBackground(context.getResources().getDrawable(R.drawable.edit_text_shape));
                layout_date.setBackground(context.getResources().getDrawable(R.drawable.edit_text_shape));
                dateSpinner.getBackground().setColorFilter(AppController.getInstance().getSecondaryGrayColor(), PorterDuff.Mode.SRC_ATOP);
                input_flight_number.setHintTextColor(AppController.getInstance().getSecondaryGrayColor());
                scrollView_drawable.setStroke(1, AppController.getInstance().getSecondaryGrayColor());
            }
            additional_information.setTextColor(AppController.getInstance().getPrimaryOrangeColor());
            input_flight_number.setTextColor(context.getResources().getColor(R.color.white));
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                DrawableCompat.setTint(flight_image.getDrawable(), AppController.getInstance().getPrimaryGrayColor());
            } else {
                flight_image.setImageDrawable(AppController.getTintedDrawable(flight_image.getDrawable(),AppController.getInstance().getPrimaryGrayColor()));
            }
            GradientDrawable flight_image_drawable = (GradientDrawable) flight_image.getBackground();
            flight_image_drawable.setColor(AppController.getInstance().getSecondaryGrayColor());

            bagtagText.setTextColor(AppController.getInstance().getPrimaryColor());

            scrollView_drawable.setColor(AppController.getInstance().getPrimaryGrayColor());



            WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
            Window window = dialog.getWindow();
            lp.copyFrom(window.getAttributes());
            lp.width = WindowManager.LayoutParams.MATCH_PARENT;
            lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
            window.setAttributes(lp);
            dialog.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE|WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM);
            dialog.setOnShowListener(new DialogInterface.OnShowListener() {
                @Override
                public void onShow(DialogInterface dialog1) {
                    input_flight_number.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            if (dialog != null) {
                                scrollView.fullScroll(View.FOCUS_DOWN);
                            }
                        }
                    }, 500);

                    input_flight_number.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            input_flight_number.postDelayed(new Runnable() {
                                @Override
                                public void run() {
                                    if (dialog != null && input_flight_number != null && input_flight_number.hasFocus()) {
                                        ScrollView scrollView = (ScrollView) dialog.findViewById(R.id.scrollView);
                                        if (scrollView != null)
                                            scrollView.fullScroll(View.FOCUS_DOWN);
                                    }
                                }
                            }, 500);
                        }
                    });
                }
            });
            dialog.show();


            dialog.findViewById(R.id.flight_header).setVisibility(bagTag != null ? View.VISIBLE : View.GONE);

            //it is a flight dialog for bag
            if (bagTag != null) {
                Analytic.getInstance().sendScreen(R.string.EVENT_FLIGHT_MODAL_FOR_BAG_SCREEN);
                bagtagText.setText(bagTag.getBagtag());
                txt_cancel.setOnClickListener(cancelListener_Bag);

            }else{ //it is a flight dialog for tracking location
                Analytic.getInstance().sendScreen(R.string.EVENT_FLIGHT_MODAL_FOR_TRACKING_POINT_SCREEN);
                txt_cancel.setOnClickListener(cancelListener_TrackingPoint);

            }


            final Drawable[] arrival_drawables = arrival.getCompoundDrawables();
            final Drawable[] departure_drawables = departure.getCompoundDrawables();
            final boolean isNightMode = Preferences.getInstance().isNightMode(context);

            departure.setOnClickListener(new View.OnClickListener() {
                @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
                @Override
                public void onClick(View v) {
                    departure.setTextColor(context.getResources().getColor(R.color.white));

                    for (Drawable departure_drawable : departure_drawables) {
                        if (departure_drawable != null) {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                                DrawableCompat.setTint(departure_drawable, context.getResources().getColor(R.color.white));
                                departure.setCompoundDrawables(departure_drawable, null, null, null);
                            }
                        }
                    }
                    for (Drawable arrival_drawable : arrival_drawables) {
                        if (arrival_drawable != null) {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                                if (isNightMode) {
                                    DrawableCompat.setTint(arrival_drawable, context.getResources().getColor(R.color.dark_gray));
                                } else {
                                    DrawableCompat.setTint(arrival_drawable, context.getResources().getColor(R.color.gray));
                                }
                                arrival.setCompoundDrawables(arrival_drawable, null, null, null);
                            }
                        }
                    }

                    if (isNightMode) {
                        departure.setBackground(context.getResources().getDrawable(R.drawable.arrival_departure_active_night));
                        arrival.setBackground(context.getResources().getDrawable(R.drawable.arrival_departure_default_night));
                        arrival.setTextColor(context.getResources().getColor(R.color.dark_gray));
                    } else {
                        departure.setBackground(context.getResources().getDrawable(R.drawable.arrival_departure_active));
                        arrival.setBackground(context.getResources().getDrawable(R.drawable.arrival_departure_default));
                        arrival.setTextColor(context.getResources().getColor(R.color.gray));

                    }
                    flightType = "D";
                }
            });

            arrival.setOnClickListener(new View.OnClickListener() {
                @android.support.annotation.RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
                @Override
                public void onClick(View v) {
                    arrival.setTextColor(context.getResources().getColor(R.color.white));

                    for (Drawable arrival_drawable : arrival_drawables) {
                        if (arrival_drawable != null) {
                            arrival_drawable.setTint(context.getResources().getColor(R.color.white));
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                                DrawableCompat.setTint(arrival_drawable, context.getResources().getColor(R.color.white));
                                arrival.setCompoundDrawables(arrival_drawable, null, null, null);
                            }
                        }
                    }

                    for (Drawable departure_drawable : departure_drawables) {
                        if (departure_drawable != null) {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                                if (isNightMode) {
                                    DrawableCompat.setTint(departure_drawable, context.getResources().getColor(R.color.dark_gray));
                                } else {
                                    DrawableCompat.setTint(departure_drawable, context.getResources().getColor(R.color.gray));
                                }
                                departure.setCompoundDrawables(departure_drawable, null, null, null);
                            }
                        }
                    }

                    if (isNightMode) {
                        arrival.setBackground(context.getResources().getDrawable(R.drawable.arrival_departure_active_night));
                        departure.setBackground(context.getResources().getDrawable(R.drawable.arrival_departure_default_night));
                        departure.setTextColor(context.getResources().getColor(R.color.dark_gray));

                    } else {
                        arrival.setBackground(context.getResources().getDrawable(R.drawable.arrival_departure_active));
                        departure.setBackground(context.getResources().getDrawable(R.drawable.arrival_departure_default));
                        departure.setTextColor(context.getResources().getColor(R.color.gray));

                    }

                    flightType = "A";
                }
            });
            departure.setEnabled(true);
            departure.callOnClick();
            final Calendar c = Calendar.getInstance();
            String today = Utils.formatDate(c.getTime(), Utils.DATE_FORMAT);
            c.add(Calendar.DATE, -1);
            String yesterday = Utils.formatDate(c.getTime(), Utils.DATE_FORMAT);
            c.add(Calendar.DATE, +2);
            String tomorrow = Utils.formatDate(c.getTime(), Utils.DATE_FORMAT);
            date = new String[]{
                    context.getString(R.string.selectDate),
                    yesterday,
                    today,
                    tomorrow
            };

            final List<String> plantsList = new ArrayList<>(Arrays.asList(date));

            // Initializing an ArrayAdapter
            final ArrayAdapter<String> spinnerArrayAdapter = new ArrayAdapter<String>(context, R.layout.spinner_item, plantsList) {
                @Override
                public boolean isEnabled(int position) {
                    if (position == 0) {
                        // Disabl
                        // e the first item from Spinner
                        // First item will be use for hint
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
            spinnerArrayAdapter.setDropDownViewResource(R.layout.spinner_item);
            dateSpinner.setAdapter(spinnerArrayAdapter);
//            dateSpinner.getBackground().setColorFilter(dateSpinner.getContext().getResources().getColor(R.color.gray), PorterDuff.Mode.SRC_ATOP);


            dateSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {

                }

                @Override
                public void onNothingSelected(AdapterView<?> parent) {

                }
            });

            dateSpinner.setDropDownWidth(850);

            dateSpinner.setOnTouchListener(new View.OnTouchListener() {
                @SuppressLint("ClickableViewAccessibility")
                @Override
                public boolean onTouch(View v, MotionEvent event) {
                    InputMethodManager imm=(InputMethodManager)context.getSystemService(Context.INPUT_METHOD_SERVICE);
                    if(imm !=null) {
                        imm.hideSoftInputFromWindow(input_flight_number.getWindowToken(), 0);
                    }
                    return false;
                }
            }) ;


            dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE | WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);

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

            input_flight_number.setFilters(new InputFilter[]{filter, new InputFilter.AllCaps(), new InputFilter.LengthFilter(8)});


            CustomButton saveBtn = (CustomButton) dialog.findViewById(R.id.save);
            saveBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    View view = dialog.getCurrentFocus();
                    if (view != null) {
                        InputMethodManager imm = (InputMethodManager)context.getSystemService(Context.INPUT_METHOD_SERVICE);
                        if (imm != null) {
                            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
                        }
                    }

                    if (onGlobalFlightDataSaved != null) {
                        if (isDataValid(input_flight_number.getText().toString(), flightType, dateSpinner.getSelectedItemPosition())) {

                            if (bagTag != null) {
                                onGlobalFlightDataSaved.updateBagTagwithFlightData(input_flight_number.getText().toString(), flightType, date[dateSpinner.getSelectedItemPosition()], bagTag);
                            } else {
                                onGlobalFlightDataSaved.flightDataSaved(input_flight_number.getText().toString(), flightType, date[dateSpinner.getSelectedItemPosition()]);
                            }
                        }
                    }

                    if (returnToBagDetails) {
                        if (isDataValid(input_flight_number.getText().toString(), flightType, dateSpinner.getSelectedItemPosition())) {
                            if (bagTag != null) {
                                bagTag.setFlightnum(input_flight_number.getText().toString());
                                bagTag.setFlighttype(flightType);
                                bagTag.setFlightdate(date[dateSpinner.getSelectedItemPosition()]);
                            }
                            BagDetailDialog.getInstance(context).showDialog(bagTag, true, syncManager, queueCallBacks);
                            dismissDialog();
                        }
                    }
                }
            });
        }
    }


    private View.OnClickListener cancelListener_TrackingPoint = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            dismissDialog();
            activity.onClearTrackingPoint();
            Flight_Screen_Dialog.getInstance(context).setOnGlobalFlightDataSaved(null);
        }
    };

    private View.OnClickListener cancelListener_Bag = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            dismissDialog();
            Flight_Screen_Dialog.getInstance(context).setOnGlobalFlightDataSaved(null);
            activity.enable2of5Interleaved();
        }
    };


    private boolean isDataValid(String flightNumber, String flightType, int flightDate) {
        String regex_length3 = "[A-Z0-9][A-Z0-9][0-9]";

        String regex_length4_letter = "[A-Z][A-Z0-9][A-Z0-9][A-Z0-9]";
        String regex_length4_digit = "[0-9][A-Z][A-Z0-9][A-Z0-9]";

        String regex_length5_letter = "[A-Z][A-Z0-9][A-Z0-9][0-9][A-Z0-9]";
        String regex_length5_digit = "[0-9][A-Z][A-Z0-9][0-9][A-Z0-9]";

        String regex_length6_letter = "[A-Z][A-Z0-9][A-Z0-9][0-9][0-9][A-Z0-9]";
        String regex_length6_digit = "[0-9][A-Z][A-Z0-9][0-9][0-9][A-Z0-9]";

        String regex_length7_letter = "[A-Z][A-Z0-9][A-Z0-9][0-9][0-9][0-9][A-Z0-9]";
        String regex_length7_digit = "[0-9][A-Z][0-9][0-9][0-9][0-9][A-Z]";

        String regex_length_8 = "[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]";

        if (flightNumber != null) {
            Pattern pattern;
            boolean match;
            switch (flightNumber.length()) {
                case 0:
                case 1:
                case 2:
                    input_flight_number.setError(context.getString(R.string.invalidFlightNumber));
                    return false;
                case 3:
                    pattern = Pattern.compile(regex_length3);
                    match = pattern.matcher(flightNumber).matches();
                    if (match) {
                        input_flight_number.setError(null);
                    } else {
                        input_flight_number.setError(context.getString(R.string.invalidFlightNumber));
                        return false;
                    }
                    break;
                case 4:
                    if (android.text.TextUtils.isDigitsOnly(flightNumber.substring(0, 1))) {
                        pattern = Pattern.compile(regex_length4_digit);
                        match = pattern.matcher(flightNumber).matches();
                    } else {
                        pattern = Pattern.compile(regex_length4_letter);
                        match = pattern.matcher(flightNumber).matches();
                    }
                    if (match) {
                        input_flight_number.setError(null);
                    } else {
                        input_flight_number.setError(context.getString(R.string.invalidFlightNumber));
                        return false;
                    }
                    break;
                case 5:
                    if (android.text.TextUtils.isDigitsOnly(flightNumber.substring(0, 1))) {
                        pattern = Pattern.compile(regex_length5_digit);
                        match = pattern.matcher(flightNumber).matches();
                    } else {
                        pattern = Pattern.compile(regex_length5_letter);
                        match = pattern.matcher(flightNumber).matches();
                    }
                    if (match) {
                        input_flight_number.setError(null);
                    } else {
                        input_flight_number.setError(context.getString(R.string.invalidFlightNumber));
                        return false;
                    }
                    break;
                case 6:
                    if (android.text.TextUtils.isDigitsOnly(flightNumber.substring(0, 1))) {
                        pattern = Pattern.compile(regex_length6_digit);
                        match = pattern.matcher(flightNumber).matches();
                    } else {
                        pattern = Pattern.compile(regex_length6_letter);
                        match = pattern.matcher(flightNumber).matches();
                    }
                    if (match) {
                        input_flight_number.setError(null);
                    } else {
                        input_flight_number.setError(context.getString(R.string.invalidFlightNumber));
                        return false;
                    }
                    break;
                case 7:
                    if (android.text.TextUtils.isDigitsOnly(flightNumber.substring(0, 1))) {
                        pattern = Pattern.compile(regex_length7_digit);
                        match = pattern.matcher(flightNumber).matches();
                    } else {
                        pattern = Pattern.compile(regex_length7_letter);
                        match = pattern.matcher(flightNumber).matches();
                    }
                    if (match) {
                        input_flight_number.setError(null);
                    } else {
                        input_flight_number.setError(context.getString(R.string.invalidFlightNumber));
                        return false;
                    }
                    break;

                case 8:
                    pattern = Pattern.compile(regex_length_8);
                    match = pattern.matcher(flightNumber).matches();
                    if(match) {
                        input_flight_number.setError(null);
                    }else {
                        input_flight_number.setError(context.getString(R.string.invalidFlightNumber));
                        return false;
                    }
            }

        } else {
            return false;
        }

        if (flightDate == 0 || date[flightDate] == null || date[flightDate].equalsIgnoreCase("")) {
            ((TextView)dateSpinner.getChildAt(0)).setError(context.getString(R.string.invalidFlightNumber));
            return false;
        }
        return flightType != null && !flightType.equalsIgnoreCase("");
    }

    public static void dismissDialog() {
        if (dialog != null && dialog.isShowing()) {
            dialog.dismiss();
        }
        dialog = null;
        ourInstance = null;

    }

    public boolean isShown(){
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
