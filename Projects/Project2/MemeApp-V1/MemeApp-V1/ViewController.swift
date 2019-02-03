//
//  ViewController.swift
//  MemeApp-V1
//
//  Created by Abdeltwab Elhussin on 2/2/19.
//  Copyright © 2019 Abdeltwab Elhussin. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    // the problem of cancel button
    // https://www.youtube.com/watch?v=6o4PmMywIA8
    
    //MARK: Outlets
    @IBOutlet weak var albumBarBtn: UIBarButtonItem!
    @IBOutlet weak var cameraBarBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBarBtn: UIBarButtonItem!
    @IBOutlet weak var shareBarBtn: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationbar: UINavigationBar!
    
    //MARK: Delegates
    let topTxtFldDelegate = TopTxtFldDelegate()
    let bottomTxtFldDelagte = BottomTxtFldDelegate();
    
    //MARK: Model
    struct Meme {
        var topText : String
        var bottomTxt: String
        var OrginalImg : UIImage?
        var memedImg : UIImage?
    }
    
    
    
    //MARK: Initial Configurations
    func toolBarConfiguration()  {
        
    }
    let textFieldAttributes : [NSAttributedString.Key:Any] = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.red,
        //NSAttributedString.Key.backgroundColor : UIColor.black,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
        NSAttributedString.Key.strokeWidth : -2.0
    ]
    
    func topTextFldInitConfigurtion() {
        topTextField.text = "TOP"
        topTextField.textAlignment = .center
        topTextField.defaultTextAttributes = textFieldAttributes
    }
    
    func bottomTextFldInitConfigurtion() {
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .center
        bottomTextField.defaultTextAttributes = textFieldAttributes
    }
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect delegates
        topTextField.delegate = topTxtFldDelegate
        bottomTextField.delegate = bottomTxtFldDelagte
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "xxx", style: .plain, target: self, action: #selector(cancelMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // initial configurations
        cameraBarBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topTextFldInitConfigurtion()
        bottomTextFldInitConfigurtion()
        if imgView.image == nil {
            shareBarBtn.isEnabled = false
            cancelBarBtn.isEnabled = false
        } else {
            shareBarBtn.isEnabled = true
            cancelBarBtn.isEnabled = true
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
    @IBAction func picImgFromAlbum(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func picImgFromCamera(_ sender: Any) {
        let cameraPickerController = UIImagePickerController()
        cameraPickerController.delegate = self
        cameraPickerController.sourceType = .camera
        present(cameraPickerController, animated: true, completion: nil)
    }
    
    //MARK: Image Picker Finishing
     // image selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgView.image = image
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
            view.frame.origin.y -= getKeyboardHeight(notification)
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
    
    func generateMemeImg() -> UIImage {
        //hide navigation bar
        self.navigationbar.isHidden = true
        self.toolbar.isHidden = true
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // show
        self.navigationbar.isHidden = false
        self.toolbar.isHidden = false
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
                _ =  self.saveMemeImg(memedImg: memedImg)   // to be used later in the next version of the app
            }
         }
    }
    
    
    // is not working ?? why
    @IBAction func cancelMeme(_ sender: Any) {
        self.imgView.image = nil
        topTextFldInitConfigurtion()
        bottomTextFldInitConfigurtion()
    }
    
    
}

