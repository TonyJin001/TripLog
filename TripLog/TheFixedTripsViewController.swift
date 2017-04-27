//
//  TheFixedTripsViewController.swift
//  TripLog
//
//  Created by Vaasu on 4/26/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

class TheFixedTripsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     let dummyDataText = ["Trip to NYC"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (dummyDataText.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = dummyDataText[indexPath.row]
        return (cell)
    }


    
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch(segue.identifier ?? ""){
        case "NewTrip":
            
            print("BYE!!")
            
            guard let navController = segue.destination as? UINavigationController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let destination = navController.topViewController as? NewTripViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            
        case "SingleTrip":
            
            print("HI!!")
    
            guard let navController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination")
            }
        
            guard let destination = navController.topViewController as? SingleTripViewController else{
            fatalError("Unexpected destination: \(segue.destination)")
            }
            
        default:
            fatalError("Unexpected segue identifier")
        }
    }
}
            
//            guard let cell = sender as? TripTableViewCell else {
//                fatalError("Unexpected sender: \(sender)")
//            }
//            
//            guard let indexPath = journalEntriesTableView.indexPath(for:cell) else {
//                fatalError("The Selected cell can't be found")
//            }
//            
//            guard let journalEntry = fetchedResultsController?.object(at:indexPath) as? JournalEntry else {
//                fatalError("fetched object was not a JournalEntry")
//            }
//            
//            destination.journalEntryDetails = journalEntry
//            destination.journalEntries = journalEntries
//            destination.hidesBottomBarWhenPushed = true
//            
//            
//        default:
//            fatalError("Unexpeced segue identifier: \(segue.identifier)")
//        }
        


        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.





