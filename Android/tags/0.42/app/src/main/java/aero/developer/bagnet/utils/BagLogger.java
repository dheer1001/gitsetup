package aero.developer.bagnet.utils;

import aero.developer.bagnet.Constants;

/**
 * Created by User on 8/3/2016.
 */
public class BagLogger {


    public static void log(String stringData){
        if (Constants.enableDebug){
            System.out.println("BagLogger ==> "+ stringData);
        }
    }
}
