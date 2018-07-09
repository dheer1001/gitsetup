//
//  AppHeaderViewController.swift
//  NetSCAN
//
//  Created by Developer on 9/15/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit

class AppHeaderViewController: UIViewController {
    
    @IBOutlet weak var ConnectView: UIView!
    @IBOutlet weak var ConnectImage: UIImageView!
    @IBOutlet weak var ConnectLabel: UILabel!
    @IBOutlet weak var LocationView: UIView!
    @IBOutlet weak var LocationImage: UIImageView!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var LocationTimer: UILabel!
    @IBOutlet weak var InternetView: UIView!
    @IBOutlet weak var InternetImage: UIImageView!
    @IBOutlet weak var InternetLabel: UILabel!
    
    var batteryChargeLevel : UIView!
    var timer = 0
    var newView: UIView!
    var AirportLabel : UILabel!
    var AirlineLabel : UILabel!
    var tapToSelectLabel: UILabel!
    var noTrackingConfigured: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden=true
        let screenSize: CGRect = UIScreen.main.bounds
        self.view.frame = CGRect(x:0, y:UIApplication.shared.statusBarFrame.height, width:screenSize.width, height:screenSize.height)
        self.view.backgroundColor=primaryColor()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor.yellow.cgColor as CGColor
        let color2 = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0).cgColor as CGColor
        let color3 = UIColor.clear.cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3]
        gradientLayer.locations = [0.0, 0.33, 0.66]
        ConnectView.frame = CGRect(x:0, y:0, width:screenSize.width/3, height:screenSize.width/15+30)
        LocationView.frame = CGRect(x:ConnectView.frame.origin.x + ConnectView.frame.size.width, y:0, width:screenSize.width/3, height:screenSize.width/12+73)
        InternetView.frame = CGRect(x:LocationView.frame.origin.x + LocationView.frame.size.width, y:0 , width:screenSize.width/3, height:screenSize.width/15+30)
        ConnectImage.frame = CGRect(x:8, y:15, width:ConnectView.frame.size.width/5 , height:ConnectView.frame.size.width/5)
        LocationImage.frame = CGRect(x:LocationView.frame.size.width/2-LocationView.frame.size.width/8, y:15, width:LocationView.frame.size.width/4 , height:LocationView.frame.size.width/4)
        InternetImage.frame = CGRect(x:InternetView.frame.size.width-8-InternetView.frame.size.width/5, y:15, width:InternetView.frame.size.width/5 , height:InternetView.frame.size.width/5)
        ConnectLabel.frame = CGRect(x:ConnectImage.frame.origin.x+ConnectImage.frame.size.width, y:0, width:ConnectView.frame.size.width-(ConnectImage.frame.origin.x+ConnectImage.frame.size.width), height:ConnectView.frame.size.height)
        LocationLabel.frame = CGRect(x:0, y:LocationImage.frame.origin.y+LocationImage.frame.size.height, width:LocationView.frame.size.width , height:21)
        LocationTimer.frame = CGRect(x:15, y:LocationLabel.frame.origin.y+LocationLabel.frame.size.height+5, width:LocationView.frame.size.width-30 , height:21)
        InternetLabel.frame = CGRect(x:0, y:0, width:InternetView.frame.size.width-InternetImage.frame.size.width-23 , height:InternetView.frame.size.height)
        ConnectView.backgroundColor = AppHeaderBackgroundColor()
        LocationView.backgroundColor = AppHeaderBackgroundColor()
        InternetView.backgroundColor = AppHeaderBackgroundColor()
        ConnectView.layer.borderWidth = 1
        ConnectView.layer.borderColor = PrimaryBoarder().cgColor
        LocationView.layer.borderWidth = 1
        LocationView.layer.borderColor = PrimaryBoarder().cgColor
        InternetView.layer.borderWidth = 1
        InternetView.layer.borderColor = PrimaryBoarder().cgColor
        
        if (UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized) {
            ConnectLabel.text = "softScanTabToScan".localized
            ConnectLabel.textColor = TextColorGray()
            ConnectLabel.adjustsFontSizeToFitWidth = true
            ConnectLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            ConnectLabel.numberOfLines = 2
        } else {
        ConnectLabel.text = "scannerDisConnected".localized
        ConnectLabel.textColor = GetColorFromHex(rgbValue: UInt32(Constants.TextColorRed))
        ConnectLabel.adjustsFontSizeToFitWidth = true
        ConnectLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        ConnectLabel.numberOfLines = 0
    }
        
        LocationLabel.text = ""
        LocationLabel.textColor = TextColorGray()
        LocationLabel.adjustsFontSizeToFitWidth = true
        LocationLabel.textAlignment = NSTextAlignment.center
        
        LocationTimer.text = ""
        LocationTimer.textColor = OrangeColorInverted()
        LocationTimer.adjustsFontSizeToFitWidth = true
        LocationTimer.textAlignment = NSTextAlignment.center
        LocationTimer.font = UIFont(name: "DS-Digital", size: 25)
        
        
        tapToSelectLabel = UILabel(frame:CGRect(x: 0, y: 0, width: LocationView.frame.size.width, height: LocationView.frame.size.height))
        tapToSelectLabel.text = "tap_to_select_tracking_ponit".localized
        tapToSelectLabel.textColor = OrangeColorInverted()
        tapToSelectLabel.adjustsFontSizeToFitWidth = true
        tapToSelectLabel.numberOfLines = 4
        tapToSelectLabel.textAlignment = NSTextAlignment.center
        
        noTrackingConfigured = UILabel(frame:CGRect(x:2, y: 0, width: LocationView.frame.size.width-4, height: LocationView.frame.size.height))
        noTrackingConfigured.text = "no_tracking_points_configured".localized
        noTrackingConfigured.textColor = OrangeColorInverted()
        noTrackingConfigured.adjustsFontSizeToFitWidth = true
        noTrackingConfigured.numberOfLines = 5
        noTrackingConfigured.textAlignment = NSTextAlignment.center
        
        if (UserDefaults.standard.value(forKey: "selected_airport") != nil &&
            ScanManager.LocalStorage.getTrackingConfigurationFor(airportCode: UserDefaults.standard.value(forKey: "selected_airport") as! String) != nil && (ScanManager.LocalStorage.GetTrackingLocation() == "" || AppDelegate.getDelegate().ScanManagerInstance.IsStillValidTrackingLocation() == false)) {
            tapToSelectLabel.isHidden = false
            noTrackingConfigured.isHidden = true
        } else {
            tapToSelectLabel.isHidden = true
            noTrackingConfigured.isHidden = false
        }
        LocationView.addSubview(noTrackingConfigured)
        LocationView.addSubview(tapToSelectLabel)
        
        InternetLabel.text = "networkOffline".localized
        InternetLabel.textColor = GetColorFromHex(rgbValue: UInt32(Constants.TextColorRed))
        InternetLabel.adjustsFontSizeToFitWidth = true
        InternetLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        InternetLabel.numberOfLines = 0
        
        ConnectImage.contentMode = UIViewContentMode.scaleAspectFit
        
        var scannerImage = UIImage(named: "bar-code-scanner.png")
        var tintColorForConnecImageView = GetColorFromHex(rgbValue: UInt32(Constants.TextColorRed))
        if (UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized) {
            scannerImage = UIImage(named: "d31e17660f180ac23ebca230f505317c.png")
            tintColorForConnecImageView = TextColorGray()
        }
        
        ConnectImage.image = scannerImage!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ConnectImage.tintColor = tintColorForConnecImageView
        
        LocationImage.isHidden = true
        LocationImage.image = LocationImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        LocationImage.tintColor = UIColor.lightGray
        LocationImage.tintColor = TextColorGray()
        InternetImage.contentMode = UIViewContentMode.scaleAspectFit // ScaleAspectFit ScaleAspectFill ScaleToFill
        InternetImage.image = InternetImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        InternetImage.tintColor = GetColorFromHex(rgbValue: UInt32(Constants.TextColorRed))
        
        fireBatteryLevelUpdating()
        
        self.view.addSubview(GetAirlinesView(frame: CGRect(x:(LocationView.frame.origin.x+LocationView.frame.size.width), y: ConnectView.frame.size.height, width:screenSize.size.width-(LocationView.frame.origin.x+LocationView.frame.size.width), height:LocationView.frame.size.height-ConnectView.frame.size.height)))
        
        self.view.addSubview(GetAirportsView(frame: CGRect(x:0, y: ConnectView.frame.size.height, width:LocationView.frame.origin.x, height:LocationView.frame.size.height-ConnectView.frame.size.height)))
        
        NotificationCenter.default.addObserver(self,selector:#selector(DidAirlineAirportLabelChange),name:NSNotification.Name(rawValue: "DidAirlineAirportLabelChange"),object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Menu")
        let builder = GAIDictionaryBuilder.createScreenView()
        let dictionary = (builder?.build())! as NSMutableDictionary
        tracker?.send(dictionary as [NSObject: AnyObject]!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func selectTrackingPointPressed() {
        
        if UserDefaults.standard.value(forKey: "selected_airport") != nil &&
            ScanManager.LocalStorage.getTrackingConfigurationFor(airportCode: UserDefaults.standard.value(forKey: "selected_airport") as! String) != nil {
            AppDelegate.getDelegate().doClose()
            
            let loginInfo = UserDefaultsManager().getLoginInfo() as NSDictionary
            let responseDic = UserDefaultsManager().getLoginResponse()
            
            let selectTrackingConfig = SelectTrackingConfigurationView()
            selectTrackingConfig.Service_ID = (responseDic["service_id"] as! String)
            selectTrackingConfig.User_ID = loginInfo.value(forKey: "userID") as! String
            AppDelegate.vc.ConnectivityView.navigationController?.pushViewController(selectTrackingConfig, animated: false)
        }
    }
    
    func GetAirlinesView(frame:CGRect) -> UIView {
        
        let responseDic = UserDefaultsManager().getLoginResponse()
        var Airlines : Array<String>!

        if (responseDic["airlines"] != nil){
        Airlines = (responseDic["airlines"] as! String).components(separatedBy: ",")
        }
        
        let AirlineView = UIView(frame:frame)
        
        let AirlineImageView = UIImageView(frame: CGRect(x:frame.size.height/4, y:frame.size.height/4, width: frame.size.height/2, height: frame.size.height/2))
        AirlineImageView.image=UIImage(named: "airline.png")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        AirlineLabel = UILabel(frame: CGRect(x:AirlineImageView.frame.size.width, y:(frame.height/2)-15, width: frame.width-AirlineImageView.frame.size.width-10, height: 30))
        
        if ((UserDefaults.standard.value(forKey: "selected_airline")) != nil){
            AirlineLabel.text=(UserDefaults.standard.value(forKey: "selected_airline") as! String)
        }
        
        AirlineLabel.textAlignment=NSTextAlignment.right
        AirlineLabel.font=UIFont.systemFont(ofSize: 20)
        
        AirlineView.addSubview(AirlineLabel)
        AirlineView.addSubview(AirlineImageView)
        
        if (Airlines != nil) && Airlines.count>1 {
            AirlineLabel.textColor=secondaryColor()
            AirlineImageView.tintColor=secondaryColor()
        } else {
            AirlineLabel.textColor=PrimaryGrayColor()
            AirlineImageView.tintColor=PrimaryGrayColor()
        }
        return AirlineView
    }
    
    func GetAirportsView(frame:CGRect) -> UIView {
        
        let responseDic = UserDefaultsManager().getLoginResponse()
        var Airports : Array<String>!
        
        if (responseDic["airlines"] != nil){
            Airports = (responseDic["airports"] as! String).components(separatedBy: ",")
        }
        
        let AirportView = UIView(frame:frame)
        
        let AirportImageView = UIImageView(frame: CGRect(x:frame.size.width-(3*frame.size.height/4), y:frame.size.height/4, width: frame.size.height/2, height: frame.size.height/2))
        AirportImageView.image=UIImage(named: "airport2.png")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        
        AirportLabel = UILabel(frame: CGRect(x:10, y:(frame.height/2)-15, width:frame.width-AirportImageView.frame.size.width-10, height: 30))
        if ((UserDefaults.standard.value(forKey: "selected_airport")) != nil){
            AirportLabel.text=(UserDefaults.standard.value(forKey: "selected_airport") as! String)
        }
        AirportLabel.textAlignment=NSTextAlignment.left
        AirportLabel.font=UIFont.systemFont(ofSize: 20)
        
        AirportView.addSubview(AirportLabel)
        AirportView.addSubview(AirportImageView)
        
        if (Airports != nil) && Airports.count>1 {
            AirportLabel.textColor=secondaryColor()
            AirportImageView.tintColor=secondaryColor()
        } else {
            AirportLabel.textColor=PrimaryGrayColor()
            AirportImageView.tintColor=PrimaryGrayColor()
        }
        return AirportView
    }
    
    func AirlinesTapped() {
        
        let loginInfo = UserDefaultsManager().getLoginInfo() as NSDictionary
        let responseDic = UserDefaultsManager().getLoginResponse()
        let Airlines = (responseDic["airlines"] as! String).components(separatedBy: ",")
        
        if  Airlines.count>1 {
            let AirlinesView = SelectAirlineView()
            AirlinesView.Airlines = Airlines as NSArray
            AirlinesView.Service_ID = (responseDic["service_id"] as! String)
            AirlinesView.User_ID = loginInfo.value(forKey: "userID") as! String
            AirlinesView.ReturnToMain = true
            AirlinesView.ShowTrackingIdentifier=false
            AppDelegate.getDelegate().doClose()
            AppDelegate.vc.ConnectivityView.navigationController?.pushViewController(AirlinesView, animated: false)
        }
    }
    
    func AirportsTapped() {
        
        let loginInfo = UserDefaultsManager().getLoginInfo() as NSDictionary
        let responseDic = UserDefaultsManager().getLoginResponse()
        let Airports = (responseDic["airports"] as! String).components(separatedBy: ",")
        
        if  Airports.count>1 {
            let airportsView = SelectAirportView()
            airportsView.Airports = Airports as NSArray
            airportsView.Service_ID = (responseDic["service_id"] as! String)
            airportsView.User_ID = loginInfo.value(forKey: "userID") as! String
            airportsView.ReturnToMain = true
            AppDelegate.getDelegate().doClose()
            AppDelegate.vc.ConnectivityView.navigationController?.pushViewController(airportsView, animated: false)
        }
    }
    
    func DidAirlineAirportLabelChange() {
        if ((UserDefaults.standard.value(forKey: "selected_airport")) != nil){
            if (AirportLabel != nil){
                AirportLabel.text=(UserDefaults.standard.value(forKey: "selected_airport") as! String)
                AirportLabel.setNeedsDisplay()}
        }
        if ((UserDefaults.standard.value(forKey: "selected_airline")) != nil){
            if(AirlineLabel != nil){
                AirlineLabel.text=(UserDefaults.standard.value(forKey: "selected_airline") as! String)
                AirlineLabel.setNeedsDisplay()
            }
        }
    }
    
    func PresentAirlineWithTrackingIdentifier() {
        let loginInfo = UserDefaultsManager().getLoginInfo() as NSDictionary
        let responseDic = UserDefaultsManager().getLoginResponse()
        let Airlines = (responseDic["airlines"] as! String).components(separatedBy: ",")
        let AirlinesView = SelectAirlineView()
        AirlinesView.Airlines = Airlines as NSArray
        AirlinesView.Service_ID = (responseDic["service_id"] as! String)
        AirlinesView.User_ID = loginInfo.value(forKey: "userID") as! String
        AirlinesView.ReturnToMain = true
        AirlinesView.ShowTrackingIdentifier=true
        AppDelegate.vc.navigationController?.pushViewController(AirlinesView, animated: false)
    }
    
    func countdown() {
        if(timer > 0){
            let minutes = String(timer / 60)
            let seconds = String(timer % 60)
            LocationTimer.text = minutes + ":" + seconds
            LocationTimer.text = String(format:"%02d:%02d", Int(timer/60),  Int(timer%60) )
            timer -= 1
        } else {
            LocationTimer.text = ""
            LocationLabel.text = ""
            LocationImage.isHidden = true
            
            if (UserDefaults.standard.value(forKey: "selected_airport") != nil &&
                ScanManager.LocalStorage.getTrackingConfigurationFor(airportCode: UserDefaults.standard.value(forKey: "selected_airport") as! String) != nil && (ScanManager.LocalStorage.GetTrackingLocation() == "" || AppDelegate.getDelegate().ScanManagerInstance.IsStillValidTrackingLocation() == false)) {
                tapToSelectLabel.isHidden = false
                noTrackingConfigured.isHidden = true
            } else {
                tapToSelectLabel.isHidden = true
                noTrackingConfigured.isHidden = false
            }

            AppDelegate.trackingLocationClock.invalidate()
            ScanManager.LocalStorage.RemoveTrackingLocation()
            ScanManager.LocalStorage.RemoveTrackingPointValidityUntil()
            AppDelegate.getDelegate().CheckForViews()
            if AppDelegate.BINGO_INFO || UserDefaults.standard.value(forKey:"bingo") != nil {
                UserDefaults.standard.removeObject(forKey: "bingo")
                ScanManager.LocalStorage.removeFlightInformation()
                ScanManager.LocalStorage.RemoveTrackingLocation()
                ScanManager.LocalStorage.RemoveTrackingPointRaw()
                ScanManager.LocalStorage.RemoveTrackingPointValidityUntil()
                AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func scannerDisconnected() {
        if ConnectLabel != nil {
            if (UserDefaults.standard.string(forKey: "scannerType") != "softScanner".localized){
                ConnectLabel.text = "scannerDisConnected".localized
                ConnectLabel.textColor = GetColorFromHex(rgbValue: UInt32(Constants.TextColorRed))
                ConnectImage.image = ConnectImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                ConnectImage.tintColor = GetColorFromHex(rgbValue: UInt32(Constants.TextColorRed))
            }
        }
    }
    
    func scannerConnected() {
        if (UserDefaults.standard.string(forKey: "scannerType") != "softScanner".localized){
            if ConnectLabel != nil {
                ConnectLabel.text = "scannerConnected".localized
                ConnectLabel.textColor = TextColorGray()
            }
            if ConnectImage != nil {
                ConnectImage.image = ConnectImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                ConnectImage.tintColor = TextColorGray()
            }
        }
    }
    
    func internetOffline() {
        InternetLabel.text = "networkOffline".localized
        InternetLabel.textColor = GetColorFromHex(rgbValue: UInt32(Constants.TextColorRed))
        InternetImage.image = UIImage(named: "Signal_Off")!
        InternetImage.image = InternetImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        InternetImage.tintColor = GetColorFromHex(rgbValue: UInt32(Constants.TextColorRed))
    }
    
    func internetOnline() {
        InternetLabel.text = "networkOnline".localized
        InternetLabel.textColor = TextColorGray()
        InternetImage.image = UIImage(named: "Signal_On")!
        InternetImage.image = InternetImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        InternetImage.tintColor = TextColorGray()
    }
    
    func fireBatteryLevelUpdating(){
        if(UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            if AppDelegate.vc.ConnectivityView.CognexManager != nil {
                AppDelegate.vc.ConnectivityView.CognexManager.GetBatteryLevel()
            }
        } else if(UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if AppDelegate.vc.ConnectivityView.SocketMobile != nil {
                AppDelegate.vc.ConnectivityView.SocketMobile.GetBatteryLevel()
            }
        }
        _ = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(fireBatteryLevelUpdating), userInfo: nil, repeats: false)
    }
    
    func updateBatteryLevel() {
        if (batteryChargeLevel != nil){
            batteryChargeLevel.removeFromSuperview()
        }
        if ConnectLabel != nil {
            batteryChargeLevel = getBatteryLevelView(frame: CGRect(x: ConnectLabel.frame.origin.x, y:ConnectLabel.frame.size.height*0.8, width:ConnectLabel.frame.size.width, height:10))
            if batteryChargeLevel != nil {
                self.view.addSubview(batteryChargeLevel)
                self.view.setNeedsDisplay()
            }
        }
    }
    
    func getBatteryLevelView(frame:CGRect) -> UIView! {
        
        if AppDelegate.COGNEX_BATTERY_LEVEL != "" || AppDelegate.SOCKET_BATTERY_LEVEL != "" {
            
            let stringSize = (ConnectLabel.text?.widthOfString(usingFont: ConnectLabel.font!))!
            var batterylevelInt = 0
//            let IsCharging = false
            let batteryView = UIView(frame:frame)
            let marginOfChargeView = (frame.size.width-stringSize)/2
            if AppDelegate.COGNEX_BATTERY_LEVEL != "" {
                batterylevelInt = Int(AppDelegate.COGNEX_BATTERY_LEVEL)!
            } else if AppDelegate.SOCKET_BATTERY_LEVEL != ""{
                batterylevelInt = Int(AppDelegate.SOCKET_BATTERY_LEVEL)!
            }
            
//            if IsCharging {
//                let imageView = UIImageView(frame: CGRect(x:0,y:0, width:(marginOfChargeView/3)*2, height:(marginOfChargeView/3)*2))
//                imageView.image=UIImage(named: "electricitySignFull.png")!.withRenderingMode(.alwaysTemplate)
//                imageView.tintColor=secondaryColor()
//                batteryView.addSubview(imageView)
//            }
            
            let dashWidth = (stringSize/5)
            var dachesDeff = CGFloat(1)
            
            let dash1 = UIView(frame:CGRect(x:dachesDeff, y:0, width: dashWidth-2, height: 5))
            dachesDeff += dash1.frame.size.width+2
            
            let dash2 = UIView(frame:CGRect(x:dachesDeff, y:0, width: dashWidth-2, height: 5))
            dachesDeff += dash2.frame.size.width+2
            
            let dash3 = UIView(frame:CGRect(x:dachesDeff, y:0, width: dashWidth-2, height: 5))
            dachesDeff += dash3.frame.size.width+2
            
            let dash4 = UIView(frame:CGRect(x:dachesDeff, y:0, width: dashWidth-2, height: 5))
            dachesDeff += dash4.frame.size.width+2
            
            let dash5 = UIView(frame:CGRect(x:dachesDeff, y:0, width: dashWidth-2, height: 5))
            dachesDeff += dash5.frame.size.width+2
            
            if batterylevelInt > 80 { // 81 -> 100
                dash1.backgroundColor=UIColor.green
                dash2.backgroundColor=UIColor.green
                dash3.backgroundColor=UIColor.green
                dash4.backgroundColor=UIColor.green
                dash5.backgroundColor=UIColor.green
            }
            else if batterylevelInt > 60 { // 61 -> 80
                dash1.backgroundColor=UIColor.green
                dash2.backgroundColor=UIColor.green
                dash3.backgroundColor=UIColor.green
                dash4.backgroundColor=UIColor.green
                dash5.backgroundColor=PrimaryGrayColor()
            }
            else if batterylevelInt > 40 { // 41 -> 60
                dash1.backgroundColor=UIColor.orange
                dash2.backgroundColor=UIColor.orange
                dash3.backgroundColor=UIColor.orange
                dash4.backgroundColor=PrimaryGrayColor()
                dash5.backgroundColor=PrimaryGrayColor()
            }
            else if batterylevelInt > 20 { // 21 - > 40
                dash1.backgroundColor=UIColor.red
                dash2.backgroundColor=UIColor.red
                dash3.backgroundColor=PrimaryGrayColor()
                dash4.backgroundColor=PrimaryGrayColor()
                dash5.backgroundColor=PrimaryGrayColor()
            }
            else {                         // 0  -> 20
                dash1.backgroundColor=UIColor.red
                dash2.backgroundColor=PrimaryGrayColor()
                dash3.backgroundColor=PrimaryGrayColor()
                dash4.backgroundColor=PrimaryGrayColor()
                dash5.backgroundColor=PrimaryGrayColor()
            }
            
            let dachesLineView = UIView(frame: CGRect(x:marginOfChargeView, y: 0, width: stringSize, height: 10))
            
            dachesLineView.addSubview(dash1)
            dachesLineView.addSubview(dash2)
            dachesLineView.addSubview(dash3)
            dachesLineView.addSubview(dash4)
            dachesLineView.addSubview(dash5)
            
            batteryView.addSubview(dachesLineView)
            return batteryView
        } else {
            return nil
        }
    }
    
    func exampleSetLocation(){
        SetLocation(location: "Beirut")
    }
    
    func exampleStartCountDownTimer(){
        StartCountDownTimer(seconds: 75)
    }
    
    func SetLocation(location: String){
        if location != "" {
            tapToSelectLabel.isHidden = true
            noTrackingConfigured.isHidden = true
            LocationImage.isHidden = false
        } else {
            LocationImage.isHidden = true
            
            if (UserDefaults.standard.value(forKey: "selected_airport") != nil &&
                ScanManager.LocalStorage.getTrackingConfigurationFor(airportCode: UserDefaults.standard.value(forKey: "selected_airport") as! String) != nil && (ScanManager.LocalStorage.GetTrackingLocation() == "" || AppDelegate.getDelegate().ScanManagerInstance.IsStillValidTrackingLocation() == false)) {
                tapToSelectLabel.isHidden = false
                noTrackingConfigured.isHidden = true
            } else {
                tapToSelectLabel.isHidden = true
                noTrackingConfigured.isHidden = false
            }
            
        }
        LocationLabel.text = location
    }
    
    func FlightDataView(){
        let screen=UIScreen.main.bounds
        let v = InformationView.init(frame: CGRect(x:15,y:screen.height/2-165,width:screen.width-30,height:330),bagView: true, bagNumber: "1234",Unknownbag:"")
        v.tag = 100
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeSubview))
        view.addGestureRecognizer(tap)
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        for view in self.view.subviews {
            view.isUserInteractionEnabled = false
        }
        self.view.addSubview(v)
    }
    
    func StartCountDownTimer(seconds: Int){
        timer = seconds
        AppDelegate.trackingLocationClock.invalidate()
        AppDelegate.trackingLocationClock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
            AppDelegate.trackingLocationClock.fire()
    }
    
    func removeSubview(){
        print("Start remove subview")
        if let viewWithTag = self.view.viewWithTag(100) {
            print("Yes!")
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        for view in self.view.subviews {
            view.isUserInteractionEnabled = true
        }
    }
}
