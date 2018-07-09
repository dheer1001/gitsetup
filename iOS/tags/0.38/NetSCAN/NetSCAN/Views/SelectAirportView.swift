//
//  SelectAirportView.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 10/11/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class SelectAirportView: UIViewController {
    
    var Airports:NSArray!
    var Airlines:NSArray!
    var Service_ID:String!
    var User_ID:String!
    var ReturnToMain:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden=true
        self.view.backgroundColor=primaryColor()
        LoadComponents()
        AppDelegate.IsUSerINMainView=false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func LoadComponents() {
        
        let screenWidth:CGFloat = UIScreen.main.bounds.size.width
        let screenHeight:CGFloat = Constants.UIScreenMainHeight
        var startY:CGFloat = 60
        
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
        
        let AirpoortImageView = UIImageView(frame: CGRect(x: (screenWidth/2)-30, y: startY, width: 60, height: 60))
        AirpoortImageView.image=UIImage(named: "airport2")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        AirpoortImageView.tintColor=secondaryColor()
        startY += AirpoortImageView.frame.size.height+10
        
        let SelectAirportLabel = UILabel(frame: CGRect(x:10,y:startY,width:screenWidth-20, height:30))
        SelectAirportLabel.text="selectAirport".localized
        SelectAirportLabel.font=UIFont.systemFont(ofSize: 15)
        SelectAirportLabel.textColor=OrangeColorInverted()
        SelectAirportLabel.textAlignment=NSTextAlignment.center
        startY += SelectAirportLabel.frame.size.height+10
        
        let AirportsMainView = UIView(frame: CGRect(x:0, y:startY, width:screenWidth, height:screenHeight-startY))
        AirportsMainView.backgroundColor=QueueBackgroundColor()
        
        let AirportsScrollView = UIScrollView(frame: CGRect(x:0, y:5, width:screenWidth, height:screenHeight-startY-5))
        if (Airports != nil) && Airports.count>0 {
            for i in 0  ..< Airports.count {
                AirportsScrollView.addSubview(GenerateAirportBox(AirportCode:Airports.object(at: i) as! String, screenWidth:screenWidth, screenHeight: screenHeight, boxesNumber:i))
            }
            
            var contentHeight = (screenWidth/2) * CGFloat(Airports.count/2)
            if (Airports.count%2 != 0){
                contentHeight = (screenWidth/2) * CGFloat((Airports.count+1)/2)
            }
            AirportsScrollView.contentSize=CGSize(width: screenWidth, height: contentHeight+10)
        }
        
        let HeaderImageView = UIImageView(frame: CGRect(x:3.5, y:0, width:screenWidth, height:(screenHeight/2.5)/7))
        HeaderImageView.image=QueueHeaderImage()
        startY += HeaderImageView.frame.size.height
        
        let HeaderCorrector = UIView(frame: CGRect(x:0, y:0,width:screenWidth/3, height:3.5))
        HeaderCorrector.backgroundColor=primaryColor()
        
        AirportsMainView.addSubview(HeaderCorrector)
        AirportsMainView.addSubview(HeaderImageView)
        AirportsMainView.addSubview(AirportsScrollView)
        
        self.view.addSubview(WelcomeLabel)
        self.view.addSubview(UserNameLabel)
        self.view.addSubview(UserIDLabel)
        self.view.addSubview(AirpoortImageView)
        self.view.addSubview(SelectAirportLabel)
        self.view.addSubview(AirportsMainView)
    }
    
    func GenerateAirportBox(AirportCode:String,screenWidth:CGFloat,screenHeight:CGFloat,boxesNumber:Int) -> UIView {
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
        
        let AirportCodeLabel = UILabel(frame: CGRect(x: 10, y:(box.frame.size.height/2)-15, width: box.frame.size.width-20, height: 30))
        AirportCodeLabel.textAlignment=NSTextAlignment.center
        AirportCodeLabel.text=AirportCode
        AirportCodeLabel.textColor=secondaryColor()
        box.addSubview(AirportCodeLabel)
        
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
        box.accessibilityIdentifier=AirportCode
        
        return box
    }
    
    func boxTapped(sender:UIGestureRecognizer) {
        
        if (UserDefaults.standard.value(forKey: "selected_airport") != nil && sender.view?.accessibilityIdentifier! != nil && (UserDefaults.standard.value(forKey: "selected_airport") as! String) != sender.view?.accessibilityIdentifier!){
            UserDefaultsManager().RemoveTrackingPointRaw()
            UserDefaultsManager().RemoveTrackingLocation()
            UserDefaultsManager().RemoveTrackingPointValidityUntil()
            UserDefaultsManager().RemoveContainerID()
            UserDefaultsManager().removeFlightInformation()
        }
        
        let view = sender.view
        UserDefaults.standard.setValue(view?.accessibilityIdentifier, forKey: "selected_airport")
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "DidAirlineAirportLabelChange"), object: nil)
        if self.ReturnToMain{
            AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: false)
        }else{
            if(self.Airlines != nil){
                AppDelegate.IsUSerINMainView=true
                let SelectAirline = SelectAirlineView()
                SelectAirline.Airlines=self.Airlines
                SelectAirline.User_ID=self.User_ID
                SelectAirline.Service_ID=self.Service_ID
                SelectAirline.ReturnToMain=self.ReturnToMain
                SelectAirline.ShowTrackingIdentifier=false
                self.navigationController?.pushViewController(SelectAirline, animated: false)
            } else {
                AppDelegate.vc.navigationController?.pushViewController(AppDelegate.vc.ConnectivityView, animated: false)
            }
        }
    }
}
