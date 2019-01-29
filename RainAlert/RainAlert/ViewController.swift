//
//  ViewController.swift
//  RainAlert
//
//  Created by July on 1/14/19.
//  Copyright © 2019 July. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITextFieldDelegate, UNUserNotificationCenterDelegate {
    private let apiManager = APIManager()
    var desc: String = "Parsing Erroor"
    var zipArray: [Int]!
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var setDefaultLabelText: UIButton!
    @IBOutlet weak var validateZipcode: UIButton!
    @IBOutlet weak var createLocalPush: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.getObserveOneJsonTopLevel() { (observeOneJsonTopLevel, error) in
            guard let topJson = observeOneJsonTopLevel else { return }
            self.desc = topJson.observations.location[0].observation[0].description
        }
        
        //requesting for authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        
        //Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        //check Zipcode
        ZipCodeStore.readJson { (zipcodes) in
            self.zipArray = zipcodes
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        zipcodeLabel.text = "Query Zipcode: \(textField.text ?? "-1")"
    }
    
    //MARK: Zipcode Label Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        // completion is async call
        // need to wait it return to print data
        //let desc = getWeatherDescription()
        zipcodeLabel.text = "Weather: \(self.desc)"
    }
    
    //MARK: Validate Zipcode
    @IBAction func validateZipcodeFormat(_ sender: UIButton) {
        if let textFieldZip = nameTextField.text {
            if let enteredZip = Int(textFieldZip) {
                if !isValid(enteredZip) {
                    zipcodeLabel.text = "\(enteredZip) is not a valid zipcode!"
                } else {
                    apiManager.setHereAPIREquestURL(zipcode: enteredZip)
                    getWeatherDescription()
                }
            }
        }
    }
    
    func isValid(_ zipCode: Int) -> Bool {
        return zipArray.contains(zipCode)
    }
    
    //MARK: create local push //TODO
    //https://www.hackingwithswift.com/read/21/2/scheduling-notifications-unusernotificationcenter-and-unnotificationrequest
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    //TODO: current trigger local push every 5 sec
    // Need to set date trigger
    @IBAction func setLocalPush(_ sender: UIButton) {
        //creating the notification content
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = "Rain Alert"
        content.body = "Weather is \(self.desc), please bring rain cloth"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default()
        content.badge = 1

        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 42
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //getting the notification trigger
        //it will be called after 5 seconds
        //below test only
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
     }
}

extension ViewController {
    // TODO: return ObserveOneJsonTopLevel from closure
    // TODO: handle async Request-Response with completion handler.
    private func getWeatherDescription() -> String {
            apiManager.getObserveOneJsonTopLevel() { (observeOneJsonTopLevel, error) in
            if let error = error {
                print("Get weather observations error: \(error.localizedDescription)")
                return
            }
            guard let topJson = observeOneJsonTopLevel else { return }
            print("Current Weather Object:")
            print(topJson.observations.location[0].observation[0].description)
            self.desc = topJson.observations.location[0].observation[0].description
        }
        return self.desc
    }
}
