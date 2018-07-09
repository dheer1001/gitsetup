//
//  BingoViewController.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 11/23/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit


class BingoViewController: UIViewController {
    
    var circularBar:CircleProgressBar!
    
    var numberOfBags:Int!
    var remainingBags:Int!
    var flightInfo:NSDictionary!
    var bagsArray:NSMutableArray!
    
    var remainingBagsLabel:UILabel!
    var bingoSuccessLabel:UILabel!
//    var resetLabel:UILabel!
    var submitLabel:UILabel!
    var submitButton:UIButton!
    var submitCaution:UIView!
    var trackingLocation:String!
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = Constants.UIScreenMainHeight
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.getDelegate().ScanManagerInstance.EnablecodeBags()
        initQueue()
        LoadComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.IsUSerINMainView=false
        AppDelegate.getDelegate().doClose()
        if UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized {
            AppDelegate.vc.ConnectivityView.CognexManager.continuesMode(ON_OFF: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if trackingLocation != nil {
            AppDelegate.IsUSerINMainView=true
            AppDelegate.getDelegate().OnDecodedData(data: trackingLocation,showTrackingIdentifier: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initQueue() {
        bagsArray = NSMutableArray()
        if UserDefaults.standard.value(forKey:"bingo") != nil{
            let tempQueue = UserDefaults.standard.value(forKey:"bingo") as! NSMutableDictionary
            let bags = tempQueue.value(forKey:"bagsArray")
            numberOfBags = tempQueue.value(forKey: "numberOfBags") as! Int
            flightInfo = tempQueue.value(forKey: "flightInfo") as! NSDictionary
            if bags != nil && (bags as! NSArray).count > 0 {
                for bag in bags as! NSArray {self.bagsArray.add(bag as! String)}
            }
            remainingBags = numberOfBags-bagsArray.count
        } else {
            let tempQueue :NSMutableDictionary = NSMutableDictionary()
            tempQueue.setValue(nil, forKey: "bagsArray")
            tempQueue.setValue(numberOfBags, forKey:"numberOfBags")
            tempQueue.setValue(flightInfo, forKey:"flightInfo")
            UserDefaults.standard.set(tempQueue, forKey: "bingo")
            remainingBags=numberOfBags
        }
    }
    
    func updateQueue() {
        let tempQueue :NSMutableDictionary = NSMutableDictionary()
        tempQueue.setValue(bagsArray, forKey: "bagsArray")
        tempQueue.setValue(numberOfBags, forKey:"numberOfBags")
        tempQueue.setValue(flightInfo, forKey:"flightInfo")
        UserDefaults.standard.removeObject(forKey:"bingo")
        UserDefaults.standard.set(tempQueue, forKey: "bingo")
        UserDefaults.standard.synchronize()
        updateProgressCircle()
    }
    
    func LoadComponents() {
        
        var startY = screenHeight/22.25
        
        self.view.backgroundColor=primaryColor()
        
        let bingoLabel = UILabel(frame: CGRect(x:screenWidth/37.5, y:startY, width: screenWidth-(2*(screenWidth/37.5)), height:screenHeight/33.35))
        bingoLabel.textAlignment = .center
        bingoLabel.font=UIFont.boldSystemFont(ofSize: screenHeight/33.35)
        bingoLabel.text="bingoMode".localized.uppercased()
        bingoLabel.textColor=secondaryColor()
        startY += bingoLabel.frame.size.height + screenHeight/33.35
        self.view.addSubview(bingoLabel)
        
        let scannerImageView:UIImageView = UIImageView(frame:(CGRect(x:(screenWidth/2)-screenWidth/20,y:startY,width:screenWidth/10,height:screenWidth/10)))
        let image :UIImage = UIImage.init(named: "bar-code-scanner")!
        let flippedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: UIImageOrientation.upMirrored)
        scannerImageView.image=flippedImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        scannerImageView.tintColor=secondaryColor()
        startY += scannerImageView.frame.size.height + screenHeight/33.35
        self.view.addSubview(scannerImageView)
        
        let startScanLabel = UILabel(frame: CGRect(x:screenWidth/37.5, y:startY, width: screenWidth-(2*(screenWidth/37.5)), height:screenHeight/33.35))
        startScanLabel.textAlignment = .center
        startScanLabel.font=UIFont.systemFont(ofSize: screenHeight/33.35)
        startScanLabel.text="continuesScanning".localized
        startScanLabel.textColor=secondaryColor()
        startY += startScanLabel.frame.size.height + screenHeight/33.35
        self.view.addSubview(startScanLabel)
        
        self.view.addSubview(pogressCircle(startY: startY, raduis:screenWidth/2.5))
        startY += (screenWidth/2.5)+screenHeight/16.65
        
        bingoSuccessLabel = UILabel(frame: CGRect(x:screenWidth/37.5, y:startY, width: screenWidth-(2*(screenWidth/37.5)), height:screenHeight/16.65))
        bingoSuccessLabel.textAlignment = .center
        bingoSuccessLabel.font=UIFont.boldSystemFont(ofSize:screenHeight/16.65)
        bingoSuccessLabel.text="bingoSuccess".localized
        bingoSuccessLabel.textColor=secondaryColor()
        bingoSuccessLabel.isHidden=true
        self.view.addSubview(bingoSuccessLabel)
        self.view.addSubview(LoadButtons())
        updateProgressCircle()
    }
    
    func LoadButtons() -> UIView {
        
        let space = screenHeight/33.35
        let startX=screenWidth/13.39
        var startY = (screenHeight/13.34) + space //CGFloat(0) in case of reset buttom not hidden
        
        let buttonsContainerView = UIView(frame: CGRect(x:0, y:screenHeight/2+((screenHeight/3.5)/2), width:screenWidth, height:screenHeight/3.5))
        
        submitLabel = UILabel(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
        submitLabel.layer.borderWidth = 1
        submitLabel.layer.cornerRadius=10
        submitLabel.clipsToBounds=true
        submitLabel.textAlignment = .center
        submitLabel.textColor=secondaryColor()
        submitLabel.numberOfLines=2
        submitLabel.text="Submit Incomplete\n \(numberOfBags-remainingBags)/\(numberOfBags.description)"
        submitLabel.backgroundColor=PrimaryGrayColor()
        buttonsContainerView.addSubview(submitLabel)
        
        submitCaution=UIView(frame: CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
        submitCaution.layer.borderWidth = 1
        submitCaution.layer.cornerRadius=10
        submitCaution.clipsToBounds=true
        submitCaution.backgroundColor=UIColor.clear
        buttonsContainerView.addSubview(submitCaution)
        let cautionImageView1 = UIImageView(frame: CGRect(x:10, y:submitCaution.frame.size.height/4, width:submitCaution.frame.size.height/2, height: submitCaution.frame.size.height/2))
        cautionImageView1.image=UIImage(named: "caution.png")?.withRenderingMode(.alwaysTemplate)
        cautionImageView1.tintColor=primaryColor()
        submitCaution.addSubview(cautionImageView1)
        let cautionImageView2 = UIImageView(frame: CGRect(x:submitCaution.frame.size.width-(submitCaution.frame.size.height/2+(10)), y:submitCaution.frame.size.height/4, width:submitCaution.frame.size.height/2, height: submitCaution.frame.size.height/2))
        cautionImageView2.image=UIImage(named: "caution")?.withRenderingMode(.alwaysTemplate)
        cautionImageView2.tintColor=primaryColor()
        submitCaution.addSubview(cautionImageView2)
        buttonsContainerView.addSubview(submitCaution)
        
        submitButton = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
        submitButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        submitButton.layer.borderColor = PrimaryBoarder().cgColor
        submitButton.layer.borderWidth = 1
        submitButton.layer.cornerRadius=10
        submitButton.clipsToBounds=true
        submitButton.backgroundColor=UIColor.clear
        submitButton.addTarget(self, action: #selector(submitPressed), for: .touchUpInside)
        buttonsContainerView.addSubview(submitButton)
        startY += submitButton.frame.height+space
        
//        resetLabel = UILabel(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
//        resetLabel.layer.borderWidth = 1
//        resetLabel.layer.cornerRadius=10
//        resetLabel.clipsToBounds=true
//        resetLabel.textAlignment = .center
//        resetLabel.textColor=secondaryColor()
//        resetLabel.numberOfLines=2
//        resetLabel.text="bingoResetButton".localized
//        buttonsContainerView.addSubview(resetLabel)
        
//        let ResetButton = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
//        ResetButton.layer.borderColor = PrimaryBoarder().cgColor
//        ResetButton.layer.borderWidth = 1
//        ResetButton.layer.cornerRadius=10
//        ResetButton.clipsToBounds=true
//        ResetButton.backgroundColor=UIColor.clear
//        ResetButton.addTarget(self, action: #selector(resetPressed), for: .touchUpInside)
//        buttonsContainerView.addSubview(ResetButton)
//        startY += ResetButton.frame.height+space
        
        let CancelButton = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
        CancelButton.setTitle("cancel".localized.uppercased(), for:UIControlState.normal)
        CancelButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        CancelButton.layer.borderColor = PrimaryBoarder().cgColor
        CancelButton.layer.borderWidth = 1
        CancelButton.layer.cornerRadius=10
        CancelButton.clipsToBounds=true
        CancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        buttonsContainerView.addSubview(CancelButton)
        
        return buttonsContainerView
    }
    
    func pogressCircle(startY:CGFloat,raduis:CGFloat) -> UIView {
        
        circularBar = CircleProgressBar()
        circularBar.frame=CGRect(x:screenWidth/2-(raduis/2), y:startY, width:raduis, height:raduis)
        circularBar.backgroundColor=UIColor.clear
        circularBar.progressBarWidth=10
        circularBar.progressBarTrackColor = secondaryColor()
        circularBar.hintHidden=true
        circularBar.progressBarProgressColor = GetColorFromHex(rgbValue: 0xFFA500)
        circularBar.setProgress(CGFloat(CGFloat(numberOfBags-remainingBags)/CGFloat(numberOfBags)), animated: true)
        
        let bagImage:UIImageView = UIImageView(frame: CGRect(x:(circularBar.frame.width/2)-raduis/8 , y:(circularBar.frame.height/2)+raduis/8, width:raduis/4, height:raduis/4))
        bagImage.image=UIImage(named: "Bag")?.withRenderingMode(.alwaysTemplate)
        bagImage.tintColor=secondaryColor()
        circularBar.addSubview(bagImage)
        
        remainingBagsLabel = UILabel(frame: CGRect(x:15, y: 10, width:circularBar.frame.width-30, height:2*(raduis/3)))
        remainingBagsLabel.text=remainingBags.description
        remainingBagsLabel.font=UIFont.systemFont(ofSize:raduis/3)
        remainingBagsLabel.adjustsFontSizeToFitWidth=true
        remainingBagsLabel.textColor=secondaryColor()
        remainingBagsLabel.textAlignment=NSTextAlignment.center
        circularBar.addSubview(remainingBagsLabel)
        
        return circularBar
    }
    
    func updateProgressCircle() {
        circularBar.setProgress(CGFloat(CGFloat(numberOfBags-remainingBags)/CGFloat(numberOfBags)), animated: true)
        remainingBagsLabel.text=remainingBags.description
        submitLabel.text="Submit Incomplete\n \(numberOfBags-remainingBags)/\(numberOfBags.description)"
        
        if remainingBags==0 {
            submitCaution.removeFromSuperview()
            submitLabel.text="Submit Bags\n \(numberOfBags-remainingBags)/\(numberOfBags.description)"
            submitLabel.backgroundColor=UIColor.init(red: 0, green: 1, blue: 0, alpha: 0.5)
            bingoSuccessLabel.isHidden=false
            AppDelegate.getDelegate().ScanManagerInstance.DisablecodeBags()
        }
        
//        if numberOfBags == remainingBags {
//            resetLabel.backgroundColor=UIColor.clear
//        } else {
//            resetLabel.backgroundColor=PrimaryGrayColor()
//        }
        
//        resetLabel.setNeedsDisplay()
        remainingBagsLabel.setNeedsDisplay()
        submitLabel.setNeedsDisplay()
        self.view.setNeedsDisplay()
    }
    
    func submitPressed() {
        if remainingBags == 0 {
            submit()
        } else {
            let confirmationView = UIView(frame: CGRect(x:0, y:screenHeight/4, width:screenWidth, height: screenHeight/2))
            confirmationView.layer.borderColor = PrimaryBoarder().cgColor
            confirmationView.layer.borderWidth = 1
            confirmationView.backgroundColor=PrimaryGrayColor().withAlphaComponent(0.9)
            
            let incompleteLabel = UILabel(frame: CGRect(x:10, y:10, width: screenWidth-20, height:50))
            incompleteLabel.textColor=secondaryColor()
            incompleteLabel.textAlignment = .center
            incompleteLabel.font = UIFont.boldSystemFont(ofSize: 20)
            incompleteLabel.text = "\("incompleteConfirmation".localized)\n\(numberOfBags-remainingBags)/\(numberOfBags.description)"
            incompleteLabel.numberOfLines=2
            confirmationView.addSubview(incompleteLabel)
            
            var messageWithS = ""
            if numberOfBags-remainingBags>1{messageWithS = "s"}
            let messageLabel = UILabel(frame: CGRect(x:15, y:incompleteLabel.frame.size.height+10, width: screenWidth-30, height:screenHeight/6.67))
            messageLabel.textAlignment = .center
            messageLabel.text=String(format:"confirmationMessage".localized,numberOfBags.description,(numberOfBags-remainingBags).description,messageWithS)
            messageLabel.textColor=secondaryColor()
            messageLabel.numberOfLines=4
            messageLabel.adjustsFontSizeToFitWidth=true
            confirmationView.addSubview(messageLabel)
            
            
            let space = screenHeight/33.35
            let startX=screenWidth/13.39
            var startY=CGFloat(0)
            
            let buttonsContainerView = UIView(frame: CGRect(x:0, y:(confirmationView.frame.height/2)+10, width:screenWidth, height:confirmationView.frame.height/3))
            
            let submit = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
            submit.layer.borderColor = PrimaryBoarder().cgColor
            submit.setTitle("submit".localized.uppercased(), for:UIControlState.normal)
            submit.layer.borderWidth = 1
            submit.layer.cornerRadius=10
            submit.clipsToBounds=true
            submit.backgroundColor=SecondaryGrayColor()
            submit.addTarget(self, action: #selector(self.submit), for: .touchUpInside)
            buttonsContainerView.addSubview(submit)
            startY += submit.frame.height+space
            
            let CancelButton = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
            CancelButton.setTitle("cancel".localized.uppercased(), for:UIControlState.normal)
            CancelButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
            CancelButton.layer.borderColor = PrimaryBoarder().cgColor
            CancelButton.layer.borderWidth = 1
            CancelButton.layer.cornerRadius=10
            CancelButton.clipsToBounds=true
            CancelButton.addTarget(self, action: #selector(cancelConfirmation), for: .touchUpInside)
            buttonsContainerView.addSubview(CancelButton)
            
            confirmationView.addSubview(buttonsContainerView)
            
            AppDelegate.getDelegate().showOverlayWithView(viewToShow: confirmationView, dismiss: false, AccessToMenu: false)
            
        }
    }
    
    func onScanningData(bagTag:String) {
        if (AppDelegate.getDelegate().ScanManagerInstance.isValidTrackingLocation(trackingLocation: bagTag)){
            if UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized {
                if AppDelegate.vc.ConnectivityView.CognexManager.readerDevice != nil {
                    if AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem() != nil {
                        if AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.connectionState == CMBConnectionStateConnected {
                            AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem().sendCommand("BEEP 1 2")
                        }
                    }
                }
            }
            deleteTemporaryData()
            trackingLocation=bagTag
            AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: true)
        } else if (AppDelegate.getDelegate().ScanManagerInstance.isValidBag(bagTag: bagTag)) {
            if bagsArray != nil && !bagsArray.contains(bagTag){
            bagsArray.add(bagTag)
            remainingBags = remainingBags - 1
                updateQueue()
                if UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized {
                    if AppDelegate.vc.ConnectivityView.CognexManager.readerDevice != nil {
                        if AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem() != nil {
                            if AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.connectionState == CMBConnectionStateConnected {
                                AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem().sendCommand("BEEP 1 2")
                            }
                        }
                    }
                }
            } else if bagsArray == nil {
                let tempQueue = UserDefaults.standard.value(forKey:"bingo") as! NSMutableDictionary
                let bags = tempQueue.value(forKey:"bagsArray")
                if bags == nil {
                    bagsArray = NSMutableArray()
                } else {
                    bagsArray = bags as! NSMutableArray
                }
                bagsArray.add(bagTag)
                remainingBags = remainingBags - 1
                updateQueue()
                if UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized {
                    if AppDelegate.vc.ConnectivityView.CognexManager.readerDevice != nil {
                        if AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem() != nil {
                            if AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.connectionState == CMBConnectionStateConnected {
                                AppDelegate.vc.ConnectivityView.CognexManager.readerDevice?.dataManSystem().sendCommand("BEEP 1 2")
                            }
                        }
                    }
                }
            }
        } else if (AppDelegate.getDelegate().ScanManagerInstance.isValidBingoLocation(trackingLocation: bagTag)){
            trackingLocation=bagTag
            cancelPressed()
        }
    }
    
    func resetPressed() {
        UserDefaults.standard.removeObject(forKey: "bingo")
        UserDefaults.standard.synchronize()
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        initQueue()
        LoadComponents()
        AppDelegate.getDelegate().ScanManagerInstance.EnablecodeBags()
    }
    
    func cancelPressed() {
        if UserDefaults.standard.string(forKey: "scannerType") == "cognex_scanner".localized {
            AppDelegate.vc.ConnectivityView.CognexManager.continuesMode(ON_OFF: false)
        }
        deleteTemporaryData()
        ScanManager.LocalStorage.removeFlightInformation()
        ScanManager.LocalStorage.RemoveTrackingLocation()
        ScanManager.LocalStorage.RemoveTrackingPointRaw()
        ScanManager.LocalStorage.RemoveTrackingPointValidityUntil()
        AppDelegate.vc.MainViewControllerPointer.RemoveFlightInformationView()
        AppDelegate.vc.MainViewControllerPointer.RemoveFligthAirPlaneInformationView()
        AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: true)
    }
    
    func deleteTemporaryData() {
        UserDefaults.standard.removeObject(forKey: "bingo")
        ScanManager.LocalStorage.removeFlightInformation()
        ScanManager.LocalStorage.RemoveTrackingLocation()
        ScanManager.LocalStorage.RemoveTrackingPointRaw()
        ScanManager.LocalStorage.RemoveTrackingPointValidityUntil()
    }
    
    func submit() {
        let unkownBags = AppDelegate.getDelegate().getUnknownBags(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation())
        for bagTag in bagsArray {
            let bag = AppDelegate.getDelegate().ScanManagerInstance.buildBagObjFromScan(bagScanString: bagTag as! String)
            if unkownBags == "I" {
                ScanManager.LocalStorage.saveContainerToCoredata(scanDateTime: Date(), trackingPoint: ScanManager.LocalStorage.GetTrackingLocation(), containerID:"", bagTag: bag.bagTag,itemType:"bag",synced: false, locked: false, errorMsg: "")
            } else if unkownBags == "S" {
                let FligthInformation:NSMutableDictionary = ScanManager.LocalStorage.getFlightInformation()
                let flight_num = FligthInformation["flight_num"] as! String
                let flight_type = FligthInformation.value(forKey: "flight_type") as! String
                let flight_date = FligthInformation.value(forKey: "flight_date") as! Date
                
                ScanManager.LocalStorage.saveBagToCoredata(scanDateTime:Date(), trackingPoint:ScanManager.LocalStorage.GetTrackingLocation(), containerID:"", bagTag:bag.bagTag,itemType:"bag",flight_num: "\(flight_num)", flight_type:flight_type, flight_date:flight_date,synced: false,locked:false , errorMsg:"")
            }
        }
        cancelPressed()
       AppDelegate.getDelegate().ScanManagerInstance.processScannedItemsQueue()
    }
    func cancelConfirmation() {
        AppDelegate.getDelegate().doClose()
    }
}
