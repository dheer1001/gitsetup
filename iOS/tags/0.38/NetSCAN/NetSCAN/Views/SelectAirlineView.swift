//
//  SelectAirlineView.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 10/12/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class SelectAirlineView: UIViewController {
    
    var Airlines:NSArray!
    var Service_ID:String!
    var User_ID:String!
    var ReturnToMain:Bool!
    var ShowTrackingIdentifier = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden=true
        AppDelegate.IsUSerINMainView=false
        self.view.backgroundColor=primaryColor()
        LoadComponents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func LoadComponents() {
        
        let screenWidth:CGFloat = UIScreen.main.bounds.size.width
        let screenHeight:CGFloat = Constants.UIScreenMainHeight
        var startY:CGFloat = 60
        
        if (ShowTrackingIdentifier){
            self.view.addSubview(GetTrackingIdentifierView(screen:UIScreen.main.bounds))
            startY = 215
        }
        else{
            let WelcomeLabel = UILabel(frame:CGRect(x: 10, y: startY, width: screenWidth-20, height: 30))
            WelcomeLabel.text="welcome".localized
            WelcomeLabel.font=UIFont.systemFont(ofSize: 15)
            WelcomeLabel.textColor=secondaryColor()
            WelcomeLabel.textAlignment=NSTextAlignment.center
            startY += WelcomeLabel.frame.size.height+10
            
            let UserNameLabel = UILabel(frame: CGRect(x:20,y:startY,width:screenWidth-40, height:60))
            UserNameLabel.text=self.User_ID
            UserNameLabel.font=UIFont.systemFont(ofSize:20)
            UserNameLabel.adjustsFontSizeToFitWidth=true
            UserNameLabel.textColor=secondaryColor()
            UserNameLabel.textAlignment=NSTextAlignment.center
            startY += UserNameLabel.frame.size.height+10
            
            let UserIDLabel = UILabel(frame: CGRect(x:10,y:startY,width:screenWidth-20, height:30))
            UserIDLabel.text=self.Service_ID
            UserIDLabel.font=UIFont.systemFont(ofSize: 15)
            UserIDLabel.textColor=secondaryColor()
            UserIDLabel.textAlignment=NSTextAlignment.center
            startY += UserIDLabel.frame.size.height+15
            
            self.view.addSubview(WelcomeLabel)
            self.view.addSubview(UserNameLabel)
            self.view.addSubview(UserIDLabel)
        }
        
        let AirlineImageView = UIImageView(frame: CGRect(x: (screenWidth/2)-30, y: startY, width: 60, height: 60))
        AirlineImageView.image=UIImage(named: "airline")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        AirlineImageView.tintColor=secondaryColor()
        startY += AirlineImageView.frame.size.height+10
        
        let SelectAirlineLabel = UILabel(frame: CGRect(x:10,y:startY,width:screenWidth-20, height:30))
        SelectAirlineLabel.text="selectAirline".localized
        SelectAirlineLabel.font=UIFont.systemFont(ofSize: 15)
        SelectAirlineLabel.textColor=OrangeColorInverted()
        SelectAirlineLabel.textAlignment=NSTextAlignment.center
        startY += SelectAirlineLabel.frame.size.height+10
        
        let AirlinesMainView = UIView(frame: CGRect(x:0, y:startY, width:screenWidth, height:screenHeight-startY))
        AirlinesMainView.backgroundColor=QueueBackgroundColor()
        
        let AirlinesScrollView = UIScrollView(frame: CGRect(x:0, y:5, width:screenWidth, height:screenHeight-startY-5))
        if (Airlines != nil) && Airlines.count>0 {
            for i in 0  ..< Airlines.count {
                AirlinesScrollView.addSubview(GenerateAirportBox(AirlineCode:Airlines.object(at: i) as! String, screenWidth:screenWidth, screenHeight: screenHeight, boxesNumber:i))
            }
            
            var contentHeight = (screenWidth/2) * CGFloat(Airlines.count/2)
            if (Airlines.count%2 != 0){
                contentHeight = (screenWidth/2) * CGFloat((Airlines.count+1)/2)
            }
            
            AirlinesScrollView.contentSize=CGSize(width: screenWidth, height: contentHeight+10)
        }
        
        let HeaderImageView = UIImageView(frame: CGRect(x:3.5, y:0, width:screenWidth, height:(screenHeight/2.5)/7))
        HeaderImageView.image=QueueHeaderImage()
        startY += HeaderImageView.frame.size.height
        
        let HeaderCorrector = UIView(frame: CGRect(x:0, y:0,width:screenWidth/3, height:3.5))
        HeaderCorrector.backgroundColor=primaryColor()
        
        AirlinesMainView.addSubview(HeaderCorrector)
        AirlinesMainView.addSubview(HeaderImageView)
        AirlinesMainView.addSubview(AirlinesScrollView)
        
        self.view.addSubview(AirlineImageView)
        self.view.addSubview(SelectAirlineLabel)
        self.view.addSubview(AirlinesMainView)
    }
    
    
    func GetTrackingIdentifierView(screen:CGRect) -> UIView {
        let showLocationIdentifiedView=UIView(frame: CGRect(x:0,y:0,width:screen.width,height:200))
        let showLocationIdentifiedLabel=UILabel(frame: CGRect(x:10,y:25,width:showLocationIdentifiedView.frame.width-20,height:25))
        let showLocationIdentifiedImageView=UIImageView(frame: CGRect(x:showLocationIdentifiedView.frame.width/2-25,y:showLocationIdentifiedLabel.frame.origin.y+showLocationIdentifiedLabel.frame.height+10,width:50,height:50))
        let showshowLocationIdentifiedGatesLabel=UILabel(frame: CGRect(x:10,y:showLocationIdentifiedImageView.frame.origin.y+showLocationIdentifiedImageView.frame.height+10,width:showLocationIdentifiedView.frame.width-20,height:25))
        let showLocationIdentifiedTimeoutLabel=UILabel(frame: CGRect(x:10,y:showshowLocationIdentifiedGatesLabel.frame.origin.y+showshowLocationIdentifiedGatesLabel.frame.height+10,width:showLocationIdentifiedView.frame.width-20,height:25))
        let showLocationIdentifiedCountdownLabel=UILabel(frame: CGRect(x:10,y:showLocationIdentifiedTimeoutLabel.frame.origin.y+showLocationIdentifiedTimeoutLabel.frame.height+10,width:showLocationIdentifiedView.frame.width-20,height:25))
        showLocationIdentifiedView.backgroundColor=primaryColor()
        
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
        showshowLocationIdentifiedGatesLabel.text=AppDelegate.getDelegate().GetTrackingLocation(TrackingPoint: UserDefaultsManager().GetTrackingLocation())
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
    
    
    func GenerateAirportBox(AirlineCode:String,screenWidth:CGFloat,screenHeight:CGFloat,boxesNumber:Int) -> UIView {
        var startY:CGFloat = 0
        var startX:CGFloat = 0
        
        if(boxesNumber%2 != 0){
            startX = (screenWidth/2) + 30
            startY = ((CGFloat((Int(boxesNumber/2))) * (screenWidth/2))) + 60
        } else {
            startX = 30
            startY = ((CGFloat((Int(boxesNumber/2))) * (screenWidth/2))) + 60
        }
        if startY == 0 {
            startY = 55
        }
        
        let box = UIView(frame: CGRect(x:CGFloat(startX), y:startY, width:(screenWidth/2)-60, height: (screenWidth/2)-60))
        box.backgroundColor=AppHeaderBackgroundColor()
        box.layer.cornerRadius=5
        
        let AirlineCodeLabel = UILabel(frame: CGRect(x: 10, y:(box.frame.size.height/2)-15, width: box.frame.size.width-20, height: 30))
        AirlineCodeLabel.textAlignment=NSTextAlignment.center
        AirlineCodeLabel.text=AirlineCode
        AirlineCodeLabel.textColor=secondaryColor()
        box.addSubview(AirlineCodeLabel)
        
        let width = CGFloat(3.0)
        let border1 = CALayer()
        border1.borderColor = primaryColor().cgColor
        border1.frame = CGRect(x:0,y:0,width:width,height:box.frame.size.height)
        border1.borderWidth = width
        
        let border2 = CALayer()
        border2.borderColor = primaryColor().cgColor
        border2.frame = CGRect(x:0,y:0,width:box.frame.size.height,height:width)
        border2.borderWidth = width
        
        let border3 = CALayer()
        border3.borderColor = primaryColor().cgColor
        border3.frame = CGRect(x:0,y:box.frame.size.height-width,width:box.frame.size.height,height:width)
        border3.borderWidth = width
        
        let border4 = CALayer()
        border4.borderColor = primaryColor().cgColor
        border4.frame = CGRect(x:box.frame.width-width,y:0,width:width,height:box.frame.size.height)
        border4.borderWidth = width
        
        box.layer.addSublayer(border1)
        box.layer.addSublayer(border2)
        box.layer.addSublayer(border3)
        box.layer.addSublayer(border4)
        box.layer.masksToBounds = true
        
        let tabGesture = UITapGestureRecognizer(target: self, action:#selector(boxTapped(sender:)))
        box.addGestureRecognizer(tabGesture)
        box.accessibilityIdentifier=AirlineCode
        
        return box
    }
    
    func boxTapped(sender:UIGestureRecognizer) {
        let view = sender.view
        UserDefaults.standard.setValue(view?.accessibilityIdentifier, forKey: "selected_airline")
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "DidAirlineAirportLabelChange"), object: nil)
        
        if (AppDelegate.getDelegate().getTypeEvent(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation()) == "B"){
            AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: false)
            AppDelegate.getDelegate().ScanManagerInstance.BingoMode()
        } else {
            if self.ReturnToMain {
                AppDelegate.IsUSerINMainView=true
                AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: false)
                if self.ShowTrackingIdentifier{
                    AppDelegate.getDelegate().LocationSuccessViewDismissed()
                }
            } else{
                AppDelegate.vc.navigationController?.pushViewController(AppDelegate.vc.ConnectivityView, animated: false)
            }
        }
    }
}
