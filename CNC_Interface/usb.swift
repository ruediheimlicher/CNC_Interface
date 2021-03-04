//
//  Netz.swift
//  SwiftStarter
//
//  Created by Ruedi Heimlicher on 30.10.2014.
//  Copyright (c) 2014 Ruedi Heimlicher. All rights reserved.
//


import Cocoa
import Foundation
import AVFoundation
import Darwin

let BUFFER_SIZE:Int   = Int(BufferSize())

var new_Data:ObjCBool = false

class rTimerInfo {
    var count = 0
}




 @objc class usb_teensy: NSObject
{
   var hid_usbstatus: Int32 = 0
   
   var read_byteArray = [UInt8](repeating: 0x00, count: BUFFER_SIZE)
   var last_read_byteArray = [UInt8](repeating: 0x00, count: BUFFER_SIZE)
   var write_byteArray: Array<UInt8> = Array(repeating: 0x00, count: BUFFER_SIZE)
   // var testArray = [UInt8]()
   var testArray: Array<UInt8>  = [0xAB,0xDC,0x69,0x66,0x74,0x73,0x6f,0x64,0x61]
   
   var read_OK:ObjCBool = false
   
   var datatruecounter = 0
   var datafalsecounter = 0
   
   
   var manustring:String = ""
   var prodstring:String = ""
   
   var USBTimerInfo = rTimerInfo()
   override init()
   {
      super.init()
   }
   
   open func USBOpen(board:[String:Any])->Int32
   {
      var r:Int32 = 0
      
      let PID:Int32 = Int32(board["PID"] as! Int32)//
      let VID:Int32 = Int32(board["VID"] as! Int32)//
      print("func usb_teensy.USBOpen PID: \(PID) VID: \(VID)")
      // rawhid_open(int max, int vid, int pid, int usage_page, int usage)
      var    out = rawhid_open(1,  VID, PID, 0xFFAB, 0x0200)
      
    //  out = rawhid_open(1, 5824, 1152, 0xFFAB, 0x0200)
      
      
      print("func usb_teensy.USBOpen out: \(out)")
      
      hid_usbstatus = out as Int32;
      
      if (out <= 0)
      {
         NSLog("USBOpen: no rawhid device found");
         //AVR.setUSB_Device_Status:0
      }
      else
      {
         NSLog("USBOpen: found rawhid device hid_usbstatus: %d",hid_usbstatus)
         let manu   = get_manu()
         let manustr:String = String(cString: manu!)
         
         if (manustr == nil)
         {
            manustring = "-"
         }
         else
         {
            manustring = manustr
            //manustring = String(cString: UnsafePointer<CChar>(manustr))
         }
         
         
         
         
         let prod = get_prod();
         if (prod == nil)
         {
            prodstring = "-"
         }
         else 
         {
         //fprintf(stderr,"prod: %s\n",prod);
         let prodstr:String = String(cString: prod!)
         if (prodstr == nil)
         {
            prodstring = "-"
         }
         else
         {
            prodstring = String(cString: UnsafePointer<CChar>(prod!))
         }
         }
         var USBDatenDic = ["prod": prod, "manu":manu]
         
      }
      
      
      return out;
   } // end USBOpen
   
   open func manufactorer()->String?
   {
      return manustring
   }
   
   open func producer()->String?
   {
      return prodstring
   }
   
   
   
   open func status()->Int32
   {
      return get_hid_usbstatus()
   }
   
   open func dev_present()->Int32
   {
      return usb_present()
   }
   
   /*
    func appendCRLFAndConvertToUTF8_1(_ s: String) -> Data {
    let crlfString: NSString = s + "\r\n" as NSString
    let buffer = crlfString.utf8String
    let bufferLength = crlfString.lengthOfBytes(using: String.Encoding.utf8.rawValue)
    let data = Data(bytes: UnsafePointer<UInt8>(buffer!), count: bufferLength)
    return data;
    }
    */
   
 
   
   open func getlastDataRead()->Data
   {
      return lastDataRead
   }
   
   @objc func start_read_USB(_ cont: Bool, dic:[String:Any])-> Int
   {
      read_OK = ObjCBool(cont)
      var timerDic:NSMutableDictionary  = ["count": 0]
      
 //     let result = rawhid_recv(0, &read_byteArray, Int32(BUFFER_SIZE), 50);
      
    //  print("\ result: \(result) cont: \(cont)")
      //print("usb.swift start_read_byteArray start: *\n\(read_byteArray)*")
  //    let usbData = Data(bytes:read_byteArray)
  //    print("\n+++ new read_byteArray in start_read_USB:")
  //     for  i in 0..<BUFFER_SIZE
  //     {
  //        print(" \(read_byteArray[i])", terminator: "")
  //     }
      // print("\n")
/*
      let nc = NotificationCenter.default
      nc.post(name:Notification.Name(rawValue:"newdata"),
              object: nil,
              userInfo: ["message":"neue Daten", "data":read_byteArray,"startdata":usbData])
  */    
      // var somethingToPass = "It worked in teensy_send_USB"
     
      
      let xcont = cont;
      
      if (xcont == true)
      {
         var timer : Timer? = nil
         timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(usb_teensy.cont_read_USB(_:)), userInfo: USBTimerInfo, repeats: true)
      }
      return 0
      //return Int(result) //
   }
   
   
   
   @objc open func cont_read_USB(_ timer: Timer)
   {
   //   print("\n*** cont_read_USB\n")
    //  print("*read_OK: \(read_OK)")
      if (read_OK).boolValue
      {
         //var tempbyteArray = [UInt8](count: 32, repeatedValue: 0x00)
         
         var result = rawhid_recv(0, &read_byteArray, Int32(BUFFER_SIZE), 50)
         
         
         //print("*cont_read_USB result: \(result)")
         //print("tempbyteArray in Timer: *\(read_byteArray)*")
        // var timerdic: [String: Int]
         
         guard let timerInfo = timer.userInfo as? rTimerInfo else { return }

             timerInfo.count += 1
    //         print("cont_read_USB timerInfo: \(timerInfo.count)")
      
         /*
          if  var dic = timer.userInfo as? NSMutableDictionary
          {
            if var count:Int = dic["count"] as? Int 
          {
          count = count + 1
          dic["count"] = count
          //dic["nr"] = count+2
          //println(dic)
          //usb_count += 1
          }
          }
          
         var timerdic:Dictionary<String,Int?> = timer.userInfo as! Dictionary<String,Int?>
         //let messageString = userInfo["message"]
         var tempcount = timerdic["count"]!
         */
         
         //print("+++ new read_byteArray in Timer:")
         /*
          for  i in 0...12
          {
          print(" \(read_byteArray[i])")
          }
          println()
          for  i in 0...12
          {
          print(" \(last_read_byteArray[i])")
          }
          println()
          println()
          */
         
         
         
         //timerdic["count"] = 2
         
         // var count:Int = timerdic["count"]
         
         //timer.userInfo["count"] = count+1
         if !(last_read_byteArray == read_byteArray)
         {
            /*
                 guard let timerInfo = timer.userInfo as? rTimerInfo else { return }

                        timerInfo.count += 1
                        print("cont_read_USB timerInfo: \(timerInfo.count)")
            */
            last_read_byteArray = read_byteArray
            lastDataRead = Data(bytes:read_byteArray)
            let usbData = Data(bytes:read_byteArray)
            new_Data = true
            datatruecounter += 1
            let codehex = read_byteArray[0]
            let codehexstring = String(codehex, radix:16, uppercase:true)
            print("cont_read_USB codehex: \(codehex) codehexstring: \(codehexstring)")
            print("+++ new read_byteArray in Timer:")
            for  i in 0..<BUFFER_SIZE
            {
               print(" \(read_byteArray[i])", terminator: "")
            }
            print("\n")

            // http://dev.iachieved.it/iachievedit/notifications-and-userinfo-with-swift-3-0/
            
            //let usbdic = ["message":"neue Daten", "data":read_byteArray] as [String : UInt8]
            let nc = NotificationCenter.default
            /*       
             nc.post(name:Notification.Name(rawValue:"newdata"),
             object: nil,
             userInfo: ["message":"neue Daten", "data":read_byteArray, "usbdata":usbData])
             */
            // CNC
            nc.post(name:Notification.Name(rawValue:"newdata"),
                    object: nil,
                    userInfo: ["message":"neue Daten", "data":read_byteArray, "contdata":usbData])
            
            // print("+ new read_byteArray in Timer:", terminator: "")
            //for  i in 0...31
            //{
            // print(" \(read_byteArray[i])", terminator: "")
            //}
            //print("")
            //let stL = NSString(format:"%2X", read_byteArray[0]) as String
            //print(" * \(stL)", terminator: "")
            //let stH = NSString(format:"%2X", read_byteArray[1]) as String
            //print(" * \(stH)", terminator: "")
            
            //var resultat:UInt32 = UInt32(read_byteArray[1])
            //resultat   <<= 8
            //resultat    += UInt32(read_byteArray[0])
            //print(" Wert von 0,1: \(resultat) ")
            
            //print("")
            //var st = NSString(format:"%2X", n) as String
            //     } // end if codehex
         }
         else
         {
            //new_Data = false
            
          //  print("---nix neues  \(read_byteArray[0])\t\(datafalsecounter)")
            datafalsecounter += 1
            //stop_read_USB()
         }
         //println("*read_USB in Timer result: \(result)")
         
         //let theStringToPrint = timer.userInfo as String
         //println(theStringToPrint)
         //timer.invalidate()
      }
      else
      {
         print("*cont_read_USB timer.invalidate")
         timer.invalidate()
      }
   }
   
   open func report_stop_read_USB(_ inTimer: Timer)
   {
      
      read_OK = false
   }
   
   @objc func stop_read_USB()
   {
      read_OK = false
   }
   
   open func send_USB()->Int32
   {
      // http://www.swiftsoda.com/swift-coding/get-bytes-from-nsdata/
      // Test Array to generate some Test Data
      //var testData = Data(bytes: UnsafePointer<UInt8>(testArray),count: testArray.count)
  /*    
      write_byteArray[0] = testArray[0]
      write_byteArray[1] = testArray[1]
      write_byteArray[2] = testArray[2]
      
      if (testArray[0] < 0xFF)
      {
         testArray[0] += 1
      }
      else
      {
         testArray[0] = 0;
      }
      if (testArray[1] < 0xFF)
      {
         testArray[1] += 1
      }
      else
      {
         testArray[1] = 0;
      }
      if (testArray[2] < 0xFF)
      {
         testArray[2] += 1
      }
      else
      {
         testArray[2] = 0;
      }
      
      //println("write_byteArray: \(write_byteArray)")
//      print("write_byteArray in send_USB: ", terminator: "")
      
      for  i in 0...16
      {
//         print(" \(write_byteArray[i])", terminator: "\t")
      }
      print("")
  */    
      
     //    let senderfolg = rawhid_send(0,&write_byteArray, Int32(BUFFER_SIZE), 50)
let senderfolg = rawhid_send(0,&write_byteArray, 32, 50)
         
         if hid_usbstatus == 0
         {
            //print("hid_usbstatus 0: \(hid_usbstatus)")
         }
         else
         {
            //print("hid_usbstatus not 0: \(hid_usbstatus)")
            
         }
         
         return senderfolg
      
   }
   
   
   
   open func rep_read_USB(_ inTimer: Timer)
   {
      var result:Int32  = 0;
      var reportSize:Int = 32;   
      var buffer = [UInt8]();
      result = rawhid_recv(0, &buffer, Int32(BUFFER_SIZE), 50);
      
      var dataRead:Data = Data(bytes:buffer)
      if (dataRead != lastDataRead)
      {
         print("neue Daten")
      }
      print(dataRead as NSData);   
      
      
   }
   
}


open class Hello
{
   open func setU()
   {
      print("Hi Netzteil")
   }
}

