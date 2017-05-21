//
//  NewTripViewController.swift
//  TripLog
//
//  Created by Vaasu on 4/25/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

//This is the file for creating a new trip 
// and editing an old trip

class NewTripViewController: UIViewController {
    
    var type: TripType = .new
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var callback: ((String, String, String)->Void)?

    @IBOutlet weak var tripnamefield: UITextField!
    
    @IBOutlet weak var startdatefield: UITextField!
    @IBOutlet weak var enddatefield: UITextField!
    
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startdatefield.tag = 0
        enddatefield.tag = 1
        
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "MM/dd/yyyy"
        
        startdatefield.text = formatter.string(from: Date())
        navigationBar.title = "New Trip"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 || textField.tag == 1{
            let inputView = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:240))
            
            
            let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRect(x:0, y:40, width:0, height:0))
            datePickerView.datePickerMode = UIDatePickerMode.date
            inputView.addSubview(datePickerView) // add date picker to UIView
            
            var center:CGPoint = datePickerView.center
            center.x = inputView.center.x
            datePickerView.center = center
            
            
            let doneButton = UIButton(frame: CGRect(x:(self.view.frame.size.width/2) - (100/2), y:0, width:100, height:50))
            doneButton.setTitle("Done", for: UIControlState.normal)
            doneButton.setTitle("Done", for: UIControlState.highlighted)
            doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
            
            inputView.addSubview(doneButton) // add Button to UIView
            
            doneButton.addTarget(self, action: #selector(doneButton(_:)), for: UIControlEvents.touchUpInside) // set button click event
            
            if textField.tag == 0 {
            
                textField.inputView = inputView
                datePickerView.addTarget(self, action: #selector(handleStartDatePicker(_:)), for: UIControlEvents.valueChanged)
            
                handleStartDatePicker(datePickerView) // Set the date on start.
            }
            
            if textField.tag == 1{
                print(textField.tag)

                textField.inputView = inputView
                datePickerView.addTarget(self, action: #selector(handleEndDatePicker(_:)), for: UIControlEvents.valueChanged)
                
                handleEndDatePicker(datePickerView) // Set the date on start.
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func handleStartDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        startdatefield.text = dateFormatter.string(from: sender.date)
    }
    
    
    func handleEndDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        enddatefield.text = dateFormatter.string(from: sender.date)
    }
    
    func doneButton(_ sender:UIButton)
    {
        startdatefield.resignFirstResponder() // To resign the inputView on clicking done.
        enddatefield.resignFirstResponder()
    }

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if presentingViewController is UINavigationController{
            dismiss(animated: true, completion: nil)
        }else if let owningNavController = navigationController{
            owningNavController.popViewController(animated: true)
        }else{
            fatalError("View is not contained by a navigation controller")
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            print("The save button was not pressed")
            return
        }
        let tripName = tripnamefield.text ?? "Unnamed Trip"
        let startDate = startdatefield.text ?? ""
        let endDate = enddatefield.text ?? ""
        
        if callback != nil{
            callback!(tripName, startDate, endDate)
        }
    }
}

enum TripType{
    case new
    case update(String, String, String)
}
