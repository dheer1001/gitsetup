//
//  MainViewController.swift
//  NetSCAN
//
//  Created by User on 9/29/16.
//  Copyright © 2016 User. All rights reserved.
//

import Foundation
import CoreBluetooth
import AVFoundation

class MainViewController:UIViewController,CBCentralManagerDelegate {
    
    public static var AppHeaderInstance:AppHeaderViewController=AppHeaderViewController()
    public static var AppHintsInstance:AppHintsViews=AppHintsViews()
    public static var NetworkStatus :Bool = false
    public static var SyncedFlag :Bool = false
    public static var shouldReload :Bool = true

    var ScannedItemsViewsInstance=ScannedItemsViews()
    var locationSuccessTimer:Timer=Timer()
    
    var MenuView=UIView()
    var ContainerView = UIView()
    var QueueScrollView = UIView()
    var FetchingBagView = UIView()
    var LocationSuccessView=UIView()
    var DeviceConnectionView=UIView()
    var FlightInformationView=UIView()
    var ContainerIdentifierView=UIView()
    var InternetConnectionView=UIView()
    var BluetoothReqiuredView = UIView()
    var FligthAirPlaneInformationView=UIView()
    var bannerView:UIView!
    
    var centralManager:CBCentralManager!
    var SoftScannerViewController = UIViewController()
    
    var headerGestureView : UIView!
    
    var locationGestureView : UIView!
    var airlinesGestureView : UIView!
    var airportsGestureView : UIView!
    var softScanGestureView : UIView!
    
    var locationGestureTap : UITapGestureRecognizer!
    var airlinesGestureTap : UITapGestureRecognizer!
    var airportsGestureTap : UITapGestureRecognizer!
    var softScanGestureTap : UITapGestureRecognizer!
    
    override func viewDidLoad(){
        self.view.backgroundColor=primaryColor()
        self.navigationController?.isNavigationBarHidden=true
        AppDelegate.getDelegate().InitializeScanManager()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        _ = Timer.scheduledTimer(timeInterval:0.5, target: self, selector: #selector(reachabilityChanged), userInfo: nil, repeats: true)
        _ = Timer.scheduledTimer(timeInterval:0.7, target: self, selector: #selector(SyncBagsWhenInternetIsAvailable), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self, selector: #selector(ShowChangePasswordView), name: NSNotification.Name(rawValue: "ShowChangePasswordView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DismissPasswordView), name: NSNotification.Name(rawValue: "DismissPasswordView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissScannerView), name: NSNotification.Name(rawValue: "dismissScannerView"), object: nil)
        
        locationGestureTap = UITapGestureRecognizer(target: self, action: #selector(locationGestureTapFunc))
        airlinesGestureTap = UITapGestureRecognizer(target: self, action: #selector(airlinesGestureTapFunc))
        airportsGestureTap = UITapGestureRecognizer(target: self, action: #selector(airportsGestureTapFunc))
        softScanGestureTap = UITapGestureRecognizer(target: self, action: #selector(OfflineScanner))
        
        headerGestureView = UIView(frame: CGRect(x:0,y:UIApplication.shared.statusBarFrame.height,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.width/12+73))
        
        
        airportsGestureView = UIView(frame:CGRect(x:0, y: UIScreen.main.bounds.size.width/15+30, width:UIScreen.main.bounds.size.width/3, height:(UIScreen.main.bounds.width/12+73)-UIScreen.main.bounds.size.width/15+30))
        airportsGestureView.addGestureRecognizer(airportsGestureTap)
        headerGestureView.addSubview(airportsGestureView)
        
        locationGestureView = UIView(frame: CGRect(x:UIScreen.main.bounds.width/3, y:0, width:UIScreen.main.bounds.width/3, height:UIScreen.main.bounds.width/12+73))
        locationGestureView.addGestureRecognizer(locationGestureTap)
        headerGestureView.addSubview(locationGestureView)
        
        airlinesGestureView = UIView(frame:CGRect(x:(UIScreen.main.bounds.width/3)*2, y: UIScreen.main.bounds.size.width/15+30, width:UIScreen.main.bounds.size.width/3, height:(UIScreen.main.bounds.width/12+73)-UIScreen.main.bounds.size.width/15+30))
        airlinesGestureView.addGestureRecognizer(airlinesGestureTap)
        headerGestureView.addSubview(airlinesGestureView)
        
        if (UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
            softScanGestureView = UIView(frame:CGRect(x:0, y: 0, width:UIScreen.main.bounds.size.width/3, height:UIScreen.main.bounds.size.width/15+30))
            softScanGestureView.addGestureRecognizer(softScanGestureTap)
            headerGestureView.addSubview(softScanGestureView)
        }
        
        self.view.addSubview(headerGestureView)
    }
    
    func locationGestureTapFunc() {
        print("locationGestureTapFunc")
        MainViewController.AppHeaderInstance.selectTrackingPointPressed()
    }
    
    func airlinesGestureTapFunc() {
        print("airlinesGestureTapFunc")
        MainViewController.AppHeaderInstance.AirlinesTapped()
    }
    
    func airportsGestureTapFunc() {
        print("airportsGestureTapFunc")
        MainViewController.AppHeaderInstance.AirportsTapped()
    }
    
    override func viewWillAppear(_ animated: Bool){
        MainViewController.AppHeaderInstance=AppHeaderViewController()
        MainViewController.AppHeaderInstance.view.isUserInteractionEnabled = false
        MainViewController.AppHeaderInstance.view.frame=CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.width/12+73)
        headerGestureView.addSubview(MainViewController.AppHeaderInstance.view)
        AppDelegate.IsUSerINMainView = true;
        AppDelegate.ShouldReturnToTestingScannerConnectivityView=false
        if(UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            centralManager = CBCentralManager.init(delegate: self, queue:nil)
            if((AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper != nil) && AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper.isDeviceConnected()){
                MainViewController.AppHeaderInstance.scannerConnected()
            }
            AppDelegate.getDelegate().ScanManagerReturnFromBackground()
        }
        if (UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            if(AppDelegate.vc.ConnectivityView.CognexManager != nil){
                if(AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem() != nil){
                    if(AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.connectionState == CMBConnectionStateConnected){
                        AppDelegate.vc.ConnectivityView.CognexManager.ON_OFF_PDF417(ON_OFF:"ON")
                        AppDelegate.getDelegate().ScanManagerReturnFromBackground()
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor=primaryColor()
        if (MainViewController.shouldReload){
            if (UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
                MainViewController.AppHeaderInstance.scannerConnected()
                AppDelegate.getDelegate().ScanManagerReturnFromBackground()
            }
        } else {
            MainViewController.shouldReload=true
            AppDelegate.getDelegate().showMenuView(viewToShow: MenuView)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.IsUSerINMainView = false
    }
    func reachabilityChanged(){
        let reachability:Reachability = Reachability()!
        if reachability.isReachable{
            RemoveINternetVeiw()
            MainViewController.AppHeaderInstance.internetOnline()
            MainViewController.NetworkStatus = true
        }else{
            AddINternetVeiw()
            MainViewController.AppHeaderInstance.internetOffline()
            MainViewController.NetworkStatus = false
            MainViewController.SyncedFlag=false
        }
    }
    
    func ReturnNetworkStatus() -> Bool{
        return MainViewController.NetworkStatus
    }
    
    func SyncBagsWhenInternetIsAvailable(){
        if(MainViewController.NetworkStatus && !MainViewController.SyncedFlag){
            AppDelegate.getDelegate().ScanManagerInstance.processScannedItemsQueue()
            AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems:UserDefaultsManager().getAllBagsFromCoredata()!, LastItemScaned: nil)
            MainViewController.SyncedFlag = true
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        print(central.state.rawValue)
        switch (central.state.rawValue) {
        case 4:
            if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized && AppDelegate.IsUSerINMainView == true){
                print("CoreBluetooth BLE hardware is powered off")
                self.AddBluetoothReqiuredView()
            }
            break;
        case 5:
            if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized && AppDelegate.IsUSerINMainView == true){
                print("CoreBluetooth BLE hardware is powered on and ready")
                self.RemoveBluetoothReqiuredView()
                AppDelegate.getDelegate().ScanManagerReturnFromBackground()
            }
            break;
        default:
            break;
        }
    }
    
    func RemoveINternetVeiw(){
        if (MainViewController.NetworkStatus==false){
            RemoveInternetConnectionView()
        }
    }
    
    func AddINternetVeiw(){
        if (MainViewController.NetworkStatus==true){
            if(AppDelegate.getDelegate().ScanManagerInstance.IsStillValidTrackingLocation()){
                if((AppDelegate.getDelegate().GetLoadStatus(TrackingLocation : UserDefaultsManager().GetTrackingLocation()) == "B") || (AppDelegate.getDelegate().getUnknownBags(scannedBarcode: UserDefaultsManager().GetTrackingLocation()) == "U")){
                    AddInternetConnectionView()
                }
            }
        }
    }
    
    func removeBannerView() {
        if (bannerView != nil){
            bannerView.removeFromSuperview()
            bannerView = nil
        }
    }
    
    func AddScanTrackingPointView(){
        bannerView=MainViewController.AppHintsInstance.getScanTrackingPointView()
        self.view.addSubview(bannerView)
    }
    
    func AddContainerRequiredView(){
        bannerView = MainViewController.AppHintsInstance.getContainerRequiredView()
        self.view.addSubview(bannerView)
    }
    
    func AddStartScanningBagsView(){
        bannerView=MainViewController.AppHintsInstance.getStartScanningBagsView()
        self.view.addSubview(bannerView)
    }
    
    func AddContainerIdentifierView(){
        if (AppDelegate.IsUSerINMainView){
            AppDelegate.containerIdentifierPresented = true
            ContainerIdentifierView=MainViewController.AppHintsInstance.getContainerIdentifiedView()
            AppDelegate.getDelegate().showOverlayWithViewSoftScanner(viewToShow: ContainerIdentifierView, dismiss: false)
        }
    }
    
    func RemoveContainerIdentifierView(){
        AppDelegate.getDelegate().doClose()
        AppDelegate.containerIdentifierPresented = false // for deny oppening softScan while container identifier doesn't dismessed
        ContainerIdentifierView.removeFromSuperview()
        self.reloadInputViews()
    }
    
    func AddLocationSuccessView(trakingLoction:String ,Seconds:Int){
        LocationSuccessView=MainViewController.AppHintsInstance.getLocationIdentifiedView(location: trakingLoction)
        AppDelegate.getDelegate().showOverlayWithView(viewToShow: LocationSuccessView, dismiss: false, AccessToMenu: false)
        locationSuccessTimer = Timer.scheduledTimer(timeInterval:1.5, target: self, selector: #selector(RemoveLocationSuccessView), userInfo: nil, repeats: false)
        MainViewController.AppHeaderInstance.StartCountDownTimer(seconds: Seconds)
        MainViewController.AppHeaderInstance.SetLocation(location: trakingLoction)
        self.view.backgroundColor=primaryColor()
    }
    
    func UpdateLocationOnAppHeader(seconds:Int,trackingLocation:String){
        if seconds >= 0 {
            MainViewController.AppHeaderInstance.StartCountDownTimer(seconds: seconds)
            MainViewController.AppHeaderInstance.SetLocation(location: trackingLocation)
        } else if seconds >= -Constants.TimeIntervalForOneYear{
            MainViewController.AppHeaderInstance.StartCountDownTimer(seconds: 0)
        }
    }
    
    func RemoveLocationSuccessView(){
        LocationSuccessView.removeFromSuperview()
        if (AppDelegate.getDelegate().getTypeEvent(scannedBarcode:ScanManager.LocalStorage.GetTrackingLocation()) == "B"){
            AppDelegate.getDelegate().ScanManagerInstance.BingoMode()
        } else {
            AppDelegate.getDelegate().LocationSuccessViewDismissed()
        }
    }
    
    func AddFetchingBagView(){
        FetchingBagView=MainViewController.AppHintsInstance.getFetchingBagView()
        AppDelegate.getDelegate().showOverlayWithView(viewToShow: FetchingBagView, dismiss: false, AccessToMenu: false)
    }
    
    func RemoveFetchingBagView(){
        AppDelegate.getDelegate().doClose()
    }
    
    func AddDeviceConnectionView(){
        if (AppDelegate.IsUSerINMainView){
            DeviceConnectionView=MainViewController.AppHintsInstance.getDeviceConnectionView(status:"Not Connected")
            AppDelegate.getDelegate().showOverlayWithView(viewToShow: DeviceConnectionView, dismiss: false, AccessToMenu: false)
        }
    }
    
    func AddBluetoothReqiuredView(){
        BluetoothReqiuredView = MainViewController.AppHintsInstance.getBluetoothRequiredView()
        AppDelegate.getDelegate().showOverlayWithView(viewToShow: BluetoothReqiuredView, dismiss: false, AccessToMenu: false)
    }
    
    func RemoveBluetoothReqiuredView(){
        AppDelegate.getDelegate().doClose()
        BluetoothReqiuredView.removeFromSuperview()
    }
    
    func RemoveDeviceConnectionView(){
        DeviceConnectionView.removeFromSuperview()
    }
    
    func AddInternetConnectionView(){
        AppDelegate.getDelegate().DisableCodesNeedToInternet()
        self.RemoveOfflineScannerView()
        InternetConnectionView=MainViewController.AppHintsInstance.getInternetConnectionView(status:"Not Connected")
        AppDelegate.getDelegate().showOverlayWithView(viewToShow: InternetConnectionView, dismiss: false, AccessToMenu: true)
    }
    
    func RemoveInternetConnectionView(){
        InternetConnectionView.removeFromSuperview()
        AppDelegate.getDelegate().doClose()
        AppDelegate.getDelegate().ScanManagerInstance.OnReturnFromBackGround()
    }
    
    func AddFlightAditionalView(bagView:Bool,bagNumber:String , unknownBag:String){
        AppDelegate.getDelegate().doCloseMenuView()
        let frame = self.view.frame
        FlightInformationView=InformationView.init(frame: CGRect.init(x:0, y: 0, width:frame.width, height:frame.height), bagView:bagView, bagNumber:bagNumber,Unknownbag: unknownBag)
        AppDelegate.getDelegate().showOverlayWithView(viewToShow: FlightInformationView, dismiss:false, AccessToMenu: false)
        if(AppDelegate.BackgrounModeAttribute){
            AppDelegate.vc.ConnectivityView.SocketMobile.ApiHelper.postSetDataConfirmation(atBackground: AppDelegate.vc.ConnectivityView.SocketMobile.Device, target: self, response: nil)
            if(AppDelegate.ScanningBagTag == ""){
                AppDelegate.LocalNotificationMessage="notification_enterflightInfo".localized
                AppDelegate.getDelegate().ScanManagerInstance.registerLocal(sender: self)
                AppDelegate.getDelegate().ScanManagerInstance.scheduleLocal(sender: self)
            }
            AppDelegate.ScanningBagTag = bagNumber
        }
    }
    
    func RemoveFlightInformationView(){
        AppDelegate.getDelegate().doClose()
        AppDelegate.getDelegate().CheckIfContainerInputRequierd()
    }
    
    func AddQueueScrollView(scannedItemsArray: NSArray,LastItem:Bag?){
        AppDelegate.getDelegate().doCloseMenuView()
        QueueScrollView.removeFromSuperview()
        QueueScrollView = ScannedItemsViewsInstance.getScannedItemsScrollView(scannedItemsArray: scannedItemsArray,lastItemScanned:LastItem)
        
        if (UIScreen.main.bounds.size.height>600) {
            QueueScrollView.frame = CGRect(x: QueueScrollView.frame.origin.x, y: QueueScrollView.frame.origin.y-60, width: QueueScrollView.frame.size.width, height: QueueScrollView.frame.size.height)
        } else {
            QueueScrollView.frame = CGRect(x: QueueScrollView.frame.origin.x, y: QueueScrollView.frame.origin.y-30, width: QueueScrollView.frame.size.width, height: QueueScrollView.frame.size.height)
        }
        self.view.addSubview(QueueScrollView)
    }
    
    func AddContainerView(containerName:String, desription:String, size:String, countour:String, type:String){
        AppDelegate.vc.MainViewControllerPointer.RemoveContainerView()
        ContainerView=ScannedItemsViewsInstance.getContainerView(containerName: containerName, desription: desription, size: size, countour: countour, type: type)
        self.view.addSubview(ContainerView)
    }
    
    func RemoveContainerView(){
        ContainerView.removeFromSuperview()
    }
    
    func AddFligthAirPlaneInformationView(info: String){
        FligthAirPlaneInformationView.removeFromSuperview()
        FligthAirPlaneInformationView = MainViewController.AppHintsInstance.getFlightInformationView(info:info)
        self.view.addSubview(FligthAirPlaneInformationView)
//        if (UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
//            AppDelegate.vc.MainViewControllerPointer.view.addSubview(SoftScannerViewController.view)
//        }
    }
    
    func RemoveFligthAirPlaneInformationView(){
        FligthAirPlaneInformationView.removeFromSuperview()
    }
    
    func handleTap() {
        var BoolContainer = false
        var BoolFligth = false
        var BoolTracking = false
        if(UserDefaultsManager().GetTrackingLocation() != ""){
            BoolTracking = true
        }
        if(UserDefaultsManager().getFlightNumber() != ""){
            BoolFligth = true
        }
        if(UserDefaultsManager().GetContainerID() != ""){
            BoolContainer = true
        }
        MenuView=MainViewController.AppHintsInstance.getMenuItemsView(hasContainer: BoolContainer, hasFlight: BoolFligth, hasTrackingPoint: BoolTracking)
        AppDelegate.getDelegate().showMenuView(viewToShow: MenuView)
    }
    
    func ShowChangePasswordView() {
        let passView : ChangePasswordViewController = ChangePasswordViewController()
        self.present(passView, animated: true)
    }
    
    func DismissPasswordView() {
        MainViewController.shouldReload=false;
        self.dismiss(animated: true)
    }
    
    // MARK: - SoftScanner
    func RemoveOfflineScanner(){
        SoftScannerViewController.view.removeFromSuperview()
    }
    
    func RemoveOfflineScannerView(){
        SoftScannerViewController.view.removeFromSuperview()
    }
    
    func OfflineScanner(){
        let status:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType:AVMediaTypeVideo)
        if (status == .authorized){
        MainViewController.AppHeaderInstance.scannerConnected()
        if(UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized && !AppDelegate.containerIdentifierPresented){
            self.OpenSoftScaner()
            }
        } else {
            let permission = PermissionsView()
            if (status == .notDetermined){
                permission.permissionType = "cameraNotdetermined"
            } else {
                permission.permissionType = "cameraDisabled"
            }
            AppDelegate.vc.ConnectivityView.navigationController?.pushViewController(permission, animated: false)
        }
    }
    
    func OpenSoftScaner() {
        AppDelegate.getDelegate().doClose()
        locationSuccessTimer.invalidate()
        let SoftScaner = SoftScannManager()
        SoftScaner.fullScreen=true
        self.present(SoftScaner, animated: false, completion: nil)
    }
    
    @objc func dismissScannerView() {
        self.dismiss(animated: false, completion: nil)
       MainViewController.AppHeaderInstance.scannerConnected()
    }
}
