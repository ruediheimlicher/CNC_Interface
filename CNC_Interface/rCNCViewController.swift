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
   
   var HomeAnschlagSet = IndexSet()
    // end IOWarriorWindowController

   var usb_schnittdatenarray:[[UInt8]] = [[]]
   
   //var readTimer:Timer
   var readTimer : Timer? = nil
   
   var AVR = rAVRview()
   
   var Einstellungen = rEinstellungen()
   
   override var acceptsFirstResponder : Bool {
          return true
   }
   override  func viewDidLoad()
   {
      super.viewDidLoad()
      
      NotificationCenter.default.addObserver(self, selector: #selector(beendenAktion), name:NSNotification.Name(rawValue: "beenden"), object: nil)

      NotificationCenter.default.addObserver(self, selector: #selector(usbsendAktion), name:NSNotification.Name(rawValue: "usbsend"), object: nil)
       NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "usbschnittdaten"), object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(usbschnittdatenAktion), name:NSNotification.Name(rawValue: "usbschnittdaten"), object: nil)
      NotificationCenter.default.addObserver(self, selector:#selector(newDataAktion(_:)),name:NSNotification.Name(rawValue: "newdata"),object:nil)
      NotificationCenter.default.addObserver(self, selector:#selector(contDataAktion(_:)),name:NSNotification.Name(rawValue: "contdata"),object:nil)
      NotificationCenter.default.addObserver(self, selector:#selector(usbattachAktion(_:)),name:NSNotification.Name(rawValue: "usb_attach"),object:nil)


   }
   
 
   override func keyDown(with theEvent: NSEvent)
   {
      //self.window.makeFirstResponder(AVR?.Profilfeld)
    //  super.keyDown(with: theEvent)
      Swift.print( "CNCView Key Pressed" )
     Swift.print(theEvent.keyCode)
      // Apple Mouse, keyboard and Trackpad
      let optionKeyPressed = theEvent.modifierFlags.contains(.option)
      var arrowstep:Int32 = 100
      
      if optionKeyPressed 
      {
          Swift.print("optionKeyPressed")
         arrowstep = 10
      }
      
      switch (theEvent.keyCode)
      {
         case 123:
            print("left arrowstep: \(arrowstep)")
            AVR?.manRichtung(3, pfeilstep: arrowstep) // left
            break
         case 124:
            print("right arrowstep: \(arrowstep)")
             AVR?.manRichtung(1, pfeilstep: arrowstep) // right
             break
         case 125:
            print("down arrowstep: \(arrowstep)")
             AVR?.manRichtung(4, pfeilstep: arrowstep) // down
             break
         case 126:
            print("up arrowstep: \(arrowstep)")
             AVR?.manRichtung(2, pfeilstep: arrowstep) // up
             break
         
         default:
            
            //print("default")
            return;
         //super.keyDown(with: theEvent)
      }// switch keycode
   
   }
   
   
   
/*
   - (void)keyDown:(NSEvent*)derEvent
   {
      //NSLog(@"keyDown: %@",[derEvent description]);
      NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      [NotificationDic setObject:[NSNumber  numberWithInt:[derEvent keyCode]]forKey:@"pfeiltaste"];
      /*
      [NotificationDic setObject:[NSNumber  numberWithInt:Klickpunkt]forKey:@"klickpunkt"];
      [NotificationDic setObject:[NSNumber  numberWithInt:Klickseite]forKey:@"klickseite"];
      [NotificationDic setObject:[NSNumber numberWithInt:GraphOffset] forKey:@"graphoffset"];
      */
      
      NSLog(@"WC keyDown: %d",[derEvent keyCode]);
      
      switch ([derEvent keyCode]) 
      {
         case 123:
            NSLog(@"links");
            
            break;
            
         case 124:
            NSLog(@"rechts");
            break;
            
         case 125:
            NSLog(@"down");
            break;
            
         case 126:
            NSLog(@"up");
            break;
            
            
            
         default:
            break;
      }
      
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"pfeiltaste" object:self userInfo:NotificationDic];
      
   }
 
 */
   
   @objc func usbattachAktion(_ note:Notification) 
   {
      let info = note.userInfo
      let status = info?["attach"] as! Int
      print("ViewController usbattachAktion status: \(status)");
      
      if (status == USBREMOVED)
      {
         USB_OK_Feld.image = notokimage
         //USBKontrolle.stringValue="USB OFF"
         print("usbattachAktion USBREMOVED ")
      }
     else if (status == USBATTACHED)
      {
         USB_OK_Feld.image = okimage
        // [USBKontrolle setStringValue:@"USB ON"];
         
         print("usbattachAktion USBATTACHED")
      }
      
      
   }

   
   @objc func usbsendAktion(_ notification:Notification) 
    {
       print("usbsendAktion: \(notification)")
    }
    
    override func windowWillClose(_ aNotification: Notification) {
        print("windowWillClose cnc")
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"beenden"),
                object: nil,
                userInfo: nil)
        
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
   //   print("info: \(info)")
   //    let usb_pwm =  info?["pwm"] as! UInt8
   //    let usb_delayok =  info?["delayok"] as! UInt8
       
      let usb_home =  info?["home"] as! UInt8
   //    let usb_art =  info?["art"] as! UInt8
   //    let usb_cncposition =  info?["cncposition"]
       
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
      
      
        //print("usbschnittdatenAktion usb_schnittdatenarray: \(usb_schnittdatenarray )")
       
      
      //teensy.write_byteArray[0] = UInt8((0x00FF) & 0xFF) // lb

       if (globalusbstatus == 0)
       {
         let warnung = NSAlert.init()
         
         warnung.informativeText = "USB_SchnittdatenAktion: USB ist noch nicht eingesteckt."
         warnung.messageText = "CNC Schnitt starten"
         warnung.addButton(withTitle: "Einstecken und einschalten")
         warnung.addButton(withTitle: "Zurück")

 //        AVR?.dc_(on: 0)
 //        AVR?.setStepperstrom(0)66
         
         
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
      timerdic["home"] = home
      
      teensy.start_read_USB(true, dic:timerdic)
      
     // readTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(teensy.cont_read_USB(_:)), userInfo: timerdic, repeats: true)

      
     }

    @objc func writeCNCAbschnitt()
    {
      //N
     // print("writeCNCAbschnitt usb_schnittdatenarray: \(usb_schnittdatenarray)")
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
            //print("aktuellezeile: \(aktuellezeile)")
            for wert in aktuellezeile
            {
               teensy.write_byteArray.append(wert)
            }
            //print("write_byteArray: \(teensy.write_byteArray)")
            if (globalusbstatus > 0)
             {
                let senderfolg = teensy.send_USB()
                print("writeCNCAbschnitt senderfolg: \(senderfolg)")
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
   
  
   @objc override func newDataAktion(_ notification:Notification)  // entspricht readUSB
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
            //printhex(wert: abschnittfertig)
            // https://useyourloaf.com/blog/swift-string-cheat-sheet/
            //print("abschnittfertig: \(String(abschnittfertig, radix:16, uppercase:true))\n")
            print("abschnittfertig: \(hex(abschnittfertig))\n")
            if usbdata != nil
            {
               //print("usbdata not nil\n")
               var i = 0
               while i < 10
               {
                  //print("i: \(i)  wert: \(usbdata[i])\t")
                  i = i+1
               }
               
            }
            
            if abschnittfertig >= 0xA0 // Code fuer Fertig: AD
            {
               //print("abschnittfertig > A0")
               let Abschnittnummer = Int(usbdata[5])
               NotificationDic["inposition"] = Int(Abschnittnummer)
               let ladePosition = Int(usbdata[6])
               NotificationDic["outposition"] = ladePosition
               NotificationDic["stepperposition"] = Stepperposition
               NotificationDic["mausistdown"] = mausistdown
               
               /*
                let nc = NotificationCenter.default
                nc.post(name:Notification.Name(rawValue:"usbread"),
                object: nil,
                userInfo: NotificationDic)
                */
               //[NotificationDic setObject:abschnittfertig forKey:@"abschnittfertig"];
               //print("newDataAktion NotificationDic: \(NotificationDic)")
               //NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
               //[nc postNotificationName:@"usbread" object:self userInfo:NotificationDic];
               
               
               var AnschlagSet = IndexSet()
               
               switch abschnittfertig
               {
               case 0xE1:// Antwort auf Mouseup 0xE0 HALT
                  print("newDataAktion E1 mouseup")
                  usb_schnittdatenarray.removeAll()
                  AVR?.setBusy(0)
                  teensy.read_OK = false
                  break
                  
               case 0xEA: // home
                  print("newDataAktion EA home gemeldet")
                  break
                  
               // Anschlag first
               case 0xA5:
                  print("Anschlag A0")
                  AnschlagSet.insert(0) // schritteax lb
                  AnschlagSet.insert(1) // schritteax hb
                  AnschlagSet.insert(4) // delayax lb
                  AnschlagSet.insert(5) // delayax lb
                  break;
                  
               case 0xA6:
                  print("Anschlag B0")
                  AnschlagSet.insert(2) // schritteax lb
                  AnschlagSet.insert(3) // schritteax hb
                  AnschlagSet.insert(6) // delayax lb
                  AnschlagSet.insert(7) // delayax lb
                  break;
                  
               case 0xA7:
                  print("Anschlag C0")
                  AnschlagSet.insert(8) // schrittebx lb
                  AnschlagSet.insert(9) // schrittebx hb
                  AnschlagSet.insert(12) // delayabx lb
                  AnschlagSet.insert(13) // delaybx lb
                  break;
                  
               case 0xA8:
                  print("Anschlag D0")
                  AnschlagSet.insert(10) // schritteby lb
                  AnschlagSet.insert(11) // schritteby hb
                  AnschlagSet.insert(14) // delayby lb
                  AnschlagSet.insert(15) // delayby lb
                  break;
                  
               // Anschlag home first
               case 0xB5:
                  print("Anschlag A home first")
                  HomeAnschlagSet.insert(0xB5)
                  break
               case 0xB6:
                  print("Anschlag B home first")
                  HomeAnschlagSet.insert(0xB6)
                  break
               case 0xB7:
                  print("Anschlag C home first")
                  HomeAnschlagSet.insert(0xB7)
                  break
               case 0xB8:
                  print("Anschlag D home first")
                  HomeAnschlagSet.insert(0xB8)
                  break
                  
               // Anschlag Second  
               case 0xC5:
                  print("Anschlag A home  second")
                  break              
               case 0xC6:
                  print("Anschlag B home  second")
                  break
               case 0xC7:
                  print("Anschlag C home  second")
                  break
               case 0xC8:
                  print("Anschlag D home  second")
                  break
                  
               case 0xD0:
                  print("Letzter Abschnitt")
                   print("HomeAnschlagSet: \(HomeAnschlagSet)")
                  NotificationDic["abschnittfertig"] = Int(abschnittfertig)
                  let nc = NotificationCenter.default
                  nc.post(name:Notification.Name(rawValue:"usbread"),
                          object: nil,
                          userInfo: NotificationDic)
                  return
                  break
                  
               default:
                  break
               }// switch abschnittfertig
               
               if AnschlagSet.count > 0
               {
                  print("AnschlagSet count 0")
                  //var i=0
                  for i in Stepperposition-1..<usb_schnittdatenarray.count
                  {
                     var tempZeilenArray = usb_schnittdatenarray[i]
                     for k in 0..<tempZeilenArray.count
                     {
                        if AnschlagSet.contains(k)
                        {
                           tempZeilenArray[k] = 0
                        }
                     }
                  }
               } // if AnschlagSet count
               
               if mausistdown == 2
               {
                  print("mausistdown = 2")
                  Stepperposition = 0
               }
               
               var EndIndexSet = IndexSet(integersIn:0xAA...0xAD)
               EndIndexSet.insert(integersIn:0xA5...0xA8)
               
               var HomeIndexSet = IndexSet(integersIn:0xAA...0xAD)
               EndIndexSet.insert(integersIn:0xB5...0xB8)
               
               print("EndIndexSet: \(EndIndexSet)")
                print("HomeIndexSet: \(HomeIndexSet)")

               
               if EndIndexSet.contains(Int(abschnittfertig))
               {
                  print("EndIndexSet contains abschnittfertig")
                  //teensy.DC_pwm(0)
                  AVR?.setBusy(0)
                  teensy.read_OK = false
               }
               else
               {
                  if HomeIndexSet.contains(Int(abschnittfertig))
                  {
                     print("HomeIndexSet contains abschnittfertig")
                     if HomeAnschlagSet.count == 1
                     {
                        print("HomeAnschlagSet.count == 1")
                     }
                     else if HomeAnschlagSet.count == 4
                     {
                        print("HomeAnschlagSet.count == 4")
                     }
                     else if home == 2
                     {
                        print("home == 2")
                     }
                  }
                  else
                  {
                     print("WriteCNCAbschnitt ")
                     writeCNCAbschnitt()
                  }
               }
                  print("HomeAnschlagSet: \(HomeAnschlagSet)")
                  NotificationDic["homeanschlagset"] = Int(HomeAnschlagSet.count)
                  NotificationDic["home"] = home
                  NotificationDic["abschnittfertig"] = Int(abschnittfertig)
                  
                  
                   let nc = NotificationCenter.default
                   nc.post(name:Notification.Name(rawValue:"usbread"),
                   object: nil,
                   userInfo: NotificationDic)
                   
               
            } // if abschnittfertig > A0
            
            //writeCNCAbschnitt()
            //print("dic end\n")
            
         } // if count > 0
         
      } // if d
      //let dic = notification.userInfo as? [String:[UInt8]]
      //print("dic: \(dic ?? ["a":[123]])\n")
      
   }
   
    
   @objc func DC_pwm(_ dcpwm:Int)
    {
       print("DC_pwm pwm: \(dcpwm)")
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
       
   @objc @IBAction  func showEinstellungen(_ sender: Any)
   {
      AVR?.showEinstellungen()
   }
  
   /*
   @objc @IBAction func print(sender:Any)
   {
      AVR?.printGraph()
   }
*/
    
   
   
   @objc @IBAction func printGraph(sender:Any)
   {
      Swift.print("print")
   // AVR?.printGraph()
   }

} // end rCNCViewController


