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
    
    
    //------------------------------------------------------------
    // setSoundManager
    
    //  sets the instance variable soundManager to the parent view by getting the 
    //  first view from the navigation controller
    /*func setSoundManager() {
        var mainViewController:RecordSoundViewController
        var navController:UINavigationController?
        //let firstVC = navigationController.viewControllers[0] as! NameOfFirstViewController
        // set whatever properties you might want to set
        navController = self.parentViewController as! UINavigationController
        mainViewController = navController!.viewControllers[0] as! RecordSoundViewController
        soundManager = mainViewController?.soundManager
    }*/
    
    
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
/*
    // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
    }
    */

}
