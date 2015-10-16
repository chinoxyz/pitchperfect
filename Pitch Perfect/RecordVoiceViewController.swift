//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Jose Sanchez on 9/26/15.
//  Copyright (c) 2015 Jose Sanchez. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundViewController: UIViewController , AVAudioRecorderDelegate{

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var tapRecordLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        self.stopButton.hidden = true
        self.recordButton.enabled=true
        self.tapRecordLabel.hidden = false
        self.pauseButton.hidden=true
        self.resumeButton.hidden=true
    }
    
    @IBAction func pauseAudio(sender: UIButton) {
        audioRecorder.pause()
        resumeButton.hidden=false
        pauseButton.hidden=true
    }
    @IBAction func resumeAudio(sender: UIButton) {
        audioRecorder.record()
        resumeButton.hidden=true
        pauseButton.hidden=false
        
    }
    @IBAction func stopAudio(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        self.recordLabel.hidden = true
        self.stopButton.hidden = true
        self.recordButton.enabled=true
        self.resumeButton.hidden=true
        self.pauseButton.hidden=true
    }
    @IBAction func recordAudio(sender: UIButton) {

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "myaudio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        self.tapRecordLabel.hidden = true
        self.recordLabel.hidden = false
        self.stopButton.hidden=false
        self.recordButton.enabled=false
        self.pauseButton.hidden=false
        print("Recording audio")
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            print("Error with audio record")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

