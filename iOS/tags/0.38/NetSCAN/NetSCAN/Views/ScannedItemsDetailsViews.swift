//
//  ScannedItemsDetailsViews.swift
//  NetSCAN
//
//  Created by User on 9/20/16.
//  Copyright © 2016 User. All rights reserved.
//

import Foundation

class ScannedItemsDetailsViews:UIView{
    
    
    @IBOutlet var ContainerDetailResetButton: UIButton!
    @IBOutlet var ContainerDetailDeleteButton: UIButton!
    
    let screen=UIScreen.main.bounds
    
    func getContainerView(containerName:String, desription:String, size:String, countour:String, type:String) -> UIView
    {
        
        let ContainerView=UIView(frame: CGRect(x:0,y:screen.height/2-150,width:screen.width,height:250))
        let InnerContainerView=UIView(frame: CGRect(x:10,y:ContainerView.frame.height/2-100,width:ContainerView.frame.width/2+50,height:ContainerView.frame.height-50))
        let InnerContainerImageView=UIImageView(frame: CGRect(x:InnerContainerView.frame.width-5,y:ContainerView.frame.height/2-(ContainerView.frame.width/6),width:ContainerView.frame.width/2-30,height:ContainerView.frame.width/2-60))
        let ContainerNameLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/12,y:InnerContainerView.frame.height/10,width:InnerContainerView.frame.width-(InnerContainerView.frame.width/12),height:InnerContainerView.frame.height/12))
        let DesriptionLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/12,y:(InnerContainerView.frame.height/3.6),width:InnerContainerView.frame.width-(InnerContainerView.frame.width/12),height:InnerContainerView.frame.height/12))
        let BaseSizeLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/12,y:(InnerContainerView.frame.height/2.2),width:80,height:InnerContainerView.frame.height/12))
        let BaseSizeValueLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/12+BaseSizeLabel.frame.width,y:(InnerContainerView.frame.height/2.2),width:InnerContainerView.frame.width-(InnerContainerView.frame.width/12)-(BaseSizeLabel.frame.width),height:InnerContainerView.frame.height/12))
        let CountourLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/12,y:(InnerContainerView.frame.height/1.6),width:80,height:InnerContainerView.frame.height/12))
        let CountourValueLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/12+CountourLabel.frame.width,y:(InnerContainerView.frame.height/1.6),width:InnerContainerView.frame.width-(InnerContainerView.frame.width/12)-(CountourLabel.frame.width),height:InnerContainerView.frame.height/12))
        let TypeLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/12,y:(InnerContainerView.frame.height/1.3+5),width:45,height:InnerContainerView.frame.height/12))
        let TypeValueLabel=UILabel(frame: CGRect(x:InnerContainerView.frame.width/12+TypeLabel.frame.width,y:(InnerContainerView.frame.height/1.3+5),width:InnerContainerView.frame.width-(InnerContainerView.frame.width/12)-(TypeLabel.frame.width),height:InnerContainerView.frame.height/12))
        
        
        
        InnerContainerView.backgroundColor=GetColorFromHex(rgbValue: 0x4F4F4F)
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = GetColorFromHex(rgbValue: UInt32(Constants.BorderColor)).cgColor
        border.frame = CGRect(x: 0, y:0, width:InnerContainerView.frame.width, height: InnerContainerView.frame.height)
        border.borderWidth = width
        InnerContainerView.layer.addSublayer(border)
        InnerContainerView.layer.masksToBounds = true
        ContainerView.addSubview(InnerContainerView)
        
        
        InnerContainerImageView.image=UIImage(named:"A")
        ContainerView.addSubview(InnerContainerImageView)
        
        ContainerNameLabel.text=containerName
        ContainerNameLabel.textColor=UIColor.white
        ContainerNameLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(ContainerNameLabel)
        
        DesriptionLabel.text=desription
        DesriptionLabel.textColor=UIColor.white
        DesriptionLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(DesriptionLabel)
        
        BaseSizeLabel.text="size".localized
        BaseSizeLabel.textColor=UIColor.white
        BaseSizeLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(BaseSizeLabel)
        
        BaseSizeValueLabel.text=size
        BaseSizeValueLabel.textColor=UIColor.gray
        BaseSizeValueLabel.font=UIFont.boldSystemFont(ofSize: 12.0)
        InnerContainerView.addSubview(BaseSizeValueLabel)
        
        CountourLabel.text="contour".localized
        CountourLabel.textColor=UIColor.white
        CountourLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(CountourLabel)
        
        CountourValueLabel.text=countour
        CountourValueLabel.textColor=UIColor.gray
        CountourValueLabel.font=UIFont.boldSystemFont(ofSize: 12.0)
        InnerContainerView.addSubview(CountourValueLabel)
        
        TypeLabel.text="uld_type".localized
        TypeLabel.textColor=UIColor.white
        TypeLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(TypeLabel)
        
        TypeValueLabel.text=type
        TypeValueLabel.textColor=UIColor.gray
        TypeValueLabel.font=UIFont.boldSystemFont(ofSize: 16.0)
        InnerContainerView.addSubview(TypeValueLabel)
        
        return ContainerView
        
    }
    
    func getContainerDetailView(synced:Bool, type:String, location:String, containerName:String, status:String) -> UIView
    {
        
        let ContainerDetailView=UIView(frame: CGRect(x:20,y:screen.height/2-(screen.height/3),width:screen.width-40,height:screen.height/1.5))
        let ContainerDetailContainer=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:-ContainerDetailView.frame.width/12,width:ContainerDetailView.frame.width/4,height:ContainerDetailView.frame.width/4))
        let ContainerDetailImageView=UIImageView(frame: CGRect(x:10,y:10,width:ContainerDetailContainer.frame.width-20,height:ContainerDetailContainer.frame.height-20))
        let ContainerDetailCloudImageView=UIImageView(frame: CGRect(x:ContainerDetailImageView.frame.width-(ContainerDetailImageView.frame.width/2.8),y:ContainerDetailImageView.frame.height-(ContainerDetailImageView.frame.height/2.8),width:ContainerDetailImageView.frame.width/3.5,height:ContainerDetailImageView.frame.height/3.5))
        let ContainerDetailTypeLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/2.5,y:ContainerDetailView.frame.width/10,width:100,height:20))
        let ContainerDetailLocationImageView=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:ContainerDetailContainer.frame.height,width:25,height:25))
        let ContainerDetailLocationLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/5,y:ContainerDetailContainer.frame.height,width:200,height:25))
        let ContainerDetailNameImageView=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:ContainerDetailLocationImageView.frame.origin.y+(ContainerDetailView.frame.width/6),width:25,height:25))
        let ContainerDetailNameLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/5,y:ContainerDetailLocationImageView.frame.origin.y+(ContainerDetailView.frame.width/6),width:200,height:25))
        let ContainerDetailStatusLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/20,y:ContainerDetailNameLabel.frame.origin.y+(ContainerDetailView.frame.width/5),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/10),height:50))
        ContainerDetailResetButton=UIButton(frame: CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailStatusLabel.frame.origin.y+(ContainerDetailView.frame.width/4),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50))
        
        ContainerDetailDeleteButton=UIButton(frame: CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailResetButton.frame.origin.y+(ContainerDetailView.frame.width/4),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50))
        
        ContainerDetailView.backgroundColor=GetColorFromHex(rgbValue: 0x2a2a2a).withAlphaComponent(0.9)
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = GetColorFromHex(rgbValue: UInt32(Constants.BorderColor)).cgColor
        border.frame = CGRect(x: 0, y:0, width:ContainerDetailView.frame.width, height: ContainerDetailView.frame.height)
        border.borderWidth = width
        ContainerDetailView.layer.addSublayer(border)
        ContainerDetailView.layer.masksToBounds = false
        
        ContainerDetailContainer.backgroundColor=UIColor.gray
        ContainerDetailContainer.layer.cornerRadius = 5;
        ContainerDetailContainer.layer.masksToBounds = true;
        
        ContainerDetailView.addSubview(ContainerDetailContainer)
        
        
        ContainerDetailImageView.image=UIImage(named: "deliverycontainer")
        ContainerDetailContainer.addSubview(ContainerDetailImageView)
        if(synced==false)
        {
            ContainerDetailCloudImageView.image=UIImage(named: "cloud_off_white")
        }
        else{
            ContainerDetailCloudImageView.image=UIImage(named: "cloud7")
        }
        ContainerDetailCloudImageView.image = ContainerDetailCloudImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailCloudImageView.tintColor = UIColor.white
        ContainerDetailImageView.addSubview(ContainerDetailCloudImageView)
        
        ContainerDetailTypeLabel.text=type
        ContainerDetailTypeLabel.textColor=UIColor.green
        ContainerDetailView.addSubview(ContainerDetailTypeLabel)
        
        ContainerDetailLocationImageView.image=UIImage(named: "gps-fixed")
        ContainerDetailLocationImageView.image = ContainerDetailLocationImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailLocationImageView.tintColor = UIColor.white
        ContainerDetailView.addSubview(ContainerDetailLocationImageView)
        
        ContainerDetailNameImageView.image=UIImage(named: "deliverycontainer")
        ContainerDetailNameImageView.image = ContainerDetailNameImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailNameImageView.tintColor = UIColor.white
        ContainerDetailView.addSubview(ContainerDetailNameImageView)
        
        ContainerDetailLocationLabel.text=location
        ContainerDetailLocationLabel.textColor=UIColor.white
        ContainerDetailView.addSubview(ContainerDetailLocationLabel)
        
        ContainerDetailNameLabel.text=containerName
        ContainerDetailNameLabel.textColor=UIColor.white
        ContainerDetailView.addSubview(ContainerDetailNameLabel)
        
        ContainerDetailStatusLabel.text=status
        ContainerDetailStatusLabel.textColor=UIColor.red
        ContainerDetailStatusLabel.numberOfLines=3
        ContainerDetailView.addSubview(ContainerDetailStatusLabel)
        
        ContainerDetailResetButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        ContainerDetailResetButton.layer.cornerRadius = 5;
        ContainerDetailResetButton.layer.masksToBounds = true;
        ContainerDetailResetButton.setTitle("reset_status".localized, for:[])
        ContainerDetailView.addSubview(ContainerDetailResetButton)
        
        ContainerDetailDeleteButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        ContainerDetailDeleteButton.layer.cornerRadius = 5;
        ContainerDetailDeleteButton.layer.masksToBounds = true;
        ContainerDetailDeleteButton.setTitle("delete_Bag".localized, for: [])
        ContainerDetailView.addSubview(ContainerDetailDeleteButton)
        
        ContainerDetailView.tag = 0901
        return ContainerDetailView
        
    }
   
    func getBagDetailView(synced:Bool,bagId:String, type:String, location:String, status:String) -> UIView
    {
        let ContainerDetailView=UIView(frame: CGRect(x:20,y:screen.height/2-(screen.height/4),width:screen.width-40,height:screen.height/2))
        let ContainerDetailContainer=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:-ContainerDetailView.frame.width/12,width:ContainerDetailView.frame.width/4,height:ContainerDetailView.frame.width/4))
        let ContainerDetailImageView=UIImageView(frame: CGRect(x:10,y:10,width:ContainerDetailContainer.frame.width-20,height:ContainerDetailContainer.frame.height-20))
        let ContainerDetailCloudImageView=UIImageView(frame: CGRect(x:ContainerDetailImageView.frame.width-(ContainerDetailImageView.frame.width/2.8),y:ContainerDetailImageView.frame.height-(ContainerDetailImageView.frame.height/2.8),width:ContainerDetailImageView.frame.width/3.5,height:ContainerDetailImageView.frame.height/3.5))
        let ContainerDetailBagIdLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/2.5,y:5,width:ContainerDetailView.frame.width/1.7,height:15))
        let ContainerDetailTypeLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/2.5,y:ContainerDetailView.frame.width/10,width:100,height:20))
        let ContainerDetailLocationImageView=UIImageView(frame: CGRect(x:ContainerDetailView.frame.width/12,y:ContainerDetailContainer.frame.height,width:25,height:25))
        let ContainerDetailLocationLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/5,y:ContainerDetailContainer.frame.height,width:ContainerDetailView.frame.width/1.7,height:25))
        let ContainerDetailStatusLabel=UILabel(frame: CGRect(x:ContainerDetailView.frame.width/20,y:ContainerDetailLocationLabel.frame.origin.y+(ContainerDetailView.frame.width/8),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/10),height:50))
        ContainerDetailResetButton=UIButton(frame: CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailStatusLabel.frame.origin.y+(ContainerDetailView.frame.width/5),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50))
        
        ContainerDetailDeleteButton=UIButton(frame: CGRect(x:ContainerDetailView.frame.width/9,y:ContainerDetailResetButton.frame.origin.y+(ContainerDetailView.frame.width/5),width:ContainerDetailView.frame.width-(ContainerDetailView.frame.width/4.5),height:50))
        
        ContainerDetailView.backgroundColor=GetColorFromHex(rgbValue: 0x2a2a2a).withAlphaComponent(0.9)
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = GetColorFromHex(rgbValue: UInt32(Constants.BorderColor)).cgColor
        border.frame = CGRect(x: 0, y:0, width:ContainerDetailView.frame.width, height: ContainerDetailView.frame.height)
        border.borderWidth = width
        ContainerDetailView.layer.addSublayer(border)
        ContainerDetailView.layer.masksToBounds = false
        
        ContainerDetailContainer.backgroundColor=UIColor.gray
        ContainerDetailContainer.layer.cornerRadius = 5;
        ContainerDetailContainer.layer.masksToBounds = true;
        
        ContainerDetailView.addSubview(ContainerDetailContainer)
        
        
        ContainerDetailImageView.image=UIImage(named: "Bag")
        ContainerDetailImageView.image = ContainerDetailImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailImageView.tintColor = UIColor.black
        
        ContainerDetailContainer.addSubview(ContainerDetailImageView)
        if(synced==false)
        {
            ContainerDetailCloudImageView.image=UIImage(named: "cloud_off_white")
        }
        else{
            ContainerDetailCloudImageView.image=UIImage(named: "cloud7")
        }
        ContainerDetailCloudImageView.image = ContainerDetailCloudImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailCloudImageView.tintColor = UIColor.white
        ContainerDetailImageView.addSubview(ContainerDetailCloudImageView)
        
        
        ContainerDetailBagIdLabel.text=bagId
        ContainerDetailBagIdLabel.textColor=UIColor.white
        ContainerDetailView.addSubview(ContainerDetailBagIdLabel)
        
        ContainerDetailTypeLabel.text=type
        ContainerDetailTypeLabel.textColor=UIColor.green
        ContainerDetailView.addSubview(ContainerDetailTypeLabel)
        
        ContainerDetailLocationImageView.image=UIImage(named: "gps-fixed")
        ContainerDetailLocationImageView.image = ContainerDetailLocationImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ContainerDetailLocationImageView.tintColor = UIColor.white
        ContainerDetailView.addSubview(ContainerDetailLocationImageView)
        
        ContainerDetailLocationLabel.text=location
        ContainerDetailLocationLabel.textColor=UIColor.white
        ContainerDetailView.addSubview(ContainerDetailLocationLabel)
        
        
        ContainerDetailStatusLabel.text=status
        ContainerDetailStatusLabel.textColor=UIColor.red
        ContainerDetailStatusLabel.numberOfLines=3
        ContainerDetailView.addSubview(ContainerDetailStatusLabel)
        
        ContainerDetailResetButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        ContainerDetailResetButton.layer.cornerRadius = 5;
        ContainerDetailResetButton.layer.masksToBounds = true;
        ContainerDetailResetButton.setTitle("reset_status".localized, for: [])
        ContainerDetailView.addSubview(ContainerDetailResetButton)
        
        ContainerDetailDeleteButton.backgroundColor=GetColorFromHex(rgbValue: 0x565656)
        ContainerDetailDeleteButton.layer.cornerRadius = 5;
        ContainerDetailDeleteButton.layer.masksToBounds = true;
        ContainerDetailDeleteButton.setTitle("delete_Bag".localized, for: [])
        ContainerDetailView.addSubview(ContainerDetailDeleteButton)
        
        ContainerDetailView.tag = 0901
        return ContainerDetailView

        
    }
}
