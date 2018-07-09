package aero.developer.bagnet.CustomViews;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.util.AttributeSet;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.utils.Location_Utils;
import aero.developer.bagnet.utils.Preferences;
import aero.developer.bagnet.utils.Utils;

public class InfoWidget extends RelativeLayout implements SharedPreferences.OnSharedPreferenceChangeListener {

    private ImageView airplane_image;
    HeaderTextView infoWidgetText;
    public InfoWidget(Context context) {
        super(context);
        init();
    }

    public InfoWidget(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public InfoWidget(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();

    }


    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public InfoWidget(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init();
    }

     private void init(){
         inflate(getContext(), R.layout.info_widget_layout, this);
         if (!isInEditMode()) {
             Preferences.getSharedPreferences(getContext()).registerOnSharedPreferenceChangeListener(this);
             airplane_image = (ImageView) findViewById(R.id.airplane_image);
             airplane_image.bringToFront();
             infoWidgetText = (HeaderTextView) findViewById(R.id.infoWidgetText);


             setInfo();
         }
     }

    @Override
    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
        if (key.equalsIgnoreCase(Preferences.FLIGHTNUMBER)) {
            setInfo();
        }
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        Preferences.getSharedPreferences(getContext()).unregisterOnSharedPreferenceChangeListener(this);
    }

    private void setInfo() {
        String flightNumber = Preferences.getInstance().getFlightNumber(getContext());
        String airportCode = Preferences.getInstance().getAirportcode(getContext());
        String flightType = Preferences.getInstance().getFlightType(getContext());
        String flightDate = Preferences.getInstance().getFlightDate(getContext());
        if (flightDate!=null && flightNumber!=null && flightType!=null) {
            String airportPair;

            String locationAirport = Location_Utils.getAirportCode(Preferences.getInstance().getTrackingLocation(getContext()));
            if (flightType != null && flightType.equalsIgnoreCase("d")) {
                airportPair = getContext().getString(R.string.departing, locationAirport);
            } else {
                airportPair = getContext().getString(R.string.arriving, locationAirport);
            }
            String fullString = flightNumber + " " + airportPair + "\n" + Utils.formatDate(flightDate, Utils.DATE_FORMAT, Utils.INFO_DATE_FORMAT);
            infoWidgetText.setText(fullString);
            setVisibility(VISIBLE);
        }else{
            this.postDelayed(new Runnable() {
                @Override
                public void run() {
                    setVisibility(INVISIBLE);
                }
            }, 100);

        }
        adjustColors();
    }
    private void adjustColors() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            DrawableCompat.setTint(airplane_image.getDrawable(), AppController.getInstance().getSecondaryGrayColor());
        } else {
            airplane_image.setImageDrawable(AppController.getTintedDrawable(airplane_image.getDrawable(),AppController.getInstance().getSecondaryGrayColor()));
        }
        infoWidgetText.setTextColor(AppController.getInstance().getPrimaryColor());
        GradientDrawable infoWidgetText_drawable = (GradientDrawable)infoWidgetText.getBackground();
        infoWidgetText_drawable.setStroke(1,AppController.getInstance().getSecondaryGrayColor());
        infoWidgetText_drawable.setColor(AppController.getInstance().getPrimaryGrayColor());

    }
}
