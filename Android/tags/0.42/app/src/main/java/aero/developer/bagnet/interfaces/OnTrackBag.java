package aero.developer.bagnet.interfaces;

import aero.developer.bagnet.objects.BagTag;

/**
 * Created by User on 8/19/2016.
 */
public interface OnTrackBag {
    void trackSuccess(BagTag bagTag);

    void trackFailed(BagTag bagTag,String errorCode);

    void onConnectionFailed(BagTag bagTag);
}
