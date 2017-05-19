//
//  ModalViewController.swift
//  TripLog
//
//  Created by Vaasu on 5/11/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

// This is the view controller for the modal that pops up
// the first time you open up the app. It gives a simple
// description on a series of 'pages' about the app.

class ModalViewController: UIViewController {
    
    let textpages = ["TripLog is an app where you can create and view Journal Entries for your Trips.", "You can start by creating a New Trip, and then creating a journal entry for that trip.", "Thanks for reading!"]
    
    var page = 0
    
    @IBOutlet weak var modaltext: UILabel!
    
    @IBOutlet weak var previousbutton: UIButton!
    @IBOutlet weak var nextbutton: UIButton!
    @IBAction func next(_ sender: Any) {
        if (page == textpages.count - 2){
            page += 1
            previousbutton.alpha = 1.0
            nextbutton.alpha = 0.5
            modaltext.text = textpages[page]
        }
        if (page < textpages.count - 2){
            page += 1
            nextbutton.alpha = 1.0
            modaltext.text = textpages[page]
        }
        print(page)
        
    }
    
    
    @IBAction func previous(_ sender: Any) {
        if (page == 1){
            page -= 1
            nextbutton.alpha = 1.0
            previousbutton.alpha = 0.5
            modaltext.text = textpages[page]
        }
        if (page > 1){
            page -= 1
            previousbutton.alpha = 1.0
            modaltext.text = textpages[page]
        }
        print(page)
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        modaltext.text = textpages[0]
        // Do any additional setup after loading the view.
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
