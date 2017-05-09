//
//  TipsCalculatorConfigurations.swift
//  TipCalculator
//
//  Created by Zuoyuan Huang on 5/8/17.
//  Copyright © 2017 Zuoyuan Huang. All rights reserved.
//

import UIKit

private let _sharedInstance = TipsCalculatorConfigurations()

class TipsCalculatorConfigurations: NSObject {
    
    var hasAdd = false
    var displayColor: UIColor?
    var resultColor: UIColor?
    var tipsToShow: [String] = []
    
    class var sharedInstance : TipsCalculatorConfigurations {
        return _sharedInstance
    }
    
    func savePreference() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(tipsToShow, forKey: "tipsToShow")
    }
    
    func loadPreference() {
        let tipsToShowSaved = UserDefaults.standard.array(forKey: "tipsToShow")
        if (tipsToShowSaved == nil) {
            tipsToShow = ["15", "18", "20", "22", "25", "30"]
            savePreference()
        } else {
            tipsToShow = tipsToShowSaved as! [String]
        }
        loadDisplayColor()
        loadResultColor()
    }
    
    func loadDisplayColor() {
        let colorData = UserDefaults.standard.data(forKey: "displayColor")
        if (colorData == nil) {
            displayColor = UIColor.black
        } else {
            displayColor = NSKeyedUnarchiver.unarchiveObject(with: colorData!) as? UIColor
        }
    }
    
    func loadResultColor() {
        let colorData = UserDefaults.standard.data(forKey: "resultColor")
        if (colorData == nil) {
            resultColor = UIColor.red
        } else {
            resultColor = NSKeyedUnarchiver.unarchiveObject(with: colorData!) as? UIColor
        }
    }
    
    func setDisplayColor(color: UIColor) {
        displayColor = color
        var colorData: NSData?
        colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        let userDefaults = UserDefaults.standard
        userDefaults.set(colorData, forKey: "displayColor")
    }
    
    func setResultColor(color: UIColor) {
        resultColor = color
        var colorData: NSData?
        colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        let userDefaults = UserDefaults.standard
        userDefaults.set(colorData, forKey: "resultColor")
    }
    
    func getTipsToShow() -> [String] {
        return tipsToShow
    }
    
    func addRowForAddTemp() {
        hasAdd = true
        tipsToShow.append("Add")
    }
    
    func removeRowForAddTemp() {
        hasAdd = false
        tipsToShow.removeLast()
    }
    
    func remove(at: Int) {
        tipsToShow.remove(at: at)
    }
    
    func appendEmpty() -> Int {
        let index = tipsToShow.count
        if !hasAdd {
            tipsToShow.append("Empty")
            return index + 1
        } else {
            tipsToShow.insert("Empty", at: index - 1)
            return index
        }
    }
    
    func update(at: Int, withData: String) {
        tipsToShow[at] = withData
    }
    
    func clear() {
        tipsToShow = []
    }
    
    func append(withData: String) {
        tipsToShow.append(withData)
    }
    
    func getValue(at: Int) -> String {
        return tipsToShow[at]
    }
    
    func duplicate() -> TipsCalculatorConfigurations {
        let result = TipsCalculatorConfigurations()
        result.hasAdd = hasAdd
        result.displayColor = displayColor
        result.resultColor = resultColor
        result.tipsToShow = tipsToShow
        return result
    }
    
}
