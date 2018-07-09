package aero.developer.bagnet.dialogs;


import android.content.DialogInterface;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.adapter.AirportAirlineAdapter;
import aero.developer.bagnet.interfaces.OptionSelectionCallback;
import aero.developer.bagnet.objects.LoginData;
import aero.developer.bagnet.utils.Preferences;

public class SelectAirportFragment extends DialogFragment  {
    private LinearLayout mainContainer;
    private RelativeLayout upperContainer;
    private TextView txt_welcome,txt_name,txt_serviceId,txt_select_airport;
    private ImageView ic_airport;
    private boolean openOnlyAirportFragment = false;
    private OptionSelectionCallback optionSelectionCallback;

    public SelectAirportFragment() {}

    public void setType(boolean openOnlyAirportFragment, OptionSelectionCallback optionSelectionCallback) {
      this.openOnlyAirportFragment = openOnlyAirportFragment;
      this.optionSelectionCallback = optionSelectionCallback;
  }
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(STYLE_NO_FRAME, R.style.AppTheme);

    }

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootview = inflater.inflate(R.layout.fragment_select_airport, container, false);
        RecyclerView airport_airline_recycleView = rootview.findViewById(R.id.airport_airline_recycleView);
        mainContainer = rootview.findViewById(R.id.mainContainer);
        upperContainer = rootview.findViewById(R.id.upperContainer);
        ic_airport = rootview.findViewById(R.id.ic_airport);
        txt_welcome = rootview.findViewById(R.id.txt_welcome);
        txt_name = rootview.findViewById(R.id.txt_name);
        txt_serviceId = rootview.findViewById(R.id.txt_serviceId);
        txt_select_airport = rootview.findViewById(R.id.txt_select_airport);
        txt_name.setText(Preferences.getInstance().getUserID(getContext()));
        txt_serviceId.setText(Preferences.getInstance().getServiceid(getContext()));

        setCancelable(false);

        String json = Preferences.getInstance().getLoginResponse(getContext());
        LoginData loginData =  new Gson().fromJson(json, new TypeToken<LoginData>() {
        }.getType());

        AirportAirlineAdapter adapter = new AirportAirlineAdapter(getContext(), AppController.getInstance().getAirportAirlineFromString(loginData.getAirports())
                , getActivity(), true, openOnlyAirportFragment, optionSelectionCallback);

       GridLayoutManager mLayoutManager = new GridLayoutManager(getContext(), 2, StaggeredGridLayoutManager.VERTICAL, false);

        airport_airline_recycleView.setLayoutManager(mLayoutManager);
        airport_airline_recycleView.setAdapter(adapter);


        adjustColors();
        return rootview;
    }

    private void adjustColors() {
        mainContainer.setBackgroundColor(AppController.getInstance().getSecondaryColor());
        upperContainer.setBackgroundColor(AppController.getInstance().getSecondaryColor());
        txt_welcome.setTextColor(AppController.getInstance().getPrimaryColor());
        txt_name.setTextColor(AppController.getInstance().getPrimaryColor());
        txt_serviceId.setTextColor(AppController.getInstance().getPrimaryColor());
        txt_select_airport.setTextColor(AppController.getInstance().getPrimaryOrangeColor());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            DrawableCompat.setTint(ic_airport.getDrawable(), AppController.getInstance().getPrimaryColor());
        }else {
            ic_airport.setImageDrawable(AppController.getTintedDrawable(ic_airport.getDrawable(),AppController.getInstance().getPrimaryColor()));
        }
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        super.onDismiss(dialog);
    }
    public boolean isShown(){
        boolean shown=false;
        if(getDialog()!=null && getDialog().isShowing()){
            shown=true;
        }
        return shown;
    }
}
