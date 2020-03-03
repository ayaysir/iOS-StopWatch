//
//  SettingViewController.swift
//  StopWatch
//
//  Created by yoonbumtae on 2020/03/03.
//  Copyright © 2020 BGSMM. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet var slFontSize: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        slFontSize.maximumValue = 70
        slFontSize.minimumValue = 20
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let prefs = readPref()
        slFontSize.setValue(prefs!.sizeOfTime, animated: false)
    }
    
    @IBAction func slFontSize(_ sender: UISlider) {
        print(sender.value)
        let prefs = readPref()
        updatePref(font: prefs!.fontOfTime, color: prefs!.colorOfTime, size: sender.value)
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
