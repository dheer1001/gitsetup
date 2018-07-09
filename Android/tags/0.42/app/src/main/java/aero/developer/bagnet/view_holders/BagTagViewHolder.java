package aero.developer.bagnet.view_holders;

import android.support.v7.widget.RecyclerView;
import android.view.View;

import aero.developer.bagnet.CustomViews.BagTagWidget;
import aero.developer.bagnet.R;
import aero.developer.bagnet.interfaces.OnBagTagListener;
import aero.developer.bagnet.objects.BagTag;

/**
 * Created by user on 8/10/2016.
 */
public class BagTagViewHolder extends RecyclerView.ViewHolder {
BagTagWidget bagTagWidget;

    public void setOnBagTagListener(OnBagTagListener onBagTagListener) {
        this.onBagTagListener = onBagTagListener;
    }

    OnBagTagListener onBagTagListener;
    public BagTagViewHolder(View itemView) {
        super(itemView);
        bagTagWidget=(BagTagWidget) itemView.findViewById(R.id.bag_tag);
    }

    public void bindData(Object bagTag) {
        bagTagWidget.setOnBagTagListener(this.onBagTagListener);
        if (bagTag != null && bagTag instanceof BagTag) {
            bagTagWidget.setVisibility(View.VISIBLE);
            bagTagWidget.setBagTag((BagTag)bagTag,0);
        }
        else if(bagTag==null){
            bagTagWidget.setVisibility(View.VISIBLE);
           bagTagWidget.setBagTag(null,0);
        }
        else{
            bagTagWidget.setVisibility(View.INVISIBLE);
        }

    }
}
