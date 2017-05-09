//
//  SettingsTableViewController.swift
//  TipCalculator
//
//  Created by Zuoyuan Huang on 5/8/17.
//  Copyright © 2017 Zuoyuan Huang. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var editingTable = false
    var colorRows = [0, 0]
    
    var previousConfig = TipsCalculatorConfigurations.sharedInstance.duplicate()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBAction func editClicked(_ sender: Any) {
        if (!editingTable) {
            editButton.title = "Done"
            editingTable = true
            previousConfig.addRowForAddTemp()
            tableView.insertRows(at: [IndexPath(row: previousConfig.getTipsToShow().count-1, section: 0)], with: UITableViewRowAnimation.automatic)
            // TipsCalculatorConfigurations.sharedInstance.removeRowForAddTemp()
            tableView.setEditing(!tableView.isEditing, animated: true)
        } else {
            editButton.title = "Edit"
            editingTable = false
            previousConfig.removeRowForAddTemp()
            tableView.deleteRows(at: [IndexPath(row: tableView.numberOfRows(inSection: 0)-1, section: 0)], with: UITableViewRowAnimation.automatic)
            tableView.setEditing(!tableView.isEditing, animated: true)
            storeNewCells()
            TipsCalculatorConfigurations.sharedInstance.tipsToShow = previousConfig.tipsToShow
            TipsCalculatorConfigurations.sharedInstance.savePreference()
            // tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return "Tips amount displayed"
        case 1:
            return "Appearence"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (section == 0) {
            return "Add, remove or change the order of how tips amount are displayed by clicking \"Edit\" on the top-right corner"
        } else if (section == 1) {
            return "Tips Calculator by Zuoyuan Huang"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return previousConfig.getTipsToShow().count
        case 1:
            return colorRows.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (indexPath.row == tableView.numberOfRows(inSection: 0) - 1) {
            return UITableViewCellEditingStyle.insert
        }
        return UITableViewCellEditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == 0) {
            return true
        }
        return false
    }
    
    func storeNewCells() {
        previousConfig.clear()
        var toRemove: [IndexPath] = []
        for row in 0...tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
            if cell?.reuseIdentifier == "newValueCell" {
                let text = cell?.viewWithTag(1) as! UITextField
                text.isUserInteractionEnabled = false
                let tmp = Double(text.text!)
                if (tmp == nil) {
                    toRemove.append(IndexPath(row: row, section: 0))
                    continue
                }
                previousConfig.append(withData: text.text!)
            } else if cell?.reuseIdentifier == "tipsAmountCell" {
                let label = cell?.viewWithTag(1) as! UILabel
                previousConfig.append(withData: label.text!)
            }
        }
        if (toRemove.count != 0) {
            tableView.deleteRows(at: toRemove, with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row == tableView.numberOfRows(inSection: 0) - 1) {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            previousConfig.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        case .insert:
            previousConfig.appendEmpty()
            tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        default:
            return
        }
    }
    
    func formatColorCell(cell: UITableViewCell, at indexPath: IndexPath) {
        let label = cell.viewWithTag(1) as! UILabel
        let colorView = cell.viewWithTag(2) as! UITextField
        if (indexPath.row == 0) {
            label.text = "Input Box Color"
            colorView.backgroundColor = TipsCalculatorConfigurations.sharedInstance.displayColor
        } else {
            label.text = "Result Box Color"
            colorView.backgroundColor = TipsCalculatorConfigurations.sharedInstance.resultColor
        }
    }
    
    func colorButtonTapped(sender: UIButton!) {
        let configuredCell = tableView.cellForRow(at: (IndexPath(row: (tableView.indexPath(for: (sender.superview?.superview as! UITableViewCell))?.row)!-1, section: 1)))
        (configuredCell?.viewWithTag(2) as! UITextField).backgroundColor = sender.backgroundColor
        if ((configuredCell?.viewWithTag(1) as! UILabel).text == "Input Box Color") {
            TipsCalculatorConfigurations.sharedInstance.setDisplayColor(color: sender.backgroundColor!)
        } else {
            TipsCalculatorConfigurations.sharedInstance.setResultColor(color: sender.backgroundColor!)
        }
    }
    
    func configColorSelectionCell(cell: UITableViewCell, at indexPath: IndexPath) {
        for i in 1...9 {
            let colorButton = cell.viewWithTag(i) as! UIButton
            colorButton.addTarget(self, action: #selector(colorButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath)?.reuseIdentifier == "colorCell") {
            colorRows.insert(1, at: indexPath.row+1)
            tableView.insertRows(at: [IndexPath(row: indexPath.row+1, section: indexPath.section)], with: UITableViewRowAnimation.automatic)
            tableView.cellForRow(at: indexPath)?.isUserInteractionEnabled = false
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let config = previousConfig.getTipsToShow()
        var cell: UITableViewCell
                
        if (indexPath.section == 0) {
            let text = config[indexPath.row]
            if (text == "Empty") {
                cell = tableView.dequeueReusableCell(withIdentifier: "newValueCell", for: indexPath)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "tipsAmountCell", for: indexPath)
                let label = cell.viewWithTag(1) as! UILabel
                label.text = text
            }
        } else {
            if (colorRows[indexPath.row] == 1) {
                cell = tableView.dequeueReusableCell(withIdentifier: "colorSelectionCell", for: indexPath)
                configColorSelectionCell(cell: cell, at: indexPath)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath)
                formatColorCell(cell: cell, at: indexPath)
            }
        }

        cell.selectionStyle = UITableViewCellSelectionStyle.none

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
