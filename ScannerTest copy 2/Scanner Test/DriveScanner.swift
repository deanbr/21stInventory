//
//  DriveScanner.swift
//  Scanner Test
//
//  Created by Elliot Taylor Garner on 4/28/15.
//  Copyright (c) 2015 CILS. All rights reserved.
//

import Foundation

class DriveScanner : NSObject {
    
    let driveService = GTLServiceDrive()
    var driveFile = GTLDriveFile()
    let fetcher = GTMHTTPFetcher()
    let scopes = "https://www.googleapis.com/auth/drive"
    let fileToRetrieve = "arubawaps.csv"
    var filePathToWriteTo : String!
    let fileNameToWriteTo = "DownloadedFromDrive.csv"
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //google drive keychain information
    let kKeychainItemName: String = "Scanner Test"
    let kClientID : String = "902503430551-3m3prkk6jqtscmkmilri6jh5dm9djav3.apps.googleusercontent.com"
    let kClientSecret : String = "GtZ5HyT0yA2aBJ_2c5zJ8GSZ"
    
    var authController: GTMOAuth2ViewControllerTouch? = nil
    var accessToken: NSString = ""
    var currentViewController: UIViewController!
    
    func userLogin() -> GTMOAuth2ViewControllerTouch? {
        
        self.driveService.authorizer  = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(kKeychainItemName,
            clientID: kClientID,
            clientSecret: kClientSecret)
        authController = createAuthController()
        return authController
    }
    
    
    func retrieveFileContents() {
        if let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0]
             self.filePathToWriteTo = dir.stringByAppendingPathComponent(self.fileNameToWriteTo)
        }
        var query = GTLQueryDrive.queryForFilesList() as! GTLQueryDrive
        self.driveService.executeQuery(query, completionHandler: { (ticket, returnedFile, error) -> Void in
            if error == nil {
                if let fileList = returnedFile as? GTLDriveFileList {
                    var array = fileList.items() as! [GTLDriveFile]
                    var listSize = array.count
                    for var i = 0; i < listSize; i++ {
                        if array[i].originalFilename != nil {
                            if array[i].originalFilename == self.fileToRetrieve {
                                self.driveFile = array[i]
                                var url = array[i].downloadUrl as String
                                var nsurl = NSURL(string: url)
                                var request = NSMutableURLRequest(URL: nsurl!)
                                request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
                                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                                    if error == nil {
                                        var data = NSString(data: data, encoding: NSUTF8StringEncoding)
                                        if let fileData = data {
                                            var error: NSErrorPointer = NSErrorPointer()
                                            var fileExists = NSFileManager.defaultManager().fileExistsAtPath(self.filePathToWriteTo)
                                            fileData.writeToFile(self.filePathToWriteTo, atomically: false, encoding: NSUTF8StringEncoding, error: error)
                                            println(error.debugDescription)
                                            var text = String(contentsOfFile: self.filePathToWriteTo, encoding: NSUTF8StringEncoding, error: nil)
                                            var parser = self.appDelegate.fileParser
                                            parser.addToHash()
                                        }
                                    }
                                    else {
                                        self.authController = self.createAuthController()
                                        self.currentViewController.presentViewController(self.authController!, animated: true, completion: nil)
                                    }
                                })
                            }
                        }
                    }
                }
            }
            else {
                println("executing query")
                self.showAlert("Problem connecting to drive!", message: "Please check your internet connection!")
            }
        })
    }

    func isAuthorized() -> Bool {
        var canAuthorize = (self.driveService.authorizer as! GTMOAuth2Authentication).canAuthorize
        return canAuthorize
    }
    
    // Creates the auth controller for authorizing access to Google Drive.
    func createAuthController() -> GTMOAuth2ViewControllerTouch {
        println("create auth")
        return GTMOAuth2ViewControllerTouch(scope: scopes,
            clientID: kClientID,
            clientSecret: kClientSecret,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: Selector("viewController:finishedWithAuth:error:"))
        
    }
    
    // Handle completion of the authorization process, and updates the Drive service
    // with the new credentials.
    func viewController(viewController: GTMOAuth2ViewControllerTouch , finishedWithAuth authResult: GTMOAuth2Authentication , error:NSError? ) {
        println("view controller")
        if let actualError = error
        {
            self.showAlert("Authentication Error", message:actualError.localizedDescription)
            self.driveService.authorizer = nil
        } else {
            self.driveService.authorizer = authResult
            self.accessToken = authResult.accessToken
            if var viewController = authController {
                viewController.dismissViewControllerAnimated(true, completion: nil)
                println("dismissed")
                retrieveFileContents()
            }
        }
        
    }
    
    func uploadFile() {
        var mimeType = "text/csv"
        var fileHandle = NSFileHandle(forReadingAtPath: self.filePathToWriteTo)
        var uploadParameters = GTLUploadParameters(fileHandle: fileHandle, MIMEType: mimeType)
        var query = GTLQueryDrive.queryForFilesUpdateWithObject(driveFile, fileId: driveFile.identifier, uploadParameters: uploadParameters) as! GTLQueryDrive
        self.driveService.executeQuery(query, completionHandler: { (ticket, updatedFile, error) -> Void in
            println("upload! complete!")
            })
        println("uploading")
    }
    
    func setView(viewController: UIViewController) {
        self.currentViewController = viewController
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
    
}
