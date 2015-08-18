//
//  DataEntryViewController.swift
//  Scanner Test
//
//  Created by Brandon Dean on 4/13/15.
//  Copyright (c) 2015 CILS. All rights reserved.
//

import UIKit

class DataEntryViewController: UIViewController {
    
    /* Reads in all passed values from barcode scanner view */
    var passedVTIDNumber: String!
    var passedMacAddress: String!
    var passedCNumber: String!
    var passedSerialNumber: String!
    var passedBuildingName: String!
    var passedRoomNumber: String!
    var passedStockNumber: String!
    var passedModelNumber: String!
    
    // (ex: VT000341304)
    @IBOutlet var textVTIDNumber: UITextField!
    // (ex: 186472CAA34A)
    @IBOutlet var textMacAddress: UITextField!
    // Also known as Inventory Number (ex: C80549)
    @IBOutlet var textCNumber: UITextField!
    // (ex: CT0116754)
    @IBOutlet var textSerialNumber: UITextField!
    // The building the device is located (ex: McBryde Hall)
    @IBOutlet var textLocation: UITextField!
    // (ex: E-1409)
    @IBOutlet var textStockNumber: UITextField!
    // (ex: RKELLER)
    @IBOutlet var textCustodian: UITextField!
    // (ex: 328)
    @IBOutlet var textRoomNumber: UITextField!
    
    /* When clicked, perform segue to next view */
    @IBAction func buttonSubmit(sender: UIButton) {
        performSegueWithIdentifier("toWallMount", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Sets all passed in values */
        if let temp = passedCNumber{
            textCNumber.text = temp
        }
        if let temp = passedVTIDNumber{
            textVTIDNumber.text = temp
        }
        if let temp = passedMacAddress{
            textMacAddress.text = temp
        }
        if let temp = passedSerialNumber{
            textSerialNumber.text = temp
        }
        if let temp = passedBuildingName {
            textLocation.text = temp
        }
        if let temp = passedRoomNumber {
            textRoomNumber.text = temp
        }
        if let temp = passedStockNumber {
            textStockNumber.text = temp
        }
        //println("Passed in value from barcode: \(passedScannedValue)")
        
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
        
        if segue.identifier == "toWallMount" {
            var wallMountViewController: WallMountViewController = segue.destinationViewController as! WallMountViewController
            
            /* Entered values will be passed to "review" view to be checked by user */
            
            /* Safety wrappers for optional values - to prevent 'nil error' */
            if let temp = textVTIDNumber.text{
                wallMountViewController.passedVTIDNumber = temp
            }
            if let temp = textMacAddress.text{
                wallMountViewController.passedMacAddress = temp
            }
            if let temp = textCNumber.text{
                wallMountViewController.passedCNumber = temp
            }
            if let temp = textSerialNumber.text{
                wallMountViewController.passedSerialNumber = temp
            }
            if let temp = textLocation.text{
                wallMountViewController.passedLocation = temp
            }
            if let temp = textStockNumber.text{
                wallMountViewController.passedStockNumber = temp
            }
            if let temp = textCustodian.text{
                wallMountViewController.passedCustodian = temp
            }
            if let temp = textRoomNumber.text{
                wallMountViewController.passedRoomNumber = temp
            }
            
        }
    }

}
