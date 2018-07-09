package aero.developer.bagnet.adapter;


import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;

import aero.developer.bagnet.R;
import aero.developer.bagnet.interfaces.OnBagTagListener;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.view_holders.BagTagViewHolder;

public class BagQueueWidgetAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {
    private static final int TYPE_ITEM = 0;
    private static final int TYPE_NULL = 1;
    private static final int TYPE_STRING = 2;
    public List<Object> bagTags = new ArrayList<>();
    Context context;

    public void setOnBagTagListener(OnBagTagListener onBagTagListener) {
        this.onBagTagListener = onBagTagListener;
    }

    OnBagTagListener onBagTagListener;

    public BagQueueWidgetAdapter(Context _context) {
        context = _context;
    }

    @Override
    public int getItemViewType(int position) {
        if (bagTags.get(position) == null) {
            return TYPE_NULL;
        }
        if (bagTags.get(position) instanceof BagTag) {
            return TYPE_ITEM;
        }
        if (bagTags.get(position) instanceof String) {
            return TYPE_STRING;
        }
        return -1;
    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        RecyclerView.ViewHolder holder = null;
        if (viewType == TYPE_ITEM || viewType == TYPE_NULL || viewType == TYPE_STRING) {
            View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.bag_tag, parent, false);
            holder = new BagTagViewHolder(v);
        }
        return holder;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        if (holder.getItemViewType() == TYPE_ITEM) {
            BagTagViewHolder bagHolder = (BagTagViewHolder) holder;
            bagHolder.setOnBagTagListener(this.onBagTagListener);
            bagHolder.bindData(bagTags.get(position));
        }
        if (holder.getItemViewType() == TYPE_NULL) {
            BagTagViewHolder bagHolder = (BagTagViewHolder) holder;
            bagHolder.bindData(null);
        }
        if (holder.getItemViewType() == TYPE_STRING) {
            BagTagViewHolder bagHolder = (BagTagViewHolder) holder;
            bagHolder.bindData("empty");
        }

    }

    @Override
    public int getItemCount() {
        return bagTags.size();
    }

    public void setBagTags(List<BagTag> _bagTags) {
        this.bagTags.clear();
        if (_bagTags.size() > 0) {
            this.bagTags.addAll(_bagTags);
        }
        this.bagTags.add("empty");
        this.bagTags.add("empty");
        notifyDataSetChanged();
    }

    public void addItem(BagTag bagTag) {
        int index = this.bagTags.indexOf(bagTag);
        //not found
        if (index == -1) {
            bagTags.add(bagTags.indexOf("empty"), bagTag);
            notifyItemInserted(bagTags.indexOf("empty"));
        } else { // found
            this.bagTags.remove(bagTag);
            notifyItemRemoved(index);
            this.bagTags.add(index, bagTag);
            notifyItemInserted(index);
        }
    }

}