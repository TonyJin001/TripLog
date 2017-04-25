//
//  NewJournalViewController.swift
//  TripLog
//
//  Created by Lyra Ding on 4/24/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

class NewJournalViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    @IBOutlet weak var journalTextView: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        journalTextView.layer.borderColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1.0).cgColor
        journalTextView.layer.borderWidth = 1.0
        journalTextView.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func importImage(_ sender: UIBarButtonItem) {
        let image = UIImagePickerController()
        image.delegate = self
        
        // Decide whether the user wants to take a photo or select it from the photo library
        switch sender {
        case cameraButton:
            image.sourceType = UIImagePickerControllerSourceType.camera
        case uploadButton:
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
            let scaleFactor = oldWidth/(journalTextView.frame.size.width-10)
            attachment.image = UIImage(cgImage: attachment.image!.cgImage!, scale: scaleFactor, orientation:.up)
            
            //put your NSTextAttachment into and attributedString
            let attString = NSAttributedString(attachment: attachment)
            //add this attributed string to the current position.
            journalTextView.textStorage.insert(attString, at: journalTextView.selectedRange.location)
            
        } else {
            // Error
            journalTextView.text = "Didn't get the image"
        }
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelEditing(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
