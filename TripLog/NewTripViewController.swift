//
//  NewTripViewController.swift
//  TripLog
//
//  Created by Vaasu on 4/25/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

class NewTripViewController: UIViewController {

    @IBOutlet weak var tripnamefield: UITextField!

    @IBOutlet weak var startdatefield: UITextField!
    @IBOutlet weak var enddatefield: UITextField!
    override func viewDidLoad() {
        let currentDateTime = Date() //Calendar code from stackoverflow
        
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        
        startdatefield.text = formatter.string(from: currentDateTime)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnDismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }

    
    @IBAction func saveAndDismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
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

}
