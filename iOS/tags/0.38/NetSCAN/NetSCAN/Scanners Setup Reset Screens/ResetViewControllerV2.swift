//
//  ResetViewControllerV2.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 10/19/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit

class ResetViewControllerV2: UIViewController {
    
    @IBOutlet var LAbel: UILabel!
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var BackBarButton: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)  {
        
        self.navigationController?.view.frame = CGRect(x:0, y:UIApplication.shared.statusBarFrame.size.height,width:(self.navigationController?.view.frame.size.width)!, height:(self.navigationController?.view.frame.size.height)!)
        UIApplication.shared.statusBarStyle = .default
        
        let backButton = UIBarButtonItem.init(title:"Back", style: .done, target: self, action: #selector(NavigationFunction))
        BackBarButton.leftBarButtonItem = backButton
        LAbel.frame = CGRect(x:20,y:50, width:UIScreen.main.bounds.width-40, height:Constants.UIScreenMainHeight/4)
        LAbel.adjustsFontSizeToFitWidth=true
        if((UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized)){
            LAbel.frame = CGRect(x:0,y:Constants.UIScreenMainHeight/6, width:UIScreen.main.bounds.width, height:30)
            ImageView.image=UIImage(named:"DataManFactorySetting")
            LAbel.text="DataMan_reset".localized
            LAbel.textAlignment=NSTextAlignment.center
            LAbel.adjustsFontSizeToFitWidth=true
        }else{
            LAbel.text="reset_scanner_text".localized
        }
        ImageView.frame = CGRect(x:60,y:LAbel.frame.height+LAbel.frame.origin.y+30,width:UIScreen.main.bounds.width-120, height:UIScreen.main.bounds.width-120)
        AppDelegate.getDelegate().doClose()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.view.frame = CGRect(x:0, y:0,width:(self.navigationController?.view.frame.size.width)!, height:(self.navigationController?.view.frame.size.height)!)
        if primaryColor() == UIColor.black {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
    }
    
    @objc func NavigationFunction(){
        // ResetViewControllerV2 will back either to homeScreen or to connectivityScreen
        if (AppDelegate.ShouldReturnToTestingScannerConnectivityView){
            AppDelegate.vc.ConnectivityView.IsLoggingIn=false
            AppDelegate.IsUSerINMainView=false
            _=self.navigationController?.popViewController(animated: true)
        } else {
            AppDelegate.IsUSerINMainView=true
            AppDelegate.getDelegate().ReloadMainViewAfterScannerSetupIsDone()
        }
    }
}
