//
//  SentMemeCollectionViewController.swift
//  MemeApp-V1
//
//  Created by Abdeltwab Elhussin on 2/19/19.
//  Copyright © 2019 Abdeltwab Elhussin. All rights reserved.
//

import UIKit


class SentMemeCollectionViewController: UICollectionViewController {

    // Story ID =  SentMemeCollectionView
    let reuseIdentifier = "collectionCell"

    //models
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**Commentingthis line solved the error : Could not cast value of type 'UICollectionViewCell' (0x11001eea0) to 'MemeApp_V1.SentMemeCollectionViewCell**/
       // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

   
    // MARK: UICollectionViewDataSource



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! SentMemeCollectionViewCell
        
        let row =  self.memes[(indexPath as NSIndexPath).row]
        
        // filling the collection view
        cell.collectionCelImg.image = row.memedImg
        cell.collectionCellTopLbl.text = row.topText
        cell.collectionCellBottomLbl.text = row.bottomTxt
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memsDetailsController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController
        memsDetailsController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(memsDetailsController, animated: true)
    }

}
