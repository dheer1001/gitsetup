//
//  UserDefaultsManager.swift
//  NetSCAN
//
//  Created by Developer on 9/27/16.
//  Copyright © 2016 User. All rights reserved.
//

import Foundation
import CoreData

class UserDefaultsManager{
    
    // MARK: Login functionality
    
    func saveLoginResponse(response:NSDictionary) {
        let defaults = UserDefaults.standard
        defaults.set(response, forKey: "loginResponse")
    }
    
    func getLoginResponse() -> NSDictionary
    {
        let defaults = UserDefaults.standard
        if let loginResponse = defaults.object(forKey: "loginResponse"){
            return (loginResponse as! NSDictionary)
        }
        return [:]
    }
    
    func saveLoginInfo(UserID: String, companyID: String){
        let defaults = UserDefaults.standard
        defaults.set(UserID, forKey: "userID")
        defaults.set(companyID, forKey: "companyID")
    }
    
    func getLoginInfo() -> [String:AnyObject] {
        let defaults = UserDefaults.standard
        var dictionary: [String:AnyObject] = [:]
        if let userID = defaults.string(forKey: "userID") {
            dictionary["userID"] = userID as AnyObject?
        }
        if let companyID = defaults.string(forKey: "companyID") {
            dictionary["companyID"] = companyID as AnyObject?
        }
        return dictionary
    }
    
    func SignOut() {
        
        RemoveTrackingPointRaw()
        RemoveTrackingLocation()
        RemoveTrackingPointValidityUntil()
        removeTrackingConfiguration()
        RemoveContainerID()
        removeFlightInformation()
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "selected_airport")
        defaults.removeObject(forKey: "selected_airline")
        defaults.removeObject(forKey: "loginResponse")
        defaults.synchronize()
    }
    
    // MARK: Flight information functionality
    func setFlightInformation(flight_num: String, flight_date: Date, flight_type: String){
        let defaults = UserDefaults.standard
        defaults.set(flight_num, forKey: "flight_num")
        defaults.set(flight_date, forKey: "flight_date")
        defaults.set(flight_type, forKey: "flight_type")
    }
    
    func setFlightNumber(flight_num: String){
        let defaults = UserDefaults.standard
        defaults.set(flight_num, forKey: "flight_num")
    }
    
    func getFlightNumber() -> String
    {
        let defaults = UserDefaults.standard
        if let flight_num = defaults.string(forKey: "flight_num"){
            return flight_num
        }
        return ""
    }
    
    func getFlightInformation() -> NSMutableDictionary {
        let defaults = UserDefaults.standard
        let dictionary = NSMutableDictionary()
        if let flight_num = defaults.object(forKey: "flight_num") {
            dictionary.setValue(flight_num as AnyObject?, forKey: "flight_num")
        }
        if let flight_date = defaults.object(forKey: "flight_date") {
            dictionary.setValue(flight_date as AnyObject?, forKey: "flight_date")
        }
        if let flight_type = defaults.string(forKey: "flight_type") {
            dictionary.setValue(flight_type as AnyObject?, forKey: "flight_type")
        }
        return dictionary
    }
    
    func removeFlightInformation(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "flight_num")
        defaults.removeObject(forKey: "flight_date")
        defaults.removeObject(forKey: "flight_type")
        defaults.synchronize()
    }
    
    // MARK: ContainerID functionality
    func SetContainerID(ContainerID:String){
        let defaults = UserDefaults.standard
        defaults.set(ContainerID, forKey: "ContainerID")
    }
    
    func GetContainerID() -> String{
        let defaults = UserDefaults.standard
        if let ContainerID = defaults.string(forKey: "ContainerID"){
            return ContainerID
        }
        return ""
    }
    
    func RemoveContainerID(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "ContainerID")
        defaults.synchronize()
    }
    
    // MARK: Tracking point information functionality
    // TrackingPointRaw
    func SetTrackingPointRaw(TrackingPointRaw:String){
        let defaults = UserDefaults.standard
        defaults.set(TrackingPointRaw, forKey: "TrackingPointRaw")
    }
    
    func GetTrackingPointRaw() -> String{
        let defaults = UserDefaults.standard
        if let TrackingPointRaw = defaults.string(forKey: "TrackingPointRaw"){
            return TrackingPointRaw
        }
        return ""
    }
    
    func RemoveTrackingPointRaw(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "TrackingPointRaw")
        defaults.synchronize()
    }
    
    func SetTrackingPointValidityUntil(){
        let currentTimeStamp = NSDate().timeIntervalSince1970 //double
        let TrackingPointValidityUntil = Int(Constants.TrackingPointExpiry) + Int(currentTimeStamp)
        let date = NSDate(timeIntervalSince1970: TimeInterval(TrackingPointValidityUntil))
        let defaults = UserDefaults.standard
        defaults.set(date, forKey: "TrackingPointValidityUntil")
    }
    
    func GetTrackingPointValidityUntil() -> Date{
        let defaults = UserDefaults.standard
        if let TrackingPointValidityUntil = defaults.object(forKey: "TrackingPointValidityUntil"){
            return TrackingPointValidityUntil as! Date
        }
        return Date.init(timeIntervalSince1970: .init())
    }
    
    func RemoveTrackingPointValidityUntil(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "TrackingPointValidityUntil")
        defaults.synchronize()
    }
    
    func SetTrackingLocation(TrackingLocation:String){
        let defaults = UserDefaults.standard
        defaults.set(TrackingLocation, forKey: "TrackingLocation")
    }
    
    func GetTrackingLocation() -> String{
        let defaults = UserDefaults.standard
        if let TrackingLocation = defaults.string(forKey: "TrackingLocation"){
            return TrackingLocation
        }
        return ""
    }
    
    func RemoveTrackingLocation(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "TrackingLocation")
        defaults.synchronize()
    }
    
    func setConfigurationsFor(airportCode:String,configurationArray:NSArray!) {
        if var configurations = getTrackingConfigurations() {
            configurations = configurations.mutableCopy() as! NSMutableDictionary
            configurations.setValue(configurationArray, forKey: airportCode)
            UserDefaults.standard.set(configurations, forKey: "trackingConfiguration")
        } else {
            let configuration = NSMutableDictionary()
            configuration.setValue(configurationArray, forKey: airportCode)
            UserDefaults.standard.set(configuration, forKey: "trackingConfiguration")
        }
    }
    
    func getTrackingConfigurationFor(airportCode:String) -> NSArray! {
        if let config :NSMutableDictionary = UserDefaults.standard.value(forKey:"trackingConfiguration") as? NSMutableDictionary {
            if let configurationForAirport:NSArray = config.value(forKey:airportCode) as? NSArray {
                if configurationForAirport.count > 0 {
                    return configurationForAirport
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func getTrackingConfigurations() -> NSMutableDictionary! {
        if let config :NSMutableDictionary = UserDefaults.standard.value(forKey:"trackingConfiguration") as? NSMutableDictionary {
            return config
        } else {
            return nil
        }
    }
    
    func removeTrackingConfiguration() {
        UserDefaults.standard.removeObject(forKey: "trackingConfiguration")
    }
    
    func setRecentlyUsedTrackingPoints(trackingPoint:NSDictionary,forKey:String){
        
        let recentlyUsedArray = NSMutableArray()
        if let arr = getRecentlyUsedTrackingPoints(forKey: forKey) {
            var count = 0
            recentlyUsedArray.add(trackingPoint)
            
            while (count<arr.count && recentlyUsedArray.count<4) {
                if (((arr.object(at: count) as! NSDictionary).value(forKey: "trackingPoint") as! String) != (trackingPoint.value(forKey: "trackingPoint") as! String)) {
                    recentlyUsedArray.add(arr.object(at: count) as! NSDictionary)
                }
                count = count+1
            }
        } else {
            recentlyUsedArray.add(trackingPoint)
        }
        UserDefaults.standard.set(recentlyUsedArray, forKey: forKey)
    }
    
    func getKeyForRecentlyUsed() -> String {
        let logInRes = self.getLoginResponse()
        if logInRes["service_id"] != nil &&  (logInRes["service_id"] as! String) != ""{
            if UserDefaults.standard.string(forKey: "companyID") != nil && UserDefaults.standard.string(forKey: "companyID") != "" {
                return (logInRes["service_id"] as! String) + "@" +  UserDefaults.standard.string(forKey: "companyID")!
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    func getRecentlyUsedTrackingPoints(forKey:String) -> NSArray!{
        if let arr = UserDefaults.standard.value(forKey: forKey) {
            return arr as! NSArray
        } else {
            return nil
        }
    }
    
    func removeRecentlyUsedTrackingPoints(key:String){
        UserDefaults.standard.removeObject(forKey:key)
    }
    
    
    // MARK: Save Core Data
    func saveBagToCoredata(scanDateTime: Date, trackingPoint: String, containerID: String, bagTag: String,itemType : String,flight_num: String, flight_type: String, flight_date: Date ,synced:Bool,locked:Bool,errorMsg:String){
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@ AND containerID = %@", trackingPoint, bagTag, containerID)
        let result = try? appDeletgate.managedObjectContext.fetch(request)
        if result?.count != 0{
            let updateBag = result?[0] as! NSManagedObject
            updateBag.setValue(scanDateTime, forKey: "scanDateTime")
            updateBag.setValue(flight_num, forKey: "flight_num")
            updateBag.setValue(flight_type, forKey: "flight_type")
            updateBag.setValue(flight_date, forKey: "flight_date")
            updateBag.setValue(synced, forKey: "synced")
            updateBag.setValue(locked, forKey: "locked")
            updateBag.setValue(errorMsg, forKey: "errorMsg")
            updateBag.setValue(itemType, forKey: "itemType")
            do {
                try updateBag.managedObjectContext?.save()
                if UserDefaults.standard.value(forKey:"bingo") == nil {
                    ScanManager().processScannedItemsQueue()
                }
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
        }else{
            let entityDescription = NSEntityDescription.entity(forEntityName: "Bags", in: appDeletgate.managedObjectContext)
            let newBag = NSManagedObject(entity: entityDescription!, insertInto: appDeletgate.managedObjectContext)
            newBag.setValue(scanDateTime, forKey: "scanDateTime")
            newBag.setValue(trackingPoint, forKey: "trackingPoint")
            newBag.setValue(containerID, forKey: "containerID")
            newBag.setValue(bagTag, forKey: "bagTag")
            newBag.setValue(flight_num, forKey: "flight_num")
            newBag.setValue(flight_type, forKey: "flight_type")
            newBag.setValue(flight_date, forKey: "flight_date")
            newBag.setValue(synced, forKey: "synced")
            newBag.setValue(locked, forKey: "locked")
            newBag.setValue(errorMsg, forKey: "errorMsg")
            newBag.setValue(itemType, forKey: "itemType")
            do {
                try newBag.managedObjectContext?.save()
                if UserDefaults.standard.value(forKey:"bingo") == nil {
                    ScanManager().processScannedItemsQueue()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func saveContainerToCoredata(scanDateTime: Date, trackingPoint: String, containerID: String, bagTag: String,itemType:String,synced:Bool,locked:Bool,errorMsg:String){
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@ AND containerID = %@", trackingPoint, bagTag, containerID)
        let result = try? appDeletgate.managedObjectContext.fetch(request)
        if result?.count != 0{
            let updateBag = result?[0] as! NSManagedObject
            updateBag.setValue(scanDateTime, forKey: "scanDateTime")
            updateBag.setValue(synced, forKey: "synced")
            updateBag.setValue(locked, forKey: "locked")
            updateBag.setValue(errorMsg, forKey: "errorMsg")
            updateBag.setValue(itemType, forKey: "itemType")
            do {
                try updateBag.managedObjectContext?.save()
                if UserDefaults.standard.value(forKey:"bingo") == nil {
                    ScanManager().processScannedItemsQueue()
                }
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
        }else{
            let entityDescription = NSEntityDescription.entity(forEntityName: "Bags", in: appDeletgate.managedObjectContext)
            let newBag = NSManagedObject(entity: entityDescription!, insertInto: appDeletgate.managedObjectContext)
            newBag.setValue(scanDateTime, forKey: "scanDateTime")
            newBag.setValue(trackingPoint, forKey: "trackingPoint")
            newBag.setValue(containerID, forKey: "containerID")
            newBag.setValue(bagTag, forKey: "bagTag")
            newBag.setValue(synced, forKey: "synced")
            newBag.setValue(locked, forKey: "locked")
            newBag.setValue(errorMsg, forKey: "errorMsg")
            newBag.setValue(itemType, forKey: "itemType")
            do {
                try newBag.managedObjectContext?.save()
                if UserDefaults.standard.value(forKey:"bingo") == nil {
                    ScanManager().processScannedItemsQueue()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func saveTrackingResponse(trackingResponse:String,trackingPoint: String, bagTag: String, containerID: String){
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@ AND containerID = %@", trackingPoint, bagTag, containerID)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            if result.count != 0{
                let updateBag = result[0] as! NSManagedObject
                updateBag.setValue(trackingResponse, forKey: "trackingResponse")
                do {
                    try updateBag.managedObjectContext?.save()
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }else{
                print("Bag not Found")
            }
        }
    }
    
    // MARK: Fetch Core Data
    func getOneBagFromCoredata(trackingPoint: String, bagTag: String) -> NSDictionary?{
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@", trackingPoint, bagTag)
        do {
            let result = try appDeletgate.managedObjectContext.fetch(request)
            if result.count != 0{
                let Bag = result[0] as! NSManagedObject
                let keys = Array(Bag.entity.attributesByName.keys)
                let dict = Bag.dictionaryWithValues(forKeys: keys)
                return dict as NSDictionary?
            }else{
                return nil
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            return nil
        }
    }
    
    func getAllBagsFromCoredata() -> NSArray?{
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        do {
            let result = try appDeletgate.managedObjectContext.fetch(request)
            return result as NSArray?
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            return nil
        }
    }
    
    func getSyncFalseLockedFalseFromCoredata() -> NSArray?{
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "synced == %@ AND locked == %@", NSNumber(booleanLiteral: false), NSNumber(booleanLiteral: false))
        do {
            let result = try appDeletgate.managedObjectContext.fetch(request)
            return result as NSArray?
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            return nil
        }
    }
    
    
    func getLockedBagWithSameErrorDisc(error:String) -> NSArray? {
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "errorMsg == %@ AND locked == %@", error, NSNumber(booleanLiteral: true))
        do {
            let result = try appDeletgate.managedObjectContext.fetch(request)
            return result as NSArray?
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            return nil
        }
    }
    
    
    // MARK: Update Core Data
    func updateBagContainerIDInCoredata(trackingPoint: String, bagTag: String, containerID: String){
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@", trackingPoint, bagTag)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            if result.count != 0{
                let updateBag = result[0] as! NSManagedObject
                updateBag.setValue(containerID, forKey: "containerID")
                do {
                    try updateBag.managedObjectContext?.save()
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }else{
                print("Bag not Found")
            }
        }
    }
    
    func updateBagFlightNumInCoredata(trackingPoint: String, bagTag: String, flight_num: String){
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@", trackingPoint, bagTag)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            if result.count != 0{
                let updateBag = result[0] as! NSManagedObject
                updateBag.setValue(flight_num, forKey: "flight_num")
                do {
                    try updateBag.managedObjectContext?.save()
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }else{
                print("Bag not Found")
            }
        }
    }
    
    func updateBagFlightTypeInCoredata(trackingPoint: String, bagTag: String, flight_type: String){
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@", trackingPoint, bagTag)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            if result.count != 0{
                let updateBag = result[0] as! NSManagedObject
                updateBag.setValue(flight_type, forKey: "flight_type")
                do {
                    try updateBag.managedObjectContext?.save()
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }else{
                print("Bag not Found")
            }
        }
    }
    
    func updateBagScanDateTimeInCoredata(trackingPoint: String, bagTag: String, scanDateTime: Date){
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@", trackingPoint, bagTag)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            if result.count != 0{
                let updateBag = result[0] as! NSManagedObject
                updateBag.setValue(scanDateTime, forKey: "scanDateTime")
                do {
                    try updateBag.managedObjectContext?.save()
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }else{
                print("Bag not Found")
            }
        }
    }
    
    func updateBagFlightDateInCoredata(trackingPoint: String, bagTag: String, flight_date: Date){
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@", trackingPoint, bagTag)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            if result.count != 0{
                let updateBag = result[0] as! NSManagedObject
                updateBag.setValue(flight_date, forKey: "flight_date")
                do {
                    try updateBag.managedObjectContext?.save()
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }else{
                print("Bag not Found")
            }
        }
    }
    
    func updateBagSyncedInCoredata(trackingPoint: String, bagTag: String, synced: Bool){
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@", trackingPoint, bagTag)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            if result.count != 0{
                let updateBag = result[0] as! NSManagedObject
                updateBag.setValue(synced, forKey: "synced")
                do {
                    try updateBag.managedObjectContext?.save()
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }else{
                print("Bag not Found")
            }
        }
    }
    
    func updateBagLockedInCoredata(trackingPoint: String, bagTag: String, locked: Bool){
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@", trackingPoint, bagTag)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            if result.count != 0{
                let updateBag = result[0] as! NSManagedObject
                updateBag.setValue(locked, forKey: "locked")
                do {
                    try updateBag.managedObjectContext?.save()
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }else{
                print("Bag not Found")
            }
        }
    }
    
    func updateBagErrorMessageInCoredata(trackingPoint: String, bagTag: String, errorMsg: String){
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@", trackingPoint, bagTag)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            if result.count != 0{
                let updateBag = result[0] as! NSManagedObject
                updateBag.setValue(errorMsg, forKey: "errorMsg")
                do {
                    try updateBag.managedObjectContext?.save()
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }else{
                print("Bag not Found")
            }
        }
    }
    
    // MARK: Delete Core Data
    func deleteOneBagFromCoredata(trackingPoint: String, bagTag: String){
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@", trackingPoint, bagTag)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            for object in result {
                appDeletgate.managedObjectContext.delete(object as! NSManagedObject)
            }
            appDeletgate.saveContext()
        }
    }
    
    func deleteAllBagsFromCoredata(){
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            for object in result {
                appDeletgate.managedObjectContext.delete(object as! NSManagedObject)
            }
            appDeletgate.saveContext()
        }
    }
    
    func deleteScannedItem(trackingPoint: String, bagTag: String, containerID: String) {
        //function "deleteScannedItem" that deletes a selected item from core data then refreshes horizontal scroll.
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@ AND containerID = %@", trackingPoint, bagTag, containerID)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            for object in result {
                appDeletgate.managedObjectContext.delete(object as! NSManagedObject)
            }
            appDeletgate.saveContext()
            appDeletgate.UpdateQueueScrollView(ArrayOfItems:ScanManager.LocalStorage.getAllBagsFromCoredata()!,LastItemScaned:nil)
        }
    }
    
    func deleteSpecificBags(BagsArray:NSArray) {
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        for i in (0 ..< BagsArray.count) {
            let Bag:NSManagedObject = BagsArray[i] as! NSManagedObject
            let trackingPoint = (Bag.value(forKey: "trackingPoint") as! String)
            let bagTag = (Bag.value(forKey: "bagTag") as! String)
            let containerID = (Bag.value(forKey: "containerID") as! String)
            request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@ AND containerID = %@", trackingPoint, bagTag, containerID)
            if let result = try? appDeletgate.managedObjectContext.fetch(request) {
                for object in result {
                    appDeletgate.managedObjectContext.delete(object as! NSManagedObject)
                }
            }
            appDeletgate.saveContext()
        }
        appDeletgate.UpdateQueueScrollView(ArrayOfItems:ScanManager.LocalStorage.getAllBagsFromCoredata()!,LastItemScaned:nil)
    }
    
    func lockScannedItemStatus(trackingPoint: String, bagTag: String, containerID: String, errorMsg:String, isLocked:Bool) {
        //function "lockScannedItemStatus" that updates a scanned item and set sync to false, locked to true, and set the error message.
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@ AND containerID = %@", trackingPoint, bagTag, containerID)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            if result.count != 0{
                let updateBag = result[0] as! NSManagedObject
                updateBag.setValue(false, forKey: "synced")
                updateBag.setValue(isLocked, forKey: "locked")
                updateBag.setValue(errorMsg, forKey: "errorMsg")
                do {
                    try updateBag.managedObjectContext?.save()
                    let myBag=ScanManager().buildBagObjFromScan(bagScanString:bagTag)
                    AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems:ScanManager.LocalStorage.getAllBagsFromCoredata()!,LastItemScaned:myBag)
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }else{
                print("Bag not Found")
            }
        }
    }
    
    func turnSyncTrue(trackingPoint: String, bag: AnyObject, containerID: String) {
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        let bagTag = bag.value(forKey: "bagTag") as! String
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@ AND containerID = %@", trackingPoint, bagTag , containerID)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            if result.count != 0{
                let updateBag = result[0] as! NSManagedObject
                updateBag.setValue(true, forKey: "synced")
                updateBag.setValue(false, forKey: "locked")
                updateBag.setValue("", forKey: "errorMsg")
                do {
                    try updateBag.managedObjectContext?.save()
                    let myBag=ScanManager().buildBagObjFromScan(bagScanString:bagTag)
                    AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems:ScanManager.LocalStorage.getAllBagsFromCoredata()!,LastItemScaned:myBag)
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }else{
                print("Bag not Found")
            }
        }
    } 
    
    func resetScannedItemStatus(trackingPoint: String, bagTag: String, containerID: String){
        //function "resetScannedItemStatus" that updates a scanned item and set sync to false, locked to false, and clears the error message field, also function will call the process queue function.
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "trackingPoint = %@ AND bagTag = %@ AND containerID = %@", trackingPoint, bagTag, containerID)
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            if result.count != 0{
                let updateBag = result[0] as! NSManagedObject
                updateBag.setValue(false, forKey: "synced")
                updateBag.setValue(false, forKey: "locked")
                updateBag.setValue("", forKey: "errorMsg")
                do {
                    try updateBag.managedObjectContext?.save()
                    ScanManager().processScannedItemsQueue()
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }else{
                print("Bag not Found")
            }
        }
    }
    
    func resetSpecificItems(arrayOfBags:NSArray){

        for i in 0..<arrayOfBags.count {
            let bagToReset = arrayOfBags[i] as! NSManagedObject
            bagToReset.setValue(false, forKey: "synced")
            bagToReset.setValue(false, forKey: "locked")
            bagToReset.setValue("", forKey: "errorMsg")
            do {
                try bagToReset.managedObjectContext?.save()
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
        }
        AppDelegate.getDelegate().UpdateQueueScrollView(ArrayOfItems:ScanManager.LocalStorage.getAllBagsFromCoredata()!,LastItemScaned:nil)
        ScanManager().processScannedItemsQueue()
    }

    
    func removeSyncedBags(){
        //function "removeSyncedBags" that removes all bags where sync = TRUE from core data.
        let appDeletgate = (UIApplication.shared.delegate as! AppDelegate)
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Bags")
        request.predicate = NSPredicate(format: "synced  == %@", NSNumber(booleanLiteral: true))
        if let result = try? appDeletgate.managedObjectContext.fetch(request) {
            for object in result {
                appDeletgate.managedObjectContext.delete(object as! NSManagedObject)
            }
            appDeletgate.saveContext()
        }
    }
}
