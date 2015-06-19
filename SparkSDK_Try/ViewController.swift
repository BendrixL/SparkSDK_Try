//
//  ViewController.swift
//  SparkSDK_Try
//
//  Created by Bendrix Bailey on 5/22/15.
//  Copyright (c) 2015 Bendrix Bailey. All rights reserved.
//
// IMPORTANT NOTE:  !!!!!!
//
// At SparkCloud.sharedInstance().loginWihtUser supply your username and passwor
//
// At SparkCloud.sharedInstance()getDevices  supply the name of the core/photon at if device.name ==
//
//  If you want to combine functions under one button, it is OK to combine the login and getDevice, however, don't 
//  run the get variable or function until you've returned with a valid device, or it will crash.
//
//  Also, if you put the function and variable closures in teh same block of code, the variable will be read before
//  the function is run.  You'll have a race condition where it appears the variable is one step behind the function call.
//
//  Run just as is, the code all works.  Have fun!
//
//  I have a new IOS project in the works to use core data and a setup screen to store username, password and core name so they
//  do not have to be hard coded in.  I'll put it up when I'ts running.
//

import UIKit

class ViewController: UIViewController {
    
    var myPhoton : SparkDevice?
    var logInOK = false
    var deviceOK = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }  // End of viewDidLoad
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var getDeviceLabel: UILabel!
    
    @IBOutlet weak var getTempLabel: UILabel!
    
    @IBOutlet weak var getLightLabel: UILabel!
    
    @IBOutlet weak var lightStateLabel: UILabel!
    
    
    @IBAction func login(sender: AnyObject) {  //  Log into the Spark cloud with email address and password
        
        SparkCloud.sharedInstance().loginWithUser("your_user_email_address", password: "your_password") { (error:NSError!) -> Void in
            if let e=error {
                self.loginLabel.text = "Login Failed"
            }
            else {
                self.loginLabel.text = "Logged in"
                self.logInOK = true
            }
        }
    }
    
    
    @IBAction func getDevice(sender: AnyObject) {  // ------  Attempt connection to the Core device
        
        if logInOK {
            SparkCloud.sharedInstance().getDevices { (sparkDevices:[AnyObject]!, error:NSError!) -> Void in
                if let e = error {
                    println("Check your internet connectivity")
                }
                else {
                    if let devices = sparkDevices as? [SparkDevice] {
                        //println(sparkDevices)
                        for device in devices {
                            if device.name == "your_core_name" {
                                self.getDeviceLabel.text = device.name
                                self.myPhoton = device
                                self.deviceOK = true
                            }
                        }
                    }
                }
            }
        } else {
            getDeviceLabel.text = "Plese log in first"
        }
        
        //println(myPhoton)
    }
    
    @IBAction func getTemp(sender: AnyObject) { // ------ Get the value of the Temp variable
        
        if deviceOK {
            myPhoton!.getVariable("Temp", completion: { (result:AnyObject!, error:NSError!) -> Void in
                if let e = error {
                    self.getTempLabel.text = "Failed reading temp"
                } else {
                    if let res = result as? Float {
                        self.getTempLabel.text = "Temperature is \(res) degrees"
                    }
                }
            })
        } else {
            getTempLabel.text = "Login and get device first"
        }
    }
    
    
    @IBAction func getLight(sender: AnyObject) {  // ---------  Get value of Light variable
        
        if deviceOK {
            myPhoton!.getVariable("Light", completion: { (result:AnyObject!, error:NSError!) -> Void in
                if let e = error {
                    self.getLightLabel.text = "Failed reading light"
                }
                else {
                    if let res = result as? Float {
                        self.getLightLabel.text = "Light level is \(res) lumens"
                    }
                }
            })
        } else {
            getLightLabel.text = "Login and get device first"
        }
    }
    
    
    @IBAction func lightOn(sender: AnyObject) {  //  ----------- Set digital bit to turn LED on
        
        if deviceOK {
            let funcArgs = [1]
            myPhoton!.callFunction("lightLed0", withArguments: funcArgs) { (resultCode : NSNumber!, error : NSError!) -> Void in
                if (error == nil) {
                    self.lightStateLabel.text = "LED is on"
                }
            }
        } else {
            lightStateLabel.text = "Login and get device first"
        }
    }
    
    
    @IBAction func lightOff(sender: AnyObject) {  //  ----------- Set digital bit to turn LED off
        
        if deviceOK {
            let funcArgs = [0]
            myPhoton!.callFunction("lightLed0", withArguments: funcArgs) { (resultCode : NSNumber!, error : NSError!) -> Void in
                if (error == nil) {
                    self.lightStateLabel.text = "LED is off"
                }
            }
        } else {
            lightStateLabel.text = "Login and get device first"
        }
    }
    
    // -------------  Function to encapsulate the retrieval of the Light variable
    
    func myGetLight()  {
        myPhoton!.getVariable("Light", completion: { (result:AnyObject!, error:NSError!) -> Void in
            if let e = error {
                self.getLightLabel.text = "Failed reading light"
            }
            else {
                if let res = result as? Float {
                    self.getLightLabel.text = "Light level is \(res) lumens"
                }
                dispatch_async(dispatch_get_main_queue()) {  // dispatch forces this que to run without dealay
                }
            }
        })
    }
    
    

}  // End of Class ViewController -----------



//  Get a list of a specific devicd exposed functions and variables

//        let myDeviceVariables : Dictionary? = myPhoton.variables as? Dictionary<String,String>
//        println("MyDevice first Variable is called \(myDeviceVariables!.keys.first) and is from type \(myDeviceVariables?.values.first)")
//
//        let myDeviceFunction = myPhoton.functions
//        println("MyDevice first function is called \(myDeviceFunction!.first)")

//  Get an instance of a specific device by its ID:

//        var myOtherDevice : SparkDevice? = nil
//        SparkCloud.sharedInstance().getDevice("53fa73265066544b16208184", completion: { (device:SparkDevice!, error:NSError!) -> Void in
//            if let d = device {
//                myOtherDevice = d
//            }
//        })

//  Rename a device
//
//        myPhoton!.name = "myNewDeviceName"
//        //or
//
//        myPhoton!.rename("myNewDeviceName", completion: { (error:NSError!) -> Void in
//            if (error == nil) {
//                println("Device successfully renamed")
//            }
//        })
//

// Logoout and clear a user session

//        SparkCloud.sharedInstance().logout()


//                            println("myPhoton")
//                            println(self.myPhoton)
//                            println(device.variables)
//                            println(device.functions)







