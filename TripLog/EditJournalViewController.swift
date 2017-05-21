//
//  EditJournalViewController.swift
//  TripLog
//
//  Created by Tony Jin on 4/26/17.
//  Copyright © 2017 CS466. All rights reserved.
// This is the file for the edit journal view.
// From this page you can make new journal entries,
// or edit an old one and save your changes
// From this view, you can add new photos in the camera roll
// Or you can go to the camera and take a photo to add it

import UIKit
import CoreData
import GooglePlaces

class EditJournalViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    
    var camera2:UIBarButtonItem!
    var upload2:UIBarButtonItem!
    var toolbar:UIToolbar!
    var placesClient: GMSPlacesClient!
    var locationmgr : CLLocationManager!
    var presetTripName : String?
    
    var latitude: Double?
    var longitude: Double?

    var tripNameTextFieldUsesKeyboard = false
    private var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>!
    
    // Controls whether the view controller is responsible for editing an entry or creating a new one
    var type:EditType = .edit
    
    var journalEntries:JournalEntryCollection? = nil
    var journalEntryDetails:JournalEntry? = nil
    var callback : ((NSAttributedString,String,String,String,Double,Double)->Void)? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initiate location manager and ask for permission
        locationmgr = CLLocationManager()
        locationmgr.requestWhenInUseAuthorization()
        placesClient = GMSPlacesClient.shared()
        

        dateTextField.delegate = self
        locationTextField.delegate = self
        tripNameTextField.delegate = self
        journalTextView.delegate = self
        
        // these tags are for the different input functionality
        // there are different tags for different images retrieval
        //and for date picker, trips picker, and google maps api
        
        cameraButton.tag = 0
        uploadButton.tag = 1
        dateTextField.tag = 2
        tripNameTextField.tag = 3
        locationTextField.tag = 4
        
        let notificationCenter = NotificationCenter.default

        // Adjust the text view so that it's not hidden by keyboard
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self,selector: #selector(adjustForKeyboard),name:Notification.Name.UIKeyboardWillShow, object:nil)
        
        // Creating a toolbar that can be moved when keyboard's shown
        toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        
        // Setup the buttons to be put in the system.
        let camera = UIButton.init(type:.custom)
        camera.setImage(UIImage(named: "Camera-50.png"), for: UIControlState.normal)
        camera.addTarget(self, action: #selector(self.importImage(_:)), for: UIControlEvents.touchUpInside)
        camera.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        camera.tag = 0
        camera2 = UIBarButtonItem(customView: camera)
        
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let upload = UIButton.init(type:.custom)
        upload.setImage(UIImage(named: "Picture-50.png"), for: UIControlState.normal)
        upload.addTarget(self, action: #selector(self.importImage(_:)), for: UIControlEvents.touchUpInside)
        upload.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        upload.tag = 1
        upload2 = UIBarButtonItem(customView: upload)
        toolbar.setItems([camera2,flexSpace,upload2], animated: false)
        
        journalTextView.inputAccessoryView = toolbar
        
        
        // Previous information if it's edit journal
        if self.type != .new {
            if let date = journalEntryDetails?.date {
                dateTextField.text = date
            }
            
            if let location = journalEntryDetails?.location {
                locationTextField.text = location
            }
            
            if let tripName = journalEntryDetails?.trip?.tripName {
                tripNameTextField.text = tripName
            }
            
            if let text:NSAttributedString = journalEntryDetails?.text as? NSAttributedString {
                journalTextView.attributedText = text
            }
            
            if let latitude = journalEntryDetails?.latitude {
                self.latitude = latitude
            }
            
            if let longitude = journalEntryDetails?.longitude {
                self.longitude = longitude
            }

        }
        
        
        // Automatically set the time if this is a new entry
        if self.type == .new {
            let currentDateTime = Date() //Calendar code from stackoverflow
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            dateTextField.text = formatter.string(from: currentDateTime)
            
            journalTextView.text = "Write something..."
            journalTextView.textColor = UIColor.lightGray
            
            // Automatically set the current place
            placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
                if let error = error {
                    print("Pick Place error: \(error.localizedDescription)")
                    return
                }
                
                if let placeLikelihoodList = placeLikelihoodList {
                    self.locationTextField.text = placeLikelihoodList.likelihoods[0].place.name
                    self.latitude = placeLikelihoodList.likelihoods[0].place.coordinate.latitude
                    self.longitude = placeLikelihoodList.likelihoods[0].place.coordinate.longitude
                }
            })
            
            if self.presetTripName != nil {
                tripNameTextField.text = self.presetTripName
            }

        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Handles image import
    @IBAction func importImage(_ sender: UIBarButtonItem) {
        
        let image = UIImagePickerController()
        image.delegate = self
        
        // Decide whether the user wants to take a photo or select it from the photo library
        switch sender.tag{
        case 0: //camera
            image.sourceType = UIImagePickerControllerSourceType.camera
        case 1: //image library
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        default:
            print("Source type for image picker unknown")
        }
        
        image.allowsEditing = false
        
        self.present(image, animated: true) {
            // After it's completed
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as?UIImage {
            
            let attachment = NSTextAttachment()
            attachment.image = image
            
            // Scale the image
            let oldWidth = attachment.image!.size.width
            let scaleFactor = oldWidth/(journalTextView.frame.size.width)
            attachment.image = UIImage(cgImage: attachment.image!.cgImage!, scale: scaleFactor, orientation:.up)
            
            //put your NSTextAttachment into and attributedString
            let attString = NSAttributedString(attachment: attachment)
            
            if journalTextView.textColor == UIColor.lightGray {
                journalTextView.text = ""
                journalTextView.textColor = UIColor.black
            }
            
            //add this attributed string to the current position.
            journalTextView.text = journalTextView.text + "\n"
            journalTextView.text = journalTextView.text + "\n"
            journalTextView.textStorage.insert(attString, at: journalTextView.selectedRange.location)
            
            journalTextView.font = UIFont(name: "Avenir", size: 20.0)
            
        } else {
            // Error
            journalTextView.text = "Didn't get the image"
        }
        self.dismiss(animated: true, completion: nil)
    }

    // When return is pressed in the textfield, hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Adjust textfield position so that it's not hidden by keyboard
    func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
       
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            journalTextView.contentInset = UIEdgeInsets.zero
            
        } else {
            journalTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        journalTextView.scrollIndicatorInsets = journalTextView.contentInset
        
        let selectedRange = journalTextView.selectedRange
        journalTextView.scrollRangeToVisible(selectedRange)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // If inputing date, use a date picker
        if textField.tag == 2 {
            let inputView = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:240))
            
            
            let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRect(x:0, y:40, width:0, height:0))
            datePickerView.datePickerMode = UIDatePickerMode.date
            inputView.addSubview(datePickerView) // add date picker to UIView
            
            var center:CGPoint = datePickerView.center
            center.x = inputView.center.x
            datePickerView.center = center
            
            // Add a done button that will dismiss the date picker
            let doneButton = UIButton(frame: CGRect(x:(self.view.frame.size.width/2) - (100/2), y:0, width:100, height:50))
            doneButton.setTitle("Done", for: UIControlState.normal)
            doneButton.setTitle("Done", for: UIControlState.highlighted)
            doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
            
            inputView.addSubview(doneButton) // add Button to UIView
            
            doneButton.addTarget(self, action: #selector(doneButton(_:)), for: UIControlEvents.touchUpInside) // set button click event
            
            textField.inputView = inputView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControlEvents.valueChanged)
            
            handleDatePicker(datePickerView) // Set the date on start.
        }
        
        // Use a picker view if it's selecting a trip name & if not creating a new trip
        if textField.tag == 3 && !tripNameTextFieldUsesKeyboard{
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Trip")
            
            // sort by author anme and then by title
            let nameSort = NSSortDescriptor(key: "tripName", ascending: true)
            request.sortDescriptors = [nameSort]
            
            // Create the controller using our moc
            let moc = journalEntries?.managedObjectContext

            fetchedResultsController  = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc!, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchedResultsController.delegate = self
            do {
                try fetchedResultsController.performFetch()
            }catch{
                print("Failed to fetch data")
            }

            let inputView = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:240))
            let inputPickerView:UIPickerView = UIPickerView()
            inputPickerView.dataSource = self
            inputPickerView.delegate = self
            inputView.addSubview(inputPickerView)
            
            var center:CGPoint = inputPickerView.center
            center.x = inputView.center.x
            inputPickerView.center = center
            
            let doneButton = UIButton(frame: CGRect(x:(self.view.frame.size.width/2) - (100/2), y:0, width:100, height:50))
            doneButton.setTitle("Done", for: UIControlState.normal)
            doneButton.setTitle("Done", for: UIControlState.highlighted)
            doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
            
            inputView.addSubview(doneButton) // add Button to UIView
            
            doneButton.addTarget(self, action: #selector(doneButton(_:)), for: UIControlEvents.touchUpInside) // set button click event

            textField.inputView = inputView
        }
        
        // When inputing location, use google map's API
        if textField.tag == 4 {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Set the first title in pickerview as Create a new trip
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Create a new trip..."
        }
        let indexPath = NSIndexPath(row: row - 1, section: 0)
        let tempTrip:Trip = (fetchedResultsController.object(at: indexPath as IndexPath) as? Trip)!
        return tempTrip.tripName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // If user decides to create a new trip, dismiss pickerview and use keyboard
        if row == 0 {
            tripNameTextFieldUsesKeyboard = true
            tripNameTextField.text = ""
            tripNameTextField.resignFirstResponder()
            tripNameTextField.inputView = nil
            tripNameTextField.becomeFirstResponder()
        } else {
            let indexPath = NSIndexPath(row: row-1, section: 0)
            let tempTrip:Trip = (fetchedResultsController.object(at: indexPath as IndexPath) as? Trip)!
            tripNameTextField.text = tempTrip.tripName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (fetchedResultsController.fetchedObjects?.count)! + 1
    }
    
    
    // Create place holder for text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty && textView.attributedText != nil{
            textView.text = "Write something..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    
    func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func doneButton(_ sender:UIButton)
    {
        dateTextField.resignFirstResponder() // To resign the inputView on clicking done.
        tripNameTextField.resignFirstResponder()
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            print("The save button was not pressed")
            return
        }

        if journalTextView.textColor == UIColor.lightGray {
            journalTextView.text = ""
        }
        let text = journalTextView.attributedText ?? nil
        let date = dateTextField.text ?? ""
        let location = locationTextField.text ?? ""
        let tripName = tripNameTextField.text ?? ""
        
        if callback != nil{
            callback!(text!, date, location,tripName,latitude ?? 0,longitude ?? 0)
        }
    }

}

enum EditType {
    case new
    case edit
}

// Google Map's API
extension EditJournalViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.locationTextField.text = place.name
        self.latitude = place.coordinate.latitude
        self.longitude = place.coordinate.longitude
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
