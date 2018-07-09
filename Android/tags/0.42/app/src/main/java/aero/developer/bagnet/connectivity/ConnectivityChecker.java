package aero.developer.bagnet.connectivity;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

/**
 * Created by User on 8/5/2016.
 */
public class ConnectivityChecker extends BroadcastReceiver {
    private OnConnectionChange onConnectionChange=null;

    public ConnectivityChecker(OnConnectionChange onConnectionChange) {
        this.onConnectionChange = onConnectionChange;
    }
    public ConnectivityChecker() {
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        int status = NetworkUtil.getConnectivityStatusString(context);
        if ("android.net.conn.CONNECTIVITY_CHANGE".equalsIgnoreCase(intent.getAction())) {
            if(status==NetworkUtil.NETWORK_STATUS_NOT_CONNECTED){
                if (onConnectionChange!=null){
                    onConnectionChange.notConnected();
                }
            }else{
                if (onConnectionChange!=null) {
                    onConnectionChange.connected();
                }
            }

        }


    }


}
