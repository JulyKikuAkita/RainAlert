//
//  ViewController.swift
//  RainAlert
//
//  Created by July on 1/14/19.
//  Copyright © 2019 July. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    private let apiManager = APIManager()
    var desc: String = "Parsing Erroor"
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var setDefaultLabelText: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.getObserveOneJsonTopLevel() { (observeOneJsonTopLevel, error) in
            guard let topJson = observeOneJsonTopLevel else { return }
            self.desc = topJson.observations.location[0].observation[0].description
        }
        //Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
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
    
    //MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        // completion is async call
        // need to wait it return to print data
        //let desc = getWeatherDescription()
        zipcodeLabel.text = "Retrieving: \(self.desc)"
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
