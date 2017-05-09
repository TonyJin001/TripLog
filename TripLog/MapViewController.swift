//
//  MapViewController.swift
//  TripLog
//
//  Created by Vaasu on 4/26/17.
//  Copyright © 2017 CS466. All rights reserved.
//
import MapKit
import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    @IBAction func GoBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let centerLocation = CLLocationCoordinate2DMake(44.0153, 73.1673)
    
        let mapSpan = MKCoordinateSpanMake(0.01, 0.01)
        let mapRegion = MKCoordinateRegionMake(centerLocation, mapSpan)
        
        map.setRegion(mapRegion, animated: true)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = centerLocation
        annotation.title = "Entry 1"
        annotation.subtitle = "12/24/16"
        map.addAnnotation(annotation)
        
        
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func back(_ sender: UIBarButtonItem) {
        if presentingViewController is UINavigationController{
            dismiss(animated: true, completion: nil)
        }else if let owningNavController = navigationController{
            owningNavController.popViewController(animated: true)
        }else{
            fatalError("View is not contained by a navigation controller")
        }
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

