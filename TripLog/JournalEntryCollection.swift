//
//  JournalEntryCollection.swift
//  TripLog
//
//  Created by Tony Jin on 4/25/17.
//  Copyright © 2017 CS466. All rights reserved.
//  
//  A collection of journal entries from core data

import UIKit
import Foundation
import CoreData

class JournalEntryCollection{
    
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
                print("Could not load Core Data: \(err)")
            }
            
            completionClosure()
        }
    }
    
    // Check if trip is already there. If not, create a new one.
    func findTrip(name:String)->Trip?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Trip")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "tripName == %@", name)
        do {
            let matches = try managedObjectContext.fetch(request)
            if matches.count==0 {
                var trip:Trip!
                managedObjectContext.performAndWait {
                    trip = Trip(context: self.managedObjectContext)
                    trip.tripName = name
                }
                return trip
            } else {
                return matches[0] as? Trip
            }
        } catch {
            print("Unable to find trips")
        }
        return nil
    }
    
    // Add a journal entry
    func add (text:NSAttributedString,date:String,location:String,tripName:String,latitude:Double,longitude:Double) -> NSManagedObjectID{
        let trip = findTrip(name: tripName)
        var journalEntry:JournalEntry!
        var journalEntryId:NSManagedObjectID? = nil
        managedObjectContext.performAndWait {
            journalEntry = JournalEntry(context: self.managedObjectContext)
            journalEntry.text = text //not sure why this is the case
            journalEntry.date = date
            journalEntry.location = location
            journalEntry.trip = trip
            journalEntry.latitude = latitude
            journalEntry.longitude = longitude
            self.saveChanges()
            journalEntryId = journalEntry.objectID
        }
        return journalEntryId!
    }
    
    // Update a journal entry
    func update(oldEntry: JournalEntry, text:NSAttributedString, date:String, location: String, tripName: String, latitude:Double, longitude:Double) -> NSManagedObjectID{
        var newEntryId:NSManagedObjectID
        if oldEntry.trip?.tripName != tripName {
            delete(oldEntry)
            newEntryId = add(text:text, date:date, location:location,tripName:tripName,latitude:latitude,longitude: longitude)
        }else{
            oldEntry.text = text
            oldEntry.date = date
            oldEntry.location = location
            oldEntry.latitude = latitude
            oldEntry.longitude = longitude
            newEntryId = oldEntry.objectID
        }
        self.saveChanges()
        return newEntryId
    }
    
    // Delete a journal entry
    func delete(_ entry:JournalEntry) {
        managedObjectContext.delete(entry)
        self.saveChanges()
    }

    // Save changes
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
