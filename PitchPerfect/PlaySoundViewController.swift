//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Alexis de Werrra on 8/14/15.
//  Copyright (c) 2015 MadWorld Software. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var myPlayer: AVAudioPlayer?
    var soundManager: SoundHandlingObject!      // reference to object who handle playing & recording
    var speakerOn: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override func viewWillDisappear(animated: Bool) {
        soundManager.stopPlayingSound()
        soundManager = nil  // set the object to nil for destruction
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        soundManager.playSoundFast()
    }
    
    @IBAction func playSoundSlow(sender: UIButton) {
        soundManager.playSoundSlow()
    }

    @IBAction func playSoundPitch(sender: AnyObject) {
        soundManager.playAudioWithVariablePitch(-1000)
    }
    @IBAction func playSoundDarkVador(sender: UIButton) {
        soundManager.playAudioWithVariablePitch(1000)
    }

    @IBAction func setPich(sender: UISlider) {
        soundManager.playAudioWithVariablePitch(sender.value)
    }
    
    @IBAction func useSpeaker(sender: AnyObject) {
        //Get the current audio session and play throught speaker
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
         session.setActive(true, error: nil)
       
        if(speakerOn) {
            speakerOn = false
            session.overrideOutputAudioPort(AVAudioSessionPortOverride.None, error: nil)
        } else {
            speakerOn = true
            session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
        }

    }
    
    @IBAction func playSoundEcho(sender: AnyObject) {
        soundManager.playAudioWithEcho()
        
    }
    @IBAction func stopPlayingSound(sender: UIButton) {
        soundManager.stopPlayingSound()
        
        
    }


}
