package aero.developer.bagnet.interfaces;

public interface EngineInterface {

    // Cognex Scan Activity
    void onConnected();
    void onDisconnected();
    void enableCode128();
    void disableCode128();
    void enablePDF417();
    void disablePDF417();
    void disable2of5Interleaved();
    void enable2of5Interleaved();
    boolean isConnected();

    //SocketMobileScanActivity
    void enableScanner();
    void disableScanner();

    //SoftScannerActivity
    void restartPreviewAndDecode();


}
