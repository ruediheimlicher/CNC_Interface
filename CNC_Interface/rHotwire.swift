//
//  rHotwire.swift
//  CNC_Interface
//
//  Created by Ruedi Heimlicher on 01.07.2022.
//  Copyright © 2022 Ruedi Heimlicher. All rights reserved.
//

import Cocoa

class rHotwire: rViewController 
{
      
   var hintergrundfarbe:NSColor = NSColor()
   
   override func viewDidAppear() 
   {
      print ("Hotwire viewDidAppear ")
  
     }
   
  
   
   
   override func viewDidLoad() 
    {
        super.viewDidLoad()
        // Do view setup here.
      self.view.window?.acceptsMouseMovedEvents = true
      //let view = view[0] as! NSView
      self.view.wantsLayer = true
      
      hintergrundfarbe  = NSColor.init(red: 0.25, 
                                    green: 0.85, 
                                    blue: 0.85, 
                                    alpha: 0.25)
      
      self.view.layer?.backgroundColor = hintergrundfarbe.cgColor
      
      formatter.maximumFractionDigits = 1
      formatter.minimumFractionDigits = 2
      formatter.minimumIntegerDigits = 1
      //formatter.roundingMode = .down
      

       
        NotificationCenter.default.addObserver(self, selector:#selector(usbstatusAktion(_:)),name:NSNotification.Name(rawValue: "usb_status"),object:nil)
      
      
      // servoPfad
      servoPfad?.setStartposition(x: 0x800, y: 0x800, z: 0)
 
   }
 
   @objc func usbstatusAktion(_ notification:Notification) 
   {
      let info = notification.userInfo
      let status:Int = info?["usbstatus"] as! Int // 
      //print("Hotwire usbstatusAktion:\t \(status)")
      usbstatus = Int32(status)
   }


} // end Hotwire
