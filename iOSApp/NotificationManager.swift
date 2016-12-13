//
//  NotificationManager.swift
//  GeoNag
//
//  Created by Erin Dieringer on 12/13/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation
import UIKit

class NotificationManager {
    
    //Se up the right privelages for local notificatios
    func setupNotificationSettings() {
        let notificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil)

        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
    
    //Cancels all notificaitons so that new ones can be stored
    func cancelNotifications () {
        let app:UIApplication = UIApplication.sharedApplication()
        for oneEvent in app.scheduledLocalNotifications! {
            let notification = oneEvent as UILocalNotification
            app.cancelLocalNotification(notification)
        }
    }
    
    //creates a new notification 
    func newNotification(name: String) {
            print("new notif")
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            cancelNotifications()
            let locattionnotification = UILocalNotification()
            locattionnotification.category = "locationReminderCategory"
            locattionnotification.alertBody = " \(name) is nearby! Click for more locations"
            locattionnotification.alertAction = "View List"
            UIApplication.sharedApplication().scheduleLocalNotification(locattionnotification)
    }
        
}

