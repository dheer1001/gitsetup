package aero.developer.bagnet.utils;

import android.content.Context;
import android.net.Uri;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;

import aero.developer.bagnet.R;


public class ULD_Utils {
    private static ULD_Utils ourInstance = new ULD_Utils();


    public static ULD_Utils getInstance(){
        if(ourInstance == null)
        {
            ourInstance = new ULD_Utils();
        }
        return ourInstance;
    }

    private ULD_Utils() {

    }
    public static Uri getImage( String imageKey){
        Uri path=null;
        if(imageKey!=null) {
            path = Uri.parse("file:///android_asset/Contours/" + imageKey + ".png");
        }
       BagLogger.log("Uri "+path);
        return path;
    }

    public static String container_GetType(Context context,String Key) {
        String typeName=null;
        JSONObject typesObject=getFileContent(context,R.raw.container_types);
        if(Key!=null) {
            try {
                typeName = typesObject.getString(Key);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return typeName != null ? typeName.trim() : null;
    }
    public static String container_GetSize(Context context,String key) {
        JSONObject typesObject=getFileContent(context,R.raw.container_sizes);
        String Size= null;
        if(key!=null) {
            try {
                Size = typesObject.getString(key);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return Size != null ? Size.trim() : null;

    }

    public static JSONObject container_GetContour(Context context,String key){
        JSONObject contourJson=null;
        JSONObject contour=getFileContent(context,R.raw.container_contours);
        if(key!=null) {
            try {
                contourJson = contour.getJSONObject(key);

            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return  contourJson;

    }
      public static String getContourWidth(JSONObject contourJson){
          String contourWidth=null;
          if ((contourJson!=null)) {
              try {
                  contourWidth = contourJson.getString("Width");
              } catch (JSONException e) {
                  e.printStackTrace();
              }
          }
          return contourWidth != null ? contourWidth.trim() : null;
      }
    public static String getContourHeight(JSONObject contourJson){
        String contourHeight=null;
        if (contourJson!=null) {
            try {
                contourHeight = contourJson.getString("Height");
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return contourHeight != null ? contourHeight.trim() : null;
    }
    public static String getContourType(JSONObject contourJson){
        String contourType=null;
        if(contourJson!=null) {
            try {
                contourType = contourJson.getString("Type");
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return contourType != null ? contourType.trim() : null;
    }

    public static  JSONObject getFileContent(Context context,int rawResourceFile) {
        JSONObject fileContent = null;
        InputStream inputStream = context.getResources().openRawResource(rawResourceFile);
        if(context!=null) {
            try {
                int size = inputStream.available();
                byte[] buffer = new byte[size];
                inputStream.read(buffer);
                inputStream.close();
                String Uld = new String(buffer, "UTF-8");
                fileContent = new JSONObject(Uld);
            } catch (IOException e) {
                e.printStackTrace();
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return fileContent;
    }

     public static String getULDType(String scannedBarcode){

         String UldType=null;
         if(scannedBarcode!=null && DataManUtils.isValidContainer(scannedBarcode)) {
            UldType= scannedBarcode.substring(0, 3);
         }
         return UldType != null ? UldType.trim() : null;
     }
    public static String getContainerTypeChar(String UldTypeCode){
        String containerType=null;
        if(UldTypeCode!=null) {
            containerType= UldTypeCode.substring(0,1);
        }

        return containerType != null ? containerType.trim() : null;
    }
    public static String getContainerSizeChar(String UldTypeCode){
        String containerSize = null;
        if(UldTypeCode!=null) {
         containerSize=UldTypeCode.substring(1,2);
        }
        return containerSize;
    }
    public static String getContainerContourChar(String UldTypeCode){
        String conatinerContour=null;
        if(UldTypeCode!=null) {
           conatinerContour= UldTypeCode.substring(2);
        }
        return conatinerContour != null ? conatinerContour.trim() : null;
    }
    public static String getSerialNumber(String scannedBarcode){
        String serialNumber=null;
        if(scannedBarcode!=null && DataManUtils.isValidContainer(scannedBarcode)) {
            serialNumber=scannedBarcode.substring(4,9);
        }
        return serialNumber != null ? serialNumber.trim() : null;
    }

    public static String getOwnerName(String scannedBarcode){
        String ownerName=null;
        if(scannedBarcode!=null && DataManUtils.isValidContainer(scannedBarcode)) {
            ownerName=scannedBarcode.substring(10, scannedBarcode.length() - 1);
        }
        return ownerName != null ? ownerName.trim() : null;
    }


}
