//
//  MainScreenViewController.swift
//  Scanner Test
//
//  Created by Brandon Dean on 4/23/15.
//  Copyright (c) 2015 CILS. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    
    var flag = 0
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var driveScanner: DriveScanner!
   
    /* When clicked, directs user to camera view */
    @IBAction func buttonCamera(sender: UIButton) {
        performSegueWithIdentifier("toCameraView", sender: self)
    }
    
    /* When clicked, directs user to settings view */
    @IBAction func buttonSettings(sender: UIButton) {
        performSegueWithIdentifier("toSettingsView", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driveScanner = appDelegate.scanner
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if flag == 0 {
            driveScanner.setView(self)
            var optionalController = driveScanner.userLogin()
            if var viewController = optionalController {
                self.presentViewController(viewController, animated: true, completion: nil)
                flag = 1
            }
            else {
                driveScanner.retrieveFileContents()
                flag = 1
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(title: String, message: String ) {
        let cancel = "OK"
        println("show Alert")
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle(cancel)
        alert.show()
    }
    
    
    /*
    ---------------------------
    MARK: - Unwind Segue Method
    ---------------------------
    */
    @IBAction func unwindToMainScreenViewController (segue : UIStoryboardSegue) {
        
        if segue.identifier == "Finished-Submit" {
            // Obtain the object reference of the source view controller
            var controller: FinishedViewController = segue.sourceViewController as! FinishedViewController
            /* Upload data to Google Spreadsheet below */
            var fileParser = appDelegate.fileParser
            fileParser.addItem(controller.passedCNumber, serial: controller.passedSerialNumber, mac: controller.passedMacAddress, stock: controller.passedStockNumber, buildID: controller.passedLocation, buildName: controller.passedLocation, abbrev: controller.passedLocation, room: controller.passedRoomNumber, model: controller.passedCNSNumber, description: "")
            fileParser.writeToFile()
            appDelegate.scanner.uploadFile()
            
        }
    }
    

    /*
    -------------------------
    MARK: - Prepare For Segue
    -------------------------
    */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toCameraView" {
            var viewViewController: ViewController = segue.destinationViewController as! ViewController
        }
        else if segue.identifier == "toSettingsView" {
            var settingsViewController: SettingsViewController = segue.destinationViewController as! SettingsViewController
        }
    }

}
