package aero.developer.bagnet.dialogs;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.os.Handler;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.Constants;
import aero.developer.bagnet.CustomViews.CustomButton;
import aero.developer.bagnet.CustomViews.DialogTextView;
import aero.developer.bagnet.R;
import aero.developer.bagnet.interfaces.OnBagTagListener;
import aero.developer.bagnet.interfaces.OnTrackBag;
import aero.developer.bagnet.interfaces.QueueCallBacks;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.objects.LoginData;
import aero.developer.bagnet.presenters.TrackingBagPresenter;
import aero.developer.bagnet.utils.Analytic;
import aero.developer.bagnet.utils.BagTagDBHelper;
import aero.developer.bagnet.utils.Location_Utils;
import aero.developer.bagnet.utils.Preferences;
import aero.developer.bagnet.utils.SyncManager;
import aero.developer.bagnet.utils.Utils;

import static aero.developer.bagnet.Constants.SESSION_ERROR_1;
import static aero.developer.bagnet.Constants.SESSION_ERROR_2;
import static aero.developer.bagnet.Constants.SESSION_ERROR_3;

public class BagDetailDialog implements OnTrackBag {

    private static Dialog dialog = null;
    @SuppressLint("StaticFieldLeak")
    private static BagDetailDialog ourInstance;
    @SuppressLint("StaticFieldLeak")
    private static Context _context;
    RelativeLayout main_container;
    private BagTag bagTag;
    private SyncManager syncManager;
    private QueueCallBacks queueCallBacks;
    private ImageView checkmark;
    private DialogTextView txt_sync;
    private LinearLayout connectionErrorContainer, trackingContainer, bagDetailsContainer, loaderContainer;
    private static OnBagTagListener onBagTagListener;

    public static void setOnBagTagListener(OnBagTagListener _onBagTagListener) {
        onBagTagListener = _onBagTagListener;
    }

    private BagDetailDialog() {
    }

    public static BagDetailDialog getInstance(Context context) {
        _context = context;
        if (ourInstance == null) {
            ourInstance = new BagDetailDialog();
        }
        if (dialog == null) {
            dialog = new Dialog(_context);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        }
        return ourInstance;
    }

    public static void hideDialog() {
        if (dialog != null) {
            dialog.dismiss();
            dialog = null;
        }
    }

    public void showDialog(BagTag bagTag, boolean makeAPICall, SyncManager _syncManager, QueueCallBacks queueCallBacks) {
        this.bagTag = bagTag;
        this.syncManager = _syncManager;
        this.queueCallBacks = queueCallBacks;

        if (dialog != null && !dialog.isShowing()) {
            dialog.setContentView(R.layout.detail_bag);
            WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
            Window window = dialog.getWindow();
            if (window != null) {
                lp.copyFrom(window.getAttributes());
                lp.width = WindowManager.LayoutParams.MATCH_PARENT;
                lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
                window.setAttributes(lp);
                dialog.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
            }
            setData(bagTag);
            if (makeAPICall) {
                String trackingLocation = Preferences.getInstance().getTrackingLocation(_context);
                // add the flight inputted at tracking point time
                if (trackingLocation != null) {
                    String unknownBag = Location_Utils.getUnknownBags(trackingLocation);
                    if (unknownBag != null && unknownBag.equalsIgnoreCase("S")) {
                        if (bagTag != null) {
                            bagTag.setFlightnum(Preferences.getInstance().getFlightNumber(_context));
                            bagTag.setFlighttype(Preferences.getInstance().getFlightType(_context));
                            bagTag.setFlightdate(Preferences.getInstance().getFlightDate(_context));
                        }
                    }
                }
                showTrackingLoaderConatiner();
                TrackingBagPresenter trackingBagPresenter = new TrackingBagPresenter(this);
                trackingBagPresenter.trackBag(_context, bagTag);
            }
            dialog.show();
        }
    }

    public void setData(final BagTag bagTag) {
        if (dialog != null && !dialog.isShowing()) {
            main_container = (RelativeLayout) dialog.findViewById(R.id.main_container);
            DialogTextView trackingLocation = (DialogTextView) dialog.findViewById(R.id.trackingLocation);
            trackingLocation.setText(Location_Utils.getTrackingLocation(bagTag.getTrackingpoint(),false));
            TextView bag_tag = (TextView) dialog.findViewById(R.id.bag_tag);
            TextView gate = (TextView) dialog.findViewById(R.id.gateText);
            TextView container_id = (TextView) dialog.findViewById(R.id.containerID);
            ImageView syncedImage = (ImageView) dialog.findViewById(R.id.syncedImage);
            ImageView bagtagimage = (ImageView) dialog.findViewById(R.id.bagtagimage);
            TextView Airport_Code=(TextView) dialog.findViewById(R.id.airport_code);
            RelativeLayout flight_bag_information = (RelativeLayout) dialog.findViewById(R.id.flight_bag_information);
            TextView PassengerName = (TextView) dialog.findViewById(R.id.passengerName);
            TextView Pnr = (TextView) dialog.findViewById(R.id.pnr);
            TextView Origion_Airport = (TextView) dialog.findViewById(R.id.origion_airport);
            TextView Destination_Airport = (TextView) dialog.findViewById(R.id.destination_airport);

            TextView outbound_flight_date = (TextView) dialog.findViewById(R.id.outbound_flight_date);
            TextView outbound_flight_code_num = (TextView) dialog.findViewById(R.id.outbound_flight_code_num);
            TextView Inbound_Flight_date = (TextView) dialog.findViewById(R.id.inbound_flight_date);
            TextView Inbound_Flight_Code_Num = (TextView) dialog.findViewById(R.id.inbound_flight_code_num);

            ImageView ic_gate = (ImageView) dialog.findViewById(R.id.ic_gate);
            ImageView ic_airplane = (ImageView) dialog.findViewById(R.id.ic_airplane);
            ImageView ic_container = (ImageView) dialog.findViewById(R.id.ic_container);
            ImageView ic_origin_destination_airplane = (ImageView) dialog.findViewById(R.id.ic_origin_destination_airplane);
            RelativeLayout rounded_image = (RelativeLayout) dialog.findViewById(R.id.rounded_image);
            loaderContainer = (LinearLayout) dialog.findViewById(R.id.loaderContainer);
            checkmark = (ImageView) dialog.findViewById(R.id.checkmark);
            txt_sync = (DialogTextView) dialog.findViewById(R.id.txt_sync);

            CustomButton btn_retry = (CustomButton) dialog.findViewById(R.id.btn_retry);
            CustomButton btn_cancel = (CustomButton) dialog.findViewById(R.id.btn_cancel);

            btn_cancel.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    hideDialog();
                }
            });
            btn_retry.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    showTrackingLoaderConatiner();
                    TrackingBagPresenter trackingBagPresenter = new TrackingBagPresenter(BagDetailDialog.this);
                    trackingBagPresenter.trackBag(_context, bagTag);
                }
            });
            connectionErrorContainer = (LinearLayout) dialog.findViewById(R.id.connectionErrorContainer);
            trackingContainer = (LinearLayout) dialog.findViewById(R.id.trackingContainer);
            bagDetailsContainer = (LinearLayout) dialog.findViewById(R.id.bagDetailsContainer);

            Preferences.getSharedPreferences(_context);
            String airportCode = Preferences.getInstance().getAirportcode(_context);
            String flightDate = bagTag.getFlightdate();
            String flightNumber = bagTag.getFlightnum();
            String flightType = bagTag.getFlighttype();
            String airportPair = "";
            String fullString = _context.getString(R.string.notavailable);
            if (flightDate != null && flightNumber != null && flightType != null) {
                dialog.findViewById(R.id.flightDetailRow).setVisibility(View.VISIBLE);
                String locationAirport = Location_Utils.getAirportCode(bagTag.getTrackingpoint());
                if (flightType != null && flightType.equalsIgnoreCase("d")) {
                    airportPair = _context.getString(R.string.departing, locationAirport);
                } else {
                    airportPair = _context.getString(R.string.arriving, locationAirport);
                }
                 fullString = flightNumber + " " + airportPair + "\n" + Utils.formatDate(flightDate, Utils.DATE_FORMAT, Utils.INFO_DATE_FORMAT);

            }else{
                dialog.findViewById(R.id.flightDetailRow).setVisibility(View.GONE);
                //gate.setVisibility(View.GONE);
            }

            if (bagTag.getBagtag()!=null && !bagTag.getBagtag().equalsIgnoreCase("")){
                bagtagimage.setImageResource(R.drawable.suitcase_travel);
            }else{
                bagtagimage.setImageResource(R.drawable.container);
            }



            bag_tag.setText(bagTag.getBagtag());

            DialogTextView eventName = (DialogTextView) dialog.findViewById(R.id.eventName);
            eventName.setText(Location_Utils.getEventType(bagTag.getTrackingpoint(),false));

            gate.setText(fullString);
            dialog.findViewById(R.id.containerRow).setVisibility(bagTag.getContainerid()!=null && !bagTag.getContainerid().equalsIgnoreCase("")?View.VISIBLE:View.GONE);
            container_id.setText(bagTag.getContainerid()!=null && !bagTag.getContainerid().equalsIgnoreCase("")?bagTag.getContainerid():_context.getString(R.string.notavailable));
            setIcon(bagTag,syncedImage);
            CustomButton resetBtn = (CustomButton) dialog.findViewById(R.id.resetBtn);
            CustomButton deletebtn = (CustomButton) dialog.findViewById(R.id.deletebtn);
            CustomButton deleteAllbtn = (CustomButton) dialog.findViewById(R.id.deleteAllbtn);
            DialogTextView error = (DialogTextView) dialog.findViewById(R.id.error);

            if(bagTag.getLocked()) {
                resetBtn.setText(_context.getString(R.string.reset_status));
                deleteAllbtn.setVisibility(View.VISIBLE);
            }
            else {
                resetBtn.setText(_context.getString(R.string.try_again));
                deleteAllbtn.setVisibility(View.GONE);
            }

            deleteAllbtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    onBagTagListener.onDeleteAllSimilarClicked(bagTag);
                }
            });

            resetBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if(bagTag.getLocked()) {
                        Analytic.getInstance().sendScreen(R.string.EVENT_ITEM_RESETED_SCREEN);
                        onBagTagListener.onResetStatusClicked(bagTag);
                    }
                    else {
                        Analytic.getInstance().sendScreen(R.string.EVENT_ITEM_TRY_AGAIN_SCREEN);
                        onBagTagListener.onTryAgainClicked(bagTag);
                    }

                }
            });
            deletebtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Analytic.getInstance().sendScreen(R.string.EVENT_ITEM_DELETED_SCREEN);
                    onBagTagListener.onRemoveBagClicked(bagTag);
                }
            });

            if (bagTag.getLocked()){
                resetBtn.setVisibility(View.VISIBLE);
                deletebtn.setVisibility(View.VISIBLE);
                error.setVisibility(View.VISIBLE);
            }
            else if(bagTag.getSynced()) {
                resetBtn.setVisibility(View.GONE);
                deletebtn.setVisibility(View.GONE);
                error.setVisibility(View.GONE);
            }
            error.setText(bagTag.getErrorMsg());

            if (
                    !(bagTag.getPassenger_first_name() != null && bagTag.getPassenger_last_name() != null && !bagTag.getPassenger_first_name().equalsIgnoreCase(" ") && !bagTag.getPassenger_last_name().equalsIgnoreCase(" ")) &&
                    !(bagTag.getPnr() != null && !bagTag.getPnr().equalsIgnoreCase(" ")) &&
                    !(bagTag.getOrigin_airport() != null && !bagTag.getOrigin_airport().equalsIgnoreCase(" ")) &&
                    !(bagTag.getDestination_airport() != null && !bagTag.getDestination_airport().equalsIgnoreCase(" ")) &&
                    !(bagTag.getOutbound_flight_date() != null && !bagTag.getOutbound_flight_date().equalsIgnoreCase(" ")) &&
                    !(bagTag.getOutbound_airline_code() != null && bagTag.getOutbound_flight_num() != null && !bagTag.getOutbound_airline_code().equalsIgnoreCase(" ") && !bagTag.getOutbound_flight_num().equalsIgnoreCase(" ")) &&
                    !(bagTag.getInbound_flight_date() != null && !bagTag.getInbound_flight_date().equalsIgnoreCase(" ")) &&
                    !(bagTag.getInbound_airline_code() != null && bagTag.getInbound_flight_num() != null && !bagTag.getInbound_airline_code().equalsIgnoreCase(" ") && !bagTag.getInbound_flight_num().equalsIgnoreCase(" "))


             ){
                flight_bag_information.setVisibility(View.GONE);
            }

            if (bagTag.getBagtag() != null && !bagTag.getBagtag().equalsIgnoreCase("")) {
                if (bagTag.getSynced()) {

                    flight_bag_information.setVisibility(View.VISIBLE);

                   if(bagTag.getInbound_flight_num()!=null && bagTag.getOutbound_flight_num()!=null && bagTag.getInbound_airline_code()!=null && bagTag.getOutbound_airline_code()!=null
                           && bagTag.getInbound_flight_date()!=null && bagTag.getOutbound_flight_date()!=null){
                       Airport_Code.setVisibility(View.VISIBLE);
                        Airport_Code.setText(airportCode);
                   }

                    boolean pii_data_sharing = false;
                    LoginData loginData = new Gson().fromJson(Preferences.getInstance().getLoginResponse(_context),LoginData.class);
                   if(loginData != null) {
                       pii_data_sharing =loginData.isPii_data_sharing();
                   }
                    if (!pii_data_sharing && bagTag.getPassenger_first_name() != null && bagTag.getPassenger_last_name() != null && !bagTag.getPassenger_first_name().equalsIgnoreCase(" ") && !bagTag.getPassenger_last_name().equalsIgnoreCase(" ")) {
                        PassengerName.setVisibility(View.VISIBLE);
                        String passengerName = bagTag.getPassenger_first_name() + "  " + bagTag.getPassenger_last_name();
                        PassengerName.setText(passengerName);
                    } else {
                        PassengerName.setVisibility(View.INVISIBLE);
                    }
                    if (!pii_data_sharing && bagTag.getPnr() != null && !bagTag.getPnr().equalsIgnoreCase(" ")) {
                        Pnr.setVisibility(View.VISIBLE);
                        Pnr.setText(bagTag.getPnr());
                    } else {
                        Pnr.setVisibility(View.INVISIBLE);
                    }
                    if (bagTag.getOrigin_airport() != null && !bagTag.getOrigin_airport().equalsIgnoreCase(" ")) {
                        Origion_Airport.setVisibility(View.VISIBLE);
                        Origion_Airport.setText(bagTag.getOrigin_airport());
                    } else {
                        if (OutboundFlightDataONLY(bagTag)) {
                            Origion_Airport.setVisibility(View.VISIBLE);
                            Origion_Airport.setText(airportCode);
                        }
                    }
                    if (bagTag.getDestination_airport() != null && !bagTag.getDestination_airport().equalsIgnoreCase(" ")) {
                        Destination_Airport.setVisibility(View.VISIBLE);
                        Destination_Airport.setText(bagTag.getDestination_airport());
                    } else {
                        if (InboundFlightDataONLY(bagTag)) {
                            Destination_Airport.setVisibility(View.VISIBLE);
                            Destination_Airport.setText(airportCode);
                        }
                    }
                    if(Origion_Airport.getVisibility() == View.INVISIBLE && Destination_Airport.getVisibility() == View.INVISIBLE){
                        ic_origin_destination_airplane.setVisibility(View.INVISIBLE);
                    }
                    if (bagTag.getOutbound_flight_date() != null && !bagTag.getOutbound_flight_date().equalsIgnoreCase(" ")) {
                        outbound_flight_date.setVisibility(View.VISIBLE);
                        outbound_flight_date.setText(bagTag.getOutbound_flight_date());
                    } else {
                        outbound_flight_date.setVisibility(View.INVISIBLE);
                    }
                    if (bagTag.getOutbound_airline_code() != null && bagTag.getOutbound_flight_num() != null && !bagTag.getOutbound_airline_code().equalsIgnoreCase(" ") && !bagTag.getOutbound_flight_num().equalsIgnoreCase(" ")) {
                        outbound_flight_code_num.setVisibility(View.VISIBLE);
                        outbound_flight_code_num.setText(bagTag.getOutbound_airline_code() + bagTag.getOutbound_flight_num());
                    } else {
                        outbound_flight_code_num.setVisibility(View.INVISIBLE);
                    }
                    if (bagTag.getInbound_flight_date() != null && !bagTag.getInbound_flight_date().equalsIgnoreCase(" ")) {
                        Inbound_Flight_date.setVisibility(View.VISIBLE);
                        Inbound_Flight_date.setText(bagTag.getInbound_flight_date());
                    } else {
                        Inbound_Flight_date.setVisibility(View.INVISIBLE);
                    }
                    if (bagTag.getInbound_airline_code() != null && bagTag.getInbound_flight_num() != null && !bagTag.getInbound_airline_code().equalsIgnoreCase(" ") && !bagTag.getInbound_flight_num().equalsIgnoreCase(" ")) {
                        Inbound_Flight_Code_Num.setVisibility(View.VISIBLE);
                        Inbound_Flight_Code_Num.setText(bagTag.getInbound_airline_code() + bagTag.getInbound_flight_num());
                    } else {
                        Inbound_Flight_Code_Num.setVisibility(View.INVISIBLE);
                    }
                } else {
                    flight_bag_information.setVisibility(View.GONE);
                }
            }else {
                flight_bag_information.setVisibility(View.GONE);
            }
            // adjust colors
            GradientDrawable main_container_drawable = (GradientDrawable) main_container.getBackground();
            main_container_drawable.setStroke(4, AppController.getInstance().getSecondaryGrayColor());
            main_container_drawable.setColor(AppController.getInstance().getbagDetailBackground());

            bag_tag.setTextColor(AppController.getInstance().getPrimaryColor());
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                DrawableCompat.setTint(ic_gate.getDrawable(), AppController.getInstance().getPrimaryColor());
                DrawableCompat.setTint(ic_airplane.getDrawable(), AppController.getInstance().getPrimaryColor());
                DrawableCompat.setTint(ic_container.getDrawable(), AppController.getInstance().getPrimaryColor());
                DrawableCompat.setTint(ic_origin_destination_airplane.getDrawable(), AppController.getInstance().getPrimaryColor());
                DrawableCompat.setTint(bagtagimage.getDrawable(), AppController.getInstance().getSecondaryColor());
            } else {
                ic_gate.setImageDrawable(AppController.getTintedDrawable(ic_gate.getDrawable(),AppController.getInstance().getPrimaryColor()));
                ic_airplane.setImageDrawable(AppController.getTintedDrawable(ic_airplane.getDrawable(),AppController.getInstance().getPrimaryColor()));
                ic_container.setImageDrawable(AppController.getTintedDrawable(ic_container.getDrawable(),AppController.getInstance().getPrimaryColor()));
                ic_origin_destination_airplane.setImageDrawable(AppController.getTintedDrawable(ic_origin_destination_airplane.getDrawable(),AppController.getInstance().getPrimaryColor()));
                bagtagimage.setImageDrawable(AppController.getTintedDrawable(bagtagimage.getDrawable(),AppController.getInstance().getSecondaryColor()));
            }

            trackingLocation.setTextColor(AppController.getInstance().getPrimaryColor());
            gate.setTextColor(AppController.getInstance().getPrimaryColor());
            container_id.setTextColor(AppController.getInstance().getPrimaryColor());
            Origion_Airport.setTextColor(AppController.getInstance().getPrimaryColor());
            Destination_Airport.setTextColor(AppController.getInstance().getPrimaryColor());
            outbound_flight_date.setTextColor(AppController.getInstance().getPrimaryColor());
            Inbound_Flight_date.setTextColor(AppController.getInstance().getPrimaryColor());
            outbound_flight_code_num.setTextColor(AppController.getInstance().getPrimaryColor());
            Inbound_Flight_Code_Num.setTextColor(AppController.getInstance().getPrimaryColor());
            PassengerName.setTextColor(AppController.getInstance().getPrimaryColor());
            Pnr.setTextColor(AppController.getInstance().getPrimaryColor());
            Airport_Code.setTextColor(AppController.getInstance().getPrimaryColor());
            txt_sync.setTextColor(AppController.getInstance().getPrimaryColor());
            GradientDrawable rounded_image_drawable = (GradientDrawable) rounded_image.getBackground();
            if(Preferences.getInstance().isNightMode(_context)) {
                rounded_image_drawable.setStroke(0, AppController.getInstance().getSecondaryGrayColor());
            }
            else {
                rounded_image_drawable.setStroke(4, AppController.getInstance().getSecondaryGrayColor());

            }
            rounded_image_drawable.setColor(AppController.getInstance().getSecondaryGrayColor());


        }



    }

    private void setIcon(BagTag bagTag, ImageView syncedImage) {
        if (bagTag.getLocked()) {
            syncedImage.setVisibility(View.VISIBLE);
            syncedImage.setImageResource(R.drawable.ic_no_sync);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                syncedImage.getDrawable().setTint(_context.getResources().getColor(R.color.disconnected));
            } else {
                syncedImage.setImageDrawable(AppController.getTintedDrawable(syncedImage.getDrawable(),_context.getResources().getColor(R.color.disconnected)));
            }
        }

        if (bagTag.getSynced()){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                syncedImage.getDrawable().setTint(AppController.getInstance().getPrimaryColor());
            } else {
                syncedImage.setImageDrawable(AppController.getTintedDrawable(syncedImage.getDrawable(),AppController.getInstance().getPrimaryColor()));
            }
            syncedImage.setVisibility(View.VISIBLE);
            syncedImage.setImageResource(R.drawable.ic_cloud_done);
        }else{
            if (!bagTag.getLocked()){
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    syncedImage.getDrawable().setTint(AppController.getInstance().getPrimaryColor());
                } else {
                    syncedImage.setImageDrawable(AppController.getTintedDrawable(syncedImage.getDrawable(),AppController.getInstance().getPrimaryColor()));
                }
                syncedImage.setVisibility(View.VISIBLE);
                syncedImage.setImageResource(R.drawable.ic_cloud_off);
            }
        }

    }

    public boolean isShown() {
        return dialog != null && dialog.isShowing();
    }

    @Override
    public void trackSuccess(BagTag bagTag) {
        bagTag.setLocked(false);
        bagTag.setSynced(true );
        showCheckmarkAndhideDialog();
    }

    @Override
    public void trackFailed(BagTag bagTag, String errorCode) {
        if (errorCode.equalsIgnoreCase(SESSION_ERROR_1) || errorCode.equalsIgnoreCase(SESSION_ERROR_2) || errorCode.equalsIgnoreCase(SESSION_ERROR_3)) {
            hideDialog();
        } else {
            String trackingLocation = Preferences.getInstance().getTrackingLocation(_context);
            if (trackingLocation != null) {
                String unknownBag = Location_Utils.getUnknownBags(trackingLocation);
                if (unknownBag != null && unknownBag.equalsIgnoreCase("U")) {
                    Flight_Screen_Dialog.getInstance(_context).setReturnToBagDetails(true, syncManager, queueCallBacks);
                    Flight_Screen_Dialog.getInstance(_context).showDialog(bagTag);
                    hideDialog();
                }
            }
        }
    }

    @Override
    public void onConnectionFailed(BagTag bagTag) {
        showConnectionErrorContainer();
    }

    private void showCheckmarkAndhideDialog() {
        loaderContainer.setVisibility(View.INVISIBLE);
        txt_sync.setVisibility(View.INVISIBLE);
        checkmark.setVisibility(View.VISIBLE);
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                hideDialog();
                BagTagDBHelper.getInstance(_context).getBagtagTag().insertOrReplace(bagTag);
                if (queueCallBacks != null)
                    queueCallBacks.addBagTag(bagTag);
                if (syncManager != null) {
                    syncManager.start();
                }
            }
        }, Constants.ResponseDialogExpireTime);
    }

    private void showConnectionErrorContainer() {
        connectionErrorContainer.setVisibility(View.VISIBLE);
        bagDetailsContainer.setVisibility(View.GONE);
        trackingContainer.setVisibility(View.GONE);
    }

    private void showTrackingLoaderConatiner() {
        trackingContainer.setVisibility(View.VISIBLE);
        connectionErrorContainer.setVisibility(View.GONE);
        bagDetailsContainer.setVisibility(View.GONE);
    }

    private boolean InboundFlightDataONLY(BagTag bagTag) {
        return (bagTag.getInbound_flight_num() != null || bagTag.getInbound_airline_code() != null || bagTag.getInbound_flight_date() != null) &&
                (bagTag.getOutbound_flight_num() == null && bagTag.getOutbound_airline_code() == null && bagTag.getOutbound_flight_date() == null);

    }

    private boolean OutboundFlightDataONLY(BagTag bagTag) {
        return (bagTag.getOutbound_flight_num() != null || bagTag.getOutbound_airline_code() != null || bagTag.getOutbound_flight_date() != null) &&
                (bagTag.getInbound_flight_num() == null && bagTag.getInbound_airline_code() == null && bagTag.getInbound_flight_date() == null);
    }


}
