//
//  SetupViewController.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 9/15/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    
    @IBOutlet var LabelTitle: UILabel!
    @IBOutlet var IOSModeBarCodeImageView: UIImageView!
    @IBOutlet var FactoryResetButton: UIButton!
    @IBOutlet var NavigationItem: UINavigationItem!
    
    var ResetView:ResetViewController!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(){
        self.init(nibName:"SetupViewController.xib", bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)  {
        
        self.navigationController?.view.frame = CGRect(x:0, y:UIApplication.shared.statusBarFrame.size.height,width:(self.navigationController?.view.frame.size.width)!, height:(self.navigationController?.view.frame.size.height)!)
        UIApplication.shared.statusBarStyle = .default
        
        LabelTitle.frame = CGRect(x:20,y:50, width:UIScreen.main.bounds.width-40, height:Constants.UIScreenMainHeight/4)
        LabelTitle.adjustsFontSizeToFitWidth=true
        if((UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized)){
            LabelTitle.frame = CGRect(x:0,y:Constants.UIScreenMainHeight/6, width:UIScreen.main.bounds.width, height:50)
            LabelTitle.textAlignment=NSTextAlignment.center
            IOSModeBarCodeImageView.image=UIImage(named:"DataManiOSMode")
            LabelTitle.text="DataMan_iOS_Mode".localized
            LabelTitle.numberOfLines=2
        }else{
            LabelTitle.text="setup_scanner_text".localized
        }
        IOSModeBarCodeImageView.frame = CGRect(x:60,y:LabelTitle.frame.height+LabelTitle.frame.origin.y+30,width:UIScreen.main.bounds.width-120, height:UIScreen.main.bounds.width-120)
        FactoryResetButton.frame = CGRect(x:80,y:IOSModeBarCodeImageView.frame.height+IOSModeBarCodeImageView.frame.origin.y+20,width:UIScreen.main.bounds.width-160,height: 50)
        FactoryResetButton.addTarget(self, action:#selector(NavigatToResetView), for: .touchUpInside)
        let BackButton = UIBarButtonItem.init(title: "Back", style: .done, target: self, action: #selector(ReturnToMainActivity))
        NavigationItem.leftBarButtonItem = BackButton
        AppDelegate.getDelegate().doClose()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.view.frame = CGRect(x:0, y:0,width:(self.navigationController?.view.frame.size.width)!, height:(self.navigationController?.view.frame.size.height)!)
        if primaryColor() == UIColor.black {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
    }
    
    func ReturnToMainActivity(){
        if (AppDelegate.ShouldReturnToTestingScannerConnectivityView){
            AppDelegate.vc.ConnectivityView.IsLoggingIn=false
            AppDelegate.IsUSerINMainView=false
            _=self.navigationController?.popViewController(animated: true)
        }else{
            AppDelegate.IsUSerINMainView=true
            AppDelegate.getDelegate().ReloadMainViewAfterScannerSetupIsDone()
        }
    }
    
    func NavigatToResetView(){
        ResetView=ResetViewController()
        self.navigationController?.pushViewController(ResetView, animated:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
