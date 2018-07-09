//
//  ScanManager.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 9/19/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
class ScanManager: UIViewController{
    
    public static var LocalStorage=UserDefaultsManager()

    var ContainerViewTimer:Timer!
    var duplicateTimer:Timer!
    var ApiCall:ApiCallSwift!
    var TimeCount = 60
    var BingoDialog:UIView!
    var duplicatedCallBack:Bool = false
    var dialog :UIView!
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func initialize (){
        if(UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if((AppDelegate.vc.ConnectivityView.SocketMobile) != nil && (AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper) != nil && (AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper.isDeviceConnected()) && AppDelegate.ShouldReturnToTestingScannerConnectivityView == false){
                self.CheckForViews()
            }
        }
        else if(UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            if((AppDelegate.vc.ConnectivityView.CognexManager) != nil && (AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem()) != nil && (AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.connectionState == CMBConnectionStateConnected) && AppDelegate.ShouldReturnToTestingScannerConnectivityView == false){
                self.CheckForViews()
            }
        }
    }
    
    func checkForBannerViews (){
        
        var trackingPointRequired = false
        var containerRequired = false
        
        let stillValidTrackingPoint = IsStillValidTrackingLocation()
        let trackingPoint = ScanManager.LocalStorage.GetTrackingLocation()
        let containerID = ScanManager.LocalStorage.GetContainerID()
        
        let containerInput = AppDelegate.getDelegate().getContainerInput(scannedBarcode: trackingPoint)
        
        // tracking point requirments
        if (trackingPoint == "" || stillValidTrackingPoint==false){
            trackingPointRequired = true
        }
        if ((containerInput == "Y" && containerID == "") || containerInput == "C"){
            containerRequired = true
        }
        
        AppDelegate.vc.MainViewControllerPointer.removeBannerView()
        
        if trackingPointRequired {
            AppDelegate.vc.MainViewControllerPointer.AddScanTrackingPointView()
        } else if containerRequired {
            AppDelegate.vc.MainViewControllerPointer.AddContainerRequiredView()
        } else {
            AppDelegate.vc.MainViewControllerPointer.AddStartScanningBagsView()
        }
    }
    
    func CheckForViews(){
        if  (((AppDelegate.vc.ConnectivityView.SocketMobile) != nil && (AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper) != nil && AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper.isDeviceConnected() && AppDelegate.IsUSerINMainView == true && UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized) || (UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized && AppDelegate.vc.ConnectivityView.CognexManager != nil && AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem() != nil && AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.connectionState == CMBConnectionStateConnected && AppDelegate.IsUSerINMainView == true ) || (UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized && AppDelegate.IsUSerINMainView == true)){
            if (UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
                MainViewController.AppHeaderInstance.scannerConnected()
            }else if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            }else if (UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
                MainViewController.AppHeaderInstance.scannerConnected()
            }
            
            AppDelegate.getDelegate().doClose()
            if (AppDelegate.getDelegate().getTypeEvent(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()) == "B" || ScanManager.LocalStorage.GetTrackingLocation() == "" || IsStillValidTrackingLocation()==false){
                AppDelegate.getDelegate().RemoveContainerView()
                self.DisablecodeBags()
                self.DisablecodeContainer()
            }
            else if(ScanManager.LocalStorage.GetContainerID() == ""){
                let seconds = ScanManager.LocalStorage.GetTrackingPointValidityUntil().timeIntervalSince(Date())
                AppDelegate.getDelegate().UpdateLocationOnAppHeader(seconds:Int(seconds),trackingLocation:AppDelegate.getDelegate().getTrackingLocation(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()))
                
                let UnknownBag = AppDelegate.getDelegate().getUnknownBags(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation())
                if(AppDelegate.getDelegate().getContainerInput(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()) != "N"){
                    self.DisablecodeBags()
                    AppDelegate.getDelegate().RemoveContainerView()
                }else if (UnknownBag == "S" && ScanManager.LocalStorage.getFlightNumber() != ""){
                    self.EnablecodeBags()
                }
                if(UnknownBag == "S"){
                    if (ScanManager.LocalStorage.getFlightNumber() == ""){
                        AppDelegate.getDelegate().AddFlightInformationView(bagView: false, bagNumber:"", UnknownBag: "S")
                    }else{
                        self.AddAirPlaneView()
                    }
                } else if (UnknownBag == "U"){
                    if (AppDelegate.ScanningBagTag != ""){
                        AppDelegate.getDelegate().AddFlightInformationView(bagView:true, bagNumber:AppDelegate.ScanningBagTag, UnknownBag: "U")
                    }
                } else if (UnknownBag == "I" && (AppDelegate.getDelegate().getContainerInput(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()) == "N")){
                    self.EnablecodeBags()
                }
                if(UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
                    if(AppDelegate.getDelegate().getContainerInput(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()) == "N"){
                        AppDelegate.getDelegate().EnableBagOrContainer()
                    }
                }
            }else{
                let UnknownBag = AppDelegate.getDelegate().getUnknownBags(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation())
                if(UnknownBag == "S"){
                    if (ScanManager.LocalStorage.getFlightNumber() == ""){
                        AppDelegate.getDelegate().AddFlightInformationView(bagView: false, bagNumber:"", UnknownBag: "S")
                    }else{
                        self.AddAirPlaneView()
                    }
                } else if (UnknownBag == "U"){
                    if (AppDelegate.ScanningBagTag != ""){
                        AppDelegate.getDelegate().AddFlightInformationView(bagView:true, bagNumber:AppDelegate.ScanningBagTag, UnknownBag: "U")
                    }
                }
                let seconds = ScanManager.LocalStorage.GetTrackingPointValidityUntil().timeIntervalSince(Date())
                AppDelegate.getDelegate().UpdateLocationOnAppHeader(seconds:Int(seconds),trackingLocation:AppDelegate.getDelegate().getTrackingLocation(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()))
                self.EnablecodeContainer()
                self.EnablecodeBags()
            }
            if(AppDelegate.getDelegate().getContainerInput(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()) != "C" && AppDelegate.getDelegate().getContainerInput(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()) != "" && ScanManager.LocalStorage.GetContainerID() != "" && IsStillValidTrackingLocation()==true && AppDelegate.ScanningBagTag == ""){
                if(ScanManager.LocalStorage.getFlightInformation().value(forKey: "flight_type") != nil){
                    self.EnablecodeContainer()
                    self.EnablecodeBags()
                }
            }
            if (AppDelegate.getDelegate().getContainerInput(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation()) != "C" && ScanManager.LocalStorage.GetContainerID() != "" && IsStillValidTrackingLocation()==true){
                let container = buildContainerObjFromScan(containerScanString: ScanManager.LocalStorage.GetContainerID())
                AppDelegate.getDelegate().AddContainerView(containerName: container.name, desription: container.containerDesc, size: container.size, countour: container.contour, type: container.type)
            }
            let Reach = Reachability()
            if(AppDelegate.getDelegate().getUnknownBags(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation()) == "U" && Reach?.isReachable == false && IsStillValidTrackingLocation()==true){
                AppDelegate.getDelegate().AddInternetConnectionView()
            }
            
            if UserDefaults.standard.value(forKey: "bingo") != nil || (ScanManager.LocalStorage.GetTrackingLocation() != "" && AppDelegate.getDelegate().getTypeEvent(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()) == "B" && isValidBingoLocation(trackingLocation: ScanManager.LocalStorage.GetTrackingLocation()) && IsStillValidTrackingLocation()){
                BingoMode()
            }

            AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems: ScanManager.LocalStorage.getAllBagsFromCoredata()!, LastItemScaned:nil)
            
            if IsStillValidTrackingLocation() {
                let seconds = ScanManager.LocalStorage.GetTrackingPointValidityUntil().timeIntervalSince(Date())
                AppDelegate.getDelegate().UpdateLocationOnAppHeader(seconds:Int(seconds),trackingLocation:AppDelegate.getDelegate().getTrackingLocation(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()))
            } else {
                let seconds = ScanManager.LocalStorage.GetTrackingPointValidityUntil().timeIntervalSince(Date())
                AppDelegate.getDelegate().UpdateLocationOnAppHeader(seconds:Int(seconds),trackingLocation:AppDelegate.getDelegate().getTrackingLocation(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()))
                ScanManager.LocalStorage.RemoveTrackingLocation()
                ScanManager.LocalStorage.RemoveTrackingPointRaw()
                ScanManager.LocalStorage.RemoveContainerID()
                ScanManager.LocalStorage.removeFlightInformation()
                AppDelegate.getDelegate().RemoveContainerView()
                AppDelegate.getDelegate().RemoveFligthAirPlaneInformationView()
            }
            checkForBannerViews()
        }
    }
    
    func AddAirPlaneView(){
        let AirportCode = AppDelegate.getDelegate().getAirportCode(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation())
        var FliType = ""
        let FliNum = ScanManager.LocalStorage.getFlightNumber()
        if(ScanManager.LocalStorage.getFlightInformation().value(forKey: "flight_type") != nil){
            if (ScanManager.LocalStorage.getFlightInformation().value(forKey: "flight_type") as! String == "D"){
                FliType = String(format: "departing".localized, AirportCode)
            }else{
                FliType = String(format: "arriving".localized, AirportCode)
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let date = dateFormatter.string(from: ScanManager.LocalStorage.getFlightInformation().value(forKey: "flight_date") as! Date)
            AppDelegate.getDelegate().AddFligthAirPlaneInformationView(Info:"\(FliNum) \(FliType)  \(date)")
        }
    }
    
    func OnReturnFromBackGround(){
        if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if !((AppDelegate.vc.ConnectivityView.SocketMobile != nil) && AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper != nil && AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper.isDeviceConnected()){
                AppDelegate.getDelegate().AddDeviceConnectionView()
            }
            AppDelegate.getDelegate().doClose()
            if AppDelegate.vc.ConnectivityView.SocketMobile != nil {
                AppDelegate.vc.ConnectivityView.SocketMobile.EnableTriggerButton()
            }
            CheckForViews()
        }
        else if (UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            if (AppDelegate.vc.ConnectivityView.CognexManager != nil){
                if( AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem() != nil ){
                    if(AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.connectionState == CMBConnectionStateConnected){
                        CheckForViews()
                    }else{
                        AppDelegate.getDelegate().AddDeviceConnectionView()
                    }
                }else{
                    AppDelegate.getDelegate().AddDeviceConnectionView()
                }
            }else{
                AppDelegate.getDelegate().AddDeviceConnectionView()
            }
        }
        else if (UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
            CheckForViews()
        }
    }
    
    func WhatToDoAfterScanningBarCode(readString:String,showTrackingIdentifier:Bool){
        if (AppDelegate.vc.ConnectivityView.bingoView != nil && UserDefaults.standard.value(forKey: "bingo") != nil){
            AppDelegate.vc.ConnectivityView.bingoView.onScanningData(bagTag:readString)
        } else {
            if isBingo(trackingLocation: readString){
                var errorMessage = ""
                var intervalTime = 1.5
                var canDismess = false
                if (self.isValidBingoLocation(trackingLocation: readString)){
                    if (UserDefaults.standard.string(forKey: "scannerType") != "softScanner".localized){
                        if (UserDefaults.standard.value(forKey: "selected_airport") != nil && (((UserDefaults.standard.value(forKey: "selected_airport") as! String) == "<ALL>") || ((UserDefaults.standard.value(forKey: "selected_airport") as! String) == AppDelegate.getDelegate().getAirportCode(scannedBarcode: readString)))){
                            AppDelegate.getDelegate().doClose()
                            ScanManager.LocalStorage.removeFlightInformation()
                            ScanManager.LocalStorage.RemoveContainerID()
                            ScanManager.LocalStorage.setRecentlyUsedTrackingPoints(trackingPoint: AppDelegate.getDelegate().buildTrackingConfigurationForRecentlyUsed(TrackingPoint: readString), forKey: ScanManager.LocalStorage.getKeyForRecentlyUsed())
                            AppDelegate.SaveTrackingToRecentlyUsedIfInvalid = false
                            ScanManager.LocalStorage.SetTrackingLocation(TrackingLocation:readString)
                            ScanManager.LocalStorage.SetTrackingPointValidityUntil()
                            ScanManager.LocalStorage.removeSyncedBags()
                            AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems: ScanManager.LocalStorage.getAllBagsFromCoredata()!, LastItemScaned: nil)

                            AppDelegate.getDelegate().RemoveContainerView()
                            AppDelegate.getDelegate().RemoveFligthAirPlaneInformationView()
                            self.DisablecodeContainer()
                            self.EnablecodeBags()
                            
                            
                            let responseDic = UserDefaultsManager().getLoginResponse()
                            let Airlines = (responseDic["airlines"] as! String).components(separatedBy: ",")
                            if Airlines.count>1{
                                MainViewController.AppHeaderInstance.StartCountDownTimer(seconds: 3600)
                                MainViewController.AppHeaderInstance.SetLocation(location: AppDelegate.getDelegate().getTrackingLocation(scannedBarcode: readString))
                                MainViewController.AppHeaderInstance.PresentAirlineWithTrackingIdentifier()
                            }else{
                                if (showTrackingIdentifier){ AppDelegate.getDelegate().AddLocationSuccessView(TrakingLocation:AppDelegate.getDelegate().getTrackingLocation(scannedBarcode: readString),seconds: 3600)
                                } else {
                                    MainViewController.AppHeaderInstance.StartCountDownTimer(seconds: 3600)
                                    MainViewController.AppHeaderInstance.SetLocation(location: AppDelegate.getDelegate().getTrackingLocation(scannedBarcode: readString))
                                    BingoMode()
                                }
                            }
                        } else {
                            errorMessage = "trackingPointValidationError".localized
                            intervalTime = 3
                            canDismess = true
                        }
                    } else {
                        errorMessage = "invalid_location_scanner".localized
                        ScanManager.LocalStorage.setRecentlyUsedTrackingPoints(trackingPoint: AppDelegate.getDelegate().buildTrackingConfigurationForRecentlyUsed(TrackingPoint: readString), forKey: ScanManager.LocalStorage.getKeyForRecentlyUsed())
                        AppDelegate.SaveTrackingToRecentlyUsedIfInvalid = false
                    }
                } else {
                    errorMessage = "invalidTrackingpiont".localized
                }
                if (errorMessage != "" && (UserDefaults.standard.string(forKey: "scannerType") != "softScanner".localized)){
                    AppDelegate.getDelegate().doClose()
                    self.BingoDialog = GetSimpleDialogView(LabelText:errorMessage, Image:false, Y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/8))
                    AppDelegate.getDelegate().showOverlayWithView(viewToShow: self.BingoDialog, dismiss: canDismess, AccessToMenu: false)
                    _ = Timer.scheduledTimer(timeInterval:intervalTime, target: self, selector: #selector(self.removeInvalidBingoDialog), userInfo: nil, repeats: false)
                } else if errorMessage != "" {
                    let deadlineTime = DispatchTime.now() + .milliseconds(50)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        AppDelegate.getDelegate().doClose()
                        self.BingoDialog = GetSimpleDialogView(LabelText:errorMessage, Image:false, Y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/8))
                        AppDelegate.getDelegate().showOverlayWithView(viewToShow: self.BingoDialog, dismiss: canDismess, AccessToMenu: false)
                        _ = Timer.scheduledTimer(timeInterval:intervalTime, target: self, selector: #selector(self.removeInvalidBingoDialog), userInfo: nil, repeats: false)
                    }
                }
            } else {
                let isValidTrackingLocation:Bool=self.isValidTrackingLocation(trackingLocation: readString)
                if (isValidTrackingLocation == true){
                    if (UserDefaults.standard.value(forKey: "selected_airport") != nil && (((UserDefaults.standard.value(forKey: "selected_airport") as! String) == "<ALL>") || ((UserDefaults.standard.value(forKey: "selected_airport") as! String) == AppDelegate.getDelegate().getAirportCode(scannedBarcode: readString)))){
                        if ((ContainerViewTimer) != nil){ContainerViewTimer.invalidate()}
                        if AppDelegate.BINGO_INFO {
                            AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: false)
                            AppDelegate.BINGO_INFO = false
                        }
                        AppDelegate.getDelegate().doClose()
                        ScanManager.LocalStorage.removeFlightInformation()
                        ScanManager.LocalStorage.RemoveContainerID()
                        ScanManager.LocalStorage.setRecentlyUsedTrackingPoints(trackingPoint: AppDelegate.getDelegate().buildTrackingConfigurationForRecentlyUsed(TrackingPoint: readString), forKey: ScanManager.LocalStorage.getKeyForRecentlyUsed())
                        ScanManager.LocalStorage.SetTrackingLocation(TrackingLocation:readString)
                        ScanManager.LocalStorage.SetTrackingPointValidityUntil()
                        ScanManager.LocalStorage.removeSyncedBags()
                        AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems: ScanManager.LocalStorage.getAllBagsFromCoredata()!, LastItemScaned: nil)
                        self.DisablecodeBags()
                        self.DisablecodeContainer()
                        AppDelegate.getDelegate().RemoveContainerView()
                        AppDelegate.getDelegate().RemoveFligthAirPlaneInformationView()
                        
                        let responseDic = UserDefaultsManager().getLoginResponse()
                        let Airlines = (responseDic["airlines"] as! String).components(separatedBy: ",")
                        if Airlines.count>1{
                            MainViewController.AppHeaderInstance.StartCountDownTimer(seconds: 3600)
                            MainViewController.AppHeaderInstance.SetLocation(location: AppDelegate.getDelegate().getTrackingLocation(scannedBarcode: readString))
                            MainViewController.AppHeaderInstance.PresentAirlineWithTrackingIdentifier()
                        }
                        else{
                            if (showTrackingIdentifier){ AppDelegate.getDelegate().AddLocationSuccessView(TrakingLocation:AppDelegate.getDelegate().getTrackingLocation(scannedBarcode: readString),seconds: 3600)
                            } else {
                                MainViewController.AppHeaderInstance.StartCountDownTimer(seconds: 3600)
                                MainViewController.AppHeaderInstance.SetLocation(location: AppDelegate.getDelegate().getTrackingLocation(scannedBarcode: readString))
                                LocationSuccesDialogDismissed()
                            }
                        }
                    } else {
                        self.BingoDialog = GetSimpleDialogView(LabelText:"trackingPointValidationError".localized, Image:false, Y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/8))
                        AppDelegate.getDelegate().showOverlayWithView(viewToShow: self.BingoDialog, dismiss: true, AccessToMenu: false)
                        _ = Timer.scheduledTimer(timeInterval:3, target: self, selector: #selector(self.removeInvalidBingoDialog), userInfo: nil, repeats: false)
                    }
                }
                let isValidContainer:Bool=self.isValidContainer(containerCode: HandleContainerSpacing(containerCode: readString))
                if (isValidContainer == true && ScanManager.LocalStorage.GetTrackingLocation() != "" && IsStillValidTrackingLocation()){
                    if ((ContainerViewTimer) != nil){ContainerViewTimer.invalidate()}
                    AppDelegate.getDelegate().doClose()
                    self.DisablecodeBags()
                    ScanManager.LocalStorage.SetContainerID(ContainerID:HandleContainerSpacing(containerCode: readString))
                    let trackingLocation:String!=ScanManager.LocalStorage.GetTrackingLocation()
                    let containerInput:String!=AppDelegate.getDelegate().getContainerInput(scannedBarcode: trackingLocation)
                    if (containerInput == "C"){
                        let container = self.buildBagObjFromScan(bagScanString: readString)
                        container.type="container"
                        container.bagTag=""
                        let UnknownBag = AppDelegate.getDelegate().getUnknownBags(scannedBarcode:trackingLocation)
                        if (UnknownBag == "S"){
                            let FligthInformation:NSMutableDictionary = ScanManager.LocalStorage.getFlightInformation()
                            let flight_num = FligthInformation["flight_num"] as! String
                            let flight_type = FligthInformation.value(forKey: "flight_type") as! String
                            let flight_date = FligthInformation.value(forKey: "flight_date") as! Date
                            ScanManager.LocalStorage.saveBagToCoredata(scanDateTime:Date(), trackingPoint:trackingLocation, containerID:readString, bagTag:"",itemType:container.type,flight_num: "\(flight_num)", flight_type:flight_type, flight_date:flight_date,synced: false,locked:false , errorMsg:"")
                            AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems:ScanManager.LocalStorage.getAllBagsFromCoredata()!,LastItemScaned:container)
                        }else{
                            ScanManager.LocalStorage.saveContainerToCoredata(scanDateTime: Date(), trackingPoint: trackingLocation, containerID:readString, bagTag:"",itemType: container.type,synced: false, locked: false, errorMsg:"")
                            AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems:ScanManager.LocalStorage.getAllBagsFromCoredata()!,LastItemScaned:container)
                        }
                    }
                    if (containerInput == "Y" || containerInput == "N"){
                        self.EnablecodeBags()
                        let container = self.buildContainerObjFromScan(containerScanString:readString)
                        AppDelegate.getDelegate().RemoveContainerView()
                        AppDelegate.getDelegate().AddContainerView(containerName:container.name, desription:container.containerDesc, size:container.size, countour:container.contour, type:container.type)
                        AppDelegate.getDelegate().AddContainerIdentifierView()
                        ContainerViewTimer = Timer.scheduledTimer(timeInterval:1.5, target: self, selector: #selector(RemoveContainerIdentifierView), userInfo: nil, repeats: false)
                    }
                }
                let isValidBag:Bool=self.isValidBag(bagTag: readString)
                if (isValidContainer == false && isValidTrackingLocation == false && isValidBag && ContinueScanning()){
                    if ((ContainerViewTimer) != nil){ContainerViewTimer.invalidate()}
                    AppDelegate.getDelegate().doClose()
                    let trackingLocation:String = ScanManager.LocalStorage.GetTrackingLocation()
                    let unkownBags:String = AppDelegate.getDelegate().getUnknownBags(scannedBarcode: trackingLocation);
                    let typeEvent:String = AppDelegate.getDelegate().getTypeEvent(scannedBarcode: trackingLocation);
                    if (typeEvent != ""  && unkownBags != ""){
                        if (unkownBags == "I"){
                            let bagTag = self.buildBagObjFromScan(bagScanString: readString)
                            bagTag.type="bag"
                            let ContainerID = ScanManager.LocalStorage.GetContainerID()
                            ScanManager.LocalStorage.saveContainerToCoredata(scanDateTime: Date(), trackingPoint: trackingLocation, containerID: ContainerID, bagTag: bagTag.bagTag,itemType: bagTag.type,synced: false, locked: false, errorMsg: "")
                            AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems:ScanManager.LocalStorage.getAllBagsFromCoredata()!,LastItemScaned:bagTag)
                        }
                        else if (unkownBags == "U" || unkownBags == "S"){
                            AppDelegate.getDelegate().AddFetchingBagView()
                            if(unkownBags == "U"){
                                bagSyncingIf_U_equalTo_U_(readString: readString, trackingLocation: trackingLocation, flightInfo: nil)
                            }else{
                                let bagTag = self.buildBagObjFromScan(bagScanString: readString)
                                bagTag.type="bag"
                                let ContainerID = ScanManager.LocalStorage.GetContainerID()                                
                                AppDelegate.getDelegate().RemoveFetchingBagView()
                                
                                ScanManager.LocalStorage.saveContainerToCoredata(scanDateTime:Date(), trackingPoint:trackingLocation, containerID:ContainerID, bagTag:bagTag.bagTag,itemType: bagTag.type,synced: false,locked:false , errorMsg:"")
                                AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems:ScanManager.LocalStorage.getAllBagsFromCoredata()!,LastItemScaned:bagTag)
                                
                                
                            }
                        }
                    }
                }
                print("String read: \(readString)***");
                checkForBannerViews()
                if(isValidBag==false && isValidContainer==false && isValidTrackingLocation==false ){
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                }
            }
        }
    }
  
    
    func bagSyncingIf_U_equalTo_U_(readString:String,trackingLocation:String,flightInfo:NSMutableDictionary!){
        
        var withFlightInfo = false
        
        if (flightInfo != nil){
            withFlightInfo = true
        }
        
        let connectingToServerView = MainViewController.AppHintsInstance.getConnectingToServerView(bagTag:readString,synced:false, flightInfo: withFlightInfo)
        AppDelegate.getDelegate().showOverlayWithView(viewToShow: connectingToServerView, dismiss: false, AccessToMenu: false)
        
        let bag = self.buildBagObjFromScan(bagScanString: readString)
        bag.type="bag"
        
        let url = Constants.BagJourneyHost + Constants.BagTrackingEndPoint
        
        var dictionary: [String:String] = [:]
        
        if (withFlightInfo){
            
            dictionary["flight_num"] = flightInfo.value(forKey: "flight_num") as? String
            dictionary["flight_type"] = flightInfo.value(forKey: "flight_type") as? String
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            dictionary["flight_date"] = dateFormatter1.string(from: flightInfo.value(forKey: "flight_date") as! Date)
        }
        
        let logInResponse = UserDefaultsManager().getLoginResponse()
        
        if let serviceId = logInResponse.value(forKey: "service_id") {
            dictionary["service_id"] = serviceId as? String
        }
        if let airlineCode = (UserDefaults.standard.string(forKey: "selected_airline")) {
            if (UserDefaults.standard.string(forKey: "selected_airline") == "<ALL>"){
                dictionary["airline_code"] = ""
            } else {
                dictionary["airline_code"] = airlineCode.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            }
        }
        
        if let ContainerID = (bag as AnyObject).value(forKey: "containerID") {
            let tempContainerID = (ContainerID as AnyObject).replacingOccurrences(of: " ", with: "")
            dictionary["container_id"] = tempContainerID.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            if let bagTag = (bag as AnyObject).value(forKey: "bagTag") {
                dictionary["LPN"] = (bagTag as AnyObject).trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            }
            if true {
                dictionary["GUID"] = ""
            }
        }else{
            if let bagTag = (bag as AnyObject).value(forKey: "bagTag") {
                dictionary["LPN"] = (bagTag as AnyObject).trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            }else{
                dictionary["GUID"] = ""
            }
        }
        
        let trackingPointID = AppDelegate.getDelegate().getTrackingID(scannedBarcode: trackingLocation)
        dictionary["tracking_location"] = trackingLocation.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        dictionary["tracking_point_id"] = trackingPointID.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        dictionary["airport_code"] = AppDelegate.getDelegate().getAirportCode(scannedBarcode: trackingLocation)
        
         
         dictionary["response_required"] = "D"
         let currentDate = NSDate()
         let dateFormatter2 = DateFormatter()
         dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
         dateFormatter2.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
         dateFormatter2.timeZone = TimeZone.init(abbreviation: "UTC")
         let DateToSend = dateFormatter2.string(from: currentDate as Date)
         var body = "{"
         for (key, value) in dictionary {
         body = body.appending("\"")
         body = body.appending(key)
         body = body.appending("\"")
         body = body.appending(":")
         body = body.appending("\"")
         body = body.appending(value)
         body = body.appending("\"")
         body = body.appending(",")
         }
         body = body.appending("\"timestamp\":\"\(DateToSend)\"")
         body = body.appending("}")

        let stringToPost = String(format: "request=%@",body)
        
        ApiCallSwift().getResponseForURL(builtURL:url  as NSString, JsonToPost:stringToPost as NSString, isAuthenticationRequired: true, method: "post", errorTitle: "NoAlert", optionalValue:"", AndCompletionHandler:{ builtURL, response, statusCode, data, error in
            AppDelegate.getDelegate().doClose()
            if data != nil{
                if let jsonResult = response as? NSDictionary {
                    if jsonResult["success"] != nil {
                        if jsonResult.value(forKey: "success") as! Bool == true{
                            
                            let connectingToServerView = MainViewController.AppHintsInstance.getConnectingToServerView(bagTag:readString,synced:true, flightInfo: withFlightInfo)
                            AppDelegate.getDelegate().showOverlayWithView(viewToShow: connectingToServerView, dismiss: false, AccessToMenu: false)
                            let ContainerID = ScanManager.LocalStorage.GetContainerID()
                            ScanManager.LocalStorage.saveContainerToCoredata(scanDateTime: Date(), trackingPoint: trackingLocation, containerID: ContainerID, bagTag: bag.bagTag,itemType: bag.type,synced: false, locked: false, errorMsg: "")
                            AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems:ScanManager.LocalStorage.getAllBagsFromCoredata()!,LastItemScaned:bag)
                            let deadlineTime = DispatchTime.now() + .milliseconds(1500)
                            DispatchQueue.main.asyncAfter(deadline: deadlineTime){
                                AppDelegate.getDelegate().doClose()
                                self.checkForBannerViews()
                            }
                        } else {
                            AppDelegate.getDelegate().AddFlightInformationView(bagView: true, bagNumber:readString,UnknownBag:"U")
                            AppDelegate.ScanningBagTag = readString
                        }
                    }
                }
            }
        })
    }
    
    
    func removeInvalidBingoDialog() {
        if self.BingoDialog != nil{
            self.BingoDialog.removeFromSuperview()
            AppDelegate.getDelegate().doClose()
        }
        AppDelegate.getDelegate().ScanManagerReturnFromBackground()
    }
    
    func RemoveContainerIdentifierView() {
        AppDelegate.getDelegate().doClose()
        AppDelegate.getDelegate().RemoveContainerIdentifierView()
        whatToDoAfterContainerScan();
        if (AppDelegate.getDelegate().getContainerInput(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()
            ) == "Y"){
            checkForBannerViews()
        }
    }
    
    func IsStillValidTrackingLocation() -> Bool{
        
        let Current:Date = Date()
        let date = ScanManager.LocalStorage.GetTrackingPointValidityUntil()
        if(Current.compare(date) == ComparisonResult.orderedDescending){
            return false
        }
        return true
        
    }
    
    func ContinueScanning () -> Bool{
        if (ScanManager.LocalStorage.GetTrackingLocation() != "" && IsStillValidTrackingLocation()){
            if(AppDelegate.getDelegate().getContainerInput(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()) != "N"){
                if (ScanManager.LocalStorage.GetContainerID() != ""){
                    if(AppDelegate.getDelegate().getContainerInput(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()) != "C"){
                        return true
                    } else {
                        return false
                    }
                    
                } else {
                    return false
                }
                
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
//    func OnFligthViewOfUnknownBagUDismiss(readString:String){
//        let bagTag = self.buildBagObjFromScan(bagScanString: readString)
//        bagTag.type="bag"
//        let ContainerID = ScanManager.LocalStorage.GetContainerID()
//        let FligthInformation = ScanManager.LocalStorage.getFlightInformation()
//        let trackingLocation = ScanManager.LocalStorage.GetTrackingLocation()
//        let flight_num = FligthInformation["flight_num"]  as! String
//        let flight_type = FligthInformation.value(forKey: "flight_type") as! String
//        let flight_date = FligthInformation.value(forKey: "flight_date") as! Date
//        AppDelegate.ScanningBagTag=""
//        ScanManager.LocalStorage.saveBagToCoredata(scanDateTime:Date(), trackingPoint:trackingLocation, containerID:ContainerID, bagTag:bagTag.bagTag,itemType: bagTag.type,flight_num: "\(flight_num)", flight_type:flight_type, flight_date:flight_date,synced: false,locked:false , errorMsg:"")
//        AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems:ScanManager.LocalStorage.getAllBagsFromCoredata()!,LastItemScaned:bagTag)
//    }
    
    func LocationSuccesDialogDismissed(){
        setScannedLocation(location: ScanManager.LocalStorage.GetTrackingLocation());
    }
    
    func CheckIfContainerInputRequierd(){
        let TrackingLocation = ScanManager.LocalStorage.GetTrackingLocation()
        let Input = AppDelegate.getDelegate().getContainerInput(scannedBarcode: TrackingLocation)
        let UnknownBag = AppDelegate.getDelegate().getUnknownBags(scannedBarcode: TrackingLocation)
        if(Input == "N"){
            self.EnablecodeContainer()
            self.EnablecodeBags()
        }else{
            if (UnknownBag != "U"){
                self.EnablecodeContainer()
            }
        }
        checkForBannerViews()
    }
    
    func setScannedLocation(location:String){
        if (location != ""){
            whatToDoAfterLocationScan();
        }else{
            ScanManager.LocalStorage.removeFlightInformation()
            ScanManager.LocalStorage.RemoveContainerID()
        }
    }
    
    func whatToDoAfterLocationScan(){
        AppDelegate.getDelegate().doClose()
        if canContinueScanwithNoInternet() == true{
            ScanManager.LocalStorage.removeFlightInformation()
            let trackingLocation:String!=ScanManager.LocalStorage.GetTrackingLocation()
            if (trackingLocation != nil){
                let unkownBags:String!=AppDelegate.getDelegate().getUnknownBags(scannedBarcode: trackingLocation)
                let flightNumber:String!=ScanManager.LocalStorage.getFlightNumber()
                if (unkownBags != "I"){
                    if (unkownBags == "S" && flightNumber == ""){
                        AppDelegate.getDelegate().AddFlightInformationView(bagView:false,bagNumber:trackingLocation,UnknownBag:"S")
                    }else{
                        EnablecodeContainer()
                        whatToDoforContainer(trackingLocation: trackingLocation);
                    }
                }else{
                    EnablecodeContainer()
                    whatToDoforContainer(trackingLocation: trackingLocation);
                }
            }
        }else{
            AppDelegate.getDelegate().AddInternetConnectionView()
        }
    }
    
    func canContinueScanwithNoInternet() ->Bool{
        let trackingLocation:String!=ScanManager.LocalStorage.GetTrackingLocation()
        ApiCall=ApiCallSwift()
        if (trackingLocation != ""){
            let unknownBags = AppDelegate.getDelegate().getUnknownBags(scannedBarcode: trackingLocation)
            if ((ApiCall.isInternetAvailable() == false) && unknownBags == "U"){
                return false
            }
        }
        return true
    }
    
    func whatToDoAfterContainerScan(){
        let trackingLocation:String!=ScanManager.LocalStorage.GetTrackingLocation()
        let containerInput:String!=AppDelegate.getDelegate().getContainerInput(scannedBarcode: trackingLocation)
        if (containerInput != "C"){
            self.EnablecodeBags()
        }
        checkForBannerViews()
    }
    
    func whatToDoforContainer(trackingLocation:String){
        let containerInput:String!=AppDelegate.getDelegate().getContainerInput(scannedBarcode: trackingLocation)
        let containerULD:String!=ScanManager.LocalStorage.GetContainerID()
        if ((containerULD == nil || containerULD == "") && containerInput != ""){
            print("container input is :\(containerInput)")
            if (containerInput == "N"){
                whatToDoAfterContainerScan()
            }else{
                CheckForViews() // for redrawing container required after handling margins of queue
            }
        }else{
            whatToDoAfterContainerScan()
        }
    }
    
    func SaveFlightDataInformation(flight_num: String, flight_date: Date, flight_type: String){
        let AirportCode = AppDelegate.getDelegate().getAirportCode(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation())
        ScanManager.LocalStorage.setFlightInformation(flight_num: flight_num, flight_date: flight_date, flight_type: flight_type)
        var FliType = ""
        if (flight_type == "D"){
            FliType = String(format: "departing".localized, AirportCode)
        }else{
            FliType = String(format: "arriving".localized, AirportCode)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.string(from: flight_date)
        AppDelegate.getDelegate().AddFligthAirPlaneInformationView(Info:"\(flight_num) \(FliType) \(date)")
        if(((AppDelegate.getDelegate().getUnknownBags(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation())) == "S")){
            self.EnablecodeContainer()
        } else if (((AppDelegate.getDelegate().getUnknownBags(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation())) == "U")){
            
            let flightDic = NSMutableDictionary()
            
            flightDic.setValue(flight_num, forKey: "flight_num")
            flightDic.setValue(flight_date, forKey: "flight_date")
            flightDic.setValue(flight_type, forKey: "flight_type")
            
            bagSyncingIf_U_equalTo_U_(readString: AppDelegate.ScanningBagTag, trackingLocation: ScanManager.LocalStorage.GetTrackingLocation(), flightInfo: flightDic)
        }
    }
    
    func RequierdContainerDialogDismiss(){
        AppDelegate.getDelegate().doClose()
        if(AppDelegate.getDelegate().getContainerInput(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()) != "C"){
            AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems:ScanManager.LocalStorage.getAllBagsFromCoredata()!,LastItemScaned:nil)
        }
        checkForBannerViews()
    }
    
    func isValidTrackingLocation(trackingLocation:String)->Bool{
        let containerSpec:String="^[A-Za-z_\\s]{3}[A-Za-z0-9_\\s]{8}[A-Za-z0-9_\\s]{10}(I|S|U){1}(Y|N|C){0,1}(L|T){0,1}$"
        if (AppDelegate.getDelegate().matchesForRegexInText(containerSpec: containerSpec, text: trackingLocation) != []){
            return true
        }
        return false
    }
    func isBingo(trackingLocation:String)->Bool {
        let trackingLocationSpec:String="^[A-Za-z_\\s]{3}[A-Za-z0-9_\\s]{8}[A-Za-z0-9_\\s]{10}(I|S|U){1}(Y|N|C){0,1}(B){0,1}$"
        if (AppDelegate.getDelegate().matchesForRegexInText(containerSpec: trackingLocationSpec, text: trackingLocation) != []){
            return true
        }
        return false
    }
    
    func isValidBingoLocation(trackingLocation:String)->Bool{
        let containerSpec:String="^[A-Za-z_\\s]{3}[A-Za-z0-9_\\s]{8}[A-Za-z0-9_\\s]{10}(I|S){1}(N){1}(B){1}$"
        if (AppDelegate.getDelegate().matchesForRegexInText(containerSpec: containerSpec, text: trackingLocation) != []){
            return true
        }
        return false
    }
    
    func isValidContainer(containerCode:String) -> Bool{
        if (!((AppDelegate.getDelegate().getContainerInput(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation())) as String == "N")){
            let containerSpec:String="^[^CEIOTceiot]{1}([^C-Fc-fT-Zt-z H-Jh-j Oo]){1}[^Q-T q-t Ii Oo Ww]{1}( ){0,1}[0-9]{5}( ){0,1}[A-Za-z]{2,3}$"
            if (AppDelegate.getDelegate().matchesForRegexInText(containerSpec: containerSpec, text: containerCode) != []){
                return true
            }
            return false
        }
        return false
    }
    
    func isValidBag(bagTag:String) -> Bool{
        let containerSpec:String="^[A-Za-z0-9_]{10}$"
        if (AppDelegate.getDelegate().matchesForRegexInText(containerSpec: containerSpec, text: bagTag) != []){
            return true
        }
        return false
    }
    
    func HandleContainerSpacing(containerCode:String) ->String{
        var NewString:String = ""
        var Chars = Array(containerCode.characters)
        if(Chars.count>9){
        if ("\(Chars[3])" != " "){
            Chars.insert(" ", at:3)
            if ("\(Chars[9])" != " "){
                Chars.insert(" ", at:9)
            }
        }
        if ("\(Chars[9])" != " "){
            Chars.insert(" ", at:9)
        }
        for char in Chars {
            NewString.append(char)
            }
        }
        return NewString
    }
    
    /*
     --------------------------------------------------------------------------------
     --------------------------------------------------------------------------------
     Scanner device commands Configuration Fuctions
     */
    
    func DisablecodeContainer(){
        if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if(AppDelegate.vc.ConnectivityView.SocketMobile.Device != nil && AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper.isDeviceConnected()){
                AppDelegate.vc.ConnectivityView.SocketMobile.DisablecodeContainer()
            }
        }
        else if (UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            if(AppDelegate.vc.ConnectivityView.CognexManager != nil && AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem() != nil){
                AppDelegate.vc.ConnectivityView.CognexManager.ON_OFF_128BarCode(ON_OFF: "OFF")
            }
        }
        //if(UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
            AppDelegate.getDelegate().DisableAll()
        //}
    }
    
    func EnablecodeContainer(){
        if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if(AppDelegate.vc.ConnectivityView.SocketMobile.Device != nil && AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper.isDeviceConnected()){
                if (!((AppDelegate.getDelegate().getContainerInput(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation())) as String == "N")){
                    AppDelegate.vc.ConnectivityView.SocketMobile.EnablecodeContainer()
                }
            }
        }
        else if (UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            if(AppDelegate.vc.ConnectivityView.CognexManager != nil && AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem() != nil){
                if (!((AppDelegate.getDelegate().getContainerInput(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation())) as String == "N")){
                    AppDelegate.vc.ConnectivityView.CognexManager.ON_OFF_128BarCode(ON_OFF: "ON")
                }
            }
        }
        //if(UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
            if (!((AppDelegate.getDelegate().getContainerInput(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation())) as String == "N")){
                AppDelegate.getDelegate().EnableContainer()
            } else {
                AppDelegate.getDelegate().EnableBagsOnly()
            }
        //}
    }
    
    func DisablecodeBags(){
        if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if(AppDelegate.vc.ConnectivityView.SocketMobile.Device != nil && AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper.isDeviceConnected()){
                AppDelegate.vc.ConnectivityView.SocketMobile.DisablecodeBags()
            }
        }
        else if (UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            if(AppDelegate.vc.ConnectivityView.CognexManager != nil && AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem() != nil){
                AppDelegate.vc.ConnectivityView.CognexManager.ON_OFF_Interleaved2OF5(ON_OFF: "OFF")
            }
        }
        //if(UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
        if (!((AppDelegate.getDelegate().getContainerInput(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation())) as String == "N")){
            AppDelegate.getDelegate().EnableContainer()
        } else {
            AppDelegate.getDelegate().DisableAll()
        }
        //}
    }
    
    func EnablecodeBags(){
        if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if(AppDelegate.vc.ConnectivityView.SocketMobile.Device != nil && AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper.isDeviceConnected()){
                AppDelegate.vc.ConnectivityView.SocketMobile.EnablecodeBags()
            }
        }
        else if (UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            if(AppDelegate.vc.ConnectivityView.CognexManager != nil && AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem() != nil){
                AppDelegate.vc.ConnectivityView.CognexManager.ON_OFF_Interleaved2OF5(ON_OFF: "ON")
            }
        }
        //if(UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized ){
        if (!((AppDelegate.getDelegate().getContainerInput(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation())) as String == "N")){
            AppDelegate.getDelegate().EnableBagOrContainer()
        } else {
            AppDelegate.getDelegate().EnableBagsOnly()
        }
        //}
    }
    
    func DisableCodesNeedToInternet(){
        if((UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized) || UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            self.DisablecodeBags()
            self.DisablecodeContainer()
        }
        //else if(UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
        AppDelegate.getDelegate().DisableAll()
        //}
    }
    
    func DisableAllcodes(){
        if(UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
            AppDelegate.getDelegate().DisableAll()
        }
        else if(UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            AppDelegate.vc.ConnectivityView.SocketMobile.DisableAllcodes()
        }
    }
    
    func buildContainerObjFromScan(containerScanString : String) -> Container{
        let myContainer = Container()
        myContainer.name = containerScanString
        let firstChar = String(containerScanString.characters.first!).uppercased()
        let secondChar = String(containerScanString[containerScanString.index(containerScanString.startIndex, offsetBy: 1)]).uppercased()
        let thirdChar = String(containerScanString[containerScanString.index(containerScanString.startIndex, offsetBy: 2)]).uppercased()
        if let path = Bundle.main.path(forResource: "container_contours", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult:NSDictionary = try (JSONSerialization.jsonObject(with: jsonData as Data, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary)!
                    if jsonResult[thirdChar] != nil{
                        let contour = jsonResult[thirdChar] as! NSDictionary
                        let width = contour["Width"] as! String
                        let height = contour["Height"] as! String
                        let type = contour["Type"] as! String
                        let delimiter = "mm"
                        var token1 = width.components(separatedBy: delimiter)
                        var token2 = height.components(separatedBy: delimiter)
                        let mmWidth = token1[0]
                        let mmHeight = token2[0]
                        let mmContour = String(format: "%@ x %@ mm", mmWidth.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines), mmHeight.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines))
                        myContainer.contour = mmContour
                        myContainer.type = type
                    }
                } catch {}
            } catch {}
        }
        if let path = Bundle.main.path(forResource: "container_sizes", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult:NSDictionary = try (JSONSerialization.jsonObject(with: jsonData as Data, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary)!
                    if jsonResult[secondChar] != nil{
                        let size = jsonResult[secondChar] as! String
                        let delimiter = "/"
                        var token1 = size.components(separatedBy: delimiter)
                        let mmSize = token1[0].trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
                        _ = token1[1].trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
                        myContainer.size = mmSize
                    }
                    
                } catch {}
            } catch {}
        }
        if let path = Bundle.main.path(forResource: "container_types", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult:NSDictionary = try (JSONSerialization.jsonObject(with: jsonData as Data, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary)!
                    if jsonResult[firstChar] != nil{
                        let containerDesc = jsonResult[firstChar] as! String
                        myContainer.containerDesc = containerDesc
                    }
                    
                } catch {}
            } catch {}
        }
        myContainer.synced = false
        return myContainer
    }
    
    func buildBagObjFromScan(bagScanString : String) -> Bag{
        let myBag = Bag()
        myBag.bagTag = bagScanString
        myBag.type = "bag"
        myBag.Trackinglocation = ScanManager.LocalStorage.GetTrackingLocation()
        myBag.status = "Service Id is not configured for the customer"
        myBag.containerID = ScanManager.LocalStorage.GetContainerID()
        myBag.synced = false
        return myBag
    }
    
    func buildTrackingPost(Bag: AnyObject) -> String{
        var dictionary: [String:String] = [:]
        let logInResponse = UserDefaultsManager().getLoginResponse()
        
        if let serviceId = logInResponse.value(forKey: "service_id") {
            dictionary["service_id"] = serviceId as? String
        }
        if let airlineCode = (UserDefaults.standard.string(forKey: "selected_airline")) {
            if (UserDefaults.standard.string(forKey: "selected_airline") == "<ALL>"){
                dictionary["airline_code"] = ""
            } else {
                dictionary["airline_code"] = airlineCode.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            }
        }
        if let flight_num = (Bag as AnyObject).value(forKey: "flight_num") {
            dictionary["flight_num"] = flight_num as? String
        }
        if let flight_date = (Bag as AnyObject).value(forKey: "flight_date") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dictionary["flight_date"] = dateFormatter.string(from: flight_date as! Date)
        }
        if let flight_type = (Bag as AnyObject).value(forKey: "flight_type") {
            dictionary["flight_type"] = flight_type as? String
        }
        if let ContainerID = (Bag as AnyObject).value(forKey: "containerID") {
            let tempContainerID = (ContainerID as AnyObject).replacingOccurrences(of: " ", with: "")
            dictionary["container_id"] = tempContainerID.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            if let bagTag = (Bag as AnyObject).value(forKey: "bagTag") {
                dictionary["LPN"] = (bagTag as AnyObject).trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            }
            if true {
                dictionary["GUID"] = ""
            }
        }else{
            if let bagTag = (Bag as AnyObject).value(forKey: "bagTag") {
                dictionary["LPN"] = (bagTag as AnyObject).trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            }else{
                dictionary["GUID"] = ""
            }
        }
        if let trackingPoint = (Bag as AnyObject).value(forKey: "trackingPoint") {
            let trackingLocation = AppDelegate.getDelegate().getTrackingLocation(scannedBarcode: trackingPoint as! String)
            let trackingPointID = AppDelegate.getDelegate().getTrackingID(scannedBarcode: trackingPoint as! String) //itemType
            dictionary["tracking_location"] = trackingLocation.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            dictionary["tracking_point_id"] = trackingPointID.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            dictionary["airport_code"] = AppDelegate.getDelegate().getAirportCode(scannedBarcode: trackingPoint as! String)
        }
        
        dictionary["response_required"] = "D"
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let DateToSend = dateFormatter.string(from: currentDate as Date)
        var body = "{"
        for (key, value) in dictionary {
            body = body.appending("\"")
            body = body.appending(key)
            body = body.appending("\"")
            body = body.appending(":")
            body = body.appending("\"")
            body = body.appending(value)
            body = body.appending("\"")
            body = body.appending(",")
        }
        body = body.appending("\"timestamp\":\"\(DateToSend)\"")
        body = body.appending("}")
        return body
    }
    
//    func getBagInfoFromAPI(bagtag: String, completion: @escaping (_ result: Bool) -> Void) {
//
//        // disable bags while fetching
//        DisablecodeBags()
//
//
//        let currentDate = NSDate()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = dateFormatter.string(from: currentDate as Date)
//        let url = Constants.BagJourneyHost + String(format: Constants.BagInfoEndPoint, bagtag, dateString)
//        let apiCallSwift = ApiCallSwift()
//        apiCallSwift.getResponseForURL(builtURL: url as NSString, JsonToPost: "", isAuthenticationRequired: true, method: "GET", errorTitle: "NoAlert", optionalValue:"", AndCompletionHandler:{ builtURL, response, statusCode, data, error in
//
//            // enable bags after fetch is done
//            self.EnablecodeBags()
//
//            if data != nil{
//                if let jsonResult = response as? NSDictionary{
//                    if jsonResult["success"] != nil {
//                        if jsonResult.value(forKey: "success") as! Bool == true{
//                            completion(true)
//                        }else{
//                            if jsonResult.value(forKey: "errors") != nil {
//                                let errors = jsonResult.value(forKey: "errors") as! NSArray
//                                var errorString = ""
//                                for i in 0 ..< errors.count{
//                                    let err = errors[i]
//                                    let errDescription = (err as AnyObject).value(forKey: "error_description")
//                                    errorString += errDescription as! String
//                                    if i != errors.count-1 {
//                                        errorString += "\n"
//                                    }
//                                }
//                            }
//                            completion(false)
//                        }
//                    } else {
//                        completion(false)
//                    }
//                } else {
//                    completion(false)
//                }
//            } else {
//                completion(false)
//            }
//        })
//    }
    
    func processScannedItemsQueue() {
        let bagsArray = UserDefaultsManager().getSyncFalseLockedFalseFromCoredata()! as NSArray
        let url = Constants.BagJourneyHost + Constants.BagTrackingEndPoint
        for i in (0 ..< bagsArray.count){
            let Bags = bagsArray[i]
            ScannedItemsViews().showActivityIndicator(TrackingPoint:(Bags as AnyObject).value(forKey: "bagTag") as! String, bagTag:(Bags as AnyObject).value(forKey: "trackingPoint") as! String)
            let jsonToPost = buildTrackingPost(Bag: Bags as AnyObject)
            let stringToPost = String(format: "request=%@",jsonToPost)
            ApiCallSwift().getResponseForURL(builtURL:url  as NSString, JsonToPost:stringToPost as NSString, isAuthenticationRequired: true, method: "post", errorTitle: "NoAlert", optionalValue:"", AndCompletionHandler:{ builtURL, response, statusCode, data, error in
                let bagTag = (Bags as AnyObject).value(forKey: "bagTag")
                let trackingPoint = ((Bags as AnyObject).value(forKey: "trackingPoint") as! String).trailingTrim(.whitespaces)
                let containerID = ((Bags as AnyObject).value(forKey: "containerID") as! String).trailingTrim(.whitespaces)
                if data != nil{
                    let result = NSString(data: data! as Data, encoding: String.Encoding.ascii.rawValue)!
                    ScanManager.LocalStorage.saveTrackingResponse(trackingResponse: result as String, trackingPoint: trackingPoint, bagTag: bagTag as! String, containerID: containerID)
                    if let jsonResult = response as? NSDictionary {
                        if jsonResult["success"] != nil {
                            if jsonResult.value(forKey: "success") as! Bool == true{
                                UserDefaultsManager().turnSyncTrue(trackingPoint: trackingPoint, bag: Bags as AnyObject, containerID: containerID)
                                AppDelegate.getDelegate().preventTokenExpiration()

                            }else{
                                if jsonResult.value(forKey: "errors") != nil {
                                    let errors = jsonResult.value(forKey: "errors") as! NSArray
                                    var errorString = ""
                                    for i in 0 ..< errors.count{
                                        let err = errors[i]
                                        let errDescription = (err as AnyObject).value(forKey: "error_description")
                                        errorString += errDescription as! String
                                        if i != errors.count-1 {
                                            errorString += "\n"
                                        }
                                    }
                                    UserDefaultsManager().lockScannedItemStatus(trackingPoint: trackingPoint, bagTag: bagTag as! String, containerID: containerID, errorMsg: errorString ,isLocked:true)
                                    AppDelegate.vc.ConnectivityView.postBeepForTrackingUnrecoverableError()
                                    if (((((errors[0] as! NSDictionary).value(forKey: "error_code") as! String) == "BJYTAPI054") || (((errors[0] as! NSDictionary).value(forKey: "error_code") as! String) == "BJYTAPI053") || (((errors[0] as! NSDictionary).value(forKey: "error_code") as! String) == "BJYTAPI032")) && (UserDefaults.standard.value(forKey: "loginResponse") != nil)) {
                                        UserDefaultsManager().SignOut()
                                        self.forceLogOut()
                                    }
                                }
                            }
                        }else{
                            if (statusCode != 0 && statusCode != 1 && statusCode != -1){
                                UserDefaultsManager().lockScannedItemStatus(trackingPoint: trackingPoint, bagTag: bagTag as! String, containerID: containerID, errorMsg: "Network_Connection_Issue".localized ,isLocked:false)
                            } else {
                                var errorString = ""
                                if((error?.userInfo) != nil && error?.userInfo.description != nil){
                                    errorString = (error?.userInfo.description)!
                                }
                                UserDefaultsManager().lockScannedItemStatus(trackingPoint: trackingPoint, bagTag: bagTag as! String, containerID: containerID, errorMsg: errorString ,isLocked:true)
                                AppDelegate.vc.ConnectivityView.postBeepForTrackingUnrecoverableError()
                            }
                        }
                    }
                }else{
                    if (statusCode == 0 || statusCode == 1 || statusCode == -1){
                        UserDefaultsManager().lockScannedItemStatus(trackingPoint: trackingPoint, bagTag: bagTag as! String, containerID: containerID, errorMsg: "Network_Connection_Issue".localized ,isLocked:false)
                    } else {
                        var errorString = ""
                        if((error?.userInfo) != nil && error?.userInfo.description != nil){
                            errorString = (error?.userInfo.description)!
                        }
                        UserDefaultsManager().lockScannedItemStatus(trackingPoint: trackingPoint, bagTag: bagTag as! String, containerID: containerID, errorMsg: errorString ,isLocked:true)
                        AppDelegate.vc.ConnectivityView.postBeepForTrackingUnrecoverableError()
                    }
                }
                ScannedItemsViews().stopActivityIndicator()
            })
        }
    }
    
    func forceLogOut() {
        if AppDelegate.vc.ConnectivityView.IsLoggingIn {
        self.dialog = GetSimpleDialogView(LabelText:"expired_login".localized
            , Image: false, Y:(Constants.UIScreenMainHeight/2)-(Constants.UIScreenMainHeight/8))
        AppDelegate.getDelegate().showOverlayWithView(viewToShow:self.dialog , dismiss: false, AccessToMenu:false)
            _ = Timer.scheduledTimer(timeInterval:1.5, target: self, selector: #selector(self.removeFailedDialog), userInfo: nil, repeats: false)
        }
    }
    
    func removeFailedDialog() {
        if AppDelegate.vc.ConnectivityView.IsLoggingIn {
            if self.dialog != nil{
                self.dialog.removeFromSuperview()
                AppDelegate.getDelegate().doClose()
            }
            UserDefaultsManager().SignOut()
            AppDelegate.vc.ConnectivityView.IsLoggingIn = false
            AppDelegate.IsUSerINMainView=false
            AppDelegate.vc.MainViewControllerPointer.RemoveOfflineScannerView()
            AppDelegate.vc.MainViewControllerPointer.RemoveFligthAirPlaneInformationView()
            AppDelegate.vc.MainViewControllerPointer.RemoveContainerView()
            AppDelegate.vc.MainViewControllerPointer.removeBannerView()
            MainViewController.AppHeaderInstance.view.removeFromSuperview()
            AppDelegate.getDelegate().ReturnToLogin()
        }
    }
    
    func BingoMode(){
        let Reach = Reachability()
        if (Reach?.isReachable)! {
            if AppDelegate.BINGO_INFO {
                AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: false)
                AppDelegate.BINGO_INFO = false
            }
            if(AppDelegate.getDelegate().getUnknownBags(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation()) == "S"){
                if ScanManager.LocalStorage.getFlightInformation().count > 0 && UserDefaults.standard.value(forKey: "bingo") != nil && (UserDefaults.standard.value(forKey: "bingo") as! NSDictionary).value(forKey: "numberOfBags") != nil{
                    NavigateToBingo(numberOfBags: (UserDefaults.standard.value(forKey: "bingo") as! NSDictionary).value(forKey: "numberOfBags") as! Int)
                } else {
                    AppDelegate.vc.ConnectivityView.bingoInformationView = BingoInformationView()
                    AppDelegate.vc.ConnectivityView.bingoInformationView.withFlightInfo=true
                    AppDelegate.vc.ConnectivityView.navigationController?.pushViewController(AppDelegate.vc.ConnectivityView.bingoInformationView, animated: false)
                    AppDelegate.BINGO_INFO=true
                }
            } else if(AppDelegate.getDelegate().getUnknownBags(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation()) == "I"){
                if  UserDefaults.standard.value(forKey: "bingo") != nil && (UserDefaults.standard.value(forKey: "bingo") as! NSDictionary).value(forKey: "numberOfBags") != nil{
                    NavigateToBingo(numberOfBags: (UserDefaults.standard.value(forKey: "bingo") as! NSDictionary).value(forKey: "numberOfBags") as! Int)
                }  else {
                    AppDelegate.vc.ConnectivityView.bingoInformationView = BingoInformationView()
                    AppDelegate.vc.ConnectivityView.bingoInformationView.withFlightInfo=false
                    AppDelegate.vc.ConnectivityView.navigationController?.pushViewController(AppDelegate.vc.ConnectivityView.bingoInformationView, animated: false)
                    AppDelegate.BINGO_INFO=true
                }
            }
        } else {
            AppDelegate.getDelegate().AddInternetConnectionView()
        }
    }
    
    func NavigateToBingo(numberOfBags:Int){
        if ScanManager.LocalStorage.GetTrackingLocation() != "" && isValidBingoLocation(trackingLocation: ScanManager.LocalStorage.GetTrackingLocation()) && IsStillValidTrackingLocation(){
            if !duplicatedCallBack{
            let seconds = ScanManager.LocalStorage.GetTrackingPointValidityUntil().timeIntervalSince(Date())
            AppDelegate.getDelegate().UpdateLocationOnAppHeader(seconds:Int(seconds),trackingLocation:AppDelegate.getDelegate().getTrackingLocation(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()))
            AppDelegate.vc.ConnectivityView.bingoView = BingoViewController()
            AppDelegate.vc.ConnectivityView.bingoView.numberOfBags=numberOfBags
            AppDelegate.vc.ConnectivityView.bingoView.flightInfo=ScanManager.LocalStorage.getFlightInformation()
                AppDelegate.vc.ConnectivityView.navigationController?.pushViewController(AppDelegate.vc.ConnectivityView.bingoView, animated: true)
                self.duplicatedCallBack = true
                duplicateTimer = Timer.scheduledTimer(timeInterval:4, target: self, selector: #selector(setDuplicatedCallBack), userInfo: nil, repeats: false)
            }
        } else {
            UserDefaults.standard.removeObject(forKey: "bingo")
            ScanManager.LocalStorage.removeFlightInformation()
            ScanManager.LocalStorage.RemoveTrackingLocation()
            ScanManager.LocalStorage.RemoveTrackingPointRaw()
            ScanManager.LocalStorage.RemoveTrackingPointValidityUntil()
            CheckForViews()
        }
    }
    
    func setDuplicatedCallBack() {
        self.duplicatedCallBack=false
    }
    
    @IBAction func registerLocal(sender: AnyObject) {
        let notificationSettings = UIUserNotificationSettings.init(types:[.alert,.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    
    @IBAction func scheduleLocal(sender: AnyObject) {
        AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper.postSetDataConfirmation(atBackground: AppDelegate.vc.ConnectivityView.SocketMobile.Device, target: self, response: nil)
        let notification = UILocalNotification()
        notification.fireDate = Date()
        notification.alertBody = AppDelegate.LocalNotificationMessage
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
        
        guard let settings = UIApplication.shared.currentUserNotificationSettings else { return }
        
        if settings.types == .none {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
    }
}


class Container: NSObject{
    var name: String = ""
    var containerDesc: String = ""
    var size: String = ""
    var contour: String = ""
    var type: String = ""
    var synced: Bool = false
}

class Bag: NSObject{
    var bagTag: String = ""
    var type: String = ""
    var Trackinglocation: String = ""
    var status: String = ""
    var synced: Bool = false
    var containerID = ""
    
    func AddBagToQueue() -> NSDictionary{
        let dic:NSDictionary = ["ID":bagTag,"name":Trackinglocation,"type":type]
        return dic
    }
}
