//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Jasmee Sengupta on 11/06/17.
//  Copyright © 2017 Jasmee Sengupta. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    
    @IBOutlet weak var recordingInProgressLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    var audioRecorder: AVAudioRecorder?
    var recordedAudioFile: RecordedAudio?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //setting here over nil object does not work - why?
        //audioRecorder?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        recordButton.isEnabled = true
        stopButton.isEnabled = false
        recordingInProgressLabel.isHidden = true
    }

    @IBAction func recordButtonTapped(_ sender: UIButton) {
        recordButton.isEnabled = false
        stopButton.isEnabled = true
        recordingInProgressLabel.text = "Recording in progress..."
        recordingInProgressLabel.isHidden = false
        
        if let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            //let directoryPathURL = URL.init(fileURLWithPath: directoryPath, isDirectory: true)
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMyyy-HHmmss"
            let recordedAudioFileName = formatter.string(from: currentDateTime) + ".m4a"
            //let pathArray = [recordedAudioFileName]
            let filePathURL = URL.init(fileURLWithPath: directoryPath + "/" + recordedAudioFileName)
            print(filePathURL)
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
               try audioSession.setMode(AVAudioSessionModeDefault)
               try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
               try audioSession.setActive(true)
            } catch {
                print("Alert")
            }
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                try audioRecorder = AVAudioRecorder(url: filePathURL, settings: settings)
            } catch {
                print("Alert")
            }
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        }
    }
    
    func recordAudio() {
        
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        stopButton.isEnabled = false
        recordButton.isEnabled = true
        recordingInProgressLabel.isHidden = true
        audioRecorder?.stop()
        do {
           try AVAudioSession.sharedInstance().setActive(false)
        } catch {
           print("Alert")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudioFile = RecordedAudio()
            recordedAudioFile?.filePathURL = recorder.url
            recordedAudioFile?.title = recorder.url.lastPathComponent
           performSegue(withIdentifier: "stopRecording", sender: recordedAudioFile)
        }else{
            //TODO: alert
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            if let playSoundsVC = segue.destination as? PlaySoundsViewController {
                playSoundsVC.recordedAudio = sender as? RecordedAudio
            }
        }
    }

}

