//
//  TextFiledsDelegates.swift
//  MemeApp-V1
//
//  Created by Abdeltwab Elhussin on 2/3/19.
//  Copyright © 2019 Abdeltwab Elhussin. All rights reserved.
//

import UIKit

class TextFiledsDelegates: NSObject , UITextFieldDelegate {

    // LifeCycle
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
