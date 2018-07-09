package aero.developer.bagnet.CustomViews;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.util.AttributeSet;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.squareup.picasso.Picasso;

import org.json.JSONObject;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.utils.DataManUtils;
import aero.developer.bagnet.utils.Location_Utils;
import aero.developer.bagnet.utils.Preferences;
import aero.developer.bagnet.utils.ULD_Utils;

public class ContainerWidget extends LinearLayout implements SharedPreferences.OnSharedPreferenceChangeListener {

ImageView image_uld;
    SingleLine_AutoResizeTextView uld_name;
    HeaderTextView uld_size;
    HeaderTextView uld_type;
    HeaderTextView uld_contour;
    HeaderTextView container_ULD;
    RelativeLayout parent_container;
    HeaderTextView base_size_title,uld_contour_title,uld_type_title;
    public ContainerWidget(Context context) {
        super(context);
        init();
    }
    public ContainerWidget(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public ContainerWidget(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();

    }


    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public ContainerWidget(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init();
    }

    private void init(){
        inflate(getContext(), R.layout.container_widget_layout, this);
        if (!isInEditMode()) {
            image_uld = (ImageView) getRootView().findViewById(R.id.uld_image);
            uld_name = (SingleLine_AutoResizeTextView) getRootView().findViewById(R.id.uld_name);
            uld_size = (HeaderTextView) getRootView().findViewById(R.id.base_size_variable);
            uld_type = (HeaderTextView) getRootView().findViewById(R.id.uld_type_variable);
            uld_contour = (HeaderTextView) getRootView().findViewById(R.id.uld_contour_variable);
            container_ULD = (HeaderTextView) getRootView().findViewById(R.id.container_ULD);
            parent_container = (RelativeLayout) getRootView().findViewById(R.id.parent_container);
            base_size_title = (HeaderTextView) getRootView().findViewById(R.id.base_size);
            uld_contour_title = (HeaderTextView) getRootView().findViewById(R.id.uld_contour);
            uld_type_title = (HeaderTextView) getRootView().findViewById(R.id.uld_type);

            setContainerWidget();
            Preferences.getSharedPreferences(getContext()).registerOnSharedPreferenceChangeListener(this);
        }

    }

    public void setContainerWidget(){
        String trackingLocation = Preferences.getInstance().getTrackingLocation(getContext());
        String containerInput = Location_Utils.getContainerInput(trackingLocation);
        String containerUld = Preferences.getInstance().getContaineruld(getContext()).toUpperCase();
        try {
            if (!containerUld.equals("") && DataManUtils.isValidContainer(containerUld) && containerInput != null && !containerInput.equalsIgnoreCase("C")) {
                //ULD_Utils.
                container_ULD.setText(containerUld);
                String Uldtype = ULD_Utils.getContainerTypeChar(ULD_Utils.getULDType(containerUld));
                Picasso.with(getContext()).load(ULD_Utils.getImage(Uldtype)).into(image_uld);
                uld_name.setText(ULD_Utils.container_GetType(getContext(), Uldtype));
                String ContainerSize = ULD_Utils.container_GetSize(getContext(), ULD_Utils.getContainerSizeChar(ULD_Utils.getULDType(containerUld)));
                uld_size.setText(" " + ContainerSize.substring(0, ContainerSize.indexOf("/")));
                JSONObject contourJson = ULD_Utils.container_GetContour(getContext(), ULD_Utils.getContainerContourChar(ULD_Utils.getULDType(containerUld)));

                String Width_Size = null,Height_Size = null;
                String contourWidth = ULD_Utils.getContourWidth(contourJson);
                if(contourWidth != null ) {
                    Width_Size = contourWidth.substring(0, contourWidth.indexOf("mm"));
                }
                String contourHeight = ULD_Utils.getContourHeight(contourJson);
                if(contourHeight != null) {
                    Height_Size = contourHeight.substring(0, contourHeight.indexOf("mm"));
                }
                uld_contour.setText(" " + Width_Size + " x " + Height_Size + " mm ");
                uld_type.setText(" " + ULD_Utils.getContourType(contourJson));
                setVisibility(VISIBLE);
            } else {
                this.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        setVisibility(INVISIBLE);
                    }
                }, 100);
            }
        }  catch (NullPointerException e){
            e.printStackTrace();
        }
        adjustColor();
    }

    @Override
    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
        if (key.equalsIgnoreCase(Preferences.CONTAINERULD)) {
            setContainerWidget();
        }
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        Preferences.getSharedPreferences(getContext()).unregisterOnSharedPreferenceChangeListener(this);
    }

    private void adjustColor() {

        GradientDrawable parent_container_drawable = (GradientDrawable) parent_container.getBackground();
        parent_container_drawable.setStroke(1, AppController.getInstance().getSecondaryGrayColor());
        parent_container_drawable.setColor(AppController.getInstance().getPrimaryGrayColor());
        container_ULD.setTextColor(AppController.getInstance().getPrimaryColor());
        uld_name.setTextColor(AppController.getInstance().getPrimaryColor());
        base_size_title.setTextColor(AppController.getInstance().getPrimaryColor());
        uld_contour_title.setTextColor(AppController.getInstance().getPrimaryColor());
        uld_type_title.setTextColor(AppController.getInstance().getPrimaryColor());

        uld_size.setTextColor(AppController.getInstance().getSecondaryGrayColor());
        uld_contour.setTextColor(AppController.getInstance().getSecondaryGrayColor());
        uld_type.setTextColor(AppController.getInstance().getSecondaryGrayColor());
    }
}
