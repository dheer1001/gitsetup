//
//  ScannedItemsDetailsViews.swift
//  NetSCAN
//
//  Created by User on 9/20/16.
//  Copyright © 2016 User. All rights reserved.
//

import Foundation
import CoreData

class ScannedItemsViews:UIView{

    var first:Bool=false
    var LoaderInstance=UIActivityIndicatorView()
    var CloudInstance=UIImageView()
    var ViewInstance=UIView()
    var ScannedItemsScrollView=UIScrollView()
    var DeletedView :UIView?
    
    func getContainerView(containerName:String, desription:String, size:String, countour:String, type:String) -> UIView{
        let ContainerView=UIView(frame: CGRect(x:0,y:(UIScreen.main.bounds.height/5.5)+85,width:UIScreen.main.bounds.width,height:(Constants.UIScreenMainHeight/4)-20))
        let InnerContainerView=UIView(frame: CGRect(x:ContainerView.frame.width/9,y:0,width:ContainerView.frame.width/2+50,height:ContainerView.frame.height))
        let ContainerNameLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/16,y:10,width:InnerContainerView.frame.width-(InnerContainerView.frame.width/12),height:(ContainerView.frame.size.height/11)+5))
        let DesriptionLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/16,y:ContainerNameLabel.frame.height+ContainerNameLabel.frame.origin.y+5,width:InnerContainerView.frame.width-(InnerContainerView.frame.width/6),height:(ContainerView.frame.size.height/11)+5))
        if(desription == ""){
            DesriptionLabel.frame=CGRect(x:InnerContainerView.frame.width/16,y:10,width:InnerContainerView.frame.width-(InnerContainerView.frame.width/12),height:(ContainerView.frame.size.height/11)+5)
        }
        let BaseSizeLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/16,y:DesriptionLabel.frame.height+DesriptionLabel.frame.origin.y+5,width:80,height:ContainerView.frame.size.height/11))
        let BaseSizeValueLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/16+BaseSizeLabel.frame.width,y:DesriptionLabel.frame.height+DesriptionLabel.frame.origin.y+5,width:InnerContainerView.frame.width-(InnerContainerView.frame.width/12)-(BaseSizeLabel.frame.width)-(BaseSizeLabel.frame.width/6),height:ContainerView.frame.size.height/11))
        let CountourLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/16,y:BaseSizeLabel.frame.height+BaseSizeLabel.frame.origin.y+10,width:80,height:ContainerView.frame.size.height/11))
        let CountourValueLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/16+CountourLabel.frame.width,y:BaseSizeLabel.frame.height+BaseSizeLabel.frame.origin.y+10,width:InnerContainerView.frame.width-(InnerContainerView.frame.width/12)-(CountourLabel.frame.width)-(CountourLabel.frame.width/6),height:ContainerView.frame.size.height/11))
        let TypeLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/16,y:CountourLabel.frame.height+CountourLabel.frame.origin.y+10,width:45,height:17))
        let TypeValueLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/16+TypeLabel.frame.width,y:CountourLabel.frame.height+CountourLabel.frame.origin.y+12,width:InnerContainerView.frame.width-(InnerContainerView.frame.width/14)-(TypeLabel.frame.width)-(TypeLabel.frame.width/6),height:ContainerView.frame.size.height/11))
        InnerContainerView.frame=CGRect(x:ContainerView.frame.width/9,y:0,width:ContainerView.frame.width/2+50,height:TypeLabel.frame.height+TypeLabel.frame.origin.y+10)
        let InnerContainerImageView=UIImageView(frame: CGRect(x:InnerContainerView.frame.width+InnerContainerView.frame.origin.x,y:InnerContainerView.frame.height/2-((UIScreen.main.bounds.width-(InnerContainerView.frame.width+InnerContainerView.frame.origin.x)-(InnerContainerView.frame.width/10))/2),width:UIScreen.main.bounds.width-(InnerContainerView.frame.width+InnerContainerView.frame.origin.x),height:UIScreen.main.bounds.width-(InnerContainerView.frame.width+InnerContainerView.frame.origin.x)-(InnerContainerView.frame.width/10)))
        InnerContainerView.backgroundColor=PrimaryBackroundViewColor()
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y:0, width:InnerContainerView.frame.width, height: InnerContainerView.frame.height)
        border.borderWidth = width
        InnerContainerView.layer.addSublayer(border)
        InnerContainerView.layer.masksToBounds = true
        ContainerView.addSubview(InnerContainerView)
        InnerContainerImageView.image=UIImage(named:"\(String(containerName.characters.first!).uppercased())")
        ContainerView.addSubview(InnerContainerImageView)
        ContainerNameLabel.text=containerName
        ContainerNameLabel.textColor=secondaryColor()
        ContainerNameLabel.adjustsFontSizeToFitWidth=true
        ContainerNameLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(ContainerNameLabel)
        DesriptionLabel.text=desription
        DesriptionLabel.textColor=secondaryColor()
        DesriptionLabel.adjustsFontSizeToFitWidth=true
        DesriptionLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(DesriptionLabel)
        BaseSizeLabel.text="size".localized
        BaseSizeLabel.adjustsFontSizeToFitWidth=true
        BaseSizeLabel.textColor=secondaryColor()
        BaseSizeLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(BaseSizeLabel)
        if(size == ""){
            BaseSizeValueLabel.text="notavailable".localized
        }else{
            BaseSizeValueLabel.text=size
        }
        BaseSizeValueLabel.textColor=SecondaryGrayColor()
        BaseSizeValueLabel.adjustsFontSizeToFitWidth=true
        BaseSizeValueLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(BaseSizeValueLabel)
        CountourLabel.text="contour".localized
        CountourLabel.adjustsFontSizeToFitWidth=true
        CountourLabel.textColor=secondaryColor()
        CountourLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(CountourLabel)
        if(countour == ""){
            CountourValueLabel.text="notavailable".localized
        }else{
            CountourValueLabel.text=size
        }
        CountourValueLabel.text=countour
        CountourValueLabel.adjustsFontSizeToFitWidth=true
        CountourValueLabel.textColor=SecondaryGrayColor()
        CountourLabel.adjustsFontSizeToFitWidth=true
        CountourValueLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(CountourValueLabel)
        TypeLabel.text="uld_type".localized
        TypeLabel.textColor=secondaryColor()
        TypeLabel.adjustsFontSizeToFitWidth=true
        TypeLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(TypeLabel)
        if(type == ""){
            TypeValueLabel.text="notavailable".localized
        }else{
            TypeValueLabel.text=type
        }
        TypeValueLabel.text=type
        TypeValueLabel.adjustsFontSizeToFitWidth=true
        TypeValueLabel.textColor=SecondaryGrayColor()
        TypeValueLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(TypeValueLabel)
        return ContainerView
    }

    func getContainerDetailView(ItemPressedObject:NSManagedObject) -> UIView{
        let ContainerDetailDeleteSimilarButton:UIButton = UIButton()
        let ContainerDetailView=UIView(frame: CGRect(x:20,y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/4),width:UIScreen.main.bounds.width-40,height:Constants.UIScreenMainHeight/1.7))
        let ContainerDetailContainer=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:-ContainerDetailView.frame.width/12,width:ContainerDetailView.frame.width/4,height:ContainerDetailView.frame.width/4))
        let ContainerDetailImageView=UIImageView(frame: CGRect(x:10,y:10,width:ContainerDetailContainer.frame.width-20,height:ContainerDetailContainer.frame.height-20))
        let ContainerDetailCloudImageView=UIImageView(frame: CGRect(x:ContainerDetailImageView.frame.width-(ContainerDetailImageView.frame.width/2.8),y:ContainerDetailImageView.frame.height-(ContainerDetailImageView.frame.height/2.8),width:ContainerDetailImageView.frame.width/3.5,height:ContainerDetailImageView.frame.height/3.5))
        let ContainerDetailTypeLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/2.5,y:ContainerDetailView.frame.width/10,width:100,height:20))
        let ContainerDetailLocationImageView=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:ContainerDetailContainer.frame.height,width:25,height:25))
        let ContainerDetailLocationLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/5,y:ContainerDetailContainer.frame.height,width:200,height:25))
        
        var yHight:CGFloat = 0.0;
        if ((ScanManager.LocalStorage.getFlightInformation().value(forKey:"flight_num") != nil) && (ScanManager.LocalStorage.getFlightInformation().value(forKey:"flight_num") as! String) != ""){
            
            let ContainerDetailFligthLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/5,y:ContainerDetailLocationImageView.frame.origin.y+(ContainerDetailView.frame.width/6),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/5)-20,height:35))
            ContainerDetailFligthLabel.text = UserDefaults.standard.value(forKey: "TemporaryFligthInfo") as? String
           
            
            ContainerDetailFligthLabel.layer.masksToBounds = true
            ContainerDetailFligthLabel.text=UserDefaults.standard.value(forKey: "TemporaryFligthInfo") as? String
            ContainerDetailFligthLabel.adjustsFontSizeToFitWidth=true
            ContainerDetailFligthLabel.numberOfLines=2
            ContainerDetailFligthLabel.textAlignment=NSTextAlignment.left
            ContainerDetailFligthLabel.textColor=secondaryColor()
            ContainerDetailFligthLabel.alpha=1
            
            let ContainerDetailFligthImageView=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:ContainerDetailLocationImageView.frame.origin.y+(ContainerDetailView.frame.width/6),width:25,height:25))
            ContainerDetailFligthImageView.image = UIImage(named:"airline")
            ContainerDetailFligthImageView.image=ContainerDetailFligthImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            ContainerDetailFligthImageView.tintColor=secondaryColor()
            
            ContainerDetailView.addSubview(ContainerDetailFligthLabel)
            ContainerDetailView.addSubview(ContainerDetailFligthImageView)
            
            yHight = (ContainerDetailView.frame.width/6)
        }
        
        let ContainerDetailNameImageView=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:yHight+ContainerDetailLocationImageView.frame.origin.y+(ContainerDetailView.frame.width/6),width:25,height:25))
        let ContainerDetailNameLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/5,y:yHight+ContainerDetailLocationImageView.frame.origin.y+(ContainerDetailView.frame.width/6),width:200,height:25))
        let ContainerDetailStatusLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/20,y:ContainerDetailNameLabel.frame.origin.y+(ContainerDetailNameLabel.frame.height+10),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/10),height:70))
        let ContainerDetailResetButton = UIButton(type: UIButtonType.system) as UIButton
        let ContainerDetailDeleteButton = UIButton(type: UIButtonType.system) as UIButton
        ContainerDetailResetButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailStatusLabel.frame.origin.y+(ContainerDetailStatusLabel.frame.height+20),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
        ContainerDetailDeleteButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailResetButton.frame.origin.y+(ContainerDetailResetButton.frame.height+20),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
        ContainerDetailView.frame=CGRect(x:20,y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/4),width:UIScreen.main.bounds.width-40,height:ContainerDetailDeleteButton.frame.height+ContainerDetailDeleteButton.frame.origin.y+20)
        ContainerDetailView.backgroundColor=BagDetailsBackgroundColor()
        ContainerDetailTypeLabel.text=AppDelegate.getDelegate().getTrackingID(scannedBarcode: (ItemPressedObject.value(forKey: "trackingPoint") as! String))
        ContainerDetailTypeLabel.adjustsFontSizeToFitWidth=true
        ContainerDetailTypeLabel.textColor=UIColor.green
        ContainerDetailView.addSubview(ContainerDetailTypeLabel)
        
        ContainerDetailLocationImageView.image=UIImage(named: "gps-fixed")
        ContainerDetailLocationImageView.image = ContainerDetailLocationImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailLocationImageView.tintColor = secondaryColor()
        ContainerDetailView.addSubview(ContainerDetailLocationImageView)
        
        ContainerDetailNameImageView.image=UIImage(named: "deliverycontainer")
        ContainerDetailNameImageView.image = ContainerDetailNameImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailNameImageView.tintColor = secondaryColor()
        ContainerDetailView.addSubview(ContainerDetailNameImageView)
        ContainerDetailLocationLabel.text=AppDelegate.getDelegate().GetTrackingLocation(TrackingPoint: (ItemPressedObject.value(forKey: "trackingPoint") as! String))
        ContainerDetailLocationLabel.adjustsFontSizeToFitWidth=true
        ContainerDetailLocationLabel.textColor=secondaryColor()
        ContainerDetailView.addSubview(ContainerDetailLocationLabel)
        ContainerDetailNameLabel.text=(ItemPressedObject.value(forKey: "containerID") as! String)
        ContainerDetailNameLabel.adjustsFontSizeToFitWidth=true
        ContainerDetailNameLabel.textColor=secondaryColor()
        ContainerDetailView.addSubview(ContainerDetailNameLabel)
        ContainerDetailStatusLabel.text=ItemPressedObject.value(forKey: "errorMsg") as? String
        ContainerDetailStatusLabel.adjustsFontSizeToFitWidth=true
        ContainerDetailStatusLabel.textColor=UIColor.red
        ContainerDetailStatusLabel.numberOfLines=10
        ContainerDetailView.addSubview(ContainerDetailStatusLabel)
        ContainerDetailResetButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        ContainerDetailResetButton.tintColor=UIColor.white
        ContainerDetailResetButton.layer.cornerRadius = 5;
        ContainerDetailResetButton.layer.masksToBounds = true;
        
        if (ItemPressedObject.value(forKey: "errorMsg") as? String == "" || ItemPressedObject.value(forKey: "errorMsg") as? String == "Network_Connection_Issue".localized){
            ContainerDetailResetButton.setTitle("try_again".localized, for: UIControlState.normal)
        } else {
            ContainerDetailResetButton.setTitle("reset_status".localized, for: UIControlState.normal)
        }
        
        ContainerDetailResetButton.addTarget(self, action: #selector(itemResetButtonClicked), for: .touchUpInside)
        ContainerDetailResetButton.accessibilityLabel="\((ItemPressedObject.value(forKey: "trackingPoint") as? String)!),\((ItemPressedObject.value(forKey: "bagTag")! as? String)!),\((ItemPressedObject.value(forKey: "containerID") as? String)!)"
        
        if (ItemPressedObject.value(forKey: "errorMsg") as? String != "" && ItemPressedObject.value(forKey: "errorMsg") as? String != "Network_Connection_Issue".localized){
            ContainerDetailResetButton.accessibilityValue = ItemPressedObject.value(forKey: "errorMsg") as? String
        }
        ContainerDetailView.addSubview(ContainerDetailResetButton)
        ContainerDetailDeleteButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        ContainerDetailDeleteButton.tintColor=UIColor.white
        ContainerDetailDeleteButton.layer.cornerRadius = 5;
        ContainerDetailDeleteButton.layer.masksToBounds = true;
        ContainerDetailDeleteButton.setTitle("delete_Bag".localized, for: UIControlState.normal)
        ContainerDetailDeleteButton.addTarget(self, action: #selector(itemDeleteButtonClicked), for: .touchUpInside)
        ContainerDetailDeleteButton.accessibilityLabel="\((ItemPressedObject.value(forKey: "trackingPoint") as? String)!),\((ItemPressedObject.value(forKey: "bagTag")! as? String)!),\((ItemPressedObject.value(forKey: "containerID") as? String)!)"
        ContainerDetailView.addSubview(ContainerDetailDeleteButton)
        
        if((ItemPressedObject.value(forKey: "synced") as! Bool)==true){
            
            ContainerDetailResetButton.removeFromSuperview()
            ContainerDetailDeleteButton.removeFromSuperview()
            ContainerDetailStatusLabel.removeFromSuperview()
            ContainerDetailView.frame=CGRect(x:20,y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/4),width:UIScreen.main.bounds.width-40,height:ContainerDetailNameImageView.frame.height+ContainerDetailNameImageView.frame.origin.y+30)
            ContainerDetailStatusLabel.removeFromSuperview()
        }
        
        
        if (ItemPressedObject.value(forKey: "errorMsg") as? String != "" && ItemPressedObject.value(forKey: "errorMsg") as? String != "Network_Connection_Issue".localized){
            ContainerDetailDeleteSimilarButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
            ContainerDetailDeleteSimilarButton.tintColor=UIColor.white
            ContainerDetailDeleteSimilarButton.layer.cornerRadius = 5;
            ContainerDetailDeleteSimilarButton.layer.masksToBounds = true;
            ContainerDetailDeleteSimilarButton.setTitle("delete_similar".localized, for: UIControlState.normal)
            ContainerDetailDeleteSimilarButton.titleLabel?.font=UIFont.systemFont(ofSize: 15.0)
            ContainerDetailDeleteSimilarButton.addTarget(self, action: #selector(DeleteSimelerButtonClicked(sender:)), for: .touchUpInside)
            let errorMsg:String = (ItemPressedObject.value(forKey: "errorMsg") as? String)!
            ContainerDetailDeleteSimilarButton.accessibilityLabel=errorMsg
            ContainerDetailDeleteSimilarButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailDeleteButton.frame.origin.y+(ContainerDetailDeleteButton.frame.height+20),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
            if((ItemPressedObject.value(forKey: "synced") as! Bool)==false && (ItemPressedObject.value(forKey: "locked") as! Bool)==true){
                ContainerDetailView.addSubview(ContainerDetailDeleteSimilarButton)
                ContainerDetailView.frame=CGRect.init(x: ContainerDetailView.frame.origin.x, y: ContainerDetailView.frame.origin.y-((ContainerDetailDeleteSimilarButton.frame.size.height+20)/2), width: ContainerDetailView.frame.size.width, height: ContainerDetailView.frame.size.height+ContainerDetailDeleteSimilarButton.frame.size.height+20)
            }
        }
        
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y:0, width:ContainerDetailView.frame.width, height: ContainerDetailView.frame.height)
        border.borderWidth = width
        ContainerDetailView.layer.addSublayer(border)
        ContainerDetailView.layer.masksToBounds = false
        ContainerDetailContainer.backgroundColor=SecondaryGrayColor()
        ContainerDetailContainer.layer.cornerRadius = 5;
        ContainerDetailContainer.layer.masksToBounds = true;
        ContainerDetailView.addSubview(ContainerDetailContainer)
        ContainerDetailImageView.image=UIImage(named: "deliverycontainer")
        ContainerDetailImageView.image=ContainerDetailImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailImageView.tintColor = primaryColor()
        ContainerDetailContainer.addSubview(ContainerDetailImageView)
        if((ItemPressedObject.value(forKey: "synced") as! Bool)==false){
            if (ItemPressedObject.value(forKey: "errorMsg") as? String != "" && ItemPressedObject.value(forKey: "errorMsg") as? String != "Network_Connection_Issue".localized){
                ContainerDetailCloudImageView.image=UIImage(named: "Cancel.png")
                ContainerDetailCloudImageView.image=ContainerDetailCloudImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                ContainerDetailCloudImageView.tintColor=UIColor.red
            }
            else{
                ContainerDetailCloudImageView.image=UIImage(named: "cloud_off_white")
                ContainerDetailCloudImageView.image = ContainerDetailCloudImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                ContainerDetailCloudImageView.tintColor = secondaryColor()
            }
        }else{
            ContainerDetailCloudImageView.image=UIImage(named: "cloud_sync")
            ContainerDetailCloudImageView.image = ContainerDetailCloudImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            ContainerDetailCloudImageView.tintColor = secondaryColor()
        }
        ContainerDetailImageView.addSubview(ContainerDetailCloudImageView)
        
        ContainerDetailView.tag = 0901
        return ContainerDetailView
    }
    
    func getBagDetailView(ItemPressedObject:NSManagedObject) -> UIView{
        var FailToGetData=false
        let ContainerDetailDeleteSimilarButton:UIButton = UIButton()
        let ContainerDetailView=UIView(frame: CGRect(x:20,y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/4),width:UIScreen.main.bounds.width-40,height:Constants.UIScreenMainHeight/2))
        let ContainerDetailContainer=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:-ContainerDetailView.frame.width/12,width:ContainerDetailView.frame.width/4,height:ContainerDetailView.frame.width/4))
        let ContainerDetailImageView=UIImageView(frame: CGRect(x:10,y:10,width:ContainerDetailContainer.frame.width-20,height:ContainerDetailContainer.frame.height-20))
        let ContainerDetailCloudImageView=UIImageView(frame: CGRect(x:ContainerDetailImageView.frame.width-(ContainerDetailImageView.frame.width/2.8),y:ContainerDetailImageView.frame.height-(ContainerDetailImageView.frame.height/2.8),width:ContainerDetailImageView.frame.width/3.5,height:ContainerDetailImageView.frame.height/3.5))
        let ContainerDetailBagIdLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/2.5,y:ContainerDetailView.frame.height/18,width:ContainerDetailView.frame.width/1.7,height:15))
        let ContainerDetailTypeLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/2.5,y:ContainerDetailView.frame.width/10,width:100,height:20))
        let ContainerDetailLocationImageView=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:ContainerDetailContainer.frame.height,width:25,height:25))
        let ContainerDetailLocationLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/5,y:ContainerDetailContainer.frame.height,width:ContainerDetailView.frame.width/1.7,height:25))
        let ContainerDetailNameImageView=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:ContainerDetailLocationImageView.frame.origin.y+(ContainerDetailView.frame.width/6),width:25,height:25))
        let ContainerDetailNameLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/5,y:ContainerDetailLocationImageView.frame.origin.y+(ContainerDetailView.frame.width/6),width:200,height:25))
        let ContainerDetailStatusLabel=UILabel(frame:CGRect(x:0,y:0,width:0,height:0))
        let TrackingPostInfoContainer=UIView(frame:CGRect(x:0,y:0,width:0,height:0))
        let ContainerDetailResetButton = UIButton(type: UIButtonType.system) as UIButton
        let ContainerDetailDeleteButton = UIButton(type: UIButtonType.system) as UIButton
        let PassengerNameLabel=UILabel(frame:CGRect(x:0,y:0,width:0,height:0))
        let PNRLabel=UILabel(frame:CGRect(x:0,y:0,width:0,height:0))
        let PlaneIconeImage=UIImageView(frame:CGRect(x:0,y:0,width:0,height:0))
        let OriginAirportLabel=UILabel(frame:CGRect(x:0,y:0,width:0,height:0))
        let DestinationAirportLabel=UILabel(frame:CGRect(x:0,y:0,width:0,height:0))
        let OutboundFlightDateLabel=UILabel(frame:CGRect(x:0,y:0,width:0,height:0))
        _=UILabel(frame:CGRect(x:0,y:0,width:0,height:0))
        let InboundFlightDate=UILabel(frame:CGRect(x:0,y:0,width:0,height:0))
        let AirportCodeLabel=UILabel(frame:CGRect(x:0,y:0,width:0,height:0))
        if(!(ItemPressedObject.value(forKey: "errorMsg") as! String).isEmpty ){
            
            ContainerDetailStatusLabel.frame=CGRect(x:ContainerDetailView.frame.width/20,y:ContainerDetailNameImageView.frame.origin.y+(ContainerDetailNameImageView.frame.height+10),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/10),height:70)
            ContainerDetailResetButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailStatusLabel.frame.origin.y+(ContainerDetailStatusLabel.frame.height+20),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
            ContainerDetailDeleteButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailResetButton.frame.origin.y+(ContainerDetailResetButton.frame.height+20),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
            ContainerDetailView.frame=CGRect(x:20,y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/4),width:UIScreen.main.bounds.width-40,height:ContainerDetailDeleteButton.frame.height+ContainerDetailDeleteButton.frame.origin.y+20)
        }else{
            if((ItemPressedObject.value(forKey: "errorMsg") as! String).isEmpty && ((ItemPressedObject.value(forKey: "trackingResponse")) != nil)){
                let defaults = UserDefaults.standard
                let TrackingPostInfo=ItemPressedObject.value(forKey: "trackingResponse") as? String
                if let data = TrackingPostInfo?.data(using: String.Encoding.utf8) {
                    do {
                        let Dic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        if((Dic?.value(forKey: "success") as! Bool) == true){
                            var heightcount:CGFloat=10.0
                            var str = ""
                            TrackingPostInfoContainer.frame=CGRect(x:ContainerDetailView.frame.width/20,y:ContainerDetailNameImageView.frame.origin.y+(ContainerDetailNameImageView.frame.height+10),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/10),height:130)
                            ContainerDetailView.addSubview(TrackingPostInfoContainer)
                            ContainerDetailResetButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:TrackingPostInfoContainer.frame.origin.y+(TrackingPostInfoContainer.frame.height+10),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
                            ContainerDetailDeleteButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailResetButton.frame.origin.y+(ContainerDetailResetButton.frame.height+20),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
                            ContainerDetailView.frame=CGRect(x:20,y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/4),width:UIScreen.main.bounds.width-40,height:ContainerDetailDeleteButton.frame.height+ContainerDetailDeleteButton.frame.origin.y+20)
                            let border = CALayer()
                            let width = CGFloat(3.0)
                            border.borderColor = PrimaryBoarder().cgColor
                            border.frame = CGRect(x: 0, y:0, width:TrackingPostInfoContainer.frame.width, height: 1)
                            border.borderWidth = width
                            TrackingPostInfoContainer.layer.addSublayer(border)
                            TrackingPostInfoContainer.layer.masksToBounds = false
                            
                            PassengerNameLabel.frame=CGRect(x:0,y:10,width:TrackingPostInfoContainer.frame.width,height:15)
                            if let AssociatedDataDic = Dic?.value(forKey: "associated_data"){
                                
                                //associated_data is not nil
                                if(((AssociatedDataDic as! NSDictionary).value(forKey:"passenger_first_name")) != nil){
                                    //passenger_first_name is not nil
                                    str=((AssociatedDataDic as AnyObject).value(forKey: "passenger_first_name")) as! String
                                    PassengerNameLabel.text=str
                                    PassengerNameLabel.textColor=secondaryColor()
                                    PassengerNameLabel.textAlignment=NSTextAlignment.center
                                    TrackingPostInfoContainer.addSubview(PassengerNameLabel)
                                    heightcount=PassengerNameLabel.frame.height+PassengerNameLabel.frame.origin.y+5
                                }
                                
                                if(((AssociatedDataDic as! NSDictionary).value(forKey:"passenger_last_name")) != nil){
                                    if(str != ""){
                                        str.append(" ")
                                        heightcount=PassengerNameLabel.frame.height+PassengerNameLabel.frame.origin.y+5
                                    }
                                    str.append(((AssociatedDataDic as AnyObject).value(forKey: "passenger_last_name")) as! String)
                                    PassengerNameLabel.text=str
                                    PassengerNameLabel.textAlignment=NSTextAlignment.center
                                    PassengerNameLabel.textColor=secondaryColor()
                                    TrackingPostInfoContainer.addSubview(PassengerNameLabel)
                                }
                                
                                PNRLabel.frame=CGRect(x:0,y:heightcount,width:TrackingPostInfoContainer.frame.width,height:15)
                                if(((AssociatedDataDic as! NSDictionary).value(forKey:"pnr")) != nil){
                                    
                                    PNRLabel.text=((AssociatedDataDic as AnyObject).value(forKey: "pnr")) as? String
                                    PNRLabel.textAlignment=NSTextAlignment.center
                                    PNRLabel.textColor=secondaryColor()
                                    TrackingPostInfoContainer.addSubview(PNRLabel)
                                    heightcount=PNRLabel.frame.height+PNRLabel.frame.origin.y+5
                                    
                                }
                                
                                PlaneIconeImage.frame=CGRect(x:0,y:heightcount,width:30,height:30)
                                PlaneIconeImage.image=UIImage(named:"Plane")
                                PlaneIconeImage.image=PlaneIconeImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                                PlaneIconeImage.tintColor=secondaryColor()
                                TrackingPostInfoContainer.addSubview(PlaneIconeImage)
                                PlaneIconeImage.center.x=TrackingPostInfoContainer.center.x-15
                                str=""
                                
                                OriginAirportLabel.frame=CGRect(x:0,y:(PlaneIconeImage.frame.origin.y+(PlaneIconeImage.frame.size.height/2))-7.5,width:TrackingPostInfoContainer.frame.width/3,height:15)
                                if(((AssociatedDataDic as! NSDictionary).value(forKey:"origin_airport")) != nil){
                                    
                                    str.append(((AssociatedDataDic as AnyObject).value(forKey: "origin_airport")) as! String)
                                    OriginAirportLabel.text=str
                                    OriginAirportLabel.textAlignment=NSTextAlignment.right
                                    OriginAirportLabel.textColor=secondaryColor()
                                    TrackingPostInfoContainer.addSubview(OriginAirportLabel)
                                    
                                }
                                heightcount=OriginAirportLabel.frame.height+OriginAirportLabel.frame.origin.y
                                
                                if(((AssociatedDataDic as! NSDictionary).value(forKey:"destination_airport")) != nil){
                                    DestinationAirportLabel.frame=CGRect(x:TrackingPostInfoContainer.frame.width-(TrackingPostInfoContainer.frame.width/3),y:(PlaneIconeImage.frame.origin.y+(PlaneIconeImage.frame.size.height/2))-7.5,width:TrackingPostInfoContainer.frame.width/3,height:15)
                                    if(str != "")
                                    {
                                        heightcount=DestinationAirportLabel.frame.height+DestinationAirportLabel.frame.origin.y
                                    }
                                    DestinationAirportLabel.text=((AssociatedDataDic as AnyObject).value(forKey: "destination_airport")) as? String
                                    DestinationAirportLabel.textAlignment=NSTextAlignment.left
                                    DestinationAirportLabel.textColor=secondaryColor()
                                    TrackingPostInfoContainer.addSubview(DestinationAirportLabel)
                                    if((((AssociatedDataDic as! NSDictionary).value(forKey:"outbound_flight_date")) != nil) && (((AssociatedDataDic as! NSDictionary).value(forKey:"outbound_airline_code")) != nil) && (((AssociatedDataDic as! NSDictionary).value(forKey:"outbound_flight_num")) != nil) && (((AssociatedDataDic as! NSDictionary).value(forKey:"inbound_flight_date")) != nil) && (((AssociatedDataDic as! NSDictionary).value(forKey:"inbound_airline_code")) != nil) && (((AssociatedDataDic as! NSDictionary).value(forKey:"inbound_flight_num")) != nil) )
                                    {
                                        heightcount=heightcount+5
                                        if let airportCode = defaults.string(forKey: "selected_airport") {
                                            AirportCodeLabel.frame=CGRect(x:0,y:PlaneIconeImage.frame.origin.y+(PlaneIconeImage.frame.size.height)+5,width:TrackingPostInfoContainer.frame.width,height:15)
                                            heightcount=AirportCodeLabel.frame.height+AirportCodeLabel.frame.origin.y
                                            AirportCodeLabel.text=airportCode
                                            AirportCodeLabel.textAlignment=NSTextAlignment.center
                                            AirportCodeLabel.textColor=secondaryColor()
                                            TrackingPostInfoContainer.addSubview(AirportCodeLabel)
                                            heightcount=heightcount-3
                                        }
                                    }
                                }else{
                                    if let airportCode = defaults.string(forKey: "selected_airport") {
                                        DestinationAirportLabel.frame=CGRect(x:TrackingPostInfoContainer.frame.width-(TrackingPostInfoContainer.frame.width/3),y:(PlaneIconeImage.frame.origin.y+(PlaneIconeImage.frame.size.height/2))-7.5,width:TrackingPostInfoContainer.frame.width/3,height:15)
                                        if(str != ""){
                                            heightcount=DestinationAirportLabel.frame.height+DestinationAirportLabel.frame.origin.y
                                        }
                                        DestinationAirportLabel.text=airportCode
                                        DestinationAirportLabel.textAlignment=NSTextAlignment.left
                                        DestinationAirportLabel.textColor=secondaryColor()
                                        TrackingPostInfoContainer.addSubview(DestinationAirportLabel)
                                    }
                                }
                                str=""
                                OutboundFlightDateLabel.frame=CGRect(x:DestinationAirportLabel.frame.origin.x,y:PlaneIconeImage.frame.origin.y+(PlaneIconeImage.frame.size.height)+5,width:DestinationAirportLabel.frame.size.width,height:15)
                                if(((AssociatedDataDic as! NSDictionary).value(forKey:"outbound_flight_date")) != nil){
                                    OutboundFlightDateLabel.text=((AssociatedDataDic as AnyObject).value(forKey: "outbound_flight_date")) as? String
                                    OutboundFlightDateLabel.textColor=secondaryColor()
                                    OutboundFlightDateLabel.textAlignment=NSTextAlignment.left
                                    OutboundFlightDateLabel.numberOfLines=1
                                    TrackingPostInfoContainer.addSubview(OutboundFlightDateLabel)
                                }
                                if(((AssociatedDataDic as! NSDictionary).value(forKey:"outbound_airline_code")) != nil){
                                    str.append(((AssociatedDataDic as AnyObject).value(forKey: "outbound_airline_code")) as! String)
                                    let OutboundFlightNum = UILabel(frame:CGRect(x:OutboundFlightDateLabel.frame.origin.x, y:OutboundFlightDateLabel.frame.origin.y+OutboundFlightDateLabel.frame.size.height+10,width:DestinationAirportLabel.frame.size.width,height:15))
                                    if(((AssociatedDataDic as! NSDictionary).value(forKey:"outbound_flight_num")) != nil){
                                        str.append(((AssociatedDataDic as AnyObject).value(forKey: "outbound_flight_num")) as! String)
                                    }
                                    OutboundFlightNum.text=str
                                    OutboundFlightNum.textColor=secondaryColor()
                                    OutboundFlightNum.textAlignment=NSTextAlignment.left
                                    OutboundFlightNum.numberOfLines=1
                                    TrackingPostInfoContainer.addSubview(OutboundFlightNum)
                                }
                                
                                InboundFlightDate.frame=CGRect(x:OriginAirportLabel.frame.origin.x,y:PlaneIconeImage.frame.origin.y+(PlaneIconeImage.frame.size.height)+5,width:OriginAirportLabel.frame.size.width,height:15)
                                if(((AssociatedDataDic as! NSDictionary).value(forKey:"inbound_flight_date")) != nil){
                                    InboundFlightDate.text=((AssociatedDataDic as AnyObject).value(forKey: "inbound_flight_date")) as? String
                                    InboundFlightDate.textColor=secondaryColor()
                                    InboundFlightDate.textAlignment=NSTextAlignment.right
                                    InboundFlightDate.numberOfLines=1
                                    TrackingPostInfoContainer.addSubview(InboundFlightDate)
                                }
                                str=""
                                if(((AssociatedDataDic as! NSDictionary).value(forKey:"inbound_airline_code")) != nil){
                                    str.append(((AssociatedDataDic as AnyObject).value(forKey: "inbound_airline_code")) as! String)
                                    let InboundFlightNum = UILabel(frame:CGRect(x: InboundFlightDate.frame.origin.x, y:InboundFlightDate.frame.origin.y+InboundFlightDate.frame.size.height+10,width:OriginAirportLabel.frame.size.width,height:15))
                                    if(((AssociatedDataDic as! NSDictionary).value(forKey:"inbound_flight_num")) != nil){
                                        str.append(((AssociatedDataDic as AnyObject).value(forKey: "inbound_flight_num")) as! String)
                                    }
                                    InboundFlightNum.text=str
                                    InboundFlightNum.textColor=secondaryColor()
                                    InboundFlightNum.textAlignment=NSTextAlignment.right
                                    InboundFlightNum.numberOfLines=1
                                    TrackingPostInfoContainer.addSubview(InboundFlightNum)
                                }
                            }else{
                                FailToGetData=true
                            }
                            //not a successfull in getting TrackingPostInfo
                        }else{
                            FailToGetData=true
                        }
                    } catch {
                        //if theirs no data to show the two button go up
                        FailToGetData=true
                    }
                }
            }else{
                //if theirs no data to show the two button go up
                FailToGetData=true
            }
        }
        if(FailToGetData){
            ContainerDetailResetButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailNameImageView.frame.origin.y+(ContainerDetailNameImageView.frame.height+20),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
            ContainerDetailDeleteButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailResetButton.frame.origin.y+(ContainerDetailResetButton.frame.height+20),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
            ContainerDetailView.frame=CGRect(x:20,y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/4),width:UIScreen.main.bounds.width-40,height:ContainerDetailDeleteButton.frame.height+ContainerDetailDeleteButton.frame.origin.y+20)
        }

        ContainerDetailBagIdLabel.text=ItemPressedObject.value(forKey: "bagTag") as? String
        ContainerDetailBagIdLabel.textColor=secondaryColor()
        ContainerDetailBagIdLabel.adjustsFontSizeToFitWidth=true
        ContainerDetailView.addSubview(ContainerDetailBagIdLabel)
        ContainerDetailTypeLabel.text=AppDelegate.getDelegate().getTrackingID(scannedBarcode: (ItemPressedObject.value(forKey: "trackingPoint") as! String))
        ContainerDetailTypeLabel.textColor=UIColor.green
        ContainerDetailTypeLabel.adjustsFontSizeToFitWidth=true
        ContainerDetailView.addSubview(ContainerDetailTypeLabel)
        
        ContainerDetailLocationImageView.image=UIImage(named: "gps-fixed")
        ContainerDetailLocationImageView.image = ContainerDetailLocationImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailLocationImageView.tintColor = secondaryColor()
        ContainerDetailView.addSubview(ContainerDetailLocationImageView)
        ContainerDetailLocationLabel.text=AppDelegate.getDelegate().GetTrackingLocation(TrackingPoint:(ItemPressedObject.value(forKey: "trackingPoint") as? String)!)
        ContainerDetailLocationLabel.textColor=secondaryColor()
        ContainerDetailLocationLabel.adjustsFontSizeToFitWidth=true
        ContainerDetailView.addSubview(ContainerDetailLocationLabel)
        
        if(ItemPressedObject.value(forKey: "containerID") != nil && (ItemPressedObject.value(forKey: "containerID") as! String) != "" )
        {
        ContainerDetailNameImageView.image=UIImage(named: "deliverycontainer")
        ContainerDetailNameImageView.image = ContainerDetailNameImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailNameImageView.tintColor = secondaryColor()
        ContainerDetailView.addSubview(ContainerDetailNameImageView)
        print(ItemPressedObject)
        ContainerDetailNameLabel.text=(ItemPressedObject.value(forKey: "containerID") as! String)
        ContainerDetailNameLabel.adjustsFontSizeToFitWidth=true
        ContainerDetailNameLabel.textColor=secondaryColor()
        ContainerDetailView.addSubview(ContainerDetailNameLabel)
            
        }
        else{
            if((ItemPressedObject.value(forKey: "synced") as! Bool)==true)
            {
                TrackingPostInfoContainer.frame=CGRect(x:ContainerDetailView.frame.width/20,y:ContainerDetailLocationLabel.frame.origin.y+(ContainerDetailLocationLabel.frame.height+10),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/10),height:130)
                ContainerDetailView.addSubview(TrackingPostInfoContainer)
                ContainerDetailResetButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:TrackingPostInfoContainer.frame.origin.y+(TrackingPostInfoContainer.frame.height+10),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
                ContainerDetailDeleteButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailResetButton.frame.origin.y+(ContainerDetailResetButton.frame.height+20),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
                ContainerDetailView.frame=CGRect(x:20,y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/4),width:UIScreen.main.bounds.width-40,height:ContainerDetailDeleteButton.frame.height+ContainerDetailDeleteButton.frame.origin.y+20)
            }else{
            ContainerDetailStatusLabel.frame=CGRect(x:ContainerDetailView.frame.width/20,y:ContainerDetailLocationLabel.frame.origin.y+(ContainerDetailLocationLabel.frame.height+10),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/10),height:70)
            ContainerDetailResetButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailStatusLabel.frame.origin.y+(ContainerDetailStatusLabel.frame.height+20),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
            ContainerDetailDeleteButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailResetButton.frame.origin.y+(ContainerDetailResetButton.frame.height+20),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
            ContainerDetailView.frame=CGRect(x:20,y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/4),width:UIScreen.main.bounds.width-40,height:ContainerDetailDeleteButton.frame.height+ContainerDetailDeleteButton.frame.origin.y+20)
            }
        }
        
       

        ContainerDetailStatusLabel.text=ItemPressedObject.value(forKey: "errorMsg") as? String
        ContainerDetailStatusLabel.textColor=UIColor.red
        ContainerDetailStatusLabel.adjustsFontSizeToFitWidth=true
        ContainerDetailStatusLabel.numberOfLines=10
        ContainerDetailView.addSubview(ContainerDetailStatusLabel)
        
        ContainerDetailResetButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        ContainerDetailResetButton.tintColor=UIColor.white
        ContainerDetailResetButton.layer.cornerRadius = 5;
        ContainerDetailResetButton.layer.masksToBounds = true;
        
        if (ItemPressedObject.value(forKey: "errorMsg") as? String == "" || ItemPressedObject.value(forKey: "errorMsg") as? String == "Network_Connection_Issue".localized){
            ContainerDetailResetButton.setTitle("try_again".localized, for: UIControlState.normal)
        } else {
            ContainerDetailResetButton.setTitle("reset_status".localized, for: UIControlState.normal)
        }
        
        ContainerDetailResetButton.addTarget(self, action: #selector(itemResetButtonClicked), for: .touchUpInside)
        ContainerDetailResetButton.accessibilityLabel="\((ItemPressedObject.value(forKey: "trackingPoint") as? String)!),\((ItemPressedObject.value(forKey: "bagTag")! as? String)!),\((ItemPressedObject.value(forKey: "containerID") as? String)!)"
        
        if (ItemPressedObject.value(forKey: "errorMsg") as? String != "" && ItemPressedObject.value(forKey: "errorMsg") as? String != "Network_Connection_Issue".localized){
            ContainerDetailResetButton.accessibilityValue = ItemPressedObject.value(forKey: "errorMsg") as? String
        }
        
        ContainerDetailView.addSubview(ContainerDetailResetButton)
        
        ContainerDetailDeleteButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        ContainerDetailDeleteButton.tintColor=UIColor.white
        ContainerDetailDeleteButton.layer.cornerRadius = 5;
        ContainerDetailDeleteButton.layer.masksToBounds = true;
        ContainerDetailDeleteButton.setTitle("delete_Bag".localized, for: UIControlState.normal)
        ContainerDetailDeleteButton.addTarget(self, action: #selector(itemDeleteButtonClicked), for: .touchUpInside)
        ContainerDetailDeleteButton.accessibilityLabel="\((ItemPressedObject.value(forKey: "trackingPoint") as? String)!),\((ItemPressedObject.value(forKey: "bagTag")! as? String)!),\((ItemPressedObject.value(forKey: "containerID") as? String)!)"
        ContainerDetailView.addSubview(ContainerDetailDeleteButton)
        
        if((ItemPressedObject.value(forKey: "synced") as! Bool)==true)
        {
            ContainerDetailResetButton.removeFromSuperview()
            ContainerDetailDeleteButton.removeFromSuperview()
            ContainerDetailView.frame=CGRect(x:20,y:Constants.UIScreenMainHeight/2-(Constants.UIScreenMainHeight/4),width:UIScreen.main.bounds.width-40,height:TrackingPostInfoContainer.frame.height+TrackingPostInfoContainer.frame.origin.y)
            
        }
        
        
        if (ItemPressedObject.value(forKey: "errorMsg") as? String != "" && ItemPressedObject.value(forKey: "errorMsg") as? String != "Network_Connection_Issue".localized){
            ContainerDetailDeleteSimilarButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
            ContainerDetailDeleteSimilarButton.tintColor=UIColor.white
            ContainerDetailDeleteSimilarButton.layer.cornerRadius = 5;
            ContainerDetailDeleteSimilarButton.layer.masksToBounds = true;
            ContainerDetailDeleteSimilarButton.setTitle("delete_similar".localized, for: UIControlState.normal)
            ContainerDetailDeleteSimilarButton.titleLabel?.font=UIFont.systemFont(ofSize: 15.0)
            ContainerDetailDeleteSimilarButton.addTarget(self, action: #selector(DeleteSimelerButtonClicked(sender:)), for: .touchUpInside)
            let errorMsg:String = (ItemPressedObject.value(forKey: "errorMsg") as? String)!
            ContainerDetailDeleteSimilarButton.accessibilityLabel=errorMsg
            ContainerDetailDeleteSimilarButton.frame=CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailDeleteButton.frame.origin.y+(ContainerDetailDeleteButton.frame.height+20),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50)
            if((ItemPressedObject.value(forKey: "synced") as! Bool)==false && (ItemPressedObject.value(forKey: "locked") as! Bool)==true){
                ContainerDetailView.addSubview(ContainerDetailDeleteSimilarButton)
                ContainerDetailView.frame=CGRect.init(x: ContainerDetailView.frame.origin.x, y: ContainerDetailView.frame.origin.y-((ContainerDetailDeleteSimilarButton.frame.size.height+20)/2), width: ContainerDetailView.frame.size.width, height: ContainerDetailView.frame.size.height+ContainerDetailDeleteSimilarButton.frame.size.height+20)
            }
        }
        
        
        ContainerDetailView.backgroundColor=BagDetailsBackgroundColor()
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = PrimaryBoarder().cgColor
        border.frame = CGRect(x: 0, y:0, width:ContainerDetailView.frame.width, height: ContainerDetailView.frame.height)
        border.borderWidth = width
        ContainerDetailView.layer.addSublayer(border)
        ContainerDetailView.layer.masksToBounds = false
        
        ContainerDetailContainer.backgroundColor=SecondaryGrayColor()
        ContainerDetailContainer.layer.cornerRadius = 5;
        ContainerDetailContainer.layer.masksToBounds = true;
        ContainerDetailView.addSubview(ContainerDetailContainer)
        ContainerDetailImageView.image=UIImage(named: "Bag")
        ContainerDetailImageView.image = ContainerDetailImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailImageView.tintColor = primaryColor()
        ContainerDetailContainer.addSubview(ContainerDetailImageView)
        if((ItemPressedObject.value(forKey: "synced") as! Bool)==false){
            if (ItemPressedObject.value(forKey: "errorMsg") as? String != "" && ItemPressedObject.value(forKey: "errorMsg") as? String != "Network_Connection_Issue".localized){
                ContainerDetailCloudImageView.image=UIImage(named: "Cancel.png")
                ContainerDetailCloudImageView.image=ContainerDetailCloudImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                ContainerDetailCloudImageView.tintColor=UIColor.red
            }
            else{
                ContainerDetailCloudImageView.image=UIImage(named: "cloud_off_white")
                ContainerDetailCloudImageView.image = ContainerDetailCloudImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                ContainerDetailCloudImageView.tintColor = secondaryColor()
            }
        }else{
            ContainerDetailCloudImageView.image=UIImage(named: "cloud_sync")
            ContainerDetailCloudImageView.image = ContainerDetailCloudImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            ContainerDetailCloudImageView.tintColor = secondaryColor()
        }
        ContainerDetailImageView.addSubview(ContainerDetailCloudImageView)
        
        if (FailToGetData){
            if ((ScanManager.LocalStorage.getFlightInformation().value(forKey:"flight_num") != nil) && (ScanManager.LocalStorage.getFlightInformation().value(forKey:"flight_num") as! String) != ""){
                let defference = (ContainerDetailView.frame.size.height-((ContainerDetailLocationImageView.frame.origin.y+ContainerDetailLocationImageView.frame.size.height)))/2
                let ExpectedHight:CGFloat = (ContainerDetailLocationImageView.frame.origin.y+ContainerDetailLocationImageView.frame.size.height)+defference
                let TempraryFlightLabel :UILabel = UILabel.init(frame: CGRect.init(x:20, y:ExpectedHight, width:ContainerDetailView.frame.size.width-40, height:20))
                TempraryFlightLabel.text=UserDefaults.standard.value(forKey: "TemporaryFligthInfo") as! String?
                TempraryFlightLabel.textColor = secondaryColor()
                TempraryFlightLabel.adjustsFontSizeToFitWidth=true
                if((ItemPressedObject.value(forKey: "synced") as! Bool)==true){
                    ContainerDetailView.addSubview(TempraryFlightLabel)
                }
            }
        }
        
        ContainerDetailView.tag = 0901
        return ContainerDetailView
        
    }
    
    func getScannedItemsScrollView(scannedItemsArray:NSArray,lastItemScanned:Bag?) -> UIView{
        AppDelegate.getDelegate().ScannedItemsArray=scannedItemsArray
        var ScannedItemsArrayCount=scannedItemsArray.count
        var Bags:NSManagedObject
        var ScannedItemsView=UIView(frame: CGRect(x:0,y:Constants.UIScreenMainHeight-(Constants.UIScreenMainHeight/2.5),width:UIScreen.main.bounds.width,height:Constants.UIScreenMainHeight/2.5))
        let taped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EmptyPressed))
        ScannedItemsView.addGestureRecognizer(taped)
        if(scannedItemsArray.count != 0){
            let ScannedItemsHeaderImageView=UIImageView(frame: CGRect(x:0,y:0,width:ScannedItemsView.frame.width,height:ScannedItemsView.frame.height/7))
            let ScannedItemsHeaderNumberOfItemsLabel=UILabel(frame: CGRect(x:10,y:10,width:ScannedItemsHeaderImageView.frame.width/3,height:20))
            _=UIImageView(frame: CGRect(x:0,y:0,width:0,height:0))
            _=UIImageView(frame: CGRect(x:0,y:0,width:0,height:0))
            ScannedItemsScrollView=UIScrollView(frame: CGRect(x:0,y:ScannedItemsHeaderImageView.frame.height,width:ScannedItemsView.frame.width,height:ScannedItemsView.frame.height))
            ScannedItemsView.backgroundColor=QueueBackgroundColor()
            ScannedItemsView.tag=0
            ScannedItemsHeaderImageView.image=QueueHeaderImage()
            ScannedItemsView.addSubview(ScannedItemsHeaderImageView)
            if(scannedItemsArray.count != 1){
                ScannedItemsHeaderNumberOfItemsLabel.text=String(format: "items_in_queue".localized, String(scannedItemsArray.count))
            }else{
                ScannedItemsHeaderNumberOfItemsLabel.text=String(format: "item_in_queue".localized, String(scannedItemsArray.count))
            }
            ScannedItemsHeaderNumberOfItemsLabel.adjustsFontSizeToFitWidth=true
            ScannedItemsHeaderNumberOfItemsLabel.textColor=secondaryColor()
            ScannedItemsHeaderImageView.addSubview(ScannedItemsHeaderNumberOfItemsLabel)
            ScannedItemsScrollView.isScrollEnabled=true
            ScannedItemsScrollView.alwaysBounceHorizontal=true
            ScannedItemsView.addSubview(ScannedItemsScrollView)
            var ImageViewWidth=CGFloat(10.0)
            for i in (0 ..< scannedItemsArray.count){
                if(i%2==0){
                    let ScannedItemsContainerBagsViewContainer=UIView(frame: CGRect(x:ImageViewWidth,y:10,width:ScannedItemsView.frame.width/5,height:ScannedItemsView.frame.width/5+15+3))
                    let ScannedItemsContainerBagsView=UIView(frame: CGRect(x:0,y:0,width:ScannedItemsView.frame.width/5,height:ScannedItemsView.frame.width/5))
                    let ScannedItemsContainerBagsImageView=UIImageView(frame: CGRect(x:ScannedItemsContainerBagsView.frame.width/6,y:ScannedItemsContainerBagsView.frame.width/5,width:ScannedItemsContainerBagsView.frame.width/1.5,height:ScannedItemsContainerBagsView.frame.width/1.8))
                    let ScannedItemsContainerBagsCloud=UIImageView(frame: CGRect(x:ScannedItemsContainerBagsImageView.frame.width/2,y:ScannedItemsContainerBagsImageView.frame.width/3,width:ScannedItemsContainerBagsImageView.frame.width/2,height:ScannedItemsContainerBagsImageView.frame.width/2))
                    let ScannedItemsContainerBagsLabel=UILabel(frame: CGRect(x:0,y:ScannedItemsContainerBagsView.frame.origin.y+ScannedItemsContainerBagsView.frame.height,width:ScannedItemsContainerBagsView.frame.width,height:15))
                    Bags = scannedItemsArray[i] as! NSManagedObject
                    ScannedItemsContainerBagsView.backgroundColor=ScannedItemPrimaryColor()
                    let border = CALayer()
                    let width = CGFloat(3.0)
                    border.borderColor = primaryColor().cgColor
                    border.frame = CGRect(x: 0, y:0, width:ScannedItemsContainerBagsView.frame.width, height: ScannedItemsContainerBagsView.frame.height)
                    border.borderWidth = width
                    border.masksToBounds = false
                    border.cornerRadius = 5;
                    ScannedItemsContainerBagsView.layer.cornerRadius = 5;
                    ScannedItemsContainerBagsView.layer.addSublayer(border)
                    ScannedItemsContainerBagsViewContainer.accessibilityLabel="\(i)"
                    ScannedItemsScrollView.addSubview(ScannedItemsContainerBagsViewContainer)
                    ScannedItemsContainerBagsViewContainer.addSubview(ScannedItemsContainerBagsView)
                    if((Bags.value(forKey: "itemType") as! String) == "bag"){
                        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BagPressed))
                        ScannedItemsContainerBagsViewContainer.addGestureRecognizer(tap)
                        ScannedItemsContainerBagsImageView.image=UIImage(named: "Bag" )
                        ScannedItemsContainerBagsImageView.image = ScannedItemsContainerBagsImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        ScannedItemsContainerBagsImageView.tintColor = ScannedItemSecondaryColor()
                        ScannedItemsContainerBagsView.addSubview(ScannedItemsContainerBagsImageView)
                        if(Bags.value(forKey: "synced") as! Bool == false){
                            ScannedItemsContainerBagsCloud.frame=CGRect(x:ScannedItemsContainerBagsImageView.frame.width/1.8,y:ScannedItemsContainerBagsImageView.frame.width/3.2,width:ScannedItemsContainerBagsImageView.frame.width/2.5,height:ScannedItemsContainerBagsImageView.frame.width/2.5)
                            if (Bags.value(forKey: "errorMsg") as? String != "" && Bags.value(forKey: "errorMsg") as? String != "Network_Connection_Issue".localized){
                                ScannedItemsContainerBagsCloud.image=UIImage(named: "Cancel.png")
                                ScannedItemsContainerBagsCloud.image=ScannedItemsContainerBagsCloud.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                                ScannedItemsContainerBagsCloud.tintColor=UIColor.red
                            }
                            else{
                                ScannedItemsContainerBagsCloud.image=UIImage(named: "cloud_off_white")
                                ScannedItemsContainerBagsCloud.image = ScannedItemsContainerBagsCloud.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                                ScannedItemsContainerBagsCloud.tintColor = secondaryColor()
                            }
                        }else{
                            ScannedItemsContainerBagsCloud.image=UIImage(named: "cloud_sync" )
                            ScannedItemsContainerBagsCloud.image = ScannedItemsContainerBagsCloud.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                            ScannedItemsContainerBagsCloud.tintColor = secondaryColor()
                            ScannedItemsArrayCount=ScannedItemsArrayCount-1
                            if(ScannedItemsArrayCount > 0){
                                ScannedItemsHeaderNumberOfItemsLabel.text=String(format: "item_in_queue".localized, String(ScannedItemsArrayCount))
                            } else {
                                ScannedItemsHeaderNumberOfItemsLabel.text=""
                            }
                        }
                        ScannedItemsContainerBagsImageView.addSubview(ScannedItemsContainerBagsCloud)
                        ScannedItemsContainerBagsLabel.text=Bags.value(forKey: "bagTag") as? String
                    }else{
                        if((Bags.value(forKey: "itemType") as! String) == "container"){
                            let ScannedItemsContainerBagsImageView=UIImageView(frame: CGRect(x:ScannedItemsContainerBagsView.frame.width/5,y:ScannedItemsContainerBagsView.frame.width/4,width:ScannedItemsContainerBagsView.frame.width/1.8,height:ScannedItemsContainerBagsView.frame.width/2.1))
                            ScannedItemsContainerBagsCloud.frame.origin.x=ScannedItemsContainerBagsImageView.frame.width/2.1
                            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContainerPressed))
                            ScannedItemsContainerBagsViewContainer.addGestureRecognizer(tap)
                            ScannedItemsContainerBagsImageView.image=UIImage(named:"deliverycontainer")
                            ScannedItemsContainerBagsImageView.image = ScannedItemsContainerBagsImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                            ScannedItemsContainerBagsImageView.tintColor = ScannedItemSecondaryColor()
                            ScannedItemsContainerBagsView.addSubview(ScannedItemsContainerBagsImageView)
                            if(Bags.value(forKey: "synced") as! Bool == false){
                                ScannedItemsContainerBagsCloud.frame=CGRect(x:ScannedItemsContainerBagsImageView.frame.width/1.8,y:ScannedItemsContainerBagsImageView.frame.width/2.2,width:ScannedItemsContainerBagsImageView.frame.width/2.5,height:ScannedItemsContainerBagsImageView.frame.width/2.5)
                                if (Bags.value(forKey: "errorMsg") as? String != "" && Bags.value(forKey: "errorMsg") as? String != "Network_Connection_Issue".localized){
                                    ScannedItemsContainerBagsCloud.image=UIImage(named: "Cancel.png")
                                    ScannedItemsContainerBagsCloud.image=ScannedItemsContainerBagsCloud.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                                    ScannedItemsContainerBagsCloud.tintColor=UIColor.red
                                }
                                else{
                                    ScannedItemsContainerBagsCloud.image=UIImage(named: "cloud_off_white")
                                    ScannedItemsContainerBagsCloud.image = ScannedItemsContainerBagsCloud.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                                    ScannedItemsContainerBagsCloud.tintColor = secondaryColor()
                                }
                            }else{
                                ScannedItemsContainerBagsCloud.image=UIImage(named: "cloud_sync" )
                                ScannedItemsContainerBagsCloud.image = ScannedItemsContainerBagsCloud.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                                ScannedItemsContainerBagsCloud.tintColor = secondaryColor()
                                ScannedItemsArrayCount=ScannedItemsArrayCount-1
                                if(ScannedItemsArrayCount > 0){
                                    ScannedItemsHeaderNumberOfItemsLabel.text=String(format: "item_in_queue".localized, String(ScannedItemsArrayCount))
                                } else {
                                    ScannedItemsHeaderNumberOfItemsLabel.text=""
                                }
                            }
                            
                            ScannedItemsContainerBagsImageView.addSubview(ScannedItemsContainerBagsCloud)
                            ScannedItemsContainerBagsLabel.text=Bags.value(forKey: "containerID") as? String
                        }
                    }
                    ScannedItemsContainerBagsLabel.textColor=ScannedItemPrimaryColor()
                    ScannedItemsContainerBagsLabel.adjustsFontSizeToFitWidth=true
                    ScannedItemsContainerBagsViewContainer.addSubview(ScannedItemsContainerBagsLabel)
                    if((scannedItemsArray.lastObject) != nil){
                        ScannedItemsScrollView.contentSize=CGSize(width:ScannedItemsContainerBagsViewContainer.frame.origin.x+ScannedItemsContainerBagsViewContainer.frame.width+10,height:ScannedItemsHeaderImageView.frame.height)
                    }
                    let CurrentBagTag    = (Bags.value(forKey: "bagTag") as? String)
                    let CurrentTrackingPoint = Bags.value(forKey: "trackingPoint") as! String
                    let CurrentContainerID = (Bags.value(forKey: "containerID") as? String)
                    if(CurrentTrackingPoint != "" && (CurrentBagTag != "" || CurrentContainerID != "" )){
                        if(CurrentBagTag == lastItemScanned?.bagTag && CurrentTrackingPoint == lastItemScanned?.Trackinglocation && CurrentContainerID == lastItemScanned?.containerID){
                            ScannedItemsContainerBagsCloud.isHidden=true
                            CloudInstance=ScannedItemsContainerBagsCloud
                            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x:ScannedItemsContainerBagsViewContainer.frame.width/2-2.5, y:ScannedItemsContainerBagsViewContainer.frame.height+3,width: 1,height: 1)) as UIActivityIndicatorView
                            LoaderInstance=loadingIndicator
                            loadingIndicator.tag=123
                            loadingIndicator.transform = CGAffineTransform(scaleX: 0.4, y: 0.4);
                            loadingIndicator.hidesWhenStopped = true
                            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
                            loadingIndicator.startAnimating()
                            ScannedItemsContainerBagsViewContainer.addSubview(loadingIndicator)
                            ViewInstance=ScannedItemsContainerBagsViewContainer
                            StartScannedItemAnimation()
                            if(UIScreen.main.bounds.width-ScannedItemsContainerBagsViewContainer.frame.width<ScannedItemsContainerBagsViewContainer.frame.origin.x){
                                var offset = ScannedItemsScrollView.contentOffset
                                offset.x = ScannedItemsContainerBagsViewContainer.frame.origin.x-UIScreen.main.bounds.width+ScannedItemsContainerBagsViewContainer.frame.width+10
                                ScannedItemsScrollView.setContentOffset(offset, animated: true)
                            }
                        }
                    }
                }
                else if(i%2 != 0){
                    let ScannedItemsContainerBagsViewContainer=UIView(frame: CGRect(x:ImageViewWidth,y:ScannedItemsScrollView.frame.height/2.3,width:ScannedItemsView.frame.width/5,height:ScannedItemsView.frame.width/5+15+3))
                    let ScannedItemsContainerBagsView=UIView(frame: CGRect(x:0,y:0,width:ScannedItemsView.frame.width/5,height:ScannedItemsView.frame.width/5))
                    let ScannedItemsContainerBagsImageView=UIImageView(frame: CGRect(x:ScannedItemsContainerBagsView.frame.width/6,y:ScannedItemsContainerBagsView.frame.width/5,width:ScannedItemsContainerBagsView.frame.width/1.5,height:ScannedItemsContainerBagsView.frame.width/1.8))
                    let ScannedItemsContainerBagsCloud=UIImageView(frame: CGRect(x:ScannedItemsContainerBagsImageView.frame.width/2,y:ScannedItemsContainerBagsImageView.frame.width/3,width:ScannedItemsContainerBagsImageView.frame.width/2,height:ScannedItemsContainerBagsImageView.frame.width/2))
                    let ScannedItemsContainerBagsLabel=UILabel(frame: CGRect(x:0,y:ScannedItemsContainerBagsView.frame.origin.y+ScannedItemsContainerBagsView.frame.height,width:ScannedItemsContainerBagsView.frame.width,height:15))
                    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContainerPressed))
                    ScannedItemsContainerBagsViewContainer.addGestureRecognizer(tap)
                    let Bags = scannedItemsArray[i] as! NSManagedObject
                    ScannedItemsContainerBagsView.backgroundColor=ScannedItemPrimaryColor()
                    let border = CALayer()
                    let width = CGFloat(3.0)
                    border.borderColor = primaryColor().cgColor
                    border.frame = CGRect(x: 0, y:0, width:ScannedItemsContainerBagsView.frame.width, height: ScannedItemsContainerBagsView.frame.height)
                    border.borderWidth = width
                    border.masksToBounds = false
                    border.cornerRadius = 5;
                    ScannedItemsContainerBagsView.layer.cornerRadius = 5;
                    ScannedItemsContainerBagsView.layer.addSublayer(border)
                    ScannedItemsContainerBagsViewContainer.accessibilityLabel="\(i)"
                    ScannedItemsScrollView.addSubview(ScannedItemsContainerBagsViewContainer)
                    ScannedItemsContainerBagsViewContainer.addSubview(ScannedItemsContainerBagsView)
                    if((Bags.value(forKey: "itemType") as! String) == "bag"){
                        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BagPressed))
                        ScannedItemsContainerBagsViewContainer.addGestureRecognizer(tap)
                        ScannedItemsContainerBagsImageView.image=UIImage(named: "Bag" )
                        ScannedItemsContainerBagsImageView.image = ScannedItemsContainerBagsImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        ScannedItemsContainerBagsImageView.tintColor = ScannedItemSecondaryColor()
                        ScannedItemsContainerBagsView.addSubview(ScannedItemsContainerBagsImageView)
                        if(Bags.value(forKey: "synced") as! Bool == false){
                            ScannedItemsContainerBagsCloud.frame=CGRect(x:ScannedItemsContainerBagsImageView.frame.width/1.8,y:ScannedItemsContainerBagsImageView.frame.width/3.2,width:ScannedItemsContainerBagsImageView.frame.width/2.5,height:ScannedItemsContainerBagsImageView.frame.width/2.5)
                            if (Bags.value(forKey: "errorMsg") as? String != "" && Bags.value(forKey: "errorMsg") as? String != "Network_Connection_Issue".localized){
                                ScannedItemsContainerBagsCloud.image=UIImage(named: "Cancel.png")
                                ScannedItemsContainerBagsCloud.image=ScannedItemsContainerBagsCloud.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                                ScannedItemsContainerBagsCloud.tintColor=UIColor.red
                            }
                            else{
                                ScannedItemsContainerBagsCloud.image=UIImage(named: "cloud_off_white")
                                ScannedItemsContainerBagsCloud.image = ScannedItemsContainerBagsCloud.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                                ScannedItemsContainerBagsCloud.tintColor = secondaryColor()
                            }
                        }else{
                            ScannedItemsContainerBagsCloud.image=UIImage(named: "cloud_sync" )
                            ScannedItemsContainerBagsCloud.image = ScannedItemsContainerBagsCloud.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                            ScannedItemsContainerBagsCloud.tintColor = secondaryColor()
                            ScannedItemsArrayCount=ScannedItemsArrayCount-1
                            if(ScannedItemsArrayCount > 0){
                                ScannedItemsHeaderNumberOfItemsLabel.text=String(format: "item_in_queue".localized, String(ScannedItemsArrayCount))
                            } else {
                                ScannedItemsHeaderNumberOfItemsLabel.text = ""
                            }
                        }
                        
                        ScannedItemsContainerBagsImageView.addSubview(ScannedItemsContainerBagsCloud)
                        ScannedItemsContainerBagsLabel.text=Bags.value(forKey: "bagTag") as? String
                    }else{
                        if((Bags.value(forKey: "itemType") as! String) == "container"){
                            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContainerPressed))
                            ScannedItemsContainerBagsViewContainer.addGestureRecognizer(tap)
                            ScannedItemsContainerBagsImageView.image=UIImage(named:"deliverycontainer")
                            ScannedItemsContainerBagsImageView.image = ScannedItemsContainerBagsImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                            ScannedItemsContainerBagsImageView.tintColor = ScannedItemSecondaryColor()
                            ScannedItemsContainerBagsView.addSubview(ScannedItemsContainerBagsImageView)
                            if(Bags.value(forKey: "synced") as! Bool == false){
                                ScannedItemsContainerBagsCloud.frame=CGRect(x:ScannedItemsContainerBagsImageView.frame.width/1.8,y:ScannedItemsContainerBagsImageView.frame.width/2.2,width:ScannedItemsContainerBagsImageView.frame.width/2.5,height:ScannedItemsContainerBagsImageView.frame.width/2.5)
                                if (Bags.value(forKey: "errorMsg") as? String != "" && Bags.value(forKey: "errorMsg") as? String != "Network_Connection_Issue".localized){
                                    ScannedItemsContainerBagsCloud.image=UIImage(named: "Cancel.png")
                                    ScannedItemsContainerBagsCloud.image=ScannedItemsContainerBagsCloud.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                                    ScannedItemsContainerBagsCloud.tintColor=UIColor.red
                                }
                                else{
                                    ScannedItemsContainerBagsCloud.image=UIImage(named: "cloud_off_white")
                                    ScannedItemsContainerBagsCloud.image = ScannedItemsContainerBagsCloud.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                                    ScannedItemsContainerBagsCloud.tintColor = secondaryColor()
                                }
                            }else{
                                ScannedItemsContainerBagsCloud.image=UIImage(named: "cloud_sync" )
                                ScannedItemsContainerBagsCloud.image = ScannedItemsContainerBagsCloud.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                                ScannedItemsContainerBagsCloud.tintColor = secondaryColor()
                                ScannedItemsArrayCount=ScannedItemsArrayCount-1
                                if(ScannedItemsArrayCount > 0){
                                    ScannedItemsHeaderNumberOfItemsLabel.text=String(format: "item_in_queue".localized, String(ScannedItemsArrayCount))
                                } else {
                                    ScannedItemsHeaderNumberOfItemsLabel.text=""
                                }
                            }
                            ScannedItemsContainerBagsImageView.addSubview(ScannedItemsContainerBagsCloud)
                            ScannedItemsContainerBagsLabel.text=Bags.value(forKey: "containerID") as? String
                        }
                    }
                    ScannedItemsContainerBagsLabel.textColor=ScannedItemPrimaryColor()
                    ScannedItemsContainerBagsLabel.adjustsFontSizeToFitWidth=true
                    ScannedItemsContainerBagsViewContainer.addSubview(ScannedItemsContainerBagsLabel)
                    ImageViewWidth=ImageViewWidth+ScannedItemsContainerBagsViewContainer.frame.width+10
                    if(ScannedItemsContainerBagsViewContainer.frame.origin.x+ScannedItemsContainerBagsViewContainer.frame.width > ScannedItemsScrollView.frame.width){
                        ScannedItemsScrollView.contentSize=CGSize(width:ScannedItemsContainerBagsViewContainer.frame.origin.x+ScannedItemsContainerBagsViewContainer.frame.width+10,height:ScannedItemsHeaderImageView.frame.height)
                    }
                    let CurrentBagTag    = (Bags.value(forKey: "bagTag") as? String)
                    let CurrentTrackingPoint = Bags.value(forKey: "trackingPoint") as! String
                    let CurrentContainerID = (Bags.value(forKey: "containerID") as? String)
                    if(CurrentTrackingPoint != "" && (CurrentBagTag != "" || CurrentContainerID != "" )){
                        if(CurrentBagTag == lastItemScanned?.bagTag && CurrentTrackingPoint == lastItemScanned?.Trackinglocation && CurrentContainerID == lastItemScanned?.containerID){
                            ScannedItemsContainerBagsCloud.isHidden=true
                            CloudInstance=ScannedItemsContainerBagsCloud
                            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x:ScannedItemsContainerBagsViewContainer.frame.width/2-2.5, y:ScannedItemsContainerBagsViewContainer.frame.height+3,width: 1,height: 1)) as UIActivityIndicatorView
                            LoaderInstance=loadingIndicator
                            loadingIndicator.tag=123
                            loadingIndicator.transform = CGAffineTransform(scaleX: 0.4, y: 0.4);
                            loadingIndicator.hidesWhenStopped = true
                            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
                            loadingIndicator.startAnimating()
                            ScannedItemsContainerBagsViewContainer.addSubview(loadingIndicator)
                            ViewInstance=ScannedItemsContainerBagsViewContainer
                            StartScannedItemAnimation()
                            if(UIScreen.main.bounds.width-ScannedItemsContainerBagsViewContainer.frame.width<ScannedItemsContainerBagsViewContainer.frame.origin.x){
                                var offset = ScannedItemsScrollView.contentOffset
                                offset.x = ScannedItemsContainerBagsViewContainer.frame.origin.x-UIScreen.main.bounds.width+ScannedItemsContainerBagsViewContainer.frame.width+10
                                ScannedItemsScrollView.setContentOffset(offset, animated: true)
                            }
                        }
                    }
                }
            }
            if(DeletedView != nil){
                if(UIScreen.main.bounds.width-(DeletedView?.frame.width)!<(DeletedView?.frame.origin.x)!){
                    var offset = ScannedItemsScrollView.contentOffset
                    offset.x = (DeletedView?.frame.origin.x)!-UIScreen.main.bounds.width+(DeletedView?.frame.width)!+10
                    ScannedItemsScrollView.setContentOffset(offset, animated: true)
                }
                DeletedView = nil
            }
            return ScannedItemsView
        }else{
            (ScannedItemsView=UIView(frame: CGRect(x:0,y:0,width:0,height:0)))
            return ScannedItemsView
        }
    }
    
    func ContainerPressed(sender: UITapGestureRecognizer){
        let tapedView = sender.view
        let ItemAtIndex = Int((tapedView?.accessibilityLabel)!)
        let ItemPressed=AppDelegate.getDelegate().ScannedItemsArray[ItemAtIndex!] as! NSManagedObject
        DeletedView=sender.view!
        AppDelegate.getDelegate().showOverlayWithView(viewToShow: getContainerDetailView(ItemPressedObject: ItemPressed), dismiss: true, AccessToMenu: false)
        AppDelegate.getDelegate().viewPressedInstance=tapedView!
    }
    
    func BagPressed(sender: UITapGestureRecognizer){
        let tapedView = sender.view
        let ItemAtIndex = Int((tapedView?.accessibilityLabel)!)
        let ItemPressed=AppDelegate.getDelegate().ScannedItemsArray[ItemAtIndex!] as! NSManagedObject
        DeletedView=sender.view!
        AppDelegate.getDelegate().showOverlayWithView(viewToShow: getBagDetailView(ItemPressedObject: ItemPressed), dismiss: true, AccessToMenu: false)
        AppDelegate.getDelegate().viewPressedInstance=tapedView!
    }
    
    func EmptyPressed(){ /* DONT DELETE - does nothing used to overide gesture of menu on scroll view - */}
    
    func StartScannedItemAnimation(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [UIViewAnimationOptions.curveEaseOut], animations: {
            self.ViewInstance.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [UIViewAnimationOptions.curveEaseOut], animations: {
                    self.ViewInstance.alpha = 1.0
                    }, completion:{
                        (finished: Bool) -> Void in
                        self.StopScannedItemAnimation()
                })
        })
    }
    
    func showActivityIndicatorWithWidth(view:UIView,loader:UIActivityIndicatorView){
        loader.hidesWhenStopped = true
        loader.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        loader.startAnimating()
        view.addSubview(loader)
        
    }
    
    func StopScannedItemAnimation(){
        LoaderInstance.removeFromSuperview()
        CloudInstance.isHidden=false
    }
    
    func itemResetButtonClicked(sender: UITapGestureRecognizer){
        let tapedString = sender.accessibilityLabel
        let errorMessage = sender.accessibilityValue
        let tappedStringArr=tapedString?.components(separatedBy: ",")
        let trackinglocation = tappedStringArr?[0]
        let bagTag = tappedStringArr?[1]
        let ContanerId=tappedStringArr?[2]
        
        if errorMessage == nil {
            UserDefaultsManager().resetScannedItemStatus(trackingPoint: trackinglocation!, bagTag: bagTag!, containerID: ContanerId!)
        } else {
            let bagsArray = UserDefaultsManager().getLockedBagWithSameErrorDisc(error: errorMessage!)!
            UserDefaultsManager().resetSpecificItems(arrayOfBags: bagsArray)
        }
        AppDelegate.getDelegate().doClose()
    }
    
    func itemDeleteButtonClicked(sender: UITapGestureRecognizer){
        let tapedString = sender.accessibilityLabel
        let tappedStringArr=tapedString?.components(separatedBy: ",")
        let trackinglocation    = tappedStringArr?[0]
        let bagTag = tappedStringArr?[1]
        let ContanerId=tappedStringArr?[2]
        UserDefaultsManager().deleteScannedItem(trackingPoint: trackinglocation!, bagTag: bagTag!, containerID: ContanerId!)
        AppDelegate.getDelegate().doClose()
    }
    
    func DeleteSimelerButtonClicked(sender: UITapGestureRecognizer){
        let tapedString = sender.accessibilityLabel!
        UserDefaultsManager().deleteSpecificBags(BagsArray:UserDefaultsManager().getLockedBagWithSameErrorDisc(error: tapedString)!)
        AppDelegate.getDelegate().doClose()
    }
    
    func showActivityIndicator(TrackingPoint:String,bagTag:String){
        AppDelegate.getDelegate().LoaderInstance2.frame = CGRect(x:AppDelegate.getDelegate().viewPressedInstance.frame.width/2-2.5, y:AppDelegate.getDelegate().viewPressedInstance.frame.height+3,width: 1,height: 1)
        AppDelegate.getDelegate().LoaderInstance2.transform = CGAffineTransform(scaleX: 0.4, y: 0.4);
        AppDelegate.getDelegate().LoaderInstance2.hidesWhenStopped = true
        AppDelegate.getDelegate().LoaderInstance2.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        AppDelegate.getDelegate().LoaderInstance2.startAnimating()
        AppDelegate.getDelegate().viewPressedInstance.addSubview(AppDelegate.getDelegate().LoaderInstance2)
    }
    
    func stopActivityIndicator(){
        AppDelegate.getDelegate().LoaderInstance2.removeFromSuperview()
    }
}


