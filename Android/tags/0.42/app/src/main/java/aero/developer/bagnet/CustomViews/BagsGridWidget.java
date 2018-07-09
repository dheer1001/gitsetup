package aero.developer.bagnet.CustomViews;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.util.AttributeSet;
import android.widget.ImageView;
import android.widget.LinearLayout;

import java.util.ArrayList;
import java.util.List;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.adapter.BagQueueWidgetAdapter;
import aero.developer.bagnet.interfaces.OnBagTagListener;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.objects.BagTagDao;
import aero.developer.bagnet.utils.BagTagDBHelper;
import aero.developer.bagnet.utils.Preferences;

public class BagsGridWidget extends LinearLayout {
    BagQueueWidgetAdapter adapter;
    RecyclerView recycleView;
    HeaderTextView queueItems;
    GridLayoutManager mLayoutManager;
    LinearLayout mainContainer;
    LinearLayout parent_container;
    ImageView queueHeader;
    public void setOnBagTagListener(OnBagTagListener onBagTagListener) {
        this.onBagTagListener = onBagTagListener;
        adapter.setOnBagTagListener(this.onBagTagListener);
    }

    OnBagTagListener onBagTagListener;

    public BagsGridWidget(Context context) {
        super(context);
        init();
    }
    public BagsGridWidget(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }
    public BagsGridWidget(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }
    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public BagsGridWidget(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init();
    }

    private void init() {
        inflate(getContext(), R.layout.bags_widget_layout, this);
        if (!isInEditMode()) {
            mainContainer = (LinearLayout) findViewById(R.id.mainContainer);
            recycleView = (RecyclerView) findViewById(R.id.bag_tag_recycleView);
            queueItems = (HeaderTextView) findViewById(R.id.queue_items);
            parent_container = (LinearLayout) findViewById(R.id.parent_container);
            queueHeader = (ImageView) findViewById(R.id.queueHeader);
            adapter = new BagQueueWidgetAdapter(getContext());
            mLayoutManager = new GridLayoutManager(getContext(), 2, StaggeredGridLayoutManager.HORIZONTAL, false);
            recycleView.setLayoutManager(mLayoutManager);
            recycleView.setAdapter(adapter);
            initBags();
            adapter.setOnBagTagListener(this.onBagTagListener);
            adjustColors();

        }
    }

    public void initBags(){
        final List<BagTag> bagTags = BagTagDBHelper.getInstance(getContext()).getBagtagTag().queryBuilder().list();
        if(bagTags.size() == 0) {
            mainContainer.setVisibility(INVISIBLE);
        } else {
            mainContainer.setVisibility(VISIBLE);
        }
        adapter.setBagTags(bagTags);
        this.postDelayed(new Runnable() {
            @Override
            public void run() {
                recycleView.smoothScrollToPosition(bagTags.size());
            }
        }, 100);
        setQueueHeader();


    }

    public void addBagTag(BagTag bagTag) {
        adapter.addItem(bagTag);
        this.postDelayed(new Runnable() {
            @Override
            public void run() {
                recycleView.smoothScrollToPosition(adapter.getItemCount());
            }
        }, 100);

        final List<BagTag> bagTags = BagTagDBHelper.getInstance(getContext()).getBagtagTag().queryBuilder().list();
        if(bagTags.size() == 0) {
            mainContainer.setVisibility(INVISIBLE);
        } else {
            mainContainer.setVisibility(VISIBLE);
        }
        setQueueHeader();

    }

    public void resetBags(){
        adapter.setBagTags(new ArrayList<BagTag>());
    }


    public void setQueueHeader() {
        long count = BagTagDBHelper.getInstance(getContext()).getBagtagTag().queryBuilder().where(BagTagDao.Properties.Synced.eq(false)).count();
        if (count == 0) {
            queueItems.setText(null);
        } else {
            queueItems.setText(getContext().getString(count > 1 ? R.string.items_in_queue : R.string.item_in_queue, count));
        }
    }

    private void adjustColors() {
        mainContainer.setBackgroundColor(AppController.getInstance().gridViewBackground());
        queueItems.setTextColor(AppController.getInstance().getPrimaryColor());

        if(Preferences.getInstance().isNightMode(getContext()))
            queueHeader.setImageDrawable(getResources().getDrawable(R.drawable.queue_header_light));
    }
}
