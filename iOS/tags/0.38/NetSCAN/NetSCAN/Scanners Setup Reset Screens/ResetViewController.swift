//
//  ResetViewController.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 9/15/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController {
    
    @IBOutlet var ResetImageView: UIImageView!
    @IBOutlet var BackBarButton: UINavigationItem!
    
    var TitleLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)  {
        
        self.navigationController?.view.frame = CGRect(x:0, y:UIApplication.shared.statusBarFrame.size.height,width:(self.navigationController?.view.frame.size.width)!, height:(self.navigationController?.view.frame.size.height)!)
        UIApplication.shared.statusBarStyle = .default
        
        let backButton = UIBarButtonItem.init(title:"Back", style: .done, target: self, action: #selector(NavigationFunction))
        BackBarButton.leftBarButtonItem = backButton
        TitleLabel = UITextView.init(frame: CGRect(x:20,y:100, width:(AppDelegate.getDelegate().window?.frame.width)!-40, height:140))
        TitleLabel.font=UIFont.systemFont(ofSize: 17)
        TitleLabel.isEditable=false
        TitleLabel.isScrollEnabled=false
        if((UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized)){
            TitleLabel.frame = CGRect(x:0,y:Constants.UIScreenMainHeight/6, width:UIScreen.main.bounds.width, height:30)
            ResetImageView.image=UIImage(named:"DataManFactorySetting")
            TitleLabel.text="DataMan_reset".localized
            TitleLabel.textAlignment=NSTextAlignment.center
        }else{
            TitleLabel.text="reset_scanner_text".localized
        }
        ResetImageView.frame = CGRect(x:60,y:TitleLabel.frame.height+TitleLabel.frame.origin.y+30,width:UIScreen.main.bounds.width-120, height:UIScreen.main.bounds.width-120)
        self.view.addSubview(TitleLabel)
        AppDelegate.getDelegate().doClose()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        // ResetViewController will back to setup screen when dismissed
        _=self.navigationController?.popViewController(animated: true)
    }
}
