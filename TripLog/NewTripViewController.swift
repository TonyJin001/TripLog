//
//  NewTripViewController.swift
//  TripLog
//
//  Created by Vaasu on 4/25/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

//This is the file for creating a new trip
//After creating a new trip, it will segue 
//back to the trips table view




class NewTripViewController: UIViewController {
    
    var type: TripType = .new
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var callback: ((String, String, String)->Void)?

    @IBOutlet weak var tripnamefield: UITextField!
    
    @IBOutlet weak var startdatefield: UITextField!
    @IBOutlet weak var enddatefield: UITextField!
    
    var alertCount: Int = 0 //this is so that the date alert does not get annoying
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertCount = 0
        
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
            
                handleStartDatePicker(datePickerView) // Set the start date
            }
            
            if textField.tag == 1{
                textField.inputView = inputView
                datePickerView.addTarget(self, action: #selector(handleEndDatePicker(_:)), for: UIControlEvents.valueChanged)
                
                handleEndDatePicker(datePickerView) // Set the end date.
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
        
        if (enddatefield.text != ""){ //enddate filled in
            let enddate = dateFormatter.date(from: enddatefield.text!)
            
            //print((enddate?.timeIntervalSince1970)!)
            //print(sender.date.timeIntervalSince1970)
            
            if ((enddate?.timeIntervalSince1970)! >= sender.date.timeIntervalSince1970){ //start date is before enddate
                
                startdatefield.text = dateFormatter.string(from: sender.date)
            }
            
            else{ //startdate is set to enddate since it can't be later
                //we don't have an alert here because we thought 
                //too many would be annoying
                // this is less likely to occur, and still 
                //will prevent impossible values so the absence of an alert
                // seemed justified
                startdatefield.text = enddatefield.text
                
            }
            
        }
            
        else{ //enddate not filled in
            startdatefield.text = dateFormatter.string(from: sender.date)
        }
        
    }
    
    
    func handleEndDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let startdate = dateFormatter.date(from: startdatefield.text!)
        
        if ((startdate?.timeIntervalSince1970)! <= sender.date.timeIntervalSince1970){ //enddate is after start date
            
            enddatefield.text = dateFormatter.string(from: sender.date)
        }
        
        else{ //enddate gets startdate since it can't be before startdate
            if (alertCount == 0){
                let dateAlert = UIAlertController(title: "Time Traveling?",
                                              message: "The End Date Can't be Before the Start Date!", preferredStyle: UIAlertControllerStyle.alert);
            
                let failAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {(Action) in
                //                print("alert");
                }
            
                dateAlert.addAction(failAction)
            
                self.present(dateAlert, animated: true, completion: nil);
                alertCount = 1
                enddatefield.text = startdatefield.text
            }
        }

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
    

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            //print("The save button was not pressed")
            return
        }
        
        
        if (tripnamefield.text != ""){ //if no trippname is entered, trip is not saved
        
            let tripName = tripnamefield.text ?? "Unnamed Trip"
        
        
            let startDate = startdatefield.text ?? ""
            let endDate = enddatefield.text ?? ""
        
            if callback != nil{
                callback!(tripName, startDate, endDate)
            }
        }
        
        
        
        else{ //alert for no trip name
            let saveAlert = UIAlertController(title: "Hold It!",
            message: "Please Enter a Name For Your Trip", preferredStyle: UIAlertControllerStyle.alert);
            
            let failAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {(Action) in
//                print("alert");
            }
            
            saveAlert.addAction(failAction)
            
            self.present(saveAlert, animated: true, completion: nil);
        }
    }
}

enum TripType{
    case new
    case update(String, String, String)
}
