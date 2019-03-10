//
//  SentMemesTableViewController.swift
//  MemeApp-V1
//
//  Created by Abdeltwab Elhussin on 2/19/19.
//  Copyright © 2019 Abdeltwab Elhussin. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    // model
   /* method 1
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    memes = appDelegate.memes  */
  
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
    let cellID = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SentMemeCustomTableViewCell
        let row = memes[(indexPath as NSIndexPath).row]
        
        //filling the cell
        cell.lftLbl.text = row.topText
        cell.rightLbl.text = row.bottomTxt
        cell.cellImg.image = row.memedImg
       
        // return 
        return cell
    }
   

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memsDetailsController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController
        memsDetailsController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(memsDetailsController, animated: true)
    }

}
