package aero.developer.bagnet.utils;

import android.content.Context;

import aero.developer.bagnet.objects.BagTagDao;
import aero.developer.bagnet.objects.DaoMaster;
import aero.developer.bagnet.objects.DaoSession;

/**
 * Created by User on 8/8/2016.
 */
public class BagTagDBHelper {
    private static DaoSession daoSession;
    private static DaoMaster daoMaster;
    private static BagTagDBHelper mInstance=null;
    private Context context;
    private static DaoMaster.DevOpenHelper helper;
    private static String DB_NAME="BAGJOURNY_NETSCAN";

    public BagTagDBHelper(Context context) {
        this.context = context;
    }

    public static BagTagDBHelper getInstance(Context context){
        if (mInstance==null){
            mInstance = new BagTagDBHelper(context);
            helper = new DaoMaster.DevOpenHelper(context, DB_NAME, null);
            daoMaster = new DaoMaster(helper.getWritableDatabase());
            daoSession = daoMaster.newSession();
        }
        return mInstance;
    }

    public DaoSession getDaoSession() {
        if (daoSession == null) {
            if (helper == null) {
                helper = new DaoMaster.DevOpenHelper(this.context, DB_NAME, null);
            }
            if (daoMaster == null) {
                daoMaster = new DaoMaster(helper.getWritableDatabase());
            }

            daoSession = daoMaster.newSession();
        }
        return daoSession;
    }
    public BagTagDao getBagtagTag() {
        return getDaoSession().getBagTagDao();
    }
}
