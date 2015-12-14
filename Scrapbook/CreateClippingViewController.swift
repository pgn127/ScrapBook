//
//  CreateClippingViewController.swift
//  Scrapbook
//
//  Created by Pamela Needle on 9/13/15.
//  Copyright (c) 2015 Pamela Needle. All rights reserved.
//

import UIKit

class CreateClippingViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var enteredNotes: UITextView!
    @IBOutlet weak var clippingImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    let picker = UIImagePickerController()
    var model: ScrapbookModel?
    var currentClipping: Clipping?
    var inCollection: Collection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enteredNotes.delegate = self
        picker.delegate = self
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if saveButton === sender {
            let notes = enteredNotes.text
            let image = clippingImageView.image
            currentClipping = model!.newClipping(notes, image: image!)
            if let inside = inCollection {
                model!.addClippingtoCollection(currentClipping!, collection: inside)
                println("clipping \(currentClipping?.dateCreated) added to collection \(inside.name)")
//            }
        }
        
    }*/
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    @objc func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            clippingImageView.contentMode = .ScaleAspectFit
            clippingImageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Enter notes here"{
            textView.text = nil

        }
    }
//
//    func textViewDidEndEditing(textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "No notes entered."
//            textView.textColor = UIColor.lightGrayColor()
//        }
//    }
    
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        enteredNotes.resignFirstResponder()
        //et imagePickerController = UIImagePickerController()
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        presentViewController(picker, animated: true, completion: nil)//4
//        picker.modalPresentationStyle = .Popover
//        presentViewController(picker, animated: true, completion: nil)//4
//        picker.popoverPresentationController?.UITapGestureRecognizer = sender
        
    }
   
    @IBAction func savePressed(sender: AnyObject) {
        let notes = enteredNotes.text
        let image = clippingImageView.image
        currentClipping = model!.newClipping(notes, image: image!)
        if let inside = inCollection {
            model!.addClippingtoCollection(currentClipping!, collection: inside)
            //println("clipping \(currentClipping?.dateCreated) added to collection \(inside.name)")
                        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
}
