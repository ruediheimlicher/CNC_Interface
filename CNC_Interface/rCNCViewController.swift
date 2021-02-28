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
   var usb_schnittdatenarray:[[UInt8]] = [[]]
   var Stepperposition:Int = 0
    var     halt = 0
   var home = 0
   //var readTimer:Timer
   var readTimer : Timer? = nil
   
   
   
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
        /*
       Array:
        
        schritteax lb
        schritteax hb
        schritteay lb
        schritteay hb
        
        delayax lb
        delayax hb
        delayay lb
        delayay hb
        
        schrittebx lb
        schrittebx hb
        schritteby lb
        schritteby hb
        
        delaybx lb
        delaybx hb
        delayby lb
        delayby hb
        
        code
        position // first, last, ...
        indexh
        indexl
        
        pwm (pos 20)
        motorstatus (pos 21)

       */
      
      Stepperposition = 0
        print("viewcontroller usbschnittdatenAktion")
       usb_schnittdatenarray.removeAll()
       let info = notification.userInfo
       let usb_pwm =  info?["pwm"] as! UInt8
       let usb_delayok =  info?["delayok"] as! UInt8
       let usb_home =  info?["home"] as! UInt8
       let usb_art =  info?["art"] as! UInt8
       let usb_cncposition =  info?["cncposition"]
       
       print("usb_pwm: \(usb_pwm) usb_delayok: \(usb_delayok) usb_home: \(usb_home) usb_art: \(usb_art) usb_cncposition: \(usb_cncposition) ")
      
      let zeilenstringarray = info?["schnittdatenstringarray"] as! [String]
      var zeilenindex = 0
      for zeile in zeilenstringarray
      {
      let zeilenarray = zeile.components(separatedBy: ",")
      print("zeilenindex: \(zeilenindex) zeile: \(zeile)  zeilenarray: \(zeilenarray)")
         var wertarray = [UInt8]()   
         for el in zeilenarray
         {
            guard let wert = UInt8(el) else { return  }
            wertarray.append(wert)
         }
         usb_schnittdatenarray.append(wertarray)
      zeilenindex += 1
      }
      
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
      
      var timerdic:[String:Any] = [String:Any]()
      timerdic["home"] = usb_home
      
      teensy.start_read_USB(true, dic:timerdic)
      readTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(teensy.cont_read_USB(_:)), userInfo: timerdic, repeats: true)

      
     }

    @objc func writeCNCAbschnitt()
    {
      //print("writeCNCAbschnitt usb_schnittdatenarray: \(usb_schnittdatenarray)")
      teensy.write_byteArray.removeAll()
      if Stepperposition < usb_schnittdatenarray.count
      {
         if halt > 0
         {
            if readTimer?.isValid ?? false 
            {
               print("writeCNCAbschnitt HALT readTimer inval")
               readTimer?.invalidate() 
            }
            
         }
         else
         {
            let aktuellezeile = usb_schnittdatenarray[Stepperposition]
            for wert in aktuellezeile
            {
               teensy.write_byteArray.append(wert)
            }
            
            if (globalusbstatus > 0)
             {
                let senderfolg = teensy.send_USB()
                
             }

           // readTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(usb_teensy.cont_read_USB(_:)), userInfo: timerDic, repeats: true)
            
            Stepperposition += 1
         }// halt
      }
      else
      {
         if readTimer?.isValid ?? false
         {
            print("writeCNCAbschnitt HALT readTimer inval")
            readTimer?.invalidate()
         }
         
      }
      
      print("writeCNCAbschnitt teensy.write_byteArray: \(teensy.write_byteArray)")
   }
   
  
} // end rCNCViewController


