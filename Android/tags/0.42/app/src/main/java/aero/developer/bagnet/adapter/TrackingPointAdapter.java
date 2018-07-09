package aero.developer.bagnet.adapter;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.HashMap;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.CustomViews.CustomButton;
import aero.developer.bagnet.CustomViews.Tracking_item;
import aero.developer.bagnet.R;
import aero.developer.bagnet.dialogs.SelectTrackingFragment;
import aero.developer.bagnet.interfaces.RefreshCallback;
import aero.developer.bagnet.objects.TrackingConfiguration;
import aero.developer.bagnet.presenters.TrackingPointPresenter;
import aero.developer.bagnet.scantypes.EngineActivity;
import aero.developer.bagnet.utils.Preferences;

/**
 * Created by User on 09-Jan-18.
 */

public class TrackingPointAdapter extends RecyclerView.Adapter {
    private Context context;
    private Activity activity;
    private ArrayList<Object> list;
    public static final int TitleViewHolder = 1;
    private static final int ItemViewHolder = 2;
    public static final int HorizontalDividerViewHolder = 3;
    public static final int RefreshViewHolder = 4;
    public static final int ClearViewHolder = 5;
    public static final int RecentlyUsed_Title = 6;

    public TrackingPointAdapter(Context context, Activity activity, ArrayList<Object> list) {
        this.context = context;
        this.activity = activity;
        this.list = list;
    }
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if(viewType == RecentlyUsed_Title) {
            RecyclerView.ViewHolder holder ;
            View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.tracking_title_item, parent, false);
            holder = new TitleViewHolder(v);
            return holder;
        }
       if(viewType == ClearViewHolder) {
           RecyclerView.ViewHolder holder ;
           View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.tracking_clear_item, parent, false);
           holder = new ClearViewHolder(v);
           return holder;
       }
        if (viewType == TitleViewHolder) {
            RecyclerView.ViewHolder holder ;
            View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.tracking_title_item, parent, false);
            holder = new TitleViewHolder(v);
            return holder;

        }
        if(viewType == ItemViewHolder) {
            RecyclerView.ViewHolder holder ;
            View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.tracking_list_item, parent, false);
            holder = new ItemViewHolder(v);
            return holder;
        }
        if(viewType == HorizontalDividerViewHolder) {
            RecyclerView.ViewHolder holder ;
            View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.horizontal_divider, parent, false);
            holder = new HorizontalDividerViewHolder(v);
            return holder;
        }
        else
        {
            RecyclerView.ViewHolder holder ;
            View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.refresh_tracking, parent, false);
            holder = new RefreshViewHolder(v);
            return holder;
        }
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder holder, @SuppressLint("RecyclerView") final int position) {
        int type = getItemViewType(position);
        if(type == TitleViewHolder || type == RecentlyUsed_Title) {
            ((TitleViewHolder) holder).title.setText(list.get(position).toString());
        }
        if(type == ItemViewHolder) {
            ((ItemViewHolder)holder).tracking_item.setData(((TrackingConfiguration)list.get(position)).getTracking_id(),
                    ((TrackingConfiguration)list.get(position)).getLocation(),((TrackingConfiguration)list.get(position)).getDescription());
            ((ItemViewHolder) holder).tracking_item.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Gson gson = new Gson();
                    String key = Preferences.getInstance().getUserID(context)+"@"+Preferences.getInstance().getCompanyID(context);
                    // first item in preference
                    if(Preferences.getInstance().getRecentlyUsedTracking(context) == null) {
                        HashMap<String, String>  map_list = new HashMap<>();
                        if(list.get(position) !=null) {
                            ArrayList<TrackingConfiguration> temp = new ArrayList<>();
                            temp.add((TrackingConfiguration) list.get(position));
                            map_list.put(key, gson.toJson(temp) );
                            String finalMap = gson.toJson(map_list);
                            Preferences.getInstance().setRecentlyUsedTracking(context, finalMap);
                        }
                    }else {// appending preference map
                        String mapString = Preferences.getInstance().getRecentlyUsedTracking(context);
                        HashMap<String, String> map = new HashMap<>();
                        map = (HashMap<String, String>) gson.fromJson(mapString, map.getClass());
                        ArrayList<TrackingConfiguration> listToAdd;
                        listToAdd = gson.fromJson(map.get(key), new TypeToken<ArrayList<TrackingConfiguration>>() {
                        }.getType());

                        if (listToAdd == null) {
                            ArrayList<TrackingConfiguration> temp = new ArrayList<>();
                            temp.add((TrackingConfiguration) list.get(position));
                            map.put(key, gson.toJson(temp) );
                            String finalMap = gson.toJson(map);
                            Preferences.getInstance().setRecentlyUsedTracking(context, finalMap);
                        } else {
                            if (AppController.getInstance().isTrackingExistInList
                                    (AppController.getInstance().prepareTrackingPoint(((TrackingConfiguration) list.get(position))), listToAdd)) {
                                listToAdd = AppController.getInstance().moveSelectedToHead(AppController.getInstance().prepareTrackingPoint(((TrackingConfiguration) list.get(position))), listToAdd);
                            } else {
                                if (listToAdd.size() < 4) {
                                    listToAdd.add(0, (TrackingConfiguration) list.get(position));
                                } else {
                                    listToAdd.remove(listToAdd.size() - 1);
                                    listToAdd.add(0, (TrackingConfiguration) list.get(position));
                                }
                            }
                            map.put(key, gson.toJson(listToAdd));
                            Preferences.getInstance().setRecentlyUsedTracking(context, gson.toJson(map));
                        }
                    }

                    ((EngineActivity) activity).onBarcodeScanned(AppController.getInstance().prepareTrackingPoint(((TrackingConfiguration)list.get(position))));
                    SelectTrackingFragment.getInstance().hideDialog();
                }
            });
        }
        if(type == ClearViewHolder) {
            ((TrackingPointAdapter.ClearViewHolder) holder).txt_clear.setGravity(Gravity.END);
            ((TrackingPointAdapter.ClearViewHolder) holder).txt_clear.setTextColor(AppController.getInstance().getPrimaryOrangeColor());
            ((TrackingPointAdapter.ClearViewHolder) holder).txt_clear.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    // clear only recently used tracking for logged in user
                    String key = Preferences.getInstance().getUserID(context)+"@"+Preferences.getInstance().getCompanyID(context);
                    Gson gson = new Gson();
                    String mapString = Preferences.getInstance().getRecentlyUsedTracking(context);
                    HashMap<String, String> map = new HashMap<>();
                    map = (HashMap<String, String>) gson.fromJson(mapString, map.getClass());
                    map.remove(key);
                    Preferences.getInstance().setRecentlyUsedTracking(context, gson.toJson(map));
                    SelectTrackingFragment.getInstance().preparelist();
                }
            });
        }
        if(type == RefreshViewHolder) {
            ((TrackingPointAdapter.RefreshViewHolder) holder).btn_refresh.setTextColor(AppController.getInstance().getPrimaryColor());
            if(Preferences.getInstance().isNightMode(context)) {
                ((TrackingPointAdapter.RefreshViewHolder) holder).btn_refresh.setBackground(context.getResources().getDrawable(R.drawable.gray_background));
            }else {
                ((TrackingPointAdapter.RefreshViewHolder) holder).btn_refresh.setBackground(context.getResources().getDrawable(R.drawable.dark_gray_background));
            }

            ((TrackingPointAdapter.RefreshViewHolder) holder).btn_refresh.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    ((TrackingPointAdapter.RefreshViewHolder) holder).progress.setVisibility(View.VISIBLE);
                    ((TrackingPointAdapter.RefreshViewHolder) holder).btn_refresh.setText("");

                    TrackingPointPresenter trackingPointPresenter = new TrackingPointPresenter(context);
                    trackingPointPresenter.TrackingLoopCalls(new RefreshCallback() {
                        @Override
                        public void onFinished() {
                            ((TrackingPointAdapter.RefreshViewHolder) holder).progress.setVisibility(View.GONE);
                            ((TrackingPointAdapter.RefreshViewHolder) holder).btn_refresh.setText(context.getResources().getString(R.string.refresh));

                            SelectTrackingFragment.getInstance().preparelist();

                            if(!AppController.getInstance().isSelectedAirportHaveTrackingConfigurations()) {
                                    SelectTrackingFragment.getInstance().hideDialog();
                            }
                        }
                    });
                }
            });
        }
    }

    @Override
    public int getItemViewType(int position) {

        if(list.get(position) instanceof TrackingConfiguration) {
            return ItemViewHolder;
        }
        if(list.get(position) instanceof String) {
            if(list.get(position).equals(context.getResources().getString(R.string.recently_used))) {
                return RecentlyUsed_Title;
            }
            if( list.get(position).equals(context.getResources().getString(R.string.clear))) {
                return ClearViewHolder;
            }
            return TitleViewHolder;
        }
        if(list.get(position) instanceof Integer) {
            switch ((Integer)list.get(position)) {
                case HorizontalDividerViewHolder:
                    return HorizontalDividerViewHolder;
                case RefreshViewHolder:
                    return RefreshViewHolder;
            }
        }
        return 0;
    }

    @Override
    public int getItemCount() {
        return list.size();
    }

    public class ItemViewHolder extends RecyclerView.ViewHolder {
        Tracking_item tracking_item;
        public ItemViewHolder(View itemView) {
            super(itemView);
            tracking_item = (Tracking_item) itemView.findViewById(R.id.tracking_item);
        }
    }

    public class TitleViewHolder extends RecyclerView.ViewHolder {
        TextView title;
        public TitleViewHolder(View itemView) {
            super(itemView);
           title = (TextView) itemView.findViewById(R.id.title);
        }
    }

    public class ClearViewHolder extends RecyclerView.ViewHolder {
        TextView txt_clear;
        public ClearViewHolder(View itemView) {
            super(itemView);
            txt_clear = (TextView) itemView.findViewById(R.id.txt_clear);
        }
    }

    public class HorizontalDividerViewHolder extends RecyclerView.ViewHolder {
        public HorizontalDividerViewHolder(View itemView) {
            super(itemView);
        }
    }

    public class RefreshViewHolder extends RecyclerView.ViewHolder {
        CustomButton btn_refresh;
        ProgressBar progress;
        public RefreshViewHolder(View itemView) {
            super(itemView);
            btn_refresh = itemView.findViewById(R.id.btn_refresh);
            progress = (ProgressBar) itemView.findViewById(R.id.progress);
        }
    }

}
