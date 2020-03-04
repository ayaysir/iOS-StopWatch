//
//  SettingViewController.swift
//  StopWatch
//
//  Created by yoonbumtae on 2020/03/03.
//  Copyright © 2020 BGSMM. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    // RRGGBB hex colors in the same order as the image
    let colorArray = [ 0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0, 0xbf0199, 0xffffff ]

    @IBOutlet var slFontSize: UISlider!
    @IBOutlet var slFontColor: UISlider!
    @IBOutlet var selectedColorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        slFontSize.maximumValue = 70
        slFontSize.minimumValue = 20
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let prefs = readPref()
        slFontSize.setValue(prefs!.sizeOfTime, animated: false)
        if let i = colorArray.firstIndex(where: {$0 == prefs!.colorOfTime}) {
            slFontColor.setValue(Float(i), animated: false)
            selectedColorView.backgroundColor = UIColorFromHex(rgbValue: prefs!.colorOfTime)
        }
        
    }
    
    @IBAction func slFontSize(_ sender: UISlider) {
        print(sender.value)
        let prefs = readPref()
        updatePref(font: prefs!.fontOfTime, color: prefs!.colorOfTime, size: sender.value)
    }
    
    @IBAction func slFontColor(_ sender: UISlider) {
        selectedColorView.backgroundColor = UIColorFromHex(rgbValue: colorArray[Int(sender.value)])
        print(sender.value, Int(sender.value))
        
        let prefs = readPref()
        updatePref(font: prefs!.fontOfTime, color: colorArray[Int(sender.value)], size: prefs!.sizeOfTime)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
