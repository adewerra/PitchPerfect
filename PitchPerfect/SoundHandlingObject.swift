//
//  SoundHandlingObject.swift
//  PitchPerfect
//      Handle all the recording and playing with effects for sounds, is created and destroyed at each recording
//
//
//  Created by Alexis de Werrra on 8/14/15.
//  Copyright (c) 2015 MadWorld Software. All rights reserved.
//

import UIKit
import AVFoundation


class SoundHandlingObject: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var soundFileURL: NSURL!
    var time: time_value?
    var pitch: Float
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    
    //----------------------------------------------------
    // Class constructor
    override init() {
        pitch = 1.0
        super.init()
 
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)
        let docsDir = dirPaths[0] as! String
        let soundFilePath = docsDir.stringByAppendingPathComponent("sound.acc")
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        self.soundFileURL  = soundFileURL
 
        //check if soundFileURL is not empty
        if(soundFilePath  == "")
        {
           NSLog("Sound file path is empty")
        } else {
            // Create the recorder
            var recordSettings = [
                AVFormatIDKey: kAudioFormatLinearPCM,
                AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
                AVEncoderBitRateKey : 320000,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey : 44100.0
            ]
            
            //Get the current audio session
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            session.setActive(true, error: nil)
            
            var error: NSError?
            self.recorder = AVAudioRecorder(URL: soundFileURL, settings: recordSettings as [NSObject : AnyObject], error: &error)
            if self.recorder == nil {
                //println(e.localizedDescription)
                NSLog("recoder was nil")
            } else {
                self.recorder.delegate = self
                recorder.meteringEnabled = true
                //() // creates/overwrites the file at soundFileURL
            }
            
       }

    }
    
    //----------------------------------------------------
    // init player
    func createPlayer() {
        var error:NSError?
        
        player = AVAudioPlayer(contentsOfURL: soundFileURL, error: &error)
        player.enableRate = true
        player.delegate = self

        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: soundFileURL, error: &error)

    }
 
    //----------------------------------------------------
    //playAudioWithVariablePitch(1000)
    func setPitchValue(pitch: Float){
        player.stop()
        player.currentTime = 0
        self.pitch = pitch
    }
    
    //----------------------------------------------------
    //playAudioWithEcho
    // help from http://coderissues.com/questions/29619087/what-does-detachnode-do-in-avaudioengine-class-in-swift
    func playAudioWithEcho() {
        var audioPlayerNode: AVAudioPlayerNode
        var echoNode = AVAudioUnitDelay()
        
        stopPlayingSound()
        audioEngine.reset()
 
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
 
        echoNode.delayTime = NSTimeInterval(0.3)

        audioEngine.attachNode(echoNode)
        
        // Connect Player --> AudioEffect
        audioEngine.connect(audioPlayerNode, to: echoNode, format: audioFile.processingFormat)
        // Connect AudioEffect --> Output
        audioEngine.connect(echoNode, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler:handlerFunc)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

    //----------------------------------------------------
    //playAudioWithVariablePitch(1000)
    func playAudioWithVariablePitch(pitch: Float){
        var error: NSError
        var changePitchEffect: AVAudioUnitTimePitch!
        var audioPlayerNode: AVAudioPlayerNode

        stopPlayingSound()
        audioEngine.reset()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Connect Player --> AudioEffect
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        // Connect AudioEffect --> Output
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: handlerFunc)
        audioEngine.prepare()
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

    //----------------------------------------------------
    // Completion function handler
    func handlerFunc() -> Void
    {
        NSLog("completionHandler: sound finished playing")
    }
 
    //----------------------------------------------------
    // Start playing the sound very slowly
    func playSoundAtSpeed(speed : Float) {
        stopPlayingSound()
        player.enableRate = true;
        player.rate = speed
        player.currentTime = 0
        player.play()
    }

    
    //----------------------------------------------------
    // Start playing the sound very slowly
    func playSoundSlow() {
        playSoundAtSpeed(0.5)
    }
    
    //----------------------------------------------------
    // Start playing the sound very fast
    func playSoundFast() {        
        playSoundAtSpeed(2)
    }
    

    //----------------------------------------------------
    // stop playing the sound
    func stopPlayingSound() {        
        player.enableRate = false;
        if(player.playing) {
            player.stop()
            player.currentTime = 0
        }
        
        if(audioEngine != nil) {
            audioEngine.stop()
            //audioEngine.reset()
        }

    }
    
    
    //----------------------------------------------------
    // Start recordig the sound from microphone
    func startRecordSound() {
        recorder.prepareToRecord() // creates/overwrites the file at soundFileURL

        recorder.record() // start recording
    }
    
    //----------------------------------------------------
    // Stop recordig the sound from microphone
    func stopRecordSound() {
        recorder.stop() // stop recording
        
    }
    
    //----------------------------------------------------
    // audioRecorderDidFinishRecording
   // extension SoundHandlingObject : AVAudioRecorderDelegate {
        
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
            var session = AVAudioSession.sharedInstance()
            session.setActive(false, error: nil)
        
            // create the player after finishing recording
            createPlayer()
        
            // ios8 and later
            var alert = UIAlertController(title: "Recorder",
                message: "Finished Recording",
                preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Keep", style: .Default, handler: {action in
                println("keep was tapped")
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {action in
                self.recorder!.deleteRecording()
            }))
        
    }


    //----------------------------------------------------
    // audioPlayerDidFinishPlaying
    // extension SoundHandlingObject : AVAudioRecorderDelegate {
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        // ios8 and later
        var alert = UIAlertController(title: "Recorder",
            message: "Finished Recording",
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Keep", style: .Default, handler: {action in
            println("keep was tapped")
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {action in
            self.recorder!.deleteRecording()
        }))
    }
    
    
    
    //----------------------------------------------------
    // audioRecorderEncodeErrorDidOccur
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
            println("\(error.localizedDescription)")
    }

}