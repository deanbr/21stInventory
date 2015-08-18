//
//  FinishedViewController.swift
//  Scanner Test
//
//  Created by Brandon Dean on 4/22/15.
//  Copyright (c) 2015 CILS. All rights reserved.
//

import UIKit

class FinishedViewController: UIViewController {

    // Passed in data values form DataReviewViewController
    
    var passedVTIDNumber: String!
    var passedMacAddress: String!
    var passedCNumber: String = ""
    var passedSerialNumber: String!
    var passedCNSNumber: String = ""
    var passedLocation: String!
    var passedStockNumber: String!
    var passedCustodian: String!
    var passedRoomNumber: String!
    var passedMounting: String = ""

    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //performSegueWithIdentifier("toHomeView", sender: self)
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
        
        if segue.identifier == "toHomeView" {
            var mainScreenViewController: MainScreenViewController = segue.destinationViewController as! MainScreenViewController
        }
    }

}
