package aero.developer.bagnet.utils;

import android.content.Context;

import java.util.List;

import aero.developer.bagnet.connectivity.NetworkUtil;
import aero.developer.bagnet.interfaces.OnTrackBag;
import aero.developer.bagnet.interfaces.QueueCallBacks;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.objects.BagTagDao;
import aero.developer.bagnet.presenters.TrackingBagPresenter;
import aero.developer.bagnet.scantypes.EngineActivity;

/**
 * Created by User on 5/22/2017.
 */

public class SyncManager implements OnTrackBag {
    private Context context;
    private QueueCallBacks queueCallBacks;
    private boolean syncStarted = false;
    private boolean syncStarted1 = false;
    public SyncManager(Context _context, QueueCallBacks _queueCallBacks) {
        context = _context;
        this.queueCallBacks = _queueCallBacks;
    }

    public void start() {
        syncDataLoop();
    }

    public void stop() {
    }

    public void syncBag(BagTag bagTag) {
        TrackingBagPresenter trackingBagPresenter = new TrackingBagPresenter(this);
        trackingBagPresenter.trackBag(context, bagTag);
    }

    public void syncData() {
        BagLogger.log("syncStarted1 = " + syncStarted1);
        if (NetworkUtil.getConnectivityStatus(context) != NetworkUtil.NETWORK_STATUS_NOT_CONNECTED) {
//            if (!syncStarted1) {
                syncStarted1 = true;
                final BagTag bagTag = BagTagDBHelper.getInstance(context).getBagtagTag().queryBuilder().where(BagTagDao.Properties.Synced.eq(false))
                        .where(BagTagDao.Properties.Locked.eq(false))
                        .limit(1).unique();

                    if (bagTag != null) {
                        TrackingBagPresenter trackingBagPresenter = new TrackingBagPresenter(this);
                        trackingBagPresenter.trackBag(context, bagTag);
                    }
                   else {
                        syncStarted1 = false;
                        BagLogger.log("-Sync done syncing");
                    }
//                }
        }
    }



    private void syncDataLoop() {
        BagLogger.log("syncStarted = " + syncStarted);
        if (NetworkUtil.getConnectivityStatus(context) != NetworkUtil.NETWORK_STATUS_NOT_CONNECTED) {
//            if (!syncStarted) {
                syncStarted = true;
                List<BagTag> BagTagList = BagTagDBHelper.getInstance(context).getBagtagTag().queryBuilder().where(BagTagDao.Properties.Synced.eq(false)).where(BagTagDao.Properties.Locked.eq(false)).list();
//                final BagTag bagTag = BagTagDBHelper.getInstance(context).getBagtagTag().queryBuilder().where(BagTagDao.Properties.Synced.eq(false))
//                        .where(BagTagDao.Properties.Locked.eq(false))
//                        .limit(1).unique();
                for (int i =0 ; i<BagTagList.size() ; i++)
                {
                    if (BagTagList.get(i) != null) {
                        TrackingBagPresenter trackingBagPresenter = new TrackingBagPresenter(this);
                        BagTagList.get(i).setShowProgressBar(true);
                        trackingBagPresenter.trackBag(context, BagTagList.get(i));
                    }
                    if( i == BagTagList.size()-1 )
                        syncStarted = false;
                        BagLogger.log("-Sync done syncing");
                    }
//                   if( BagTagList.lastIndexOf(bagTagitem) == BagTagList.size()-1 )
//                   {
//                       syncStarted = false;
//                       BagLogger.log("-Sync done syncing");
//                   }
//                }

//                }
            }
        }

    public void resetAllStatus(String error, EngineActivity activity) {
        BagLogger.log("syncStarted = " + syncStarted);
        if (NetworkUtil.getConnectivityStatus(context) != NetworkUtil.NETWORK_STATUS_NOT_CONNECTED) {
            syncStarted = true;
            List<BagTag> BagTagList = BagTagDBHelper.getInstance(context).getBagtagTag().queryBuilder().where(BagTagDao.Properties.ErrorMsg.eq(error))
                    .list();
            for (int i =0 ; i<BagTagList.size() ; i++)
            {
                if (BagTagList.get(i) != null) {
                    BagTagList.get(i).setLocked(false);
                    BagTagList.get(i).setSynced(false);
                    activity.addBagTag(BagTagList.get(i));
                    TrackingBagPresenter trackingBagPresenter = new TrackingBagPresenter(this);
                    BagTagList.get(i).setShowProgressBar(true);
                    trackingBagPresenter.trackBag(context, BagTagList.get(i));
                }
                if( i == BagTagList.size()-1 )
                    syncStarted = false;
                BagLogger.log("-Sync done syncing");
            }
        }
    }



    @Override
    public void trackSuccess(BagTag bagTag) {
        bagTag.setSynced(true);
        BagTagDBHelper.getInstance(this.context).getBagtagTag().insertOrReplace(bagTag);
        if (queueCallBacks != null) {
            queueCallBacks.addBagTag(bagTag);
        }
        syncStarted = false;
        syncStarted1 = false;
        BagLogger.log("syncStarted  trackSuccess= " + syncStarted);
//        syncDataLoop();
    }

    @Override
    public void trackFailed(BagTag bagTag,String errorCode) {
        syncStarted = false;
        syncStarted1 = false;
        long id = BagTagDBHelper.getInstance(this.context).getBagtagTag().insertOrReplace(bagTag);
        BagLogger.log("Replaced ID = " + id);

        bagTag.setShowProgressBar(false);
        if (queueCallBacks != null) {
            queueCallBacks.addBagTag(bagTag);
        }
        BagLogger.log("-Sync failed : " + bagTag.getErrorMsg());
        BagLogger.log("syncStarted  trackSuccess= " + syncStarted);
//        syncDataLoop();
    }

    @Override
    public void onConnectionFailed(BagTag bagTag) {
        syncStarted = false;
        syncStarted1 = false;
        long id = BagTagDBHelper.getInstance(this.context).getBagtagTag().insertOrReplace(bagTag);
        BagLogger.log("Replaced ID = " + id);

        bagTag.setShowProgressBar(false);
        if (queueCallBacks != null) {
            queueCallBacks.addBagTag(bagTag);
        }
        BagLogger.log("-Sync failed : " + bagTag.getErrorMsg());
        BagLogger.log("syncStarted  trackSuccess= " + syncStarted);
    }
}
