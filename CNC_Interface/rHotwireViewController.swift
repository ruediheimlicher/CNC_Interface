//
//  rHotwire.swift
//  CNC_Interface
//
//  Created by Ruedi Heimlicher on 01.07.2022.
//  Copyright © 2022 Ruedi Heimlicher. All rights reserved.
//

import Cocoa

class rHotwireViewController: rViewController 
{
      
   var hintergrundfarbe:NSColor = NSColor()
   //rTSP_NN* nn;
   var nn:rTSP_NN!
   
   var CNC_PList:NSMutableDictionary!
   
   var ProfilTable: NSTableView!          
   var ProfilDaten: NSMutableArray!   
   
   /*
   var ProfilDatenOA: NSArray    
   var ProfilDatenUA: NSArray                 
    var ProfilDatenOB: NSArray                  
   var ProfilDatenUB: NSArray
*/
   
   var   Scale: Double!;
   var   cncposition: Int!
   var   cncstatus: Double!

   var GraphEnd: Int!
   
   var   CNC_busy: Int!
   var   ProfilTiefe: Int!
   var ProfilZoom: Double!
   var   mitOberseite: Int!
   var   mitUnterseite: Int!
   var   mitEinlauf: Int!
   var   mitAuslauf: Int!
   var   flipH: Int!
   var   flipV: Int!
   var   reverse: Int!
   var   einlauflaenge: Int!
   var   einlauftiefe: Int!
   var   einlaufrand: Int!
   var   auslauflaenge: Int!
   var   auslauftiefe: Int!
   var   auslaufrand: Int!
   var   motorsteps: Int!
   var   micro: Int!

   struct RumpfDaten
   {
      var breitea = 30
      var breiteb = 16
      var einstichtiefe = 16
      var elementlaenge = 560
      var hoehea = 15
      var hoeheb = 8
      var portalabstand = 690
      var radiusa = 8
      var radiusb = 4
      var rand = 10
      var rumpfabstand = 50
      var rumpfauslauf = 15
      var rumpfblockbreite = 80
      var rumpfblockhoehe = 40
      var rumpfeinlauf = 15
      var rumpfmicro = 1
      var rumpfoffsetx = 8.5
      var rumpfoffsety = 0.0
      var rumpfportalabstand = 690
      var rumpfpwm = 92
      var rumpfspeed = 7
      
   }
   
   
   @IBOutlet weak var intpos0Feld: NSStepper!
   @IBOutlet weak var StepperTab: rTabview!
    
   @IBOutlet weak var TaskTab: rTabview!
   @IBOutlet weak var  ProfilFeld: NSTextField!
    
   @IBOutlet weak var  GFKFeldA: NSTextField!
   @IBOutlet weak var  GFKFeldB: NSTextField!

    
   @IBOutlet weak var  ProfilTiefeFeldA: NSTextField!
   @IBOutlet weak var  ProfilTiefeFeldB: NSTextField!

   @IBOutlet weak var  Einlauflaenge: NSTextField!
   @IBOutlet weak var  Einlauftiefe: NSTextField!

   @IBOutlet weak var  Auslauflaenge: NSTextField!
   @IBOutlet weak var  Auslauftiefe: NSTextField!

   @IBOutlet weak var  ProfilBOffsetYFeld: NSTextField!
   @IBOutlet weak var  ProfilBOffsetXFeld: NSTextField!
    
   @IBOutlet weak var  ProfilWrenchFeld: NSTextField! // Schränkung
   @IBOutlet weak var  ProfilWrenchEinheitRadio: NSTextField!
   @IBOutlet weak var  HorizontalSchieberFeld: NSTextField!
   @IBOutlet weak var  VertikalSchieberFeld: NSTextField!
   @IBOutlet weak var  HorizontalSchieber: NSTextField!
   @IBOutlet weak var  VertikalSchieber: NSTextField!
    
   @IBOutlet weak var  SpeedStepper: NSTextField!
   @IBOutlet weak var  SpeedFeld: NSTextField!

   @IBOutlet weak var  ProfilNameFeldA: NSTextField!
   @IBOutlet weak var  ProfilNameFeldB: NSTextField!

   @IBOutlet weak var  StopKoordinate: NSTextField!
   @IBOutlet weak var  StartKoordinate: NSTextField!
   @IBOutlet weak var  Adresse: NSTextField!
   @IBOutlet weak var  Cmd: NSTextField!
   @IBOutlet weak var  CNCKnopf: NSTextField!
   @IBOutlet weak var  OberseiteCheckbox: NSButton!
   @IBOutlet weak var  UnterseiteCheckbox: NSButton!
   @IBOutlet weak var  OberseiteTaste: NSButton!
   @IBOutlet weak var  UnterseiteTaste: NSButton!
   
   @IBOutlet weak var  EinlaufCheckbox: NSButton!
   @IBOutlet weak var  AuslaufCheckbox: NSButton!
   
   @IBOutlet weak var  AbbrandCheckbox: NSButton!
   
   @IBOutlet weak var  ScalePop: NSPopUpButton!
   @IBOutlet weak var  Profil1Pop: NSPopUpButton!
   @IBOutlet weak var  Profil2Pop: NSPopUpButton!
   
   @IBOutlet  weak var  CNCTable: NSTableView!
   @IBOutlet  weak var  CNCScroller: NSScrollView!

   // CNC
   @IBOutlet weak var CNC_Preparetaste: NSButton! 
   @IBOutlet weak var CNC_Starttaste: NSButton! 
   @IBOutlet weak var CNC_Stoptaste: NSButton! 
   @IBOutlet weak var CNC_Sendtaste: NSButton! 
   @IBOutlet weak var CNC_Terminatetaste: NSButton! 
   @IBOutlet weak var CNC_Neutaste: NSButton! 
   @IBOutlet weak var CNC_Halttaste: NSButton! 
   @IBOutlet weak var DC_Taste: NSButton! 
   @IBOutlet weak var DC_Stepper: NSStepper! 
   @IBOutlet weak var DC_Slider: NSSlider! 
   @IBOutlet weak var DC_PWM: NSTextField! 
   @IBOutlet weak var CNC_Steps: NSTextField! 
   @IBOutlet weak var CNC_micro: NSTextField! 

   @IBOutlet weak var CNC_Uptaste: NSButton! 
   @IBOutlet weak var CNC_Downtaste: NSButton! 
   @IBOutlet weak var CNC_Lefttaste: NSButton! 
   @IBOutlet weak var CNC_busySpinner: NSProgressIndicator! 
    
   @IBOutlet weak var CNC_Linkstaste: NSButton! 
    
   @IBOutlet weak var CNC_Righttaste: NSButton! 
    
   @IBOutlet weak var CNC_Seite1Check: NSButton! 
   @IBOutlet weak var CNC_Seite2Check: NSButton! 
    
   @IBOutlet weak var CNC_BlockKonfigurierenTaste: NSButton! 
   @IBOutlet weak var CNC_BlockAnfuegenTaste: NSButton! 

    
   @IBOutlet weak var  Pfeiltaste: rPfeiltaste! 
    
   @IBOutlet weak var IndexFeld: NSTextField! 
   @IBOutlet weak var IndexStepper: NSStepper! 

   @IBOutlet weak var WertAXFeld: NSTextField! 
   @IBOutlet weak var WertAXStepper: NSStepper! 
   @IBOutlet weak var WertAYFeld: NSTextField! 
   @IBOutlet weak var WertAYStepper: NSStepper! 
    
   @IBOutlet weak var WertBXFeld: NSTextField! 
   @IBOutlet weak var WertBXStepper: NSStepper! 
   @IBOutlet weak var WertBYFeld: NSTextField! 
   @IBOutlet weak var WertBYStepper: NSStepper! 
    
   @IBOutlet weak var ABBindCheck: NSButton! 

   @IBOutlet weak var LagePop: NSPopUpButton! 
   @IBOutlet weak var WinkelFeld: NSTextField! 
   @IBOutlet weak var WinkelStepper: NSStepper! 

   @IBOutlet weak var PWMFeld: NSTextField! 
   @IBOutlet weak var PWMStepper: NSStepper! 

   @IBOutlet weak var AbbrandFeld: NSTextField! 

   @IBOutlet weak var GleichesProfilRadioKnopf: NSButton! 
   @IBOutlet weak var WertFeld: NSTextField! 
    
   @IBOutlet weak var PositionFeld: NSTextField! 
   @IBOutlet weak var AnzahlFeld: NSTextField! 
   @IBOutlet weak var PositionXFeld: NSTextField! 
   @IBOutlet weak var PositionYFeld: NSTextField! 
    
   @IBOutlet weak var SaveChangeTaste: NSButton! 
   @IBOutlet weak var ShiftAllTaste: NSButton! 
    
   @IBOutlet weak var Blockoberkante: NSTextField! 
   @IBOutlet weak var OberkantenStepper: NSStepper! 
   @IBOutlet weak var Blockbreite: NSTextField! 
   @IBOutlet weak var Blockdicke: NSTextField! 
    
   @IBOutlet weak var RumpfBlockbreite: NSTextField! 
   @IBOutlet weak var RumpfBlockhoehe: NSTextField! 

    
   @IBOutlet weak var Einlaufrand: NSTextField! 
   @IBOutlet weak var Auslaufrand: NSTextField! 
   @IBOutlet weak var AnschlagLinksIndikator: NSBox! 
   @IBOutlet weak var AnschlagUntenIndikator: NSBox! 
    
   @IBOutlet weak var Basisabstand: NSTextField!  // Abstand CNC zu Block
   @IBOutlet weak var Portalabstand: NSTextField!  
   @IBOutlet weak var Spannweite: NSTextField!  // 
    
   @IBOutlet weak var startdelayFeld: NSTextField!  //
    
   //@IBOutlet weak var USBKontrolle! 
    
   @IBOutlet weak var HomeTaste: NSButton! 

   @IBOutlet weak var SeitenVertauschenTaste: NSButton! 
   @IBOutlet weak var NeuesElementTaste: NSButton! 
    
   @IBOutlet weak var AbmessungX: NSTextField! 
   @IBOutlet weak var AbmessungY: NSTextField! 
    
   @IBOutlet weak var red_pwmFeld: NSTextField! 

   @IBOutlet weak var LinkeRechteSeite: NSSegmentedControl! 
    
   @IBOutlet weak var VersionFeld: NSTextField! 
   @IBOutlet weak var DatumFeld: NSTextField! 
   @IBOutlet weak var SlaveVersionFeld: NSTextField! 






   
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
      
      Auslauftiefe.integerValue = 10
      
      //readHotwire_PList()
   }//viewDidLoad
  
   
   @objc func readHotwire_PList()
   {
      var dateiname = ""
      var dateisuffix = ""
      var urlstring:String = ""

      var USBPfad = NSHomeDirectory()
      print("readCNC_PList: \(USBPfad)")
      do
      {
         guard let fileURL = openFile() else { return  }
         
         urlstring = fileURL.absoluteString
         dateiname = urlstring.components(separatedBy: "/").last ?? "-"
         print("report_readSVG fileURL: \(fileURL)")
         
         dateiname = dateiname.components(separatedBy: ".").first ?? "-"
         
         //USBPfad.stringValue = dateiname

      }
      catch 
      {
         print("readCNC_PList  error: \(error)")
         
         /* error handling here */
         return
      }

   }
   
    
   @objc func usbstatusAktion(_ notification:Notification) 
   {
      let info = notification.userInfo
      guard let status = info?["usbstatus"] as? Int else 
      { 
         print("Basis usbstatusAktion: kein status\n")
         return  
         
      }// 
      //print("Hotwire usbstatusAktion:\t \(status)")
      usbstatus = Int32(status)
   }


} // end Hotwire
