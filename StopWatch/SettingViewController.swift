//
//  SettingViewController.swift
//  StopWatch
//
//  Created by yoonbumtae on 2020/03/03.
//  Copyright © 2020 BGSMM. All rights reserved.
//

import UIKit

var availableFontList = [String]()

class SettingViewController: UIViewController {
    
    // RRGGBB hex colors in the same order as the image
    let colorArray = [ 0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0, 0xbf0199, 0xffffff ]

    @IBOutlet var slFontSize: UISlider!
    @IBOutlet var slFontColor: UISlider!
    @IBOutlet var selectedColorView: UIView!
    @IBOutlet var pkvFontList: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        slFontSize.maximumValue = 70
        slFontSize.minimumValue = 20
        
        // get all font list
        for family in UIFont.familyNames {
            print("\(family)")
            availableFontList.append(family)
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print("\t\(name)")
            }
        }
        
        availableFontList.sort()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let prefs = readPref()
        
        slFontSize.setValue(prefs!.sizeOfTime, animated: false)
        
        if let i = colorArray.firstIndex(where: {$0 == prefs!.colorOfTime}) {
            slFontColor.setValue(Float(i), animated: false)
            selectedColorView.backgroundColor = UIColorFromHex(rgbValue: prefs!.colorOfTime)
        }
        
        if let i = availableFontList.firstIndex(where: {$0 == prefs!.fontOfTime}) {
            pkvFontList.selectRow(i, inComponent: 0, animated: false)
        }
        
    }
    
    @IBAction func slFontSize(_ sender: UISlider) {
        // print(sender.value)
        let prefs = readPref()
        updatePref(font: prefs!.fontOfTime, color: prefs!.colorOfTime, size: sender.value)
    }
    
    @IBAction func slFontColor(_ sender: UISlider) {
        selectedColorView.backgroundColor = UIColorFromHex(rgbValue: colorArray[Int(sender.value)])
        // print(sender.value, Int(sender.value))
        
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

extension SettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableFontList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let prefs = readPref()
        updatePref(font: availableFontList[row], color: prefs!.colorOfTime, size: prefs!.sizeOfTime)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont(name: availableFontList[row], size: CGFloat(20))
        pickerLabel.text = availableFontList[row]
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    
    
}
