package aero.developer.bagnet.Sign_In_Timeout;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

import aero.developer.bagnet.Constants;
import aero.developer.bagnet.utils.Preferences;

/**
 * Created by Mohamad Itani on 23-Feb-18.
 */
public class AlarmHelper {
    private static AlarmHelper ourInstance;
    private AlarmManager alarmMgr;
    private Context context;

    public static AlarmHelper getInstance(Context context) {
        if (ourInstance == null) {
            ourInstance = new AlarmHelper(context);
        }
        return ourInstance;
    }

    private AlarmHelper(Context context) {
        alarmMgr = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        this.context = context;
    }

    public void setAlarm(boolean auto) {
        long time = System.currentTimeMillis() + (Constants.numSeconds);
        setAlarm(time, auto);
    }

    private void setAlarm(long time, boolean auto) {
        if (!auto) {
            cancel();
        }
        Intent intent = new Intent(context, AlarmReceiver.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_ONE_SHOT);
        alarmMgr.set(AlarmManager.RTC_WAKEUP, time, pendingIntent);
    }

    public void cancel() {
        Intent intent = new Intent(context, AlarmReceiver.class);
        PendingIntent alarmIntent = PendingIntent.getBroadcast(context, 0, intent, 0);
        if (alarmIntent != null) {
            alarmMgr.cancel(alarmIntent);
        }
        Preferences.getInstance().removeAlarmCounter(context);
    }
}