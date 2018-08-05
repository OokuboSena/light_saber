//
//  ViewController.swift
//  lightSavar
//
//  Created by Ookubo Sena on 2018/08/05.
//  Copyright © 2018年 jp.app.game. All rights reserved.
//

import UIKit
import CoreMotion           //加速度センサーの値を取得するためのフレームワーク
import AVFoundation         //音を再生するためのフレームワーク

class ViewController: UIViewController {
    
    let motionManager:CMMotionManager = CMMotionManager()
    
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    
    var startAudioplayer:AVAudioPlayer = AVAudioPlayer()

    var startAccel: Bool = false
    
    
    // pushCountが偶数の時に停止、奇数の時に稼働
    var pushCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSound()
        
    }

    @IBAction func tappedStartButton(_ sender: UIButton) {
        startAudioplayer.play()
        startGetAccelerometer()

        pushCount+=1
    }
    
    func setupSound() {
        //ボタンを押した時の音
        if let sound = Bundle.main.path(forResource: "light_saber1", ofType: ".mp3") {
            startAudioplayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            startAudioplayer.prepareToPlay()
        }
        //iPhoneを振った時の音
        if let sound = Bundle.main.path(forResource: "light_saber3", ofType: ".mp3"){
            audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            audioPlayer.prepareToPlay()
        }
    }
    
    
    
    
    
    func startGetAccelerometer() {
        motionManager.accelerometerUpdateInterval = 1/100
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (accelerometerData: CMAccelerometerData?, error: Error?) in
            if let acc = accelerometerData {
                let x = acc.acceleration.x
                let y = acc.acceleration.y
                let z = acc.acceleration.z
            
                let synthetic = (x * x) + (y * y) + (z * z)
            
                if self.startAccel == false && synthetic >= 8 {
                    self.startAccel = true
                    self.audioPlayer.currentTime = 0
                    if self.pushCount % 2 == 1 {
                        self.audioPlayer.play()
                    }else{
                        self.audioPlayer.stop()
                    }
                }
                
                if self.startAccel == true && synthetic < 1 {
                    self.startAccel = false
                }
            }
        }
    }
}
