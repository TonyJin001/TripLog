//
//  SingleTripViewController.swift
//  TripLog
//
//  Created by Vaasu on 4/26/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

class SingleTripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tripJournalEntriesTable: UITableView!
    
    
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
    
    
    @IBAction func GoBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    let dummyDataText = ["Last week I went to NYC...", "It's Christmas Today!"]
//    let dummyDataDate = ["01/01/17","12/24/16"]
//    let dummyDataTripName = ["New York Trip", "New York Trip"]
//    let dummyDataTripIndex = ["#2","#1"]
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (dummyDataText.count)
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = dummyDataText[indexPath.row]
        return (cell)
    }
//       guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalEntriesTableViewCell", for: indexPath) as? JournalEntriesTableViewCell else {
//            fatalError("Can't get cell of the right kind")
//        }
//        
//        cell.journalEntryTextLabel.text = dummyDataText[indexPath.row]
//        cell.journalEntryDateLabel.text = dummyDataDate[indexPath.row]
//        cell.journalEntryTripNameLabel.text = dummyDataTripName[indexPath.row]
//        cell.journalEntryTripIndexLabel.text = dummyDataTripIndex[indexPath.row]
//        
//        return cell
//    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier ?? ""){
        case "EditTrip":
            
            print("BYE!!")
            
            guard let navController = segue.destination as? UINavigationController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let destination = navController.topViewController as? EditTripViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
        
        case "NewEntryFromTrip":
            
            print("UM!!")
            
            guard let navController = segue.destination as? UINavigationController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let destination = navController.topViewController as? NewJournalViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            
            
        case "Map":
            
            print("HI!!")
            
            guard let navController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination")
            }
            
            guard let destination = navController.topViewController as? MapViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
        
        case "ToEntryOne":
            
            print("HI!!")
            
            
            guard let destination = segue.destination as? JournalDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            destination.hidesBottomBarWhenPushed = true
            
        case "ToEntryTwo":
            
            print("mimi!")
            
            
            guard let destination = segue.destination as? JournalDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            destination.hidesBottomBarWhenPushed = true
            
        default:
            fatalError("Unexpected segue identifier")
        }
    }
}
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

    


