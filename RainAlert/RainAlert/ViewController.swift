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
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var setDefaultLabelText: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        zipcodeLabel.text = "Default"
        getWeather()
    }
}

extension ViewController {
    
    private func getWeather() {
        apiManager.getObservations() { (observations, error) in
            if let error = error {
                print("Get weather observations error: \(error.localizedDescription)")
                return
            }
            guard let observations = observations else { return }
            print("Current Weather Object:")
            print(observations)
        }
    }
    
}
