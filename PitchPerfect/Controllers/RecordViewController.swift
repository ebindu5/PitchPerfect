//
//  RecordViewController.swift
//  PitchPerfect
//
//  Created by BINDU ELAKURTHI on 4/17/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController,  AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopRecording: UIButton!
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecording.isEnabled = false
    }
    
    @IBAction func startRecording(_ sender: Any) {
        changeProperties("Recording in progress", true, false)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "RecordingAudio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try!  session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        try!   audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        changeProperties("Tap to Record", false, true)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try!  audioSession.setActive(false)
    }
    
    //MARK: Change the RecordVC properties
    func changeProperties(_ recordingLabelText: String, _ stopRecordingStatus: Bool, _ recordButtonStatus: Bool){
        recordLabel.text = recordingLabelText
        stopRecording.isEnabled = stopRecordingStatus
        recordButton.isEnabled = recordButtonStatus
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("Recording has not saved")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playVC = segue.destination as! PlayBackViewController
            let recordedURL = sender as! URL
            playVC.recordedAudioURL = recordedURL
        }
    }
}

