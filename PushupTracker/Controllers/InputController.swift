//
//  InputController.swift
//  PushupTracker
//
//  Created by Harrison, Kyle on 10/3/19.
//  Copyright © 2019 Harrison, Kyle. All rights reserved.
//

import UIKit

class InputController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    //MARK: - Constants
    
    private enum Settings: String {
        
        case numberOfPushups, dateOfPushups
        
    }
    
    //MARK: - Outlets
    @IBOutlet weak var Quantity: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var Submit: UIButton!
    @IBOutlet weak var Confirm: UILabel!
    @IBOutlet weak var Summary: UILabel!
    
    //MARK: - Properties
    var pushupNums: [Int] = []
    var pushupDates: [Date] = []

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    
//    MARK: - View Controller Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Quantity.keyboardType = .numberPad
        restoreDefaults()
        Summary.text = """
        Since starting the program, you have completed \(pushupNums.reduce(0,+)) pushups.
        """
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
    }
    

     
    

//    MARK: - Helpers
    
    @IBAction func submitPushups(_ sender: UIButton) {
        let num = Quantity.text!
        var plural: String
        if isValid(num) {
            if num == "1" {
                plural = " has"
            }
            else {
                plural = "s have"
            }
                saveSettings()
                Confirm.text = "Your \(String(describing: num)) pushup\(plural) been recorded."
                Quantity.text = ""
                datePicker.setDate(NSDate() as Date, animated: true)
        }
        else {
            
            Confirm.text = "Please submit a valid number of pushups"
        }
    }
    
    
    func saveSettings() {
        
        restoreDefaults()
        let defaults = UserDefaults.standard
        pushupNums.append(Int(Quantity.text!)!)
        pushupDates.append(datePicker!.date)
        defaults.set(pushupNums, forKey: Settings.numberOfPushups.rawValue)
        defaults.set(pushupDates, forKey: Settings.dateOfPushups.rawValue)
        
        }
    
    func restoreDefaults() {
        let defaults = UserDefaults.standard
        
        if let pushupArray = defaults.array(forKey: Settings.numberOfPushups.rawValue ) as? [Int] {
            if let dateArray =  defaults.array(forKey: Settings.dateOfPushups.rawValue) as? [Date] {
                    pushupNums = pushupArray
                    pushupDates = dateArray
                }
            }
    }
    
    
    func dateDiff(between firstDate: Date, and secondDate: Date) -> Int {
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        if components.day != 0 {
        return components.day ?? 1
        } else { return 1 }
    }
    
    func isValid(_ number: String) -> Bool {
        if number == ""  || !number.isNumber{
            return false
        } else {
            return true
        }
    }


}
//MARK: - Extension

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
