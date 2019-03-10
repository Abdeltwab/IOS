//
//  SentMemeCustomTableViewCell.swift
//  MemeApp-V1
//
//  Created by Abdeltwab Elhussin on 3/4/19.
//  Copyright © 2019 Abdeltwab Elhussin. All rights reserved.
//

import UIKit

class SentMemeCustomTableViewCell: UITableViewCell {

    
    //outlets
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var lftLbl: UILabel!
    @IBOutlet weak var rightLbl: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
