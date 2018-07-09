package aero.developer.bagnet;

import android.annotation.SuppressLint;
import android.app.Application;
import android.content.Context;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffColorFilter;
import android.graphics.drawable.Drawable;
import android.media.MediaCodec;
import android.util.Base64;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import aero.developer.bagnet.objects.TrackingConfiguration;
import aero.developer.bagnet.utils.DataManUtils;
import aero.developer.bagnet.utils.Preferences;

import static aero.developer.bagnet.presenters.TrackingPointPresenter.CONFIGURATIONS;

/**
 * Created by User on 9/16/2016.
 */
@SuppressLint("Registered")
public class AppController extends Application {

    static AppController instance = null;


    public static synchronized AppController getInstance() {
        return instance;
    }


    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
    }

    public int getPrimaryColor() {
        if(Preferences.getInstance().isNightMode(getApplicationContext()))
            return getResources().getColor(R.color.black);
        return getResources().getColor(R.color.white);
    }

    public int getSecondaryColor() {
        if(Preferences.getInstance().isNightMode(getApplicationContext()))
            return getResources().getColor(R.color.white);
        return getResources().getColor(R.color.black);
    }
    public int getPrimaryGrayColor() {
        if(Preferences.getInstance().isNightMode(getApplicationContext()))
            return getResources().getColor(R.color.gray);
        return getResources().getColor(R.color.dark_gray);
    }

    public int getSecondaryGrayColor() {
        if(Preferences.getInstance().isNightMode(getApplicationContext()))
            return getResources().getColor(R.color.dark_gray);
        return getResources().getColor(R.color.gray);
    }

    public int getheaderViewColor() {
        if(Preferences.getInstance().isNightMode(getApplicationContext()))
            return getResources().getColor(R.color.gray);
        return getResources().getColor(R.color.headerBox_background);
    }


    public int gridViewBackground() {
        if(Preferences.getInstance().isNightMode(getApplicationContext()))
            return getResources().getColor(R.color.gridview_whitebackground);
        return getResources().getColor(R.color.gridviewBackground);
    }

    public int getbagImageColor() {
        if(Preferences.getInstance().isNightMode(getApplicationContext()))
            return getResources().getColor(R.color.silver);
        return getResources().getColor(R.color.dark_gray);
    }

    public int getbagContainerColor() {
        if(Preferences.getInstance().isNightMode(getApplicationContext()))
            return getResources().getColor(R.color.dark_gray);
        return getResources().getColor(R.color.silver);
    }

    public int getbagDetailBackground() {
        if(Preferences.getInstance().isNightMode(getApplicationContext()))
            return getResources().getColor(R.color.bag_details_background);
        return getResources().getColor(R.color.trans_gray);
    }


    public int getprimaryBackroundViewColor() {
        if(Preferences.getInstance().isNightMode(getApplicationContext()))
            return getResources().getColor(R.color.light_gray);

         return getResources().getColor(R.color.reverse_light_gray);
        }

    public int getsecondaryBackroundViewColor() {
        if(Preferences.getInstance().isNightMode(getApplicationContext()))
            return getResources().getColor(R.color.reverse_light_gray);

        return getResources().getColor(R.color.light_gray);
    }

    public int getPrimaryOrangeColor() {
        if(Preferences.getInstance().isNightMode(getApplicationContext()))
            return getResources().getColor(R.color.black);
        return getResources().getColor(R.color.orange);
    }

    public int getCapturebackground() {
        if(Preferences.getInstance().isNightMode(getApplicationContext()))
            return getResources().getColor(R.color.transblack);
        return getResources().getColor(R.color.transwhite);
    }

    public static Drawable getTintedDrawable(Drawable drawable, int color) {
        PorterDuffColorFilter porterDuffColorFilter = new PorterDuffColorFilter(color, PorterDuff.Mode.SRC_IN);
        drawable.setColorFilter(porterDuffColorFilter);
        return drawable;
    }

    public String sha256(String data) throws MediaCodec.CryptoException {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            digest.reset();

            byte[] input = digest.digest(data.getBytes("UTF-8"));

            for (int i = 0; i < 1000; i++) {
                digest.reset();
                input = digest.digest(input);
            }
            return Base64.encodeToString(input,2);
        }catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    public static String sha256_old(String base) {
        try{
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(base.getBytes("UTF-8"));
            StringBuffer hexString = new StringBuffer();

            for (int i = 0; i < hash.length; i++) {
                String hex = Integer.toHexString(0xff & hash[i]);
                if(hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }

            return hexString.toString();
        } catch(Exception ex){
            throw new RuntimeException(ex);
        }
    }

    public List<String> getAirportAirlineFromString(String Str) {

        if(Str !=null && Str.length()>0) {
            return Arrays.asList(Str.split("\\s*,\\s*"));
        }
        return new ArrayList<>();
    }

    public byte[] longToBytes(long x) {
        @SuppressLint("InlinedApi") ByteBuffer buffer = ByteBuffer.allocate(Long.BYTES);
        buffer.putLong(x);
        return buffer.array();
    }

    public String loadJSONFromAsset(String filename) {
        String json = null;
        try {
            InputStream is = getApplicationContext().getAssets().open(filename);
            int size = is.available();
            byte[] buffer = new byte[size];
            is.read(buffer);
            is.close();
            json = new String(buffer, "UTF-8");
        } catch (IOException ex) {
            ex.printStackTrace();
            return null;
        }
        return json;
    }

    public boolean isSelectedAirportHaveTrackingConfigurations() {
        Gson gson = new Gson();
        HashMap<String,Object> map= new HashMap<>();
        HashMap<String, String> config_map = new HashMap<>();
        ArrayList<TrackingConfiguration> tempList = new ArrayList<>();
        ArrayList<TrackingConfiguration> trackingList = new ArrayList<>();

        if(Preferences.getInstance().getTrackingMap(getApplicationContext())!=null) {
            map = (HashMap<String, Object>) gson.fromJson(Preferences.getInstance().getTrackingMap(getApplicationContext()), map.getClass());
        }
        if(map !=null && Preferences.getInstance().getAirportcode(getApplicationContext())!=null) {
            String map_value = (String) map.get(Preferences.getInstance().getAirportcode(getApplicationContext()));
            config_map = (HashMap<String, String>) gson.fromJson(map_value, config_map.getClass());


//            if (config_map != null) {
//                String s = new Gson().toJson(config_map.get(CONFIGURATIONS));
//                trackingList = gson.fromJson(s, new TypeToken<ArrayList<TrackingConfiguration>>() {
//                }.getType());
//            }
        }
//        return config_map != null && filterTrackingList(trackingList)!=null && filterTrackingList(trackingList).size()>0
//                && config_map.get(CONFIGURATIONS)  != null;
        return config_map != null
                && config_map.get(CONFIGURATIONS)  != null;
    }

    public String prepareTrackingPoint(TrackingConfiguration item) {
        if(item !=null){
            return (item.getAirport_code() + item.getTracking_id() +
                    item.getLocation() + item.getIndicator_for_unknown_bag_mgmt() +
                    item.getIndicator_for_container_scanning() + validatePurpose(item.getPurpose(),item.getBingo_sheet_scanning()));
        }else {
            return "";
        }
    }

    public ArrayList<TrackingConfiguration> filterTrackingList(List<TrackingConfiguration> list){
        ArrayList<TrackingConfiguration> tempList = new ArrayList<>();
        for (TrackingConfiguration item: list) {
            if(DataManUtils.isValidTrackingLocationWithoutErrorDialog(prepareTrackingPoint(item),getApplicationContext()) ) {
                tempList.add(item);
            }
        }
        return tempList;
    }

    public String validateAirportCode (String airport_code) {
        if(airport_code == null || airport_code.equalsIgnoreCase("") || airport_code.length() ==0 )
            return "   ";

            if(airport_code.length()<3) {
                switch (airport_code.length()) {
                    case 1:
                        return airport_code + "  ";
                    case 2:
                        return airport_code + " ";
                }
            }

            if(airport_code.length()>3) {
                return airport_code.substring(0,3);
            }
            return airport_code;
        }

    public String validateTracking_ID (String trackingID){
        if(trackingID == null || trackingID.equalsIgnoreCase("") || trackingID.length() ==0 )
            return "        "; // 8 spaces

        if(trackingID.length() <8) {
            switch (trackingID.length()) {
                case 1:
                    return trackingID + "       "; // 7 spaces
                case 2:
                    return trackingID + "      "; // 6 spaces
                case 3:
                    return trackingID + "     "; // 5 spaces
                case 4:
                    return trackingID + "    "; // 4 spaces
                case 5:
                    return trackingID + "   "; // 3 spaces
                case 6:
                    return trackingID + "  "; // 2 spaces
                case 7:
                    return trackingID + " "; // 1 spaces
            }
        }
        if(trackingID.length() >8) {
            return trackingID.substring(0,8);
        }
        return trackingID;
    }

    public String validateLocation (String location) {
        if(location == null || location.equalsIgnoreCase("") || location.length() ==0 )
            return "          "; // 10 spaces

        if(location.length() <10) {
            switch (location.length()) {
                case 1:
                    return location + "         "; // 9 spaces
                case 2:
                    return location + "        "; // 8 spaces
                case 3:
                    return location + "       "; // 7 spaces
                case 4:
                    return location + "      "; // 6 spaces
                case 5:
                    return location + "     "; // 5 spaces
                case 6:
                    return location + "    "; // 4 spaces
                case 7:
                    return location + "   "; // 3 spaces
                case 8:
                    return location + "  "; // 2 spaces
                case 9:
                    return location + " "; // 1 spaces
            }
        }
        if(location.length() >10) {
            return location.substring(0,10);
        }
        return location;
    }

    public String validateunknownBag(String unknownBag) {
        if(unknownBag == null || unknownBag.equals(""))
            return "I";
        if(unknownBag.length()>1){
            return "I";
        }
        return unknownBag;
    }

    public String validatecontainer(String container) {
        if(container == null || container.equals(""))
            return "N";
        if(container.length()>1){
            return "N";
        }
        return container;
    }

    public String validatePurpose(String purpose,String bingo_value) {
        if(purpose == null || purpose.equals("") || purpose.length() == 0) {
            return "T";
        }
        if(purpose.equalsIgnoreCase("TRACK")){
            return "T";
        }
        if(purpose.equalsIgnoreCase("LOAD"))
        {
            if(bingo_value.equalsIgnoreCase("YES")) {
                return "B";
            }else {
                return "L";
            }
        }

        if(!purpose.substring(0,1).equalsIgnoreCase("T") && !purpose.substring(0,1).equalsIgnoreCase("L") ) {
            return "T";
        }
        return purpose.substring(0,1);
    }

    public String validateGroup(String groupName) {
        if (groupName == null || groupName.equalsIgnoreCase("") || groupName.length() == 0) {
            return "";
        }
        return groupName;
    }

    public boolean isTrackingExistInList(String trackingPoint,ArrayList<TrackingConfiguration> list ) {
        if(list!=null) {
            for (TrackingConfiguration item : list) {
                if (AppController.getInstance().prepareTrackingPoint(item).equalsIgnoreCase(trackingPoint)) {
                    return true;
                }
            }
        }
        return false;
    }

    public ArrayList<TrackingConfiguration> moveSelectedToHead(String trackingPoint,ArrayList<TrackingConfiguration> list ) {
        ArrayList<TrackingConfiguration> tempList = new ArrayList<>();
        tempList = list;
        TrackingConfiguration temp ;
        for (int i =0 ; i<list.size();i++){
            if(AppController.getInstance().prepareTrackingPoint(list.get(i)).equalsIgnoreCase(trackingPoint)) {
               temp = list.get(i);
                tempList.remove(i);
                tempList.add(0,temp);
            }
        }
        return tempList;
    }

    public String preparePurposeFromTypeEvent(String typeEvent) {
        if(typeEvent.equalsIgnoreCase("T") ) {
            return "Track";
        }if (typeEvent.equalsIgnoreCase("L")  || typeEvent.equalsIgnoreCase("B")) {
            return "Load";
        }
          return   "";
    }


    public void addTrackingPointToRecentlyUsed(Context context, TrackingConfiguration trackingConfiguration) {
        Gson gson = new Gson();
        String mapString = Preferences.getInstance().getRecentlyUsedTracking(getApplicationContext());
        String key = Preferences.getInstance().getUserID(context)+"@"+Preferences.getInstance().getCompanyID(context);

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
    }
}