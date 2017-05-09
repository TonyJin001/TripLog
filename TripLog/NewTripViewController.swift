//
//  NewTripViewController.swift
//  TripLog
//
//  Created by Vaasu on 4/25/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

class NewTripViewController: UIViewController {
    
    var type: TripType = .new
    
    var callback: ((String, String, String)->Void)?

    @IBOutlet weak var tripnamefield: UITextField!

    
    @IBOutlet weak var startdatefield: UITextField!
    @IBOutlet weak var enddatefield: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
   
    
    override func viewDidLoad() {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        
       
        super.viewDidLoad()

        switch(type){
        case .new:
            break
        case let .update(tripName, startDate, endDate):
            
            tripnamefield.text = tripName
            startdatefield.text = startDate
            enddatefield.text = endDate
        }
        
        
        // Do any additional setup after loading the view.
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
        print ("Cookie Cake")
        let tripName = tripnamefield.text ?? ""
        let startDate = startdatefield.text ?? ""
        let endDate = enddatefield.text ?? ""
        
        if callback != nil{
            print ("IceCream Cake")
            callback!(tripName, startDate, endDate)
        }
    }



}

enum TripType{
    case new
    case update(String, String, String)
}
