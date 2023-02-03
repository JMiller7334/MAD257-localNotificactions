//
//  ViewController.swift
//  Huli Pizza Notification
//
//  Created by Steven Lipton on 11/23/18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

//ALL COMMENTS BY ME WILL BE IN CAPS FOR THIS PROJECT TO CONTRAST MY
// COMMENTS FROM THE ONES ALREADY HERE.
// MODIFIED BY JACOB MILLER. from --> TUTORIAL FROM LinkedInLearning.
import UIKit
import UserNotifications // IMPORTING OF NOTIFICATIONS IS REQUIRED

// a global constant
let pizzaSteps = ["Make pizza", "Roll Dough", "Add Sauce", "Add Cheese", "Add Ingredients", "Bake", "Done"]


class ViewController: UIViewController {
    var counter = 0
    
    func getNotificationSettings(){
        //HANDLES IF NOTIFICATION SETTINGS ARE NOT ENABLED.
        UNUserNotificationCenter.current().getNotificationSettings { (setttings) in
            let status = setttings.authorizationStatus
            if status == .denied || status == .notDetermined{
                DispatchQueue.main.async (execute: {
                    self.accessDeniedAlert()
                })
                return
            }
            //self.introNotification()
        }
    }
   
    @IBAction func schedulePizza(_ sender: UIButton) {
        self.getNotificationSettings()
        //CALLS MY FUNC FOR MAKING NOTIFICATIONS.
        let content = self.messageNotification(
            msgTitle: "A Scheduled Pizza",
            msgBody: "Time to make a pizza!")
        //STRUCTURE FOR THE NOTIFICATION CALANDER EVENT.
        var dateComponents = Calendar.current.dateComponents([
            .hour, .minute, .second
            ], from: Date())
        
        //SET THE CALANDER EVENT
        dateComponents.second = dateComponents.second! + 15
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: false)
        let identifier = "message.scheduled"
        self.addNotification(trigger: trigger, content: content, identifier: identifier)
        
    }
    
    
    @IBAction func makePizza(_ sender: UIButton) {
        self.getNotificationSettings()
        //CALLS MY FUNC FOR MAKING NOTIFICATIONS.
        let content = self.messageNotification(msgTitle: "A timed pizza step", msgBody: "Making pizza!")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        let identifier = "message.standard"
        self.addNotification(trigger: trigger, content: content, identifier: identifier)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.isNavigationBarHidden = true
    }

    //MARK: - Support Methods
    
    // A function to print errors to the console
    func printError(_ error:Error?,location:String){
        if let error = error{
            print("Error: \(error.localizedDescription) in \(location)")
        }
    }
    
    //THIS SENDS THE NOTIFICATION TO THE USER.
    func addNotification(trigger: UNNotificationTrigger, content: UNNotificationContent, identifier: String){
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) {(error) in self.printError(error, location: "Add request for identifier:" + identifier)}
    }
    
    //MY CUSTOM NOTIFICATION FUNC
    func messageNotification(
        msgTitle: String, msgBody: String) ->
        UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
            content.title = msgTitle
            content.body = msgBody
            content.userInfo = ["step": 0]
        return content
    }
    
    //BELOW: THIS IS HOW A NOTIFICATION IS STRUCTURED. DEFAULT NOTIFICATION W/FIXED TEXT.
    
    //A sample local notification for testing
    func introNotification(){
        // a Quick local notification.
        let time = 15.0
        counter += 1
        //Content
        let notifcationContent = UNMutableNotificationContent()
        notifcationContent.title = "Hello, Pizza!!"
        notifcationContent.body = "Just a message to test permissions \(counter)"
        notifcationContent.badge = counter as NSNumber
        //Trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        
        //Request
        let request = UNNotificationRequest(identifier: "intro", content: notifcationContent, trigger: trigger)
        //Schedule
        UNUserNotificationCenter.current().add(request) { (error) in
            self.printError(error, location: "Add introNotification")
        }
    }
    //An alert to indicate that the user has not granted permission for notification delivery.
    func accessDeniedAlert(){
        // presents an alert when access is denied for notifications on startup. give the user two choices to dismiss the alert and to go to settings to change thier permissions.
        let alert = UIAlertController(title: "Huli Pizza", message: "Huli Pizza needs notifications to work properly, but they are currently turned off. Turn them on in settings.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(okayAction)
        alert.addAction(settingsAction)
        present(alert, animated: true) {
        }
    }
}

