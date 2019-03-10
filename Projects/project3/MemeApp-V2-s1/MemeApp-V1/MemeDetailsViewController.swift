//
//  MemeDetailsViewController.swift
//  MemeApp-V1
//
//  Created by Abdeltwab Elhussin on 2/25/19.
//  Copyright © 2019 Abdeltwab Elhussin. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {

    var meme : Meme!
    
    //outlets
    @IBOutlet weak var ImgView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // make the image :  Aspect Fill
        self.ImgView.image = meme.memedImg
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //
    }
    
}
