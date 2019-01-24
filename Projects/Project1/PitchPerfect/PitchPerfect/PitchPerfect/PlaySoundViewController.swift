//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Abdeltwab Elhussin on 1/22/19.
//  Copyright © 2019 Abdeltwab Elhussin. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    @IBOutlet weak var slowBtn : UIButton!
    @IBOutlet weak var fastBtn : UIButton!
    @IBOutlet weak var highBtn : UIButton!
    @IBOutlet weak var lowBtn : UIButton!
    @IBOutlet weak var reverbBtn : UIButton!
    @IBOutlet weak var echotn : UIButton!
    @IBOutlet weak var stopBtn : UIButton!

    
    var audioRecordURL : URL!
    
    //vars used by the extention
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case fast = 0, slow, high , low, echo, reverb
    }
    
    //Actions
    @IBAction func playSoundForButton ( _ sender : UIButton) {
        //print("play sound pressed")
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .high:
            playSound(pitch: 1000)
        case .low:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        configureUI(.playing)
    }
    
    @IBAction func stopSoundForButton ( _ sender : AnyObject) {
        stopAudio()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
