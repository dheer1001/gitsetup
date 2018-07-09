package aero.developer.bagnet.interfaces;

/**
 * Created by User on 8/17/2016.
 */
public interface SettingsActions {
    void onClearContainer();
    void onClearFlight();
    void onClearTrackingPoint();
    void onCreditsClicked(String cognexFirmwareVersion , String cognexBattery , String socketFirmwareVersion , String socketBattery,
                          String fullDecodeVersion,String controlLogicVersion);
    void onsignOutClicked();
    void onRestartClicked();
    void onSignoutFailed(String error_message);
}
