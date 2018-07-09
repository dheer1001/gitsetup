package aero.developer.bagnet.CustomViews;


import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.connectivity.NetworkUtil;
import aero.developer.bagnet.interfaces.OnBagTagListener;
import aero.developer.bagnet.objects.BagTag;

public class BagTagWidget extends LinearLayout  {
    int progressStatus;
    OnBagTagListener onBagTagListener;
    TextView bagTagCode;
    ImageView bagTagImage;
    RelativeLayout bagTagLayout;

    public BagTagWidget(Context context) {
        super(context);
        init();
    }

    public BagTagWidget(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public BagTagWidget(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();

    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public BagTagWidget(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init();
    }

    public void setOnBagTagListener(OnBagTagListener onBagTagListener) {
        this.onBagTagListener = onBagTagListener;
    }

    private void init() {
        inflate(getContext(), R.layout.bag_tag_widget_layout, this);

    }

    public void setBagTag(final BagTag bagTag, final int _progressStatus) {
        bagTagLayout = (RelativeLayout) getRootView().findViewById(R.id.bagTagLayout);
        bagTagImage = (ImageView) getRootView().findViewById(R.id.bagtagimage);
        bagTagCode = (TextView) getRootView().findViewById(R.id.bag_tag_code);
        ImageView syncedImage = (ImageView) findViewById(R.id.syncedImage);
        if (bagTag != null) {
            progressStatus = _progressStatus;
            if (bagTag.getBagtag() != null && !bagTag.getBagtag().equalsIgnoreCase("")) {
                bagTagCode.setText(bagTag.getBagtag());
                bagTagImage.setImageResource(R.drawable.suitcase_travel);
            } else {
                bagTagCode.setText(bagTag.getContainerid());
                bagTagImage.setImageResource(R.drawable.container);
            }

            if (onBagTagListener != null) {
                    bagTagLayout.setOnClickListener(new OnClickListener() {
                        @Override
                        public void onClick(View v) {
                                onBagTagListener.onBagTagClicked(bagTag);
                            }
                    });
            }

            runProgress(bagTag);
            setIcon(bagTag, syncedImage);
        } else {
            bagTagLayout.setBackground(getResources().getDrawable(R.drawable.bag_tag_null_widget));
            bagTagImage.setVisibility(View.INVISIBLE);
            bagTagCode.setVisibility(View.INVISIBLE);
            syncedImage.setVisibility(INVISIBLE);
        }

        adjustColors();
    }

    public void runProgress(BagTag bagTag) {
        final ProgressBar bagTagProgress = (ProgressBar) getRootView().findViewById(R.id.bagTag_progressBar);
        if (NetworkUtil.getConnectivityStatus(getContext()) == NetworkUtil.NETWORK_STATUS_NOT_CONNECTED) {
            bagTagProgress.setVisibility(View.INVISIBLE);
            return;
        }
        if(bagTag.getLocked() &&  !bagTag.getSynced())
        {
            bagTagProgress.setVisibility(View.INVISIBLE);
            return;
        }
        if(bagTag.getSynced())
        {
            bagTagProgress.setVisibility(View.INVISIBLE);
            return;
        }
        if(bagTag.isShowProgressBar())
        {

//        if (!bagTag.getLocked() && ! bagTag.getSynced() && bagTag.getErrorMsg() != null &&  !bagTag.getErrorMsg().equals(getResources().getString(R.string.error_networkConnectionIssue)) ) {
            bagTagProgress.setVisibility(View.VISIBLE);
            bagTagProgress.setIndeterminate(true);
        } else {
            bagTagProgress.setVisibility(View.INVISIBLE);
        }
    }


    private void setIcon(BagTag bagTag, ImageView syncedImage) {
        if(bagTag.getLocked()) {
            syncedImage.setVisibility(VISIBLE);
            syncedImage.setImageResource(R.drawable.ic_no_sync);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                syncedImage.getDrawable().setTint(getResources().getColor(R.color.disconnected));
            }else {
                syncedImage.setImageDrawable(AppController.getTintedDrawable(syncedImage.getDrawable(),getResources().getColor(R.color.disconnected)));
            }
        }
        else if (bagTag.getSynced()) {
            syncedImage.setVisibility(VISIBLE);
            syncedImage.setImageResource(R.drawable.ic_cloud_done);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                syncedImage.getDrawable().setTint(AppController.getInstance().getPrimaryColor());
            } else {
                syncedImage.setImageDrawable(AppController.getTintedDrawable(syncedImage.getDrawable(),AppController.getInstance().getPrimaryColor()));
            }
        } else {
            syncedImage.setVisibility(VISIBLE);
            syncedImage.setImageResource(R.drawable.ic_cloud_off);
            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP) {
                syncedImage.getDrawable().setTint(AppController.getInstance().getPrimaryColor());
            } else {
                syncedImage.setImageDrawable(AppController.getTintedDrawable(syncedImage.getDrawable(),AppController.getInstance().getPrimaryColor()));
            }
        }
    }


    private void adjustColors() {
        bagTagCode.setTextColor(AppController.getInstance().getPrimaryColor());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            bagTagImage.getDrawable().setTint(AppController.getInstance().getbagImageColor());
        }else{
            bagTagImage.setImageDrawable(AppController.getTintedDrawable(bagTagImage.getDrawable(),AppController.getInstance().getbagImageColor()));
        }

        GradientDrawable bagTagLayout_drawable = (GradientDrawable)bagTagLayout.getBackground();
        bagTagLayout_drawable.setStroke(4,AppController.getInstance().getSecondaryColor());
        bagTagLayout_drawable.setColor(AppController.getInstance().getbagContainerColor());

    }



}
