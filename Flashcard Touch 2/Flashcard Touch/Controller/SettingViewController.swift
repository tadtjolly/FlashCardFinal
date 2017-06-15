//
//  ViewController.swift
//  pushnofitication
//
//  Created by Trung Hieu on 6/13/17.
//  Copyright © 2017 Trung Hieu. All rights reserved.
//

import UIKit
import UserNotifications

final class ViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func vietnameseAction(_ sender: Any) {
        Locale.updateLanguage(code: "vi")
    }
    @IBAction func englishAction(_ sender: Any) {
        Locale.updateLanguage(code: "en")
    }

    @IBAction func action(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "Flashcard"
        content.subtitle = "Thong bao"
        content.body = "San sang de hoc tu cung Flashcard"
        content.badge = 1
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH"
        let hour = Int(timeFormat.string(from: datePicker.date))
        timeFormat.dateFormat = "mm"
        let minute = Int(timeFormat.string(from: datePicker.date))

        var date = DateComponents()
        date.hour = hour
        date.minute = minute
    
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "Study", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            if didAllow {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
