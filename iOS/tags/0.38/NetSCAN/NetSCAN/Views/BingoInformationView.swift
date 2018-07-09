//
//  BingoInformationView.swift
//  NetSCAN
//
//  Created by Issa Al Zayed on 11/28/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class BingoInformationView: UIViewController,UITextFieldDelegate {
    
    var withFlightInfo:Bool!
    var arrDepSeg: UISegmentedControl!
    var datePickerTextField: CustomUITextField!
    var FlightTextField: UITextField!
    var NumberOfBagsTextField:UITextField!
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = Constants.UIScreenMainHeight
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=true
        AppDelegate.IsUSerINMainView=false
        AppDelegate.getDelegate().doClose()
        self.view.backgroundColor=primaryColor()
        
        //Keyboard controller
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        loadComponent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadComponent() {
        
        var startY = screenHeight/22.25
        
        let titleLabel = UILabel(frame: CGRect(x:screenWidth/37.5, y:startY, width: screenWidth-(2*(screenWidth/37.5)), height:screenHeight/33.35))
        titleLabel.textAlignment = .center
        titleLabel.font=UIFont.boldSystemFont(ofSize: screenHeight/33.35)
        titleLabel.text="bingoSheetDetected".localized.uppercased()
        titleLabel.textColor=secondaryColor()
        startY += titleLabel.frame.size.height + screenHeight/33.35
        self.view.addSubview(titleLabel)
        
        let aditionalInfoLabel = UILabel(frame: CGRect(x:screenWidth/37.5, y:startY, width: screenWidth-(2*(screenWidth/37.5)), height:screenHeight/33.35))
        aditionalInfoLabel.textAlignment = .center
        aditionalInfoLabel.font=UIFont.systemFont(ofSize: screenHeight/33.35)
        aditionalInfoLabel.text="additional_information".localized
        aditionalInfoLabel.textColor=OrangeColorInverted()
        startY += aditionalInfoLabel.frame.size.height + screenHeight/33.35
        self.view.addSubview(aditionalInfoLabel)
        
        if withFlightInfo {
            
            //arrDepSeg
            arrDepSeg = UISegmentedControl()//.init(items:["Arr","Dep"])
            arrDepSeg.frame = CGRect(x:20,y:startY,width:screenWidth-40,height:40)
            arrDepSeg.tintColor = PrimaryBoarder()
            
            let arrView=UIView(frame: CGRect(x:0,y:0,width:arrDepSeg.frame.size.width/2,height:arrDepSeg.frame.size.height))
            let arrImage  = UIImageView(frame:CGRect(x:5, y:5, width:30, height:30))
            arrImage.image = UIImage(named:"plane-landing.png")
            arrImage.image = arrImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            arrImage.tintColor = PrimaryBoarder()
            arrView.addSubview(arrImage)
            
            let arrTitle  = UILabel(frame:CGRect(x:40, y:0, width:arrDepSeg.frame.size.width/2-45, height:40))
            arrTitle.textColor = PrimaryBoarder()
            arrTitle.textAlignment = NSTextAlignment.center
            arrTitle.text = "arrival".localized.uppercased()
            arrTitle.font = UIFont.systemFont(ofSize: 12)
            arrView.addSubview(arrTitle)
            let FinalImage1 = UIImage.renderUIViewToImage(viewToBeRendered: arrView)
            arrDepSeg.insertSegment(with: FinalImage1, at: 0, animated: false)
            
            let DepView=UIView(frame: CGRect(x:0,y:0,width:arrDepSeg.frame.size.width/2,height:arrDepSeg.frame.size.height))
            let DepImage  = UIImageView(frame:CGRect(x:5, y:5, width:30, height:30))
            DepImage.image = UIImage(named:"departures-flights.png")
            DepImage.image = DepImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            DepImage.tintColor = PrimaryBoarder()
            DepView.addSubview(DepImage)
            
            let DepTitle  = UILabel(frame:CGRect(x:40, y:0, width:arrDepSeg.frame.size.width/2-45, height:40))
            DepTitle.textColor = PrimaryBoarder()
            DepTitle.textAlignment = NSTextAlignment.center
            DepTitle.text = "departure".localized.uppercased()
            DepTitle.font = UIFont.systemFont(ofSize: 12)
            DepView.addSubview(DepTitle)
            let FinalImage2 = UIImage.renderUIViewToImage(viewToBeRendered: DepView)
            arrDepSeg.insertSegment(with: FinalImage2, at:1, animated: false)
            arrDepSeg.selectedSegmentIndex = 1
            startY += arrDepSeg.frame.size.height + 2*(screenHeight/33.35)
            self.view.addSubview(arrDepSeg)
            
            //flightNumText
            let textColor:UIColor = PrimaryBoarder()
            FlightTextField = UITextField()
            FlightTextField.frame = CGRect(x:20,y:startY,width:screenWidth-40,height:60)
            FlightTextField.attributedPlaceholder = NSAttributedString(string:"flightnumber".localized,attributes:[NSForegroundColorAttributeName: textColor])
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = PrimaryBoarder().cgColor
            border.frame = CGRect(x: 0, y: FlightTextField.frame.size.height - width, width:  FlightTextField.frame.size.width, height: FlightTextField.frame.size.height)
            border.borderWidth = width
            FlightTextField.autocapitalizationType = .allCharacters
            FlightTextField.textColor = secondaryColor()
            FlightTextField.adjustsFontSizeToFitWidth=true
            FlightTextField.font = UIFont.systemFont(ofSize:25)
            FlightTextField.layer.addSublayer(border)
            FlightTextField.layer.masksToBounds = true
            FlightTextField.delegate = self
            FlightTextField.returnKeyType = UIReturnKeyType.next
            startY += FlightTextField.frame.size.height + screenHeight/33.35
            self.view.addSubview(FlightTextField)
            
            datePickerTextField = CustomUITextField()
            datePickerTextField.frame = CGRect(x:20, y:startY, width:screenWidth-40,height:60)
            datePickerTextField.attributedPlaceholder = NSAttributedString(string:"date".localized,attributes:[NSForegroundColorAttributeName: textColor])
            let border2 = CALayer()
            let width2 = CGFloat(1.0)
            border2.borderColor = PrimaryBoarder().cgColor
            border2.frame = CGRect(x: 0, y: datePickerTextField.frame.size.height - width2, width:  datePickerTextField.frame.size.width, height: datePickerTextField.frame.size.height)
            border2.borderWidth = width2
            
            datePickerTextField.textColor = secondaryColor()
            datePickerTextField.adjustsFontSizeToFitWidth=true
            datePickerTextField.font = UIFont.systemFont(ofSize:25)
            datePickerTextField.layer.addSublayer(border2)
            datePickerTextField.layer.masksToBounds = true
            
            let datePickerView  : UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            datePickerView.addTarget(self, action: #selector(handleDatePicker), for: UIControlEvents.valueChanged)
            let date = NSDate()
            datePickerView.minimumDate = date.addingTimeInterval(-60*60*24*1) as Date
            datePickerView.date = date as Date
            datePickerView.maximumDate = date.addingTimeInterval(60*60*24*1) as Date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            datePickerTextField.text = dateFormatter.string(from:date as Date)
            
//            let toolBar:UIToolbar = UIToolbar.init(frame: CGRect(x:0,y:0,width:self.view.frame.size.width,height:44))
//            let flexibleSpace:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//            let doneButton:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done, target:self, action:#selector(dismissKeyboard))
//            toolBar.barStyle = UIBarStyle.default
//            toolBar.setItems([flexibleSpace,doneButton], animated: false)
//            toolBar.backgroundColor = UIColor.lightGray
//            //            datePickerTextField.inputAccessoryView = toolBar

            datePickerTextField.inputView = datePickerView
            startY += datePickerTextField.frame.size.height + screenHeight/33.35
            self.view.addSubview(datePickerTextField)
            
        } else {
            startY = screenHeight/2-30
        }
        
        NumberOfBagsTextField = UITextField()
        NumberOfBagsTextField.frame = CGRect(x:20,y:startY,width:screenWidth-40,height:60)
        NumberOfBagsTextField.attributedPlaceholder = NSAttributedString(string:"numberOfBags".localized,attributes:[NSForegroundColorAttributeName: PrimaryBoarder()])
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y: NumberOfBagsTextField.frame.size.height - width, width:  NumberOfBagsTextField.frame.size.width, height: NumberOfBagsTextField.frame.size.height)
        border.borderWidth = width
        NumberOfBagsTextField.textColor = secondaryColor()
        NumberOfBagsTextField.keyboardType = .numberPad
        NumberOfBagsTextField.adjustsFontSizeToFitWidth=true
        NumberOfBagsTextField.font = UIFont.systemFont(ofSize:25)
        NumberOfBagsTextField.layer.addSublayer(border)
        NumberOfBagsTextField.layer.masksToBounds = true
        NumberOfBagsTextField.delegate = self
        NumberOfBagsTextField.returnKeyType = UIReturnKeyType.next
        
        let toolBar:UIToolbar = UIToolbar.init(frame: CGRect(x:0,y:0,width:self.view.frame.size.width,height:44))
        let flexibleSpace:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done, target:self, action:#selector(dismissKeyboard))
        toolBar.barStyle = UIBarStyle.default
        toolBar.setItems([flexibleSpace,doneButton], animated: false)
        toolBar.backgroundColor = UIColor.lightGray
        NumberOfBagsTextField.inputAccessoryView = toolBar
        
        startY += NumberOfBagsTextField.frame.size.height + screenHeight/33.35
        self.view.addSubview(NumberOfBagsTextField)
        self.view.addSubview(LoadButtons())
    }
    
    func LoadButtons() -> UIView {
        
        let space = screenHeight/33.35
        let startX=screenWidth/13.39
        var startY=space
        
        let buttonsContainerView = UIView(frame: CGRect(x:0, y:screenHeight-(((screenHeight/13.34)*2)+space*3), width:screenWidth, height:(((screenHeight/13.34)*2)+space*3)))
        
        let SaveButton = UIButton(frame:CGRect(x:startX,y:startY,width:screenWidth-(startX*2),height:screenHeight/13.34))
        SaveButton.setTitle("save".localized.uppercased(), for:UIControlState.normal)
        SaveButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        SaveButton.backgroundColor = PrimaryGrayColor()
        SaveButton.layer.borderColor = PrimaryBoarder().cgColor
        SaveButton.layer.borderWidth = 1
        SaveButton.layer.cornerRadius=10
        SaveButton.clipsToBounds=true
        SaveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        buttonsContainerView.addSubview(SaveButton)
        
        startY += SaveButton.frame.height+space
        
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
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        datePickerTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func cancelPressed() {
        
        UserDefaults.standard.removeObject(forKey: "bingo")
        
        ScanManager.LocalStorage.removeFlightInformation()
        ScanManager.LocalStorage.RemoveTrackingLocation()
        ScanManager.LocalStorage.RemoveTrackingPointRaw()
        ScanManager.LocalStorage.RemoveTrackingPointValidityUntil()
        
        AppDelegate.vc.MainViewControllerPointer.RemoveFlightInformationView()
        AppDelegate.vc.MainViewControllerPointer.RemoveFligthAirPlaneInformationView()
        
        AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated: true)
        AppDelegate.vc.ConnectivityView.bingoInformationView = nil
        AppDelegate.BINGO_INFO=false
    }
    
    func saveButtonClicked(sender: UIButton!) {
        if AppDelegate.getDelegate().getUnknownBags(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()) == "S" {
            if (NumberOfBagsTextField.text!.isEmpty || Int(NumberOfBagsTextField.text!)! < 2 || Int(NumberOfBagsTextField.text!)! > 999 || FlightTextField.text!.isEmpty || datePickerTextField.text!.isEmpty || (FlightTextField.text?.characters.count)!<4){
                if datePickerTextField.text!.isEmpty {
                    ShakeTextField(cell: datePickerTextField)
                }
                if (FlightTextField.text!.isEmpty || (FlightTextField.text?.characters.count)!<4){
                    ShakeTextField(cell: FlightTextField)
                }
                if NumberOfBagsTextField.text!.isEmpty || Int(NumberOfBagsTextField.text!)! < 2 || Int(NumberOfBagsTextField.text!)! > 999{
                    ShakeTextField(cell: NumberOfBagsTextField)
                }
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM yyyy"
                let Date = dateFormatter.date(from: datePickerTextField.text!)
                var type = ""
                if (arrDepSeg.selectedSegmentIndex == 0){
                    type = "A"
                } else if (arrDepSeg.selectedSegmentIndex == 1){
                    type = "D"
                }
                AppDelegate.getDelegate().SaveFlightDataInformation(flight_num:FlightTextField.text!, flight_date: Date!, flight_type: type)
                AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated:false)
                AppDelegate.BINGO_INFO=false
                
                let tempQueue :NSMutableDictionary = NSMutableDictionary()
                tempQueue.setValue(nil, forKey: "bagsArray")
                tempQueue.setValue((Int(NumberOfBagsTextField.text!)), forKey:"numberOfBags")
                tempQueue.setValue(ScanManager.LocalStorage.getFlightInformation(), forKey:"flightInfo")
                UserDefaults.standard.set(tempQueue, forKey: "bingo")
                
                AppDelegate.getDelegate().ScanManagerInstance.NavigateToBingo(numberOfBags: (Int(NumberOfBagsTextField.text!))!)
                AppDelegate.vc.ConnectivityView.bingoInformationView = nil
            }
        } else if AppDelegate.getDelegate().getUnknownBags(scannedBarcode: ScanManager.LocalStorage.GetTrackingLocation()) == "I"{
            if NumberOfBagsTextField.text!.isEmpty || Int(NumberOfBagsTextField.text!)! < 2 || Int(NumberOfBagsTextField.text!)! > 999{
                ShakeTextField(cell: NumberOfBagsTextField)
            } else {
                AppDelegate.vc.ConnectivityView.navigationController?.popViewController(animated:false)
                let tempQueue :NSMutableDictionary = NSMutableDictionary()
                tempQueue.setValue(nil, forKey: "bagsArray")
                tempQueue.setValue((Int(NumberOfBagsTextField.text!)), forKey:"numberOfBags")
                tempQueue.setValue(ScanManager.LocalStorage.getFlightInformation(), forKey:"flightInfo")
                UserDefaults.standard.set(tempQueue, forKey: "bingo")
                AppDelegate.BINGO_INFO=false
                
                AppDelegate.getDelegate().ScanManagerInstance.NavigateToBingo(numberOfBags: (Int(NumberOfBagsTextField.text!))!)
                AppDelegate.vc.ConnectivityView.bingoInformationView = nil
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification){
        self.view.frame.origin.y = -20
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(FlightTextField != nil && textField==FlightTextField) {
            let maxLength = 7
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let alphanumerics = NSCharacterSet.alphanumerics.inverted
            
            return (newString.length <= maxLength && newString.rangeOfCharacter(from: alphanumerics).location == NSNotFound)
        }
        if(NumberOfBagsTextField != nil && textField==NumberOfBagsTextField) {
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let alphanumerics = NSCharacterSet.alphanumerics.inverted
            
            return (newString.length <= maxLength && newString.rangeOfCharacter(from: alphanumerics).location == NSNotFound)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if(FlightTextField != nil && FlightTextField==textField){
            datePickerTextField.becomeFirstResponder()
        }
        else if(datePickerTextField != nil && datePickerTextField==textField){
            NumberOfBagsTextField.becomeFirstResponder()
        }
        return true
    }
}
