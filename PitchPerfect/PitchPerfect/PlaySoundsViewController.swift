//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Shirley Hang on 3/25/15.
//  Copyright (c) 2015 shirley. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController
{
    var audioPlayer:AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func playAudio()
    {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playSlowAudio(sender: UIButton)
    {
        audioPlayer.rate = 0.5
        playAudio()
    }

    @IBAction func playFastAudio(sender: UIButton)
    {
        audioPlayer.rate = 1.5
        playAudio()
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
}
