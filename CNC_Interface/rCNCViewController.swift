//
//  rCNCViewController.swift
//  CNC_Interface
//
//  Created by Ruedi Heimlicher on 27.02.2021.
//  Copyright © 2021 Ruedi Heimlicher. All rights reserved.
//

import Foundation
import Cocoa

class rCNCViewController:rViewController
{
   var usb_schnittdatenarray:[UInt] = []
   override  func viewDidLoad()
   {
      super.viewDidLoad()
      NotificationCenter.default.addObserver(self, selector: #selector(usbsendAktion), name:NSNotification.Name(rawValue: "usbsend"), object: nil)
       NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "usbschnittdaten"), object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(usbschnittdatenAktion), name:NSNotification.Name(rawValue: "usbschnittdaten"), object: nil)

   }
   @objc func usbsendAktion(_ notification:Notification) 
    {
       print("usbsendAktion: \(notification)")
    }
    
     
    
     @objc func usbschnittdatenAktion(_ notification:Notification) 
     {
        
        print("viewcontroller usbschnittdatenAktion")
       let info = notification.userInfo
       let usb_pwm =  info?["pwm"] as! UInt8
       let usb_delayok =  info?["delayok"] as! UInt8
       let usb_home =  info?["home"] as! UInt8
       let usb_art =  info?["art"] as! UInt8
       let usb_cncposition =  info?["cncposition"]
       
       print("usb_pwm: \(usb_pwm) usb_delayok: \(usb_delayok) usb_home: \(usb_home) usb_art: \(usb_art) usb_cncposition: \(usb_cncposition) ")
      let temparray:[Int] = info?["schnittdatenarray"] as! [Int]
      
      if (temparray.count > 0)
      {
         print("temparray: \(temparray)")
         }
   //   usb_schnittdatenarray = info?["schnittdatenarray"] as! [UInt]
       print("usb_schnittdatenarray: \(usb_schnittdatenarray )")
       
      
      //teensy.write_byteArray[0] = UInt8((0x00FF) & 0xFF) // lb

       if (globalusbstatus == 0)
       {
         let warnung = NSAlert.init()
         
         warnung.informativeText = "USB_SchnittdatenAktion: USB ist noch nicht eingesteckt."
         warnung.messageText = "CNC Schnitt starten"
         warnung.addButton(withTitle: "Einstecken und einschalten")
         warnung.addButton(withTitle: "Zurück")

         var openerfolg = 0
         let devicereturn = warnung.runModal()
         switch (devicereturn)
         {
         case NSApplication.ModalResponse.alertFirstButtonReturn: // Einschalten
               let device = teensyboardarray[boardindex]
               openerfolg = Int(teensy.USBOpen(board: device))
            break
            
         case NSApplication.ModalResponse.alertSecondButtonReturn:
               return
            break
         case NSApplication.ModalResponse.alertThirdButtonReturn:
               return
            break
         default:
            return
            break
         }
         
         
      }
  
      writeCNCAbschnitt()
     }

    @objc func writeCNCAbschnitt()
    {
      print("writeCNCAbschnitt usb_schnittdatenarray: \(usb_schnittdatenarray)")
   }
   
 
} // end rCNCViewController


