//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Jasmee Sengupta on 11/06/17.
//  Copyright © 2017 Jasmee Sengupta. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer?
    var recordedAudio: RecordedAudio?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func playFastButtonTapped(_ sender: UIButton) {
        self.playAudio(resourcePath: recordedAudio?.filePathURL, rate: 1.8)
    }
    
    @IBAction func playSlowButtonTapped(_ sender: UIButton) {
        self.playAudio(resourcePath: recordedAudio?.filePathURL, rate: 0.4)
    }
    
    @IBAction func playTomButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func playNormalButtonTapped(_ sender: UIButton) {
        //self.playAudio(resourcePath: "chalte", rate: 1.0)
        self.playAudio(resourcePath: recordedAudio?.filePathURL, rate: 1.0)
    }
    
    @IBAction func stopAudio(_ sender: UIButton) {
        audioPlayer?.stop()
    }
    
    func playAudio(resourcePath : URL?, rate: Float) {
        guard let resourcePath = resourcePath else{
            return
        }
        getAudio(path: resourcePath)
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0.0
        //how to play continuous audio? it is not playing even without above line. may be because we are getting the audio everytime anew
        audioPlayer?.enableRate = true
        audioPlayer?.rate = rate
        audioPlayer?.play()
    }
    
    func getAudio(path : URL) {
        //keeping it here does not play sound - If you declare your player inside the method it would go out of existence as soon as it finishes executing your method
        //var audioPlayer: AVAudioPlayer?
        //let path = path.description
//        guard let filePath = Bundle.main.path(forResource: path, ofType: "m4a") else {
//            ////TODO: alert "Sorry we lost you there"
//            return
//        }
        
        do {
            //let fileURL = URL.init(fileURLWithPath: path)
            audioPlayer = try AVAudioPlayer(contentsOf: path, fileTypeHint: "m4a")
            audioPlayer?.prepareToPlay()
        }catch {
            ////TODO: alert "Sorry we lost you there"
        }
    }
}
