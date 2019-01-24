//
//  recordVoiceViewController.swift
//  PitchPerfect
//
//  Created by Abdeltwab Elhussin on 1/18/19.
//  Copyright © 2019 Abdeltwab Elhussin. All rights reserved.
//

import UIKit
import AVFoundation


class recordVoiceViewController: UIViewController , AVAudioRecorderDelegate{
    // MARK: propertises
    var audioRecorder : AVAudioRecorder!
    var isRecoding : Bool!
    
    // MARK: ui
    @IBOutlet weak var recordlbl: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopBtn.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // print("View will apprea")
    }
    
    // MARK: configure UI
    func configureUI (_ state : Bool) {
       
        if state {
            stopBtn.isEnabled = true
            recordBtn.isEnabled = false
            recordlbl.text = "Recording in progress"
            
        }else {
            recordBtn.isEnabled = true
            stopBtn.isEnabled = false
            recordlbl.text = "Recording Stooped"
            
        }
       
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        isRecoding = true
        configureUI(isRecoding)
        //record voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        //debugging
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        //delegate
        audioRecorder.delegate = self
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    @IBAction func stopRecord(_ sender: Any) {
        isRecoding = false
       configureUI(isRecoding)
       audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //print("Recording is finsihed ..")
        if flag{
              performSegue(withIdentifier: "stopRecodingSegu", sender: audioRecorder.url)
        }else {
            print("REcoding is not Finsihed succesfully")
        }
    }
    
    //preppare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecodingSegu" {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordSoundULR = sender as! URL
            playSoundVC.audioRecordURL = recordSoundULR
        }
    }
}

