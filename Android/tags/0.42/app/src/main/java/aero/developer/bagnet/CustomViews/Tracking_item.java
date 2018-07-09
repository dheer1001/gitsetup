package aero.developer.bagnet.CustomViews;

import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.utils.Preferences;

/**
 * Created by User on 10-Jan-18.
 */

public class Tracking_item  extends LinearLayout{
    TextView description,tracking_id,location;
    RelativeLayout main_container;

    public Tracking_item(Context context) {
        super(context);
        init();
    }

    public Tracking_item(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public Tracking_item(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    public void init() {
        inflate(getContext(), R.layout.tracking_item, this);
        tracking_id = (TextView) findViewById(R.id.tracking_id);
        location = (TextView) findViewById(R.id.location);
        description = (TextView) findViewById(R.id.description);
        main_container = (RelativeLayout) findViewById(R.id.main_container);
        adjustColors();
    }

    public void setData(String Tracking_id,String Location,String Description) {
       if(Tracking_id!=null) {
           tracking_id.setText(Tracking_id.trim());
       }
        if(Location!=null) {
            location.setText(Location.trim());

        }
        if(Description!=null && !Description.equalsIgnoreCase("")) {
            description.setText(Description.trim());
        }else {
            description.setText("");
        }

    }
    private void adjustColors() {
        GradientDrawable main_container_drawable = (GradientDrawable) main_container.getBackground();
        if(Preferences.getInstance().isNightMode(getContext())) {
            main_container_drawable.setStroke(4, AppController.getInstance().getSecondaryColor());
        }
        main_container_drawable.setColor(AppController.getInstance().getheaderViewColor());
        tracking_id.setTextColor(AppController.getInstance().getPrimaryColor());
            location.setTextColor(AppController.getInstance().getPrimaryColor());
            description.setTextColor(AppController.getInstance().getPrimaryColor());
    }
}
