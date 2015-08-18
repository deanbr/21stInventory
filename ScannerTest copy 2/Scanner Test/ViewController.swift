import UIKit
import AVFoundation

// Based on simple barcode scanning demo @ http://www.bowst.com/mobile/simple-barcode-scanning-with-swift/

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    
    /* Global string used to retrieve data associated with barcode
     * Used in captureOutput() and prepareForSegue() functions
     */
    
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var segmentedControlBarcodeType: UISegmentedControl!
    @IBOutlet var buttonProceed: UIButton!
    @IBOutlet var labelInfo: UILabel!
    
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var mine: UIImageView!
    @IBOutlet var myImageView: UIImageView!
    
    var detectionStringGlobal : String! // dummy variable used for testing - TODO: DELETE
    /* Global set to type of bar code being scanned in.  */
    var typeofBarCodeStr : String!
    
    var highlightViewRect = CGRectZero
    
    /* Values to be passed to Data Entry view - set when scanned in */
    var strVTIDNumber: String!
    var strMacAddress: String!
    var strCNumber: String!
    var strSerialNumber: String!
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var fileParser: FileParser21!
    var foundFlag = 0
    var recordToPass: Record!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileParser = self.appDelegate.fileParser
        
        // Allow the view to resize freely
        self.highlightView.autoresizingMask =   UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleBottomMargin |
            UIViewAutoresizing.FlexibleLeftMargin |
            UIViewAutoresizing.FlexibleRightMargin
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 3
        
        // Add it to our controller's view as! a subview.
        self.view.insertSubview(self.highlightView, atIndex:2)
        
        
        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Create a nilable NSError to hand off to the next method.
        // Make sure to use the "var" keyword and not "let"
        var error : NSError? = nil
        
        
        let input : AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
        
        // If our input is not nil then add it to the session, otherwise we're kind of done!
        if input != nil {
            session.addInput(input)
        }
        else {
            // This is fine for a demo, do something real with this in your app. :)
            println("testing")
            println(error)
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        
        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as! AVCaptureVideoPreviewLayer
        previewLayer.frame = self.view.bounds // CGRectMake(60, 250,200, 30)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        // I set "textCNumber" as! the default type of bar code
        typeofBarCodeStr = "textCNumber"
        self.view.addSubview(labelInfo)
        self.view.addSubview(segmentedControlBarcodeType)
        self.view.addSubview(buttonProceed)
        
        // Starts the scanner
        session.startRunning()

        
    }
    
    /*
    -------------------------
    MARK: - Camera
    -------------------------
    */
    // This is called when we find a known barcode type with the camera.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        //var highlightViewRect = CGRectZero
        
        var barCodeObject : AVMetadataObject!
        
        let barCodeTypes = [AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode
        ]
        
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            
            for barcodeType in barCodeTypes {
                
                if metadata.type == barcodeType {
                    barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
                    
                    highlightViewRect = barCodeObject.bounds
                    
                    detectionStringGlobal = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    
                    // Set the corresponding value to what was read from the barcode scanner
                    switch typeofBarCodeStr {
                        
                        case "textVTIDNumber": // VT ID
                            strVTIDNumber = detectionStringGlobal
                        
                        case "textCNumber": // C Number
                            strCNumber = detectionStringGlobal
                            if fileParser.Dict1_Inventory_Record[strCNumber] != nil {
                                self.foundFlag = 1
                                self.recordToPass = self.fileParser.Dict1_Inventory_Record[strCNumber]
                                performSegueWithIdentifier("toDataEntry", sender: self)
                            }
                        
                        case "textSerialNumber": // Serial Number
                            strSerialNumber = detectionStringGlobal
                            if var inventoryNumber = fileParser.Dict2_Serial_Inventory[strSerialNumber] {
                                if fileParser.Dict1_Inventory_Record[inventoryNumber] != nil {
                                    self.foundFlag = 1
                                    self.recordToPass = self.fileParser.Dict1_Inventory_Record[inventoryNumber]
                                    performSegueWithIdentifier("toDataEntry", sender: self)
                                }
                            }
                        
                        case "textMacAddress": // MAC Address
                            strMacAddress = detectionStringGlobal
                            if var inventoryNumber = fileParser.Dict3_Mac_Inventory[strSerialNumber] {
                                if fileParser.Dict1_Inventory_Record[inventoryNumber] != nil {
                                    self.foundFlag = 1
                                    self.recordToPass = self.fileParser.Dict1_Inventory_Record[inventoryNumber]
                                    performSegueWithIdentifier("toDataEntry", sender: self)
                                }
                            }
                        
                        default:
                            return
                    }
                    
                    self.session.stopRunning()
                    break
                }
                
            }
        }
        
        /* 
         * Displays a green rectangle showing the scanned surface for
         * 0.8 seconds, then removes it and starts the camera again.
        */
        self.highlightView.frame = highlightViewRect
        self.view.addSubview(self.highlightView)
        self.view.bringSubviewToFront(self.highlightView)
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: Selector("removeScannedRectangle"), userInfo: nil, repeats: false)
    }
    
    func removeScannedRectangle(){
        //self.highlightView.sendSubviewToBack(self.highlightView)
        self.highlightView.removeFromSuperview()
        self.session.startRunning()
    }
    
    /*
    -------------------------
    MARK: - Set Barcode
    -------------------------
    */
    @IBAction func setBarcodeType(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            
        case 0: // VT ID
            typeofBarCodeStr = "textVTIDNumber"
            
        case 1: // C Number
            typeofBarCodeStr = "textCNumber"
            
        case 2: // Serial Number
            typeofBarCodeStr = "textSerialNumber"
            
        case 3: // MAC Address
            typeofBarCodeStr = "textMacAddress"
            
        default:
            return
        }
    }
    
    /*
    -----------------------------
    MARK: - Go to Data Entry view
    -----------------------------
    */
    @IBAction func goToNextView(sender: UIButton) {
        performSegueWithIdentifier("toDataEntry", sender: self)
        
    }
    
    /*
    -------------------------
    MARK: - Prepare For Segue
    -------------------------
    */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toDataEntry" {
            var dataEntryViewController: DataEntryViewController = segue.destinationViewController as! DataEntryViewController
            
            if foundFlag == 1 {
                var recordString = self.recordToPass.str
                dataEntryViewController.passedCNumber = recordString[0]
                dataEntryViewController.passedSerialNumber = recordString[1]
                dataEntryViewController.passedMacAddress = recordString[2]
                dataEntryViewController.passedBuildingName = recordString[4]
                dataEntryViewController.passedStockNumber = recordString[8]
                dataEntryViewController.passedRoomNumber = recordString[6]
            }
            
            /* Safety wrappers for optional values - to prevent 'nil error' */
            if let temp = strVTIDNumber{
                dataEntryViewController.passedVTIDNumber = temp
            }
            if let temp = strCNumber{
                dataEntryViewController.passedCNumber = temp
            }
            if let temp = strMacAddress{
                dataEntryViewController.passedMacAddress = temp
            }
            if let temp = strSerialNumber{
                dataEntryViewController.passedSerialNumber = temp
            }
        }
    }
    
    
}