package aero.developer.bagnet.interfaces;

import aero.developer.bagnet.objects.BagTag;

/**
 * Created by User on 5/22/2017.
 */

public interface ReadStringListener {
    void onTrackingLocationScannedExtraActions(String trackingLocation);
    void onContainerScannedExtraActions(String container);

    void onBagScannedExtraActions(BagTag bagTag);
    void whatToDoAfterContainerScanExtraActions(String containerInput);
}
