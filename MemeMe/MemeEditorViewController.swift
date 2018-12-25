//
//  ViewController.swift
//  MemeMe
//
//  Created by MAC on 16/11/2018.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit


class ViewController: UIViewController , UIImagePickerControllerDelegate,
UINavigationControllerDelegate  , UITextFieldDelegate {
    
    
        var Image: UIImageView!
    @IBOutlet weak var TopBar: UIToolbar!
    @IBOutlet weak var TopText: UITextField!
 
    @IBOutlet weak var BottomText: UITextField!
    @IBOutlet weak var cameraB: UIBarButtonItem!
    
    
    @IBOutlet weak var ShareButton: UIBarButtonItem!
     @IBOutlet weak var cancel: UIBarButtonItem!
    
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var buttomBar: UIToolbar!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        
        cameraB.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        
        
        let memeTextAttributes = [
            NSAttributedString.Key.strokeWidth: Float(-4),
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
            ] as [NSAttributedString.Key : Any]
        func configure(textField :UITextField){
            
            textField.defaultTextAttributes = memeTextAttributes
            TopText.text = "TOP"
            BottomText.text = "BUTTOM"
            textField.textAlignment = NSTextAlignment.center
            textField.delegate = self
        }
        
        configure(textField: TopText)
        configure(textField:  BottomText)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textFieldDidBeginEditing(textField)
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == "BOTTOM"  {
            BottomText.text = ""
        }
        else if  textField.text == "TOP" {
            TopText.text = ""
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
   
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage{
            ImagePickerView.image = image
        }
    }
    
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if BottomText.isFirstResponder {
            
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
        
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        if BottomText.isFirstResponder {
            view.frame.origin.y = 0.0
        }
        
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:))    , name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            ImagePickerView.image = image
            
        }
        dismiss(animated: true) {
            self.ShareButton.isEnabled = true
        }
        
    }
    @IBAction func cancelFunc(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func PickAnImageFromCamera(_ sender: Any) {
        getImagePickerController(.camera)
    }
    
    @IBAction func PickAnImagefromLibrary(_ sender: Any) {
        getImagePickerController(.photoLibrary)
    }
    
   
   
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func getImagePickerController(_ sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
       
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        TopBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        buttomBar.isHidden = false
        TopBar.isHidden = false
        return memedImage
    }
    
    
    @IBAction func Share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activitycontorller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activitycontorller.completionWithItemsHandler = { activity , success , item , error -> Void in
            if success{
                self.save(memedImage: memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
           present(activitycontorller, animated: true, completion: nil)
    }
    
    func save(memedImage : UIImage) {
        
        let meme = generateMemedImage()
        let memeP = Meme(topText: TopText.text!, bottomText: BottomText.text!, originalImage: ImagePickerView.image, memedImage: meme)
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(memeP)
    }
    
    }


