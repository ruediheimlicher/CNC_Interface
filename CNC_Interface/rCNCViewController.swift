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
   // von IOWarriorWindowController
    var mausistdown:Int = 0
    
   var Stepperposition:Int = 0
   
   var halt = 0
   var home = 0

   var pwm = 0
    // end IOWarriorWindowController

   var usb_schnittdatenarray:[[UInt8]] = [[]]
   
   //var readTimer:Timer
   var readTimer : Timer? = nil
   
 //  var AVR = rAVRview()
   
   override  func viewDidLoad()
   {
      super.viewDidLoad()
      NotificationCenter.default.addObserver(self, selector: #selector(usbsendAktion), name:NSNotification.Name(rawValue: "usbsend"), object: nil)
       NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "usbschnittdaten"), object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(usbschnittdatenAktion), name:NSNotification.Name(rawValue: "usbschnittdaten"), object: nil)
      NotificationCenter.default.addObserver(self, selector:#selector(newDataAktion(_:)),name:NSNotification.Name(rawValue: "newdata"),object:nil)
      NotificationCenter.default.addObserver(self, selector:#selector(contDataAktion(_:)),name:NSNotification.Name(rawValue: "contdata"),object:nil)

   }
   
   @objc func usbsendAktion(_ notification:Notification) 
    {
       print("usbsendAktion: \(notification)")
    }
    
     
    
     @objc func usbschnittdatenAktion(_ notification:Notification) 
     {
      // N
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
        print("cncviewcontroller usbschnittdatenAktion")
       usb_schnittdatenarray.removeAll()
       let info = notification.userInfo
       let usb_pwm =  info?["pwm"] as! UInt8
       let usb_delayok =  info?["delayok"] as! UInt8
       let usb_home =  info?["home"] as! UInt8
       let usb_art =  info?["art"] as! UInt8
       let usb_cncposition =  info?["cncposition"]
       
       //print("usb_pwm: \(usb_pwm) usb_delayok: \(usb_delayok) usb_home: \(usb_home) usb_art: \(usb_art) usb_cncposition: \(usb_cncposition) ")
      
      let zeilenstringarray = info?["schnittdatenstringarray"] as! [String]
      var zeilenindex = 0
      for zeile in zeilenstringarray
      {
         let zeilenarray = zeile.components(separatedBy: ",")
         //print("zeilenindex: \(zeilenindex) zeile: \(zeile)  zeilenarray: \(zeilenarray)")
         var wertarray = [UInt8]() 
         var elementindex = 0
         for el in zeilenarray
         {
            guard let wert = UInt8(el) else { return  }
            wertarray.append(wert)
            elementindex += 1
         }
         for anz in  elementindex..<Int(BufferSize())
         {
            wertarray.append(0)
            
         }
         usb_schnittdatenarray.append(wertarray)
         zeilenindex += 1
      }
      
      
        //print("usb_schnittdatenarray: \(usb_schnittdatenarray )")
       
      
      //teensy.write_byteArray[0] = UInt8((0x00FF) & 0xFF) // lb

       if (globalusbstatus == 0)
       {
         let warnung = NSAlert.init()
         
         warnung.informativeText = "USB_SchnittdatenAktion: USB ist noch nicht eingesteckt."
         warnung.messageText = "CNC Schnitt starten"
         warnung.addButton(withTitle: "Einstecken und einschalten")
         warnung.addButton(withTitle: "Zurück")

 //        AVR?.dc_(on: 0)
 //        AVR?.setStepperstrom(0)
         
         
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
      
     // readTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(teensy.cont_read_USB(_:)), userInfo: timerdic, repeats: true)

      
     }

    @objc func writeCNCAbschnitt()
    {
      //N
      print("writeCNCAbschnitt usb_schnittdatenarray: \(usb_schnittdatenarray)")
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
            print("aktuellezeile: \(aktuellezeile)")
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
         print("writeCNCAbschnitt HALT ")
         teensy.stop_read_USB()
         if readTimer?.isValid ?? false
         {
            print("writeCNCAbschnitt HALT readTimer inval")
            readTimer?.invalidate()
         }
         
      }
      
      print("writeCNCAbschnitt teensy.write_byteArray: \(teensy.write_byteArray)")
   }
   
  
   @objc override func newDataAktion(_ notification:Notification) 
   {
      // N
      var lastData = teensy.getlastDataRead()
      let lastDataArray = [UInt8](lastData)
      print("newDataAktion notification: \n\(notification)\n lastData:\n \(lastData)")       
      var ii = 0
      while ii < 10
      {
         //print("ii: \(ii)  wert: \(lastData[ii])\t")
         ii = ii+1
      }
      
      let u = ((Int32(lastData[1])<<8) + Int32(lastData[2]))
      //print("hb: \(lastData[1]) lb: \(lastData[2]) u: \(u)")
      let info = notification.userInfo
      
      let data = "foo".data(using: .utf8)!      
      //print("info: \(String(describing: info))")
      //print("new Data")
      //let data = notification.userInfo?["data"]
      //print("data: \(String(describing: data)) \n") // data: Optional([0, 9, 51, 0,....
      
      
      //print("lastDataRead: \(lastDataRead)   ")
      var i = 0
      while i < 10
      {
         //print("i: \(i)  wert: \(lastDataRead[i])\t")
         i = i+1
      }
      
      if let d = info!["contdata"] // Data vornanden
      {
         var usbdata = info!["data"] as! [UInt8]
         
   //      let stringFromByteArray = String(data: Data(bytes: usbdata), encoding: .utf8)         
         
   //      print("usbdata: \(usbdata)\n")
         
         //if  usbdata = info!["data"] as! [String] // Data vornanden
         if  usbdata.count > 0 // Data vornanden
         {
            //print("usbdata: \(usbdata)\n") // d: [0, 9, 56, 0, 0,... 
            var NotificationDic = [String:Int]()
            
            let abschnittfertig:UInt8 =   usbdata[0]
            
            print("abschnittfertig: \(abschnittfertig)\n")
            if usbdata != nil
            {
               print("usbdata not nil\n")
               var i = 0
               while i < 10
               {
                  print("i: \(i)  wert: \(usbdata[i])\t")
                  i = i+1
               }
               
            }
            
            if abschnittfertig >= 0xA0 // Code fuer Fertig: AD
            {
               let Abschnittnummer = Int(usbdata[5])
               NotificationDic["inposition"] = Int(Abschnittnummer)
               let ladePosition = Int(usbdata[6])
               NotificationDic["outposition"] = ladePosition
               NotificationDic["stepperposition"] = Stepperposition
               NotificationDic["mausistdown"] = mausistdown
               print("newDataAktion NotificationDic: \(NotificationDic)")
            } // if data
            
   //         writeCNCAbschnitt()
            //print("dic end\n")
         } // if count > 0
         
      } // if d
      //let dic = notification.userInfo as? [String:[UInt8]]
      //print("dic: \(dic ?? ["a":[123]])\n")
      
   }
   
   
    @objc  func contDataAktion(_ notification:Notification) 
    {
       let lastData = teensy.getlastDataRead()
      print("contDataAktion notification: \n\(notification)\n lastData:\n \(lastData) ")       
      var ii = 0
       while ii < 10
       {
          //print("ii: \(ii)  wert: \(lastData[ii])\t")
          ii = ii+1
       }
       
       let u = ((Int32(lastData[1])<<8) + Int32(lastData[2]))
       //print("hb: \(lastData[1]) lb: \(lastData[2]) u: \(u)")
       let info = notification.userInfo
       
       //print("info: \(String(describing: info))")
       //print("new Data")
       let data = notification.userInfo?["data"]
       //print("data: \(String(describing: data)) \n") // data: Optional([0, 9, 51, 0,....
       
       
       //print("lastDataRead: \(lastDataRead)   ")
       var i = 0
       while i < 10
       {
          //print("i: \(i)  wert: \(lastDataRead[i])\t")
          i = i+1
       }
       
       if let d = notification.userInfo!["contdata"]
        {
              
           //print("d: \(d)\n") // d: [0, 9, 56, 0, 0,... 
           let t = type(of:d)
           //print("typ: \(t)\n") // typ: Array<UInt8>
           
           //print("element: \(d[1])\n")
           
           print("d as string: \(String(describing: d))\n")
           if d != nil
           {
              //print("d not nil\n")
              var i = 0
              while i < 10
              {
                 //print("i: \(i)  wert: \(d![i])\t")
                 i = i+1
              }
              
           }
          
           
           //print("dic end\n")
        }

            
          
          //print("dic end\n")
       }
       
       //let dic = notification.userInfo as? [String:[UInt8]]
       //print("dic: \(dic ?? ["a":[123]])\n")
       
    
} // end rCNCViewController


