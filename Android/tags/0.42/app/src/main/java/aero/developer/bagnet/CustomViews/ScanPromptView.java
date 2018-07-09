package aero.developer.bagnet.CustomViews;

import android.content.Context;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.util.AttributeSet;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import aero.developer.bagnet.R;

/**
 * Created by User on 08-Mar-18.
 */

public class ScanPromptView extends RelativeLayout {

    private HeaderTextView txt_title;
    HeaderTextView txt_description;
    private RelativeLayout mainContainer;
    private ImageView scanning_icon;
    public ScanPromptView(Context context) {
        super(context);
        init();
    }

    public ScanPromptView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public ScanPromptView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public ScanPromptView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init();
    }

    private void init() {
        inflate(getContext(), R.layout.scan_prompt_view, this);
        txt_title =  findViewById(R.id.txt_title);
        txt_description =  findViewById(R.id.txt_description);
        mainContainer =  findViewById(R.id.mainContainer);
        scanning_icon = findViewById(R.id.scanning_icon);
        setPromptForLocation();
    }

    public void hideView(){
        mainContainer.setVisibility(GONE);
    }

    public void showView() {
        mainContainer.setVisibility(VISIBLE);
    }

    public void setPromptForLocation(){
        showView();
        scanning_icon.setImageDrawable(getResources().getDrawable(R.drawable.scann));
        mainContainer.setBackgroundColor(getResources().getColor(R.color.disconnected));
        float scale = getResources().getDisplayMetrics().density;
        int dpAsPixels = (int) (10*scale + 0.5f);
        mainContainer.setPadding(dpAsPixels,dpAsPixels,dpAsPixels,dpAsPixels);

        txt_title.setVisibility(GONE);
        txt_description.setText(getContext().getString(R.string.scan_tracking));
        txt_description.setTextColor(getResources().getColor(R.color.white));
        txt_description.setTextSize(16);

    }

    public void setPromptForContainer(){
        showView();
        scanning_icon.setImageDrawable(getResources().getDrawable(R.drawable.container));
        mainContainer.setBackgroundColor(getResources().getColor(R.color.disconnected));
        float scale = getResources().getDisplayMetrics().density;
        int dpAsPixels = (int) (10*scale + 0.5f);
        mainContainer.setPadding(dpAsPixels,dpAsPixels,dpAsPixels,dpAsPixels);

        txt_title.setVisibility(VISIBLE);
        txt_title.setText(getContext().getString(R.string.container_required));
        txt_description.setText(getContext().getString(R.string.scan_container));
        txt_description.setTextColor(getResources().getColor(R.color.white_80));
        txt_description.setTextSize(16);

    }
    public void setPromptForContainersOnly(){
        showView();
        scanning_icon.setImageDrawable(getResources().getDrawable(R.drawable.container));
        mainContainer.setBackgroundColor(getResources().getColor(R.color.connected));
        float scale = getResources().getDisplayMetrics().density;
        int dpAsPixels = (int) (10*scale + 0.5f);
        mainContainer.setPadding(dpAsPixels,dpAsPixels,dpAsPixels,dpAsPixels);

        txt_title.setVisibility(GONE);
        txt_description.setVisibility(VISIBLE);
        txt_description.setText(getContext().getString(R.string.start_scan_containers));
        txt_description.setTextSize(16);
    }


    public void setPromptForBags(){
        showView();
        scanning_icon.setImageDrawable(getResources().getDrawable(R.drawable.suitcase_travel));
        mainContainer.setBackgroundColor(getResources().getColor(R.color.connected));
        float scale = getResources().getDisplayMetrics().density;
        int AsPixels_10 = (int) (10*scale + 0.5f);
        int AsPixels_5 = (int) (5*scale + 0.5f);
        mainContainer.setPadding(AsPixels_10,AsPixels_5,AsPixels_10,AsPixels_5);

        txt_title.setVisibility(VISIBLE);
        txt_title.setText(getContext().getString(R.string.start_scan_bags));
        txt_description.setText(getContext().getString(R.string.switch_container));
        txt_description.setTextColor(getResources().getColor(R.color.white_80));
        txt_description.setTextSize(13);
    }

}
