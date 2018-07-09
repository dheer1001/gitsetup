//
//  AppDelegate.swift
//  NetSCAN
//
//  Created by User on 9/15/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import UserNotifications
 
@UIApplicationMain
class AppDelegate:UIResponder,UIApplicationDelegate{
    
    var window: UIWindow?
    var canBeDismissed: Bool!
    var currentView: UIView!
    var myView: UIView!
    var myMenuView: UIView!
    public static let nav = UINavigationController()
    var ScannedItemsArray:NSArray = []
    var viewPressedInstance=UIView()
    var LoaderInstance2=UIActivityIndicatorView()
    public let ScanManagerInstance=ScanManager()
    let SoftScannerInstance=SoftScannManager()
    var activityViewForLoader:UIActivityIndicatorView!
    var loadingView:UIView!
    var tokenExpiryTimer:Timer!
    
    public static var IsUSerINMainView=false
    public static var EnableContainers=false
    public static var EnableBags=false
    public static var ShouldReturnToTestingScannerConnectivityView=true;
    public static var BackgrounModeAttribute:Bool = false
    public static var ScanningBagTag:String = ""
    public static var LocalNotificationMessage = ""
    public static var COGNEX_FIRMWARE_VERSION:String = ""
    public static var COGNEX_BATTERY_LEVEL:String = ""
    public static var SOCKET_FIRMWARE_VERSION:String = ""
    public static var SOCKET_BATTERY_LEVEL:String = ""
    public static var BINGO_INFO:Bool = false
    public static var containerIdentifierPresented = false
    public static var SaveTrackingToRecentlyUsedIfInvalid = false
    public static var priorityForBags = true
    public static var RecentlyUsedTrackingDescription = ""
    public static var trackingLocationClock = Timer()
    public static var DialogsDismissClock = Timer()

    let SetSoftScanner=true //used to enable and disable scanner for releases
    
    
    public static let vc = Login ( nibName:"Login", bundle: nil)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        
        // Configure tracker from GoogleService-Info.plist.
        
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true  // report uncaught exceptions
        //gai?.logger.logLevel = GAILogLevel.verbose  // remove before app release
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = secondaryColor()
        AppDelegate.BackgrounModeAttribute=false;
        //Push the vc onto the nav
        
      AppDelegate.nav.pushViewController(AppDelegate.vc, animated: false)
        
        // Set the window’s root view controller
        self.window!.rootViewController = AppDelegate.nav
        
        // SetExpirationTimer
        AppDelegate.getDelegate().preventTokenExpiration()
        
        // Present the window
        self.window!.makeKeyAndVisible()
        return true
        
    }
    
    class func getDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func registerNotification(){
        let notifCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert,.sound]
        notifCenter.requestAuthorization(options: options) { (false, Error) in}
    }
    
//    func AddScanTrackingPointView(){
//        AppDelegate.vc.MainViewControllerPointer.AddScanTrackingPointView()
//    }
//
//    func RemoveScanTrackingPointView(){
//        AppDelegate.vc.MainViewControllerPointer.RemoveScanTrackingPointView()
//    }
    
    func AddContainerIdentifierView(){
        AppDelegate.vc.MainViewControllerPointer.AddContainerIdentifierView()
    }
    
    func RemoveContainerIdentifierView(){
        AppDelegate.vc.MainViewControllerPointer.RemoveContainerIdentifierView()
    }
    
    func AddLocationSuccessView(TrakingLocation:String, seconds:Int){
        AppDelegate.vc.MainViewControllerPointer.AddLocationSuccessView(trakingLoction: TrakingLocation ,Seconds:3600)
    }
    
    func InitializeScanManager(){
        ScanManagerInstance.initialize()
    }
    
    func LocationSuccessViewDismissed(){
        ScanManagerInstance.LocationSuccesDialogDismissed()
    }
    
    func RequierdContainerDialogDismiss(){
        ScanManagerInstance.RequierdContainerDialogDismiss()
    }
    
    func AddInternetConnectionView(){
        AppDelegate.priorityForBags = false
        AppDelegate.vc.MainViewControllerPointer.AddInternetConnectionView()
        if(AppDelegate.BackgrounModeAttribute){
            AppDelegate.LocalNotificationMessage="notification_noInternetConnection".localized
            AppDelegate.getDelegate().ScanManagerInstance.scheduleLocal(sender: self)
        }
    }
    
    func RemoveInternetConnectionView(){
        AppDelegate.priorityForBags = true
        AppDelegate.vc.MainViewControllerPointer.RemoveInternetConnectionView()
    }
    
    func AddFetchingBagView(){
        AppDelegate.vc.MainViewControllerPointer.AddFetchingBagView()
    }
    
    func RemoveFetchingBagView(){
        AppDelegate.vc.MainViewControllerPointer.RemoveFetchingBagView()
    }
    
    func AddDeviceConnectionView(){
        AppDelegate.priorityForBags = false
        AppDelegate.vc.MainViewControllerPointer.AddDeviceConnectionView()
    }
    
    func RemoveDeviceConnectionView(){
        AppDelegate.priorityForBags = true
        AppDelegate.vc.MainViewControllerPointer.RemoveDeviceConnectionView()
    }
    
    func AddFlightInformationView(bagView:Bool,bagNumber:String,UnknownBag:String){
        AppDelegate.vc.MainViewControllerPointer.AddFlightAditionalView(bagView: bagView,bagNumber: bagNumber,unknownBag:UnknownBag)
    }
    
    func RemoveFlightInformationView(){
        AppDelegate.vc.MainViewControllerPointer.RemoveFlightInformationView()
    }
    
    func UpdateQueueScrollView(ArrayOfItems:NSArray,LastItemScaned:Bag?){
        AppDelegate.vc.MainViewControllerPointer.AddQueueScrollView(scannedItemsArray: ArrayOfItems,LastItem: LastItemScaned)
       ScanManagerInstance.checkForBannerViews()
    }
    
    func SaveFlightDataInformation(flight_num: String, flight_date: Date, flight_type: String){
        ScanManagerInstance.SaveFlightDataInformation(flight_num: flight_num, flight_date: flight_date, flight_type: flight_type)
    }
    
    func CheckIfContainerInputRequierd(){
        ScanManagerInstance.CheckIfContainerInputRequierd()
    }
    
    func AddContainerView(containerName:String, desription:String, size:String, countour:String, type:String){
        AppDelegate.vc.MainViewControllerPointer.AddContainerView(containerName: containerName, desription: desription, size: size, countour: countour, type: type)
    }
    
    func RemoveContainerView(){
        AppDelegate.vc.MainViewControllerPointer.RemoveContainerView()
    }
    
//    func OnFligthViewOfUnknownBagU(ReadString:String){
//        ScanManagerInstance.OnFligthViewOfUnknownBagUDismiss(readString:ReadString)
//    }
    
    func LunshViewController(){
        AppDelegate.vc.NavigatToConnectDivice()
    }
    
    func LunchNavigatToResetDivice(){
        AppDelegate.vc.NavigatToResetDivice()
    }
    
    func ReturnNavigation () -> UINavigationController{
        return AppDelegate.nav
    }
    
    func GetTrackingLocation(TrackingPoint:String) -> String{
        return self.getTrackingLocation(scannedBarcode: TrackingPoint)
    }
    
    func CheckForViews(){
        ScanManagerInstance.CheckForViews()
    }
    
    func RemoveFligthAirPlaneInformationView(){
        AppDelegate.vc.MainViewControllerPointer.RemoveFligthAirPlaneInformationView()
    }
    
    func AddFligthAirPlaneInformationView(Info:String){
        AppDelegate.vc.MainViewControllerPointer.AddFligthAirPlaneInformationView(info:Info)
    }
    
    func UpdateLocationOnAppHeader(seconds:Int,trackingLocation:String){
        AppDelegate.vc.MainViewControllerPointer.UpdateLocationOnAppHeader(seconds:seconds,trackingLocation:trackingLocation)
    }
    
    func ScanManagerReturnFromBackground(){
        ScanManagerInstance.OnReturnFromBackGround()
    }
    
    func ReloadMainViewAfterScannerSetupIsDone(){
        AppDelegate.vc.ReloadMainViewAfterScannerSetupIsDone()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication){
        AppDelegate.BackgrounModeAttribute=true
        self.window?.endEditing(true)
        
        if UIApplication.shared.responds(to: #selector(getter: UIApplication.shared.currentUserNotificationSettings)) {
            let grantedSettings:UIUserNotificationSettings = UIApplication.shared.currentUserNotificationSettings!
            if (grantedSettings.types != .none && (UserDefaults.standard.value(forKey: "loginResponse") != nil)){
                showTokenExpiryNotificationAfter(fireDate: tokenExpiryTimer.fireDate)
                if tokenExpiryTimer != nil {
                    tokenExpiryTimer.invalidate()
                }
            }
        }
    }
    
    func DisableCodesNeedToInternet(){
        ScanManagerInstance.DisableCodesNeedToInternet()
    }
    
    func GetLoadStatus(TrackingLocation:String) -> String{
        return self.getTypeEvent(scannedBarcode:TrackingLocation)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication){
        AppDelegate.BackgrounModeAttribute=false;
        if(AppDelegate.IsUSerINMainView){
            ScanManagerInstance.OnReturnFromBackGround()
        }
        preventTokenExpiration()
        fetchFakeTracking()
    }
    
    func ReturnToLogin(){
        AppDelegate.vc.MainViewControllerPointer.ContainerView.removeFromSuperview()
        AppDelegate.vc.MainViewControllerPointer.QueueScrollView.removeFromSuperview()
        AppDelegate.nav.dismiss(animated: true,completion: nil)
        AppDelegate.nav.popToRootViewController(animated: true)
    }
    
    func CancelButton(){
         AppDelegate.nav.dismiss(animated: true,completion: nil)
         AppDelegate.nav.popToRootViewController(animated: true)
    }
    
    func ConnectivityTest_ScannerWasConnected(){
        AppDelegate.vc.ConnectivityView.DeviceArrival()
    }
    
    func InternetStatus() -> Bool{
        return AppDelegate.vc.MainViewControllerPointer.ReturnNetworkStatus()
    }

    func applicationWillTerminate(_ application: UIApplication) {
//        ScanManagerInstance.DisableTriggerButton()
        self.saveContext()
    }
    
    // MARK: - SoftScanner
    func LunchOfflineScanner(){
        AppDelegate.vc.MainViewControllerPointer.OfflineScanner()
    }
    
    func EnableContainer(){
        AppDelegate.EnableContainers=true
        AppDelegate.EnableBags=false
    }
    
    func EnableBagOrContainer(){
        AppDelegate.EnableContainers=true
        AppDelegate.EnableBags=true
    }
    
    func DisableAll(){
        AppDelegate.EnableContainers=false
        AppDelegate.EnableBags=false
    }
    
    func EnableBagsOnly(){
        AppDelegate.EnableContainers=false
        AppDelegate.EnableBags=true
    }
    
    func OnDecodedData(data:String,showTrackingIdentifier: Bool){
        AppDelegate.getDelegate().ScanManagerInstance.WhatToDoAfterScanningBarCode(readString: data, showTrackingIdentifier: showTrackingIdentifier)
    }
    
    func getTypeEvent(scannedBarcode:String) ->String
    {
        var typeEvent:String! = ""
        if(AppDelegate.SaveTrackingToRecentlyUsedIfInvalid || (ScanManagerInstance.isValidTrackingLocation(trackingLocation: scannedBarcode) == true || ScanManagerInstance.isValidBingoLocation(trackingLocation: scannedBarcode) == true)){
            if (scannedBarcode.characters.count >= 22){
                let Chars=Array(scannedBarcode.characters)
                let Char1 = Chars[23]
                typeEvent = "\(Char1)".uppercased()
            }
        }
        return typeEvent
    }
    
    func getContainerInput (scannedBarcode:String) ->String
    {
        var containerInput:String! = ""
        if(AppDelegate.SaveTrackingToRecentlyUsedIfInvalid || (ScanManagerInstance.isValidTrackingLocation(trackingLocation: scannedBarcode) == true || ScanManagerInstance.isValidBingoLocation(trackingLocation: scannedBarcode) == true)){
            if (scannedBarcode.characters.count >= 21){
                let Chars=Array(scannedBarcode.characters)
                let Char1 = Chars[22]
                containerInput = "\(Char1)".uppercased()
            }
        }
        return containerInput
    }
    
    func getUnknownBags (scannedBarcode:String) -> String
    {
        var unknownBags:String! = ""
        if(AppDelegate.SaveTrackingToRecentlyUsedIfInvalid || (ScanManagerInstance.isValidTrackingLocation(trackingLocation: scannedBarcode) == true || ScanManagerInstance.isValidBingoLocation(trackingLocation: scannedBarcode) == true)){
            if (scannedBarcode.characters.count >= 20){
                let Chars=Array(scannedBarcode.characters)
                let Char1 = Chars[21]
                unknownBags = "\(Char1)".uppercased()
            }
        }
        return unknownBags
    }
    
    func getTrackingLocation (scannedBarcode:String) -> String
    {
        var trackLocation:String! = ""
        if(AppDelegate.SaveTrackingToRecentlyUsedIfInvalid || (ScanManagerInstance.isValidTrackingLocation(trackingLocation: scannedBarcode) == true || ScanManagerInstance.isValidBingoLocation(trackingLocation: scannedBarcode) == true)){
            if (scannedBarcode.characters.count >= 19){
                let Chars=Array(scannedBarcode.characters)
                let Char1 = Chars[11]
                let Char2 = Chars[12]
                let Char3 = Chars[13]
                let Char4 = Chars[14]
                let Char5 = Chars[15]
                let Char6 = Chars[16]
                let Char7 = Chars[17]
                let Char8 = Chars[18]
                let Char9 = Chars[19]
                let Char10 = Chars[20]
                trackLocation = "\(Char1)\(Char2)\(Char3)\(Char4)\(Char5)\(Char6)\(Char7)\(Char8)\(Char9)\(Char10)"
            }
        }
        return trackLocation
    }
    
    func getTrackingID (scannedBarcode:String) -> String
    {
        var eventType:String! = ""
        if(AppDelegate.SaveTrackingToRecentlyUsedIfInvalid || (ScanManagerInstance.isValidTrackingLocation(trackingLocation: scannedBarcode) == true || ScanManagerInstance.isValidBingoLocation(trackingLocation: scannedBarcode) == true)){
            if (scannedBarcode.characters.count >= 19){
                let Chars=Array(scannedBarcode.characters)
                let Char1 = Chars[3]
                let Char2 = Chars[4]
                let Char3 = Chars[5]
                let Char4 = Chars[6]
                let Char5 = Chars[7]
                let Char6 = Chars[8]
                let Char7 = Chars[9]
                let Char8 = Chars[10]
                eventType = "\(Char1)\(Char2)\(Char3)\(Char4)\(Char5)\(Char6)\(Char7)\(Char8)"
            }
        }
        return eventType
    }
    
    func getAirportCode (scannedBarcode:String) -> String
    {
        var airportCode:String! = ""
        if (AppDelegate.SaveTrackingToRecentlyUsedIfInvalid || (ScanManagerInstance.isValidTrackingLocation(trackingLocation: scannedBarcode) == true || ScanManagerInstance.isValidBingoLocation(trackingLocation: scannedBarcode) == true)){
            if (scannedBarcode.characters.count >= 19){
                let Chars=Array(scannedBarcode.characters)
                let Char1 = Chars[0]
                let Char2 = Chars[1]
                let Char3 = Chars[2]
                airportCode = "\(Char1)\(Char2)\(Char3)"
            }
        }
        return airportCode
    }
    
    func buildTrackingConfigurationForRecentlyUsed(TrackingPoint:String) -> NSDictionary{
        
        let trackingConfig = NSMutableDictionary()
        let purpose = TrackingPoint.characters.last
        
        trackingConfig.setValue(self.getAirportCode(scannedBarcode: TrackingPoint), forKey: "airport_code")
        trackingConfig.setValue(self.getTrackingID(scannedBarcode: TrackingPoint), forKey: "tracking_id")
        trackingConfig.setValue(self.getTrackingLocation(scannedBarcode: TrackingPoint), forKey: "location")
        trackingConfig.setValue(self.getContainerInput(scannedBarcode: TrackingPoint), forKey: "indicator_for_container_scanning")
        trackingConfig.setValue(self.getUnknownBags(scannedBarcode: TrackingPoint), forKey: "indicator_for_unknown_bag_mgmt")
        
        if purpose?.description.uppercased() == "B" {
            trackingConfig.setValue("Load", forKey: "purpose")
            trackingConfig.setValue("YES", forKey: "bingo_sheet_scanning")
        } else if purpose?.description.uppercased() == "L" {
            trackingConfig.setValue("Load", forKey: "purpose")
            trackingConfig.setValue("NO", forKey: "bingo_sheet_scanning")
        } else {
            trackingConfig.setValue("Track", forKey: "purpose")
            trackingConfig.setValue("NO", forKey: "bingo_sheet_scanning")
        }
        
        trackingConfig.setValue(TrackingPoint, forKey: "trackingPoint")
        trackingConfig.setValue("recentlyUsed", forKey: "group_name")
        trackingConfig.setValue(AppDelegate.RecentlyUsedTrackingDescription, forKey: "description")
        AppDelegate.RecentlyUsedTrackingDescription = ""
        return trackingConfig
    }
    
    func matchesForRegexCaseSensitive(containerSpec:String, text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: containerSpec, options: NSRegularExpression.Options(rawValue: 0))
            let nsString = text as NSString
            let results = regex.matches(in: text,options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func matchesForRegexInText(containerSpec:String, text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: containerSpec, options: .caseInsensitive)
            let nsString = text as NSString
            let results = regex.matches(in: text,options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func showOverlayWithViewSoftScanner(viewToShow: UIView, dismiss: Bool){
        if( myView != nil ){
            doClose()
        }
        currentView = viewToShow
        let screen=UIScreen.main.bounds
        if(UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized)
        {
            myView=UIView(frame: CGRect(x:0,y:screen.height-(screen.height/2.5),width:screen.width,height:screen.height/2.5))
        }else{
            myView=UIView(frame: CGRect(x:0, y:275, width:screen.width, height:screen.height-275))
            currentView.frame=CGRect(x: viewToShow.frame.origin.x, y:0, width: viewToShow.frame.size.width, height: viewToShow.frame.size.height)
        }
        myView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(overLayTap))
        myView.addGestureRecognizer(tap)
        canBeDismissed = dismiss
        myView.addSubview(currentView)
        self.window?.endEditing(true)//closes the keyboard if open
        self.window?.addSubview(myView)
    }

    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "NetSCAN", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func showOverlayWithView(viewToShow: UIView, dismiss: Bool, AccessToMenu:Bool){
        if( myView != nil && viewToShow.tag != 0901){
            doClose()
        }
        let screen=UIScreen.main.bounds
        currentView = viewToShow
        if !AccessToMenu {
            myView=UIView(frame: CGRect(x:0, y:0, width:screen.width, height:screen.height))
        } else {
            myView=UIView(frame: CGRect(x:0, y:275, width:screen.width, height:screen.height-275))
            currentView.frame=CGRect(x: viewToShow.frame.origin.x, y:0, width: viewToShow.frame.size.width, height: viewToShow.frame.size.height)
        }
        myView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(overLayTap))
        myView.addGestureRecognizer(tap)
        canBeDismissed = dismiss
        myView.addSubview(currentView)
        self.window?.endEditing(true)//closes the keyboard if open
        self.window?.addSubview(myView)
    }
    
    func overLayTap(){
        if (canBeDismissed == true) {
            AppDelegate.DialogsDismissClock.invalidate()
            doClose()
        }
    }
    
    func doClose() {
        if(self.myView != nil){
            self.myView.removeFromSuperview()
            doCloseMenuView()
        }
    }
    
    func ShowLoaderIndicatorView()
    {
        autoreleasepool(invoking:{
            if (loadingView == nil)
            {
                loadingView = UIView(frame: CGRect(x: 0, y:0, width:(UIScreen.main.bounds.size.width), height: (Constants.UIScreenMainHeight)))
                let BGview = UIView(frame : loadingView.bounds)
                BGview.alpha=0.5
                BGview.backgroundColor=PrimaryGrayColor()
                loadingView.addSubview(BGview)
                activityViewForLoader = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
                activityViewForLoader.frame = CGRect.init(x: ((UIScreen.main.bounds.size.width)-200)/2, y: ((Constants.UIScreenMainHeight)-200)/2, width: 200, height: 200)
                activityViewForLoader.backgroundColor=UIColor.clear
                BGview.addSubview(activityViewForLoader)
                activityViewForLoader.startAnimating()
                self.window?.addSubview(loadingView)
            }
        })
    }
    
    func hideLoadingIndicatorView (){
        if loadingView != nil {
            loadingView.removeFromSuperview()
            loadingView = nil
        }
    }
    
    func showMenuView(viewToShow: UIView){
        if( myMenuView != nil ){
            doCloseMenuView()
        }
        let screen=UIScreen.main.bounds
        myMenuView=UIView(frame: CGRect(x:0, y:0, width:screen.width, height:screen.height))
        currentView = viewToShow
        myMenuView.addSubview(currentView)
        self.window?.endEditing(true)
        self.window?.addSubview(myMenuView)
    }
    
    func doCloseMenuView() {
        if( myMenuView != nil ){
            self.myMenuView.removeFromSuperview()
        }
    }
    
    // MARK: - Token Expiry
    
    func preventTokenExpiration() {
        if UserDefaults.standard.value(forKey: "loginResponse") != nil{
            if tokenExpiryTimer != nil {
                tokenExpiryTimer.invalidate()
            }
            tokenExpiryTimer = Timer.scheduledTimer(timeInterval: Constants.FakeTrackingSeconds, target: self, selector: #selector(fetchFakeTracking), userInfo: nil, repeats: true)
        }
    }
    
    func fetchFakeTracking() {
        if UserDefaults.standard.value(forKey: "loginResponse") != nil {
            var dictionary: [String:String] = [:]
            var logInResponse = UserDefaultsManager().getLoginResponse()
            
            if let serviceId = UserDefaults.standard.value(forKey: "userID") {
                dictionary["user_id"] = serviceId as? String
            }
            
            if let companyID = UserDefaults.standard.value(forKey: "companyID") {
                dictionary["company_id"] = companyID as? String
            }
            
            if let apiKey = logInResponse.value(forKey: "api_key") {
                dictionary["api_key"] = apiKey as? String
            }
            
            var body = "{"
            
            body = body.appending("\"")
            body = body.appending("user_id")
            body = body.appending("\"")
            body = body.appending(":")
            body = body.appending("\"")
            body = body.appending(dictionary["user_id"]!)
            body = body.appending("\"")
            body = body.appending(",")
            
            body = body.appending("\"")
            body = body.appending("company_id")
            body = body.appending("\"")
            body = body.appending(":")
            body = body.appending("\"")
            body = body.appending(dictionary["company_id"]!)
            body = body.appending("\"")
            body = body.appending(",")
            
            body = body.appending("\"")
            body = body.appending("api_key")
            body = body.appending("\"")
            body = body.appending(":")
            body = body.appending("\"")
            body = body.appending(dictionary["api_key"]!)
            body = body.appending("\"")
            
            body = body.appending("}")

            let url = Constants.BagJourneyHost+Constants.revalidationEndPoint
            let stringToPost = String(format: "request=%@",body)
            ApiCallSwift().getResponseForURL(builtURL:url  as NSString, JsonToPost:stringToPost as NSString, isAuthenticationRequired: true, method: "post", errorTitle: "NoAlert", optionalValue: "", AndCompletionHandler:{ builtURL, response, statusCode, data, error in
                if response as? NSDictionary != nil {
                    if (response as? NSDictionary)?.value(forKey: "success") != nil {
                        if ((response as? NSDictionary)?.value(forKey: "success") as! Bool) {
                            print("(\((response as? NSDictionary)!)")
                            logInResponse = logInResponse.mutableCopy() as! NSMutableDictionary
                            logInResponse.setValue((response as? NSDictionary)?.value(forKey: "api_key"), forKey: "api_key")
                            UserDefaultsManager().saveLoginResponse(response: logInResponse)
                            self.preventTokenExpiration()
                        } else {
                            if self.tokenExpiryTimer != nil {
                                self.tokenExpiryTimer.invalidate()
                            }
                        }
                    }
                }
            })
        } else {
            if tokenExpiryTimer != nil {
                tokenExpiryTimer.invalidate()
            }
        }
    }

    func showTokenExpiryNotificationAfter(fireDate:Date) {
        if UserDefaults.standard.value(forKey: "loginResponse") != nil {
            let objNotificationContent = UNMutableNotificationContent()
            objNotificationContent.title = "Token will expire soon"
            objNotificationContent.body = "Please open the app to prevent the token from expiring."
            objNotificationContent.sound = UNNotificationSound.default()

            //Deliver the notification after fireDate
            let timeInterval = fireDate.timeIntervalSinceNow
            if timeInterval > 0 {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                let request = UNNotificationRequest(identifier: "tokenExpiry", content: objNotificationContent, trigger: trigger) // Schedule the notification.
                let center = UNUserNotificationCenter.current()
                center.add(request) {  (error : Error?) in
                    if error != nil {
                        // Handle any errors
                    }
                }
            }
        }
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        fetchFakeTracking()
    }
 }

func GetSimpleDialogView(LabelText:String,Image:Bool,Y:CGFloat) -> UIView {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = Constants.UIScreenMainHeight
    
    var labelHeight = (screenHeight/4) - 2
    
    let Dialog = UIView(frame:CGRect(x:0,y:Y,width:screenWidth,height:screenHeight/4))
    Dialog.backgroundColor=QueueBackgroundColor().withAlphaComponent(0.7)
    
    let border1 = CALayer()
    let width1 = CGFloat(2.0)
    border1.borderColor = SecondaryGrayColor().cgColor
    border1.frame = CGRect(x:0,y:0, width:Dialog.frame.size.width, height:width1)
    border1.borderWidth = width1
    
    let border2 = CALayer()
    let width2 = CGFloat(2.0)
    border2.borderColor = SecondaryGrayColor().cgColor
    border2.frame = CGRect(x:0,y:0, width:width2, height:Dialog.frame.size.height)
    border2.borderWidth = width2
    
    let border3 = CALayer()
    let width3 = CGFloat(2.0)
    border3.borderColor = SecondaryGrayColor().cgColor
    border3.frame = CGRect(x:0,y:Dialog.frame.size.height, width:Dialog.frame.size.width, height:width1)
    border3.borderWidth = width3
    
    let border4 = CALayer()
    let width4 = CGFloat(2.0)
    border4.borderColor = SecondaryGrayColor().cgColor
    border4.frame = CGRect(x:Dialog.frame.size.width-2,y:0, width:width2, height:Dialog.frame.size.height)
    border4.borderWidth = width4
    
    Dialog.layer.addSublayer(border1)
    Dialog.layer.addSublayer(border2)
    Dialog.layer.addSublayer(border3)
    Dialog.layer.addSublayer(border4)
    
    var color = UIColor.red
    var startY = CGFloat(1)
    if Image {
        let imageView = UIImageView(frame:CGRect(x:(screenWidth/2)-(Dialog.frame.size.height/8), y:Dialog.frame.size.height/4, width: Dialog.frame.size.height/4, height: Dialog.frame.size.height/4))
        imageView.image=UIImage(named: "password.png")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageView.tintColor = secondaryColor()
        
        Dialog.addSubview(imageView)
        startY = Dialog.frame.size.height*0.6
        labelHeight = ((screenHeight/4)-2) - startY
        color = UIColor.green
    }
    
    let textLabel = UILabel(frame:CGRect(x:10, y: startY, width:screenWidth-20, height:labelHeight))
    textLabel.text = LabelText
    textLabel.textColor = color
    textLabel.textAlignment=NSTextAlignment.center
    textLabel.numberOfLines=5
    textLabel.adjustsFontSizeToFitWidth=true
    Dialog.addSubview(textLabel)
    return Dialog
}

func GetColorFromHex(rgbValue:UInt32)->UIColor{
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    return UIColor(red:red, green:green, blue:blue, alpha:1.0)
}

func ShakeTextField(cell: UITextField) {
    let animation = CAKeyframeAnimation()
    animation.keyPath = "position.x"
    animation.values =  [0, 20, -5, 10, 0]
    animation.duration = 0.3
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    animation.isAdditive = true
    cell.layer.add(animation, forKey: "shake")
}

func primaryColor() -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return UIColor.black}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return UIColor.white}
    return UIColor.black
}

func secondaryColor() -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return UIColor.white}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return UIColor.black}
    return UIColor.white
}

func PrimaryGrayColor() -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return UIColor.darkGray}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return UIColor.gray}
    return UIColor.darkGray
}

func SecondaryGrayColor() -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return UIColor.gray}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return UIColor.darkGray}
    return UIColor.gray
}

func PrimaryBackroundViewColor() -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return GetColorFromHex(rgbValue: 0x4F4F4F)}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return UIColor.lightGray}
    return GetColorFromHex(rgbValue: 0x4F4F4F)
}

func PrimaryBoarder() -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return GetColorFromHex(rgbValue: 0xA9A9A9)}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return UIColor.black}
    return GetColorFromHex(rgbValue: 0xA9A9A9)
}

func AppHeaderBackgroundColor() -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return GetColorFromHex(rgbValue: 0x333333)}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return UIColor.lightGray}
    return GetColorFromHex(rgbValue: 0x333333)
}

func TextColorGray() -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return GetColorFromHex(rgbValue: 0xA9A9A9)}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return UIColor.darkGray}
    return GetColorFromHex(rgbValue: 0xA9A9A9)
}

func YellowColorInverted () -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return GetColorFromHex(rgbValue: 0xE6C200)}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return UIColor.black}
    return GetColorFromHex(rgbValue: 0xE6C200)
}

func OrangeColorInverted() -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return GetColorFromHex(rgbValue: 0xFFA500)}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return UIColor.black}
    return GetColorFromHex(rgbValue: 0xFFA500)
}

func ScannedItemPrimaryColor() -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return GetColorFromHex(rgbValue: 0x949a9d)}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return GetColorFromHex(rgbValue: 0x333333)}
    return GetColorFromHex(rgbValue: 0x949a9d)
}

func ScannedItemSecondaryColor() -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return GetColorFromHex(rgbValue:0x333333)}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return GetColorFromHex(rgbValue: 0x949a9d)}
    return GetColorFromHex(rgbValue:0x333333)
}

func BagDetailsBackgroundColor() -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return GetColorFromHex(rgbValue:0x2a2a2a)}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return UIColor.init(white: 1, alpha: 0.9)}
    return GetColorFromHex(rgbValue:0x2a2a2a)
}

func QueueBackgroundColor () -> UIColor {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return GetColorFromHex(rgbValue: 0x434343)}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return GetColorFromHex(rgbValue: 0xC8CACE)}
    return GetColorFromHex(rgbValue: 0x434343)
}

func QueueHeaderImage() -> UIImage {
    if (UserDefaults.standard.string(forKey: "colorMode") == "moonlight"){
        return UIImage(named:"scroll_header")!}
    else if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
        return UIImage(named:"scroll_header_2.png")!
        }
    return UIImage(named:"scroll_header")!
}

func SHA256(data : Data) -> Data {
    var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
    data.withUnsafeBytes {
        _ = CC_SHA256($0, CC_LONG(data.count), &hash)
    }
    return Data(bytes: hash)
}

func increptPassword (password:String) -> String {
    var input = Data(bytes: [UInt8](password.utf8))
    for _ in 0..<1001 {
        input = SHA256(data :input)
    }
    let base64String = input.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    return base64String
}

class MyCustomClass:NSObject{
    
    var timer = 10
    var clock = Timer()
    
    func StartCountDownTimer(seconds: Int, label: UILabel){
        timer = seconds
        clock.invalidate()
        clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MyCustomClass.countdown), userInfo: ["theLabel" :label], repeats: true)
        clock.fire()
    }
    
    func countdown(time :Timer) {
        let userInfo = time.userInfo as! Dictionary<String, AnyObject>
        let tempLabel:UILabel = (userInfo["theLabel"] as! UILabel)
        if(timer > 0){
            let minutes = String(timer / 60)
            let seconds = String(timer % 60)
            tempLabel.text = minutes + ":" + seconds
            tempLabel.text = String(format:"%02d:%02d", Int(timer/60),  Int(timer%60) )
            timer -= 1
        } else {
            tempLabel.text = "00:00"
            clock.invalidate()
        }
    }
}

 extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.height
    }
    
    func trailingTrim(_ characterSet : CharacterSet) -> String {
        if let range = rangeOfCharacter(from: characterSet, options: [.anchored, .backwards]) {
            return self.substring(to: range.lowerBound).trailingTrim(characterSet)
        }
        return self
    }
    
 }

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

 extension Date {
    func offsetFrom(date: Date) -> Int {
        let days: Set<Calendar.Component> = [.day]
        let differenceDays = (NSCalendar.current.dateComponents(days, from: date, to: self))
        return differenceDays.day!
    }
 }
 
class Constants {
    
    // MARK: List of Constants

    static let BorderColor     = 0xA9A9A9
    static let BackgroundColor = 0x333333
    static let TextColorGray   = 0xA9A9A9
    static let TextColorRed    = 0xff0000
    static let Orange          = 0xFFA500
    static let endColor        = 0x070707
    static let centerColor     = 0x292929
    static let startColor      = 0x070707
    static let gradientRadius  = "10"
    static let BagsContainersGridViewColor = 0x434343
    static let TrackingPointExpiry  = 3600 //seconds
    static let FakeTrackingSeconds = 1500.0 // seconds
    static let TimeIntervalForOneYear = 31104000 // seconds
    static let UIScreenMainHeight = UIScreen.main.bounds.size.height
    static let StartingY = CGFloat(20)
    
    //static let BagJourneyHost = "https://57.191.0.148/baggage"
    
    //QA end points and key
    
    
    #if NetScanQA
    static let BagJourneyHost = "https://57.191.0.217/baggage"
//    static let BagJourneyAPIKeyhistory = "8f24282be5c9b02a3066a3467d0832ab"

    #else
    //Production end points and key
    static let BagJourneyHost = "https://bagjourney.sita.aero/baggage"
//    static let BagJourneyAPIKeyhistory = "bb0fcf1ffcf7d2348729ff37315c8436"

    #endif

    
    static let BagJourneyAPIKeyhistory = "bb0fcf1ffcf7d2348729ff37315c8436"
    
    static let BagInfoEndPoint = "/history/v1.0/tag/%@/flightdate/%@"
    static let BagTrackingEndPoint = "/tracking/v1.0"
    static let LogInEndPoint = "/applogin/v1.0"
    static let LogOutEndPoint = "/applogout/v1.0"
    static let ChangePasswordEndPoint = "/resetpassword/v1.0"
    static let trackingConfigurationEndPoint = "/trackingconfiguration/v1.0/service_id/%@/airport_code/%@"
    static let revalidationEndPoint = "/revalidateapikey/v1.0"
}
