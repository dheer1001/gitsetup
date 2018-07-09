package aero.developer.bagnet.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.CustomViews.AirportAirlineWidget;
import aero.developer.bagnet.LoginActivity;
import aero.developer.bagnet.R;
import aero.developer.bagnet.TestCognexActivity;
import aero.developer.bagnet.dialogs.LocationSuccessFullDialog;
import aero.developer.bagnet.dialogs.SelectAirlineFragment;
import aero.developer.bagnet.interfaces.OptionSelectionCallback;
import aero.developer.bagnet.scantypes.EngineActivity;
import aero.developer.bagnet.scantypes.HoneyWellScanner_Activity;
import aero.developer.bagnet.scantypes.SoftScannerActivity;
import aero.developer.bagnet.socketmobile.TestSocketScannerActivity;
import aero.developer.bagnet.utils.Preferences;

/**
 * Created by User on 09-Oct-17.
 */

public class AirportAirlineAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {
    private List<String> AirportAirlineList = new ArrayList<>();
    private Context context;
    private FragmentActivity activity;
    private boolean isAirportFragment,openOnlythisFragment;
    private OptionSelectionCallback optionSelectionCallback;
    private EngineActivity view = null;

public AirportAirlineAdapter(Context context, List<String> list, FragmentActivity activity,boolean isAirportFragment,boolean openOnlythisFragment,
                             OptionSelectionCallback optionSelectionCallback) {
    this.AirportAirlineList = list;
    this.context = context;
    this.activity = activity;
    this.isAirportFragment = isAirportFragment;
    this.openOnlythisFragment = openOnlythisFragment;
    this.optionSelectionCallback = optionSelectionCallback;
    if(optionSelectionCallback instanceof EngineActivity) {
        view = (EngineActivity) optionSelectionCallback;
    }
}
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        RecyclerView.ViewHolder holder = null;
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.airport_airline_tag, parent, false);
        holder = new ViewHolder(v);
        return holder;
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder holder, @SuppressLint("RecyclerView") final int position) {
        ((ViewHolder) holder).airport_airline_tag.setData(AirportAirlineList.get(position));
        ((ViewHolder) holder).airport_airline_tag.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (activity instanceof LoginActivity && openOnlythisFragment) {

                    if (Preferences.getInstance().getScannerType(context).equalsIgnoreCase(context.getResources().getString(R.string.socket_mobile_bt))) {
                        Intent intent = new Intent(context, TestSocketScannerActivity.class);
                        activity.startActivity(intent);
                    } else if (Preferences.getInstance().getScannerType(context).equalsIgnoreCase(context.getResources().getString(R.string.cognex_scanner))) {
                        Intent intent = new Intent(context, TestCognexActivity.class);
                        activity.startActivity(intent);
                    } else if (Preferences.getInstance().getScannerType(context).equalsIgnoreCase(context.getResources().getString(R.string.soft_scan))) {
                        Intent intent = new Intent(context, SoftScannerActivity.class);
                        activity.startActivity(intent);
                    } else if (Preferences.getInstance().getScannerType(context).equalsIgnoreCase(context.getResources().getString(R.string.honeywell_ct50_scanner))) {
                        Intent intent = new Intent(context, HoneyWellScanner_Activity.class);
                        activity.startActivity(intent);
                    }

                    if (isAirportFragment) {
                        Preferences.getInstance().setAirportCode(context, AirportAirlineList.get(position));
                    } else {
                        Preferences.getInstance().setAirlineCode(context, AirportAirlineList.get(position));
                    }
                    activity.finish();
                    return;
                }

                if (isAirportFragment) {
                    Fragment prev = activity.getSupportFragmentManager().findFragmentByTag("selectAirportFragment");
                    if (prev != null) {
                        final DialogFragment df = (DialogFragment) prev;

                        // clear tracking point if the user changes the airport
                        String prev_selected_airport = Preferences.getInstance().getAirportcode(context);
                        Preferences.getInstance().setAirportCode(context,AirportAirlineList.get(position));
                        if(prev_selected_airport!= null) {
                            if(!prev_selected_airport.equalsIgnoreCase(AirportAirlineList.get(position))) {
                                if(view != null) {
                                    view.onClearTrackingPoint();
                                }
                            }
                        }
                        if(view != null && view.txt_TapToSelectTrackingPoint!=null && view.noTrackingPoints!= null
                                && Preferences.getInstance().getTrackingLocation(context) == null) {
                            if (AppController.getInstance().isSelectedAirportHaveTrackingConfigurations() ) {
                                if(view.locationLayout.getVisibility()== View.GONE) {
                                    view.txt_TapToSelectTrackingPoint.setVisibility(View.VISIBLE);
                                    view.noTrackingPoints.setVisibility(View.GONE);
                                }
                            } else {
                                view.noTrackingPoints.setVisibility(View.VISIBLE);
                                view.txt_TapToSelectTrackingPoint.setVisibility(View.GONE);
                            }
                        }
                    if(optionSelectionCallback != null)
                        optionSelectionCallback.getSelectedAirport(AirportAirlineList.get(position));

                        if(openOnlythisFragment) {
                            df.dismiss();
                        } else {
                            FragmentManager fragmentManager = activity.getSupportFragmentManager();
                            FragmentTransaction ft = fragmentManager.beginTransaction();
                            SelectAirlineFragment selectAirlineFragment = new SelectAirlineFragment();
                            selectAirlineFragment.setType(true,optionSelectionCallback);
                            if(!selectAirlineFragment.isAdded())
                            selectAirlineFragment.show(ft, "selectAirlineFragment");
                            new Handler().postDelayed(new Runnable() {
                                @Override
                                public void run() {
                                    df.dismiss();
                                }
                            }, 500);
                        }

                    }
                } else {
                    Fragment selectAirlineFragment = activity.getSupportFragmentManager().findFragmentByTag("selectAirlineFragment");
                    if (selectAirlineFragment != null) {
                        Preferences.getInstance().setAirlineCode(context,AirportAirlineList.get(position));
                        if(optionSelectionCallback != null)
                        optionSelectionCallback.getSelectedAirline(AirportAirlineList.get(position));
                        DialogFragment df = (DialogFragment) selectAirlineFragment;
                        df.dismiss();
                    }else {
                        if(optionSelectionCallback!=null){
                            optionSelectionCallback.getSelectedAirline(AirportAirlineList.get(position));
                        }
                        LocationSuccessFullDialog.hideDialog();

                    }
                }
            }

        });
    }


    @Override
    public int getItemCount() {
        return AirportAirlineList.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        AirportAirlineWidget airport_airline_tag;
        public ViewHolder(View itemView) {
            super(itemView);
            airport_airline_tag = (AirportAirlineWidget) itemView.findViewById(R.id.airport_airline_tag);
        }


    }
}
