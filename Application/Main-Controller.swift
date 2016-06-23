//
//  Main-Controller.swift
//  twentyfour95 (Code Name Telluride)
//
//  Created by Grant Goodman on 17/06/16.
//  Copyright © 2016 NEOTechnica Corporation. All rights reserved.
//

import UIKit

class MC: UIViewController
{
    //--------------------------------------------------//
    
    //Interface Builder User Interface Elements
    
    //UIButtons
    @IBOutlet weak var buildButton:       UIButton!
    @IBOutlet weak var codeNameButton:    UIButton!
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var ntButton:          UIButton!
    
    //UILabels
    @IBOutlet weak var aGrandTotalOfLabel:           UILabel!
    
    @IBOutlet weak var amountGivenLabel:             UILabel!
    
    @IBOutlet weak var askForLabel:                  UILabel!
    @IBOutlet weak var askForPlaceholderLabel:       UILabel!
    @IBOutlet weak var askForRoundedLabel:           UILabel!
    
    @IBOutlet weak var aTipOfLabel:                  UILabel!
    
    @IBOutlet weak var backLabel:                    UILabel!
    
    @IBOutlet weak var bundleVersionLabel:           UILabel!
    @IBOutlet weak var bundleVersionSubtitleLabel:   UILabel!
    
    @IBOutlet weak var designationLabel:             UILabel!
    @IBOutlet weak var designationSubtitleLabel:     UILabel!
    
    @IBOutlet weak var equalsLabel:                  UILabel!
    
    @IBOutlet weak var grandTotalLabel:              UILabel!
    
    @IBOutlet weak var originalTotalLabel:           UILabel!
    @IBOutlet weak var orSimplyLabel:                UILabel!
    
    @IBOutlet weak var plusLabel:                    UILabel!
    
    @IBOutlet weak var preReleaseNotifierLabel:      UILabel!
    
    @IBOutlet weak var skuLabel:                     UILabel!
    @IBOutlet weak var skuLabelSubtitleLabel:        UILabel!
    
    @IBOutlet weak var titleLabel:                   UILabel!
    
    @IBOutlet weak var topDesignationLabel:           UILabel!
    @IBOutlet weak var topSkuLabel:                  UILabel!
    @IBOutlet weak var topVersionLabel:              UILabel!
    
    @IBOutlet weak var yourTipLabel:                 UILabel!
    @IBOutlet weak var yourTipPlaceholderLabel:      UILabel!
    
    //UIViews
    @IBOutlet weak var firstBorderView:     UIView!
    @IBOutlet weak var secondBorderView:    UIView!
    @IBOutlet weak var thirdBorderView:     UIView!
    @IBOutlet weak var fourthBorderView:    UIView!
    @IBOutlet weak var fifthBorderView:     UIView!
    
    @IBOutlet weak var firstSeparatorView:  UIView!
    @IBOutlet weak var secondSeparatorView: UIView!
    
    //Other Items
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    
    @IBOutlet weak var numberPickerView: UIPickerView!
    
    @IBOutlet weak var originalTotalTextField: UITextField!
    
    @IBOutlet weak var screenShotView: UIView!
    
    @IBOutlet weak var tipOfSegmentedControl: UISegmentedControl!
    
    //--------------------------------------------------//
    
    //Non-Interface Builder Elements
    
    //Array Objects
    var numberArray:   [Int]!
    
    var uploadArray:   [String]! = []
    var uploadedArray: [String]! = []
    
    //Boolean Objects
    var isAdHocDistribution:       Bool!
    var numberIsInvalid:           Bool! = false
    var preReleaseApplication:     Bool!
    var screenShotsToggledOn:      Bool!
    var shouldTakeScreenShot:      Bool!
    var uploadedScreenShot:        Bool! = false
    
    //Integer Objects
    //let buildNumber =                   Int(NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String)! + 1
    let buildNumber =                   Int(NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String)!
    
    var applicationGenerationAsInteger: Int!
    var bugFixReleaseNumber:            Int!
    var minorReleaseNumber:             Int!
    var newFirstNumber:                 Int!
    var versionChoice:                  Int! = 0
    
    //String Objects
    var applicationCodeName:      String!
    var applicationGeneration:    String!
    var applicationSku:           String!
    var currentCaptureLink:       String!
    var developmentState:         String! = "p"
    var formattedVersionNumber:   String!
    var preReleaseNotifierString: String!
    var titleOfSelectedRow:       String!
    
    //Other Objects
    var unformattedGrandTotal: Double!
    
    //--------------------------------------------------//
    
    //Override Functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Be sure to change the values below.
            //The development state of the application.
            //The code name of the application.
            //The value of the pre-release application boolean.
            //The boolean value determining whether or not the application is ad-hoc.
            //The first digit in the formatted version number.
            //The build number string when archiving.
        
        //Make variables declared in the app delegate accesible.
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Set the minor and bug fix release numbers, lifted from the values in the AppDelegate file.
        bugFixReleaseNumber = appDelegate.bugFixReleaseNumber!
        minorReleaseNumber = appDelegate.minorReleaseNumber!
        preReleaseNotifierString = appDelegate.preReleaseNotifierString!
        
        //Declare whether the application is a pre-release version or not, and the project code name.
        applicationCodeName = "Telluride"
        codeNameButton.setTitle("Project Code Name: " + applicationCodeName, forState: .Normal)
        preReleaseApplication = false
        isAdHocDistribution = false
        
        //Declare and set user defaults.
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.objectForKey("buildNumber") != nil
        {
            if buildNumber == userDefaults.objectForKey("buildNumber") as! Int
            {
                shouldTakeScreenShot = false
            }
            else
            {
                if preReleaseApplication == true
                {
                    shouldTakeScreenShot = true
                }
                else
                {
                    shouldTakeScreenShot = false
                }
            }
        }
        else
        {
            if preReleaseApplication == true
            {
                shouldTakeScreenShot = true
            }
            else
            {
                shouldTakeScreenShot = false
            }
        }
        
        if userDefaults.objectForKey("screenShotsToggledOn") != nil
        {
            screenShotsToggledOn = userDefaults.valueForKey("screenShotsToggledOn") as! Bool
        }
        else
        {
            screenShotsToggledOn = false
        }
        
        userDefaults.setValue(buildNumber, forKey: "buildNumber")
        userDefaults.setValue(screenShotsToggledOn, forKey: "screenShotsToggledOn")
        userDefaults.synchronize()
        
        //Prepare various values to be displayed as version information.
        preReleaseNotifierLabel.text = preReleaseNotifierString
        generateSkuAndDesignation()
        
        //Set the SKU and pre-release notifier for the application.
        skuLabelSubtitleLabel.text = applicationSku
        preReleaseNotifierLabel.text = preReleaseNotifierString
        
        //Format the version number for later display.
        formattedVersionNumber = "3." + String(minorReleaseNumber) + "." + String(bugFixReleaseNumber)
        
        //Determine what is displayed on the 'buildButton' button.
        if versionChoice == 0
        {
            buildButton.setTitle(formattedVersionNumber!, forState: UIControlState.Normal)
        }
        else if versionChoice == 1
        {
            buildButton.setTitle(applicationSku!, forState: UIControlState.Normal)
        }
        else if versionChoice == 2
        {
            buildButton.setTitle(formattedVersionNumber, forState: UIControlState.Normal)
            
            self.buildButton.alpha = 0.0
            self.ntButton.alpha = 1.0
        }
        
        //Set the colour of the status bar.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UIApplication.sharedApplication().statusBarHidden = false
        
        //Set the background image for the main view.
        //setBackgroundImageForView(self.view, backgroundImageName: "Background Image")
        
        //Determine what to show or hide depending on what kind of release the current build is designated as.
        if preReleaseApplication == false && isAdHocDistribution == false
        {
            codeNameButton.hidden = true
            informationButton.hidden = true
            preReleaseNotifierLabel.hidden = true
            
            bundleVersionLabel.alpha = 0.0
            bundleVersionSubtitleLabel.alpha = 0.0
            
            designationLabel.alpha = 0.0
            designationSubtitleLabel.alpha = 0.0
            
            skuLabel.alpha = 0.0
            skuLabelSubtitleLabel.alpha = 0.0
            
            buildButton.hidden = false
            ntButton.hidden = false
        }
        else
        {
            bundleVersionLabel.alpha = 0.0
            bundleVersionSubtitleLabel.alpha = 0.0
            
            designationLabel.alpha = 0.0
            designationSubtitleLabel.alpha = 0.0
            
            skuLabel.alpha = 0.0
            skuLabelSubtitleLabel.alpha = 0.0
        }
        
        //Determine the application version number and display it on the 'bundleVersionSubtitleLabel' label.
        let applicationVersionNumber = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        bundleVersionSubtitleLabel.text = applicationVersionNumber
        
        //Set the 'uploadArray' array to the array of files in the local documents folder.
        uploadArray = arrayOfFilesInDocumentsFolder()
        
        //Set the proposed web link to the current capture.
        currentCaptureLink = "http://www.grantbrooksgoodman.io/APPLICATIONS/\(applicationCodeName.uppercaseString)/\(applicationSku)"
        
        numberArray = (1...100).map { $0 }
        
        originalTotalTextField.layer.borderWidth = 3
        originalTotalTextField.layer.cornerRadius = 4
        originalTotalTextField.attributedPlaceholder = NSAttributedString(string: "$24.95",
                                                                          attributes:[NSForegroundColorAttributeName: colorWithHexString("3c4a4f")])
        originalTotalTextField.font = UIFont(name: "DS-Digital", size: 16)
        originalTotalTextField.layer.borderColor = colorWithHexString("3c4a4f").CGColor
        originalTotalTextField.addTarget(self, action: #selector(MC.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        firstBorderView.alpha = 0.0
        secondBorderView.alpha = 0.0
        thirdBorderView.alpha = 0.0
        fifthBorderView.alpha = 0.0
        plusLabel.alpha = 0.0
        equalsLabel.alpha = 0.0
        secondSeparatorView.alpha = 0.0
        
        firstBorderView.layer.borderWidth = 3
        firstBorderView.layer.cornerRadius = 4
        firstBorderView.layer.borderColor = colorWithHexString("3c4a4f").CGColor
        
        secondBorderView.layer.borderWidth = 3
        secondBorderView.layer.cornerRadius = 4
        secondBorderView.layer.borderColor = colorWithHexString("3c4a4f").CGColor
        
        thirdBorderView.layer.borderWidth = 3
        thirdBorderView.layer.cornerRadius = 4
        thirdBorderView.layer.borderColor = colorWithHexString("3c4a4f").CGColor
        
        fourthBorderView.layer.borderWidth = 3
        fourthBorderView.layer.cornerRadius = 4
        fourthBorderView.layer.borderColor = colorWithHexString("3c4a4f").CGColor
        
        fifthBorderView.layer.borderWidth = 3
        fifthBorderView.layer.cornerRadius = 4
        fifthBorderView.layer.borderColor = colorWithHexString("3c4a4f").CGColor
        
        numberPickerView.layer.borderWidth = 3
        numberPickerView.layer.cornerRadius = 4
        numberPickerView.layer.borderColor = colorWithHexString("3c4a4f").CGColor
        
        tipOfSegmentedControl.layer.borderWidth = 3
        tipOfSegmentedControl.layer.cornerRadius = 4
        tipOfSegmentedControl.clipsToBounds = true
        tipOfSegmentedControl.layer.borderColor = colorWithHexString("3c4a4f").CGColor
        
        originalTotalTextField.becomeFirstResponder()
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(detectTextFieldState), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        topVersionLabel.text = formattedVersionNumber
        topSkuLabel.text = applicationSku
        topDesignationLabel.text = designationSubtitleLabel.text!
        
        if shouldTakeScreenShot == true || uploadArray.count > 0
        {
            if preReleaseApplication == true
            {
                NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: #selector(screenShot), userInfo: nil, repeats: false)
            }
            else
            {
                screenShotView.hidden = true
            }
        }
        else
        {
            screenShotView.hidden = true
        }
    }
    
    //--------------------------------------------------//
    
    //Interface Builder Actions
    
    @IBAction func buildButton(sender: AnyObject)
    {
        //Determine what to display for each setting of the build button.
        if buildButton.titleLabel!.text == formattedVersionNumber
        {
            buildButton.setTitle(applicationSku, forState: UIControlState.Normal)
            versionChoice = 1
        }
        else if buildButton.titleLabel!.text == applicationSku
        {
            buildButton.setTitle(formattedVersionNumber, forState: UIControlState.Normal)
            versionChoice = 2
            
            self.buildButton.alpha = 0.0
            
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    self.ntButton.alpha = 1.0
                    
                }, completion: nil)
        }
    }
    
    @IBAction func codeNameButton(sender: AnyObject)
    {
        if designationLabel.alpha == 0.0
        {
            //Animate the display of various elements of the view.
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    self.bundleVersionLabel.alpha = 1.0
                    self.bundleVersionSubtitleLabel.alpha = 1.0
                    
                    self.designationLabel.alpha = 1.0
                    self.designationSubtitleLabel.alpha = 1.0
                    
                    self.skuLabel.alpha = 1.0
                    self.skuLabelSubtitleLabel.alpha = 1.0
                    
                }, completion: nil)
        }
        else
        {
            //Animate the hide of various elements of the view.
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    self.bundleVersionLabel.alpha = 0.0
                    self.bundleVersionSubtitleLabel.alpha = 0.0
                    
                    self.designationLabel.alpha = 0.0
                    self.designationSubtitleLabel.alpha = 0.0
                    
                    self.skuLabel.alpha = 0.0
                    self.skuLabelSubtitleLabel.alpha = 0.0
                    
                }, completion: nil)
        }
    }
    
    @IBAction func informationButton(sender: AnyObject)
    {
        //Declare various values.
        var developmentStage: String!
        
        //Determine and set the reported development stage, depending on the state of various prerequisites.
        if buildNumber < 100
        {
            developmentStage = "a pre-alpha"
        }
        else if buildNumber < 1000 && buildNumber > 100
        {
            developmentStage = "an alpha"
        }
        else if buildNumber >= 1000
        {
            developmentStage = "a beta"
        }
        
        //Determine and set the reported development state, depending on the state of various prerequisites.
        if developmentState == "i"
        {
            developmentState = "for use by internal developers only"
        }
        else if developmentState == "p"
        {
            developmentState = "for limited outside user testing"
        }
        
        //Declare, set, and display the 'informationAlertController' alert controller.
        let informationAlertController = UIAlertController(title: "Project \(applicationCodeName.capitalizedString)", message: "This is \(developmentStage) version of project code name \(applicationCodeName).\n\nThis version is meant \(developmentState).\n\nAll features presented here are subject to change, and any new or previously undisclosed information presented within this software is to remain strictly confidential.\n\nRedistribution of this software by unauthorised parties in any way, shape, or form is strictly prohibited.\n\nBy continuing your use of this software, you acknowledge your agreement to the above terms.", preferredStyle: UIAlertControllerStyle.Alert)
        informationAlertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        
        if uploadedScreenShot == true
        {
            informationAlertController.addAction(UIAlertAction(title: "View Current Online Capture", style: .Default, handler: { (action: UIAlertAction!) in
                UIApplication.sharedApplication().openURL(NSURL(string: "\(self.currentCaptureLink).png")!)
            }))
        }
        
        if screenShotsToggledOn == true
        {
            informationAlertController.addAction(UIAlertAction(title: "Disable Self-Capture", style: .Destructive, handler: { (action: UIAlertAction!) in
                self.screenShotsToggledOn = false
                NSUserDefaults.standardUserDefaults().setValue(self.screenShotsToggledOn, forKey: "screenShotsToggledOn")
                NSUserDefaults.standardUserDefaults().synchronize()
            }))
        }
        else
        {
            informationAlertController.addAction(UIAlertAction(title: "Enable Self-Capture", style: .Default, handler: { (action: UIAlertAction!) in
                self.screenShotsToggledOn = true
                NSUserDefaults.standardUserDefaults().setValue(self.screenShotsToggledOn, forKey: "screenShotsToggledOn")
                NSUserDefaults.standardUserDefaults().synchronize()
            }))
        }
        
        self.presentViewController(informationAlertController, animated: true, completion: nil)
    }
    
    @IBAction func longPress(sender: AnyObject)
    {
        //Copy the text of the build button to the clipboard.
        let pasteBoard = UIPasteboard.generalPasteboard()
        pasteBoard.string = buildButton.titleLabel!.text
    }
    
    @IBAction func ntButton(sender: AnyObject)
    {
        //Set the alpha of the 'ntButton' button and version choice.
        self.ntButton.alpha = 0.0
        versionChoice = 0
        
        //Animate the display of the build button.
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
                self.buildButton.alpha = 1.0
                
            }, completion: nil)
    }
    
    @IBAction func tipOfSegmentedControl(sender: AnyObject)
    {
        let originalTotalAsDouble = Double(originalTotalTextField.text!.stringByReplacingOccurrencesOfString("$", withString: "").stringByReplacingOccurrencesOfString(",", withString: ""))
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        currencyFormatter.locale = NSLocale(localeIdentifier: "es_US")
        
        originalTotalTextField.text! = currencyFormatter.stringFromNumber(originalTotalAsDouble!)!
        
        if tipOfSegmentedControl.selectedSegmentIndex == 0
        {
            unformattedGrandTotal = getGrandTotalWith(0.15, originalTotal: originalTotalAsDouble!)
            
            let yourTip = unformattedGrandTotal - originalTotalAsDouble!
            let roundedAmount = round(100.0 * yourTip) / 100.0
            
            yourTipLabel.text = String(currencyFormatter.stringFromNumber(roundedAmount)!)
            
            grandTotalLabel.text = String(currencyFormatter.stringFromNumber(unformattedGrandTotal)!)
        }
        else if tipOfSegmentedControl.selectedSegmentIndex == 1
        {
            unformattedGrandTotal = getGrandTotalWith(0.18, originalTotal: originalTotalAsDouble!)
            
            let yourTip = unformattedGrandTotal - originalTotalAsDouble!
            let roundedAmount = round(100.0 * yourTip) / 100.0
            
            yourTipLabel.text = String(currencyFormatter.stringFromNumber(roundedAmount)!)
            
            grandTotalLabel.text = String(currencyFormatter.stringFromNumber(unformattedGrandTotal)!)
        }
        else if tipOfSegmentedControl.selectedSegmentIndex == 2
        {
            unformattedGrandTotal = getGrandTotalWith(0.20, originalTotal: originalTotalAsDouble!)
            
            let yourTip = unformattedGrandTotal - originalTotalAsDouble!
            let roundedAmount = round(100.0 * yourTip) / 100.0
            
            yourTipLabel.text = String(currencyFormatter.stringFromNumber(roundedAmount)!)
            
            grandTotalLabel.text = String(currencyFormatter.stringFromNumber(unformattedGrandTotal)!)
        }
        else
        {
            print("Invalid segmented control selection.")
        }
        
        originalTotalTextField.resignFirstResponder()
        
        numberPickerView.reloadAllComponents()
        
        if numberPickerView.selectedRowInComponent(0) != 0
        {
            if numberArray.indexOf(Int(titleOfSelectedRow)!) != nil
            {
                numberPickerView.selectRow(numberArray.indexOf(Int(titleOfSelectedRow)!)!, inComponent: 0, animated: false)
            }
        }
        else
        {
            if self.numberArray.count > 3
            {
                self.numberPickerView.selectRow(3, inComponent: 0, animated: true)
            }
        }
        
        pickerView(numberPickerView, didSelectRow: numberPickerView.selectedRowInComponent(0), inComponent: 0)
        
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
                self.firstBorderView.alpha = 1.0
                self.secondBorderView.alpha = 1.0
                self.thirdBorderView.alpha = 1.0
                self.equalsLabel.alpha = 1.0
                self.secondSeparatorView.alpha = 1.0
                
            }, completion: nil)
    }
    
    @IBAction func tapGestureRecogniser(sender: AnyObject)
    {
        originalTotalTextField.resignFirstResponder()
    }
    
    //--------------------------------------------------//
    
    //Inependent Functions
    
    func detectTextFieldState()
    {
        if originalTotalTextField.editing == true
        {
            let desiredPosition = originalTotalTextField.endOfDocument
            originalTotalTextField.selectedTextRange = originalTotalTextField.textRangeFromPosition(desiredPosition, toPosition: desiredPosition)
            
            textFieldDidChange(originalTotalTextField)
        }
    }
    
    func textFieldDidChange(textField: UITextField)
    {
        textField.text! = textField.text!.stringByReplacingOccurrencesOfString("$", withString: "").stringByReplacingOccurrencesOfString(",", withString: "")
        
        if !textField.text!.hasPrefix("$")
        {
            textField.text = "$" + textField.text!
        }
        
        if textField.text!.stringByReplacingOccurrencesOfString("$", withString: "").stringByReplacingOccurrencesOfString(",", withString: "").length > 3 && !textField.text!.containsString(".")
        {
            textField.text = textField.text!.chopSuffix(1)
        }
        
        if textField.text!.containsString(".") && !textField.text!.hasSuffix(".")
        {
            let stringArray = textField.text!.characters.split{$0 == "."}.map(String.init)
            
            let dollarsString = stringArray[0]
            let centsString = stringArray[1]
            
            if centsString.characters.count > 2
            {
                textField.text = textField.text!.chopSuffix(1)
            }
            
            if centsString.characters.count > 3
            {
                textField.text = dollarsString.chopSuffix(1) + "." + centsString
            }
        }
        
        if textField.text! == "$."
        {
            textField.text! = ""
        }
        
        if textField.text! == "$"
        {
            textField.text! = ""
        }
        
        if Double(textField.text!.stringByReplacingOccurrencesOfString("$", withString: "").stringByReplacingOccurrencesOfString(",", withString: "")) > 833.33
        {
            numberIsInvalid = true
        }
        else
        {
            numberIsInvalid = false
        }
        
        if numberIsInvalid == false
        {
            if textField.text! != "$" && textField.text! != ""
            {
                UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                    {
                        if UIScreen.mainScreen().bounds.height == 568 || UIScreen.mainScreen().bounds.height == 480
                        {
                            self.fourthBorderView.frame.origin.x = 0
                        }
                        else
                        {
                            self.fourthBorderView.frame.origin.x = 7
                        }
                        
                        self.fifthBorderView.alpha = 1.0
                        
                        if UIScreen.mainScreen().bounds.height != 568 && UIScreen.mainScreen().bounds.height != 480 && UIScreen.mainScreen().bounds.height != 667
                        {
                            self.plusLabel.alpha = 1.0
                        }
                        
                    }, completion: nil)
            }
            else
            {
                UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                    {
                        if UIScreen.mainScreen().bounds.height == 568 || UIScreen.mainScreen().bounds.height == 480
                        {
                            self.fourthBorderView.frame.origin.x = 82
                        }
                        else
                        {
                            self.fourthBorderView.frame.origin.x = 107
                        }
                        
                        self.firstBorderView.alpha = 0.0
                        self.secondBorderView.alpha = 0.0
                        self.thirdBorderView.alpha = 0.0
                        self.fifthBorderView.alpha = 0.0
                        self.plusLabel.alpha = 0.0
                        self.equalsLabel.alpha = 0.0
                        self.secondSeparatorView.alpha = 0.0
                        self.tipOfSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
                        self.numberPickerView.selectRow(0, inComponent: 0, animated: false)
                        
                    }, completion: nil)
            }
            
            adjustForTotalChange()
        }
        else
        {
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    if UIScreen.mainScreen().bounds.height == 568 || UIScreen.mainScreen().bounds.height == 480
                    {
                        self.fourthBorderView.frame.origin.x = 82
                    }
                    else
                    {
                        self.fourthBorderView.frame.origin.x = 107
                    }
                    
                    self.firstBorderView.alpha = 0.0
                    self.secondBorderView.alpha = 0.0
                    self.thirdBorderView.alpha = 0.0
                    self.fifthBorderView.alpha = 0.0
                    self.plusLabel.alpha = 0.0
                    self.equalsLabel.alpha = 0.0
                    self.secondSeparatorView.alpha = 0.0
                    self.tipOfSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
                    self.numberPickerView.selectRow(0, inComponent: 0, animated: false)
                    
                }, completion: nil)
            
            adjustForTotalChange()
        }
        
        let desiredPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRangeFromPosition(desiredPosition, toPosition: desiredPosition)
        
        if unformattedGrandTotal != nil
        {
            pickerView(numberPickerView, didSelectRow: numberPickerView.selectedRowInComponent(0), inComponent: 0)
        }
    }
    
    func adjustForTotalChange()
    {
        let originalTotalAsDouble = Double(originalTotalTextField.text!.stringByReplacingOccurrencesOfString("$", withString: "").stringByReplacingOccurrencesOfString(",", withString: ""))
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        currencyFormatter.locale = NSLocale(localeIdentifier: "es_US")
        
        if tipOfSegmentedControl.selectedSegmentIndex == 0
        {
            unformattedGrandTotal = getGrandTotalWith(0.15, originalTotal: originalTotalAsDouble!)
            
            let yourTip = unformattedGrandTotal - originalTotalAsDouble!
            let roundedAmount = round(100.0 * yourTip) / 100.0
            
            yourTipLabel.text = String(currencyFormatter.stringFromNumber(roundedAmount)!)
            
            grandTotalLabel.text = String(currencyFormatter.stringFromNumber(unformattedGrandTotal)!)
        }
        else if tipOfSegmentedControl.selectedSegmentIndex == 1
        {
            unformattedGrandTotal = getGrandTotalWith(0.18, originalTotal: originalTotalAsDouble!)
            
            let yourTip = unformattedGrandTotal - originalTotalAsDouble!
            let roundedAmount = round(100.0 * yourTip) / 100.0
            
            yourTipLabel.text = String(currencyFormatter.stringFromNumber(roundedAmount)!)
            
            grandTotalLabel.text = String(currencyFormatter.stringFromNumber(unformattedGrandTotal)!)
        }
        else if tipOfSegmentedControl.selectedSegmentIndex == 2
        {
            unformattedGrandTotal = getGrandTotalWith(0.20, originalTotal: originalTotalAsDouble!)
            
            let yourTip = unformattedGrandTotal - originalTotalAsDouble!
            let roundedAmount = round(100.0 * yourTip) / 100.0
            
            yourTipLabel.text = String(currencyFormatter.stringFromNumber(roundedAmount)!)
            
            grandTotalLabel.text = String(currencyFormatter.stringFromNumber(unformattedGrandTotal)!)
        }
    }
    
    func getGrandTotalWith(tipOf: Double!, originalTotal: Double!) -> Double
    {
        let percentOfTotal = (originalTotal! * tipOf)
        
        let grandTotal = originalTotal! + percentOfTotal
        let roundedAmount = round(100.0 * grandTotal) / 100.0
        
        var nearestDollar = Int(roundedAmount)
        
        if roundedAmount % Double(Int(roundedAmount)) != 0
        {
            nearestDollar = nearestDollar + 1
        }
        
        let twentyPercentOfNumber = originalTotal * 0.20
        
        let maximumGrandTotal = originalTotal! + twentyPercentOfNumber
        let maximumRoundedAmount = round(100.0 * maximumGrandTotal) / 100.0
        
        var maximumNearestDollar = Int(maximumRoundedAmount)
        
        if maximumRoundedAmount % Double(Int(maximumRoundedAmount)) != 0
        {
            maximumNearestDollar = maximumNearestDollar + 1
        }
        
        if (originalTotal + twentyPercentOfNumber) >= 100
        {
            numberArray = (nearestDollar...(maximumNearestDollar + 100)).map { $0 }
            numberPickerView.reloadAllComponents()
        }
        else
        {
            numberArray = (nearestDollar...200).map { $0 }
            numberPickerView.reloadAllComponents()
        }
        
        return roundedAmount
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return numberArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return "\(numberArray[row])"
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView
    {
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "DS-Digital", size: 23)
            pickerLabel?.textColor = colorWithHexString("DCDCE0")
            pickerLabel?.textAlignment = NSTextAlignment.Center
            pickerLabel?.adjustsFontSizeToFitWidth = true
        }
        
        if (numberArray.count - 1) >= row
        {
            pickerLabel?.text = "$" + String(numberArray[row])
        }
        
        return pickerLabel!
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        let titleData = numberArray[row]
        
        let attributedTitle = NSAttributedString(string: "$" + String(titleData), attributes: [NSFontAttributeName: UIFont(name: "DS-Digital", size: 20)!, NSForegroundColorAttributeName: colorWithHexString("DCDCE0")])
        
        return attributedTitle
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (numberArray.count - 1) >= row
        {
            let askForAmountBackDouble = Double(numberArray[row]) - unformattedGrandTotal
            let roundedAmount = round(100.0 * askForAmountBackDouble) / 100.0
            
            titleOfSelectedRow = String(numberArray[row])
            
            let currencyFormatter = NSNumberFormatter()
            currencyFormatter.numberStyle = .CurrencyStyle
            currencyFormatter.locale = NSLocale(localeIdentifier: "es_US")
            
            askForLabel.text = String(currencyFormatter.stringFromNumber(roundedAmount)!)
            
            if String(Int(roundedAmount)) == "0"
            {
                askForRoundedLabel.text = "nothing"
            }
            else
            {
                switch Int(roundedAmount) % 10
                {
                case 1...2:
                    
                    if Int(roundedAmount) != 1 && Int(roundedAmount) != 2
                    {
                        var newNumberAsString = String(Int(roundedAmount)).chopSuffix(1)
                        
                        newNumberAsString = newNumberAsString + "0"
                        
                        askForRoundedLabel.text = "$" + newNumberAsString
                    }
                    else
                    {
                        askForRoundedLabel.text = "$" + String(Int(roundedAmount))
                    }
                    
                case 3...7:
                    var newNumberAsString = String(Int(roundedAmount)).chopSuffix(1)
                    
                    newNumberAsString = newNumberAsString + "5"
                    
                    askForRoundedLabel.text = "$" + newNumberAsString
                    
                case 8...9:
                    
                    var newFirstNumber = Int(roundedAmount) / 10
                    
                    newFirstNumber = newFirstNumber + 1
                    
                    var newNumberAsString = String(newFirstNumber)
                    
                    newNumberAsString = newNumberAsString + "0"
                    
                    askForRoundedLabel.text = "$" + newNumberAsString
                    
                default:
                    askForRoundedLabel.text = "$" + String(Int(roundedAmount))
                }
                
                if Int(askForRoundedLabel.text!.stringByReplacingOccurrencesOfString("$", withString: "").stringByReplacingOccurrencesOfString(",", withString: "")) > numberArray[numberPickerView.selectedRowInComponent(0)]
                {
                    askForRoundedLabel.text! = "$" + String(Int(Double(askForLabel.text!.stringByReplacingOccurrencesOfString("$", withString: "").stringByReplacingOccurrencesOfString(",", withString: ""))!))
                }
            }
        }
    }
    
    func generateSkuAndDesignation()
    {
        //Declare and set the application's build date.
        let applicationBuildDate = NSBundle.mainBundle().infoDictionary!["CFBuildDate"] as! NSDate
        
        //Declare and set the date that the application was compiled.
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ddMM"
        let skuDate: String = dateFormatter.stringFromDate(applicationBuildDate)
        
        //Declare and set the name of the application.
        var applicationName = applicationCodeName
        
        //Format the name of the application for display in the SKU.
        if applicationName.length > 3
        {
            applicationName = applicationName.chopSuffix(applicationName.length - 3)
        }
        else if applicationName.length == 3
        {
            applicationName = applicationName.chopSuffix(applicationName.length)
        }
        
        //Format the build number for the SKU.
        var formattedBuildNumberAsString: String! = String(buildNumber)
        if formattedBuildNumberAsString.length < 4 && formattedBuildNumberAsString.length < 5
        {
            if formattedBuildNumberAsString.length == 1
            {
                formattedBuildNumberAsString = "000" + formattedBuildNumberAsString
            }
            else if formattedBuildNumberAsString.length == 2
            {
                formattedBuildNumberAsString = "00" + formattedBuildNumberAsString
            }
            else if formattedBuildNumberAsString.length == 3
            {
                formattedBuildNumberAsString = "0" + formattedBuildNumberAsString
            }
            
            applicationGeneration = 1.ordinalValue
            applicationGenerationAsInteger = 1
        }
        else if formattedBuildNumberAsString.length == 4
        {
            applicationGeneration = 1.ordinalValue
            applicationGenerationAsInteger = 1
        }
        else if formattedBuildNumberAsString.length >= 5
        {
            let formattedBuildNumberAsStringAsDouble = Double(formattedBuildNumberAsString)
            let firstSubtractedBuildNumber = Int((formattedBuildNumberAsStringAsDouble! / 10000) + 1)
            let secondSubtractedBuildNumber = (firstSubtractedBuildNumber - 1) * 10000
            let thirdSubtractedBuildNumber = secondSubtractedBuildNumber - Int(formattedBuildNumberAsStringAsDouble!)
            
            formattedBuildNumberAsString = String(thirdSubtractedBuildNumber).stringByReplacingOccurrencesOfString("-", withString: "")
            
            if formattedBuildNumberAsString.length == 1
            {
                formattedBuildNumberAsString = "000" + formattedBuildNumberAsString
            }
            else if formattedBuildNumberAsString.length == 2
            {
                formattedBuildNumberAsString = "00" + formattedBuildNumberAsString
            }
            else if formattedBuildNumberAsString.length == 3
            {
                formattedBuildNumberAsString = "0" + formattedBuildNumberAsString
            }
            
            applicationGeneration = String(Int((formattedBuildNumberAsStringAsDouble! / 10000) + 1).ordinalValue)
            applicationGenerationAsInteger = Int((formattedBuildNumberAsStringAsDouble! / 10000) + 1)
        }
        
        //Set the development state designation label text.
        if developmentState == "p" && preReleaseApplication == false
        {
            designationSubtitleLabel.text = "PUB-DIS"
        }
        else if developmentState == "p" && preReleaseApplication == true
        {
            designationSubtitleLabel.text = "PUB-TES"
        }
        else if developmentState == "i" && preReleaseApplication == false
        {
            designationSubtitleLabel.text = "INT-DIS"
        }
        else if developmentState == "i" && preReleaseApplication == true
        {
            designationSubtitleLabel.text = "INT-TES"
        }
        
        //Set the application SKU.
        applicationSku = "\(skuDate)-\(applicationName.uppercaseString)-\(String(applicationGenerationAsInteger) + formattedBuildNumberAsString)"
    }
    
    func setButtonElementsForWhiteRoundedButton(roundedButton: WRB, buttonTitle: String, buttonTarget: String?, buttonEnabled: Bool)
    {
        if buttonEnabled == true
        {
            roundedButton.layer.borderColor = UIColor.whiteColor().CGColor
            roundedButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            roundedButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            
            roundedButton.enabled = true
            roundedButton.userInteractionEnabled = true
        }
        else
        {
            roundedButton.layer.borderColor = UIColor.grayColor().CGColor
            roundedButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            roundedButton.enabled = false
            roundedButton.userInteractionEnabled = false
        }
        
        roundedButton.layer.borderWidth = 1.0
        roundedButton.layer.cornerRadius = 5.0
        roundedButton.alpha = 0.600000023841858
        roundedButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        roundedButton.setTitle(buttonTitle.uppercaseString, forState: UIControlState.Normal)
        
        if buttonTarget != nil
        {
            let buttonTargetSelector: Selector = NSSelectorFromString(buttonTarget!)
            roundedButton.addTarget(self, action: buttonTargetSelector, forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func setButtonElementsForBlackRoundedButton(roundedButton: BRB, buttonTitle: String, buttonTarget: String?, buttonEnabled: Bool)
    {
        if buttonEnabled == true
        {
            roundedButton.layer.borderColor = UIColor.blackColor().CGColor
            roundedButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            roundedButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
            
            roundedButton.enabled = true
            roundedButton.userInteractionEnabled = true
        }
        else
        {
            roundedButton.layer.borderColor = UIColor.grayColor().CGColor
            roundedButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            roundedButton.enabled = false
            roundedButton.userInteractionEnabled = false
        }
        
        roundedButton.layer.borderWidth = 1.0
        roundedButton.layer.cornerRadius = 5.0
        roundedButton.alpha = 0.600000023841858
        roundedButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        roundedButton.setTitle(buttonTitle.uppercaseString, forState: UIControlState.Normal)
        
        if buttonTarget != nil
        {
            let buttonTargetSelector: Selector = NSSelectorFromString(buttonTarget!)
            roundedButton.addTarget(self, action: buttonTargetSelector, forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func getDocumentsDirectory() -> NSString
    {
        let searchPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = searchPaths[0]
        
        return documentsDirectory
    }
    
    func removeItemFromDocumentsFolder(itemName: String)
    {
        do
        {
            try NSFileManager.defaultManager().removeItemAtPath("\(getDocumentsDirectory())/\(itemName)")
        }
        catch let occurredError as NSError
        {
            print(occurredError.debugDescription)
        }
    }
    
    func arrayOfFilesInDocumentsFolder() -> [String]
    {
        do
        {
            let allItems = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(getDocumentsDirectory() as String)
            
            return allItems
        }
        catch let occurredError as NSError
        {
            print(occurredError.debugDescription)
        }
        
        return []
    }
    
    func screenShot() -> UIImage
    {
        let keyWindowLayer = UIApplication.sharedApplication().keyWindow!.layer
        let mainScreenScale = UIScreen.mainScreen().scale
        
        UIGraphicsBeginImageContextWithOptions(keyWindowLayer.frame.size, false, mainScreenScale);
        
        self.view?.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        
        if screenShotsToggledOn == true
        {
            UIImageWriteToSavedPhotosAlbum(screenShot, nil, nil, nil)
        }
        
        UIGraphicsEndImageContext()
        
        screenShotView.hidden = true
        
        if let pngData = UIImagePNGRepresentation(screenShot)
        {
            let fileName = getDocumentsDirectory().stringByAppendingPathComponent("\(applicationSku).png")
            uploadArray.append("\(applicationSku).png")
            pngData.writeToFile(fileName, atomically: true)
        }
        
        var sessionConfiguration = SessionConfiguration()
        sessionConfiguration.host = "ftp://ftp.grantbrooksgoodman.io/"
        sessionConfiguration.username = "grantgoodman"
        sessionConfiguration.password = "Grantavery123"
        
        let currentSession = Session(configuration: sessionConfiguration)
        
        currentSession.createDirectory("/public_html/APPLICATIONS/\(self.applicationCodeName.uppercaseString)")
        {
            (result, error) -> Void in
            
            if error == nil
            {
                print("Made new directory for application.")
            }
            else
            {
                print("Application directory already exists.")
            }
        }
        
        uploadArray.removeAtIndex(0)
        uploadedArray = uploadArray
        
        for individualObject in uploadArray
        {
            currentSession.upload(NSURL(fileURLWithPath: getDocumentsDirectory().stringByAppendingPathComponent(individualObject)), path: "/public_html/APPLICATIONS/\(self.applicationCodeName.uppercaseString)/\(individualObject)")
            {
                (result, error) -> Void in
                
                if error == nil
                {
                    print("http://www.grantbrooksgoodman.io/APPLICATIONS/\(self.applicationCodeName.uppercaseString)/\(individualObject)")
                    self.removeItemFromDocumentsFolder(individualObject)
                    
                    self.uploadedScreenShot = true
                }
                else
                {
                    print("There was an error while uploading the screen-shot.")
                    print(error!.localizedDescription)
                    
                    self.uploadedScreenShot = false
                }
            }
        }
        
        return screenShot
    }
}

extension MC : UITextFieldDelegate
{
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                                                 replacementString string: String) -> Bool
    {
        let newCharacters = NSCharacterSet(charactersInString: string)
        let boolIsNumber = NSCharacterSet.decimalDigitCharacterSet().isSupersetOfSet(newCharacters)
        
        if boolIsNumber == true
        {
            return true
        }
        else
        {
            if string == "."
            {
                let countdots = textField.text!.componentsSeparatedByString(".").count - 1
                if countdots == 0
                {
                    return true
                }
                else
                {
                    if countdots > 0 && string == "."
                    {
                        return false
                    }
                    else
                    {
                        return true
                    }
                }
            }
            else
            {
                return false
            }
        }
    }
}

extension UISegmentedControl
{
    func removeBorders()
    {
        setBackgroundImage(imageWithColor(UIColor.clearColor()), forState: .Normal, barMetrics: .Default)
        setBackgroundImage(imageWithColor(tintColor!), forState: .Selected, barMetrics: .Default)
        setDividerImage(imageWithColor(UIColor.clearColor()), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)
    }
    
    private func imageWithColor(color: UIColor) -> UIImage
    {
        let imageContextRect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(imageContextRect.size)
        
        let currentContext = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(currentContext, color.CGColor)
        
        CGContextFillRect(currentContext, imageContextRect);
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return resultingImage
    }
}
