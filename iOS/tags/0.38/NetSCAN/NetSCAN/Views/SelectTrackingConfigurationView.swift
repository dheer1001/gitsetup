//
//  SelectTrackingConfigurationView.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 1/9/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class SelectTrackingConfigurationView: UIViewController ,UIScrollViewDelegate {
    
    var Service_ID:String!
    var User_ID:String!
    var configurationList :NSMutableArray!
    var selectedTrackingPoint : String!
    var hiddenHeader:UIView!
    var clearButton:UIButton!
    var refreshButton:UIButton!
    var activityViewForLoader:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view:UIView in self.view.subviews {
            view.removeFromSuperview()
        }
        
        navigationController?.isNavigationBarHidden=true
        self.view.backgroundColor=primaryColor()
        getConfigurationList()
        
        if configurationList.count != 0 {
            LoadComponents()
            loadHiddenObject()
            AppDelegate.IsUSerINMainView=false
        } else {
            AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getConfigurationList() {
        
        if (UserDefaults.standard.value(forKey: "selected_airport")) != nil {
            let configList = UserDefaultsManager().getTrackingConfigurationFor(airportCode: (UserDefaults.standard.value(forKey: "selected_airport")) as! String)
            
            let groupsNameArray = NSMutableArray()
            configurationList = NSMutableArray()
            
            if configList != nil {
                for trackingRowDic in configList! {
                    if (trackingRowDic as! NSDictionary).value(forKey: "group_name") != nil {
                        if groupsNameArray.count > 0 {
                            if !groupsNameArray.contains((trackingRowDic as! NSDictionary).value(forKey: "group_name")!) {
                                groupsNameArray.add((trackingRowDic as! NSDictionary).value(forKey: "group_name")!)
                            }
                        } else {
                            groupsNameArray.add((trackingRowDic as! NSDictionary).value(forKey: "group_name")!)
                        }
                    }
                }
                
                let sortedArray = groupsNameArray.sorted{($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending}
                groupsNameArray.removeAllObjects()
                groupsNameArray.addObjects(from: sortedArray)
                
                for groupName in groupsNameArray {
                    let grouplist = NSMutableArray()
                    for trackingRowDic in configList! {
                        if (trackingRowDic as! NSDictionary).value(forKey: "group_name") != nil {
                            if ((trackingRowDic as! NSDictionary).value(forKey: "group_name") as! String) == (groupName as! String) {
                                grouplist.add(trackingRowDic)
                            }
                        }
                    }
                    configurationList.add(grouplist)
                }
            }
        }
    }
    
    
    func LoadComponents() {
        
        for view:UIView in self.view.subviews{
            view.removeFromSuperview()
        }
        
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
        
        let locationImageView = UIImageView(frame: CGRect(x: (screenWidth/2)-30, y: startY, width: 60, height: 60))
        locationImageView.image=UIImage(named: "gps-fixed")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        locationImageView.tintColor=secondaryColor()
        startY += locationImageView.frame.size.height+10
        
        let SelectTrackingLocationLabel = UILabel(frame: CGRect(x:10,y:startY,width:screenWidth-20, height:30))
        SelectTrackingLocationLabel.text="selectTrackingPoint".localized
        SelectTrackingLocationLabel.font=UIFont.systemFont(ofSize: 15)
        SelectTrackingLocationLabel.textColor=OrangeColorInverted()
        SelectTrackingLocationLabel.textAlignment=NSTextAlignment.center
        startY += SelectTrackingLocationLabel.frame.size.height+10
        
        let selectTrackingLocationView = UIView()
        selectTrackingLocationView.backgroundColor=QueueBackgroundColor()
        
        let trackingGroupsContainer = UIView()
        
        var contentHeight = CGFloat(0)
        var groupHeight = CGFloat(0)
        
        if (configurationList != nil) && configurationList.count>0 {

            if let recentlyGroup = UserDefaultsManager().getRecentlyUsedTrackingPoints(forKey: UserDefaultsManager().getKeyForRecentlyUsed()) {
                
                groupHeight = CGFloat(0)
                let groupView = UIView()
                
                for i in 0  ..< recentlyGroup.count {
                    let trackingRow = recentlyGroup.object(at: i) as! NSDictionary
                    let box = GenerateTrackingRowBox(trackingRowDic:trackingRow, screenWidth: screenWidth, screenHeight: screenHeight, boxesNumber: i)
                    groupView.addSubview(box!)
                }
                
                if ((recentlyGroup.count)%2 != 0){
                    groupHeight = (((screenWidth/2)-60) * CGFloat(((recentlyGroup.count)+1)/2)) + 80
                } else {
                    groupHeight = (((screenWidth/2)-60) * CGFloat((recentlyGroup.count)/2)) + 80
                }
                
                groupView.frame = CGRect(x: 0, y: contentHeight, width: screenWidth, height:groupHeight)
                
                let border = CALayer()
                border.borderColor = primaryColor().cgColor
                border.frame = CGRect(x:0,y:groupHeight-2,width:screenWidth,height:2)
                border.borderWidth = 2.0
                groupView.layer.addSublayer(border)
                
                let groubTitle = UILabel(frame: CGRect(x:30, y:0, width:screenWidth-40, height:80))
                groubTitle.textAlignment = NSTextAlignment.left
                groubTitle.textColor = secondaryColor()
                groubTitle.adjustsFontSizeToFitWidth = true
                groubTitle.text=((recentlyGroup.object(at: 0) as! NSDictionary).value(forKey: "group_name") as? String)?.localized
                groubTitle.font = UIFont.boldSystemFont(ofSize: 22)
                groupView.addSubview(groubTitle)
                
                clearButton = UIButton(frame:CGRect(x: screenWidth-100, y: 25, width: 80, height: 30))
                clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
                clearButton.setTitle("CLEAR".localized, for: .normal)
                clearButton.setTitleColor(OrangeColorInverted(), for: .normal)
                clearButton.backgroundColor = UIColor.clear
                groupView.addSubview(clearButton)
                
                trackingGroupsContainer.addSubview(groupView)
                contentHeight = contentHeight + groupHeight
            }

            for i in 0  ..< configurationList.count {
                let group = configurationList.object(at: i) as! NSArray
                
                if group.count>0 {

                    groupHeight = CGFloat(0)
                    let groupView = UIView()
                    var defeatedBoxes = 0
                    
                    for i in 0  ..< group.count {
                        let trackingRow = group.object(at: i) as! NSDictionary
                        let box = GenerateTrackingRowBox(trackingRowDic:trackingRow, screenWidth: screenWidth, screenHeight: screenHeight, boxesNumber: i-defeatedBoxes)
                        if box != nil {
                            groupView.addSubview(box!)
                        } else {
                           defeatedBoxes = defeatedBoxes + 1
                        }
                    }
                    
                    if ((group.count-defeatedBoxes)%2 != 0){
                        groupHeight = (((screenWidth/2)-60) * CGFloat(((group.count-defeatedBoxes)+1)/2)) + 80
                    } else {
                        groupHeight = (((screenWidth/2)-60) * CGFloat((group.count-defeatedBoxes)/2)) + 80
                    }
                    
                    groupView.frame = CGRect(x: 0, y: contentHeight, width: screenWidth, height:groupHeight)
                    
                    let border = CALayer()
                    border.borderColor = primaryColor().cgColor
                    border.frame = CGRect(x:0,y:groupHeight-2,width:screenWidth,height:2)
                    border.borderWidth = 2.0
                    groupView.layer.addSublayer(border)
                    
                    let groubTitle = UILabel(frame: CGRect(x:30, y:0, width:screenWidth-40, height:80))
                    groubTitle.textAlignment = NSTextAlignment.left
                    groubTitle.textColor = secondaryColor()
                    groubTitle.adjustsFontSizeToFitWidth = true
                    groubTitle.text=(group.object(at: 0) as! NSDictionary).value(forKey: "group_name") as? String
                    groubTitle.font = UIFont.boldSystemFont(ofSize: 22)
                    groupView.addSubview(groubTitle)
                    
                    
                    trackingGroupsContainer.addSubview(groupView)
                    contentHeight = contentHeight + groupHeight
                }
            }
            
            refreshButton = UIButton(frame: CGRect(x:screenWidth/13.39, y:contentHeight+20, width: screenWidth-((screenWidth/13.39)*2), height:screenHeight/13.34))
            refreshButton.backgroundColor = AppHeaderBackgroundColor()
            refreshButton.setTitle("refresh".localized, for: .normal)
            refreshButton.setTitleColor(secondaryColor(), for: .normal)
            refreshButton.layer.cornerRadius = 10
            refreshButton.addTarget(self, action: #selector(refreshPressed), for: .touchUpInside)
            
            trackingGroupsContainer.addSubview(refreshButton)
            contentHeight = contentHeight + refreshButton.frame.size.height + 30
        }
        trackingGroupsContainer.frame = CGRect(x:trackingGroupsContainer.frame.origin.x,y:trackingGroupsContainer.frame.origin.y ,width: screenWidth, height: contentHeight+10)
        
        let HeaderImageView = UIImageView(frame: CGRect(x:3.5, y:0, width:screenWidth, height:(screenHeight/2.5)/7))
        HeaderImageView.image=QueueHeaderImage()
        startY += HeaderImageView.frame.size.height
        
        let HeaderCorrector = UIView(frame: CGRect(x:0, y:0,width:screenWidth/3, height:3.5))
        HeaderCorrector.backgroundColor=primaryColor()
        
        selectTrackingLocationView.addSubview(HeaderCorrector)
        selectTrackingLocationView.addSubview(HeaderImageView)
        selectTrackingLocationView.addSubview(trackingGroupsContainer)
        
        selectTrackingLocationView.frame = CGRect(x:0, y:startY, width:screenWidth, height:HeaderCorrector.frame.size.height+HeaderImageView.frame.size.height+trackingGroupsContainer.frame.size.height)
        
        let TrackingLocationsScrollView = UIScrollView(frame:CGRect(x: 0, y:UIApplication.shared.statusBarFrame.height, width: screenWidth, height: screenHeight))
        TrackingLocationsScrollView.contentSize=CGSize(width:screenWidth, height:selectTrackingLocationView.frame.origin.y+selectTrackingLocationView.frame.size.height-10-UIApplication.shared.statusBarFrame.height)
        TrackingLocationsScrollView.bounces = false
        TrackingLocationsScrollView.delegate = self
        
        TrackingLocationsScrollView.addSubview(WelcomeLabel)
        TrackingLocationsScrollView.addSubview(UserNameLabel)
        TrackingLocationsScrollView.addSubview(UserIDLabel)
        TrackingLocationsScrollView.addSubview(locationImageView)
        TrackingLocationsScrollView.addSubview(SelectTrackingLocationLabel)
        TrackingLocationsScrollView.addSubview(selectTrackingLocationView)
        
        self.view.addSubview(TrackingLocationsScrollView)
        
        let closeButton = UIButton(frame: CGRect(x:10,y:30, width:48, height:48))
        closeButton.addTarget(self, action: #selector(self.close), for: UIControlEvents.touchUpInside)
        closeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        closeButton.setBackgroundImage(UIImage(named: "ic_close.png")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        closeButton.tintColor=secondaryColor()
        
        self.view.addSubview(closeButton)
        
    }
    
    func loadHiddenObject(){
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        var startY:CGFloat = 215-191
        
        hiddenHeader = UIView(frame:CGRect(x: 0, y:UIApplication.shared.statusBarFrame.height, width: screenWidth, height: 199))
        hiddenHeader.backgroundColor=primaryColor()
        
        let locationImageView = UIImageView(frame: CGRect(x: (screenWidth/2)-30, y: startY, width: 60, height: 60))
        locationImageView.image=UIImage(named: "gps-fixed")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        locationImageView.tintColor=secondaryColor()
        startY += locationImageView.frame.size.height+10
        
        let SelectTrackingLocationLabel = UILabel(frame: CGRect(x:10,y:startY,width:screenWidth-20, height:30))
        SelectTrackingLocationLabel.text="selectTrackingPoint".localized
        SelectTrackingLocationLabel.font=UIFont.systemFont(ofSize: 15)
        SelectTrackingLocationLabel.textColor=OrangeColorInverted()
        SelectTrackingLocationLabel.textAlignment=NSTextAlignment.center
        
        let HeaderImageView = UIImageView(frame: CGRect(x:3.5, y:(hiddenHeader.frame.height-(screenHeight/17.5))+12, width:screenWidth, height:(screenHeight/17.5)-12))
        
        if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
            HeaderImageView.image = UIImage(named:"scroll_header4.png")!
        } else {
             HeaderImageView.image = UIImage(named:"scroll_header3.png")!
        }
        
        let HeaderCorrector = UIView(frame: CGRect(x:0, y:(hiddenHeader.frame.height-(screenHeight/17.5))+15.5,width:screenWidth/3, height:(screenHeight/17.5)-15.5))
        HeaderCorrector.backgroundColor=QueueBackgroundColor()
    
        let closeButton = UIButton(frame: CGRect(x:10,y:30-UIApplication.shared.statusBarFrame.height, width:48, height:48))
        closeButton.addTarget(self, action: #selector(self.close), for: UIControlEvents.touchUpInside)
        closeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        closeButton.setBackgroundImage(UIImage(named: "ic_close.png")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        closeButton.tintColor=secondaryColor()
        
        hiddenHeader.addSubview(locationImageView)
        hiddenHeader.addSubview(SelectTrackingLocationLabel)
        hiddenHeader.addSubview(HeaderImageView)
        hiddenHeader.addSubview(HeaderCorrector)
        hiddenHeader.addSubview(closeButton)
        
        hiddenHeader.isHidden=true
        self.view.addSubview(hiddenHeader)
    }
    
    func  GenerateTrackingRowBox(trackingRowDic:NSDictionary,screenWidth:CGFloat,screenHeight:CGFloat,boxesNumber:Int) -> UIView! {
        
        var airportCode = "   " // 3 characs
        var trackingID = "        " // 8 characs
        var location = "          " // 10 characs
        var unKnownBagInput = "I" // default is I 1 characs
        var containerInput = "N" // default is N 1 characs
        var purpose = "track" // default is T 1 characs
        var description = "" // default is empty
        
        // airport_code
        if trackingRowDic.value(forKey: "airport_code") != nil {
            airportCode = trackingRowDic.value(forKey: "airport_code") as! String
            if airportCode.count != 3 {
                if airportCode.count < 3 {
                    for _ in (airportCode.count ..< 3) {
                        airportCode = airportCode.appending(" ")
                    }
                }
                else if airportCode.count > 3 {
                    let startIndex = airportCode.index(airportCode.startIndex, offsetBy: 3)
                    airportCode = airportCode.substring(to: startIndex)
                }
            }
        }
        
        // tracking_id
        if trackingRowDic.value(forKey: "tracking_id") != nil {
            trackingID = trackingRowDic.value(forKey: "tracking_id") as! String
            if trackingID.count != 8 {
                if trackingID.count < 8 {
                    for _ in (trackingID.count ..< 8) {
                        trackingID = trackingID.appending(" ")
                    }
                }
                else if trackingID.count > 8 {
                    let startIndex = trackingID.index(trackingID.startIndex, offsetBy: 8)
                    trackingID = trackingID.substring(to: startIndex)
                }
            }
        }
        
        // location
        if trackingRowDic.value(forKey: "location") != nil {
            location = trackingRowDic.value(forKey: "location") as! String
            if location.count != 10 {
                if location.count < 10 {
                    for _ in (location.count ..< 10) {
                        location = location.appending(" ")
                    }
                }
                else if trackingID.count > 10 {
                    let startIndex = location.index(location.startIndex, offsetBy: 10)
                    location = location.substring(to: startIndex)
                }
            }
        }
        
        // indicator_for_unknown_bag_mgmt
        if trackingRowDic.value(forKey: "indicator_for_unknown_bag_mgmt") != nil {
            unKnownBagInput = trackingRowDic.value(forKey: "indicator_for_unknown_bag_mgmt") as! String
            if unKnownBagInput.uppercased() == "U" || unKnownBagInput.uppercased() == "S" || unKnownBagInput.uppercased() == "I"{} else {
                unKnownBagInput = "I"
            }
        }
        
        // indicator_for_container_scanning
        if trackingRowDic.value(forKey: "indicator_for_container_scanning") != nil {
            containerInput = trackingRowDic.value(forKey: "indicator_for_container_scanning") as! String
            if containerInput.uppercased() == "C" || containerInput.uppercased() == "Y" || containerInput.uppercased() == "N"{} else {
                containerInput = "N"
            }
        }
        
        // purpose
        if trackingRowDic.value(forKey: "purpose") != nil {
            purpose = trackingRowDic.value(forKey: "purpose") as! String
            if purpose.uppercased() == "TRACK" || purpose.uppercased() == "LOAD" || purpose.uppercased() == "T" || purpose.uppercased() == "L" {
                if purpose.uppercased() == "LOAD" || purpose.uppercased() == "L" {
                    purpose = "L"
                } else {
                    purpose = "T"
                }
            } else {
                purpose = "T"
            }
        }
        
        // bingo_sheet_scanning
        if trackingRowDic.value(forKey: "bingo_sheet_scanning") != nil {
            if (trackingRowDic.value(forKey: "bingo_sheet_scanning") as! String).uppercased() == "YES" && purpose == "L" {
                purpose = "B"
            }
        }
        
        // description
        if trackingRowDic.value(forKey: "description") != nil {
            description = trackingRowDic.value(forKey: "description") as! String
        }
        
        
        var startY:CGFloat = 0
        var startX:CGFloat = 0
        
        if(boxesNumber%2 != 0){
            startX = (screenWidth/2) + 20
            startY = ((CGFloat((Int(boxesNumber/2))) * ((screenWidth/2)-60))) + 80
        } else {
            startX = 20
            startY = ((CGFloat((Int(boxesNumber/2))) * ((screenWidth/2)-60))) + 80
        }
        if startY == 0 {
            startY = 80
        }
        
        let box = UIView(frame: CGRect(x:CGFloat(startX), y:startY, width:(screenWidth/2)-40, height: (screenWidth/2)-80))
        box.backgroundColor=AppHeaderBackgroundColor()
        box.layer.cornerRadius=5
        
        
        let labelsView = UIView(frame: CGRect(x:0, y:(box.frame.size.height/2)-35, width:(screenWidth/2)-40, height:70))
        
        let trackingIdLabel = UILabel(frame: CGRect(x: 10, y:0, width: box.frame.size.width-20, height:25))
        trackingIdLabel.textAlignment=NSTextAlignment.center
        trackingIdLabel.text=trackingID
        trackingIdLabel.font = UIFont.boldSystemFont(ofSize: 22)
        trackingIdLabel.adjustsFontSizeToFitWidth = true
        trackingIdLabel.textColor=secondaryColor()
        labelsView.addSubview(trackingIdLabel)
        
        let locationLabel = UILabel(frame: CGRect(x: 10, y:30, width: box.frame.size.width-20, height:20))
        locationLabel.textAlignment=NSTextAlignment.center
        locationLabel.text=location
        locationLabel.adjustsFontSizeToFitWidth = true
        locationLabel.textColor=secondaryColor()
        labelsView.addSubview(locationLabel)
        
        let descriptionLabel = UILabel(frame: CGRect(x: 10, y:50, width: box.frame.size.width-20, height:20))
        descriptionLabel.textAlignment=NSTextAlignment.center
        descriptionLabel.text=description
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textColor=secondaryColor()
        labelsView.addSubview(descriptionLabel)
        
        box.addSubview(labelsView)
        
        let width = CGFloat(3.0)
        let border1 = CALayer()
        border1.borderColor = primaryColor().cgColor
        border1.frame = CGRect(x:0,y:0,width:width,height:box.frame.size.height)
        border1.borderWidth = width
        
        let border2 = CALayer()
        border2.borderColor = primaryColor().cgColor
        border2.frame = CGRect(x:0,y:0,width:box.frame.size.width,height:width)
        border2.borderWidth = width
        
        let border3 = CALayer()
        border3.borderColor = primaryColor().cgColor
        border3.frame = CGRect(x:0,y:box.frame.size.height-width,width:box.frame.size.width,height:width)
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
        
        box.accessibilityIdentifier = airportCode + trackingID + location + unKnownBagInput + containerInput + purpose
        box.accessibilityValue = description
        return box
    }
    
    func boxTapped(sender:UIGestureRecognizer) {
        selectedTrackingPoint = (sender.view?.accessibilityIdentifier)!
        AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: false)
        let deadlineTime = DispatchTime.now() + .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime){
            AppDelegate.SaveTrackingToRecentlyUsedIfInvalid = true
            AppDelegate.RecentlyUsedTrackingDescription = (sender.view?.accessibilityValue)!
            AppDelegate.getDelegate().OnDecodedData(data: self.selectedTrackingPoint,showTrackingIdentifier: false)
        }
    }
    
    @objc func close (){
        AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshPressed (){
        let url = Constants.BagJourneyHost + String(format: Constants.trackingConfigurationEndPoint,Service_ID,(UserDefaults.standard.value(forKey: "selected_airport") as! String))
        let apiCall = ApiCallSwift()
        apiCall.getResponseForURL(builtURL: url as NSString, JsonToPost:"", isAuthenticationRequired: false, method: "GET", errorTitle: "", optionalValue:UserDefaults.standard.value(forKey: "selected_airport") as! String, AndCompletionHandler: { (retrivedCode, response, statusCode, data, Error) in
            self.stopRefreshLoader()
            if response.value(forKey: "success") != nil && response.value(forKey: "success") as! Bool {
                if let configuration = response.value(forKey:"configurations") {
                    if (configuration as! NSArray).count > 0 {
                        let airportCode = ((configuration as! NSArray).firstObject as! NSDictionary).value(forKey: "airport_code") as! String
                        ScanManager.LocalStorage.setConfigurationsFor(airportCode: airportCode, configurationArray: configuration as! NSArray)
                        self.viewDidLoad()
                    }
                }
            }
        })
        startRefreshLoader()
    }
    
    func startRefreshLoader() {
        autoreleasepool(invoking:{
            if (activityViewForLoader == nil){
                refreshButton.setTitle("", for: .normal)
                activityViewForLoader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
                activityViewForLoader.frame = CGRect(x:(refreshButton.frame.size.width/2)-100, y: (refreshButton.frame.size.height/2)-100, width: 200, height: 200)
                activityViewForLoader.backgroundColor=UIColor.clear
                activityViewForLoader.startAnimating()
                refreshButton.addSubview(activityViewForLoader)
            }
        })
    }
    
    func stopRefreshLoader (){
        refreshButton.setTitle("refresh".localized, for: .normal)
        if activityViewForLoader != nil {
            activityViewForLoader.removeFromSuperview()
            activityViewForLoader = nil
        }
    }
    
    func clearButtonPressed(){
        UserDefaultsManager().removeRecentlyUsedTrackingPoints(key: UserDefaultsManager().getKeyForRecentlyUsed())
        self.viewDidLoad()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= 191) {
            hiddenHeader.isHidden=false
        }else{
            hiddenHeader.isHidden=true
        }

        if (clearButton != nil){
            if (scrollView.contentOffset.y >= 211){
                clearButton.isUserInteractionEnabled=false
            } else{
                clearButton.isUserInteractionEnabled=true
            }
        }
    }
}
