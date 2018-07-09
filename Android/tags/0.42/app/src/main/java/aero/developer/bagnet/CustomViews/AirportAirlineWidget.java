package aero.developer.bagnet.CustomViews;

import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.util.AttributeSet;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.utils.Preferences;

/**
 * Created by User on 09-Oct-17.
 */

public class AirportAirlineWidget extends LinearLayout {
    private TextView name;
    private RelativeLayout airport_airline_Layout;
    public AirportAirlineWidget(Context context) {
        super(context);
        init();
    }

    public AirportAirlineWidget(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public AirportAirlineWidget(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();

    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public AirportAirlineWidget(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init();
    }

    private void init() {
        inflate(getContext(), R.layout.airport_airline_widget, this);
        airport_airline_Layout = (RelativeLayout) findViewById(R.id.airport_airline_Layout);
        name = (TextView) findViewById(R.id.name);

        adjustColors();
    }

    public void setData(String Name)
    {
        name.setText(Name);
    }

    private void adjustColors() {
        GradientDrawable airport_airlineLayout_drawable = (GradientDrawable)airport_airline_Layout.getBackground();
        if(Preferences.getInstance().isNightMode(getContext())) {
            airport_airlineLayout_drawable.setStroke(4, AppController.getInstance().getSecondaryColor());
        }
        airport_airlineLayout_drawable.setColor(AppController.getInstance().getheaderViewColor());

        name.setTextColor(AppController.getInstance().getPrimaryColor());

    }
}
