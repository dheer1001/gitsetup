//
//  SoftScannerManager.swift
//  NetSCAN
//
//  Created by User on 10/21/16.
//  Copyright © 2016 User. All rights reserved.
//

import Foundation

class SoftScannManager:UIViewController,CMBReaderDeviceDelegate{
    
    var readerDevice:CMBReaderDevice?
    var readerDeviceView:UIView!
    var cancelButton:UIButton!
    var fullScreen:Bool!
    
    var EnableContainers:Bool!
    var EnableBags:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=primaryColor()
        AppDelegate.IsUSerINMainView = false
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.readerDevice=nil
        
        if fullScreen {
            readerDeviceView=UIView(frame: CGRect(x:0, y:UIApplication.shared.statusBarFrame.height, width:UIScreen.main.bounds.width, height:Constants.UIScreenMainHeight-UIApplication.shared.statusBarFrame.height))
        }
        else {
            readerDeviceView=UIView(frame: CGRect(x:0, y:50, width:UIScreen.main.bounds.width, height:Constants.UIScreenMainHeight/3))
        }
        
        readerDeviceView.backgroundColor=UIColor.gray
        self.view.addSubview(readerDeviceView)
        
        self.cancelButton=UIButton(frame: CGRect(x:readerDeviceView.frame.size.width-65, y:readerDeviceView.frame.origin.y+readerDeviceView.frame.size.height-60, width:50, height: 50))
        self.cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        let image = UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate)
        self.cancelButton.setBackgroundImage(image, for: .normal)
        self.cancelButton.tintColor=UIColor.red
        self.view.addSubview(self.cancelButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initDevice()
    }
    
    func initDevice() {
        self.readerDevice=CMBReaderDevice.readerOfDeviceCamera(with: CDMCameraMode.noAimer, previewOptions:CDMPreviewOption.alwaysShow, previewView: self.readerDeviceView)
        self.readerDevice!.delegate=self
        self.readerDevice?.connect { (error:Error!) in
            if error == nil {
                self.readerDevice?.startScanning()
                self.setSymbologies()
            }
        }
    }
    
    func setSymbologies() {
        self.readerDevice?.setSymbology(CMBSymbologyQR, enabled: true, completion: nil)
        self.readerDevice?.setSymbology(CMBSymbologyPdf417, enabled: true, completion: nil)
        self.readerDevice?.setSymbology(CMBSymbologyI2o5, enabled: AppDelegate.EnableBags, completion: nil)
        self.readerDevice?.setSymbology(CMBSymbologyC128, enabled: AppDelegate.EnableContainers, completion: nil)
    }
    
    @objc func cancelPressed() {
        close()
        AppDelegate.getDelegate().ScanManagerReturnFromBackground()
    }
    
    func close (){
        self.readerDevice?.stopScanning()
        self.readerDevice?.disconnect()
        self.readerDevice=nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissScannerView"), object: nil)
    }
    
    func  availabilityDidChange(ofReader reader: CMBReaderDevice!) {
        print("availabilityDidChange")
    }
    
    func connectionStateDidChange(ofReader reader: CMBReaderDevice!) {
        print("connectionStateDidChange")
    }
    
    func didReceiveReadResult(fromReader reader: CMBReaderDevice!, results readResults: CMBReadResults!) {
        for readResult: CMBReadResult in readResults.readResults as! [CMBReadResult]! {
            if readResult.xml != nil{
                let xml: Data? = readResult.xml
                let parser = CDMXMLParser(data: xml)
                let root: CDMXMLElement? = parser?.rootElement()
                let DMQS_Parser = DMQSXmlResultParser(rootElement: root)
                let result: [AnyHashable: Any] = DMQS_Parser!.parseForNotification()
                if result["goodRead"] as! Bool{
                    let deadlineTime = DispatchTime.now() + .milliseconds(100)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        AppDelegate.getDelegate().OnDecodedData(data:(result["readString"] as? String)!,showTrackingIdentifier: true)
                    }
                }
            }
        }
        close()
    }
}
