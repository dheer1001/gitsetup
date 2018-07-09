//
//  ChangePasswordViewController.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 10/17/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController , UITextFieldDelegate{
    
    var ScrollView = UIScrollView()
    var USER_ID_Text=UITextField()
    var COMPANY_ID_Text=UITextField()
    var OLD_PASS_Text=UITextField()
    var NEW_PASS_Text=UITextField()
    var CONF_PASS_Text=UITextField()
    var ChangPasswordButton = UIButton()
    var  dialog : UIView!
    var willDismissToLogin:Bool = false
    var forceChangePass:Bool = false
    var ScrollViewContentInset:UIEdgeInsets!
    var dismissAfterDialog = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.IsUSerINMainView = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- UI Functions
    func LoadComponents() {
        
        let screenWidth = UIScreen.main.bounds.size.width
        var startY = CGFloat(50)
        
        self.view.backgroundColor=primaryColor()
        self.navigationController?.isNavigationBarHidden=true
        
        //ScrollView
        self.ScrollView.frame=CGRect(x:0,y:UIApplication.shared.statusBarFrame.height,width:UIScreen.main.bounds.width,height: Constants.UIScreenMainHeight-UIApplication.shared.statusBarFrame.height)
//        self.ScrollView.isScrollEnabled=true
        self.ScrollView.backgroundColor=primaryColor()
        self.view.addSubview(ScrollView)
        
        //Keyboard controller
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        deregisterFromKeyboardNotifications()
        registerForKeyboardNotifications()
        
        //BackView
        let BackButton = UIButton(frame: CGRect(x:0,y:0, width:35, height:35))
        let BackLabel = UILabel(frame:CGRect(x:45, y:0, width:50, height: 35))
        let BackView = UIView(frame:CGRect(x:10,y:35+UIApplication.shared.statusBarFrame.height, width:100, height:70))
        let BackTap = UITapGestureRecognizer(target: self, action: #selector(Back))
        BackButton.addTarget(self, action: #selector(Back), for: UIControlEvents.touchUpInside)
        BackButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        BackButton.setBackgroundImage(UIImage(named: "left_arrow.png")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        BackButton.tintColor=secondaryColor()
        BackLabel.textAlignment=NSTextAlignment.center
        BackLabel.text = "back".localized
        BackLabel.textColor = secondaryColor()
        BackView.addGestureRecognizer(BackTap)
        BackView.addSubview(BackLabel)
        BackView.addSubview(BackButton)
        self.ScrollView.addSubview(BackView)
        
        //HeaderImageView
        let HeaderImageView = UIImageView(frame:CGRect(x: (screenWidth/2)-50, y:50, width: 100, height: 100))
        HeaderImageView.image=UIImage(named:"password.png")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        HeaderImageView.tintColor = secondaryColor()
        self.ScrollView.addSubview(HeaderImageView)
        startY += HeaderImageView.frame.size.height + 20
        
        //ChangePasswordLabel
        let ChangePasswordLabel = UILabel(frame:CGRect(x:10, y: startY, width: screenWidth-20, height: 30))
        ChangePasswordLabel.font=UIFont.systemFont(ofSize: 20)
        ChangePasswordLabel.textColor=secondaryColor()
        ChangePasswordLabel.textAlignment=NSTextAlignment.center
        ChangePasswordLabel.text="changePassword".localized.uppercased()
        ChangePasswordLabel.adjustsFontSizeToFitWidth=true
        self.ScrollView.addSubview(ChangePasswordLabel)
        startY += ChangePasswordLabel.frame.size.height + 30
        
        if (forceChangePass){
            //ForceChangePasswordLabel
            let ForceChangePasswordLabel = UILabel(frame:CGRect(x:10, y: startY-35, width: screenWidth-20, height: 40))
            ForceChangePasswordLabel.font=UIFont.systemFont(ofSize: 14)
            ForceChangePasswordLabel.textColor=secondaryColor()
            ForceChangePasswordLabel.textAlignment=NSTextAlignment.center
            ForceChangePasswordLabel.text="force_password_change_subtitle".localized
            ForceChangePasswordLabel.adjustsFontSizeToFitWidth=true
            ForceChangePasswordLabel.numberOfLines = 2
            self.ScrollView.addSubview(ForceChangePasswordLabel)
            startY += ForceChangePasswordLabel.frame.size.height
        }
        
        //addSubviews
        let rowHeight = CGFloat(50)
        self.ScrollView.addSubview(rawView(imageName:"service.png", placeHolder:"", startY: startY, screenWidth: screenWidth, textField: USER_ID_Text))
        startY += rowHeight + 20
        self.ScrollView.addSubview(rawView(imageName:"company.png", placeHolder:"", startY: startY, screenWidth: screenWidth, textField: COMPANY_ID_Text))
        startY += rowHeight + 20
        self.ScrollView.addSubview(rawView(imageName:"outline_lock_black_48pt_3x.png", placeHolder:"old_password".localized, startY: startY, screenWidth: screenWidth, textField: OLD_PASS_Text))
        startY += rowHeight + 20
        self.ScrollView.addSubview(rawView(imageName:"outline_lock_black_48pt_3x.png", placeHolder:"new_password".localized, startY: startY, screenWidth: screenWidth, textField: NEW_PASS_Text))
        startY += rowHeight + 20
        self.ScrollView.addSubview(rawView(imageName:"outline_lock_black_48pt_3x.png", placeHolder:"confirm_password".localized, startY: startY, screenWidth: screenWidth, textField: CONF_PASS_Text))
        startY += rowHeight + 20
        
        //ChangPasswordButton
        ChangPasswordButton.frame=CGRect(x:25,y:startY,width:UIScreen.main.bounds.width-50,height:50)
        ChangPasswordButton.setTitle("changePassword".localized.uppercased(), for:UIControlState.normal)
        EnableChangePasswordButton()
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = SecondaryGrayColor().cgColor
        border.frame = CGRect(x: 0, y:0, width:ChangPasswordButton.frame.size.width, height: ChangPasswordButton.frame.size.height)
        border.borderWidth = width
        
        ChangPasswordButton.layer.addSublayer(border)
        ChangPasswordButton.layer.masksToBounds = true
        ChangPasswordButton.addTarget(self, action: #selector(ChangePasswordPressed), for: .touchUpInside)
        self.ScrollView.addSubview(ChangPasswordButton)
        startY += rowHeight + 20
        
        OLD_PASS_Text.addTarget(self, action: #selector(EnableChangePasswordButton), for: UIControlEvents.editingChanged)
        NEW_PASS_Text.addTarget(self, action: #selector(EnableChangePasswordButton), for: UIControlEvents.editingChanged)
        CONF_PASS_Text.addTarget(self, action: #selector(EnableChangePasswordButton), for: UIControlEvents.editingChanged)
        
        self.ScrollView.contentSize=CGSize(width: self.ScrollView.frame.size.width, height: startY)
    }
    
    func rawView(imageName:String,placeHolder:String,startY:CGFloat,screenWidth:CGFloat,textField:UITextField) -> UIView {
        
        let border = CALayer()
        let borderWidth = CGFloat(2.0)
        let RowView = UIView(frame:(CGRect(x:25,y:startY,width:screenWidth-50,height:50)))
        let paddingView = UIView(frame :CGRect(x:0,y:0,width:50,height:50))
        let paddingView2 = UIView(frame: CGRect(x:0, y:0, width:5, height:20))
        let imageView=UIImageView(frame:CGRect(x:paddingView.frame.width/6,y:paddingView.frame.width/6,width: paddingView.frame.width/1.5,height:paddingView.frame.height/1.5))
        
        textField.frame = CGRect(x:50,y:0,width: RowView.frame.width-50,height:50)
        textField.attributedPlaceholder = NSAttributedString(string:placeHolder.localized,attributes:[NSForegroundColorAttributeName: SecondaryGrayColor()])
        textField.leftView = paddingView2
        textField.leftViewMode = UITextFieldViewMode.always
        textField.textColor=secondaryColor()
        textField.delegate=self
        if (textField == OLD_PASS_Text || textField == NEW_PASS_Text || textField == CONF_PASS_Text){
            if (textField == CONF_PASS_Text){
                textField.returnKeyType =  UIReturnKeyType.go
            }else{
                textField.returnKeyType =  UIReturnKeyType.next
                textField.returnKeyType =  UIReturnKeyType.next
            }
            textField.isSecureTextEntry=true
        } else {
            if (textField == USER_ID_Text){
                textField.text = UserDefaultsManager().getLoginInfo()["userID"] as? String
            } else {
                textField.text = UserDefaultsManager().getLoginInfo()["companyID"] as? String
            }
            textField.isUserInteractionEnabled=false
        }
        
        border.borderColor = SecondaryGrayColor().cgColor
        border.frame = CGRect(x: paddingView.frame.size.width-borderWidth, y:0, width:borderWidth, height: paddingView.frame.size.height)
        border.borderWidth = borderWidth
        
        paddingView.layer.addSublayer(border)
        paddingView.layer.masksToBounds = true
        
        imageView.image=UIImage.init(named:imageName)!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageView.tintColor=secondaryColor()
        
        RowView.backgroundColor=PrimaryGrayColor()
        RowView.addSubview(textField)
        RowView.addSubview(paddingView)
        RowView.addSubview(imageView)
        
        return RowView
    }
    
    func Back() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissPasswordView"), object: nil)
        if (willDismissToLogin){
            AppDelegate.vc.dismiss(animated: true, completion: nil)
        }
    }
    
    func removeSuccessDialog() {
        if self.dialog != nil{
            self.dialog.removeFromSuperview()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissPasswordView"), object: nil)
            MainViewController.shouldReload=true
            if (willDismissToLogin){
                AppDelegate.vc.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func removeFailedDialog() {
        if self.dialog != nil{
            self.dialog.removeFromSuperview()
            AppDelegate.getDelegate().doClose()
            if (willDismissToLogin && dismissAfterDialog){
                AppDelegate.vc.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- TextFieldDelegate
    func textFieldShouldReturn(_ textField : UITextField) -> Bool{
        if(OLD_PASS_Text==textField){
            NEW_PASS_Text.becomeFirstResponder()
        }
        if(NEW_PASS_Text==textField){
            CONF_PASS_Text.becomeFirstResponder()
        }
        if(CONF_PASS_Text==textField){
            if (OLD_PASS_Text.text != "" && NEW_PASS_Text.text != "" && CONF_PASS_Text.text != ""){
                ChangePasswordPressed()
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField==NEW_PASS_Text || textField==CONF_PASS_Text) {
            let maxLength = 24
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return (newString.length <= maxLength)
        }
        return true
    }
    
    func EnableChangePasswordButton() {
        if (OLD_PASS_Text.text != "" && NEW_PASS_Text.text != "" && CONF_PASS_Text.text != ""){
            ChangPasswordButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
            ChangPasswordButton.isUserInteractionEnabled = true
        } else{
            ChangPasswordButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
            ChangPasswordButton.isUserInteractionEnabled = false
            
            
        }
    }
    
    func IsAcceptablePassword(string:String)->Bool{
        let containerSpec:String="^(?=.{8,24})(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[ ~!@#$%^&*_=+|';:,<.>/?]).*$"
        if (AppDelegate.getDelegate().matchesForRegexCaseSensitive(containerSpec: containerSpec, text: string) != []){
            return true
        }
        return false
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
    
    //MARK:-Keyboard Functions
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        //        self.ScrollView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height+30, 0.0)
        
        self.ScrollViewContentInset = self.ScrollView.contentInset
        
        self.ScrollView.contentInset = contentInsets
        self.ScrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        
        if (!aRect.contains(ChangPasswordButton.frame.origin)){
            self.ScrollView.scrollRectToVisible(ChangPasswordButton.frame, animated: true)
        }
        
    }

    func keyboardWillBeHidden(notification: NSNotification){
        self.ScrollView.contentInset = self.ScrollViewContentInset
        self.ScrollView.scrollIndicatorInsets = self.ScrollViewContentInset
        self.view.endEditing(true)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK:- ChangePassword & APIcall
    func ChangePasswordPressed() {
        dismissKeyboard()
        if NEW_PASS_Text.text == CONF_PASS_Text.text {
            if IsAcceptablePassword(string: NEW_PASS_Text.text!) {
                let url = Constants.BagJourneyHost + Constants.ChangePasswordEndPoint
                let stringToPost = buildStringToPost()
                let apicall = APICall()
                apicall.getResponseForURL(url, jsonToPost: stringToPost, isAuthenticationRequired: false, method: "POST", errorTitle:nil, hideLoader: false) { (responseDic, statusCode, data, error) in
                    AppDelegate.getDelegate().hideLoadingIndicatorView()
                    var errorMessage:String = ""
                    if (responseDic != nil){
                        let response : [String:Any] = responseDic as! [String:Any]
                        if (response.count>0){
                            if (response["success"] != nil){
                                if (response["success"] as! Bool){
                                    self.dismissAfterDialog = true
                                    var successMessage = response["success_message"] as! String
                                    if (self.forceChangePass){
                                        successMessage = response["success_message"] as! String + "reset_password_success_extra".localized
                                    }
                                    self.dialog = GetSimpleDialogView(LabelText:successMessage, Image:true, Y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/8))
                                    self.dialog.backgroundColor=QueueBackgroundColor()
                                    AppDelegate.getDelegate().showOverlayWithView(viewToShow: self.dialog, dismiss: false, AccessToMenu: false)
                                    AppDelegate.DialogsDismissClock = Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(self.removeSuccessDialog), userInfo: nil, repeats: false)
                                } else {
                                    if let errorDic = response["errors"]{
                                        if let value = ((errorDic as! NSArray).firstObject as! NSDictionary).value(forKey: "error_description"){
                                            errorMessage = value as! String
                                        }
                                    }
                                    self.dialog = GetSimpleDialogView(LabelText:errorMessage, Image:false, Y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/8))
                                    self.dialog.backgroundColor=QueueBackgroundColor()
                                    AppDelegate.getDelegate().showOverlayWithView(viewToShow: self.dialog, dismiss: true, AccessToMenu: false)
                                    AppDelegate.DialogsDismissClock = Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(self.removeFailedDialog), userInfo: nil, repeats: false)
                                }
                            } else {
                                if (statusCode == 0 || statusCode == 1){
                                    errorMessage = "Network_Connection_Issue".localized
                                    self.dialog = GetSimpleDialogView(LabelText:errorMessage, Image:false, Y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/8))
                                    self.dialog.backgroundColor=QueueBackgroundColor()
                                    AppDelegate.getDelegate().showOverlayWithView(viewToShow: self.dialog, dismiss: true, AccessToMenu: false)
                                    AppDelegate.DialogsDismissClock = Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(self.removeFailedDialog), userInfo: nil, repeats: false)
                                }
                            }
                        }else{
                            if (statusCode == 404 && (error != nil)){
                                errorMessage = "requestFailed".localized
                            }else{
                                errorMessage="Network_Connection_Issue".localized
                            }
                            self.dialog = GetSimpleDialogView(LabelText:errorMessage, Image:false, Y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/8))
                            self.dialog.backgroundColor=QueueBackgroundColor()
                            AppDelegate.getDelegate().showOverlayWithView(viewToShow: self.dialog, dismiss: true, AccessToMenu: false)
                            AppDelegate.DialogsDismissClock = Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(self.removeFailedDialog), userInfo: nil, repeats: false)
                        }
                    }else{
                        if (statusCode == 404 && (error != nil)){
                            errorMessage = "requestFailed".localized
                        }else{
                            errorMessage="Network_Connection_Issue".localized
                        }
                        self.dialog = GetSimpleDialogView(LabelText:errorMessage, Image:false, Y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/8))
                        self.dialog.backgroundColor=QueueBackgroundColor()
                        AppDelegate.getDelegate().showOverlayWithView(viewToShow: self.dialog, dismiss: true, AccessToMenu: false)
                        AppDelegate.DialogsDismissClock = Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(self.removeFailedDialog), userInfo: nil, repeats: false)
                    }
                }
                AppDelegate.getDelegate().ShowLoaderIndicatorView()
            } else {
                ShakeTextField(cell: NEW_PASS_Text)
                ShakeTextField(cell: CONF_PASS_Text)
                AppDelegate.DialogsDismissClock = Timer.scheduledTimer(timeInterval:0.3, target: self, selector: #selector(self.showPasswordErrorDialog), userInfo: nil, repeats: false)
            }
        } else {
            ShakeTextField(cell: NEW_PASS_Text)
            ShakeTextField(cell: CONF_PASS_Text)
            AppDelegate.DialogsDismissClock = Timer.scheduledTimer(timeInterval:0.3, target: self, selector: #selector(self.showPasswordErrorDialog), userInfo: nil, repeats: false)
        }
    }
    
    func showPasswordErrorDialog () {
        
        var message = ""
        if NEW_PASS_Text.text != CONF_PASS_Text.text {
            message = "passwordDialogNotMatch".localized
        } else {
            message = "passwordDialogNotValid".localized
        }
        self.dialog = GetSimpleDialogView(LabelText:message, Image:false, Y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/8))
        AppDelegate.getDelegate().showOverlayWithView(viewToShow: self.dialog, dismiss: true, AccessToMenu: false)
        self.dialog.backgroundColor=QueueBackgroundColor()
        AppDelegate.DialogsDismissClock = Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(self.removeFailedDialog), userInfo: nil, repeats: false)
    }
    
    func buildStringToPost() -> String {
        var body = "{"
        body = body.appending("\"")
        body = body.appending("user_id")
        body = body.appending("\"")
        body = body.appending(":")
        body = body.appending("\"")
        body = body.appending(String(USER_ID_Text.text!))
        body = body.appending("\"")
        body = body.appending(",")
        
        body = body.appending("\"")
        body = body.appending("company_id")
        body = body.appending("\"")
        body = body.appending(":")
        body = body.appending("\"")
        body = body.appending(String(COMPANY_ID_Text.text!))
        body = body.appending("\"")
        body = body.appending(",")
        
        body = body.appending("\"")
        body = body.appending("old_password")
        body = body.appending("\"")
        body = body.appending(":")
        body = body.appending("\"")
        body = body.appending(increptPassword(password: String(OLD_PASS_Text.text!)))
        body = body.appending("\"")
        body = body.appending(",")
        
        body = body.appending("\"")
        body = body.appending("new_password")
        body = body.appending("\"")
        body = body.appending(":")
        body = body.appending("\"")
        body = body.appending(increptPassword(password: String(NEW_PASS_Text.text!)))
        body = body.appending("\"")
        body = body.appending(",")
        
        body = body.appending("\"")
        body = body.appending("confirm_password")
        body = body.appending("\"")
        body = body.appending(":")
        body = body.appending("\"")
        body = body.appending(increptPassword(password: String(CONF_PASS_Text.text!)))
        body = body.appending("\"")
        body = body.appending("}")
        
        return body
    }
}
