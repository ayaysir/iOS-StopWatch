//
//  ViewController.swift
//  StopWatch
//
//  Created by yoonbumtae on 2020/02/26.
//  Copyright © 2020 BGSMM. All rights reserved.
//

import UIKit

struct Preferences: Codable {
    var fontOfTime: String
    var colorOfTime: Int
    var sizeOfTime: Float
}


// plist test
let prefPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Preferences.plist")

func updatePref(font: String, color: Int, size: Float) {
    let preferences = Preferences(fontOfTime: font, colorOfTime: color, sizeOfTime: size)
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    
    do {
        let data = try encoder.encode(preferences)
        try data.write(to: prefPath)
    } catch {
        print(error)
    }
}

func readPref() -> Preferences? {
    // plist read
    if
        let xml = FileManager.default.contents(atPath: prefPath.path),
        let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml) {
        
        return preferences
    }
    
    return nil
}


func UIColorFromHex(rgbValue: Int) -> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
    let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
    let blue = CGFloat((rgbValue & 0x0000FF)) / 0xFF
    let alpha = CGFloat(1.0)
    
    
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}


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
        
        
        let isFileExist: Bool = FileManager.default.fileExists(atPath: prefPath.path)
        
        if !isFileExist {
            updatePref(font: "Courier", color: 0x000000, size: 60.0)
        }
        
        lblTime.text = timeFormatter(0)
        
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let prefs = readPref()!
            
        // font size
        //lblTime.font = UIFont(name: prefs.fontOfTime, size: CGFloat(prefs.sizeOfTime))
        
        // font color
        lblTime.textColor = UIColorFromHex(rgbValue: prefs.colorOfTime)
        
        // 래이블 monospace화 하기
        let bodyFontDescriptor = UIFontDescriptor.init(name: prefs.fontOfTime, size: CGFloat(prefs.sizeOfTime))
            let bodyMonospacedNumbersFontDescriptor = bodyFontDescriptor.addingAttributes(
                [
                    UIFontDescriptor.AttributeName.featureSettings: [
                        [
                            UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                            UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
                        ]
                    ]
                ])

            let bodyMonospacedNumbersFont = UIFont(descriptor: bodyMonospacedNumbersFontDescriptor, size: CGFloat(prefs.sizeOfTime))

            lblTime.font = bodyMonospacedNumbersFont

        
    }
    
    @IBAction func btnStartAction(_ sender: Any) {
        
        if isTimerOn == false {
            // 최초 시작
            isTimerOn = true
            btnStartOutlet.setTitle("Pause", for: .normal)
            lblTime.text = timeFormatter(currentTimeCount)
            
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
        //lblTime.text = timeFormatter(currentTimeCount)
        // stop 버튼 비활성화
        btnStopOutlet.isEnabled = false
        logger(title: "Stop")
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

