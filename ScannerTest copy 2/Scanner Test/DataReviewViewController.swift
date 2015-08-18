//
//  DataReviewViewController.swift
//  Scanner Test
//
//  Created by Brandon Dean on 4/13/15.
//  Copyright (c) 2015 CILS. All rights reserved.
//

import UIKit

class DataReviewViewController: UIViewController {
    
    // Passed in data value from WallMountViewController
    var passedMounting: String!
    
    // Passed in data values form DataEntryViewController
    var passedVTIDNumber: String!
    var passedMacAddress: String!
    var passedCNumber: String!
    var passedSerialNumber: String!
    var passedModelNumber: String!
    var passedLocation: String!
    var passedStockNumber: String!
    var passedCustodian: String!
    var passedRoomNumber: String!
    
    // Labels (to be displayed)
    
    @IBOutlet var labelVTIDNumber: UILabel!
    @IBOutlet var labelMacAddress: UILabel!
    @IBOutlet var labelCNumber: UILabel!
    @IBOutlet var labelSerialNumber: UILabel!
    @IBOutlet var labelCNSNumber: UILabel!
    @IBOutlet var labelLocation: UILabel!
    @IBOutlet var labelStockNumber: UILabel!
    @IBOutlet var labelCustodian: UILabel!
    @IBOutlet var labelRoomNumber: UILabel!
    @IBOutlet var labelMounting: UILabel!
    
    @IBAction func buttonSubmit(sender: UIButton) {
        performSegueWithIdentifier("toFinishedView", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        /* Sets all passed in values */
        if let temp = passedVTIDNumber{
            labelVTIDNumber.text = temp
        }
        if let temp = passedMacAddress{
            labelMacAddress.text = temp
        }
        if let temp = passedCNumber{
            labelCNumber.text = temp
        }
        if let temp = passedSerialNumber{
            labelSerialNumber.text = temp
        }
        if let temp = passedModelNumber{
            labelCNSNumber.text = temp
        }
        if let temp = passedLocation{
            labelLocation.text = temp
        }
        if let temp = passedStockNumber{
            labelStockNumber.text = temp
        }
        if let temp = passedCustodian{
            labelCustodian.text = temp
        }
        if let temp = passedRoomNumber{
            labelRoomNumber.text = temp
        }
        if let temp = passedMounting{
            labelMounting.text = temp
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    -------------------------
    MARK: - Prepare For Segue
    -------------------------
    */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toFinishedView" {
            var finishedViewController: FinishedViewController = segue.destinationViewController as! FinishedViewController
            
            /* Safety wrappers for optional values - to prevent 'nil error' */
            if let temp = passedVTIDNumber{
                finishedViewController.passedVTIDNumber = temp
            }
            if let temp = passedMacAddress{
                finishedViewController.passedMacAddress = temp
            }
            if let temp = passedCNumber{
                finishedViewController.passedCNumber = temp
            }
            if let temp = passedModelNumber{
                finishedViewController.passedCNSNumber = temp
            }
            if let temp = passedSerialNumber{
                finishedViewController.passedSerialNumber = temp
            }
            if let temp = passedLocation{
                finishedViewController.passedLocation = temp
            }
            if let temp = passedStockNumber{
                finishedViewController.passedStockNumber = temp
            }
            if let temp = passedCustodian{
                finishedViewController.passedCustodian = temp
            }
            if let temp = passedRoomNumber{
                finishedViewController.passedRoomNumber = temp
            }
        }
    }

}
