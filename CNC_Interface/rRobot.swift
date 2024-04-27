//
//  rRobot.swift
//  Robot_Interface
//
//  Created by Ruedi Heimlicher on 12.09.2019.
//  Copyright © 2019 Ruedi Heimlicher. All rights reserved.
//

import Cocoa


let ROB_ACHSE0_MIN:UInt16 = 0x7FF // Startwert low
let ROB_ACHSE0_MAX:UInt16 = 0xFFF // Startwert high
let ROB_FAKTOR0:Float = 1.6
let ROB_ACHSE0_OFFSET:UInt16 = 1800 // Startwert low
let WINKELFAKTOR0:Float = 35.0

// Flachservo 1-2ms
let ROB_ACHSE1_MIN:UInt16 = 2640 // Minwert low
let ROB_ACHSE1_START:UInt16 = 0 // Startwert Slider 1

let ROB_ACHSE1_OFFSET:UInt16 = 2200 // Startwert low
let ROB_FAKTOR1:Float = 0.9
let WINKELFAKTOR1:Float = 35.0

let ROB_ACHSE2_MIN:UInt16 = 800 // Startwert low
let ROB_ACHSE2_START:UInt16 = 0 // Startwert Slider 1
//let ROB_ACHSE2_MAX:UInt16 = 0xFFF// Startwert high

let ROB_ACHSE2_OFFSET:UInt16 = 1300 // starteinstellung
let ROB_FAKTOR2:Float = 1.5
let WINKELFAKTOR2:Float = 40.0

class rRobot: rViewController 
{

   @IBOutlet  weak var RobotarmFeld:rRobotarm!
   
   @IBOutlet  weak var DrehknopfFeld:rDrehknopfView!
   
   @IBOutlet weak var Drehknopf_Feld: NSTextField!
   @IBOutlet weak var Drehknopf_Feld_raw: NSTextField!
   
   @IBOutlet weak var Drehknopf_Stepper_H: NSStepper!
   @IBOutlet weak var Drehknopf_Stepper_L: NSStepper!
   @IBOutlet weak var Drehknopf_Stepper_L_Feld: NSTextField!
   @IBOutlet weak var Drehknopf_Stepper_H_Feld: NSTextField!
   
   @IBOutlet weak var x1_Slider: NSSlider!
   @IBOutlet weak var y1_Slider: NSSlider!
   @IBOutlet weak var z1_Slider: NSSlider!
   
   
   @IBOutlet weak var arm: NSButton!
   
   @IBOutlet weak var startx: NSTextField!
   @IBOutlet weak var starty: NSTextField!
   @IBOutlet weak var startz: NSTextField!
   
   
   @IBOutlet weak var endx: NSTextField!
   @IBOutlet weak var endy: NSTextField!
   @IBOutlet weak var endz: NSTextField!

   @IBOutlet weak var zielx: NSTextField!
   @IBOutlet weak var ziely: NSTextField!
   @IBOutlet weak var zielz: NSTextField!
   
   @IBOutlet weak var arm0: NSTextField!
   @IBOutlet weak var arm1: NSTextField!
   
 
   
//   @IBOutlet weak var armwinkel0: NSTextField!
   @IBOutlet weak var armwinkel1: NSTextField!
   
   @IBOutlet weak var armwinkel2: NSTextField!
   
   @IBOutlet weak var setarmwinkel1: NSButton!
   
   @IBOutlet weak var setarmwinkel2: NSButton!
   @IBOutlet weak var cleararmwinkel2: NSButton!
   @IBOutlet weak var rotwinkel: NSTextField!
   
   @IBOutlet weak var rotoffsetfeld: NSTextField!
   @IBOutlet weak var rotoffsetstepper: NSStepper!
   
   @IBOutlet weak var rotfaktorfeld: NSTextField!
   @IBOutlet weak var rotfaktorstepper: NSStepper!

   
   
   @IBOutlet weak var pot1offsetfeld: NSTextField!
   @IBOutlet weak var pot1offsetstepper: NSStepper!

   @IBOutlet weak var winkelfaktor1feld: NSTextField!
   @IBOutlet weak var winkelfaktor1stepper: NSStepper!
   

   @IBOutlet weak var pot2offsetfeld: NSTextField!
   @IBOutlet weak var pot2offsetstepper: NSStepper!

   @IBOutlet weak var winkelfaktor2feld: NSTextField!
   @IBOutlet weak var winkelfaktor2stepper: NSStepper!

   
   @IBOutlet weak var pos0Feld: NSTextField!
   @IBOutlet weak var pos1Feld: NSTextField!
   @IBOutlet weak var pos2Feld: NSTextField!
   
   @IBOutlet weak var intpos0Feld: NSTextField!
   @IBOutlet weak var intpos1Feld: NSTextField!
   @IBOutlet weak var intpos2Feld: NSTextField!
   
   
   
   var hintergrundfarbe = NSColor()
   
   var lastwinkel:CGFloat = 3272
   
   var geometrie = geom()
   
   var wegmarke:UInt16 = 0
   
   override func viewDidAppear() 
   {
      //print ("Robot viewDidAppear selectedDevice: \(selectedDevice)")
   }
   

    override func viewDidLoad() 
    {
      super.viewDidLoad()
      self.view.window?.acceptsMouseMovedEvents = true
      //let view = view[0] as! NSView
      self.view.wantsLayer = true
      hintergrundfarbe  = NSColor.init(red: 0.25, 
                                       green: 0.45, 
                                       blue: 0.45, 
                                       alpha: 0.25)
      self.view.layer?.backgroundColor =  hintergrundfarbe.cgColor
      formatter.maximumFractionDigits = 1
      formatter.minimumFractionDigits = 2
      formatter.minimumIntegerDigits = 1
      //formatter.roundingMode = .down
      
  
      
      //USB_OK.backgroundColor = NSColor.greenColor()
      // Do any additional setup after loading the view.
  //    let newdataname = Notification.Name("newdata")
  //    NotificationCenter.default.addObserver(self, selector:#selector(newDataAktion(_:)),name:newdataname,object:nil)
 //     NotificationCenter.default.addObserver(self, selector:#selector(joystickAktion(_:)),name:NSNotification.Name(rawValue: "joystick"),object:nil)
      NotificationCenter.default.addObserver(self, selector:#selector(usbstatusAktion(_:)),name:NSNotification.Name(rawValue: "usb_status"),object:nil)
      NotificationCenter.default.addObserver(self, selector:#selector(drehknopfAktion(_:)),name:NSNotification.Name(rawValue: "drehknopf"),object:nil)
      
  //    UserDefaults.standard.removeObject(forKey: "robot1_min")
  //    UserDefaults.standard.removeObject(forKey: "robot2_min")

      
      // https://www.hackingwithswift.com/example-code/system/how-to-save-user-settings-using-userdefaults
      var robot0_offset = UserDefaults.standard.integer(forKey: "robot0_offset")
      if (robot0_offset == 0)
      {
         robot0_offset = Int(ROB_ACHSE0_OFFSET)
      }
      Pot0_Stepper_L.integerValue = robot0_offset
      Pot0_Stepper_L_Feld.integerValue = robot0_offset
      
      // Achse 0 rotation
      var rotoffset = UserDefaults.standard.integer(forKey: "rotoffset")
      if rotoffset == 0
      {
         rotoffset = Int(ROB_ACHSE0_OFFSET)
      }
      rotoffsetfeld.integerValue = rotoffset
      rotoffsetstepper.integerValue = rotoffset
  
      // Achse 0 rotfaktor
      var rotfaktor = UserDefaults.standard.integer(forKey: "rotfaktor")
      if rotfaktor == 0
      {
         rotfaktor = Int(WINKELFAKTOR0)
      }
      rotfaktorfeld.integerValue = rotfaktor
      rotfaktorstepper.integerValue = rotfaktor
      
     
      
      // Achse 1 Arm 0
      var robot1_offset = UserDefaults.standard.integer(forKey: "robot1offset")
      if (robot1_offset == 0)
      {
         print("robot1_offset neu")
         robot1_offset = Int(ROB_ACHSE1_OFFSET)
      }
      pot1offsetfeld.integerValue = robot1_offset
      pot1offsetstepper.integerValue = robot1_offset
      
      var robot1_min = UserDefaults.standard.integer(forKey: "robot1min")
      if (robot1_min == 0)
      {
         print("robot1_min neu")
         robot1_min = Int(ROB_ACHSE1_MIN)
      }
      Pot1_Stepper_L.integerValue = robot1_min
      Pot1_Stepper_L_Feld.integerValue = robot1_min
      
      //print("viewDidLoad Pot1_Stepper_L: \(Pot1_Stepper_L.integerValue) ROB_ACHSE1_MIN: \(ROB_ACHSE1_MIN)")
      
      var winkelfaktor1 = UserDefaults.standard.float(forKey: "winkelfaktor1")
      if (winkelfaktor1 == 0)
      {
         winkelfaktor1 = WINKELFAKTOR1   
      }
      winkelfaktor1stepper.floatValue = winkelfaktor1
      winkelfaktor1feld.floatValue = winkelfaktor1

      var winkelfaktor2 = UserDefaults.standard.float(forKey: "winkelfaktor2")
      if (winkelfaktor2 == 0)
      {
         winkelfaktor2 = WINKELFAKTOR2   
      }
      winkelfaktor2stepper.floatValue = winkelfaktor2
      winkelfaktor2feld.floatValue = winkelfaktor2
      
      teensy.write_byteArray[ACHSE1_START_BYTE_H] = UInt8((robot1_offset & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE1_START_BYTE_L] = UInt8((robot1_offset & 0x00FF) & 0xFF) // lb

      
      
      // Achse 2 Arm 2
      var robot2_offset = UserDefaults.standard.integer(forKey: "robot2offset")
      if (robot2_offset == 0)
      {
         print("robot2_offset neu")
         robot2_offset = Int(ROB_ACHSE2_OFFSET)
      }
      pot2offsetfeld.integerValue = robot2_offset
      pot2offsetstepper.integerValue = robot2_offset
      
      var robot2_min = UserDefaults.standard.integer(forKey: "robot2min")
      if (robot2_min == 0)
      {
         print("robot2_min neu")
         robot1_min = Int(ROB_ACHSE2_MIN)
      }

      Pot2_Stepper_L.integerValue = robot2_min
      Pot2_Stepper_L_Feld.integerValue = robot2_min
      
      //print("viewDidLoad Pot2_Stepper_L: \(Pot2_Stepper_L.integerValue) ROB_ACHSE2_MIN: \(ROB_ACHSE2_MIN)")
      
 
      teensy.write_byteArray[ACHSE2_START_BYTE_H] = UInt8((robot2_offset & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE2_START_BYTE_L] = UInt8((robot2_offset & 0x00FF) & 0xFF) // lb

      
      Pot1_Slider.integerValue = Int(ROB_ACHSE1_START)
      Pot1_Feld_raw.integerValue = Pot1_Slider.integerValue
      Pot1_Feld.integerValue = Int(Pot1_Slider.floatValue * ROB_FAKTOR1)
      
      Pot1_Stepper_H.integerValue = Int(Pot1_Slider.maxValue)
      Pot1_Stepper_H_Feld.integerValue = Int(Pot1_Slider.maxValue)
      

      
      Pot2_Slider.integerValue = Int(ROB_ACHSE2_START)
      Pot2_Feld_raw.integerValue = Pot2_Slider.integerValue
      Pot2_Feld.integerValue = Int(Pot2_Slider.floatValue * ROB_FAKTOR2)

      Pot2_Stepper_H.integerValue = Int(Pot2_Slider.maxValue)
      Pot2_Stepper_H_Feld.integerValue = Int(Pot2_Slider.maxValue)
      
      //Pot2_Slider.minValue = Double(ROB_ACHSE2_MIN)
      
      
      
      
      
      
      // Startpos fuer Achse1
      let intpos1 = UInt16(pot1offsetstepper.floatValue * ROB_FAKTOR1)
      
      teensy.write_byteArray[ACHSE1_BYTE_H] = UInt8((intpos1 & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE1_BYTE_L] = UInt8((intpos1 & 0x00FF) & 0xFF) // lb

      
      // Startpos fuer Achse2
      let intpos2 = UInt16(Pot2_Slider.floatValue * ROB_FAKTOR2)
      teensy.write_byteArray[ACHSE2_BYTE_H] = UInt8((intpos2 & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE2_BYTE_L] = UInt8((intpos2 & 0x00FF) & 0xFF) // lb
      
      let achse0 = 3272
      teensy.write_byteArray[ACHSE0_BYTE_H] = UInt8((achse0 & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE0_BYTE_L] = UInt8((achse0 & 0x00FF) & 0xFF) // lb
      
      // offset:
      
      let startint = UInt(Pot1_Stepper_L.intValue)
      teensy.write_byteArray[ACHSE1_START_BYTE_H] = UInt8((startint & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE1_START_BYTE_L] = UInt8((startint & 0x00FF) & 0xFF) // lb

      
      teensy.write_byteArray[0] = SET_ROB // Code
      
      if (globalusbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
         print("Robot viewDidLoad senderfolg: \(senderfolg)")
      }
      
      /*
       
       Pot1_Feld.integerValue = Int(UInt16(Float(ACHSE1_START) * ROB_FAKTOR1))
       */
      
      Drehknopf_Stepper_H_Feld.integerValue = Int(DrehknopfFeld.maxwinkel)
      Drehknopf_Stepper_H.integerValue = Int(DrehknopfFeld.maxwinkel)
      
      Drehknopf_Stepper_L_Feld.integerValue = Int(DrehknopfFeld.minwinkel)
      Drehknopf_Stepper_L.integerValue = Int(DrehknopfFeld.minwinkel)
      
      DrehknopfFeld.hgfarbe = hgfarbe
      print("Robot globalusbstatus: \(globalusbstatus)")
      

   }
   
   
   
   @nonobjc override func 
      windowShouldClose(_ sender: Any) 
   {
      print("Robot windowShouldClose")
      NSApplication.shared.terminate(self)
   }
   
   
   @objc func usbstatusAktion(_ notification:Notification) 
   {
      let info = notification.userInfo
      guard let status = info?["usbstatus"] as? Int else 
      { 
         print("Basis usbstatusAktion: kein status\n")
         return  
         
      }// 
     // print("Robot usbstatusAktion:\t \(status) ")
      usbstatus = Int(status)
   }
   
   @objc  func drehknopfAktion(_ notification:Notification) 
   {
      //print("Robot drehknopfAktion usbstatus:\t \(usbstatus)  globalusbstatus: \(globalusbstatus) selectedDevice: \(selectedDevice) ident: \(String(describing: self.view.identifier))")
      let sel = NSUserInterfaceItemIdentifier(selectedDevice)
      if (sel == self.view.identifier)
      {
         // print("Robot drehknopfAktion passt")
         teensy.write_byteArray[0] = DREHKNOPF
         
         let info = notification.userInfo
         
         // ident als String: s. joystickaktion
         //     let ident = Int(info?["ident"] as! String) 
         let punkt:CGPoint = info?["punkt"] as! CGPoint
         
         let winkel = (punkt.x ) // Winkel in Grad. Nullpunkt senkrecht
         
         
         let winkel2 = Int(10*(winkel + 180)) // 
         Drehknopf_Feld.integerValue = Int(winkel)
         let h = Double(Joystickfeld.bounds.size.height)
         let randbereich = abs(DrehknopfFeld.minwinkel) + abs(DrehknopfFeld.maxwinkel)
         let drehknopfnormierung = 360/(360 - randbereich )
         
         // minwinkel ist negativ von Scheitelpunkt aus
         let wert = CGFloat(Float((winkel + 180 + (DrehknopfFeld.minwinkel))*drehknopfnormierung) * DREHKNOPF_FAKTOR) // red auf 0
         Drehknopf_Feld_raw.integerValue = Int(wert)
        
         print("Robot drehknopfAktion winkel: \(winkel) wert: \(wert)")
         
         var achse0:UInt16 = 0
         if (wert > 0)
         {
            achse0 =  UInt16(wert)
            lastwinkel = wert
         }
         else
         {
            //achse0 = UInt16(lastwinkel)
         }
         
         //
         //ACHSE0_START_BYTE_H
 //        let achse0_start = 
 //        print("Robot drehknopfAktion achse0: \(achse0)")
         //print("Drehknopf winkel: \(winkel) winkel2: \(winkel2) *** normierung: \(drehknopfnormierung)   wert: \(wert) achse0: \(achse0)")
         
         teensy.write_byteArray[ACHSE0_BYTE_H] = UInt8((achse0 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE0_BYTE_L] = UInt8((achse0 & 0x00FF) & 0xFF) // lb
         
         let startint = UInt(0x680)
         teensy.write_byteArray[ACHSE0_START_BYTE_H] = UInt8((startint & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE0_START_BYTE_L] = UInt8((startint & 0x00FF) & 0xFF) // lb

         if (globalusbstatus > 0)
         {
            let senderfolg = teensy.send_USB()
            //print("Robot Drehknopfaktion senderfolg: \(senderfolg)")
         }         
      } // identifier passt
   }
   @objc func setDrehknopfwinkel(winkel:Float)
   {
      print("Robot setDrehknopfwinkel winkel:\t \(winkel)") 
   }
   
   // MARK joystick
   @objc override func joystickAktion(_ notification:Notification) 
   {
          print("Robot joystickAktion usbstatus:\t \(usbstatus)  selectedDevice: \(selectedDevice) ident: \(String(describing: self.view.identifier))")
      let sel = NSUserInterfaceItemIdentifier.init(selectedDevice)
      //  if (selectedDevice == self.view.identifier)
      //var ident = ""
      if (sel == self.view.identifier)
      {
         print("Robot joystickAktion passt")
         
         var ident = "13"
         let info = notification.userInfo 
         print("Robot joystickAktion info: \(info)")
         let i = info?["ident"]
         print("Robot joystickAktion i: \(i)")
         if let joystickident = info?["ident"]as? String
         {
            print("Robot joystickAktion ident da: \(joystickident)")
            ident = joystickident
         }
         else
         {
            print("Robot joystickAktion ident nicht da")
         }
         // let id = NSUserInterfaceItemIdentifier.init(rawValue:(info?["ident"] as! NSString) as String)
         
         
         //   let ident = "aa" //info["ident"] as! String 
         let punkt:CGPoint = info?["punkt"] as! CGPoint
         
         
         let wegindex:Int = info?["index"] as! Int // 
         let first:Int = info?["first"] as! Int
         
         //      print("Robot joystickAktion:\t \(punkt)")
         //      print("x: \(punkt.x) y: \(punkt.y) index: \(wegindex) first: \(first) ident: \(ident)")
         
         
         if ident == "3001" // Drehknopf
         {
            print("Drehknopf ident 2001")
            teensy.write_byteArray[0] = DREHKNOPF
            let winkel = Int(punkt.x )
            print("Drehknopf winkel: \(winkel)")
         }
         else if ident == "3000"
            
         {
            
            teensy.write_byteArray[0] = SET_ROB // Code 
            
            // Horizontal Pot0
            let w = Double(Joystickfeld.bounds.size.width) // Breite Joystickfeld
            let faktorw:Double = (Pot0_Slider.maxValue - Pot0_Slider.minValue) / w  // Normierung auf Feldbreite
            //      print("w: \(w) faktorw: \(faktorw)")
            var x = Double(punkt.x)
            if (x > w)
            {
               x = w
            }
            /*
             goto_x.integerValue = Int(Float(x*faktorw))
             joystick_x.integerValue = Int(Float(x*faktorw))
             goto_x_Stepper.integerValue = Int(Float(x*faktorw))
             */
            let achse0 = UInt16(Float(x*faktorw) * ROB_FAKTOR0)
            //print("x: \(x) achse0: \(achse0)")
            teensy.write_byteArray[ACHSE0_BYTE_H] = UInt8((achse0 & 0xFF00) >> 8) // hb
            teensy.write_byteArray[ACHSE0_BYTE_L] = UInt8((achse0 & 0x00FF) & 0xFF) // lb
            
            
            let h = Double(Joystickfeld.bounds.size.height)
            let faktorh:Double = (Pot1_Slider.maxValue - Pot1_Slider.minValue) / h  // Normierung auf Feldhoehe
            
            let faktorz = 1
            //     print("h: \(h) faktorh: \(faktorh)")
            var y = Double(punkt.y)
            if (y > h)
            {
               y = h
            }
            let z = 0
            
            /*
             goto_y.integerValue = Int(Float(y*faktorh))
             joystick_y.integerValue = Int(Float(y*faktorh))
             goto_y_Stepper.integerValue = Int(Float(y*faktorh))
             */
            
            let achse1 = UInt16(Float(y*faktorh) * ROB_FAKTOR1)
            //print("y: \(y) achse1: \(achse1)")
            teensy.write_byteArray[ACHSE1_BYTE_H] = UInt8((achse1 & 0xFF00) >> 8) // hb
            teensy.write_byteArray[ACHSE1_BYTE_L] = UInt8((achse1 & 0x00FF) & 0xFF) // lb
            
            let achse2 =  UInt16(Float(z*faktorz) * ROB_FAKTOR2)
            teensy.write_byteArray[ACHSE2_BYTE_H] = UInt8((achse2 & 0xFF00) >> 8) // hb
            teensy.write_byteArray[ACHSE2_BYTE_L] = UInt8((achse2 & 0x00FF) & 0xFF) // lb
            
            let message:String = info?["message"] as! String
            if ((message == "mousedown") && (first >= 0))// Polynom ohne mousedragged
            {
               
               teensy.write_byteArray[0] = SET_RING
               let anz:Int = servoPfad?.anzahlPunkte() ?? 0
               print("robot joystickAktion anz: \(anz)")
               if (wegindex > 1)
               {
                  print("")
                  print("robot joystickAktion cont achse0: \(achse0) achse1: \(achse1)  achse2: \(achse2) anz: \(String(describing: anz)) wegindex: \(wegindex)")
                  
                  let lastposition = servoPfad?.pfadarray.last
                  
                  let lastx:Int = Int(lastposition!.x)
                  let nextx:Int = Int(achse0)
                  let hypx:Int = (nextx - lastx) * (nextx - lastx)
                  
                  let lasty:Int = Int(lastposition!.y)
                  let nexty:Int = Int(achse1)
                  let hypy:Int = (nexty - lasty) * (nexty - lasty)
                  
                  let lastz:Int = Int(lastposition!.z)
                  let nextz:Int = Int(achse2)
                  let hypz:Int = (nextz - lastz) * (nextz - lastz)
                  
                  print("joystickAktion lastx: \(lastx) nextx: \(nextx) lasty: \(lasty) nexty: \(nexty) ***  lastz: \(lastz) nextz: \(nextz)")
                  
                  
                  let hyp:Float = (sqrt((Float(hypx + hypy + hypz)))) // Gesamter Weg ueber x,y,z
                  
                  let anzahlsteps = hyp/schrittweiteFeld.floatValue
                  print("Robot joystickAktion hyp: \(hyp) anzahlsteps: \(anzahlsteps) ")
                  
                  teensy.write_byteArray[HYP_BYTE_H] = UInt8((Int(hyp) & 0xFF00) >> 8) // hb
                  teensy.write_byteArray[HYP_BYTE_L] = UInt8((Int(hyp) & 0x00FF) & 0xFF) // lb
                  
                  teensy.write_byteArray[STEPS_BYTE_H] = UInt8((Int(anzahlsteps) & 0xFF00) >> 8) // hb
                  teensy.write_byteArray[STEPS_BYTE_L] = UInt8((Int(anzahlsteps) & 0x00FF) & 0xFF) // lb
                  
                  teensy.write_byteArray[INDEX_BYTE_H] = UInt8(((wegindex-1) & 0xFF00) >> 8) // hb // hb // Start, Index 0
                  teensy.write_byteArray[INDEX_BYTE_L] = UInt8(((wegindex-1) & 0x00FF) & 0xFF) // lb
                  
                  print("joystickAktion hypx: \(hypx) hypy: \(hypy) hypz: \(hypz) hyp: \(hyp)")
                  
               }
               else
               {
                  print("robot joystickAktion start achse0: \(achse0) achse1: \(achse1)  achse2: \(achse2) anz: \(anz) wegindex: \(wegindex)")
                  teensy.write_byteArray[HYP_BYTE_H] = 0 // hb // Start, keine Hypo
                  teensy.write_byteArray[HYP_BYTE_L] = 0 // lb
                  teensy.write_byteArray[INDEX_BYTE_H] = 0 // hb // Start, Index 0
                  teensy.write_byteArray[INDEX_BYTE_L] = 0 // lb
                  
               }
               
               servoPfad?.addPosition(newx: achse0, newy: achse1, newz: 0)
               
            }
         } // if 2000
         if (globalusbstatus > 0)
         {
            let senderfolg = teensy.send_USB()
            print("robot joystickaktion  senderfolg: \(senderfolg)")
         }
      }
      else
      {
         //         print("Robot joystickAktion passt nicht")
      }
      
      
   }
   
   //MARK Geometrie
   
   func checkgeometrie() -> Bool
   {
      if (endy.floatValue == 0)
      {
         return false
      }
      
      let hypoxy:Float = hypotf((endx.floatValue - startx.floatValue), (endy.floatValue - starty.floatValue))
      let hypoz :Float = hypotf(hypoxy,(endz.floatValue - startz.floatValue))
      if (hypoz > (arm0.floatValue + arm1.floatValue))
      {
         return false
      }
      return true
   }
   
   
   //MARK: Armwinkel
   
   
   @IBAction  func report_cleararmwinkel(_ sender: NSButton)
   {
      servoPfad?.clearPfadarray()
      startx.doubleValue = 0
      endx.doubleValue = 0
      starty.doubleValue = 0
      endy.doubleValue = 100
      startz.doubleValue = 10
      endz.doubleValue = 30
      
      
   }
   
   
   @IBAction  func report_setweg(_ sender: NSButton)
   {
      if (checkgeometrie() == true)
      {
         
         
         
         let intx0:UInt16 = UInt16(startx.integerValue)
         let inty0:UInt16 = UInt16(starty.integerValue)
         let intz0:UInt16 = UInt16(startz.integerValue)
         
         
         // servopfad endpos
  //       let intx1:UInt16 = UInt16(endx.integerValue)
  //       let inty1:UInt16 = UInt16(endy.integerValue)
  //       let intz1:UInt16 = UInt16(endz.integerValue)
         
         var newx:Float = 0
         var newy:Float = 0
         var newz:Float = 0
         servoPfad?.setStartposition(x: intx0, y: inty0, z: intz0)
         
         // raumdiagonale start-end
         let deltax0:Float = (endx.floatValue - startx.floatValue) * (endx.floatValue - startx.floatValue)
         let deltay0:Float = (endy.floatValue - starty.floatValue) * (endy.floatValue - starty.floatValue)
         let deltaz0:Float = (endz.floatValue - startz.floatValue) * (endz.floatValue - startz.floatValue)
                  
         let hyp0 = sqrt(deltax0 + deltay0 + deltaz0)
         
         let winkeltup = winkelvonpunkt3D(x: endx.doubleValue, y: endy.doubleValue, z: endz.doubleValue)
         print("report_setweg            winkelvonpunkt: \(winkeltup)")
         
         teensy.write_byteArray[0] = SET_WEG
         
         
          
         
         var posarray: [(Float, Float, Float )] = []
         var winkelarray: [(Float, Float, Float )] = []
         
         let startxfloat = startx.floatValue
         let startyfloat = starty.floatValue
         let startzfloat = startz.floatValue

         
         let endzfloat = endz.floatValue
         
         // arme:
         let r0 = arm0.floatValue
         let r1 = arm1.floatValue
         let winkelfaktor0 = rotfaktorfeld.floatValue // Multiplikator fuer rotwinkel, servoabhaengig
         let rotoffset0 = UInt16(Pot0_Stepper_L.intValue)

         let winkelfaktor1 = winkelfaktor1feld.doubleValue // Multiplikator fuer winkel1, servoaghaengig
         let winkel1 = winkelfaktor1 * winkeltup.1 // Achse 1
         let intpos1 = UInt16(winkel1)
         teensy.write_byteArray[ACHSE1_BYTE_H] = UInt8((intpos1 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE1_BYTE_L] = UInt8((intpos1 & 0x00FF) & 0xFF) // lb

         let startint1 = UInt16(Pot1_Stepper_L.intValue)
         teensy.write_byteArray[ACHSE1_START_BYTE_H] = UInt8((startint1 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE1_START_BYTE_L] = UInt8((startint1 & 0x00FF) & 0xFF) // lb

         let winkelfaktor2 = winkelfaktor2feld.doubleValue // Multiplikator fuer winkel2, servoaghaengig
         let winkel2 = winkelfaktor2 * winkeltup.2 // Achse 2
         
         let intpos2 = UInt16(winkel2)
         teensy.write_byteArray[ACHSE2_BYTE_H] = UInt8((intpos2 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE2_BYTE_L] = UInt8((intpos2 & 0x00FF) & 0xFF) // lb

         let startint2 = UInt16(Pot2_Stepper_L.intValue)
         teensy.write_byteArray[ACHSE2_START_BYTE_H] = UInt8((startint2 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE2_START_BYTE_L] = UInt8((startint2 & 0x00FF) & 0xFF) // lb
         
         print("report_setweg winkelfaktor0: \t\(winkelfaktor0) \t winkelfaktor1: \t\(winkelfaktor1) \t winkelfaktor2: \t\(winkelfaktor2)")
         print("report_setweg rotoffset0: \t\(rotoffset0) \t startint1: \t\(startint1) \t startint2: \t\(startint2)")

         rotwinkel.doubleValue = winkeltup.0  // Rotation
         
         
         var rot0:Float = Float((90 + winkeltup.0 ) )
         
         let winkel0 = winkelfaktor0 * rot0
         
         let intpos0 = UInt16(winkel0)
          
         print("report_setweg achse0 rot0: \(rot0) winkel0: \(winkel0)") 
         intpos0Feld.integerValue = Int(intpos0)
         teensy.write_byteArray[ACHSE0_BYTE_H] = UInt8((intpos0 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE0_BYTE_L] = UInt8((intpos0 & 0x00FF) & 0xFF) // lb

         teensy.write_byteArray[ACHSE0_START_BYTE_H] = UInt8((rotoffset0 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE0_START_BYTE_L] = UInt8((rotoffset0 & 0x00FF) & 0xFF) // lb

         // erste pos anlaufen mit setRob
         if (globalusbstatus > 0)
         {
            let senderfolg = teensy.send_USB()
            
         } 
      
         // servoPfad startpos
         var lastx:Float = (endx.floatValue)
         var lasty:Float = (endy.floatValue)
         var lastz:Float = (endz.floatValue)

         
         var zielxfloat = zielx.floatValue
         var zielyfloat = ziely.floatValue
         let zielzfloat = zielz.floatValue
     
         
         // Raumdiagonale von end zu ziel
         let deltax:Float = (zielxfloat - endx.floatValue) * (zielxfloat - endx.floatValue)
         let deltay:Float = (zielyfloat - endy.floatValue) * (zielyfloat - endy.floatValue)
         let deltaz:Float = (zielzfloat - endz.floatValue) * (zielzfloat - endz.floatValue)
         
         let hyp = sqrt(deltax + deltay + deltaz)

         let anzschritte = UInt16(hyp / schrittweiteFeld.floatValue)
         let anzfloat = hyp / schrittweiteFeld.floatValue
         // einzelschritte
         print("report_setweg hyp: \t\(hyp) \t anzschritte: \t\(anzschritte)")

         
         let dx = (zielxfloat - endx.floatValue) / anzfloat
         let dy = (zielyfloat - endy.floatValue) / anzfloat
         let dz = (zielzfloat - endz.floatValue) / anzfloat

         teensy.write_byteArray[0] = SET_WEG
         
         
         teensy.write_byteArray[STEPS_BYTE_H] = UInt8((Int(anzschritte) & 0xFF00) >> 8) // hb
         teensy.write_byteArray[STEPS_BYTE_L] = UInt8((Int(anzschritte) & 0x00FF) & 0xFF) // lb

         wegmarke = 0
         for i in 0...anzschritte
         {
            //posarray.append((xx:lastx,yy:lasty,zz:lastz))
            posarray.append((lastx,lasty,lastz))
            newx = lastx +  dx
            newy = lasty +  dy
            newz = lastz +  dz
            
            var diagxy:Float = hypotf((newx-startx.floatValue),(newy-starty.floatValue)) // Diagonale in xy-Ebene zwischen Endpunkten

            // winkel um z-achse 90° ist ri y-achse
            var phiz0 = asin((newx-startx.floatValue)/diagxy) * 180/(Float.pi)
      //      let phiz = 90 - phiz0
            phiz0 = 90 + phiz0
            // Ergebnisse 
            var xi0:Double = 0, yi0:Double = 0, xi1: Double = 0, yi1:Double = 0, xi11: Double = 0, yi11:Double = 0
            
            var robotarmwinkel:(Double,Double) = geometrie.armwinkel(absz0: Double(endx.floatValue) , ord0: Double(endz.floatValue), rad0: Double(r0), absz1: Double(diagxy), ord1: Double(newz), rad1: Double(r1))

            winkelarray.append((phiz0 * winkelfaktor0,Float(robotarmwinkel.0 * winkelfaktor1), Float(robotarmwinkel.1 * winkelfaktor2)))
            
            
            lastx = newx
            lasty = newy
            lastz = newz
          //  print("newx: \t\(newx) \tnewy: \t\(newy)\t newz: \t\(newz) ")
            
            // Rot. Winkel
            rotwinkel.doubleValue = Double(phiz0)  // Rotation
            
            let intpos0 = UInt16(phiz0 * winkelfaktor0)
            
            teensy.write_byteArray[ACHSE0_BYTE_H] = UInt8((intpos0 & 0xFF00) >> 8) // hb
            teensy.write_byteArray[ACHSE0_BYTE_L] = UInt8((intpos0 & 0x00FF) & 0xFF) // lb
            
            teensy.write_byteArray[ACHSE0_START_BYTE_H] = UInt8((rotoffset0 & 0xFF00) >> 8) // hb
            teensy.write_byteArray[ACHSE0_START_BYTE_L] = UInt8((rotoffset0 & 0x00FF) & 0xFF) // lb

            
            // Winkel 1: arm 0
            let winkel1 = winkelfaktor1 * (robotarmwinkel.0)
       //     print("report_setarmwinkel ausgabewinkel1: \(winkel1)")
            
            let intpos1 = UInt16(winkel1)
            
            teensy.write_byteArray[ACHSE1_BYTE_H] = UInt8((intpos1 & 0xFF00) >> 8) // hb
            teensy.write_byteArray[ACHSE1_BYTE_L] = UInt8((intpos1 & 0x00FF) & 0xFF) // lb
           
            teensy.write_byteArray[ACHSE1_START_BYTE_H] = UInt8((startint1 & 0xFF00) >> 8) // hb
            teensy.write_byteArray[ACHSE1_START_BYTE_L] = UInt8((startint1 & 0x00FF) & 0xFF) // lb

            // Winkel 2: arm 1
            let winkel2 = winkelfaktor2 *  (robotarmwinkel.1)
       //     print("report_setarmwinkel ausgabewinkel2: \(winkel2)")
            let intpos2 = UInt16(winkel2) 
            teensy.write_byteArray[ACHSE2_BYTE_H] = UInt8((intpos2 & 0xFF00) >> 8) // hb
            teensy.write_byteArray[ACHSE2_BYTE_L] = UInt8((intpos2 & 0x00FF) & 0xFF) // lb
            
            teensy.write_byteArray[ACHSE2_START_BYTE_H] = UInt8((startint2 & 0xFF00) >> 8) // hb
            teensy.write_byteArray[ACHSE2_START_BYTE_L] = UInt8((startint2 & 0x00FF) & 0xFF) // lb
             
            teensy.write_byteArray[INDEX_BYTE_H] = UInt8(((wegmarke) & 0xFF00) >> 8) // hb // hb // Start, Index 0
            teensy.write_byteArray[INDEX_BYTE_L] = UInt8(((wegmarke) & 0x00FF) & 0xFF) // lb
            
            print("\(wegmarke)\t\(intpos0)\t\(winkel1)\t\(winkel2)")
            if (globalusbstatus > 0)
            {
               let senderfolg = teensy.send_USB()
            } 
            wegmarke += 1
            
            
            
         } // for
         
         //print("posarray: \(posarray)")
         //print("winkelarray: \(winkelarray)")
         var i=0
         for zeile in winkelarray
         {
            print("\(i)\t\(zeile.0)\t\(zeile.1)\t\(zeile.2)")
            i += 1
         }
         
         
      } // if checkgeometrie
      else
      {
         print("Weg: Geometrie hat keine Lösung")
         /*
         armwinkel1.stringValue = "---"
         armwinkel2.stringValue = "---"
         rotwinkel.stringValue = "-"
         */
      }

   }
   
   @IBAction  func report_setarmwinkel(_ sender: NSButton)
   {
      if (checkgeometrie() == true)
      {
         // servoPfad startpos
         let intx0:UInt16 = UInt16(startx.integerValue)
         let inty0:UInt16 = UInt16(starty.integerValue)
         let intz0:UInt16 = UInt16(startz.integerValue)
 
         // servopfad endpos
   //      let intx1:UInt16 = UInt16(endx.integerValue)
   //      let inty1:UInt16 = UInt16(endy.integerValue)
   //      let intz1:UInt16 = UInt16(endz.integerValue)

         
         servoPfad?.setStartposition(x: intx0, y: inty0, z: intz0)
         
         let deltax:Float = (endx.floatValue - startx.floatValue) * (endx.floatValue - startx.floatValue)
         let deltay:Float = (endy.floatValue - starty.floatValue) * (endy.floatValue - starty.floatValue)
         let deltaz:Float = (endz.floatValue - startz.floatValue) * (endz.floatValue - startz.floatValue)
         
         let hyp = sqrt(deltax + deltay + deltaz)
         let anzschritte = UInt16(hyp / schrittweiteFeld.floatValue)
         print("report_setarmwinkel hyp: \(hyp) anzschritte: \(anzschritte)")

         teensy.write_byteArray[0] = SET_ROB
 
         let winkeltup = winkelvonpunkt3D(x: endx.doubleValue, y: endy.doubleValue, z: endz.doubleValue)
         print("report_setarmwinkel            winkelvonpunkt: \(winkeltup)")
 //        print("report_setarmwinkel  code: \(teensy.write_byteArray[0])")
         if (winkeltup.1 < 0) // Arm 1
         {
            let alert = NSAlert()
            alert.messageText = "Ausserhalb Arbeitsbereich"
            alert.informativeText = "Winkel 1 ist < 0."
            alert.beginSheetModal(for: self.view.window!) 
            { 
               (response) in
            }
            return
         }
         
          
         RobotarmFeld.setstartpunkt(punkt: NSMakePoint(0,CGFloat(startz?.floatValue ?? 0)))
         armwinkel1.doubleValue = winkeltup.1 // Achse 1
         x1_Slider.integerValue = endx.integerValue
         RobotarmFeld.setpath0(len: CGFloat(arm0.floatValue), winkel: CGFloat(winkeltup.1))
        
         let winkelfaktor1 = winkelfaktor1feld.floatValue // Multiplikator fuer winkel1, servoaghaengig
         let winkel1 = winkelfaktor1 * armwinkel1.floatValue
         print("report_setarmwinkel ausgabe1: \(winkel1)")
         
  //       let intpos1 = UInt16((winkel1) * ROB_FAKTOR1)
         let intpos1 = UInt16(winkel1)
          
         teensy.write_byteArray[ACHSE1_BYTE_H] = UInt8((intpos1 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE1_BYTE_L] = UInt8((intpos1 & 0x00FF) & 0xFF) // lb
         let startint1 = UInt16(Pot1_Stepper_L.intValue)
         teensy.write_byteArray[ACHSE1_START_BYTE_H] = UInt8((startint1 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE1_START_BYTE_L] = UInt8((startint1 & 0x00FF) & 0xFF) // lb

         
         //
         
         
  //       self.setAchse1(pos: winkel1)

         armwinkel2.doubleValue = winkeltup.2 // Achse 2
         y1_Slider.integerValue = endy.integerValue
         
         RobotarmFeld.setpath1(len: CGFloat(arm1.floatValue), winkel: CGFloat(winkeltup.1 + winkeltup.2))
         let winkelfaktor2 = winkelfaktor2feld.floatValue // Multiplikator fuer winkel1, servoabhaengig
         let winkel2 = winkelfaktor2 * armwinkel2.floatValue
         
         print("report_setarmwinkel ausgabe2: \(winkel2)")
         
 //        let intpos2 = UInt16((winkel2) * ROB_FAKTOR2)
         let intpos2 = UInt16(winkel2) 
         
         teensy.write_byteArray[ACHSE2_BYTE_H] = UInt8((intpos2 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE2_BYTE_L] = UInt8((intpos2 & 0x00FF) & 0xFF) // lb
         let startint2 = UInt16(Pot2_Stepper_L.intValue)
         teensy.write_byteArray[ACHSE2_START_BYTE_H] = UInt8((startint2 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE2_START_BYTE_L] = UInt8((startint2 & 0x00FF) & 0xFF) // lb
       
         if (winkeltup.0.isNaN)
         {
            print("winkeltup.0 ist NaN")
            return
         }

         rotwinkel.doubleValue = winkeltup.0  // Rotation
         
         let winkelfaktor0 = rotfaktorfeld.floatValue // Multiplikator fuer rotwinkel, servoabhaengig
         
         var rot0:Float = Float((90 + winkeltup.0 ) )
         
         let winkel0 = winkelfaktor0 * rot0
         
         let intpos0 = UInt16(winkel0)
         
         pos0Feld.integerValue = Int(rot0)
         //let introt0 = UInt16((rot0) * ROB_FAKTOR0) 
         
         
         print("report_setarmwinkel achse0 rot0: \(rot0) winkel0: \(winkel0)") 
         intpos0Feld.integerValue = Int(intpos0)
         teensy.write_byteArray[ACHSE0_BYTE_H] = UInt8((intpos0 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE0_BYTE_L] = UInt8((intpos0 & 0x00FF) & 0xFF) // lb
         var rotoffset0:UInt16 = 1
     //    rotoffset0 = UInt16(rotoffsetstepper.integerValue)
         rotoffset0 = UInt16(Pot0_Stepper_L.intValue)
         teensy.write_byteArray[ACHSE0_START_BYTE_H] = UInt8((rotoffset0 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE0_START_BYTE_L] = UInt8((rotoffset0 & 0x00FF) & 0xFF) // lb

         
         
        
         if (globalusbstatus > 0)
         {
            let senderfolg = teensy.send_USB()
            
         } 
         /*
             */
         
         
            return
               
               
         // set Robot
         teensy.write_byteArray[0] = SET_ROB // Code
         
         
         // Achse 1 Armwinkel 0 
         var pos1:Float = Float((180 - winkeltup.1 ) * 10)
         pos1Feld.integerValue = Int(pos1)
         //let intpos1 = UInt16((pos1) * ROB_FAKTOR1)
         print("report_setarmwinkel achse1 pos1: \(pos1) intpos1: \(intpos1)") 
         intpos1Feld.integerValue = Int(intpos1)
         
 
         teensy.write_byteArray[ACHSE1_BYTE_H] = UInt8((intpos1 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE1_BYTE_L] = UInt8((intpos1 & 0x00FF) & 0xFF) // lb

         var offset1 = UInt16(pot1offsetstepper.integerValue)
         teensy.write_byteArray[ACHSE1_START_BYTE_H] = UInt8((offset1 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE1_START_BYTE_L] = UInt8((offset1 & 0x00FF) & 0xFF) // lb
        
         
         
         // Achse 2 Armwinkel 1
         var pos2:Float = Float((180 - winkeltup.2 ) * 10)
         pos2Feld.integerValue = Int(pos2)
         //let intpos2 = UInt16((pos2) * ROB_FAKTOR2)
         print("set robot achse2 pos2: \(pos2) intpos2: \(intpos2)") 
         intpos2Feld.integerValue = Int(intpos2)
         teensy.write_byteArray[ACHSE2_BYTE_H] = UInt8((intpos2 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE2_BYTE_L] = UInt8((intpos2 & 0x00FF) & 0xFF) // lb
         
         var offset2 = UInt16(pot2offsetstepper.integerValue)
         teensy.write_byteArray[ACHSE2_START_BYTE_H] = UInt8((offset2 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE2_START_BYTE_L] = UInt8((offset2 & 0x00FF) & 0xFF) // lb
         
         
         // Rotwinkel
         if (winkeltup.2.isNaN)
         {
            print("winkeltup.2 ist NaN")
            return
         }
         /*
         var rot0:Float = Float((180 - winkeltup.2 ) * 10)
         pos0Feld.integerValue = Int(rot0)
         let introt0 = UInt16((rot0) * ROB_FAKTOR0) 
         print("report_setarmwinkel achse0 rot0: \(rot0) introt0: \(introt0)") 
         intpos0Feld.integerValue = Int(introt0)
         teensy.write_byteArray[ACHSE0_BYTE_H] = UInt8((introt0 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE0_BYTE_L] = UInt8((introt0 & 0x00FF) & 0xFF) // lb
         var rotoffset0:UInt16 = 1
         rotoffset0 = UInt16(rotoffsetstepper.integerValue)
         teensy.write_byteArray[ACHSE0_START_BYTE_H] = UInt8((rotoffset0 & 0xFF00) >> 8) // hb
         teensy.write_byteArray[ACHSE0_START_BYTE_L] = UInt8((rotoffset0 & 0x00FF) & 0xFF) // lb
         */
         /*
          // Armwinkel 2
          var pos1:Float = Float((180 - winkeltup.1 ) * 10)
          pos1Feld.integerValue = Int(pos1)
          let intpos1 = UInt16((pos1) * ROB_FAKTOR1)
          print("set robot achse1 pos1: \(pos1) intpos1: \(intpos1)") 
          intpos1Feld.integerValue = Int(intpos1)
          teensy.write_byteArray[ACHSE1_BYTE_H] = UInt8((intpos1 & 0xFF00) >> 8) // hb
          teensy.write_byteArray[ACHSE1_BYTE_L] = UInt8((intpos1 & 0x00FF) & 0xFF) // lb
          */
         if (globalusbstatus > 0)
         {
            let senderfolg = teensy.send_USB()
            
         }
         
      }
      else
      {
         print("Geometrie hat keine Lösung")
         armwinkel1.stringValue = "---"
         armwinkel2.stringValue = "---"
         rotwinkel.stringValue = "-"
         
      }
      
   }
   
   // Pot 1
   @IBAction  func report_rotoffsetstepper(_ sender: NSStepper) // untere Grenze
   {
      print("Robot report_rotoffsetstepper IntVal: \(sender.integerValue)")
      teensy.write_byteArray[0] = SET_0 // Code 
      // Offset
      let intpos = sender.integerValue 
      rotoffsetfeld.integerValue = intpos
      print("report_rotoffsetstepper offset: \(intpos)")
      teensy.write_byteArray[ACHSE0_START_BYTE_H] = UInt8((intpos & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE0_START_BYTE_L] = UInt8((intpos & 0x00FF) & 0xFF) // lb
      
      // winkel
      let intpos0 = intpos0Feld.integerValue 
      teensy.write_byteArray[ACHSE0_BYTE_H] = UInt8((intpos0 & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE0_BYTE_L] = UInt8((intpos0 & 0x00FF) & 0xFF) // lb

      if (globalusbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
         
      }
   }

   @IBAction  func report_pot1offsetstepper(_ sender: NSStepper) // untere Grenze
   {
      //print("Robot report_pot1offsetstepper IntVal: \(sender.integerValue)")
      teensy.write_byteArray[0] = SET_1
      // Offset
      let offset1 = sender.integerValue 
      pot1offsetfeld.integerValue = offset1
      
      teensy.write_byteArray[ACHSE1_START_BYTE_H] = UInt8((offset1 & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE1_START_BYTE_L] = UInt8((offset1 & 0x00FF) & 0xFF) // lb
     
      // Winkel
      let intpos1 = intpos1Feld.integerValue 
      teensy.write_byteArray[ACHSE1_BYTE_H] = UInt8((intpos1 & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE1_BYTE_L] = UInt8((intpos1 & 0x00FF) & 0xFF) // lb
      print("report_pot1offsetstepper intpos1: \(intpos1) offset1: \(offset1)")
      
      if (globalusbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
         
      }
   }

 // Pot 2 
   
   @IBAction  func report_pot2offsetstepper(_ sender: NSStepper) // untere Grenze
   {
      //print("Robot report_pot2offsetstepper IntVal: \(sender.integerValue)")
      teensy.write_byteArray[0] = SET_2
      // Offset
      let offset2 = sender.integerValue 
      pot2offsetfeld.integerValue = offset2
      
      teensy.write_byteArray[ACHSE2_START_BYTE_H] = UInt8((offset2 & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE2_START_BYTE_L] = UInt8((offset2 & 0x00FF) & 0xFF) // lb
      
      // Winkel
      let intpos2 = intpos2Feld.integerValue 
      teensy.write_byteArray[ACHSE2_BYTE_H] = UInt8((intpos2 & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE2_BYTE_L] = UInt8((intpos2 & 0x00FF) & 0xFF) // lb
      print("report_pot2offsetstepper intpos2: \(intpos2) offset2: \(offset2)")
      
      if (globalusbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
         
      }
   }

   @IBAction  func report_winkelfaktor1stepper(_ sender: NSStepper) // faktor fuer °
   {
      teensy.write_byteArray[0] = SET_1
      
      winkelfaktor1feld.floatValue = sender.floatValue
   }
   
   @IBAction  func report_winkelfaktor2stepper(_ sender: NSStepper) // faktor fuer °
   {
      teensy.write_byteArray[0] = SET_2
      
      winkelfaktor2feld.floatValue = sender.floatValue
   }

   @IBAction  func report_rotfaktorstepper(_ sender: NSStepper) // faktor fuer °
   {
      teensy.write_byteArray[0] = SET_0
      
      rotfaktorfeld.floatValue = sender.floatValue
   }

   //MARK:setrotwinkel
   @IBAction  func report_setrotwinkel(_ sender: NSButton) 
   {
      print("report_setrotwinkel winkel: \(rotwinkel.floatValue)")
      let rotfaktor = rotfaktorfeld.floatValue
      let winkel0 = rotfaktor * (90 + rotwinkel.floatValue)
      print("report_setrotwinkel ausgabe: \(winkel0)")
      
      //RobotarmFeld.setpath0(len: CGFloat(arm0.floatValue), winkel: CGFloat(armwinkel1.floatValue))
      
      self.setAchse0(pos: winkel0)
      
   }

   @IBAction  func report_setarmwinkel1(_ sender: NSButton) 
   {
      print("report_setarmwinkel1 winkel: \(armwinkel1.floatValue)")
      let winkelfaktor1 = winkelfaktor1feld.floatValue
      let winkel1 = winkelfaktor1 * armwinkel1.floatValue
      print("report_setarmwinkel1 ausgabe: \(winkel1)")
      
      RobotarmFeld.setpath0(len: CGFloat(arm0.floatValue), winkel: CGFloat(armwinkel1.floatValue))

      self.setAchse1(pos: winkel1)
      
   }
   
   @IBAction  func report_setarmwinkel2(_ sender: NSButton) 
   {
      print("report_setarmwinkel2 winkel: \(armwinkel2.floatValue)")
      let winkelfaktor2 = winkelfaktor2feld.floatValue
      let winkel2 = winkelfaktor2 * armwinkel2.floatValue
      print("report_setarmwinkel2 ausgabe: \(winkel2)")
      self.setAchse2(pos: winkel2)
      
   }

   
   // nur 2 Dim: x,z. y1 alz z benutzt
   func winkelvonpunkt( x:Double  ,  y:Double,   z:Double) -> (Double, Double)
   {
      var phi0:Double , phi1:Double 
      phi0 = 13
      phi1 = 17
      //   let arm0:Double = 75
      //   let arm1:Double = 65
      var x0:Double = startx.doubleValue, y0:Double = startz.doubleValue, r0:Double = arm0.doubleValue, x1:Double = endx.doubleValue, y1:Double = endz.doubleValue, r1:Double = arm1.doubleValue 
      
      //   x1 = x
      //   y1 = y
      //     z1 = z
      var xi0:Double = 0, yi0:Double = 0, xi1: Double = 0, yi1:Double = 0, xi11: Double = 0, yi11:Double = 0
      /*
       int circle_circle_intersection(double x0, double y0, double r0,
       double x1, double y1, double r1,
       double *xi, double *yi,
       double *xi_prime, double *yi_prime)
       
       */
      //   var resultat = circle_circle_intersection(0, 0, arm0, x, y, arm1, &xi1, &yi1, &xi11, &yi11)
      
      var robotarmwinkel:(Double,Double) = geometrie.armwinkel(absz0: x0 , ord0: y0, rad0: r0, absz1: x1, ord1: y1, rad1: r1)
      print("robotarmwinkel: \(robotarmwinkel)")
      //    Swift.print("
      return (robotarmwinkel.0, robotarmwinkel.1)
   }
   
   func winkelvonpunkt3D( x:Double  ,  y:Double,   z:Double) -> (Double, Double, Double)
   {
      var phi0:Double , phi1:Double ,phi2:Double
      phi0 = 13
      phi1 = 17
      phi2 = 10
      //   let arm0:Double = 75
      //   let arm1:Double = 65
      
      // Werte aus Eingabefeldern
      var x0:Double = startx.doubleValue, y0:Double = starty.doubleValue, z0:Double = startz.doubleValue, r0:Double = arm0.doubleValue, r1:Double = arm1.doubleValue
      
      
      var x1:Double = endx.doubleValue, y1:Double = endy.doubleValue, z1:Double = endz.doubleValue 
      
 //     print("x1: \(x1) x0: \(x0)  y1: \(y1)  y0: \(y0)   z0: \(z0)   z1: \(z1)")
      // Diagonale x,y:
      var diagxy:Float = hypotf((Float(x1-x0)),Float(y1-y0)) // Diagonale in xy-Ebene zwischen Endpunkten
      
      // winkel um z-achse 90° ist ri y-achse
      var phiz0:Float = asin(Float(x1-x0)/diagxy) * 180/(Float.pi)
      
      let phiz = 90 - phiz0
      //   x1 = x
      //   y1 = y
      //     z1 = z
      // Ergebnisse 
      var xi0:Double = 0, yi0:Double = 0, xi1: Double = 0, yi1:Double = 0, xi11: Double = 0, yi11:Double = 0
      /*
       int circle_circle_intersection(double x0, double y0, double r0,
       double x1, double y1, double r1,
       double *xi, double *yi,
       double *xi_prime, double *yi_prime)
       
       */
      //   var resultat = circle_circle_intersection(0, 0, arm0, x, y, arm1, &xi1, &yi1, &xi11, &yi11)
      
      var robotarmwinkel:(Double,Double) = geometrie.armwinkel(absz0: x0 , ord0: z0, rad0: r0, absz1: Double(diagxy), ord1: z1, rad1: r1)
//      print("diagxy: \(diagxy) robotarmwinkel.0: \(robotarmwinkel.0) robotarmwinkel.1: \(robotarmwinkel.1) phiz0: \(phiz0) phiz: \(phiz)")
      //    Swift.print("
      
      return (Double(phiz0),robotarmwinkel.0, robotarmwinkel.1)
      //return (robotarmwinkel.0, robotarmwinkel.1)
   }
   
   
   
   //MARK: Slider 0
   @IBAction override func report_Slider0(_ sender: NSSlider)
   {
      teensy.write_byteArray[0] = SET_0 // Code 
  //    print("Robot report_Slider0 IntVal: \(sender.intValue)")
      
      let pos = sender.floatValue
      
      let intpos = UInt16(pos * ROB_FAKTOR0)
      let Ustring = formatter.string(from: NSNumber(value: intpos))
      
      print("report_Slider0 pos: \(pos) intpos: \(intpos)")
      // Pot0_Feld.stringValue  = Ustring!
      Pot0_Feld.integerValue = Int(intpos)
 //     Pot0_Stepper_L.integerValue  = Int(sender.minValue) // Stepper min setzen
  //    Pot0_Stepper_L_Feld.integerValue = Int(sender.minValue)
      Pot0_Stepper_H.integerValue  = Int(sender.maxValue) // Stepper max setzen
      Pot0_Stepper_H_Feld.integerValue = Int(sender.maxValue)
      
      setAchse0(pos: pos * ROB_FAKTOR0)
      /*
      teensy.write_byteArray[ACHSE0_BYTE_H] = UInt8((intpos & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE0_BYTE_L] = UInt8((intpos & 0x00FF) & 0xFF) // lb

      let startint = UInt16(Pot0_Stepper_L.intValue)
      teensy.write_byteArray[ACHSE0_START_BYTE_H] = UInt8((startint & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE0_START_BYTE_L] = UInt8((startint & 0x00FF) & 0xFF) // lb
 
      if (usbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
         print("Robot report_Slider0 senderfolg: \(senderfolg)")
      }
 */
   }
   @IBAction override func report_Pot0_Stepper_L(_ sender: NSStepper) // untere Grenze
   {
      print("Robot report_Pot0_Stepper_L IntVal: \(sender.integerValue)")
      
      let intpos = sender.integerValue 
      Pot0_Stepper_L_Feld.integerValue = intpos
      
//      Pot0_Slider.minValue = sender.doubleValue 
      print("report_Pot0_Stepper_L Pot0_Slider.minValue: \(Pot0_Slider.minValue)")
      
   }
   
   @IBAction override func report_Pot0_Stepper_H(_ sender: NSStepper)// Obere Grenze
   {
      print("Robot report_Pot0_Stepper_H IntVal: \(sender.integerValue)")
      
      let intpos = sender.integerValue 
      Pot0_Stepper_H_Feld.integerValue = intpos
      
      Pot0_Slider.maxValue = sender.doubleValue 
      print("report_Pot0_Stepper_H Pot0_Slider.maxValue: \(Pot0_Slider.maxValue)")
      
   }
   @IBAction override func report_set_Pot0(_ sender: NSTextField)
   {
      teensy.write_byteArray[0] = SET_0 // Code 
      
      // senden mit faktor 1000
      //let u = Pot0_Feld.floatValue 
      let Pot0_wert = Pot0_Feld.floatValue * 100
      let Pot0_intwert = UInt(Pot0_wert)
      
      let Pot0_HI = (Pot0_intwert & 0xFF00) >> 8
      let Pot0_LO = Pot0_intwert & 0x00FF
      
      print("Robot report_set_Pot0 Pot0_wert: \(Pot0_wert) Pot0 HI: \(Pot0_HI) Pot0 LO: \(Pot0_LO) ")
      let intpos = sender.intValue 
      self.Pot0_Slider.floatValue = Pot0_wert //sender.floatValue
      self.Pot0_Stepper_L.floatValue = Pot0_wert//sender.floatValue
      
      teensy.write_byteArray[ACHSE0_BYTE_H] = UInt8(Pot0_LO)
      teensy.write_byteArray[ACHSE0_BYTE_L] = UInt8(Pot0_HI)
      
      if (usbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
         if (senderfolg < BUFFER_SIZE)
         {
            print("report_set_Pot0 U: %d",senderfolg)
         }
      }
   }
   
   @objc func setAchse0(pos: Float)
   {
      // min 2640
      print(" setAchse0 pos: \(pos)")
      teensy.write_byteArray[0] = SET_0 // Code
      //     let intpos = UInt16((pos) * ROB_FAKTOR1)
      let intpos = UInt16(pos)
      teensy.write_byteArray[ACHSE0_BYTE_H] = UInt8((intpos & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE0_BYTE_L] = UInt8((intpos & 0x00FF) & 0xFF) // lb
      let startint = UInt16(Pot0_Stepper_L.intValue)
      teensy.write_byteArray[ACHSE0_START_BYTE_H] = UInt8((startint & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE0_START_BYTE_L] = UInt8((startint & 0x00FF) & 0xFF) // lb
      
      let ausgabe0 = intpos + startint
      let winkel0 = pos / rotfaktorfeld.floatValue
      print("setAchse0 intpos: \(intpos) startint: \(startint) ausgabe0: \(ausgabe0) winkel0: \(winkel0)")
      if (globalusbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
         
      }
   }

   //MARK: xyz-Slider
   
   @IBAction  func report_x1_Slider(_ sender: NSSlider)
   {
 //     teensy.write_byteArray[0] = SET_1 // Code
      print("Robot report_x1_Slider IntVal: \(sender.intValue)")
      endx.integerValue = sender.integerValue
      
      
   }
   
   @IBAction  func report_y1_Slider(_ sender: NSSlider)
   {
 //     teensy.write_byteArray[0] = SET_1 // Code
      print("Robot report_y1_Slider IntVal: \(sender.intValue)")
      endy.integerValue = sender.integerValue
      
      
   }
   
   @IBAction  func report_z1_Slider(_ sender: NSSlider)
   {
 //     teensy.write_byteArray[0] = SET_1 // Code
      print("Robot report_z1_Slider IntVal: \(sender.intValue)")
      endz.integerValue = sender.integerValue
      
      
   }
   
   // MARK:Slider 1
   @IBAction override func report_Slider1(_ sender: NSSlider)
   {
      teensy.write_byteArray[0] = SET_1 // Code
      
 //     let name = UserDefaults.standard.string(forKey: "name")
 //     let robot1_offset = UserDefaults.standard.integer(forKey: "robot1offset")
      
   //   print(name)

 //    print("report_Slider1 float: \(sender.floatValue) min: \(sender.minValue) ")
      /*
       let pos = sender.floatValue
       Pot1_Feld_raw.integerValue = Int(pos)
       let intpos = UInt16(pos * FAKTOR1)
       //     let Istring = formatter.string(from: NSNumber(value: intpos))
       */
      let inv = Pot1_Inverse_Check.state.rawValue
      var pos:Float = 0
      if (inv == 0)
      {
         pos = sender.floatValue 
      }
      else
      {
         pos = Float(sender.maxValue) - sender.floatValue + Float(sender.minValue)
      }
      
      let intpos = UInt16(pos  * ROB_FAKTOR1)
      print("report_Slider1 pos: \(pos) intpos: \(intpos) ") 
      Pot1_Feld_raw.integerValue  = Int(pos)
      Pot1_Feld.integerValue  = Int(intpos)
      
      
      setAchse1(pos: (pos  * ROB_FAKTOR1)) // intpos
    }
   
   @objc func setAchse1(pos: Float)
   {
      // min 2640
      print(" setAchse1 pos: \(pos)")
      teensy.write_byteArray[0] = SET_1 // Code
 //     let intpos = UInt16((pos) * ROB_FAKTOR1)
      let intpos = UInt16(pos)
      teensy.write_byteArray[ACHSE1_BYTE_H] = UInt8((intpos & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE1_BYTE_L] = UInt8((intpos & 0x00FF) & 0xFF) // lb
      let startint = UInt16(Pot1_Stepper_L.intValue)
      teensy.write_byteArray[ACHSE1_START_BYTE_H] = UInt8((startint & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE1_START_BYTE_L] = UInt8((startint & 0x00FF) & 0xFF) // lb
      
      let ausgabe1 = intpos + startint
      let winkel1 = pos / winkelfaktor1feld.floatValue
      print("setAchse1 intpos: \(intpos) startint: \(startint) ausgabe1: \(ausgabe1) winkel1: \(winkel1)")
      if (globalusbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
         
      }
   }
   
   
   
   @IBAction override func report_Pot1_Stepper_L(_ sender: NSStepper) // untere Grenze
   {
      print("Robot report_Pot1_Stepper_L IntVal: \(sender.integerValue)")
      
      let intpos = sender.integerValue 
      Pot1_Stepper_L_Feld.integerValue = intpos
      
      //Pot1_Slider.minValue = sender.doubleValue 
      //print("report_Pot1_Stepper_L Pot1_Slider.minValue: \(Pot1_Slider.minValue)")
      
      
   }
   
   @IBAction override func report_Pot1_Stepper_H(_ sender: NSStepper)// Obere Grenze
   {
      print("report_Pot1_Stepper_H IntVal: \(sender.integerValue)")
      
      let intpos = sender.integerValue 
      Pot1_Stepper_H_Feld.integerValue = intpos
      
      //Pot1_Slider.maxValue = sender.doubleValue 
      //print("report_Pot1_Stepper_H Pot1_Slider.maxValue: \(Pot1_Slider.maxValue)")
      
   }
   
   // MARK:Slider 2
   @IBAction override func report_Slider2(_ sender: NSSlider)
   {
      UserDefaults.standard.set("Ruedi Heimlicher", forKey: "name")
      
      teensy.write_byteArray[0] = SET_2 // Code 
      print("Robot report_Slider2 IntVal: \(sender.intValue)")
      let inv = Pot2_Inverse_Check.state.rawValue
      var pos:Float = 0
      if (inv == 0)
      {
         pos = sender.floatValue
         /*
         Pot2_Stepper_L.integerValue  = Int(sender.minValue) // Stepper min setzen
         Pot2_Stepper_L_Feld.integerValue = Int(sender.minValue)
         Pot2_Stepper_H.integerValue  = Int(sender.maxValue) // Stepper max setzen
         Pot2_Stepper_H_Feld.integerValue = Int(sender.maxValue)
         */
      }
      else
      {
         pos = Float(sender.maxValue) - sender.floatValue + Float(sender.minValue)
         Pot2_Stepper_L.integerValue  = Int(sender.maxValue) // Stepper min setzen
         Pot2_Stepper_L_Feld.integerValue = Int(sender.maxValue)
         Pot2_Stepper_H.integerValue  = Int(sender.minValue) // Stepper max setzen
         Pot2_Stepper_H_Feld.integerValue = Int(sender.minValue)
         
         
      }
      let intpos = UInt16(pos * ROB_FAKTOR2)
      
      
      Pot2_Feld_raw.integerValue  = Int(pos)
      Pot2_Feld.integerValue  = Int(intpos)
      
      setAchse2(pos: pos * ROB_FAKTOR2)
      
   }
   
   @objc func setAchse2(pos: Float)
   {
      print("setAchse2 pos: \(pos)")
      teensy.write_byteArray[0] = SET_2 // Code
   //   let intpos = UInt16((pos) * ROB_FAKTOR2)
      let intpos = UInt16(pos)
      teensy.write_byteArray[ACHSE2_BYTE_H] = UInt8((intpos & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE2_BYTE_L] = UInt8((intpos & 0x00FF) & 0xFF) // lb
      let startint = UInt16(Pot2_Stepper_L.intValue)
      teensy.write_byteArray[ACHSE2_START_BYTE_H] = UInt8((startint & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE2_START_BYTE_L] = UInt8((startint & 0x00FF) & 0xFF) // lb
      let wert2 = intpos + startint
      let winkel2 = pos / winkelfaktor2feld.floatValue
      print("setAchse2 intpos: \(intpos) startint: \(startint) ausgabe2: \(wert2) winkel2: \(winkel2)")
      if (globalusbstatus > 0)
      {
         let senderfolg = teensy.send_USB()         
      }
      
      
      
   }

   
   @IBAction override func report_Pot2_Stepper_L(_ sender: NSStepper) // untere Grenze
   {
      print("report_Pot2_Stepper_L IntVal: \(sender.integerValue)")
      let inv = Pot2_Inverse_Check.state.rawValue
      var intpos = 0
      if (inv == 0)
      {
         intpos = sender.integerValue 
         Pot2_Slider.minValue = sender.doubleValue 
      }
      else
      {
         intpos = Int(Pot2_Slider.maxValue) - sender.integerValue + Int(Pot2_Slider.minValue)
         Pot2_Slider.maxValue = sender.doubleValue
      }
      
      Pot2_Stepper_L_Feld.integerValue = intpos
      
      
      print("report_Pot2_Stepper_L Pot2_Slider.minValue: \(Pot2_Slider.minValue)")
      
   }
   
   @IBAction override func report_Pot2_Stepper_H(_ sender: NSStepper)// Obere Grenze
   {
      print("report_Pot2_Stepper_H IntVal: \(sender.integerValue)")
      
      let intpos = sender.integerValue 
      Pot2_Stepper_H_Feld.integerValue = intpos
      
      Pot2_Slider.maxValue = sender.doubleValue 
      print("report_Pot2_Stepper_H Pot2_Slider.maxValue: \(Pot2_Slider.maxValue)")
      
   }
   
   
   
   @IBAction override func report_Slider3(_ sender: NSSlider)
   {
      teensy.write_byteArray[0] = SET_3 // Code 
      print("Robot report_Slider3 IntVal: \(sender.intValue)")
      
      let pos = sender.floatValue
      
      let intpos = UInt16(pos * FAKTOR3)
      let Ustring = formatter.string(from: NSNumber(value: intpos))
      
      //print("report_Slider3 pos: \(pos) intpos: \(intpos)  Ustring: \(Ustring ?? "0")")
      // Pot0_Feld.stringValue  = Ustring!
      Pot3_Feld.integerValue  = Int(intpos)
      Pot3_Stepper_L.integerValue  = Int(sender.minValue) // Stepper min setzen
      Pot3_Stepper_L_Feld.integerValue = Int(sender.minValue)
      Pot3_Stepper_H.integerValue  = Int(sender.maxValue) // Stepper max setzen
      Pot3_Stepper_H_Feld.integerValue = Int(sender.maxValue)
      
      teensy.write_byteArray[ACHSE3_BYTE_H] = UInt8((intpos & 0xFF00) >> 8) // hb
      teensy.write_byteArray[ACHSE3_BYTE_L] = UInt8((intpos & 0x00FF) & 0xFF) // lb
      
      if (globalusbstatus > 0)
      {
         let senderfolg = teensy.send_USB()
         print("report_Slider3 senderfolg: \(senderfolg)")
      }
   }
   
   @IBAction override func report_Pot3_Stepper_L(_ sender: NSStepper) // untere Grenze
   {
      print("report_Pot3_Stepper_L IntVal: \(sender.integerValue)")
      
      let intpos = sender.integerValue 
      Pot3_Stepper_L_Feld.integerValue = intpos
      
      Pot3_Slider.minValue = sender.doubleValue 
      print("report_Pot3_Stepper_L Pot3_Slider.minValue: \(Pot3_Slider.minValue)")
      
   }
   
   @IBAction override func report_Pot3_Stepper_H(_ sender: NSStepper)// Obere Grenze
   {
      print("report_Pot3_Stepper_H IntVal: \(sender.integerValue)")
      
      let intpos = sender.integerValue 
      Pot3_Stepper_H_Feld.integerValue = intpos
      
      Pot3_Slider.maxValue = sender.doubleValue 
      print("report_Pot3_Stepper_H Pot3_Slider.maxValue: \(Pot3_Slider.maxValue)")
      
   }
   
   
   @IBAction  func report_Drehknopf_Stepper_L(_ sender: NSStepper) // untere Grenze
   {
      print("report_Drehknopf_Stepper_L IntVal: \(sender.integerValue)")
      
      let intpos = sender.integerValue 
      Drehknopf_Stepper_L_Feld.integerValue = intpos
      
      DrehknopfFeld.minwinkel = CGFloat(sender.doubleValue)
      print("report_Drehknopf_Stepper_L DrehknopfFeld.minwinkel: \(DrehknopfFeld.minwinkel)")
      DrehknopfFeld.bogen.removeAllPoints()
      DrehknopfFeld.bogen.appendArc(withCenter:  DrehknopfFeld.mittelpunkt, radius: DrehknopfFeld.knopfrect.size.height/2-2, startAngle: DrehknopfFeld.minwinkel + 90, endAngle: DrehknopfFeld.maxwinkel + 90)
      
      //   abdeckpfad.fill()
      
      DrehknopfFeld.needsDisplay = true
      
   }
   
   
   
   @IBAction  func report_Drehknopf_Stepper_H(_ sender: NSStepper) // untere Grenze
   {
      print("report_Drehknopf_Stepper_H IntVal: \(sender.integerValue)")
      
      let intpos = sender.integerValue 
      Drehknopf_Stepper_H_Feld.integerValue = intpos
      
      DrehknopfFeld.maxwinkel = CGFloat(sender.doubleValue)
      print("report_Drehknopf_Stepper_H DrehknopfFeld.minwinkel: \(DrehknopfFeld.minwinkel)")
      DrehknopfFeld.bogen.removeAllPoints()
      DrehknopfFeld.bogen.appendArc(withCenter:  DrehknopfFeld.mittelpunkt, radius: DrehknopfFeld.knopfrect.size.height/2-2, startAngle: DrehknopfFeld.minwinkel + 90, endAngle: DrehknopfFeld.maxwinkel + 90)
      
      DrehknopfFeld.needsDisplay = true
      
   }
   
    @objc override func beendenAktion(_ notification:Notification) 
    {
      let robot1_min = Pot1_Stepper_L.integerValue
      //https://learnappmaking.com/userdefaults-swift-setting-getting-data-how-to/
      
      print("beendenAktion Pot1_Stepper_L: \(Pot1_Stepper_L.integerValue) Pot2_Stepper_L: \(Pot2_Stepper_L.integerValue)")
      UserDefaults.standard.set(Pot1_Stepper_L.integerValue, forKey: "robot1min")
      UserDefaults.standard.set(Pot2_Stepper_L.integerValue, forKey: "robot2min")
      
      UserDefaults.standard.set(rotoffsetstepper.integerValue, forKey: "rotoffset")
      UserDefaults.standard.set(pot1offsetstepper.integerValue, forKey: "robot1offset")
      UserDefaults.standard.set(pot2offsetstepper.integerValue, forKey: "robot2offset")
   
      UserDefaults.standard.set(winkelfaktor1stepper.floatValue,forKey: "winkelfaktor1")
      UserDefaults.standard.set(winkelfaktor2stepper.floatValue,forKey: "winkelfaktor2")
      
      
      print("Robot beendenAktion")
      
      NSApplication.shared.terminate(self)
      
   }

    
}
