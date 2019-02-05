//
//  ShareImageViewContriller.swift
//  MemeMe
//
//  Created by Abdullah Aldakhiel on 5/02/2019.
//  Copyright © 2018 Abdullah Aldakhiel. All rights reserved.
//

import UIKit

class ShareImageViewContriller: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var bottomBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    var shareImage:UIImage!
    var bottomPress = false
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imagePickerView.image = shareImage
        shareButton.isEnabled = true
        
        configureTextField (textF: bottomText, name: "BOTTOM")
        configureTextField (textF: topText, name: "TOP")
        
        
    }
    
    func configureTextField (textF: UITextField, name: String){
        textF.text = name
        let memeTextAttributes:[NSAttributedString.Key : Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -2.0,]
        textF.defaultTextAttributes = memeTextAttributes
        textF.textAlignment = .center
        
        
        let fixedWidth = imagePickerView.frame.size.width
        let newSize = textF.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textF.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        
    }
    @IBAction func sizeOfText(_ sender: Any) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
        super.touchesBegan(touches, with: event)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    
    @IBAction func textFTopEnd(_ sender: Any) {
        textFieldShouldReturn(sender as! UITextField)
        
    }
    
    @IBAction func textFBotEnd(_ sender: Any) {
        textFieldShouldReturn(sender as! UITextField)
    }
    @objc func keyboardwillshow (_ notification:Notification){
        if self.view.frame.origin.y == 0 && bottomText.isFirstResponder {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            print(getKeyboardHeight(notification))
        }
    }
    @objc func keyboardwillHide(_ notification:Notification){
        
        self.view.frame.origin.y = 0
        
    }
    
    
    @IBAction func keyBoardUp(_ sender: Any) {
        subscribeToKeyboardNotifications()
        
    }
    
    @IBAction func keyBoardDown(_ sender: Any) {
        unsubscribeFromKeyboardNotifications()
        
    }
    @IBAction func shareYourPic(_ sender: Any) {
        let memedImage = generateImage()
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        vc.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }else{
            }
        }        
        present(vc, animated: true, completion: {  () in
            //self.dismiss(animated: true, completion: nil)
        })
    }
    
    func generateImage() -> UIImage {
        
        configureBars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        configureBars(false)
        return newImage
    }
    
    func configureBars(_ isHidden: Bool) {
        bottomBar.isHidden = isHidden
    }
}


extension ShareImageViewContriller{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}

extension ShareImageViewContriller {
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ShareImageViewContriller.keyboardwillshow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        if bottomText.endEditing(true){
            NotificationCenter.default.addObserver(self, selector: #selector(ShareImageViewContriller.keyboardwillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            
        }
    }
}
