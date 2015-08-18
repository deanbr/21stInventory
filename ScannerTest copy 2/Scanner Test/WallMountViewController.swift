//
//  WallMountViewController.swift
//  Scanner Test
//
//  Created by Brandon Dean on 4/13/15.
//  Copyright (c) 2015 CILS. All rights reserved.
//

import UIKit

class WallMountViewController: UIViewController {
    
    // Passed in data values form DataEntryViewController
    var passedVTIDNumber: String!
    var passedMacAddress: String!
    var passedCNumber: String!
    var passedSerialNumber: String!
    var passedCNSNumber: String!
    var passedLocation: String!
    var passedStockNumber: String!
    var passedCustodian: String!
    var passedRoomNumber: String!
    var modelNumber: String!
    
    /* Global variable changed upon  user action */
    var location : String!
    @IBOutlet var textOtherLocation: UITextField!
    
    /* Buttons */
    @IBAction func wallButton(sender: UIButton) {
        location = "Wall"
        modelNumber = "AP-224"
        performSegueWithIdentifier("toDataReview", sender: self)
    }
    
    @IBAction func ceilingButton(sender: UIButton) {
        location = "Ceiling"
        modelNumber = "AP-225"
        performSegueWithIdentifier("toDataReview", sender: self)
    }
    
    @IBAction func buttonSubmit(sender: UIButton) {
        location = textOtherLocation.text
        performSegueWithIdentifier("toDataReview", sender: self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        if segue.identifier == "toDataReview" {
            var dataReviewViewController: DataReviewViewController = segue.destinationViewController as! DataReviewViewController
            //dataReviewViewController.passedMounting = location!
            if let temp = location{
                dataReviewViewController.passedMounting = temp
            }
            /* Safety wrappers for optional values - to prevent 'nil error' */
            if let temp = passedVTIDNumber{
                dataReviewViewController.passedVTIDNumber = temp
            }
            if let temp = passedMacAddress{
                dataReviewViewController.passedMacAddress = temp
            }
            if let temp = passedCNumber{
                dataReviewViewController.passedCNumber = temp
            }
            if let temp = modelNumber{
                dataReviewViewController.passedModelNumber = temp
            }
            if let temp = passedSerialNumber{
                dataReviewViewController.passedSerialNumber = temp
            }
            if let temp = passedLocation{
                dataReviewViewController.passedLocation = temp
            }
            if let temp = passedStockNumber{
                dataReviewViewController.passedStockNumber = temp
            }
            if let temp = passedCustodian{
                dataReviewViewController.passedCustodian = temp
            }
            if let temp = passedRoomNumber{
                dataReviewViewController.passedRoomNumber = temp
            }
        }
       
    }
    

}
