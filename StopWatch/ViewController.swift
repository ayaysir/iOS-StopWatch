//
//  ViewController.swift
//  StopWatch
//
//  Created by yoonbumtae on 2020/02/26.
//  Copyright © 2020 BGSMM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isTimerOn: Bool = false
    var currentTimeCount: Int = 0
    
    var timer: Timer?
    
    let timeSelector: Selector = #selector(ViewController.updateTime)

    @IBOutlet var lblTime: UILabel!
    @IBOutlet var btnStartOutlet: UIButton!
    @IBOutlet var btnStopOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnStopOutlet.isEnabled = false
    }
    @IBAction func btnStartAction(_ sender: Any) {
        
        if isTimerOn == false {
            // 최초 시작
            isTimerOn = true
            btnStartOutlet.setTitle("Pause", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: timeSelector, userInfo: nil, repeats: true)
            // stop 버튼 활성화
            btnStopOutlet.isEnabled = true
            logger(title: "Start")
        } else if isTimerOn && timer!.isValid {
            // 타이머 진행 중 일시정지
            btnStartOutlet.setTitle("Resume", for: .normal)
            timer?.invalidate()
            logger(title: "Pause")
        } else if isTimerOn && !(timer!.isValid) {
            // 일시정지상태에서 재개
            btnStartOutlet.setTitle("Pause", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: timeSelector, userInfo: nil, repeats: true)
            logger(title: "Resume")
        }
        
        
    }
    @IBAction func btnStopAction(_ sender: Any) {
        // 타이머 종료 후 리셋
        timer?.invalidate()
        isTimerOn = false
        btnStartOutlet.setTitle("Start", for: .normal)
        currentTimeCount = 0
        lblTime.text = timeFormatter(currentTimeCount)
        // stop 버튼 비활성화
        btnStopOutlet.isEnabled = false
        logger(title: "Stop")
    }
    @IBAction func btnHistory(_ sender: Any) {
    }
    @IBAction func btnSetting(_ sender: Any) {
    }
    
    @objc func updateTime(){
        
        currentTimeCount += 1
        lblTime.text = timeFormatter(currentTimeCount)
    }
    
    func timeFormatter(_ intTime: Int) -> String {
        let hour = intTime / 3600
        let min = (intTime % 3600) / 60
        let sec = (intTime % 3600) % 60
        
        let hourStr =  hour < 10 ? "0\(hour)" : String(hour)
        let minStr = min < 10 ? "0\(min)" : String(min)
        let secStr = sec < 10 ? "0\(sec)" : String(sec)
        
        return "\(hourStr):\(minStr):\(secStr)"
    }
    
    func logger(title: String) {
        let date = NSDate()
        
        let logStr = "\(title),\(Int(date.timeIntervalSince1970))\n"
        
        let file = "history.txt"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            
            let isFileExist: Bool = FileManager.default.fileExists(atPath: fileURL.path)
            
            do {
                if !isFileExist {
                    // history.txt 파일이 없다면  생성
                    print(fileURL, fileURL.path)
                    try "".write(to: fileURL, atomically: false, encoding: .utf8)
                }
                // history.txt 파일에 기존 파일에 로그 추가
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                fileHandle.write(logStr.data(using: .utf8)!)
            } catch   {
                print(error)
            }
            
        }
        
    }


}

