//
//  InformationView.swift
//  NetSCAN
//
//  Created by Developer on 9/20/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit

class InformationView: UIView, UITextFieldDelegate,UIScrollViewDelegate {
    @IBOutlet weak var bagImage: UIImageView!
    @IBOutlet weak var bagNum: UILabel!
    
    @IBOutlet weak var InfoLabel: UILabel!
    @IBOutlet weak var FlightTextField: UITextField!
    @IBOutlet weak var datePickerTextField: CustomUITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var arrDepSeg: UISegmentedControl!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    static var UnknownBag = ""
    static var BagNumber=""
    
    func addBehavior() {
        
        AppDelegate.priorityForBags = false
        
        let screen=UIScreen.main.bounds
        
        self.ScrollView.frame=CGRect(x: 0,y:0,width: screen.width,height: screen.height)
        ScrollView.isScrollEnabled=true
        
        
        if bagImage.isHidden == false {
            view.frame = CGRect(x:15,y:screen.height/2-240,width:screen.width-30,height:480)
        } else {
            view.frame = CGRect(x:15,y:screen.height/2-157,width:screen.width-30,height:315)
        }
        
        //set the frames
        bagImage.frame = CGRect(x:view.frame.width/2-60,y:10,width:120,height:120)
        bagNum.frame = CGRect(x:20, y:bagImage.frame.origin.y+bagImage.frame.size.height+10, width:view.frame.width-40, height:25)
        
        if bagImage.isHidden == false {
            InfoLabel.frame = CGRect(x:20,y:bagNum.frame.origin.y+bagNum.frame.size.height+10,width:view.frame.width-40,height:25)
        } else {
            InfoLabel.frame = CGRect(x:20,y:10,width:view.frame.width-40,height:25)
        }
        
        arrDepSeg.frame = CGRect(x:20,y:InfoLabel.frame.origin.y+InfoLabel.frame.size.height+10,width:view.frame.width-40,height:40)
        FlightTextField.frame = CGRect(x:20,y:arrDepSeg.frame.origin.y+arrDepSeg.frame.size.height+15,width:view.frame.width-40,height:60)
        datePickerTextField.frame = CGRect(x:20, y:FlightTextField.frame.origin.y+FlightTextField.frame.size.height+15, width:view.frame.width-40,height:60)
        saveButton.frame = CGRect(x:(view.frame.width)/2,y:datePickerTextField.frame.origin.y+datePickerTextField.frame.size.height+15,width:(view.frame.width-40)/2,height:50)
        
        cancelButton.frame = CGRect(x:((view.frame.width/2)-((view.frame.width-40)/2)),y:datePickerTextField.frame.origin.y+datePickerTextField.frame.size.height+15,width:(view.frame.width-40)/2,height:50)
        
        //View
        view.backgroundColor = AppHeaderBackgroundColor()
        view.layer.borderWidth = 1
        view.layer.borderColor = PrimaryBoarder().cgColor
        
        
        //bagImage
        bagImage.backgroundColor = PrimaryBoarder()
        bagImage.image = bagImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        bagImage.tintColor = primaryColor()
        bagImage.layer.cornerRadius = 5
        bagImage.clipsToBounds = true
        
        //bagNum
        bagNum.adjustsFontSizeToFitWidth = true
        bagNum.textColor=secondaryColor()
        bagNum.textAlignment = NSTextAlignment.center
        
        //additionalLabel
        InfoLabel.backgroundColor=AppHeaderBackgroundColor()
        InfoLabel.text="additional_information".localized
        InfoLabel.adjustsFontSizeToFitWidth = true
        InfoLabel.textColor=OrangeColorInverted()
        InfoLabel.textAlignment = NSTextAlignment.center
        
        //arrDepSeg
        arrDepSeg.tintColor = PrimaryBoarder()
        arrDepSeg.selectedSegmentIndex = 1
        
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
        arrDepSeg.setImage(FinalImage1, forSegmentAt: 0)
        
        
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
        arrDepSeg.setImage(FinalImage2, forSegmentAt: 1)
        
        //flightNumText
        let textColor:UIColor = PrimaryBoarder()
        FlightTextField.attributedPlaceholder = NSAttributedString(string:"flightnumber".localized,
                                                                   attributes:[NSForegroundColorAttributeName: textColor])
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y: FlightTextField.frame.size.height - width, width:  FlightTextField.frame.size.width, height: FlightTextField.frame.size.height)
        border.borderWidth = width
        FlightTextField.textColor = secondaryColor()
        FlightTextField.adjustsFontSizeToFitWidth=true
        FlightTextField.font = UIFont.systemFont(ofSize:25)
        FlightTextField.backgroundColor=AppHeaderBackgroundColor()
        FlightTextField.layer.addSublayer(border)
        FlightTextField.layer.masksToBounds = true
        FlightTextField.delegate = self
        FlightTextField.returnKeyType = UIReturnKeyType.next
        
        //datePicker
        datePickerTextField.attributedPlaceholder = NSAttributedString(string:"date".localized,
                                                                       attributes:[NSForegroundColorAttributeName: textColor])
        let border2 = CALayer()
        let width2 = CGFloat(1.0)
        border2.borderColor = PrimaryBoarder().cgColor
        border2.frame = CGRect(x: 0, y: datePickerTextField.frame.size.height - width2, width:  datePickerTextField.frame.size.width, height: datePickerTextField.frame.size.height)
        border2.borderWidth = width2
        
        datePickerTextField.textColor = secondaryColor()
        datePickerTextField.adjustsFontSizeToFitWidth=true
        datePickerTextField.font = UIFont.systemFont(ofSize:25)
        datePickerTextField.backgroundColor=AppHeaderBackgroundColor()
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
        
        let toolBar:UIToolbar = UIToolbar.init(frame: CGRect(x:0,y:0,width:self.view.frame.size.width,height:44))
        let flexibleSpace:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done, target:self, action:#selector(dismissKeyboard))
        toolBar.barStyle = UIBarStyle.default
        toolBar.setItems([flexibleSpace,doneButton], animated: false)
        toolBar.backgroundColor = UIColor.lightGray
        
        datePickerTextField.inputView = datePickerView
        datePickerTextField.inputAccessoryView = toolBar
        
        //saveButton
        saveButton.backgroundColor=SecondaryGrayColor()
        saveButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        saveButton.layer.cornerRadius = 5
        saveButton.clipsToBounds = true
        saveButton.setTitle("save".localized.uppercased(), for: UIControlState.normal)
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        
        //cancel button
        cancelButton.backgroundColor=UIColor.clear
        cancelButton.setTitleColor(secondaryColor(), for: UIControlState.normal)
        cancelButton.layer.cornerRadius = 5
        cancelButton.clipsToBounds = true
        cancelButton.setTitle("cancel".localized.uppercased(), for: UIControlState.normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonCliced), for: .touchUpInside)
        
        //tapGesture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        FlightTextField.becomeFirstResponder()
        
    }
    
    // Our custom view from the XIB file
    var view: UIView!
    
    func xibSetup(bagView: Bool, bagNumber: String) {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        if bagView == false {
            bagImage.isHidden = true
            bagNum.isHidden = true
        } else {
            bagImage.isHidden = false
            bagNum.isHidden = false
            bagNum.text = bagNumber
        }
        
        addBehavior()
    }
    
    func loadViewFromNib() -> UIView {
        
        //let bundle = NSBundle(forClass: self.dynamicType)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "InformationView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    init(frame: CGRect, bagView: Bool, bagNumber: String, Unknownbag:String) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup(bagView: bagView, bagNumber: bagNumber)
        InformationView.UnknownBag=Unknownbag
        InformationView.BagNumber=bagNumber
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        //xibSetup()
    }
    
    func isValidInput(input:String) -> Bool{
        
        var isDigit = false
        var regexSpec = "^[0-9A-Z]$"
        
        if (AppDelegate.getDelegate().matchesForRegexCaseSensitive(containerSpec:"^[0-9]{1}$", text:"\(input.characters.first!)") != []){
            isDigit = true
        }
        
        if (input.characters.count == 3){
            regexSpec = "^[A-Z0-9]{2}[0-9]{1}$"
        }
            
        else if (input.characters.count == 4 && !isDigit){
            regexSpec = "^[A-Z]{1}[A-Z0-9]{3}$"
        }else if (input.characters.count == 4 && isDigit){
            regexSpec = "^[0-9]{1}[A-Z]{1}[A-Z0-9]{2}$"
        }
            
        else if (input.characters.count == 5 && !isDigit){
            regexSpec = "^[A-Z]{1}[A-Z0-9]{2}[0-9]{1}[A-Z0-9]{1}$"
        }else if (input.characters.count == 5 && isDigit){
            regexSpec = "^[0-9]{1}[A-Z]{1}[A-Z0-9]{1}[0-9]{1}[A-Z0-9]{1}$"
        }
            
        else if (input.characters.count == 6 && !isDigit){
            regexSpec = "^[A-Z]{1}[A-Z0-9]{2}[0-9]{2}[A-Z0-9]{1}$"
        }else if (input.characters.count == 6 && isDigit){
            regexSpec = "^[0-9]{1}[A-Z]{1}[A-Z0-9]{1}[0-9]{2}[A-Z0-9]{1}$"
        }
            
        else if (input.characters.count == 7 && !isDigit){
            regexSpec = "^[A-Z]{1}[A-Z0-9]{2}[0-9]{3}[A-Z0-9]{1}$"
        }else if (input.characters.count == 7 && isDigit){
            regexSpec = "^[0-9]{1}[A-Z]{1}[0-9]{4}[A-Z]{1}$"
        }
        
        if (input.characters.count == 8){
            regexSpec = "^[A-Z]{3}[0-9]{4}[A-Z]{1}$"
        }
        
        if (AppDelegate.getDelegate().matchesForRegexCaseSensitive(containerSpec: regexSpec, text: input) != []){
            return true
        }
        return false
    }
    
    func saveButtonClicked(sender: UIButton!) {
        
        if (FlightTextField.text!.isEmpty || datePickerTextField.text!.isEmpty || !isValidInput(input: FlightTextField.text!))
        {
            if datePickerTextField.text!.isEmpty {
                ShakeTextField(cell: datePickerTextField)
            }
            if (FlightTextField.text!.isEmpty || !isValidInput(input: FlightTextField.text!)){
                ShakeTextField(cell: FlightTextField)
            }
            AppDelegate.priorityForBags = false
        }
        else
        {
            AppDelegate.priorityForBags = true
            // should save the data into the local storage
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let Date = dateFormatter.date(from: datePickerTextField.text!)
            var type = ""
            if (arrDepSeg.selectedSegmentIndex == 0)
            {
                type = "A"
            }
            else if (arrDepSeg.selectedSegmentIndex == 1)
            {
                type = "D"
            }
            
            AppDelegate.getDelegate().SaveFlightDataInformation(flight_num:FlightTextField.text!, flight_date: Date!, flight_type: type)
            if(InformationView.UnknownBag == "S")
            {
                AppDelegate.getDelegate().RemoveFlightInformationView()
            }
//            if(InformationView.UnknownBag == "U")
//            {
//                AppDelegate.getDelegate().OnFligthViewOfUnknownBagU(ReadString: InformationView.BagNumber)
//                AppDelegate.getDelegate().doClose()
//            }
        }
    }
    
    func cancelButtonCliced(){
        if(InformationView.UnknownBag == "S"){
            UserDefaultsManager().RemoveTrackingLocation()
            UserDefaultsManager().RemoveTrackingPointRaw()
            UserDefaultsManager().RemoveTrackingPointValidityUntil()
            UserDefaultsManager().RemoveContainerID()
            UserDefaultsManager().removeFlightInformation()
            AppDelegate.getDelegate().UpdateLocationOnAppHeader(seconds:0, trackingLocation:"")
            AppDelegate.getDelegate().RemoveContainerView()
            AppDelegate.getDelegate().RemoveFligthAirPlaneInformationView()
            AppDelegate.priorityForBags = false
        } else {
            AppDelegate.priorityForBags = true
            AppDelegate.ScanningBagTag=""
        }
        AppDelegate.getDelegate().doClose()
        AppDelegate.getDelegate().CheckForViews()
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        datePickerTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        let screen=UIScreen.main.bounds

        var keyboardCGRect:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardCGRect = self.view.convert(keyboardCGRect, from: nil)
        
        if bagImage.isHidden == false {
            let originalViewHeight = view.frame.height
            view.frame = CGRect(x:15,y:15,width:screen.width-30,height:screen.height-keyboardHeight-30)
            
            self.ScrollView.frame=CGRect(x: 0,y:0,width: screen.width,height: view.frame.height)
            self.ScrollView.contentSize = CGSize(width:screen.width,height:view.frame.height)
            
            var contentInset:UIEdgeInsets = self.ScrollView.contentInset
            contentInset.bottom = originalViewHeight - view.frame.height
            if(contentInset.bottom != 0) {
                self.ScrollView.contentInset = contentInset
            }
            
        } else {
            if(view.frame.height < screen.height-keyboardHeight){
                
                let allSpaces = Int(screen.height) - Int(view.frame.height) - Int(keyboardHeight)
                let singleSpace = allSpaces/2
                
                view.frame = CGRect(x:15,y:Int(singleSpace),width:Int(screen.width-30),height:Int(view.frame.height))
            }
            else{
                view.frame = CGRect(x:15,y:15,width:screen.width-30,height:screen.height-keyboardHeight-30)
                self.ScrollView.frame=CGRect(x: 0,y:0,width: screen.width,height: view.frame.height)
                self.ScrollView.contentSize = CGSize(width:screen.width,height:view.frame.height)
                
                var contentInset:UIEdgeInsets = self.ScrollView.contentInset
                contentInset.bottom = keyboardCGRect.size.height
                self.ScrollView.contentInset = contentInset
            }
        }
    }

    func keyboardWillHide(sender: NSNotification) {
        //view.frame.origin.y += 50
        
        let screen=UIScreen.main.bounds
        
        self.ScrollView.frame=CGRect(x: 0,y:0,width: screen.width,height: screen.height)
        self.ScrollView.contentSize = CGSize(width:screen.width,height:screen.height)
        
        self.ScrollView.contentInset = UIEdgeInsets.zero
        
        if bagImage.isHidden == false {
            view.frame = CGRect(x:15,y:screen.height/2-240,width:screen.width-30,height:480)
        } else {
            view.frame = CGRect(x:15,y:screen.height/2-157,width:screen.width-30,height:315)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField==FlightTextField) {
            let maxLength = 8
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let alphanumerics = NSCharacterSet.alphanumerics.inverted
            
            return (newString.length <= maxLength && newString.rangeOfCharacter(from: alphanumerics).location == NSNotFound)
        }
        
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if(FlightTextField==textField){
            datePickerTextField.becomeFirstResponder()
        }
        
        return true
    }
    
}

class CustomUITextField: UITextField {
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    override func selectionRects(for range: UITextRange) -> [Any] {
        return []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action == #selector(cut(_:)) || action == #selector(select(_:)) || action == #selector(selectAll(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

extension UIImage{
    
    class func renderUIViewToImage(viewToBeRendered:UIView?) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions((viewToBeRendered?.bounds.size)!, false, 0.0)
        viewToBeRendered!.drawHierarchy(in: viewToBeRendered!.bounds, afterScreenUpdates: true)
        viewToBeRendered!.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
}
