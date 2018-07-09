//
//  PermissionsView.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 6/4/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class PermissionsView: UIViewController {
    
    @IBOutlet var permissionScroll: UIScrollView!
    @IBOutlet var btnView: UIView!
    @IBOutlet var btnImage: UIImageView!
    @IBOutlet var permissionName: UILabel!
    @IBOutlet var permissionDescription: UILabel!
    @IBOutlet var option1: UIButton!
    @IBOutlet var option2: UIButton!
    
    var permissionType:NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        self.view.frame = CGRect(x:0, y:0,width: screenWidth,height:screenHeight)
        self.permissionScroll.frame = CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.view.frame.size.height)
        self.permissionScroll.backgroundColor = primaryColor()

        var y:CGFloat = CGFloat(self.permissionScroll.frame.size.height/4)
        
        self.btnView.frame = CGRect(x:CGFloat((self.permissionScroll.frame.size.width-70)/2),y:CGFloat(y-70/2),width:CGFloat(70),height:CGFloat(70))
        self.btnView.clipsToBounds = true
        self.btnView.layer.cornerRadius = self.btnView.frame.size.width/2
        
        self.btnImage.frame = CGRect(x:15,y:15,width:40,height:40)

        var text = ""
        var text2 = ""

        if (permissionType.isEqual(to: "cameraNotdetermined")){
            btnImage.image = UIImage(named: "appleCamera")
            text = "permission_camera_title".localized
            text2 = "permission_camera".localized
        }
        if (permissionType.isEqual(to: "cameraDisabled")){
            btnImage.image = UIImage(named: "appleCamera")
            text = "permission_camera_title".localized
            text2 = "permission_camera_denied".localized
        }

        if (permissionType.isEqual(to: "notifNotDetermined")){
            btnImage.image = UIImage(named: "appleNotifications")?.withRenderingMode(.alwaysTemplate)
            btnImage.tintColor = primaryColor()
            btnImage.backgroundColor = secondaryColor()
            btnImage.layer.cornerRadius = 5
            btnImage.clipsToBounds = true
            
            text = "permission_notifications_title".localized
            text2 = "permission_notifications".localized
        }
        
        if (permissionType.isEqual(to: "notifDisabled")){
            btnImage.image = UIImage(named: "appleNotifications")?.withRenderingMode(.alwaysTemplate)
            btnImage.tintColor = primaryColor()
            btnImage.backgroundColor = secondaryColor()
            btnImage.layer.cornerRadius = 5
            btnImage.clipsToBounds = true
            
            text = "permission_notifications_title".localized
            text2 = "permission_notifications_denied".localized
        }

        permissionScroll.bringSubview(toFront:btnView)
        y = y+(self.btnView.frame.size.height/2)+35

        permissionName.frame = CGRect(x:0, y:y, width: permissionScroll.frame.size.width, height: 22)
        permissionName.text = text
        permissionName.adjustsFontSizeToFitWidth = true
        permissionName.textAlignment = .center
        permissionName.textColor = secondaryColor()
        y = y+permissionName.frame.size.height
        
        permissionDescription.frame = CGRect(x:50, y:y, width:permissionScroll.frame.size.width-100, height:110)
        permissionDescription.text = text2
        permissionDescription.adjustsFontSizeToFitWidth = true
        permissionDescription.textAlignment = .center
        permissionDescription.lineBreakMode = .byWordWrapping
        permissionDescription.numberOfLines = 0
        permissionDescription.textColor = secondaryColor()
        y = y+permissionDescription.frame.size.height+40

        option1.frame = CGRect(x: (self.permissionScroll.frame.size.width - 250)/2, y: y, width: 250, height: 50)
        option1.clipsToBounds = true
        option1.layer.cornerRadius = 10
        option1.layer.borderWidth = 1
        option1.layer.backgroundColor = secondaryColor().cgColor
        option1.layer.borderColor = secondaryColor().cgColor
        option1.setTitle("permission_yes".localized, for: .normal)
        option1.titleLabel?.textAlignment = .center
        option1.titleEdgeInsets = UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0)
        option1.titleLabel?.adjustsFontSizeToFitWidth = true
        option1.tintColor = primaryColor()
        y = y+self.option1.frame.size.height+20;
        
        option2.frame = CGRect(x: (self.permissionScroll.frame.size.width - 250)/2, y: y, width: 250, height: 50)
        option2.clipsToBounds = true
        option2.layer.cornerRadius = 10
        option2.layer.borderWidth = 1
        option2.layer.backgroundColor = secondaryColor().cgColor
        option2.layer.borderColor = secondaryColor().cgColor
        option2.setTitle("permission_no".localized, for: .normal)
        option2.titleLabel?.textAlignment = .center
        option2.titleEdgeInsets = UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0)
        option2.titleLabel?.adjustsFontSizeToFitWidth = true
        option2.tintColor = primaryColor()
        y = y+self.option2.frame.size.height+20;
        
        let recognizer1 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(option1Selected(recognizer:)))
        option1.addGestureRecognizer(recognizer1)
        
        let recognizer2 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(option2Selected(recognizer:)))
        option2.addGestureRecognizer(recognizer2)
     
        permissionScroll.contentSize = CGSize(width: self.permissionScroll.frame.size.width, height: y)   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func option1Selected(recognizer:UITapGestureRecognizer) {
        if (permissionType.isEqual(to: "cameraNotdetermined")){
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo,completionHandler: { (granted) in
                DispatchQueue.main.async {
                    if (granted){
                        AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: false)
                    } else {
                        self.showCameraAlert(msg: "camera_alert".localized)
                    }
                }
            })
        }
        if (permissionType.isEqual(to: "cameraDisabled")){
             DispatchQueue.main.async {
                self.showCameraAlert(msg: "camera_alert".localized)
            }
        }
        if (permissionType.isEqual(to: "notifNotDetermined")){
            let notifCenter = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert,.sound]
            notifCenter.requestAuthorization(options: options, completionHandler: { (guranted, error) in
                DispatchQueue.main.async {
                    if (guranted){
                        AppDelegate.vc.continueAfterLoginSucess(Airports: AppDelegate.vc.tempoAirports, Airlines: AppDelegate.vc.tempoAirlines, response: AppDelegate.vc.tempoResponse, UserID: AppDelegate.vc.tempoUserID)
                    } else {
                        self.showCameraAlert(msg: "notifications_alert".localized)
                    }
                }
            })
        }
    }
    
    func option2Selected(recognizer:UITapGestureRecognizer) {
        DispatchQueue.main.async {
            if (self.permissionType.contains("camera")){
                AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: true)
            } else {
                AppDelegate.vc.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func showCameraAlert(msg:String){
        let cameraAlert : UIAlertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        cameraAlert.addAction(UIAlertAction(title: "later".localized, style: .cancel, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        cameraAlert.addAction(UIAlertAction(title: "Settings".localized, style: .default, handler: { (alert) in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        DispatchQueue.main.async {
            self.present(cameraAlert, animated: true, completion: nil)
        }
    }
}
