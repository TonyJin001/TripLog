//
//  GoogleMapViewController.swift
//  TripLog
//
//  Created by Lyra Ding on 5/9/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces

//This is file for the map, implemented with google maps.  

class GoogleMapViewController: UIViewController, GMSMapViewDelegate{

    var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>!
    var locationManager = CLLocationManager()
    var currentLocation: GMSPlace?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var idToJournalEntry = [String : JournalEntry]()
    var markerToId = [GMSMarker:String]()
    var idToMarker = [String:GMSMarker]()
    var selectedJournalEntry:JournalEntry?
    var journalEntries:JournalEntryCollection?
    
    var zoomLevel: Float = 15.0
    var centerLatitude:Double?
    var centerLongitude:Double?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.toolbar.isHidden = true
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        
        // hardcoded section
        let totalNumberOfObjects = self.fetchedResultsController!.sections?[0].numberOfObjects
        
        
        if totalNumberOfObjects == 0 {
            centerLatitude = 0
            centerLongitude = 0
        }
        
        // Set the center longitude and latitude
        let indexPath = IndexPath(row: 0, section: 0)
        guard let journalEntry = self.fetchedResultsController.object(at: indexPath) as? JournalEntry else {
            fatalError("Cannot find entry")
        }
        centerLatitude = journalEntry.latitude
        centerLongitude = journalEntry.longitude
        
        // Create the map view and add snippets
        let camera = GMSCameraPosition.camera(withLatitude: centerLatitude!, longitude: centerLongitude!, zoom: 12)
        self.mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        self.mapView.delegate = self
        self.mapView.settings.myLocationButton = true
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mapView.isMyLocationEnabled = true
        
        
        
        
        
        
        
        for i in 0..<totalNumberOfObjects! {
            
            print(String(i)+"!!!!!!!!!!!!!!!!!!")
            
            let indexPath = IndexPath(row: i, section: 0)
            guard let journalEntry = self.fetchedResultsController.object(at: indexPath) as? JournalEntry else {
                fatalError("Cannot find entry")
            }
            
            let objectID:String = String(describing: journalEntry.objectID)
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: journalEntry.latitude, longitude: journalEntry.longitude)
            marker.title = journalEntry.trip?.tripName
            marker.snippet = (journalEntry.text as! NSAttributedString).string
            marker.map = self.mapView
            
            markerToId[marker] = objectID
            idToMarker[objectID] = marker
            
            idToJournalEntry[objectID] = journalEntry
            
        }
        
        
        
        // Add the map to the view, hide it until we've got a location update.
        self.view.addSubview(self.mapView)
        //        mapView.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        selectedJournalEntry = idToJournalEntry[markerToId[marker]!]!
        performSegue(withIdentifier: "ViewJournalDetails", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ViewJournalDetails" {
            guard let destination = segue.destination as? JournalDetailViewController else {
                fatalError("Cannot find JournalDetailViewController")
            }
            if (selectedJournalEntry != nil) {
                destination.journalEntryDetails = selectedJournalEntry
            } else {
                fatalError("selectedJournalEntry is nil")
            }
            destination.journalEntries = self.journalEntries
            
        }
        
    }
    
 

}

extension GoogleMapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
//        if mapView.isHidden {
//            mapView.isHidden = false
//            mapView.camera = camera
//        } else {
//            mapView.animate(to: camera)
//        }

    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

