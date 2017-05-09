//
//  TipsCalculatorTableViewController.swift
//  TipCalculator
//
//  Created by Zuoyuan Huang on 5/8/17.
//  Copyright © 2017 Zuoyuan Huang. All rights reserved.
//

import UIKit

class TipsCalculatorTableViewController: UITableViewController {
    
    var prefrenceLoaded = false
    var userInput = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TipsCalculatorConfigurations.sharedInstance.loadPreference()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        typingChanged()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TipsCalculatorConfigurations.sharedInstance.getTipsToShow().count + 1
    }
    
    func typingChanged() {
        let inputField = tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(1) as! UITextField
        userInput = inputField.text!
        updateResults()
    }
    
    func updateResults() {
        for indexPath in tableView.indexPathsForVisibleRows! {
            let row = indexPath.row
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
            if (cell?.reuseIdentifier == "resultCell") {
                let amountLabel = cell?.viewWithTag(4) as! UILabel
                let totalLabel = cell?.viewWithTag(5) as! UILabel
                let tipPercentageString = TipsCalculatorConfigurations.sharedInstance.getValue(at: row-1)
                let tipPercentage = Double(tipPercentageString)! / 100
                let input = Double(userInput)
                if (input == nil) {
                    amountLabel.text = ""
                    totalLabel.text = ""
                } else {
                    amountLabel.text = "+ $" + String(format: "%.2f", tipPercentage * input!)
                    totalLabel.text = "= $" + String(format: "%.2f", input! + tipPercentage * input!)
                }
            }
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }

    
    func configureResultCell(cell: UITableViewCell, at indexPath: IndexPath) {
        let alpha = Double(indexPath.row-1) * (0.9 / Double(TipsCalculatorConfigurations.sharedInstance.getTipsToShow().count))
        let colorLabel = cell.viewWithTag(2) as! UILabel
        let percentageLabel = cell.viewWithTag(3) as! UILabel
        cell.backgroundColor = UIColor.white
        colorLabel.backgroundColor = TipsCalculatorConfigurations.sharedInstance.resultColor?.withAlphaComponent(CGFloat(1-alpha))
        percentageLabel.text = TipsCalculatorConfigurations.sharedInstance.getValue(at: indexPath.row-1) + "%"
        updateResults()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if (indexPath.row == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath)
            cell.backgroundColor = TipsCalculatorConfigurations.sharedInstance.displayColor
            let textField = cell.viewWithTag(1) as! UITextField
            textField.becomeFirstResponder()
            textField.addTarget(self, action: #selector(typingChanged), for: UIControlEvents.editingChanged)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
            configureResultCell(cell: cell, at: indexPath)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        // Configure the cell...

        return cell
    }
    
    @IBAction func unwindToCalculator(segue: UIStoryboardSegue) {
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
