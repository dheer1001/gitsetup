//
//  ConnectivityTestClass.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 1/16/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class ConnectivityTestClass: UIViewController {
    
    var StillSearchingForScanner : Bool = true
    var ScannerConnectionFlag:Bool = false
    let SuccessFlage:Bool = false;
    var IsLoggingIn:Bool = false
    
    var ScannerConnectivityTimer:Timer!
    var Consumer:Timer!
    
    var CognexManager : CognexScannerManagerClass!
    var SocketMobile : SocketMobileScannerManager!
    var LoaderView : NVActivityIndicatorView!
    var bingoView : BingoViewController!
    var bingoInformationView:BingoInformationView!
    
    var buttonsContainerView:UIView!
    var ConnectionFailedView:UIView!
    var ConnectingView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden=true
    }
    override func viewWillAppear(_ animated: Bool)
    {
        ScannerConnectionFlag = false
        StillSearchingForScanner = true
        IsLoggingIn = true
        AppDelegate.ShouldReturnToTestingScannerConnectivityView=true
        self.view.backgroundColor=primaryColor()
        self.view.addSubview(LoadConnectingView())
        AppDelegate.getDelegate().InitializeScanManager()
        DoConnectivityTest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (ConnectionFailedView != nil){
            ConnectionFailedView.removeFromSuperview()
            ConnectionFailedView = nil
        }
        if (ConnectingView != nil){
            ConnectingView.removeFromSuperview()
            ConnectingView = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func LoadConnectingView() -> UIView {
        
        let screenHeight = Constants.UIScreenMainHeight
        let screenWidth = UIScreen.main.bounds.width
        let space = screenHeight/33.35
        var startY=CGFloat(0)
        let viewHeight = 180+(2*space)
        
        ConnectingView = UIView(frame: CGRect(x:0, y:(screenHeight/2)-(viewHeight/2), width:screenWidth, height:viewHeight))
        
        let image :UIImage = UIImage.init(named: "bar-code-scanner")!
        let flippedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: UIImageOrientation.upMirrored)
        
        let ScannerImageView = UIImageView.init(frame: CGRect.init(x:(screenWidth/2)-50, y:startY, width:100, height:100))
        ScannerImageView.image = flippedImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ScannerImageView.tintColor = secondaryColor()
        ConnectingView.addSubview(ScannerImageView)
        startY += ScannerImageView.frame.size.height+space
        
        LoaderView = NVActivityIndicatorView(frame:CGRect(x:(screenWidth/2)-25, y:startY, width:50, height:50), type: NVActivityIndicatorType.ballPulse, color:secondaryColor(), padding:0)
        LoaderView.startAnimating()
        ConnectingView.addSubview(LoaderView)
        startY += LoaderView.frame.size.height+space
        
        let TitleLabel = UILabel.init(frame: CGRect.init(x:20, y:startY, width: screenWidth-40, height:30))
        TitleLabel.numberOfLines=2
        TitleLabel.textColor=secondaryColor()
        TitleLabel.text="connectingScanner".localized
        TitleLabel.textAlignment=NSTextAlignment.center
        ConnectingView.addSubview(TitleLabel)
        
        return ConnectingView
    }
    
    func loadConnectionFailedView() -> UIView {
        
        ConnectionFailedView = UIView()
        ConnectionFailedView.frame=UIScreen.main.bounds
        
        let screenHeight = Constants.UIScreenMainHeight
        let screenWidth = UIScreen.main.bounds.width
        let startY=CGFloat(((screenHeight/2+((screenHeight/3.5)/2))/2)-110)
        
        let ImageViewContainer = UIView(frame: CGRect(x: 0, y:startY, width: screenWidth, height:220))
        ConnectionFailedView.addSubview(ImageViewContainer)
        
        let image :UIImage = UIImage.init(named: "bar-code-scanner")!
        let flippedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: UIImageOrientation.upMirrored)
        
        let ScannerImageView = UIImageView.init(frame: CGRect.init(x:(screenWidth/2)-50, y:30, width:100, height:100))
        ScannerImageView.image = flippedImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ScannerImageView.tintColor = secondaryColor()
        ImageViewContainer.addSubview(ScannerImageView)
        
        let connectionImage :UIImage = UIImage.init(named: "couldNotConnect.png")!
        let connectionFlippedImage = UIImage(cgImage: connectionImage.cgImage!, scale: connectionImage.scale, orientation: UIImageOrientation.upMirrored)
        
        let ConnectionImageView = UIImageView.init(frame: CGRect.init(x:ScannerImageView.frame.origin.x-30, y:0, width:ScannerImageView.frame.size.width+60, height:ScannerImageView.frame.size.height+60))
        ConnectionImageView.image = connectionFlippedImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        if (UserDefaults.standard.string(forKey: "colorMode") == "sunlight") {
            ConnectionImageView.tintColor = PrimaryGrayColor()
        } else {
            ConnectionImageView.tintColor = OrangeColorInverted()
        }
        ImageViewContainer.addSubview(ConnectionImageView)
        
        let TitleLabel = UILabel.init(frame: CGRect.init(x:20, y:ConnectionImageView.frame.size.height+10, width: screenWidth-40, height:60))
        TitleLabel.numberOfLines=2
        TitleLabel.textColor=secondaryColor()
        TitleLabel.text = "couldNotConnected".localized
        TitleLabel.textAlignment=NSTextAlignment.center
        ImageViewContainer.addSubview(TitleLabel)
        
        ConnectionFailedView.addSubview(LoadButtons())
        
        return ConnectionFailedView
    }
    
    func LoadButtons() -> UIView {
        
        let screenHeight = Constants.UIScreenMainHeight
        let screenWidth = UIScreen.main.bounds.width
        let space = screenHeight/33.35
        let startX=screenWidth/13.39
        var startY=CGFloat(0)
        
        buttonsContainerView = UIView(frame: CGRect(x:0, y:screenHeight/2+((screenHeight/3.5)/2), width:screenWidth, height:screenHeight/3.5))
        
        let SetupButton = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
        SetupButton.setTitle("set_up".localized.uppercased(), for:UIControlState.normal)
        SetupButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        SetupButton.layer.borderColor = PrimaryBoarder().cgColor
        SetupButton.layer.borderWidth = 1
        SetupButton.layer.cornerRadius=10
        SetupButton.clipsToBounds=true
        SetupButton.backgroundColor=PrimaryGrayColor()
        SetupButton.addTarget(self, action: #selector(SetupPressed), for: .touchUpInside)
        buttonsContainerView.addSubview(SetupButton)
        startY += SetupButton.frame.height+space
        
        let ResetButton = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
        ResetButton.setTitle("reset_scanner".localized.uppercased(), for:UIControlState.normal)
        ResetButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        ResetButton.layer.borderColor = PrimaryBoarder().cgColor
        ResetButton.layer.borderWidth = 1
        ResetButton.layer.cornerRadius=10
        ResetButton.clipsToBounds=true
        ResetButton.backgroundColor=PrimaryGrayColor()
        ResetButton.addTarget(self, action: #selector(ResetPressed), for: .touchUpInside)
        buttonsContainerView.addSubview(ResetButton)
        startY += ResetButton.frame.height+space
        
        let CancelButton = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
        CancelButton.setTitle("cancel".localized.uppercased(), for:UIControlState.normal)
        CancelButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        CancelButton.layer.borderColor = PrimaryBoarder().cgColor
        CancelButton.layer.borderWidth = 1
        CancelButton.layer.cornerRadius=10
        CancelButton.clipsToBounds=true
        CancelButton.addTarget(self, action: #selector(CancelPressed), for: .touchUpInside)
        buttonsContainerView.addSubview(CancelButton)
        
        return buttonsContainerView
    }
    
    func SetupPressed() {
        let SetUpView = SetupViewController()
        self.navigationController?.pushViewController(SetUpView, animated: false)
    }
    
    func ResetPressed() {
        let ResetView = ResetViewController()
        self.navigationController?.pushViewController(ResetView, animated: false)
    }
    
    func CancelPressed() {
        AppDelegate.getDelegate().ReturnToLogin()
    }
    
    //---------------Devicies connectivity test--------------------------
    func DoConnectivityTest()
    {
        if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            DoSocketMobileScannerTest()
        }
        else if (UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            DoCognexScannerTest()
        }
        else if (UserDefaults.standard.string(forKey: "scannerType") == "softScanner".localized){
            DoSoftScannerTest()
        }
        ScannerConnectivityTimer = Timer.scheduledTimer(timeInterval:10, target:self, selector:#selector(ConnectivityStatus), userInfo:nil, repeats:false)
    }
    
    func DoSoftScannerTest()
    {
        ScannerConnectionSuccess()
    }
    
    func DoCognexScannerTest()
    {
        if(CognexManager == nil || CognexManager.readerDevice?.dataManSystem() == nil){
            CognexManager = CognexScannerManagerClass()
            CognexManager.Initialize()
        }
        else if (CognexManager.readerDevice?.connectionState == CMBConnectionStateConnected) {
            ConnectivityStatus()
        }
    }
    
    func DoSocketMobileScannerTest ()
    {
        if(SocketMobile == nil || SocketMobile.ApiHelper == nil){
            SocketMobile = SocketMobileScannerManager()
            SocketMobile.initialize()
        }
        else if (SocketMobile.ApiHelper != nil && SocketMobile.ApiHelper.isDeviceConnected()){
            ConnectivityStatus()
        }
    }
    
    //----------------Connectivity Status--------------------
    func ConnectivityStatus()
    {
        if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            if(ScannerConnectionFlag==false){
                if(SocketMobile.ApiHelper.isDeviceConnected()){
                    ScannerConnectionSuccess()
                }else{
                    ScannerConnectionFalied()
                }
            }
        }
        else if (UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            if CognexManager.readerDevice?.dataManSystem() != nil{
                if CognexManager.readerDevice?.connectionState == CMBConnectionStateConnected {
                    CognexManager.continuesMode(ON_OFF: false)
                    ScannerConnectionSuccess()
                }else{
                    ScannerConnectionFalied()
                }
            }else{
                ScannerConnectionFalied()
            }
        }
    }
    
    func ScannerConnectionSuccess(){
        if (ScannerConnectionFlag == false){
            Timer.scheduledTimer(timeInterval: 2, target:self, selector:#selector(NavigateToMainView), userInfo:nil, repeats:false)
        }
    }
    
    func ScannerConnectionFalied(){
        if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized || UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            ConnectingView.removeFromSuperview()
            self.view.addSubview(loadConnectionFailedView())
            self.view.setNeedsDisplay()
        }
    }
    
    func NavigateToMainView(){
        AppDelegate.IsUSerINMainView=true
        ScannerConnectionFlag=true
        AppDelegate.vc.ConnectivityView.IsLoggingIn=true
        self.navigationController?.pushViewController(AppDelegate.vc.MainViewControllerPointer, animated: true)
    }
    
    func postBeepForTrackingUnrecoverableError(){
        if (UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized){
            CognexManager.dataManBeep()
        }
        else if (UserDefaults.standard.string(forKey: "scannerType") == "socket_mobile_bt".localized){
            SocketMobile.socketMobileBeep()
        }
    }
    
    //----------------SocketMobileProtocol------------------
    func DeviceArrival(){
        ScannerConnectivityTimer.invalidate()
        ScannerConnectionSuccess()
    }
}

