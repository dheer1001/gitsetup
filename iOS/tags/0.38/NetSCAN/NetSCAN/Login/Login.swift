//
//  ViewController.swift
//  NetSCAN
//
//  Created by User on 9/15/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit
import UserNotifications

class Login: UIViewController , UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate{
    
    @IBOutlet var MainView: UIView!
    @IBOutlet var ScrollView: UIScrollView!
    @IBOutlet var SitaImageView: UIImageView!
    @IBOutlet var StartButton: UIButton!
    @IBOutlet var ScannerTextField: UITextField!
    @IBOutlet var CopyrightLabel: UILabel!
    var pageControl: UIPageControl = UIPageControl()

    public var MainViewControllerPointer = MainViewController()
    public var ConnectivityView = ConnectivityTestClass()
    
    var isVisible = false
    var dialog :UIView!
    var tempUserID:String!
    var tempCompanyID:String!
    var separator1 = UITextField()
    var separator2 = UITextField()
    var textFieldsContainer = UIView()
    var userNameTextField = UITextField()
    var companyIDTextField = UITextField()
    var passwordTextField = UITextField()
    var loginContainer = UIView()
    var remainigUnsyncedBagsView:UIView!
    var tempoAirlines = NSArray()
    var tempoAirports = NSArray()
    var tempoUserID = String()
    var tempoResponse : [String:Any] = [:]
    
    override func viewWillAppear(_ animated: Bool){
        AppDelegate.getDelegate().doClose()
        AppDelegate.getDelegate().doCloseMenuView()
        LoadComponents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.passwordTextField.text=""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((UserDefaults.standard.string(forKey: "scannerType")) == nil){
            UserDefaults.standard.setValue("softScanner".localized, forKey: "scannerType")
        }
        
        AppDelegate.getDelegate().window?.backgroundColor=UIColor.white
        self.navigationController?.isNavigationBarHidden=true
        LoadComponents()
        self.navigationManager()
    }
    
    func navigationManager() {
        MainViewControllerPointer = MainViewController()
        if (NavigateToExpectedClass() != self){
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { (settings) in
                if(settings.authorizationStatus == .authorized){
                    self.navigationController?.pushViewController(self.NavigateToExpectedClass(), animated:false)
                }else{
                    let permission = PermissionsView()
                    permission.permissionType = "notifNotDetermined"
                    self.navigationController?.pushViewController(permission, animated: false)
                }
            }
        } else {
            LoadComponents()
        }
    }
    
    func LoadComponents() {
        
        self.ScrollView.frame=CGRect(x: 0,y:Constants.StartingY,width: UIScreen.main.bounds.width,height: Constants.UIScreenMainHeight+200)
        ScrollView.isScrollEnabled=true
        self.ScrollView.backgroundColor=primaryColor()
        let gesture1 : UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(PageControllerChanged))
        gesture1.direction=UISwipeGestureRecognizerDirection.right
        let gesture2 : UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(PageControllerChanged))
        gesture2.direction=UISwipeGestureRecognizerDirection.left
        self.ScrollView.addGestureRecognizer(gesture1)
        self.ScrollView.addGestureRecognizer(gesture2)
        
        SitaImageView.frame=CGRect(x:UIScreen.main.bounds.width/4,y:(Constants.UIScreenMainHeight/6)-30,width: UIScreen.main.bounds.width/2,height: Constants.UIScreenMainHeight/12)
        SitaImageView.image = SitaImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        SitaImageView.tintColor = secondaryColor()
        
        var userID = ""
        var companyID = ""
        // login view
        if (tempUserID != nil){
            userID = tempUserID
            tempUserID = nil
        }else if (UserDefaults.standard.string(forKey: "userID") != nil){
            userID = UserDefaults.standard.string(forKey: "userID")!
        }
        if (tempCompanyID != nil){
            companyID = tempCompanyID
            tempCompanyID = nil
        }else if (UserDefaults.standard.string(forKey: "companyID") != nil){
            companyID = UserDefaults.standard.string(forKey: "companyID")!
        }
        
        self.loginContainer.frame=CGRect(x:28, y:((Constants.UIScreenMainHeight/2)-90), width:UIScreen.main.bounds.size.width-56, height:135)
        self.loginContainer.layer.cornerRadius = 10;
        self.loginContainer.clipsToBounds = true;
        self.loginContainer.backgroundColor = PrimaryGrayColor()
        
        self.separator1.backgroundColor = PrimaryBoarder()
        self.separator2.backgroundColor = PrimaryBoarder()
        
        self.userNameTextField.textColor=secondaryColor()
        self.userNameTextField.returnKeyType = UIReturnKeyType.next
        self.userNameTextField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        self.userNameTextField.autocorrectionType = UITextAutocorrectionType.no
        self.userNameTextField.adjustsFontSizeToFitWidth=true
        self.userNameTextField.text=userID
        self.userNameTextField.attributedPlaceholder = NSAttributedString(string:"userID".localized,attributes:[NSForegroundColorAttributeName:SecondaryGrayColor()])
        
        self.companyIDTextField.textColor=secondaryColor()
        self.companyIDTextField.returnKeyType = UIReturnKeyType.next
        self.companyIDTextField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        self.companyIDTextField.autocorrectionType = UITextAutocorrectionType.no
        self.companyIDTextField.adjustsFontSizeToFitWidth=true
        self.companyIDTextField.text=companyID
        self.companyIDTextField.attributedPlaceholder = NSAttributedString(string:"companyID".localized,attributes:[NSForegroundColorAttributeName:SecondaryGrayColor()])
        
        self.passwordTextField.returnKeyType = UIReturnKeyType.go
        self.passwordTextField.isSecureTextEntry=true
        self.passwordTextField.textColor=secondaryColor()
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string:"password".localized,attributes:[NSForegroundColorAttributeName:SecondaryGrayColor()])
        
        var startY = CGFloat(0)
        self.userNameTextField.frame=CGRect(x:10, y:startY, width:loginContainer.frame.size.width-20, height: 44)
        startY += self.userNameTextField.frame.size.height
        
        self.separator1.frame=CGRect(x:0,y:startY, width:loginContainer.frame.size.width, height:1)
        startY += 1
        
        self.companyIDTextField.frame=CGRect(x:10,y:startY,width:loginContainer.frame.size.width-20,height:44)
        startY += self.companyIDTextField.frame.size.height
        
        self.separator2.frame=CGRect(x:0, y:startY, width:loginContainer.frame.size.width, height:1)
        startY += 1
        
        self.passwordTextField.frame=CGRect(x:10, y:startY, width:loginContainer.frame.size.width-20, height: 44)
        startY += self.passwordTextField.frame.size.height
        
        self.loginContainer.addSubview(userNameTextField)
        self.loginContainer.addSubview(separator1)
        self.loginContainer.addSubview(companyIDTextField)
        self.loginContainer.addSubview(separator2)
        self.loginContainer.addSubview(passwordTextField)
        self.loginContainer.layer.borderColor = PrimaryBoarder().cgColor
        self.loginContainer.layer.borderWidth = 1
        
        self.passwordTextField.delegate=self
        self.userNameTextField.delegate=self
        self.companyIDTextField.delegate=self
        
        self.userNameTextField.addTarget(self, action: #selector(EnableStartButton), for: UIControlEvents.editingChanged)
        self.companyIDTextField.addTarget(self, action: #selector(EnableStartButton), for: UIControlEvents.editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(EnableStartButton), for: UIControlEvents.editingChanged)
        
        self.ScrollView.addSubview(loginContainer)
        
        StartButton.frame=CGRect(x:28,y:loginContainer.frame.origin.y+loginContainer.frame.height+20,width:UIScreen.main.bounds.width-56,height:50)
        StartButton.setTitle("signIn".localized.uppercased(), for:UIControlState.normal)
        EnableStartButton()
        
        StartButton.layer.borderColor = PrimaryBoarder().cgColor
        StartButton.layer.borderWidth = 1
        StartButton.layer.cornerRadius=10
        StartButton.clipsToBounds=true
        StartButton.addTarget(self, action: #selector(Start), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Login.dismissKeyboard))
        MainView.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        CopyrightLabel.frame=CGRect(x:0,y:SitaImageView.frame.origin.y+SitaImageView.frame.size.height,width:UIScreen.main.bounds.size.width,height:15)
        CopyrightLabel.textAlignment=NSTextAlignment.center
        CopyrightLabel.textColor=SecondaryGrayColor()
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        CopyrightLabel.text="© SITA \(year), v.\(version!)"
        CopyrightLabel.font=UIFont.systemFont(ofSize: 12)

        let footerView = FooterView(frame: CGRect(x:0,y:Constants.UIScreenMainHeight-(self.navigationController?.navigationBar.frame.size.height)!-UIApplication.shared.statusBarFrame.size.height,width:UIScreen.main.bounds.size.width,height:51))
        
        self.ScrollView.addSubview(footerView)
        
        let c1 = NSLayoutConstraint(item: footerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 1)
        
        let c2 = NSLayoutConstraint(item: footerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        
        let c3 = NSLayoutConstraint(item: footerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        let c4 = NSLayoutConstraint(item: footerView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0)
        
        let c5 = NSLayoutConstraint(item: footerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant:51)
        
        NSLayoutConstraint.activate([c1,c2,c3,c4,c5])
        
        
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.size.width, height:Constants.StartingY))
        statusBarView.backgroundColor=primaryColor()
        self.view.addSubview(statusBarView)
        UIApplication.shared.isStatusBarHidden=false
        if primaryColor() == UIColor.black {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
        self.view.setNeedsDisplay()
        
    }
    
    func NavigateToExpectedClass() -> UIViewController {
        
        let response = UserDefaultsManager().getLoginResponse()
        let logInData = UserDefaultsManager().getLoginInfo()
        
        if (response.count>0){
            let Airlines = (response["airlines"] as! String).components(separatedBy: ",")
            let Airports = (response["airports"] as! String).components(separatedBy: ",")
            
            if Airports.count>1 && (UserDefaults.standard.value(forKey: "selected_airport") == nil){
                let SelectAirport = SelectAirportView()
                SelectAirport.Airports = Airports as NSArray
                if Airlines.count>1 && (UserDefaults.standard.value(forKey: "selected_airline") == nil){
                    SelectAirport.Airlines = Airlines as NSArray
                }else if (UserDefaults.standard.value(forKey: "selected_airline") == nil){
                    UserDefaults.standard.setValue(Airlines[0] as String, forKey: "selected_airline")
                }
                SelectAirport.Service_ID = (response["service_id"] as! String)
                SelectAirport.User_ID = logInData["userID"] as! String
                SelectAirport.ReturnToMain = false
                return SelectAirport
            }
            else if Airlines.count>1 && (UserDefaults.standard.value(forKey: "selected_airline") == nil){
                if (UserDefaults.standard.value(forKey: "selected_airport") == nil) {
                    UserDefaults.standard.setValue(Airports[0] as String, forKey: "selected_airport")
                }
                let SelectAirline = SelectAirlineView()
                SelectAirline.Airlines = Airlines as NSArray
                SelectAirline.Service_ID = (response["service_id"] as! String)
                SelectAirline.User_ID = logInData["userID"] as! String
                SelectAirline.ReturnToMain = false
                return SelectAirline
            } else if(UserDefaults.standard.value(forKey: "selected_airport") != nil) && (UserDefaults.standard.value(forKey: "selected_airline") != nil){
                if (UserDefaults.standard.value(forKey: "selected_airport") == nil) {
                    UserDefaults.standard.setValue(Airports[0] as String, forKey: "selected_airport")
                }
                if (UserDefaults.standard.value(forKey: "selected_airline") == nil) {
                    UserDefaults.standard.setValue(Airlines[0] as String, forKey: "selected_airline")
                }
                return AppDelegate.vc.ConnectivityView
            }
        }else{
            return self
        }
        return self
    }
    
    func FooterView(frame:CGRect) -> UIView{

        let FooterView = UIView()
        FooterView.backgroundColor=primaryColor()
        FooterView.translatesAutoresizingMaskIntoConstraints = false
        FooterView.clipsToBounds = false
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x:0, y:0))
        path.addLine(to: CGPoint(x: (frame.size.width/2)-45, y:0))
        path.move(to: CGPoint(x:(frame.size.width/2)+45, y:0))
        path.addLine(to: CGPoint(x:frame.size.width, y:0))
        path.move(to: CGPoint(x: (frame.size.width/2)-35, y:5))
        path.addLine(to: CGPoint(x:(frame.size.width/2)-10, y:frame.size.height))
        path.move(to: CGPoint(x:(frame.size.width/2)+35, y:5))
        path.addLine(to: CGPoint(x:(frame.size.width/2)+10, y:frame.size.height))
        path.addLine(to: CGPoint(x:(frame.size.width/2)-10, y:frame.size.height))
        path.move(to: CGPoint(x: (frame.size.width/2)-45, y:0))
        path.addQuadCurve(to: CGPoint(x: (frame.size.width/2)-35, y:5), controlPoint:CGPoint(x:(frame.size.width/2)-40, y:0))
        path.move(to: CGPoint(x: (frame.size.width/2)+45, y:0))
        path.addQuadCurve(to: CGPoint(x: (frame.size.width/2)+35, y:5), controlPoint:CGPoint(x:(frame.size.width/2)+40, y:0))
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.lineWidth = 2
        layer.strokeColor = SecondaryGrayColor().cgColor
        layer.fillColor = primaryColor().cgColor
        FooterView.layer.addSublayer(layer)
        
        let ScannerImageView:UIImageView = UIImageView.init(frame:(CGRect(x:10,y:10,width:frame.height-20,height:frame.height-20)))
        let image :UIImage = UIImage.init(named: "bar-code-scanner")!
        let flippedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: UIImageOrientation.upMirrored)
        ScannerImageView.image=flippedImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ScannerImageView.tintColor=secondaryColor()
        FooterView.addSubview(ScannerImageView)
        
        
        ScannerTextField.attributedPlaceholder = NSAttributedString(string:"Scanner".localized,attributes:[NSForegroundColorAttributeName: SecondaryGrayColor()])
        ScannerTextField.returnKeyType =  UIReturnKeyType.next
        ScannerTextField.leftViewMode = UITextFieldViewMode.always
        ScannerTextField.textColor=secondaryColor()
        ScannerTextField.textAlignment=NSTextAlignment.center
        ScannerTextField.delegate=self
        ScannerTextField.tag=1111
        
        if (UIScreen.main.bounds.width==320.0){
            ScannerTextField.font=UIFont.systemFont(ofSize:10)
            ScannerTextField.frame=CGRect(x:(ScannerImageView.frame.origin.x+ScannerImageView.frame.size.width)-5,y:0,width:(((frame.size.width/2)-45)-(ScannerImageView.frame.origin.x+ScannerImageView.frame.size.width))+20,height:frame.size.height)
        } else if (UIScreen.main.bounds.width==375.0){
            ScannerTextField.font=UIFont.systemFont(ofSize: 13)
            ScannerTextField.frame=CGRect(x:(ScannerImageView.frame.origin.x+ScannerImageView.frame.size.width),y:0,width:(((frame.size.width/2)-45)-(ScannerImageView.frame.origin.x+ScannerImageView.frame.size.width))+5,height:frame.size.height)
        }else if (UIScreen.main.bounds.width>375.0){
            ScannerTextField.font=UIFont.systemFont(ofSize: 15)
            ScannerTextField.frame=CGRect(x:(ScannerImageView.frame.origin.x+ScannerImageView.frame.size.width),y:0,width:(((frame.size.width/2)-45)-(ScannerImageView.frame.origin.x+ScannerImageView.frame.size.width))+5,height:frame.size.height)
        }
        
        ScannerTextField.adjustsFontSizeToFitWidth=true
        if ((UserDefaults.standard.string(forKey: "scannerType")) != nil){
            ScannerTextField.text=UserDefaults.standard.string(forKey: "scannerType")
        }
        FooterView.addSubview(ScannerTextField)
        
        let ModeImageView = UIImageView.init(frame:(CGRect(x:frame.size.width-(frame.size.height-20)-10,y:10,width:frame.size.height-20,height:frame.size.height-20)))
        
        let ModeImage :UIImage!
        if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
            ModeImage = UIImage.init(named: "theme_dark2.png")!
        } else{
            ModeImage = UIImage.init(named: "theme_lite2.png")!
        }
        
        ModeImageView.image=ModeImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ModeImageView.tintColor=secondaryColor()
        FooterView.addSubview(ModeImageView)
        
        let ModeButton = UIButton(frame: CGRect(x:(frame.size.width/2)+40, y:0, width:(frame.size.width-((frame.size.width/2)+45)-ModeImageView.frame.size.width)-5, height: frame.size.height))
        var ModeTitle=String()
        ModeButton.titleLabel?.font=ScannerTextField.font
        if(UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
            ModeTitle="lightMode".localized
        } else{
             ModeTitle="darkMode".localized
        }
        ModeButton.setTitle(ModeTitle, for: UIControlState.normal)
        ModeButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        ModeButton.addTarget(self, action: #selector(PageControllerChanged), for: UIControlEvents.touchUpInside)
        FooterView.addSubview(ModeButton)        
        return FooterView;
    }
    
    func PageControllerChanged() {
        if(UserDefaults.standard.value(forKey: "colorMode") != nil && UserDefaults.standard.string(forKey: "colorMode") == "sunlight"){
            UserDefaults.standard.set("moonlight", forKey: "colorMode")
        } else {
            UserDefaults.standard.set("sunlight", forKey: "colorMode")
        }
        tempCompanyID=companyIDTextField.text
        tempUserID=userNameTextField.text
        LoadComponents()
        MainViewController.AppHeaderInstance.viewDidLoad()
    }
    
    func GetLogInResponse(UserID:String , CompanyID:String , Password:String) {
        let url = Constants.BagJourneyHost + Constants.LogInEndPoint
        
        var body = "{"
        body = body.appending("\"")
        body = body.appending("user_id")
        body = body.appending("\"")
        body = body.appending(":")
        body = body.appending("\"")
        body = body.appending(String(UserID))
        body = body.appending("\"")
        body = body.appending(",")
        
        body = body.appending("\"")
        body = body.appending("company_id")
        body = body.appending("\"")
        body = body.appending(":")
        body = body.appending("\"")
        body = body.appending(String(CompanyID))
        body = body.appending("\"")
        body = body.appending(",")
        
        body = body.appending("\"")
        body = body.appending("password")
        body = body.appending("\"")
        body = body.appending(":")
        body = body.appending("\"")
        body = body.appending(String(Password))
        body = body.appending("\"")
        body = body.appending("}")
        
        let APIcall : APICall = APICall()
        
        APIcall.getResponseForURL(url, jsonToPost: body, isAuthenticationRequired:false, method: "POST", errorTitle: nil, hideLoader: false) {(responseDic, statusCode, data, error) in
            AppDelegate.getDelegate().hideLoadingIndicatorView()
            if (responseDic != nil){
                let response : [String:Any] = responseDic as! [String:Any]
                if (response.count>0 && (response["success"] as! Bool == true) && (response["airports"] != nil) &&  (response["airlines"] != nil)){
                    
                    let Airlines = (response["airlines"] as! String).components(separatedBy: ",")
                    let Airports = (response["airports"] as! String).components(separatedBy: ",")
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
                    let date = dateFormatter.date(from: response["password_expiry_date"] as! String)

                    let defference = (date?.offsetFrom(date: Date()))!
                    if  defference <= 7 {
                        var timeRemaining = ""
                        if defference <= 0 {
                            timeRemaining = "today".localized
                        } else if defference == 1 {
                            timeRemaining = "tomorrow".localized
                        } else {
                            timeRemaining = "in \(defference) days"
                        }
                        AppDelegate.getDelegate().showOverlayWithView(viewToShow:self.ExpairyDialogView(remainingTime:timeRemaining) , dismiss: false, AccessToMenu:false)
                    } else {
                        self.continueAfterLoginSucess(Airports:Airports as NSArray,Airlines:Airlines as NSArray,response:response,UserID:UserID)
                    }
                    
                }else{
                    var ErrorMessage = "Network_Connection_Issue".localized
                    var ErrorCode = ""
                    if (response["errors"] != nil){
                        let errorDic = response["errors"]!
                        let firsError = (errorDic as AnyObject).firstObject! as! NSDictionary
                        let message = (firsError as AnyObject).value(forKey: "error_description") as! NSString
                        ErrorCode = (firsError as AnyObject).value(forKey: "error_code") as! String
                        ErrorMessage = message as String
                    }
                    if (ErrorCode != "BJYAPLN005"){
                        self.dialog = GetSimpleDialogView(LabelText: ErrorMessage, Image: false, Y:(Constants.UIScreenMainHeight/2)-(Constants.UIScreenMainHeight/8))
                        AppDelegate.getDelegate().showOverlayWithView(viewToShow:self.dialog , dismiss: false, AccessToMenu:false)
                        _ = Timer.scheduledTimer(timeInterval:1.5, target: self, selector: #selector(self.removeFailedDialog), userInfo: nil, repeats: false)
                    } else {
                        let changePassword = ChangePasswordViewController()
                        changePassword.willDismissToLogin=true
                        changePassword.forceChangePass=true
                        self.present(changePassword, animated: true, completion:nil)
                    }
                }
            } else {
                var message = "Network_Connection_Issue".localized
                if (statusCode == 404 && (error != nil)){
                    message = "requestFailed".localized
                }
                self.dialog = GetSimpleDialogView(LabelText:message, Image: false, Y:(Constants.UIScreenMainHeight/2)-(Constants.UIScreenMainHeight/8))
                AppDelegate.getDelegate().showOverlayWithView(viewToShow:self.dialog , dismiss: false, AccessToMenu: false)
                _ = Timer.scheduledTimer(timeInterval:1.5, target: self, selector: #selector(self.removeFailedDialog), userInfo: nil, repeats: false)
            }
        }
        AppDelegate.getDelegate().ShowLoaderIndicatorView()
    }
   
    func checkIfLastUserChange(UserID:String) -> Bool{
        if ((UserDefaults.standard.value(forKey: "lastUserLogged")) != nil){
            if ((UserDefaults.standard.value(forKey: "lastUserLogged") as! String) != ""){
                if ((UserDefaults.standard.value(forKey: "lastUserLogged") as! String) != UserID){
                    UserDefaultsManager().removeSyncedBags()
                    if ((UserDefaultsManager().getAllBagsFromCoredata()?.count)! > 0){
                        DispatchQueue.main.async {
                            let remainView = self.getRemainUnsynchronizedView(badgeNumber:(UserDefaultsManager().getAllBagsFromCoredata()?.count)!, lastUser:(UserDefaults.standard.value(forKey: "lastUserLogged") as! String))
                            
                            let screen=UIScreen.main.bounds
                            self.remainigUnsyncedBagsView=UIView(frame: CGRect(x:0, y:0, width:screen.width, height:screen.height))
                            self.remainigUnsyncedBagsView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6)
                            self.remainigUnsyncedBagsView.addSubview(remainView)
                            self.view.addSubview(self.remainigUnsyncedBagsView)
                        }
                        return true
                    }
                }
            }
        }
        return false
    }
    
    
    func continueAfterLoginSucess(Airports:NSArray,Airlines:NSArray,response:[String:Any],UserID:String){
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if(settings.authorizationStatus == .authorized){
                if (self.checkIfLastUserChange(UserID: UserID) == false ){
                    DispatchQueue.main.async {
                        self.continueAfterChecking(Airports: Airports, Airlines: Airlines, response: response, UserID: UserID)
                    }
                } else {
                    self.tempoUserID = UserID
                    self.tempoAirlines = Airlines
                    self.tempoAirports = Airports
                    self.tempoResponse = response
                }
            }else{
                DispatchQueue.main.async {
                    
                    self.tempoUserID = UserID
                    self.tempoAirlines = Airlines
                    self.tempoAirports = Airports
                    self.tempoResponse = response
                    
                    let permission = PermissionsView()
                    permission.permissionType = "notifNotDetermined"
                    self.navigationController?.pushViewController(permission, animated: false)
                }
            }
        }
    }
    
    func continueAfterChecking(Airports:NSArray,Airlines:NSArray,response:[String:Any],UserID:String){
        
        UserDefaultsManager().saveLoginResponse(response: response as NSDictionary)
        self.getTrackingConfigurationForAirports()
        
        UserDefaults.standard.setValue(UserID, forKey: "lastUserLogged")
        if Airports.count>1{
            let SelectAirport = SelectAirportView()
            SelectAirport.Airports = Airports as NSArray
            if Airlines.count>1{
                SelectAirport.Airlines = Airlines as NSArray
            }else {
                UserDefaults.standard.setValue(Airlines[0] as! String, forKey: "selected_airline")
            }
            SelectAirport.Service_ID = (response["service_id"] as! String)
            SelectAirport.User_ID = UserID
            SelectAirport.ReturnToMain = false
            self.navigationController?.pushViewController(SelectAirport, animated: false)
        }
        else if Airlines.count>1{
            UserDefaults.standard.setValue(Airports[0] as! String, forKey: "selected_airport")
            let SelectAirline = SelectAirlineView()
            SelectAirline.Airlines = Airlines as NSArray
            SelectAirline.Service_ID = (response["service_id"] as! String)
            SelectAirline.User_ID = UserID
            SelectAirline.ReturnToMain = false
            self.navigationController?.pushViewController(SelectAirline, animated: false)
        } else if Airports.count==1 && Airlines.count==1{
            UserDefaults.standard.setValue(Airports[0] as! String, forKey: "selected_airport")
            UserDefaults.standard.setValue(Airlines[0] as! String, forKey: "selected_airline")
            self.navigationController?.pushViewController(self.ConnectivityView, animated: true)
        }
        AppDelegate.getDelegate().preventTokenExpiration()
    }
    
    func isNotificationPermissionAuthorised() -> Bool {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if(settings.authorizationStatus == .authorized){
                //return true
            }else{
                //return false
            }
        }
        return false;
    }
    
    func getRemainUnsynchronizedView(badgeNumber:Int,lastUser:String) -> UIView {
        
        let unsynchronizedView=UIView(frame: CGRect(x:20,y:Constants.UIScreenMainHeight/7,width:UIScreen.main.bounds.width-40,height:Constants.UIScreenMainHeight-(Constants.UIScreenMainHeight/4)))
        
        unsynchronizedView.backgroundColor=BagDetailsBackgroundColor().withAlphaComponent(0.9)
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y:0, width:unsynchronizedView.frame.width, height: unsynchronizedView.frame.height)
        border.borderWidth = width
        unsynchronizedView.layer.addSublayer(border)
        unsynchronizedView.layer.masksToBounds = false
        
        let bagImageViewContainer = UIView(frame:CGRect(x:(unsynchronizedView.frame.size.width/2)-50, y: 50, width: 100, height: 100))
        bagImageViewContainer.backgroundColor = SecondaryGrayColor()
        bagImageViewContainer.layer.cornerRadius = 7.5
        
        let bagImageView = UIImageView(frame:CGRect(x:(bagImageViewContainer.frame.size.width/2)-30, y:20, width:60, height: 60))
        bagImageView.image = UIImage(named: "Bag")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        bagImageView.tintColor = primaryColor()
        
        
        let badgeView = UIView(frame:CGRect(x: bagImageViewContainer.frame.width-15, y: -15, width: 30, height: 30))
        badgeView.backgroundColor = UIColor.red
        badgeView.layer.cornerRadius = 15
        let badgeLabel = UILabel(frame: CGRect(x:5, y:5, width: 20, height: 20))
        badgeLabel.adjustsFontSizeToFitWidth = true
        badgeLabel.textColor = UIColor.white
        badgeLabel.textAlignment = .center
        badgeLabel.text = "\(badgeNumber)"
        badgeView.addSubview(badgeLabel)
        
        let cloudImageView = UIImageView(frame:CGRect(x:bagImageViewContainer.frame.size.width-42.5, y:bagImageViewContainer.frame.size.height-33, width:35, height: 25))
        cloudImageView.image = UIImage(named: "cloud_off_white")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        cloudImageView.tintColor = secondaryColor()
        
        bagImageViewContainer.addSubview(bagImageView)
        bagImageViewContainer.addSubview(cloudImageView)
        bagImageViewContainer.addSubview(badgeView)
        
        let messageLabel = UILabel(frame:CGRect(x: 10, y:180, width: unsynchronizedView.frame.size.width-20, height: 100))
        messageLabel.textAlignment = .center
        messageLabel.textColor = secondaryColor()
        messageLabel.numberOfLines = 4
        messageLabel.text = String.localizedStringWithFormat("login_queueUnsyncedBags".localized,lastUser)
        let screenHeight = unsynchronizedView.frame.size.height
        let screenWidth = unsynchronizedView.frame.size.width
        let space = screenHeight/33.35
        let startX=screenWidth/13.39
        var startY=CGFloat(0)
        
        let buttonsContainerView = UIView(frame: CGRect(x:0, y:screenHeight/2+((screenHeight/3.5)/2), width:screenWidth, height:screenHeight/3.5))
        
        let sendBagsButton = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
        sendBagsButton.addTarget(self, action:#selector(login_queue_action_sendUnsynced_Pressed), for: .touchUpInside)
        sendBagsButton.setTitle("login_queue_action_sendUnsynced".localized.uppercased(), for:UIControlState.normal)
        sendBagsButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        sendBagsButton.titleEdgeInsets = UIEdgeInsetsMake(0,15,0,15)
        sendBagsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        sendBagsButton.layer.borderColor = PrimaryBoarder().cgColor
        sendBagsButton.layer.borderWidth = 1
        sendBagsButton.layer.cornerRadius=10
        sendBagsButton.clipsToBounds=true
        sendBagsButton.backgroundColor=PrimaryGrayColor()
        buttonsContainerView.addSubview(sendBagsButton)
        startY += sendBagsButton.frame.height+space
        
        let cancelLoginButton = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
        cancelLoginButton.setTitle("login_queue_action_Cancel".localized.uppercased(), for:UIControlState.normal)
        cancelLoginButton.addTarget(self, action:#selector(login_queue_action_Cancel_Pressed), for: .touchUpInside)
        cancelLoginButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        cancelLoginButton.titleEdgeInsets = UIEdgeInsetsMake(0,15,0,15)
        cancelLoginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelLoginButton.layer.borderColor = PrimaryBoarder().cgColor
        cancelLoginButton.layer.borderWidth = 1
        cancelLoginButton.layer.cornerRadius=10
        cancelLoginButton.clipsToBounds=true
        cancelLoginButton.backgroundColor=PrimaryGrayColor()
        buttonsContainerView.addSubview(cancelLoginButton)
        startY += cancelLoginButton.frame.height+space
        
        let deleteBagsButton = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
        deleteBagsButton.setTitle("login_queue_action_deleteUnsynced".localized.uppercased(), for:UIControlState.normal)
        deleteBagsButton.addTarget(self, action:#selector(login_queue_action_deleteUnsynced_Pressed), for: .touchUpInside)
        deleteBagsButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        deleteBagsButton.titleEdgeInsets = UIEdgeInsetsMake(0,15,0,15)
        deleteBagsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        deleteBagsButton.layer.borderColor = PrimaryBoarder().cgColor
        deleteBagsButton.layer.borderWidth = 1
        deleteBagsButton.layer.cornerRadius=10
        deleteBagsButton.clipsToBounds=true
        deleteBagsButton.backgroundColor=UIColor.red
        buttonsContainerView.addSubview(deleteBagsButton)
        
        unsynchronizedView.addSubview(bagImageViewContainer)
        unsynchronizedView.addSubview(messageLabel)
        unsynchronizedView.addSubview(buttonsContainerView)
        
        return unsynchronizedView
    }
    
    func ExpairyDialogView(remainingTime:String) -> UIView {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = Constants.UIScreenMainHeight
        
        let Dialog = UIView(frame:CGRect(x:0,y:screenHeight/4,width:screenWidth,height:screenHeight/2))
        Dialog.backgroundColor=QueueBackgroundColor().withAlphaComponent(0.9)
        
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
        
        var startYmain=Dialog.frame.size.height/20
        
        let imageView = UIImageView(frame: CGRect(x:(Dialog.frame.size.width/2)-(Dialog.frame.size.height/10), y: startYmain, width: Dialog.frame.size.height/5, height: Dialog.frame.size.height/5))
        imageView.image = UIImage(named: "Exclamation.png")?.withRenderingMode( .alwaysTemplate)
        imageView.tintColor = secondaryColor()
        startYmain = startYmain + imageView.frame.size.height
        Dialog.addSubview(imageView)
        
        let consideringLabel = UILabel(frame: CGRect(x: 10, y:startYmain, width:Dialog.frame.width-20, height: 30))
        consideringLabel.text = "considerChangePass".localized
        consideringLabel.textColor = secondaryColor()
        consideringLabel.font = UIFont.boldSystemFont(ofSize: 20)
        consideringLabel.textAlignment = NSTextAlignment.center
        consideringLabel.adjustsFontSizeToFitWidth = true
        startYmain = startYmain + consideringLabel.frame.size.height
        Dialog.addSubview(consideringLabel)
        
        let expiryLabel = UILabel(frame: CGRect(x: 10, y:startYmain, width:Dialog.frame.width-20, height: 60))
        expiryLabel.text = String(format: "passwordExpiryMessage".localized,remainingTime)
        expiryLabel.textColor = secondaryColor()
        expiryLabel.font = UIFont.systemFont(ofSize:16)
        expiryLabel.textAlignment = NSTextAlignment.center
        expiryLabel.numberOfLines = 2
        expiryLabel.adjustsFontSizeToFitWidth = true
        Dialog.addSubview(expiryLabel)
        
        
        let space = screenHeight/33.35
        let startX=screenWidth/13.39
        var startY=CGFloat(0)
        
        let buttonsContainerView = UIView(frame: CGRect(x:0, y:(Dialog.frame.height/2)+20, width:screenWidth, height:Dialog.frame.height/3))
        
        let changePassButton = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
        changePassButton.layer.borderColor = PrimaryBoarder().cgColor
        changePassButton.setTitle("changePasswordNow".localized.uppercased(), for:UIControlState.normal)
        changePassButton.layer.borderWidth = 1
        changePassButton.layer.cornerRadius=10
        changePassButton.clipsToBounds=true
        changePassButton.backgroundColor=SecondaryGrayColor()
        changePassButton.addTarget(self, action: #selector(changePassButtonPressed), for: .touchUpInside)
        buttonsContainerView.addSubview(changePassButton)
        startY += changePassButton.frame.height+space
        
        let laterButton = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
        laterButton.setTitle("later".localized.uppercased(), for:UIControlState.normal)
        laterButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        laterButton.layer.borderColor = PrimaryBoarder().cgColor
        laterButton.layer.borderWidth = 1
        laterButton.layer.cornerRadius=10
        laterButton.clipsToBounds=true
        laterButton.addTarget(self, action: #selector(laterButtonPressed), for: .touchUpInside)
        buttonsContainerView.addSubview(laterButton)
        
        Dialog.addSubview(buttonsContainerView)
        
        return Dialog
    }
    
    @objc func laterButtonPressed() {
        AppDelegate.getDelegate().doClose()
        let response = UserDefaultsManager().getLoginResponse()
        let Airlines = (response["airlines"] as! String).components(separatedBy: ",")
        let Airports = (response["airports"] as! String).components(separatedBy: ",")
        continueAfterLoginSucess(Airports: Airports as NSArray, Airlines: Airlines as NSArray, response: response as! [String : Any], UserID: userNameTextField.text!)
    }
    
    func changePassButtonPressed() {
        AppDelegate.getDelegate().doClose()
        let changePassword = ChangePasswordViewController()
        changePassword.willDismissToLogin=true
        self.present(changePassword, animated: true, completion:nil)
    }
    
    func login_queue_action_Cancel_Pressed(){
        passwordTextField.text=""
        if (remainigUnsyncedBagsView != nil){
            remainigUnsyncedBagsView.removeFromSuperview()
        }
        UserDefaultsManager().SignOut()
    }
    
    func login_queue_action_sendUnsynced_Pressed(){
        if (remainigUnsyncedBagsView != nil){
            remainigUnsyncedBagsView.removeFromSuperview()
        }
        continueAfterChecking(Airports: tempoAirports, Airlines: tempoAirlines, response: tempoResponse, UserID: tempoUserID)
    }
    
    func login_queue_action_deleteUnsynced_Pressed() {
        let alert = UIAlertController(title: "login_queue_action_deleteUnsynced_prompt".localized, message:nil, preferredStyle: UIAlertControllerStyle.alert)
      
        let actionYes = UIAlertAction(title: "YES", style: .cancel) { UIAlertAction in
            if (self.remainigUnsyncedBagsView != nil){
                self.remainigUnsyncedBagsView.removeFromSuperview()
            }
            UserDefaultsManager().deleteAllBagsFromCoredata()
            self.continueAfterChecking(Airports: self.tempoAirports, Airlines: self.tempoAirlines, response: self.tempoResponse, UserID: self.tempoUserID)
        }
        let actionNo = UIAlertAction(title: "NO", style: .default) { UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(actionNo)
        alert.addAction(actionYes)

        self.present(alert, animated: false, completion: nil)
    }
    
    func removeFailedDialog() {
        if self.dialog != nil{
            self.dialog.removeFromSuperview()
            AppDelegate.getDelegate().doClose()
        }
    }
    
    func ScannerSelectorActionSheet(){
        self.ScrollView.contentSize = CGSize(width:UIScreen.main.bounds.width,height:Constants.UIScreenMainHeight)
        let optionMenu = UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
        let SocketMobileAction = UIAlertAction(title: "socket_mobile_bt".localized, style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.ScannerTextField.text="socket_mobile_bt".localized
            UserDefaults.standard.set("socket_mobile_bt".localized, forKey: "scannerType")
            self.EnableStartButton()
        })
        let CognexAction = UIAlertAction(title: "cognex_scanner".localized, style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.ScannerTextField.text="cognex_scanner".localized
            UserDefaults.standard.set("cognex_scanner".localized, forKey: "scannerType")
            self.EnableStartButton()
        })
        let SoftScanAction = UIAlertAction(title: "softScanner".localized, style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.ScannerTextField.text="softScanner".localized
            UserDefaults.standard.set("softScanner".localized, forKey: "scannerType")
            self.EnableStartButton()
        })
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
        optionMenu.addAction(SocketMobileAction)
        optionMenu.addAction(CognexAction)
        optionMenu.addAction(SoftScanAction)
        optionMenu.addAction(CancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func ReloadMainViewAfterScannerSetupIsDone(){
        self.navigationController?.pushViewController(MainViewControllerPointer,animated:true)
        AppDelegate.getDelegate().ScanManagerReturnFromBackground()
    }
    
    
    func ButtonClicked(sender: UIButton!) {
        let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: false, completion: nil)
    }
    
    
    func getTrackingConfigurationForAirports() {
        
        let Service_ID = (UserDefaultsManager().getLoginResponse()["service_id"] as! String)
        let Airports = (UserDefaultsManager().getLoginResponse()["airports"] as! String).components(separatedBy: ",")
        
        for airportCode in Airports {
            let url = Constants.BagJourneyHost + String(format: Constants.trackingConfigurationEndPoint,Service_ID,airportCode)
            let apiCall = ApiCallSwift()
            apiCall.getResponseForURL(builtURL: url as NSString, JsonToPost:"", isAuthenticationRequired: false, method: "GET", errorTitle: "", optionalValue:airportCode, AndCompletionHandler: { (retrivedCode, response, statusCode, data, Error) in
                if response.value(forKey: "success") != nil && response.value(forKey: "success") as! Bool {
                    if let configuration = response.value(forKey:"configurations") {
                        if (configuration as! NSArray).count > 0 {
                            let airportCode = ((configuration as! NSArray).firstObject as! NSDictionary).value(forKey: "airport_code") as! String
                            ScanManager.LocalStorage.setConfigurationsFor(airportCode: airportCode, configurationArray: configuration as! NSArray)
                        } else {
                            ScanManager.LocalStorage.setConfigurationsFor(airportCode: retrivedCode, configurationArray:NSArray())
                        }
                    } else {
                        ScanManager.LocalStorage.setConfigurationsFor(airportCode: retrivedCode, configurationArray:NSArray())
                    }

                } else {
                    ScanManager.LocalStorage.setConfigurationsFor(airportCode: retrivedCode, configurationArray:NSArray())
                }
                if (AppDelegate.IsUSerINMainView){
                    self.MainViewControllerPointer.viewWillAppear(true)
                }
                AppDelegate.getDelegate().ScanManagerReturnFromBackground()
            })
        }
    }
    
    
    //MARK:-Keyboard Functions
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification){
        self.view.frame.origin.y = 0
        self.ScrollView.contentSize = CGSize(width:UIScreen.main.bounds.width,height:Constants.UIScreenMainHeight)
        self.view.frame.origin.y -= 50
        self.ScrollView.contentSize = CGSize(width:UIScreen.main.bounds.width,height:Constants.UIScreenMainHeight)
        isVisible = true
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
        self.ScrollView.contentSize = CGSize(width:UIScreen.main.bounds.width,height:Constants.UIScreenMainHeight)
        isVisible = false
    }
    
     //MARK:-TextFields Functions
    
    func EnableStartButton() {
        if (userNameTextField.text != "" && companyIDTextField.text != "" && passwordTextField.text != "" && ScannerTextField.text != ""){
            StartButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
            StartButton.isUserInteractionEnabled = true
        } else{
            StartButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
            StartButton.isUserInteractionEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField : UITextField) -> Bool{
        if(userNameTextField==textField){
            companyIDTextField.becomeFirstResponder()
        }
        if(companyIDTextField==textField){
            passwordTextField.becomeFirstResponder()
        }
        if(passwordTextField==textField){
            Start()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField){
        if(textField==ScannerTextField){
            if(isVisible){
                DispatchQueue.main.async {
                    textField.resignFirstResponder()
                }
            }else{
                textField.resignFirstResponder()
            }
            self.ScannerSelectorActionSheet()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if(textField==passwordTextField){
            return true
        }
        if(textField==companyIDTextField){
            if string != ""{
                return self.IsAcceptableUserInput(string: string)
            }
        }
        if(textField==userNameTextField){
            if string != ""{
                return self.IsAcceptableUserInput(string: string)
            }
        }
        return true
    }
    
    
    func IsAcceptableUserInput(string:String)->Bool{
        let containerSpec:String="^[0-9A-Z]$"
        if (AppDelegate.getDelegate().matchesForRegexCaseSensitive(containerSpec: containerSpec, text: string) != []){
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
     //MARK:-View Navigation Functions 
    func Start() {
        if(!(userNameTextField.text=="") && !(passwordTextField.text=="") && !(ScannerTextField.text=="") && !(companyIDTextField.text!=="")){
            dismissKeyboard()
            UserDefaultsManager().saveLoginInfo(UserID:userNameTextField.text!, companyID:companyIDTextField.text!)
            let increptedPassword = increptPassword(password: passwordTextField.text!)
            GetLogInResponse(UserID:userNameTextField.text!, CompanyID:companyIDTextField.text!, Password:increptedPassword)
        }
    }

    func NavigatToConnectDivice(){
        // reason: 'Pushing the same view controller instance more than once is not supported
        let SetUpView = SetupViewController()
        self.navigationController?.dismiss(animated: false, completion:nil)
        _=self.navigationController?.popViewController(animated: false)
        self.navigationController?.pushViewController(SetUpView, animated: false)
    }
    
    func NavigatToResetDivice(){
        // reason: 'Pushing the same view controller instance more than once is not supported
        let SetUpView = ResetViewControllerV2()
        self.navigationController?.dismiss(animated: false, completion:nil)
        _=self.navigationController?.popViewController(animated: false)
        self.navigationController?.pushViewController(SetUpView, animated: false)
    }
}
