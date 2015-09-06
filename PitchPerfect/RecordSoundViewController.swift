//
//  RecordSoundViewController
//  PitchPerfect
//
//  Created by Alexis de Werrra on 8/14/15.
//  Copyright (c) 2015 MadWorld Software. All rights reserved.
//

import UIKit

class RecordSoundViewController: UIViewController {

    @IBOutlet weak var recLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var soundManager: SoundHandlingObject?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        recLabel.text = "Press button to record"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func RecordSound(sender: UIButton) {
        soundManager = SoundHandlingObject()

        stopButton.hidden=false
        recLabel.text = "Recording"
        recordButton.enabled=false
        soundManager!.startRecordSound()

    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden=true;
    }

    @IBAction func StopRecording(sender: UIButton) {
        recLabel.text = "Press button to record"

        stopButton.hidden = true
        recordButton.enabled=true
        soundManager!.stopRecordSound()
        self.performSegueWithIdentifier("StopRecording", sender: soundManager)

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "StopRecording") {
            let playSoundViewCtrl:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! SoundHandlingObject
            playSoundViewCtrl.soundManager = data
        }
    }
}

