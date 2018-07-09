package aero.developer.bagnet.objects;

import android.database.sqlite.SQLiteDatabase;

import java.util.Map;

import de.greenrobot.dao.AbstractDao;
import de.greenrobot.dao.AbstractDaoSession;
import de.greenrobot.dao.identityscope.IdentityScopeType;
import de.greenrobot.dao.internal.DaoConfig;

import aero.developer.bagnet.objects.BagTag;

import aero.developer.bagnet.objects.BagTagDao;

// THIS CODE IS GENERATED BY greenDAO, DO NOT EDIT.

/**
 * {@inheritDoc}
 * 
 * @see de.greenrobot.dao.AbstractDaoSession
 */
public class DaoSession extends AbstractDaoSession {

    private final DaoConfig bagTagDaoConfig;

    private final BagTagDao bagTagDao;

    public DaoSession(SQLiteDatabase db, IdentityScopeType type, Map<Class<? extends AbstractDao<?, ?>>, DaoConfig>
            daoConfigMap) {
        super(db);

        bagTagDaoConfig = daoConfigMap.get(BagTagDao.class).clone();
        bagTagDaoConfig.initIdentityScope(type);

        bagTagDao = new BagTagDao(bagTagDaoConfig, this);

        registerDao(BagTag.class, bagTagDao);
    }
    
    public void clear() {
        bagTagDaoConfig.getIdentityScope().clear();
    }

    public BagTagDao getBagTagDao() {
        return bagTagDao;
    }

}
