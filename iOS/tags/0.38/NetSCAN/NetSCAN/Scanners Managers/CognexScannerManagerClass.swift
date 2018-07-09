//
//  CognexScannerManagerClass.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 1/18/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class CognexScannerManagerClass:NSObject,CMBReaderDeviceDelegate{
    
    var duplicatedCallBack:Bool = false
    
    var duplicateTimer:Timer!
    var BatteryLevelTimer:Timer!
    
    
    // MARK:- readerDeviceInitializer
    
    func Initialize(){
        self.initDevice()
    }
    
    var readerDevice:CMBReaderDevice?
    
    func initDevice() {
        if readerDevice == nil {
            DispatchQueue(label: "MXInit", attributes: []).async(execute: { () -> Void in
                self.readerDevice = CMBReaderDevice.readerOfMX()
                DispatchQueue.main.async(execute: { () -> Void in
                    self.readerDevice!.delegate = self
                    self.connectToReaderDevice()
                })
            })
        }else{
            self.readerDevice!.delegate = self
            connectToReaderDevice()
        }
    }
    
    func connectToReaderDevice() {
        if self.readerDevice!.availability == CMBReaderAvailibilityAvailable && self.readerDevice!.connectionState != CMBConnectionStateConnected {
            self.readerDevice!.connect(completion: { (error:Error?) in
                if error != nil {
                    print("Disconnected")
                } else {
                    self.continuesMode(ON_OFF: false)
                }
            })
        } else if self.readerDevice!.connectionState != CMBConnectionStateConnected{
            print("Disconnected")
            self.readerDevice!.connect(completion: { (error:Error?) in
                if error != nil {
                    print("Disconnected")
                } else {
                    self.continuesMode(ON_OFF: false)
                }
            })
        }
    }
    
    func disconnectReaderDevice() {
        if (self.readerDevice != nil && self.readerDevice!.connectionState != CMBConnectionStateDisconnected){
            self.readerDevice!.disconnect()
        }
    }
    
    // MARK:-dataManConfig
    
    func ON_OFF_Interleaved2OF5(ON_OFF:String){
        if (readerDevice?.dataManSystem() != nil){
            readerDevice?.dataManSystem().sendCommand("SET SYMBOL.I2O5 \(ON_OFF)")
        }
    }
    
    func ON_OFF_128BarCode(ON_OFF:String){
        if (readerDevice?.dataManSystem() != nil){
            readerDevice?.dataManSystem().sendCommand("SET SYMBOL.C128 \(ON_OFF)")
        }
    }
    
    func ON_OFF_PDF417(ON_OFF:String){
        if (readerDevice?.dataManSystem() != nil){
            readerDevice?.dataManSystem().sendCommand("SET SYMBOL.PDF417 \(ON_OFF)")
            readerDevice?.dataManSystem().sendCommand("SET SYMBOL.QR ON")
            readerDevice?.dataManSystem().sendCommand("SET POWER.POWEROFF-TIMEOUT 2640")
            readerDevice?.dataManSystem().sendCommand("SET POWER.HIBERNATE-TIMEOUT 2640")
        }
    }
    
    func continuesMode (ON_OFF:Bool) {
        if (readerDevice?.dataManSystem() != nil && readerDevice?.connectionState==CMBConnectionStateConnected){
            if ON_OFF {
                do {
                    // Format
                    let formatScript = Bundle.main.path(forResource:"format_script", ofType: "js")
                    let formatScriptContent = try String(contentsOfFile: formatScript!, encoding: String.Encoding.utf8)
                    let formatScriptData = formatScriptContent.data(using: .utf8)
                    let bytesSize = formatScriptContent.lengthOfBytes(using: .utf8)
                    readerDevice?.dataManSystem().sendCommand("SCRIPT.LOAD \(bytesSize)", with: formatScriptData, timeout:5*1000, expectBinaryResponse: false, callback: { CDMResponse in})
                    
                    //Com
                    let comScript = Bundle.main.path(forResource:"com_script", ofType: "js")
                    let comScriptContent = try String(contentsOfFile: comScript!, encoding: String.Encoding.utf8)
                    let comScriptData = comScriptContent.data(using: .utf8)
                    let comBytesSize = comScriptContent.lengthOfBytes(using: .utf8)
                    readerDevice?.dataManSystem().sendCommand("SET COM.SCRIPT \(comBytesSize)", with: comScriptData, timeout:5*1000, expectBinaryResponse: false, callback: { CDMResponse in})
                    
                    // Set com On
                    readerDevice?.dataManSystem().sendCommand(("SET COM.SCRIPT-ENABLED ON"))
                    
                    //Set Format Mode
                    readerDevice?.dataManSystem().sendCommand(("SET FORMAT.MODE 1"))
                    
                    // Set No beep
                    readerDevice?.dataManSystem().sendCommand("SET BEEP.GOOD 0 0")
                    
                } catch (let error) {
                    print("Error while processing script file: \(error)")
                }
            } else {
                readerDevice?.dataManSystem().sendCommand(("SET COM.SCRIPT-ENABLED OFF"))
                readerDevice?.dataManSystem().sendCommand("SET BEEP.GOOD 1 1")
            }
        }
    }
    
    func dataManBeep() {
        if readerDevice?.dataManSystem() != nil && readerDevice?.connectionState == CMBConnectionStateConnected {
            AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem().sendCommand("BEEP 2 2")
        }
    }
    
    func GetFirmwareVersion (){
        if (readerDevice?.dataManSystem() != nil && readerDevice?.connectionState==CMBConnectionStateConnected){
            readerDevice?.dataManSystem().sendCommand(("GET DEVICE.FIRMWARE-VER")) { CDMResponse in
                AppDelegate.COGNEX_FIRMWARE_VERSION = (CDMResponse?.payload!)!
            }}else{
            AppDelegate.COGNEX_FIRMWARE_VERSION = ""
        }
    }
    
    func GetBatteryLevel (){
        if (readerDevice?.dataManSystem() != nil && readerDevice?.connectionState==CMBConnectionStateConnected){
            readerDevice?.dataManSystem().sendCommand(("GET BATTERY.CHARGE")) { CDMResponse in
                if CDMResponse?.payload != nil {
                    AppDelegate.COGNEX_BATTERY_LEVEL=(CDMResponse?.payload!)!
                    MainViewController.AppHeaderInstance.updateBatteryLevel()
                }
            }
        }else{
            AppDelegate.COGNEX_BATTERY_LEVEL=""
            MainViewController.AppHeaderInstance.updateBatteryLevel()
        }
    }
    
    
    
//    func GetBatteryCharge (){
//
//    }
    
    func setDuplicatedCallBack() {
        self.duplicatedCallBack=false
    }
    // MARK:-readerDeviceDelegate
    
    func availabilityDidChange(ofReader reader: CMBReaderDevice!) {
        print("DeviceSelectorVC availabilityDidChangeOfReader")
        print("readerAvailable: \(reader.availability == CMBReaderAvailibilityAvailable)")
        if (reader.availability != CMBReaderAvailibilityAvailable) {
            disconnectReaderDevice()
        } else {
            self.readerDevice = CMBReaderDevice.readerOfMX()
            self.readerDevice!.delegate = self
            if (self.readerDevice!.availability == CMBReaderAvailibilityAvailable) {
                connectToReaderDevice()
            }
        }
    }
    
    func connectionStateDidChange(ofReader reader: CMBReaderDevice!) {
        if self.readerDevice!.connectionState == CMBConnectionStateConnected {
            if !duplicatedCallBack {
                if(UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
                    if(AppDelegate.BINGO_INFO || (AppDelegate.vc.ConnectivityView.IsLoggingIn && AppDelegate.IsUSerINMainView == true) || UserDefaults.standard.value(forKey: "bingo") != nil){
                        ON_OFF_PDF417(ON_OFF: "ON")
                        AppDelegate.getDelegate().ConnectivityTest_ScannerWasConnected()
                        AppDelegate.getDelegate().RemoveDeviceConnectionView()
                        AppDelegate.getDelegate().doClose()
                        AppDelegate.vc.MainViewControllerPointer.RemoveOfflineScannerView()
                        AppDelegate.getDelegate().ScanManagerReturnFromBackground()
                    } else if (AppDelegate.ShouldReturnToTestingScannerConnectivityView){
                        if(AppDelegate.vc.ConnectivityView.StillSearchingForScanner){
                            AppDelegate.getDelegate().ConnectivityTest_ScannerWasConnected()
                            AppDelegate.getDelegate().RemoveDeviceConnectionView()
                            AppDelegate.getDelegate().doClose()
                            AppDelegate.getDelegate().ScanManagerReturnFromBackground()
                        } else {
                            AppDelegate.vc.ConnectivityView.NavigateToMainView()
                        }
                    }
                }
                self.duplicatedCallBack = true
                duplicateTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(setDuplicatedCallBack), userInfo: nil, repeats: false)
            }
        } else {
            if(UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
                if(AppDelegate.BINGO_INFO || (AppDelegate.vc.ConnectivityView.IsLoggingIn && AppDelegate.IsUSerINMainView == true) || UserDefaults.standard.value(forKey: "bingo") != nil){
                    MainViewController.AppHeaderInstance.scannerDisconnected()
                    AppDelegate.getDelegate().AddDeviceConnectionView()
                }
            }
            AppDelegate.COGNEX_BATTERY_LEVEL = ""
        }
        MainViewController.AppHeaderInstance.fireBatteryLevelUpdating()
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
                    if(UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
                        if(AppDelegate.BINGO_INFO || (AppDelegate.vc.ConnectivityView.IsLoggingIn && AppDelegate.IsUSerINMainView == true) || UserDefaults.standard.value(forKey: "bingo") != nil){
                            AppDelegate.getDelegate().OnDecodedData(data: result["readString"] as! String!,showTrackingIdentifier: true)
                        }
                    }
                }
            }
        }
    }
}
