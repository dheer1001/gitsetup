package aero.developer.bagnet.interfaces;

import aero.developer.bagnet.objects.BagTag;

/**
 * Created by User on 8/23/2016.
 */
public interface OnBagTagListener {
    void onBagTagClicked(BagTag bagTag);
    void onResetStatusClicked(BagTag bagTag);
    void onRemoveBagClicked(BagTag bagTag);
    void onDeleteAllSimilarClicked(BagTag bagTag);
    void onTryAgainClicked( BagTag bagTag);
}
