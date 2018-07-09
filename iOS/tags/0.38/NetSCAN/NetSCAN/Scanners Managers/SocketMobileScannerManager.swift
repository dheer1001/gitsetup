//
//  SochetMobileScannerManager.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 10/6/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class SocketMobileScannerManager: NSObject , ScanApiHelperDelegate{
    
    public  var ApiHelper:ScanApiHelper!
    public  var Device:DeviceInfo!
    var Consumer:Timer!
    
    // initializerApiHelper
    func initialize (){
        if(UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if (self.ApiHelper == nil){
                self.ApiHelper=ScanApiHelper()
                self.ApiHelper.setDelegate(self)
                self.ApiHelper.open()
                Consumer=Timer.scheduledTimer(timeInterval: 0.2, target:self, selector:#selector(self.onTimer), userInfo:nil, repeats:true)
                if(AppDelegate.ShouldReturnToTestingScannerConnectivityView == false){
                    AppDelegate.getDelegate().AddDeviceConnectionView()
                }
            }else{
                if self.ApiHelper.isDeviceConnected()==false {
                    if(AppDelegate.ShouldReturnToTestingScannerConnectivityView == false){
                        AppDelegate.getDelegate().AddDeviceConnectionView()
                    }
                }
            }
        }
    }
    
    func onTimer(theTimer: Timer) {
        if theTimer == Consumer {
            self.ApiHelper.doScanApiReceive()
        }
    }
    
    func GetFirmwareVersion() {
        if self.Device != nil && self.ApiHelper.isDeviceConnected(){
            self.ApiHelper.postGetFirmwareVersion(self.Device, target: self, response: #selector(OnGetFirmware(obj:)))
        }else{
            AppDelegate.SOCKET_FIRMWARE_VERSION = ""
        }
    }
    
    func GetBatteryLevel() {
        if self.Device != nil && self.ApiHelper.isDeviceConnected() {
            self.ApiHelper.postGetBatteryLevel(fromDevice: self.Device, target: self, response: #selector(OnGetBattery(obj:)))
        }else{
            AppDelegate.SOCKET_BATTERY_LEVEL = ""
            MainViewController.AppHeaderInstance.updateBatteryLevel()
        }
    }
    
    @objc func OnGetFirmware (obj:ISktScanObject){
        let property : ISktScanProperty = obj.property()
        if property.getType() == kSktScanPropTypeVersion {
            AppDelegate.SOCKET_FIRMWARE_VERSION=String.init("\(property.version().getMajor()).\(property.version().getMiddle()).\(property.version().getMinor())")
        }
    }
    
    @objc func OnGetBattery (obj:ISktScanObject){
        let property : ISktScanProperty = obj.property()
        let A = toByteArray(property.getUlong())
        AppDelegate.SOCKET_BATTERY_LEVEL = String.init(A[1])
        MainViewController.AppHeaderInstance.updateBatteryLevel()
    }
    
    func toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafePointer(to: &value) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<T>.size) {
                Array(UnsafeBufferPointer(start: $0, count: MemoryLayout<T>.size))
            }
        }
    }
    
    func socketMobileBeep(){
        if self.Device != nil && self.ApiHelper.isDeviceConnected(){
            self.ApiHelper.postSetDataConfirmationError(self.Device, target: self, response:nil)
            self.ApiHelper.postSetDataConfirmationError(self.Device, target: self, response:nil)
        }
    }

    
    
    func onDeviceArrival(_ result: SKTRESULT, device deviceInfo: DeviceInfo!){
        if(UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            self.Device=deviceInfo;
            if((AppDelegate.vc.ConnectivityView.IsLoggingIn && AppDelegate.IsUSerINMainView == true) || AppDelegate.BINGO_INFO || UserDefaults.standard.value(forKey: "bingo") != nil){
                MainViewController.AppHeaderInstance.scannerConnected()
                AppDelegate.getDelegate().ScanManagerReturnFromBackground()
                AppDelegate.getDelegate().RemoveDeviceConnectionView()
                EnableTriggerButton()
                AppDelegate.vc.MainViewControllerPointer.RemoveOfflineScannerView()
            }
            else if (AppDelegate.ShouldReturnToTestingScannerConnectivityView){
                if(AppDelegate.vc.ConnectivityView.StillSearchingForScanner){
                    AppDelegate.vc.ConnectivityView.DeviceArrival()
                }else{
                    AppDelegate.vc.ConnectivityView.NavigateToMainView()
                }
            }
            if UserDefaults.standard.value(forKey: "bingo") != nil {
                AppDelegate.getDelegate().doClose()
            }
            MainViewController.AppHeaderInstance.fireBatteryLevelUpdating()
        }
    }
    
    func onDeviceRemoval(_ deviceRemoved: DeviceInfo!){
        if(UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized &&  ((AppDelegate.vc.ConnectivityView.IsLoggingIn && AppDelegate.IsUSerINMainView == true) || AppDelegate.BINGO_INFO || UserDefaults.standard.value(forKey: "bingo") != nil)){
            MainViewController.AppHeaderInstance.scannerDisconnected()
            AppDelegate.getDelegate().AddDeviceConnectionView()
            AppDelegate.SOCKET_BATTERY_LEVEL = ""
            MainViewController.AppHeaderInstance.updateBatteryLevel()
        }
    }
    
    func onDecodedData(_ device: DeviceInfo!, decodedData: ISktScanDecodedData!){
        if(UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized &&  ((AppDelegate.vc.ConnectivityView.IsLoggingIn && AppDelegate.IsUSerINMainView == true) || AppDelegate.BINGO_INFO || UserDefaults.standard.value(forKey: "bingo") != nil)){
            let rawData: UnsafeMutablePointer<UInt8> = decodedData!.getData()
            let rawDataSize: UInt32 = decodedData!.getSize()
            let data = Data(bytes: rawData, count: Int(rawDataSize))
            var readString:String = String(data: data, encoding: String.Encoding.utf8)!
            var Chars=Array(readString.characters)
            readString=""
            if(Chars.last == "\r" || Chars.last == " "){
                Chars.removeLast()
            }
            for i in 0..<Chars.count{
                readString.append(Chars[i])
            }
            AppDelegate.getDelegate().OnDecodedData(data: readString, showTrackingIdentifier: true)
        }
    }
    
    func EnableTriggerButton(){
        if self.Device != nil{
            if (self.ApiHelper.isDeviceConnected()){
                self.ApiHelper.postSetTriggerDevice(self.Device, action:3,target:self, response:nil)
            }
        }
    }
    
    func DisableTriggerButton(){
        if self.Device != nil{
            if (self.ApiHelper.isDeviceConnected()){
                self.ApiHelper.postSetTriggerDevice(self.Device, action:4,target:self, response:nil)
            }
        }
    }
    
    func DisablecodeContainer(){
        if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if(self.Device != nil && self.ApiHelper.isDeviceConnected()){
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:11,status:false,target:self.ApiHelper, response: nil)
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:15,status:false,target:self.ApiHelper, response: nil)
            }
        }
    }
    
    func EnablecodeContainer(){
        if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if(self.Device != nil && self.ApiHelper.isDeviceConnected()){
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:11,status:true,target:self.ApiHelper, response: nil)
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:15,status:true,target:self.ApiHelper, response: nil)
                
            }
        }
    }
        
    
    func DisablecodeBags(){
        if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if(self.Device != nil && self.ApiHelper.isDeviceConnected()){
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:27,status:false,target:self.ApiHelper, response: nil)
            }
        }
    }
    
    func EnablecodeBags(){
        if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if(self.Device != nil && self.ApiHelper.isDeviceConnected()){
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:27,status:true,target:self.ApiHelper, response: nil)
            }
        }
    }
    
    func DisableAllcodes(){
        if(UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if (self.Device != nil){
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:0,status:false,target:self.ApiHelper, response: nil) //NotSpecified
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:1,status:false,target:self.ApiHelper, response: nil) //AustraliaPost
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:2,status:false,target:self.ApiHelper, response: nil) //Aztec
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:3,status:false,target:self.ApiHelper, response: nil) //BooklandEan
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:4,status:false,target:self.ApiHelper, response: nil) //BritishPost
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:5,status:false,target:self.ApiHelper, response: nil) //CanadaPost
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:6,status:false,target:self.ApiHelper, response: nil) //Chinese2of5
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:7,status:false,target:self.ApiHelper, response: nil) //Codabar
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:8,status:false,target:self.ApiHelper, response: nil) //CodablockA
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:9,status:false,target:self.ApiHelper, response: nil) //CodablockF
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:10,status:false,target:self.ApiHelper, response: nil)//Code11
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:11,status:false,target:self.ApiHelper, response: nil) //Code39
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:12,status:false,target:self.ApiHelper, response: nil) //Code39Extended
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:13,status:false,target:self.ApiHelper, response: nil) //Code39Trioptic
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:14,status:false,target:self.ApiHelper, response: nil) //Code93
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:15,status:false,target:self.ApiHelper, response: nil) //Code128
                //self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:16,status:false,target:self.ApiHelper, response: nil) //DataMatrix
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:17,status:false,target:self.ApiHelper, response: nil) //DutchPost
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:18,status:false,target:self.ApiHelper, response: nil) //Ean8
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:19,status:false,target:self.ApiHelper, response: nil) //Ean13
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:20,status:false,target:self.ApiHelper, response: nil) //Ean128
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:21,status:false,target:self.ApiHelper, response: nil) //Ean128Irregular
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:22,status:false,target:self.ApiHelper, response: nil) //EanUccCompositeAB
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:23,status:false,target:self.ApiHelper, response: nil) //EanUccCompositeC
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:24,status:false,target:self.ApiHelper, response: nil) //Gs1Databar
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:25,status:false,target:self.ApiHelper, response: nil) //Gs1DatabarLimited
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:26,status:false,target:self.ApiHelper, response: nil) //Gs1DatabarExpanded
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:27,status:false,target:self.ApiHelper, response: nil) //Interleaved2of5
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:28,status:false,target:self.ApiHelper, response: nil) //Isbt128
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:29,status:false,target:self.ApiHelper, response: nil) //JapanPost
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:30,status:false,target:self.ApiHelper, response: nil) //Matrix2of5
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:31,status:false,target:self.ApiHelper, response: nil) //Maxicode
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:32,status:false,target:self.ApiHelper, response: nil) //Msi
                //  self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:33,status:false,target:self.ApiHelper, response: nil) //Pdf417
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:34,status:false,target:self.ApiHelper, response: nil) //Pdf417Micro
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:35,status:false,target:self.ApiHelper, response: nil) //Planet
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:36,status:false,target:self.ApiHelper, response: nil) //Plessey
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:37,status:false,target:self.ApiHelper, response: nil) //Postnet
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:38,status:false,target:self.ApiHelper, response: nil) //QRCode
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:39,status:true,target:self.ApiHelper, response: nil) //Standard2of5
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:40,status:false,target:self.ApiHelper, response: nil) //Telepen
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:41,status:false,target:self.ApiHelper, response: nil) //Tlc39
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:42,status:false,target:self.ApiHelper, response: nil) //UpcA
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:43,status:false,target:self.ApiHelper, response: nil) //UpcE0
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:44,status:false,target:self.ApiHelper, response: nil) //UpcE1
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:45,status:false,target:self.ApiHelper, response: nil) //UspsIntelligentMail
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:46,status:false,target:self.ApiHelper, response: nil) //DirectPartMarking
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:47,status:false,target:self.ApiHelper, response: nil) //HanXin
                self.ApiHelper.postSetSymbologyInfo(self.Device,symbologyId:48,status:false,target:self.ApiHelper, response: nil) //LastSymbologyID
            }
        }
    }
}
