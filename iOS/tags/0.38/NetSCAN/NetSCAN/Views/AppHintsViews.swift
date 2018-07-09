//
//  AppHintsViews.swift
//  NetSCAN
//
//  Created by User on 9/19/16.
//  Copyright © 2016 User. All rights reserved.
//

import Foundation
import UIKit


class AppHintsViews: UIView
{
    let infiniteTextView = UITextView()
    var textHeight = CGFloat()
    let DelegetInstance = AppDelegate()
    var view: UIView!
    var creditsView: UIView!
    var LogInFailedView : UIView!
    var flag: Bool = false
    
    func getDeviceConnectionView(status:String) -> UIView{
        let screen=UIScreen.main.bounds
        let DeviceConnectivityView=UIView(frame: CGRect(x:25,y:screen.height/2-75,width:screen.width-50,height:150))
        let DeviceConnectivityLabel=UILabel(frame: CGRect(x:10,y:20,width:DeviceConnectivityView.frame.width-20,height:25))
        var DeviceConnectivityStatusLabel=UILabel(frame: CGRect(x:0 ,y:0,width:0,height:0))
        DeviceConnectivityView.backgroundColor=PrimaryBackroundViewColor()
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y:0, width:DeviceConnectivityView.frame.width, height: DeviceConnectivityView.frame.height)
        border.borderWidth = width
        DeviceConnectivityView.layer.addSublayer(border)
        DeviceConnectivityView.layer.masksToBounds = true
        DeviceConnectivityLabel.text="testing_connection".localized
        DeviceConnectivityLabel.adjustsFontSizeToFitWidth=true
        DeviceConnectivityLabel.textColor=SecondaryGrayColor()
        DeviceConnectivityLabel.textAlignment=NSTextAlignment.center
        DeviceConnectivityView.addSubview(DeviceConnectivityLabel)
        if(status.isEqual("Connected")){
            DeviceConnectivityStatusLabel=UILabel(frame: CGRect(x:10 ,y:50,width:DeviceConnectivityView.frame.width-20,height:25))
            DeviceConnectivityStatusLabel.text="connected".localized
        }else{
            if(status.isEqual("Not Connected")){
                DeviceConnectivityStatusLabel=UILabel(frame: CGRect(x:10 ,y:50,width:DeviceConnectivityView.frame.width-20,height:25))
                DeviceConnectivityStatusLabel.text="disconnect".localized
            }
        }
        DeviceConnectivityStatusLabel.textAlignment=NSTextAlignment.center
        DeviceConnectivityStatusLabel.adjustsFontSizeToFitWidth=true
        DeviceConnectivityStatusLabel.textColor=UIColor.red
        DeviceConnectivityStatusLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        DeviceConnectivityView.addSubview(DeviceConnectivityStatusLabel)
        let DeviceButtonsView=UIView(frame:CGRect(x:(DeviceConnectivityView.frame.width/2)-(DeviceConnectivityView.frame.width/2.4),y:DeviceConnectivityStatusLabel.frame.height+DeviceConnectivityStatusLabel.frame.origin.y+15,width:DeviceConnectivityView.frame.width/1.2,height:40))
        DeviceConnectivityView.addSubview(DeviceButtonsView)
        let DeviceConnectivitySetupButton=UIButton(type: UIButtonType.system) as UIButton
        DeviceConnectivitySetupButton.frame=CGRect(x:0,y:0,width:DeviceButtonsView.frame.width/3.5,height:40)
        DeviceConnectivitySetupButton.setTitle("set_up".localized, for: .normal)
        DeviceConnectivitySetupButton.titleLabel!.font = UIFont.systemFont(ofSize: DeviceConnectivitySetupButton.frame.width/8)
        DeviceConnectivitySetupButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        DeviceConnectivitySetupButton.backgroundColor=SecondaryGrayColor()
        DeviceConnectivitySetupButton.layer.cornerRadius = 5
        DeviceConnectivitySetupButton.clipsToBounds = true
        DeviceConnectivitySetupButton.addTarget(self, action: #selector(SetUpScanner), for: .touchUpInside)
        DeviceButtonsView.addSubview(DeviceConnectivitySetupButton)
        let ManteeScannerButton=UIButton(type: UIButtonType.system) as UIButton
        ManteeScannerButton.frame=CGRect(x:DeviceButtonsView.frame.width/2-(DeviceButtonsView.frame.width/7),y:0,width:DeviceButtonsView.frame.width/3.5,height:40)
        ManteeScannerButton.setTitle("Cancel".localized, for: .normal)
        ManteeScannerButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        ManteeScannerButton.titleLabel!.font = UIFont.systemFont(ofSize: ManteeScannerButton.frame.width/8)
        ManteeScannerButton.backgroundColor=SecondaryGrayColor()
        ManteeScannerButton.layer.cornerRadius = 5
        ManteeScannerButton.clipsToBounds = true
        ManteeScannerButton.addTarget(self, action: #selector(CancelButton), for: .touchUpInside)
        DeviceButtonsView.addSubview(ManteeScannerButton)
        let DeviceConnectivityResetButton=UIButton(type: UIButtonType.system) as UIButton
        DeviceConnectivityResetButton.frame=CGRect(x:DeviceButtonsView.frame.width-(DeviceButtonsView.frame.width/3.5),y:0,width:DeviceButtonsView.frame.width/3.5,height:40)
        DeviceConnectivityResetButton.setTitle("reset_scanner".localized, for: .normal)
        DeviceConnectivityResetButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        DeviceConnectivityResetButton.titleLabel!.font = UIFont.systemFont(ofSize: DeviceConnectivityResetButton.frame.width/8)
        DeviceConnectivityResetButton.backgroundColor=SecondaryGrayColor()
        DeviceConnectivityResetButton.layer.cornerRadius = 5
        DeviceConnectivityResetButton.clipsToBounds = true
        DeviceConnectivityResetButton.addTarget(self, action: #selector(ResetScanner), for: .touchUpInside)
        DeviceButtonsView.addSubview(DeviceConnectivityResetButton)
        return DeviceConnectivityView
    }
    
    func getInternetConnectionView(status:String) -> UIView{
        let screen=UIScreen.main.bounds
        let DeviceConnectivityView=UIView(frame: CGRect(x:25,y:(screen.height-(screen.width/12+73))/2,width:screen.width-50,height:100))
        let DeviceConnectivityLabel=UILabel(frame: CGRect(x:10,y:20,width:DeviceConnectivityView.frame.width-20,height:25))
        var DeviceConnectivityStatusLabel=UILabel(frame: CGRect(x:0 ,y:0,width:0,height:0))
        DeviceConnectivityView.backgroundColor=PrimaryBackroundViewColor()
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y:0, width:DeviceConnectivityView.frame.width, height: DeviceConnectivityView.frame.height)
        border.borderWidth = width
        DeviceConnectivityView.layer.addSublayer(border)
        DeviceConnectivityView.layer.masksToBounds = true
        DeviceConnectivityLabel.text="Aquiring connection..."
        DeviceConnectivityLabel.adjustsFontSizeToFitWidth=true
        DeviceConnectivityLabel.textColor=SecondaryGrayColor()
        DeviceConnectivityLabel.textAlignment=NSTextAlignment.center
        DeviceConnectivityView.addSubview(DeviceConnectivityLabel)
        if(status.isEqual("Connected")){
            DeviceConnectivityStatusLabel=UILabel(frame: CGRect(x:10 ,y:50,width:DeviceConnectivityView.frame.width-20,height:25))
            DeviceConnectivityStatusLabel.text="connected".localized
        }else{
            if(status.isEqual("Not Connected")){
                DeviceConnectivityStatusLabel=UILabel(frame: CGRect(x:10 ,y:50,width:DeviceConnectivityView.frame.width-20,height:25))
                DeviceConnectivityStatusLabel.text="OFFLINE"
            }
        }
        DeviceConnectivityStatusLabel.textAlignment=NSTextAlignment.center
        DeviceConnectivityStatusLabel.adjustsFontSizeToFitWidth=true
        DeviceConnectivityStatusLabel.textColor=UIColor.red
        DeviceConnectivityStatusLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        DeviceConnectivityView.addSubview(DeviceConnectivityStatusLabel)
        return DeviceConnectivityView
    }
    
    func getFetchingBagView() -> UIView{
        let screen=UIScreen.main.bounds
        let FetchingBagView=UIView(frame: CGRect(x:25,y:(screen.height-(screen.width/12+73))/2,width:screen.width-50,height:100))
        let DeviceConnectivityLabel=UILabel(frame: CGRect(x:10,y:20,width:FetchingBagView.frame.width-20,height:25))
        FetchingBagView.backgroundColor=PrimaryBackroundViewColor()
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y:0, width:FetchingBagView.frame.width, height: FetchingBagView.frame.height)
        border.borderWidth = width
        FetchingBagView.layer.addSublayer(border)
        FetchingBagView.layer.masksToBounds = true
        DeviceConnectivityLabel.text="Fetching bag info"
        DeviceConnectivityLabel.adjustsFontSizeToFitWidth=true
        DeviceConnectivityLabel.textColor=SecondaryGrayColor()
        DeviceConnectivityLabel.textAlignment=NSTextAlignment.center
        FetchingBagView.addSubview(DeviceConnectivityLabel)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x:FetchingBagView.frame.width/2-3, y:((FetchingBagView.frame.height/3)*2),width: 1.5,height: 1.5)) as UIActivityIndicatorView
        loadingIndicator.tag=123
        loadingIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        loadingIndicator.startAnimating()
        FetchingBagView.addSubview(loadingIndicator)
        return FetchingBagView
    }
    
    func getConnectingToServerView(bagTag:String,synced:Bool,flightInfo:Bool) -> UIView {
        
        let ContainerDetailView=UIView(frame: CGRect(x:20,y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/4),width:UIScreen.main.bounds.width-40,height:Constants.UIScreenMainHeight/2))
        
        
        let ContainerDetailContainer=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:-ContainerDetailView.frame.width/12,width:ContainerDetailView.frame.width/4,height:ContainerDetailView.frame.width/4))
        
        ContainerDetailContainer.backgroundColor=SecondaryGrayColor()
        ContainerDetailContainer.layer.cornerRadius = 5;
        ContainerDetailContainer.layer.masksToBounds = true;

        ContainerDetailView.backgroundColor=BagDetailsBackgroundColor().withAlphaComponent(0.9)
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y:0, width:ContainerDetailView.frame.width, height: ContainerDetailView.frame.height)
        border.borderWidth = width
        ContainerDetailView.layer.addSublayer(border)
        ContainerDetailView.layer.masksToBounds = false
        
        
        let ContainerDetailImageView=UIImageView(frame: CGRect(x:10,y:10,width:ContainerDetailContainer.frame.width-20,height:ContainerDetailContainer.frame.height-20))
        
        ContainerDetailImageView.image=UIImage(named: "Bag")
        ContainerDetailImageView.image = ContainerDetailImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailImageView.tintColor = primaryColor()
        
        ContainerDetailContainer.addSubview(ContainerDetailImageView)
        ContainerDetailView.addSubview(ContainerDetailContainer)
        
        
         let ContainerDetailBagIdLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/2.5,y:ContainerDetailView.frame.height/18,width:ContainerDetailView.frame.width/1.7,height:15))
        ContainerDetailBagIdLabel.text=bagTag
        ContainerDetailBagIdLabel.textColor=secondaryColor()
        ContainerDetailBagIdLabel.adjustsFontSizeToFitWidth=true
        ContainerDetailView.addSubview(ContainerDetailBagIdLabel)
        
        let ContainerDetailTypeLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/2.5,y:ContainerDetailView.frame.width/10,width:100,height:20))
        ContainerDetailTypeLabel.text=AppDelegate.getDelegate().getTrackingID(scannedBarcode: (UserDefaultsManager().GetTrackingLocation()))
        ContainerDetailTypeLabel.adjustsFontSizeToFitWidth=true
        ContainerDetailTypeLabel.textColor=OrangeColorInverted()
        ContainerDetailView.addSubview(ContainerDetailTypeLabel)
        
        let ContainerDetailLocationImageView=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:ContainerDetailContainer.frame.height,width:25,height:25))
        ContainerDetailLocationImageView.image=UIImage(named: "gps-fixed")
        ContainerDetailLocationImageView.image = ContainerDetailLocationImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailLocationImageView.tintColor = secondaryColor()
        ContainerDetailView.addSubview(ContainerDetailLocationImageView)
        
        let ContainerDetailLocationLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/5,y:ContainerDetailContainer.frame.height,width:ContainerDetailView.frame.width/1.7,height:25))
        ContainerDetailLocationLabel.text=AppDelegate.getDelegate().GetTrackingLocation(TrackingPoint:UserDefaultsManager().GetTrackingLocation())
        ContainerDetailLocationLabel.textColor=secondaryColor()
        ContainerDetailLocationLabel.adjustsFontSizeToFitWidth=true
        ContainerDetailView.addSubview(ContainerDetailLocationLabel)
        
        
        let TempraryFlightLabel = UILabel(frame: CGRect(x:20, y:ContainerDetailLocationLabel.frame.origin.y+ContainerDetailLocationLabel.frame.size.height+25, width:ContainerDetailView.frame.size.width-40, height:20))
        if(flightInfo){
            TempraryFlightLabel.text=UserDefaults.standard.value(forKey: "TemporaryFligthInfo") as! String?
            TempraryFlightLabel.textColor = secondaryColor()
            TempraryFlightLabel.adjustsFontSizeToFitWidth=true
            ContainerDetailView.addSubview(TempraryFlightLabel)
        }
        
        if (!synced){
            
            let LoaderView = NVActivityIndicatorView(frame:CGRect(x:(ContainerDetailView.frame.size.width/2)-37.5, y:(ContainerDetailView.frame.size.height/2)+15, width:75, height:75), type: NVActivityIndicatorType.ballSpinFadeLoader, color:secondaryColor(), padding:0)
            LoaderView.startAnimating()
            ContainerDetailView.addSubview(LoaderView)
            
            let LoaderViewLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/5,y:LoaderView.frame.origin.y+LoaderView.frame.height+10,width:ContainerDetailView.frame.width/1.7,height:25))
            LoaderViewLabel.text="synchronizing_bag".localized
            LoaderViewLabel.textAlignment = .center
            LoaderViewLabel.textColor=secondaryColor()
            LoaderViewLabel.adjustsFontSizeToFitWidth=true
            ContainerDetailView.addSubview(LoaderViewLabel)
        } else {
            let checkMarkImageView = UIImageView(frame: CGRect(x:(ContainerDetailView.frame.size.width/2)-37.5, y:(ContainerDetailView.frame.size.height/2)+15, width:75, height:75))
            checkMarkImageView.image = UIImage(named: "checkmark.png")?.withRenderingMode(.alwaysTemplate)
            checkMarkImageView.tintColor = UIColor.green
            ContainerDetailView.addSubview(checkMarkImageView)
        }
        
        return ContainerDetailView
        
    }
    
    func getBluetoothRequiredView() -> UIView{
        let screen=UIScreen.main.bounds
        let DeviceConnectivityView=UIView(frame: CGRect(x:25,y:(screen.height-(screen.width/12+73))/2,width:screen.width-50,height:100))
        let DeviceConnectivityLabel=UILabel(frame: CGRect(x:10,y:20,width:DeviceConnectivityView.frame.width-20,height:25))
        var DeviceConnectivityStatusLabel=UILabel(frame: CGRect(x:0 ,y:0,width:0,height:0))
        DeviceConnectivityView.backgroundColor=PrimaryBackroundViewColor()
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y:0, width:DeviceConnectivityView.frame.width, height: DeviceConnectivityView.frame.height)
        border.borderWidth = width
        DeviceConnectivityView.layer.addSublayer(border)
        DeviceConnectivityView.layer.masksToBounds = true
        DeviceConnectivityLabel.text="Bluetooth is required"
        DeviceConnectivityLabel.adjustsFontSizeToFitWidth=true
        DeviceConnectivityLabel.textColor=SecondaryGrayColor()
        DeviceConnectivityLabel.textAlignment=NSTextAlignment.center
        DeviceConnectivityView.addSubview(DeviceConnectivityLabel)
        DeviceConnectivityStatusLabel=UILabel(frame: CGRect(x:10 ,y:50,width:DeviceConnectivityView.frame.width-20,height:25))
        DeviceConnectivityStatusLabel.text="Bluetooth is powerd off".localized
        DeviceConnectivityStatusLabel.textAlignment=NSTextAlignment.center
        DeviceConnectivityStatusLabel.adjustsFontSizeToFitWidth=true
        DeviceConnectivityStatusLabel.textColor=UIColor.red
        DeviceConnectivityStatusLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        DeviceConnectivityView.addSubview(DeviceConnectivityStatusLabel)
        return DeviceConnectivityView
    }

    func SetUpScanner(){
        AppDelegate.IsUSerINMainView=false
        DelegetInstance.LunshViewController()
    }
    
    func ResetScanner(){
        AppDelegate.IsUSerINMainView=false
        DelegetInstance.LunchNavigatToResetDivice()
    }
    
    func OfflineScanner(){
        self.DelegetInstance.LunchOfflineScanner()
    }
    
    func getScanTrackingPointView()-> UIView{
        
        let scanTrackingPointView = UIView(frame:CGRect(x: 0, y:UIScreen.main.bounds.height-60, width:UIScreen.main.bounds.width, height: 60))
        scanTrackingPointView.backgroundColor = UIColor.red
        
        let scannerImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        scannerImageView.image = UIImage(named: "bar-code-scanner.png")?.withRenderingMode(.alwaysTemplate)
        scannerImageView.tintColor = UIColor.white
        
        scanTrackingPointView.addSubview(scannerImageView)
        
        
        let descriptionLabel = UILabel(frame:CGRect(x: 60, y: 10, width: UIScreen.main.bounds.width-60, height: 40))
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = UIColor(white: 1, alpha: 0.85)
        descriptionLabel.text = "scan_tracking".localized
        
        scanTrackingPointView.addSubview(descriptionLabel)
        
        return scanTrackingPointView
    }
    
//    func getScanTrackingPointView()-> UIView{
//        let screen=UIScreen.main.bounds
//        let ScanTrackingPointView=UIView(frame: CGRect(x:0,y:0,width:0,height:0))
//        if(UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
//            ScanTrackingPointView.frame=CGRect(x:25,y:0,width:screen.width-50,height:150)
//        }else{
//            ScanTrackingPointView.frame=CGRect(x:25,y:(screen.height-(screen.width/12+73))/2,width:screen.width-50,height:150)
//        }
//        let ScanTrackingPointImageView=UIImageView(frame: CGRect(x:ScanTrackingPointView.frame.width/2-25,y:ScanTrackingPointView.frame.height/2-50,width:50,height:50))
//        let ScanTrackingPointLabel=UILabel(frame: CGRect(x:10 ,y:ScanTrackingPointView.frame.height/2+10,width:ScanTrackingPointView.frame.width-20,height:25))
//        ScanTrackingPointView.backgroundColor=PrimaryBackroundViewColor()
//        let border = CALayer()
//        let width = CGFloat(3.0)
//        border.borderColor = PrimaryBoarder().cgColor
//        border.frame = CGRect(x: 0, y:0, width:ScanTrackingPointView.frame.width, height: ScanTrackingPointView.frame.height)
//        border.borderWidth = width
//        ScanTrackingPointView.layer.addSublayer(border)
//        ScanTrackingPointView.layer.masksToBounds = true
//        ScanTrackingPointImageView.image=UIImage(named: "bar-code-scanner")
//        ScanTrackingPointImageView.image = ScanTrackingPointImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        ScanTrackingPointImageView.tintColor = secondaryColor()
//        ScanTrackingPointView.addSubview(ScanTrackingPointImageView)
//        ScanTrackingPointLabel.text="scan_tracking".localized
//        ScanTrackingPointLabel.adjustsFontSizeToFitWidth=true
//        ScanTrackingPointLabel.textColor=SecondaryGrayColor()
//        ScanTrackingPointLabel.textAlignment=NSTextAlignment.center
//        ScanTrackingPointLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
//        ScanTrackingPointView.addSubview(ScanTrackingPointLabel)
//
//
//        if UserDefaults.standard.value(forKey: "selected_airport") != nil &&
//            ScanManager.LocalStorage.getTrackingConfigurationFor(airportCode: UserDefaults.standard.value(forKey: "selected_airport") as! String) != nil {
//            let mainView = UIView(frame:CGRect(x:0, y: ScanTrackingPointView.frame.origin.y - (ScanTrackingPointView.frame.height/3 + 15), width: UIScreen.main.bounds.size.width, height:ScanTrackingPointView.frame.height + ScanTrackingPointView.frame.height/3 + 15))
//
//            ScanTrackingPointView.frame.origin.y = 0
//            mainView.addSubview(ScanTrackingPointView)
//
//            let selectTrackingPointButton = UIView(frame:CGRect(x: ScanTrackingPointView.frame.origin.x, y: ScanTrackingPointView.frame.height+15, width: ScanTrackingPointView.frame.size.width, height:ScanTrackingPointView.frame.height/3))
//
//            selectTrackingPointButton.backgroundColor=PrimaryBackroundViewColor()
//            let border2 = CALayer()
//            let width = CGFloat(3.0)
//            border2.borderColor = PrimaryBoarder().cgColor
//            border2.frame = CGRect(x: 0, y:0, width:selectTrackingPointButton.frame.width, height: selectTrackingPointButton.frame.height)
//            border2.borderWidth = width
//            selectTrackingPointButton.layer.addSublayer(border2)
//            selectTrackingPointButton.layer.masksToBounds = true
//
//            let selectTrackingPointLabel = UILabel(frame:CGRect(x: 0, y:0, width:selectTrackingPointButton.frame.width, height: selectTrackingPointButton.frame.height))
//            selectTrackingPointLabel.text="tap_to_select_tracking_ponit".localized
//            selectTrackingPointLabel.adjustsFontSizeToFitWidth=true
//            selectTrackingPointLabel.textColor=SecondaryGrayColor()
//            selectTrackingPointLabel.textAlignment=NSTextAlignment.center
//            selectTrackingPointLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
//
//            selectTrackingPointButton.addSubview(selectTrackingPointLabel)
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectTrackingPointPressed))
//            selectTrackingPointButton.addGestureRecognizer(tapGesture)
//
//            mainView.addSubview(selectTrackingPointButton)
//            return mainView
//        }
//        return ScanTrackingPointView
//    }
    
    func selectTrackingPointPressed() {
        AppDelegate.getDelegate().doClose()
        
        let loginInfo = UserDefaultsManager().getLoginInfo() as NSDictionary
        let responseDic = UserDefaultsManager().getLoginResponse()
        
        let selectTrackingConfig = SelectTrackingConfigurationView()
        selectTrackingConfig.Service_ID = (responseDic["service_id"] as! String)
        selectTrackingConfig.User_ID = loginInfo.value(forKey: "userID") as! String
        AppDelegate.vc.ConnectivityView.navigationController?.pushViewController(selectTrackingConfig, animated: false)
    }
    
    func getLocationIdentifiedView(location:String) -> UIView{
        let screen=UIScreen.main.bounds
        let showLocationIdentifiedView=UIView(frame: CGRect(x:25,y:(screen.height-(screen.width/12+73))/2,width:screen.width-50,height:250))
        let showLocationIdentifiedLabel=UILabel(frame: CGRect(x:10,y:25,width:showLocationIdentifiedView.frame.width-20,height:25))
        let showLocationIdentifiedImageView=UIImageView(frame: CGRect(x:showLocationIdentifiedView.frame.width/2-25,y:showLocationIdentifiedLabel.frame.origin.y+showLocationIdentifiedLabel.frame.height+10,width:50,height:50))
        let showshowLocationIdentifiedGatesLabel=UILabel(frame: CGRect(x:10,y:showLocationIdentifiedImageView.frame.origin.y+showLocationIdentifiedImageView.frame.height+10,width:showLocationIdentifiedView.frame.width-20,height:25))
        let showLocationIdentifiedTimeoutLabel=UILabel(frame: CGRect(x:10,y:showshowLocationIdentifiedGatesLabel.frame.origin.y+showshowLocationIdentifiedGatesLabel.frame.height+10,width:showLocationIdentifiedView.frame.width-20,height:25))
        let showLocationIdentifiedCountdownLabel=UILabel(frame: CGRect(x:10,y:showLocationIdentifiedTimeoutLabel.frame.origin.y+showLocationIdentifiedTimeoutLabel.frame.height+10,width:showLocationIdentifiedView.frame.width-20,height:25))
        showLocationIdentifiedView.backgroundColor=PrimaryBackroundViewColor()
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y:0, width:showLocationIdentifiedView.frame.width, height: showLocationIdentifiedView.frame.height)
        border.borderWidth = width
        showLocationIdentifiedView.layer.addSublayer(border)
        showLocationIdentifiedView.layer.masksToBounds = true
        showLocationIdentifiedLabel.text="location_identifed".localized
        showLocationIdentifiedLabel.textColor=SecondaryGrayColor()
        showLocationIdentifiedLabel.textAlignment=NSTextAlignment.center
        showLocationIdentifiedLabel.adjustsFontSizeToFitWidth=true
        showLocationIdentifiedLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        showLocationIdentifiedView.addSubview(showLocationIdentifiedLabel)
        showLocationIdentifiedImageView.image=UIImage(named: "gps-fixed")
        showLocationIdentifiedImageView.image = showLocationIdentifiedImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        showLocationIdentifiedImageView.tintColor = SecondaryGrayColor()
        showLocationIdentifiedView.addSubview(showLocationIdentifiedImageView)
        showshowLocationIdentifiedGatesLabel.text=location
        showshowLocationIdentifiedGatesLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        showshowLocationIdentifiedGatesLabel.textAlignment=NSTextAlignment.center
        showshowLocationIdentifiedGatesLabel.numberOfLines=1
        showshowLocationIdentifiedGatesLabel.adjustsFontSizeToFitWidth=true
        showshowLocationIdentifiedGatesLabel.textAlignment=NSTextAlignment.center
        showshowLocationIdentifiedGatesLabel.textColor = secondaryColor()
        showLocationIdentifiedView.addSubview(showshowLocationIdentifiedGatesLabel)
        showLocationIdentifiedTimeoutLabel.text="location_timeout".localized
        showLocationIdentifiedTimeoutLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        showLocationIdentifiedTimeoutLabel.textAlignment=NSTextAlignment.center
        showLocationIdentifiedTimeoutLabel.adjustsFontSizeToFitWidth=true
        showLocationIdentifiedTimeoutLabel.textColor = SecondaryGrayColor()
        showLocationIdentifiedView.addSubview(showLocationIdentifiedTimeoutLabel)
        showLocationIdentifiedCountdownLabel.text="59:58"
        showLocationIdentifiedCountdownLabel.font=UIFont.boldSystemFont(ofSize: 20.0)
        showLocationIdentifiedCountdownLabel.textAlignment=NSTextAlignment.center
        showLocationIdentifiedCountdownLabel.textColor = OrangeColorInverted()
        showLocationIdentifiedView.addSubview(showLocationIdentifiedCountdownLabel)
        let tempTimer = MyCustomClass()
        tempTimer.StartCountDownTimer(seconds:3600, label: showLocationIdentifiedCountdownLabel)
        return showLocationIdentifiedView
    }
    
    func getContainerIdentifiedView() -> UIView{
        let screen=UIScreen.main.bounds
        let showContainerIdentifiedView=UIView()
        
        let ContainerID = UserDefaultsManager().GetContainerID()
        
        if(UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
            showContainerIdentifiedView.frame=CGRect(x:25,y:0,width:screen.width-50,height:225)
        }else{
            showContainerIdentifiedView.frame=CGRect(x:25,y:(screen.height-(screen.width/12+73))/2,width:screen.width-50,height:225)
        }
        showContainerIdentifiedView.backgroundColor=PrimaryBackroundViewColor()
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y:0, width:showContainerIdentifiedView.frame.width, height: showContainerIdentifiedView.frame.height)
        border.borderWidth = width
        showContainerIdentifiedView.layer.addSublayer(border)
        showContainerIdentifiedView.layer.masksToBounds = true
        
        //"container_identified".localized 16
        // containerID 20
        
        let identifiedLabel = UILabel(frame:CGRect(x:15, y:20, width: showContainerIdentifiedView.frame.size.width-30, height: 30))
        identifiedLabel.text = "container_identified".localized
        identifiedLabel.font = UIFont.systemFont(ofSize: 16)
        identifiedLabel.adjustsFontSizeToFitWidth = true
        identifiedLabel.textAlignment = NSTextAlignment.center
        identifiedLabel.textColor = secondaryColor()
        showContainerIdentifiedView.addSubview(identifiedLabel)
        
        let containerImage=UIImageView(frame:CGRect(x:(showContainerIdentifiedView.frame.width/2)-(showContainerIdentifiedView.frame.height/4),y:(showContainerIdentifiedView.frame.height/2)-(((showContainerIdentifiedView.frame.height/2)*0.72)/2),width:showContainerIdentifiedView.frame.height/2,height:(showContainerIdentifiedView.frame.height/2)*0.72))
        containerImage.image=UIImage(named:"\(String(ContainerID.characters.first!).uppercased())")
        showContainerIdentifiedView.addSubview(containerImage)
        
        let IDlabel = UILabel(frame:CGRect(x:15, y:showContainerIdentifiedView.frame.size.height-50, width: showContainerIdentifiedView.frame.size.width-30, height: 30))
        IDlabel.text = ContainerID
        IDlabel.font = UIFont.systemFont(ofSize: 20)
        IDlabel.adjustsFontSizeToFitWidth = true
        IDlabel.textAlignment = NSTextAlignment.center
        IDlabel.textColor = secondaryColor()
        showContainerIdentifiedView.addSubview(IDlabel)
        
        return showContainerIdentifiedView
    }
    
    
    func getContainerRequiredView()-> UIView{
        
        let ContainerRequiredView = UIView(frame:CGRect(x: 0, y:UIScreen.main.bounds.height-60, width:UIScreen.main.bounds.width, height: 60))
        ContainerRequiredView.backgroundColor = UIColor.red
        
        let scannerImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        scannerImageView.image = UIImage(named: "bar-code-scanner.png")?.withRenderingMode(.alwaysTemplate)
        scannerImageView.tintColor = UIColor.white
        
        ContainerRequiredView.addSubview(scannerImageView)
        

        let titleLabel = UILabel(frame:CGRect(x: 60, y: 5, width: UIScreen.main.bounds.width-60, height: 30))
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor(white: 1, alpha: 1)
        titleLabel.text = "container_required".localized
        
        ContainerRequiredView.addSubview(titleLabel)
        
        let descriptionLabel = UILabel(frame:CGRect(x: 60, y: 25, width: UIScreen.main.bounds.width-60, height: 30))
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = UIColor(white: 1, alpha: 0.6)
        descriptionLabel.text = "scan_container".localized
        
        ContainerRequiredView.addSubview(descriptionLabel)
        
        return ContainerRequiredView
    }
    
    
    func getStartScanningBagsView()-> UIView{
        
        let mainView = UIView(frame:CGRect(x: 0, y:UIScreen.main.bounds.height-60, width:UIScreen.main.bounds.width, height: 60))
        mainView.backgroundColor = UIColor.black
        
        let BagsRequiredView = UIView(frame:CGRect(x: 0, y:0, width:UIScreen.main.bounds.width, height: 60))
        BagsRequiredView.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        
        let scannerImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        scannerImageView.image = UIImage(named: "bar-code-scanner.png")?.withRenderingMode(.alwaysTemplate)
        scannerImageView.tintColor = UIColor.white
        BagsRequiredView.addSubview(scannerImageView)
        
        
        let titleLabel = UILabel(frame:CGRect(x: 60, y:2, width: UIScreen.main.bounds.width-60, height: 20))
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.white
        titleLabel.text = "start_scan_bags".localized
        
        BagsRequiredView.addSubview(titleLabel)
        
        let descriptionLabel = UILabel(frame:CGRect(x: 60, y: 25, width: UIScreen.main.bounds.width-60, height: 30))
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.text = "switch_container".localized
        descriptionLabel.numberOfLines=2
        descriptionLabel.adjustsFontSizeToFitWidth=true
        
        BagsRequiredView.addSubview(descriptionLabel)
        mainView.addSubview(BagsRequiredView)
        return mainView
    }
    
    func getFlightInformationView(info:String) -> UIView{
        let screen=UIScreen.main.bounds
        let showFlightInformationViewContainer=UIView(frame: CGRect(x:30,y:(screen.width/12+73)+15 /*screen.height/5.5*/,width:screen.width-40,height:80))
        let showFlightInformationImageView=UIImageView(frame: CGRect(x:0,y:0,width:showFlightInformationViewContainer.frame.size.height,height:showFlightInformationViewContainer.frame.size.height))
        let showFlightInformationView=UIView(frame: CGRect(x:showFlightInformationImageView.frame.width-(showFlightInformationViewContainer.frame.size.height*0.32),y:showFlightInformationViewContainer.frame.height/12,width:showFlightInformationViewContainer.frame.width/1.5,height:showFlightInformationViewContainer.frame.size.height*0.7))
        let showFlightInformationLabel=UILabel(frame: CGRect(x:5,y:5,width:showFlightInformationView.frame.width-10,height:showFlightInformationView.frame.height-10))
        showFlightInformationImageView.image=UIImage(named:"airline")
        showFlightInformationImageView.image = showFlightInformationImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        showFlightInformationImageView.tintColor = SecondaryGrayColor()
//        showFlightInformationViewContainer.addSubview(showFlightInformationImageView)
        showFlightInformationView.backgroundColor=PrimaryBackroundViewColor()
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y:0, width:showFlightInformationView.frame.width, height: showFlightInformationView.frame.height)
        border.borderWidth = width
        showFlightInformationView.layer.addSublayer(border)
        showFlightInformationView.layer.masksToBounds = true
        showFlightInformationLabel.text=info
        showFlightInformationLabel.adjustsFontSizeToFitWidth=true
        showFlightInformationLabel.numberOfLines=2
        showFlightInformationLabel.textAlignment=NSTextAlignment.center
        showFlightInformationLabel.textColor=secondaryColor()
        showFlightInformationLabel.alpha=1
        UserDefaults.standard.set(info, forKey:"TemporaryFligthInfo")
        showFlightInformationView.addSubview(showFlightInformationLabel)
        showFlightInformationViewContainer.addSubview(showFlightInformationView)
        showFlightInformationViewContainer.addSubview(showFlightInformationImageView)
        
        return showFlightInformationViewContainer
    }
    
    func getMenuItemsView(hasContainer: Bool, hasFlight: Bool, hasTrackingPoint:Bool) -> UIView {
                
        if(UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            AppDelegate.vc.ConnectivityView.CognexManager.GetBatteryLevel()
            AppDelegate.vc.ConnectivityView.CognexManager.GetFirmwareVersion()
        } else if(UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            AppDelegate.vc.ConnectivityView.SocketMobile.GetFirmwareVersion()
            AppDelegate.vc.ConnectivityView.SocketMobile.GetBatteryLevel()
        }
        
        let screen=UIScreen.main.bounds
        view=UIView(frame: CGRect(x:0, y:UIApplication.shared.statusBarFrame.height, width:screen.width, height:screen.height-UIApplication.shared.statusBarFrame.height))
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.9)
        view.tag=0
        DelegetInstance.showOverlayWithView(viewToShow: view, dismiss: false, AccessToMenu:false)
        let scrollView = UIScrollView(frame:CGRect(x:0,y:0,width:screen.size.width,height:screen.size.height))
        let containerButton = UIButton(type: UIButtonType.system) as UIButton
        let flightButton = UIButton(type: UIButtonType.system) as UIButton
        let trackingPointButton = UIButton(type: UIButtonType.system) as UIButton
        let SetupScannerButton = UIButton(type: UIButtonType.system) as UIButton
        let BackView = UIView(frame:CGRect(x:10,y:20, width:100, height:70))
        
        let BackButton = UIButton(frame: CGRect(x:0,y:0, width:35, height:35))
        BackButton.addTarget(self, action: #selector(removeMenuItemsView), for: UIControlEvents.touchUpInside)
        BackButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        BackButton.setBackgroundImage(UIImage(named: "left_arrow.png")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        BackButton.tintColor=UIColor.white
        
        let BackLabel = UILabel(frame:CGRect(x:45, y:0, width:50, height: 35))
        BackLabel.textAlignment=NSTextAlignment.center
        BackLabel.text = "back".localized
        BackLabel.textColor = UIColor.white
        
        let BackTap = UITapGestureRecognizer(target: self, action: #selector(removeMenuItemsView))
        
        BackView.addGestureRecognizer(BackTap)
        BackView.addSubview(BackLabel)
        BackView.addSubview(BackButton)
        scrollView.addSubview(BackView)
        
        let UserNameLabel = UILabel(frame: CGRect(x:20,y:75,width:UIScreen.main.bounds.size.width-40, height:60))
        if let _ = UserDefaultsManager().getLoginInfo()["userID"]{
            UserNameLabel.text = UserDefaultsManager().getLoginInfo()["userID"] as? String
        }
        UserNameLabel.font=UIFont.systemFont(ofSize:20)
        UserNameLabel.adjustsFontSizeToFitWidth=true
        UserNameLabel.textColor=UIColor.white
        UserNameLabel.textAlignment=NSTextAlignment.center
        scrollView.addSubview(UserNameLabel)
        
        let ChangePasswordButton = UIButton(type: UIButtonType.system) as UIButton
        ChangePasswordButton.frame = CGRect(x:30,y:160,width:screen.width-60,height:50)
        ChangePasswordButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        ChangePasswordButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        ChangePasswordButton.layer.cornerRadius = 5;
        ChangePasswordButton.layer.masksToBounds = true;
        ChangePasswordButton.setTitle("changePassword".localized.uppercased(), for: UIControlState.normal)
        ChangePasswordButton.addTarget(self, action: #selector(ChangePasswordPressed), for: .touchUpInside)
        scrollView.addSubview(ChangePasswordButton)
        
        let start = CGFloat(ChangePasswordButton.frame.origin.y+(ChangePasswordButton.frame.size.height)+10)
        
        var ButtonCounter = 0
        if hasContainer {
            containerButton.frame = CGRect(x:30,y:start,width:screen.width-60,height:50)
            ButtonCounter += 1
        }
        if hasContainer && hasFlight{
            flightButton.frame = CGRect(x:30,y:containerButton.frame.origin.y+containerButton.frame.size.height+10,width:screen.width-60,height:50)
            ButtonCounter += 1
        }else if hasFlight{
            flightButton.frame = CGRect(x:30,y:start,width:screen.width-60,height:50)
            ButtonCounter += 1
        }
        if hasFlight && hasTrackingPoint{
            trackingPointButton.frame = CGRect(x:30,y:flightButton.frame.origin.y+flightButton.frame.size.height+10,width:screen.width-60,height:50)
            ButtonCounter += 1
        }else if hasContainer && hasTrackingPoint{
            trackingPointButton.frame = CGRect(x:30,y:containerButton.frame.origin.y+containerButton.frame.size.height+10,width:screen.width-60,height:50)
            ButtonCounter += 1
        }else if hasTrackingPoint{
            trackingPointButton.frame = CGRect(x:30,y:start,width:screen.width-60,height:50)
            ButtonCounter += 1
        }
        if (ButtonCounter == 0){
            SetupScannerButton.frame = CGRect(x:30,y:start,width:screen.width-60,height:50)
        }
        if (ButtonCounter == 1){
            SetupScannerButton.frame = CGRect(x:30,y:start+60,width:screen.width-60,height:50)
        }
        if (ButtonCounter == 2){
            SetupScannerButton.frame = CGRect(x:30,y:start+120,width:screen.width-60,height:50)
        }
        if (ButtonCounter == 3){
            SetupScannerButton.frame = CGRect(x:30,y:start+180,width:screen.width-60,height:50)
        }
        
        containerButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        containerButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        containerButton.layer.cornerRadius = 5;
        containerButton.layer.masksToBounds = true;
        containerButton.setTitle("clear_container".localized.uppercased(), for: UIControlState.normal)
        containerButton.addTarget(self, action: #selector(containerButtonClicked), for: .touchUpInside)
        scrollView.addSubview(containerButton)
        flightButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        flightButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        flightButton.layer.cornerRadius = 5;
        flightButton.layer.masksToBounds = true;
        flightButton.setTitle("clear_flight".localized.uppercased(), for: UIControlState.normal)
        flightButton.addTarget(self, action: #selector(flightButtonClicked), for: .touchUpInside)
        scrollView.addSubview(flightButton)
        trackingPointButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        trackingPointButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        trackingPointButton.layer.cornerRadius = 5;
        trackingPointButton.layer.masksToBounds = true;
        trackingPointButton.setTitle("clear_tracking_point".localized.uppercased(), for: UIControlState.normal)
        trackingPointButton.addTarget(self, action: #selector(trackingPointButtonClicked), for: .touchUpInside)
        scrollView.addSubview(trackingPointButton)
        
        let aboutButton = UIButton(type: UIButtonType.system) as UIButton
        aboutButton.frame = CGRect(x:30,y:((ChangePasswordButton.frame.origin.y)+300),width:screen.width-60,height:50)
        aboutButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        aboutButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        aboutButton.layer.cornerRadius = 5;
        aboutButton.layer.masksToBounds = true;
        aboutButton.setTitle("credits".localized.uppercased(), for: UIControlState.normal)
        aboutButton.addTarget(self, action: #selector(aboutButtonClicked), for: .touchUpInside)
        scrollView.addSubview(aboutButton)
        
        let RestartButton = UIButton(type: UIButtonType.system) as UIButton
        RestartButton.frame = CGRect(x:30,y:aboutButton.frame.height+aboutButton.frame.origin.y+10,width:screen.width-60,height:50)
        RestartButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        RestartButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        RestartButton.layer.cornerRadius = 5;
        RestartButton.layer.masksToBounds = true
        RestartButton.setTitle("restart".localized.uppercased(), for: UIControlState.normal)
        RestartButton.addTarget(self, action: #selector(RestartButtonPressed), for: .touchUpInside)
        scrollView.addSubview(RestartButton)
        
        let QuitButton = UIButton(type: UIButtonType.system) as UIButton
        QuitButton.frame = CGRect(x:30,y:RestartButton.frame.height+RestartButton.frame.origin.y+10,width:screen.width-60,height:50)
        QuitButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        QuitButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        QuitButton.layer.cornerRadius = 5;
        QuitButton.layer.masksToBounds = true
        QuitButton.setTitle("signout".localized.uppercased(), for: UIControlState.normal)
        QuitButton.addTarget(self, action: #selector(QuitButtonPressed), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeMenuItemsView), name: NSNotification.Name(rawValue: "removeMenuItemsView"), object: nil)
        
        scrollView.addSubview(QuitButton)
        
        scrollView.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height: QuitButton.frame.origin.y+QuitButton.frame.size.height+30)
        
        view.addSubview(scrollView)
        return view
    }
    
    func SetupScannerButtonClicked(sender: UIButton!) {
        AppDelegate.IsUSerINMainView=false
        self.removeMenuItemsView()
        DelegetInstance.LunshViewController()
    }
    
    @objc func containerButtonClicked(sender: UIButton!) {
        UserDefaultsManager().RemoveContainerID()
        self.removeMenuItemsView()
        AppDelegate.getDelegate().RemoveContainerView()
        AppDelegate.getDelegate().CheckForViews()
    }
    
    @objc func flightButtonClicked(sender: UIButton!) {
        UserDefaultsManager().removeFlightInformation()
        self.removeMenuItemsView()
        AppDelegate.getDelegate().RemoveFligthAirPlaneInformationView()
        AppDelegate.getDelegate().CheckForViews()
    }
    
    @objc func trackingPointButtonClicked(sender: UIButton!) {
        UserDefaultsManager().RemoveTrackingLocation()
        UserDefaultsManager().RemoveTrackingPointRaw()
        UserDefaultsManager().RemoveTrackingPointValidityUntil()
        UserDefaultsManager().RemoveContainerID()
        UserDefaultsManager().removeFlightInformation()
        self.removeMenuItemsView()
        AppDelegate.getDelegate().UpdateLocationOnAppHeader(seconds:0, trackingLocation:"")
        AppDelegate.getDelegate().RemoveContainerView()
        AppDelegate.getDelegate().RemoveFligthAirPlaneInformationView()
        AppDelegate.getDelegate().CheckForViews()
    }
    
    @objc func QuitButtonPressed(sender: UIButton!) {
        
        let dictionary = UserDefaultsManager().getLoginInfo()
        let response = UserDefaultsManager().getLoginResponse()
        
        var body = "{"
        body = body.appending("\"")
        body = body.appending("user_id")
        body = body.appending("\"")
        body = body.appending(":")
        body = body.appending("\"")
        body = body.appending(dictionary["userID"]! as! String)
        body = body.appending("\"")
        body = body.appending(",")
        
        body = body.appending("\"")
        body = body.appending("company_id")
        body = body.appending("\"")
        body = body.appending(":")
        body = body.appending("\"")
        body = body.appending(dictionary["companyID"]! as! String)
        body = body.appending("\"")
        body = body.appending(",")
        
        body = body.appending("\"")
        body = body.appending("api_key")
        body = body.appending("\"")
        body = body.appending(":")
        body = body.appending("\"")
        body = body.appending(response.value(forKey:"api_key") as! String)
        body = body.appending("\"")
        body = body.appending("}")
        
        let stringToPost = String(format: "request=%@",body)
        let url = Constants.BagJourneyHost+Constants.LogOutEndPoint as NSString
        
        AppDelegate.getDelegate().ShowLoaderIndicatorView()
        
        let ApiCall = ApiCallSwift()
        ApiCall.getResponseForURL(builtURL:url, JsonToPost:stringToPost as NSString, isAuthenticationRequired:false, method: "POST", errorTitle: "", optionalValue:"") { (builtURL, response, statusCode, data, error) in
            AppDelegate.getDelegate().hideLoadingIndicatorView()
//            if (statusCode == 200 && response.value(forKey: "success") as! Bool){
                // remove from UserDefaults login response, select_airport, and select_airline and password
//            if (statusCode != 0 && statusCode != 1 && statusCode != -1 && statusCode != 1234567890){
                UserDefaultsManager().SignOut()
                AppDelegate.vc.ConnectivityView.IsLoggingIn = false
                self.removeMenuItemsView()
                
                AppDelegate.IsUSerINMainView=false
                AppDelegate.vc.MainViewControllerPointer.RemoveOfflineScannerView()
                AppDelegate.vc.MainViewControllerPointer.removeBannerView()

                AppDelegate.vc.MainViewControllerPointer.RemoveFligthAirPlaneInformationView()
                AppDelegate.vc.MainViewControllerPointer.RemoveContainerView()

                MainViewController.AppHeaderInstance.view.removeFromSuperview()
                self.DelegetInstance.ReturnToLogin()
                AppDelegate.getDelegate().tokenExpiryTimer.invalidate()
            
//            } else {
//                self.LogInFailedView=UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:Constants.UIScreenMainHeight))
//                self.LogInFailedView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6)
//                let currentView = GetSimpleDialogView(LabelText:"Network_Connection_Issue".localized, Image: false, Y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/8))
//                self.LogInFailedView.addSubview(currentView)
//                AppDelegate.getDelegate().window?.addSubview(self.LogInFailedView)
//                _ = Timer.scheduledTimer(timeInterval:1.5, target: self, selector: #selector(self.RemoveLogInFailedView), userInfo: nil, repeats: false)
//            }
        }
    }
    
    @objc func ChangePasswordPressed(sender: UIButton!) {
        AppDelegate.getDelegate().doCloseMenuView()
        AppDelegate.getDelegate().doClose()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowChangePasswordView"), object: nil)
    }
    
    @objc func RestartButtonPressed(sender: UIButton!) {
        
        AppDelegate.getDelegate().doClose()
        AppDelegate.getDelegate().doCloseMenuView()
        
        UserDefaultsManager().RemoveTrackingLocation()
        UserDefaultsManager().RemoveTrackingPointRaw()
        UserDefaultsManager().RemoveTrackingPointValidityUntil()
        UserDefaultsManager().RemoveContainerID()
        UserDefaultsManager().removeFlightInformation()
        
        let loginRes = UserDefaultsManager().getLoginResponse()
        let Airlines = (loginRes["airlines"] as! String).components(separatedBy: ",")
        let Airports = (loginRes["airports"] as! String).components(separatedBy: ",")
        
        if (Airports.count>1){
            UserDefaults.standard.removeObject(forKey: "selected_airport")
        }
        if (Airlines.count>1){
            UserDefaults.standard.removeObject(forKey: "selected_airline")
        }
        
        AppDelegate.nav.popToRootViewController(animated: false)
        AppDelegate.vc.navigationManager()
    }
    
    
    func RemoveLogInFailedView() {
        if LogInFailedView != nil {
            LogInFailedView.removeFromSuperview()
            LogInFailedView=nil
        }
    }
    
    @objc func CancelButton(sender: UIButton!) {
        UserDefaultsManager().removeFlightInformation()
        UserDefaultsManager().RemoveContainerID()
        UserDefaultsManager().RemoveTrackingPointRaw()
        AppDelegate.vc.ConnectivityView.IsLoggingIn=false
        AppDelegate.IsUSerINMainView=false
        AppDelegate.getDelegate().CancelButton()
    }

    func aboutButtonClicked(sender: UIButton!) {
        self.view.addSubview(getCreditsView())
    }
    
    func getCreditsView() -> UIView {
        let screen=UIScreen.main.bounds
        creditsView=UIView(frame: CGRect(x:0, y:0, width:screen.width, height:screen.height))
        creditsView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.8)
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        let version = nsObject as! String
        let nsObject2: AnyObject? = Bundle.main.infoDictionary?["CFBundleVersion"] as? String as AnyObject?
        let build = nsObject2 as! String
        var deviceFirmwareVersion = ""
        var BatteryLevel = ""
        
        if (UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            if (AppDelegate.COGNEX_FIRMWARE_VERSION != ""){
                deviceFirmwareVersion = String (format: "\nCOGNEX firmware v%@",AppDelegate.COGNEX_FIRMWARE_VERSION)
            }
            if(AppDelegate.COGNEX_BATTERY_LEVEL != ""){
                BatteryLevel = String (format: "\nBattery charge : %@ %%",AppDelegate.COGNEX_BATTERY_LEVEL)
            }
        }else if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if AppDelegate.SOCKET_FIRMWARE_VERSION != "" {
                deviceFirmwareVersion = String (format: "\nSocketMobile firmware v%@",AppDelegate.SOCKET_FIRMWARE_VERSION)
            }
            if AppDelegate.SOCKET_BATTERY_LEVEL != ""{
                BatteryLevel = String (format: "\nBattery charge : %@ %%",AppDelegate.SOCKET_BATTERY_LEVEL)
            }
        }
        
        let aStr = String(format: "%@(%@)%@%@", version, build,deviceFirmwareVersion,BatteryLevel)
        infiniteTextView.frame = CGRect(x:0, y:0, width:screen.width, height:screen.height)
        infiniteTextView.text = String(format: "creditsText".localized, aStr)
        infiniteTextView.backgroundColor = UIColor.clear
        infiniteTextView.textColor = UIColor.white
        infiniteTextView.isUserInteractionEnabled = true
        infiniteTextView.font=UIFont.boldSystemFont(ofSize: 18.0)
        infiniteTextView.textAlignment = NSTextAlignment.center
        infiniteTextView.contentOffset = CGPoint(x:0, y:0)
        infiniteTextView.contentOffset = CGPoint(x:0, y:-(screen.size.height)*2/3)
        creditsView.addSubview(infiniteTextView)
        let emptyView=UIView(frame: CGRect(x:0, y:0, width:screen.width, height:screen.height))
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeCreditsView))
        emptyView.addGestureRecognizer(tap)
        creditsView.addSubview(emptyView)
        let sizeOfString = infiniteTextView.text.boundingRect(
            with: CGSize(width:screen.size.width, height:CGFloat.infinity),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSFontAttributeName: infiniteTextView.font!],
            context: nil).size
        textHeight = sizeOfString.height
        print("------------------")
        flag = true
        animate()
        return creditsView
    }
    
    @objc func removeMenuItemsView() {
        flag = false
        self.view.removeFromSuperview()
        AppDelegate.getDelegate().doCloseMenuView()
        AppDelegate.getDelegate().ScanManagerReturnFromBackground()
    }
    
    @objc func removeCreditsView() {
        flag = false
        if creditsView != nil{
            self.creditsView.removeFromSuperview()
        }
    }
    
    func animate(){
        let screen=UIScreen.main.bounds
        if self.infiniteTextView.contentOffset.y > textHeight {
            self.infiniteTextView.contentOffset = CGPoint(x:0, y:-screen.size.height+10)
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.infiniteTextView.contentOffset = CGPoint(x:0, y:self.infiniteTextView.contentOffset.y + 10)
        }, completion: { finished in
            DispatchQueue.main.async {
                if self.flag {
                    self.animate()
                }
            }
        })
    }
}

