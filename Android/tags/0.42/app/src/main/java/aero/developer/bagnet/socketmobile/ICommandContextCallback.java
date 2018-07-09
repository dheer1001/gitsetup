package aero.developer.bagnet.socketmobile;

import com.socketmobile.scanapi.ISktScanObject;

/**
 * ICommandContextCallback defines the interface for
 * a Command complete callback. The ScanObj passed as input
 * of the callback corresponds to the ScanObj received by
 * the application when the command has completed
 */
public interface ICommandContextCallback {

    void run(ISktScanObject scanObj);
}
