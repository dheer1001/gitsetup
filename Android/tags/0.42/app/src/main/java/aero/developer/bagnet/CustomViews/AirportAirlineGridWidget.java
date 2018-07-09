package aero.developer.bagnet.CustomViews;

import android.content.Context;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.util.AttributeSet;
import android.widget.ImageView;
import android.widget.LinearLayout;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.utils.Preferences;

/**
 * Created by User on 09-Oct-17.
 */

public class AirportAirlineGridWidget extends LinearLayout {
    RecyclerView recycleView;
    GridLayoutManager mLayoutManager;
    LinearLayout mainContainer;
    LinearLayout parent_container;
    ImageView queueHeader;
    public AirportAirlineGridWidget(Context context) {
        super(context);
        init();
    }

    public AirportAirlineGridWidget(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public AirportAirlineGridWidget(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public AirportAirlineGridWidget(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init();
    }


    private void init() {
        inflate(getContext(), R.layout.airport_airline_gridwidget, this);
        if (!isInEditMode()) {
            mainContainer = (LinearLayout) findViewById(R.id.mainContainer);
            recycleView = (RecyclerView) findViewById(R.id.airport_airline_recycleView);
            parent_container = (LinearLayout) findViewById(R.id.parent_container);
            queueHeader = (ImageView) findViewById(R.id.queueHeader);

            mLayoutManager = new GridLayoutManager(getContext(), 2, StaggeredGridLayoutManager.VERTICAL, false);
            recycleView.setLayoutManager(mLayoutManager);
            adjustColors();

        }
    }

    private void adjustColors() {
        mainContainer.setBackgroundColor(AppController.getInstance().gridViewBackground());
        if(Preferences.getInstance().isNightMode(getContext()))
        queueHeader.setImageDrawable(getResources().getDrawable(R.drawable.queue_header_light));

    }

}
