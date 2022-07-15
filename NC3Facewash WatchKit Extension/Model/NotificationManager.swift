//
//  NotificationManager.swift
//  NC3Facewash WatchKit Extension
//
//  Created by Local Administrator on 15/07/22.
//
//


import Foundation
import SwiftUI
import UserNotifications

@MainActor
class LocalNotificationManagerMorning: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var isGranted = false
    @Published var pendingRequests : [UNNotificationRequest] = []
    
    override init(){
        super.init()
        notificationCenter.delegate = self
    }
    
    //Delegate Function
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await getPendingRequests()
        return[.sound, .banner]
    }
    
    func requestAuthorization () async throws{
        try await notificationCenter
            .requestAuthorization(options: [.sound, .badge, .alert])
        await getCurrentSettings()
        
    }
    
    func getCurrentSettings() async{
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
//        print(isGranted)
    }
    
//    func openSettings() {
//        if let url = URL(string: UIApplication.openSettingsURLString){
//            if UIApplication.shared.canOpenURL(url){
//                Task{
//                    await  UIApplication.shared.open(url)
//                }
//            }
//        }
//    }
    
    func schedule(localNotificationMorning: LocalNotificationMorning) async {
        let content = UNMutableNotificationContent()
        content.title = localNotificationMorning.title
        content.body = localNotificationMorning.body
        content.sound = .default
        
        if localNotificationMorning.ScheduleType == .time{
        guard let timeInterval = localNotificationMorning.timeInterval else {return}
        
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: localNotificationMorning.repeats)
            let request = UNNotificationRequest(identifier: localNotificationMorning.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        } else{
            guard let dateComponents = localNotificationMorning.dateComponents else { return }
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: localNotificationMorning.repeats)
            let request = UNNotificationRequest(identifier: localNotificationMorning
                .identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        }
        await getPendingRequests()
        
    }
    
    func getPendingRequests() async{
        pendingRequests = await notificationCenter.pendingNotificationRequests()
        print("Pending: \(pendingRequests.count)")
    }
    
    func removeRequest(withIdentifier identifier: String){
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        if let index = pendingRequests.firstIndex(where: {$0.identifier == identifier}){
            pendingRequests.remove(at:index)
            print("Pending: \(pendingRequests.count)")
        }
    }
}



struct LocalNotificationMorning{
    internal init (identifier: String,
                   title: String,
                   body: String,
                   timeInterval: Double,
                   repeats: Bool){
        self.identifier = identifier
        self.ScheduleType = .time
        self.title = title
        self.body = body
        self.timeInterval = timeInterval
        self.dateComponents = nil
        self.repeats = repeats
    }
    internal init (identifier: String,
                   title: String,
                   body: String,
                   dateComponents: DateComponents,
                   repeats: Bool){
        self.identifier = identifier
        self.ScheduleType = .calendar
        self.title = title
        self.body = body
        self.timeInterval = nil
        self.dateComponents = dateComponents
        self.repeats = repeats
            }
    enum ScheduleType{
        case time,calendar
    }
    
    
    var identifier: String
    var ScheduleType: ScheduleType
    var title: String
    var body: String
    var timeInterval: Double?
    var dateComponents: DateComponents?
    var repeats: Bool
}

