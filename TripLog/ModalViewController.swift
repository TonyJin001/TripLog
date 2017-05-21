//
//  ModalViewController.swift
//  TripLog
//
//  Created by Vaasu on 5/11/17.
//  Copyright © 2017 CS466. All rights reserved.
//
// This is the view controller for the modal that pops up
// the first time you open up the app. It gives a simple
// description on a series of 'pages' about the app.

import UIKit


class ModalViewController: UIViewController {
    
    let textpages = ["In TripLog, you can write journal entries when you are travelling, and these journal entries will be automatically grouped by trips.", "The \"Journal Entries\" tab shows you all the journal entries you have. Click on the \"Trips\" tab to view the entries organized by trips.", "Enjoy your trips and the app!"]
    
    var page = 0
    
    @IBOutlet weak var modaltext: UILabel!
    
    @IBOutlet weak var previousbutton: UIButton!
    @IBOutlet weak var nextbutton: UIButton!
    
    @IBAction func next(_ sender: Any) {
        if (page == textpages.count - 2){ //second to last page
            page += 1
            previousbutton.alpha = 1.0
            nextbutton.alpha = 0.5
            modaltext.text = textpages[page]
        }
        if (page < textpages.count - 2){ //before second to last page
            page += 1
            previousbutton.alpha = 1.0
            nextbutton.alpha = 1.0
            modaltext.text = textpages[page]
        }
        
    }
    
    
    @IBAction func previous(_ sender: Any) {
        if (page == 1){ //second page
            page -= 1
            nextbutton.alpha = 1.0
            previousbutton.alpha = 0.5
            modaltext.text = textpages[page]
        }
        if (page > 1){ //after second page
            page -= 1
            nextbutton.alpha = 1.0
            previousbutton.alpha = 1.0
            modaltext.text = textpages[page]
        }
        
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
    

}
