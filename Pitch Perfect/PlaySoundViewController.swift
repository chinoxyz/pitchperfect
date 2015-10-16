//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Jose Sanchez on 9/29/15.
//  Copyright (c) 2015 Jose Sanchez. All rights reserved.
//

import UIKit
import AVFoundation
class PlaySoundViewController: UIViewController {
    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var receivedAudio:RecordedAudio!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer?.enableRate = true
        audioPlayer!.prepareToPlay()
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
    }

    
    @IBAction func playSlow(sender: UIButton) {
        playWithRate(0.5)
    }
    @IBAction func playFast(sender: UIButton) {
        playWithRate(2.0)
    }
    
    /*
     * Play RecordedAudio with a determined rate
     */
    func playWithRate(rate:Float){
        audioEngine.stop()
        audioPlayer?.currentTime = 0
        audioPlayer?.rate = rate
        audioPlayer?.play()
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playWithPitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playWithPitch(-1000)
    }
    
    @IBAction func playReberbAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changeEffect = AVAudioUnitReverb()
        changeEffect.loadFactoryPreset( AVAudioUnitReverbPreset.LargeChamber)
        changeEffect.wetDryMix = 50.0
        audioEngine.attachNode(changeEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
        audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    @IBAction func playEchoAudio(sender: UIButton) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changeEffect = AVAudioUnitDelay()
        changeEffect.delayTime = NSTimeInterval(0.5)
        
        audioEngine.attachNode(changeEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
        audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    /*
     * Play Recorded Audio with a determined pitch
     */
    func playWithPitch(pitch:Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    /*
     * Stop any Audio
     */
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer?.stop()
        audioEngine?.stop()
    }


}
