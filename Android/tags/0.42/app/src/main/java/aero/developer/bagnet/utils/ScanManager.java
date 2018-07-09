package aero.developer.bagnet.utils;

import android.content.Context;
import android.os.Build;
import android.view.View;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import aero.developer.bagnet.AppController;
import aero.developer.bagnet.R;
import aero.developer.bagnet.dialogs.BINGO_Progress_Dialog;
import aero.developer.bagnet.dialogs.BagDetailDialog;
import aero.developer.bagnet.dialogs.IdentifiedContainerDialog;
import aero.developer.bagnet.interfaces.EngineInterface;
import aero.developer.bagnet.interfaces.BagActions;
import aero.developer.bagnet.interfaces.QueueCallBacks;
import aero.developer.bagnet.interfaces.ReadStringListener;
import aero.developer.bagnet.objects.BagTag;
import aero.developer.bagnet.objects.BagTagDao;
import aero.developer.bagnet.objects.TrackingConfiguration;
import aero.developer.bagnet.scantypes.CognexScanActivity;

import static aero.developer.bagnet.scantypes.EngineActivity.engineActivity;

/**
 * Created by User on 5/22/2017.
 */

public class ScanManager {
    private Context context;
    private EngineInterface engineInterface;
    private ReadStringListener listener;
    private QueueCallBacks queueCallBacks;
    private SyncManager syncManager;
    private BagActions bagActions;

    public ScanManager(SyncManager _syncManager, Context _context, ReadStringListener _listener, EngineInterface _engineInterface, QueueCallBacks _queueCallBacks, BagActions _BagActions) {
        this.context = _context;
        this.engineInterface = _engineInterface;
        this.listener = _listener;
        this.queueCallBacks = _queueCallBacks;
        this.syncManager = _syncManager;
        this.bagActions = _BagActions;

    }


    public void handleScannedTrackingLocation(String _trackingLocation) {

        Analytic.getInstance().sendScreen(R.string.EVENT_TRACKING_POINT_SCANNED_SCREEN);
        BagTagDBHelper.getInstance(this.context).getBagtagTag().queryBuilder().where(BagTagDao.Properties.Synced.eq(true)).buildDelete().executeDeleteWithoutDetachingEntities();
//        IdentifiedContainerDialog.getInstance(context).setOnDismissListener(null);
        Preferences.getInstance().resetFlightInfo(this.context);
        Preferences.getInstance().resetContaineruld(this.context);
        Preferences.getInstance().saveTrackingLocation(this.context, _trackingLocation);
        Preferences.getInstance().saveStartTrackingTime(this.context, new Date());

        // save tracking point to recently used list
        Gson gson = new Gson();
        String mapString = Preferences.getInstance().getRecentlyUsedTracking(context);
        String key = Preferences.getInstance().getUserID(context)+"@"+Preferences.getInstance().getCompanyID(context);

        String bingo_sheet_scanning = "NO";
        if(Location_Utils.getTypeEvent(_trackingLocation)!=null && Location_Utils.getTypeEvent(_trackingLocation).equalsIgnoreCase("B")) {
            bingo_sheet_scanning = "YES";
        }
        TrackingConfiguration trackingConfiguration = new TrackingConfiguration("",Location_Utils.getAirportCode(_trackingLocation),Location_Utils.getEventType(_trackingLocation,false),
                Location_Utils.getTrackingLocation(_trackingLocation,false),
                AppController.getInstance().preparePurposeFromTypeEvent(Location_Utils.getTypeEvent(_trackingLocation)),Location_Utils.getUnknownBags(_trackingLocation),Location_Utils.getContainerInput(_trackingLocation),bingo_sheet_scanning);

        if(mapString == null) {
            HashMap<String, String>  map_list = new HashMap<>();
            ArrayList<TrackingConfiguration> temp = new ArrayList<>();
            temp.add(trackingConfiguration);
            map_list.put(key, gson.toJson(temp) );
            String finalMap = gson.toJson(map_list);
            Preferences.getInstance().setRecentlyUsedTracking(context, finalMap);
        }else {
            HashMap<String, String> map = new HashMap<>();
            map = (HashMap<String, String>) gson.fromJson(mapString, map.getClass());
            ArrayList<TrackingConfiguration> listToAdd;
            listToAdd = gson.fromJson(map.get(key), new TypeToken<ArrayList<TrackingConfiguration>>() {
            }.getType());
            if (listToAdd == null) {
                ArrayList<TrackingConfiguration> temp = new ArrayList<>();
                temp.add(trackingConfiguration);
                map.put(key, gson.toJson(temp));
                String finalMap = gson.toJson(map);
                Preferences.getInstance().setRecentlyUsedTracking(context, finalMap);
            } else {
                if (AppController.getInstance().isTrackingExistInList
                        (AppController.getInstance().prepareTrackingPoint(trackingConfiguration), listToAdd)) {
                    listToAdd = AppController.getInstance().moveSelectedToHead(AppController.getInstance().prepareTrackingPoint(trackingConfiguration), listToAdd);
                } else {
                    if (listToAdd.size() < 4) {
                        listToAdd.add(0, trackingConfiguration);
                    } else {
                        listToAdd.remove(listToAdd.size() - 1);
                        listToAdd.add(0, trackingConfiguration);
                    }
                }

                map.put(key, gson.toJson(listToAdd));
                Preferences.getInstance().setRecentlyUsedTracking(context, gson.toJson(map));
            }
        }

        if (engineInterface != null) {
            engineInterface.disable2of5Interleaved();
            engineInterface.disableCode128();
        }
        if (listener != null) {
            listener.onTrackingLocationScannedExtraActions(_trackingLocation);
        }
    }

    public void handleScannedContainer(String _container) {
        boolean isValidContainerWithoutSpaces = DataManUtils.checkifThisContainerWithoutSpaces(_container);
        String containerString = null;
        if (isValidContainerWithoutSpaces) {
            BagLogger.log("Container is OK and require correction");

            StringBuilder stringBuilder = new StringBuilder(_container);
            stringBuilder.insert(8, ' ');
            stringBuilder.insert(3, ' ');
            containerString = stringBuilder.toString();
        } else {
            containerString = _container;
        }

        boolean isValidContainer = DataManUtils.isValidContainer(containerString);
        if (isValidContainer) {
            Analytic.getInstance().sendScreen(R.string.EVENT_CONTAINER_SCANNED_SCREEN);
            Preferences.getInstance().saveContaineruld(this.context, containerString);

            String trackingLocation = Preferences.getInstance().getTrackingLocation(this.context);
            String containerInput = Location_Utils.getContainerInput(trackingLocation);

            // show Identified container dialog
            if(containerInput!=null && containerInput.equalsIgnoreCase("Y")) {
                boolean isBottomAligned = false;
                if(Preferences.getInstance().getScannerType(context).equalsIgnoreCase(context.getResources().getString(R.string.soft_scan))) {
                    isBottomAligned = true;
                }
                IdentifiedContainerDialog.getInstance(context).showDialog(isBottomAligned);
            }

            if (containerInput != null && containerInput.equalsIgnoreCase("C")) {
                // we need to add the container as a bag.
                BagLogger.log("containerString = " + containerString);
                BagTag container = new BagTag();
                container.setContainerid(containerString);
                container.setTrackingpoint(trackingLocation);
                container.setDatetime(Utils.formatDate(new Date(), Utils.timeZoneFormatREQUEST));
                boolean isContainerAlreadyAdded = false;
               List<BagTag> baglsist =  BagTagDBHelper.getInstance(this.context).getBagtagTag().queryBuilder().list();
                if(baglsist!=null && baglsist.size()>0) {
                    for (BagTag item:baglsist) {
                        if(item.getContainerid()!=null && item.getContainerid().equalsIgnoreCase(container.getContainerid())
                                && item.getTrackingpoint()!=null && item.getTrackingpoint().equalsIgnoreCase(container.getTrackingpoint())) {
                            isContainerAlreadyAdded = true;
                            break;
                        }
                    }
                }
                if(!isContainerAlreadyAdded) {
                    updateBagintoDB(Preferences.getInstance().getFlightNumber(this.context), Preferences.getInstance().getFlightType(this.context), Preferences.getInstance().getFlightDate(this.context), container);
                    BagLogger.log("containerString = " + container.getContainerid());

                    if (this.syncManager != null) {
                        this.syncManager.start();
                    }
                }
               }
            if (listener != null) {
                listener.onContainerScannedExtraActions(containerString);
            }
        }
    }

    public void handleScannedBag(String _bag) {

        if(BagDetailDialog.getInstance(context)!= null && BagDetailDialog.getInstance(context).isShown()) {
            BagDetailDialog.hideDialog();
        }
        String trackingLocation = Preferences.getInstance().getTrackingLocation(this.context);
        String containerInput = Location_Utils.getContainerInput(trackingLocation);


        Analytic.getInstance().sendScreen(R.string.EVENT_BAG_SCANNED_SCREEN);
        BagTag bagTag = new BagTag();
        bagTag.setBagtag(_bag);
        bagTag.setContainerid(Preferences.getInstance().getContaineruld(this.context));
        bagTag.setTrackingpoint(trackingLocation);
        bagTag.setDatetime(Utils.formatDate(new Date(), Utils.timeZoneFormatREQUEST));

        // we need to check if the unknown bag is ignored or event is tracking so we add directly to database.
        String unkownBags = Location_Utils.getUnknownBags(trackingLocation);
        String typeEvent = Location_Utils.getTypeEvent(trackingLocation);
        String jsonStr = "";
        if(typeEvent!= null && typeEvent.equalsIgnoreCase("B")) {
            String tempQueue = Preferences.getInstance().getBingoTempQueue(context);
            ArrayList<String> TempQueue;

            if(tempQueue != null) {
                TempQueue = new Gson().fromJson(tempQueue, new TypeToken<ArrayList<String>>() {
                }.getType());
                if(canAddScannedBag(TempQueue,_bag)) {
                    TempQueue.add(_bag);
                    Preferences.getInstance().setBingoTempQueue(new Gson().toJson(TempQueue));
                    if(CognexScanActivity.readerDevice!= null && CognexScanActivity.readerDevice.getDataManSystem()!= null &&
                            BINGO_Progress_Dialog.getInstance().getDialog()!= null){
                        DataManUtils.fireBeep(CognexScanActivity.readerDevice.getDataManSystem());
                    }
                }
            } else {
                TempQueue = new ArrayList<>();
                if(canAddScannedBag(TempQueue,_bag)) {
                    TempQueue.add(_bag);
                    Preferences.getInstance().setBingoTempQueue(new Gson().toJson(TempQueue));
                }
            }
            //update UI in progress Dialog screen
            if(BINGO_Progress_Dialog.getInstance().getDialog()!=null) {
                BINGO_Progress_Dialog.getInstance().updateFields();
            }
            return;
        }
        if (typeEvent != null && unkownBags != null) {

            //BAGNET-103
            switch (unkownBags) {
                case "I":
                case "i":
                    BagTagDBHelper.getInstance(this.context).getBagtagTag().insertOrReplace(bagTag);
                    if (this.queueCallBacks != null)
                        this.queueCallBacks.addBagTag(bagTag);
                    if (syncManager != null)
                        syncManager.start();
                    break;
                case "S":
                case "s":
                    if (trackingLocation != null) {
                        bagTag.setFlightnum(Preferences.getInstance().getFlightNumber(context));
                        bagTag.setFlighttype(Preferences.getInstance().getFlightType(context));
                        bagTag.setFlightdate(Preferences.getInstance().getFlightDate(context));
                    }
                    engineActivity.addSyncBag(bagTag);

//                    BagHistoryPresenter presenter = new BagHistoryPresenter();
//                    presenter.setCallback(this.bagActions);
//                    presenter.getBagHistory(bagTag);
//                    if (engineInterface != null)
//                        engineInterface.disable2of5Interleaved();
                    break;
                case "U":
                case "u":
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        if(listener!= null) {
                            listener.onBagScannedExtraActions(bagTag);
                        }
                    }
            }
        }

    }

    public void BINGO_updateBagintoDB(BagTag bagTag) {
        BagTagDBHelper.getInstance(this.context).getBagtagTag().insertOrReplace(bagTag);
        if (this.queueCallBacks != null) {
            this.queueCallBacks.addBagTag(bagTag);
            syncManager.start();

        }
    }

    public void updateBagintoDB(String flightNumber, String flightType, String flightdate, BagTag bagTag) {
        bagTag.setFlightdate(flightdate);
        bagTag.setFlighttype(flightType);
        bagTag.setFlightnum(flightNumber);
        BagTagDBHelper.getInstance(this.context).getBagtagTag().insertOrReplace(bagTag);
        if (this.queueCallBacks != null) {
            this.queueCallBacks.addBagTag(bagTag);
        }
    }

    public void whatToDoAfterContainerScan() {
        String trackingLocation = Preferences.getInstance().getTrackingLocation(context);
        String containerInput = Location_Utils.getContainerInput(trackingLocation);
       if(containerInput != null && containerInput.equalsIgnoreCase("N"))
           engineInterface.disableCode128();

        if (containerInput != null && !containerInput.equalsIgnoreCase("C")) {
            if (engineInterface != null) {
                engineInterface.enable2of5Interleaved();
                if(engineActivity!= null && engineActivity.scanPromptView!= null && IdentifiedContainerDialog.instance ==null ) {
                    engineActivity.scanPromptView.setPromptForBags();
                    engineActivity.floatingActionButton.setVisibility(View.VISIBLE);

                }
            }
        }
//        else if(engineActivity!= null && engineActivity.scanPromptView!= null && containerInput != null && containerInput.equalsIgnoreCase("C")) {
//            engineActivity.scanPromptView.hideView();
//        }
        if (listener != null) {
            listener.whatToDoAfterContainerScanExtraActions(containerInput);
        }
    }

    private boolean canAddScannedBag(ArrayList<String> baglist, String scannedBag) {
        if(baglist != null &&  baglist.size() == Preferences.getInstance().getBingoBagsnumber(context)) {
            return false;
        }
        if (baglist != null) {
            for (String bag : baglist) {
                if (bag.equalsIgnoreCase(scannedBag)) {
                    return false;
                }
            }
            return true;
        }
        return false;
    }
}
