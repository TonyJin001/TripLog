//
//  TripCollection.swift
//  TripLog
//
//  Created by Lyra Ding on 5/7/17.
//  Copyright © 2017 CS466. All rights reserved.
//
//  A collection of trips from core data

import UIKit
import Foundation
import CoreData

class TripCollection{
    
    var managedObjectContext: NSManagedObjectContext // our in-memory data store and portal to the database
    var persistentContainer: NSPersistentContainer // our database connection
    
    
    /* Initializes our collection by connecting to the database.
     
     The closure is called when the connection has been established.
     */
    
    init(completionClosure: @escaping ()->()){
        
        persistentContainer = NSPersistentContainer(name:"JournalEntryModel")
        managedObjectContext = persistentContainer.viewContext
        
        persistentContainer.loadPersistentStores(){ (description, err) in
            if let err = err{
                // should try harder to make the connection and not just dump the user
                print("Could not load Core Data: \(err)")
            }
            
            completionClosure()
        }
    }
    
    // Add a new trip
    func add (tripName:String,startDate:String,endDate:String) {
        var trip:Trip!
        managedObjectContext.performAndWait {
            trip = Trip(context: self.managedObjectContext)
            trip.tripName = tripName
            trip.startDate = startDate
            trip.endDate = endDate
            self.saveChanges()
        }
    }
    
    // Update an old trip
    func update(oldTrip: Trip, tripName:String, startDate:String,endDate:String){
        oldTrip.tripName = tripName
        oldTrip.startDate = startDate
        oldTrip.endDate = endDate
        self.saveChanges()
    }
    
    // Delete a trip
    func delete(_ trip:Trip) {
        managedObjectContext.delete(trip)
        self.saveChanges()
    }
    
    
    func saveChanges() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // print() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
}

