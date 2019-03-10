//
//  CreateMemeViewController.swift
//  MemeApp-V1
//
//  Created by Abdeltwab Elhussin on 2/2/19.
//  Copyright © 2019 Abdeltwab Elhussin. All rights reserved.
//

import UIKit

class CreateMemeViewController : UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    // the problem of cancel button
    // https://www.youtube.com/watch?v=6o4PmMywIA8
    
    //MARK: Outlets
    @IBOutlet weak var albumBarBtn: UIBarButtonItem!
    @IBOutlet weak var cameraBarBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBarBtn: UIButton!
    @IBOutlet weak var shareBarBtn: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationbar: UINavigationBar!
    @IBOutlet weak var sntMemeBtnView: UIButton!
    
    //MARK: Delegates
    let topTxtFldDelegate = TextFiledsDelegates()
    let bottomTxtFldDelagte = TextFiledsDelegates();
    
    //MARK: Initial Configurations
    
    let textFieldAttributes : [NSAttributedString.Key:Any] = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        //NSAttributedString.Key.backgroundColor : UIColor.black,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
        NSAttributedString.Key.strokeWidth : -2.0 ,
    ]
    
    
    func setStyle(toTextField textField: UITextField) {
        if textField == topTextField {
            textField.text = "TOP"
            textField.delegate = topTxtFldDelegate
        }else if textField == bottomTextField {
            textField.text = "BOTTOM"
            textField.delegate = bottomTxtFldDelagte
        }
        //comon configuration
        textField.defaultTextAttributes = textFieldAttributes
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = true
    }
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // initial Configuration
        cameraBarBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setStyle(toTextField: topTextField)
        setStyle(toTextField: bottomTextField)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if imgView.image == nil {
            shareBarBtn.isEnabled = false
            cancelBarBtn.isEnabled = false
        }
        // subscribing to keyboard notifications
        subscribeToWrtingNotification()
        subscribeToReturnNotification()
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromWrtingNotifications()
        subscribeToReturnNotification()
    }
    
    //MARK: PickImage
    
    func openImagePicker(_ type: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func picImgFromAlbum(_ sender: Any) {
        openImagePicker(.photoLibrary)
    }
    
    @IBAction func picImgFromCamera(_ sender: Any) {
       openImagePicker(.camera)
    }
    
    //MARK: Image Picker Finishing
     // image selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgView.image = image
            //enbling share button
            shareBarBtn.isEnabled = true
            cancelBarBtn.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    //cancel  selecting image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imgView.image = nil
        dismiss(animated: true, completion: nil)
    }
  
    //MARK: shifiting Keyboard up and down
    func subscribeToWrtingNotification () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromWrtingNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func subscribeToReturnNotification () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromReturnNotification () {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= (0.5 * getKeyboardHeight(notification) )
        }
    }
    
    
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
         return keyboardSize.cgRectValue.height
    }
    
    // MARK: Svaing the Meme Picture
    
    func hideToolbars(_ hide: Bool) {
        self.navigationbar.isHidden = hide
        self.toolbar.isHidden = hide
    }
    
    func generateMemeImg() -> UIImage {
        //hide navigation bar
        hideToolbars(true)
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // show
       hideToolbars(false)
        return memedImage
    }
    
    
    func saveMemeImg(memedImg : UIImage) -> Meme {
        
        let mem = Meme(topText: topTextField.text!, bottomTxt: bottomTextField.text!, OrginalImg: imgView.image!, memedImg: memedImg)
        return mem
    }
    
    
    //MARK: Share Meme
    
    @IBAction func shareMeme(_ sender: Any) {
        // create activity contoll
        let memedImg = generateMemeImg()
        let activityController = UIActivityViewController.init(activityItems: [memedImg], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = { (activity, success, items, error) in
            if(success) {
                let SavedMeme =  self.saveMemeImg(memedImg: memedImg)
                //shorter Version
                //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(SavedMeme)
                var i = 0
                print("New Meme has been Added number ->\(i+=1)")
            }
         }
    }
    
    
    // is not working ?? why
    @IBAction func cancelMeme(_ sender: Any) {
        self.imgView.image = nil
        setStyle(toTextField: topTextField)
        setStyle(toTextField: bottomTextField)
    }
    
    
    
    //navigate to sent memes tab bar using code and  segue
  
    @IBAction func sentMemebtn(_ sender: Any) {
        performSegue(withIdentifier: "sentMemeSegue", sender: self)

    }
    
}

