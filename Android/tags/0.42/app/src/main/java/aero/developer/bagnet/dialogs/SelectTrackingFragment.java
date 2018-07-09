package aero.developer.bagnet.dialogs;

import android.content.DialogInterface;
import android.os.Build;
import android.os.Bundle;
import android.support.design.widget.AppBarLayout;
import android.support.v4.app.DialogFragment;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.CustomViews.TrackingGridWidget;
import aero.developer.bagnet.R;
import aero.developer.bagnet.adapter.TrackingPointAdapter;
import aero.developer.bagnet.objects.TrackingConfiguration;
import aero.developer.bagnet.utils.Preferences;

import static aero.developer.bagnet.adapter.TrackingPointAdapter.HorizontalDividerViewHolder;
import static aero.developer.bagnet.adapter.TrackingPointAdapter.RefreshViewHolder;
import static aero.developer.bagnet.adapter.TrackingPointAdapter.TitleViewHolder;
import static aero.developer.bagnet.presenters.TrackingPointPresenter.CONFIGURATIONS;

/**
 * Created by User on 09-Jan-18.
 */

public class SelectTrackingFragment extends DialogFragment {
    private static SelectTrackingFragment instance;
    private View rootview;
    private TextView txt_welcome,txt_name,txt_serviceId,txt_select_tracking;
    private LinearLayout mainContainer;
    private RelativeLayout upperContainer;
    private ImageView ic_location,ic_close;
    private TrackingGridWidget trackingrecyclerView;
    private RecyclerView tracking_recycleView;
    private AppBarLayout app_bar;

    public static SelectTrackingFragment getInstance() {
        if (instance == null) {
            instance = new SelectTrackingFragment();
        }
        return instance;
    }

    public SelectTrackingFragment() {}

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(STYLE_NO_FRAME, R.style.AppTheme);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        rootview = inflater.inflate(R.layout.fragment_select_tracking, container, false);

        ic_close = ( ImageView) rootview.findViewById(R.id.ic_close);
        mainContainer = (LinearLayout) rootview.findViewById(R.id.mainContainer);
        upperContainer = (RelativeLayout) rootview.findViewById(R.id.upperContainer);
        ic_location = (ImageView) rootview.findViewById(R.id.ic_location);

        txt_welcome = (TextView) rootview.findViewById(R.id.txt_welcome);
        txt_name = (TextView) rootview.findViewById(R.id.txt_name);
        txt_serviceId = (TextView) rootview.findViewById(R.id.txt_serviceId);
        txt_select_tracking = (TextView) rootview.findViewById(R.id.txt_select_tracking);
        trackingrecyclerView = (TrackingGridWidget) rootview.findViewById(R.id.trackingrecyclerView);
        tracking_recycleView = (RecyclerView) rootview.findViewById(R.id.tracking_recycleView);
        app_bar = (AppBarLayout) rootview.findViewById(R.id.app_bar);

        txt_name.setText(Preferences.getInstance().getUserID(getContext()));
        txt_serviceId.setText(Preferences.getInstance().getServiceid(getContext()));
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            DrawableCompat.setTint(ic_close.getDrawable(), AppController.getInstance().getPrimaryColor());
        }else {
            ic_close.setImageDrawable(AppController.getTintedDrawable(ic_close.getDrawable(),AppController.getInstance().getPrimaryColor()));
        }
        ic_close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                hideDialog();
            }
        });
        preparelist();

        adjustColors();
        return rootview;
    }

    @Override
    public void onResume() {
        super.onResume();
        // clear instance on onbackpressed
        getDialog().setOnKeyListener(new DialogInterface.OnKeyListener()
        {
            @Override
            public boolean onKey(android.content.DialogInterface dialog, int keyCode,
                                 android.view.KeyEvent event) {

                if ((keyCode ==  android.view.KeyEvent.KEYCODE_BACK)) {
                    if (event.getAction()!= KeyEvent.ACTION_DOWN)
                        return true;
                    else {
                        hideDialog();
                        return true;
                    }
                } else
                    return false;
            }
        });
    }

    public void adjustColors() {
        mainContainer.setBackgroundColor(AppController.getInstance().getSecondaryColor());
        upperContainer.setBackgroundColor(AppController.getInstance().getSecondaryColor());
        app_bar.setBackgroundColor(AppController.getInstance().getSecondaryColor());
        txt_welcome.setTextColor(AppController.getInstance().getPrimaryColor());
        txt_name.setTextColor(AppController.getInstance().getPrimaryColor());
        txt_serviceId.setTextColor(AppController.getInstance().getPrimaryColor());
        txt_select_tracking.setTextColor(AppController.getInstance().getPrimaryOrangeColor());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            DrawableCompat.setTint(ic_location.getDrawable(), AppController.getInstance().getPrimaryColor());
        }else {
            ic_location.setImageDrawable(AppController.getTintedDrawable(ic_location.getDrawable(),AppController.getInstance().getPrimaryColor()));

        }
    }

    public void hideDialog() {
        if(getDialog()!=null) {
            getDialog().dismiss();
                instance = null;
        }
    }

    public boolean isShown(){
        boolean shown=false;
        if(getDialog()!=null && getDialog().isShowing()){
            shown=true;
        }
        return shown;
    }

    public void preparelist() {
        String airport_code = Preferences.getInstance().getAirportcode(getContext());
        String trackingString = Preferences.getInstance().getTrackingMap(getContext());
        if(trackingString!=null) {
            Gson gson = new Gson();
            HashMap<String,Object> map= new HashMap<>();
            map= (HashMap<String,Object>) gson.fromJson(trackingString, map.getClass());

            String map_value = (String) map.get(airport_code);
            HashMap<String,String> config_map= new HashMap<>();
            config_map= (HashMap<String,String>) gson.fromJson(map_value, config_map.getClass());

            ArrayList<TrackingConfiguration> trackingList = new ArrayList<>();
            if(config_map!=null) {
                String s = new Gson().toJson(config_map.get(CONFIGURATIONS));
                trackingList = gson.fromJson(s, new TypeToken<ArrayList<TrackingConfiguration>>() {
                }.getType());

                Comparator<TrackingConfiguration> comparator = new Comparator<TrackingConfiguration>() {
                    @Override
                    public int compare(TrackingConfiguration left, TrackingConfiguration right) {
                        return left.getGroup_name().compareTo(right.getGroup_name());
                    }
                };
                if(trackingList!=null)
                    Collections.sort(trackingList, comparator);
            }


//        ArrayList<TrackingConfiguration> trackingList = new ArrayList<>();
//            trackingList.add(new TrackingConfiguration("LOAD_AT_GVA","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("Un-Grouped","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("LOAD_AT_GVA","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("Un-Grouped","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("LOAD_AT_GVA","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("Un-Grouped","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("LOAD_AT_GVA","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("Un-Grouped","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("LOAD_AT_GVA","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("Un-Grouped","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("LOAD_AT_GVA","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("Un-Grouped","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("LOAD_AT_GVA","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("Un-Grouped","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("LOAD_AT_GVA","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("Un-Grouped","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("LOAD_AT_GVA","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("Un-Grouped","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("LOAD_AT_GVA","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("Un-Grouped","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));
//            trackingList.add(new TrackingConfiguration("LOAD_AT_GVA","GVA","BLOADEGT","TerminalAA","LOAD","N","I","NO"));


            //grouping list into hashmap
            // Treemap so that the hash map will be sorted alphabetically
            TreeMap<String,ArrayList<TrackingConfiguration>> groupingMap  = new TreeMap<>();
            ArrayList<TrackingConfiguration> temp ;
            ArrayList<Object> final_list = new ArrayList<>();

            if(trackingList != null) {
                for (TrackingConfiguration item : trackingList) {
                    item.setLocation(AppController.getInstance().validateLocation(item.getLocation()));
                    item.setTracking_id(AppController.getInstance().validateTracking_ID(item.getTracking_id()));
                    item.setAirport_code(AppController.getInstance().validateAirportCode(item.getAirport_code()));
                    item.setIndicator_for_unknown_bag_mgmt(AppController.getInstance().validateunknownBag(item.getIndicator_for_unknown_bag_mgmt()));
                    item.setIndicator_for_container_scanning(AppController.getInstance().validatecontainer(item.getIndicator_for_container_scanning()));
                    item.setGroup_name((AppController.getInstance().validateGroup(item.getGroup_name())));
                }
            }

            if(trackingList != null &&  trackingList.size()>0) {
                for (TrackingConfiguration item : trackingList) {
                    if (groupingMap.get(item.getGroup_name()) == null) {
                        temp = new ArrayList<>();
                        temp.add(item);
                        groupingMap.put(item.getGroup_name(), temp);
                    } else {
                        temp = groupingMap.get(item.getGroup_name());
                        temp.add(item);
                        groupingMap.put(item.getGroup_name(), temp);
                    }
                }

                String FreqUsed_String = Preferences.getInstance().getRecentlyUsedTracking(getContext());

                if(FreqUsed_String!=null) {
                    gson = new Gson();
                    String key = Preferences.getInstance().getUserID(getContext())+"@"+Preferences.getInstance().getCompanyID(getContext());
                    HashMap<String, String> FreqUsed_map ;
                    FreqUsed_map= (HashMap<String,String>) gson.fromJson(FreqUsed_String, map.getClass());
                    ArrayList<TrackingConfiguration> recentlyUsed_List;
                    recentlyUsed_List = gson.fromJson(FreqUsed_map.get(key), new TypeToken<ArrayList<TrackingConfiguration>>() {
                    }.getType());
                    if(recentlyUsed_List!=null) {
                        final_list.add(getContext().getResources().getString(R.string.recently_used));
                        final_list.add(getContext().getResources().getString(R.string.clear));
                        for (TrackingConfiguration item:recentlyUsed_List) {
                            final_list.add(item);
                        }
                        final_list.add(HorizontalDividerViewHolder);
                    }
                }

                for (Map.Entry<String, ArrayList<TrackingConfiguration>> entry : groupingMap.entrySet()) {
                    String key = entry.getKey();
                    ArrayList<TrackingConfiguration> value = entry.getValue();

                    final_list.add(key);
                    for (TrackingConfiguration item : value) {
//                        item.setDescription(item.getDescription()+ " " +item.getDescription()+ " " +item.getDescription()+ " " +item.getDescription()+ " " +item.getDescription()+ " " );
                        final_list.add(item);
                    }
                    final_list.add(HorizontalDividerViewHolder);
                }
                final_list.add(RefreshViewHolder);
            }

            final TrackingPointAdapter adapter = new TrackingPointAdapter(getContext(),getActivity(),final_list);
            GridLayoutManager mLayoutManager = new GridLayoutManager(getContext(), 2, StaggeredGridLayoutManager.VERTICAL, false);

            mLayoutManager.setSpanSizeLookup(new GridLayoutManager.SpanSizeLookup() {
                @Override
                public int getSpanSize(int position) {
                    switch(adapter.getItemViewType(position)){
                        case TitleViewHolder :
                            return 2;
                        case   HorizontalDividerViewHolder :
                            return 2;
                        case RefreshViewHolder:
                            return 2;
                        default:
                            return 1;
                    }
                }
            });
            tracking_recycleView.setLayoutManager(mLayoutManager);
            tracking_recycleView.setAdapter(adapter);

        }
    }
}
