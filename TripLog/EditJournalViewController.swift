//
//  EditJournalViewController.swift
//  TripLog
//
//  Created by Lyra Ding on 4/26/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit
import CoreData

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

    var mockData = ["one", "two", "three"]
    private var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>!
    
    var type:EditType = .edit
    
    var journalEntries:JournalEntryCollection? = nil
    var journalEntryDetails:JournalEntry? = nil
    var callback : ((NSAttributedString,String,String,String)->Void)? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTextField.delegate = self
        locationTextField.delegate = self
        tripNameTextField.delegate = self
        journalTextView.delegate = self
        
        
        cameraButton.tag = 0
        uploadButton.tag = 1
        dateTextField.tag = 2
        tripNameTextField.tag = 3
        
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)

        notificationCenter.addObserver(self,selector: #selector(adjustForKeyboard),name:Notification.Name.UIKeyboardWillShow, object:nil)
        
        
        
        // Create a button bar for the number pad
        toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 35)
        
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
        

        
        if self.type != .new {
            // Do any additional setup after loading the view.
            if let date = journalEntryDetails?.date {
                dateTextField.text = date
            }
            
            if let location = journalEntryDetails?.location {
                locationTextField.text = location
            }
            
            if let tripName = journalEntryDetails?.trip?.tripName {
                tripNameTextField.text = tripName
            }
            
            if let text:NSAttributedString = journalEntryDetails?.text as! NSAttributedString {
                journalTextView.attributedText = text
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
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func importImage(_ sender: UIBarButtonItem) {
        
        let image = UIImagePickerController()
        image.delegate = self
        
        // Decide whether the user wants to take a photo or select it from the photo library
        switch sender.tag{
        case 0:
            image.sourceType = UIImagePickerControllerSourceType.camera
        case 1:
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        default:
            fatalError("Source type for image picker unknown")
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

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func adjustForKeyboard(notification: Notification) {
        
        var keyboardHeight:CGFloat = 0
        
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
       
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            journalTextView.contentInset = UIEdgeInsets.zero
            
        } else {
            journalTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
//            journalTextView.inputAccessoryView = toolbar
        }
        
        journalTextView.scrollIndicatorInsets = journalTextView.contentInset
        
        let selectedRange = journalTextView.selectedRange
        journalTextView.scrollRangeToVisible(selectedRange)
        
    
//        journalTextView.inputAccessoryView = toolbar
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 2 {
            let inputView = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:240))
            
            
            let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRect(x:0, y:40, width:0, height:0))
            datePickerView.datePickerMode = UIDatePickerMode.date
            inputView.addSubview(datePickerView) // add date picker to UIView
            
            var center:CGPoint = datePickerView.center
            center.x = inputView.center.x
            datePickerView.center = center
            
            
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
        
        if textField.tag == 3 {
            
            // get all books
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Trip")
            
            // sort by author anme and then by title
            let nameSort = NSSortDescriptor(key: "tripName", ascending: true)
            request.sortDescriptors = [nameSort]
            
            // Create the controller using our moc
            let moc = journalEntries?.managedObjectContext

            fetchedResultsController  = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc!, sectionNameKeyPath: nil, cacheName: nil)
            
            //sectionNameKeyPath????
            
            fetchedResultsController.delegate = self
            do {
                try fetchedResultsController.performFetch()
            }catch{
                fatalError("Failed to fetch data")
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
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let indexPath = NSIndexPath(row: row, section: 0)
        let tempTrip:Trip = (fetchedResultsController.object(at: indexPath as IndexPath) as? Trip)!
        return tempTrip.tripName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let indexPath = NSIndexPath(row: row, section: 0)
        let tempTrip:Trip = (fetchedResultsController.object(at: indexPath as IndexPath) as? Trip)!
        tripNameTextField.text = tempTrip.tripName
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (fetchedResultsController.fetchedObjects?.count)!
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
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
        locationTextField.resignFirstResponder()
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            print("The save button was not pressed")
            return
        }
        
        let text = journalTextView.attributedText ?? nil
        let date = dateTextField.text ?? ""
        let location = locationTextField.text ?? ""
        let tripName = tripNameTextField.text ?? ""
        
        if callback != nil{
            callback!(text!, date, location,tripName)
        }
    }

}

enum EditType {
    case new
    case edit
}

