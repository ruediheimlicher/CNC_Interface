//
//  rAVR.h
//  USBInterface
//
//  Created by Sysadmin on 01.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

// https://developer.apple.com/documentation/swift/importing-swift-into-objective-c
@class rTSP_NN;

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "rProfil_DS.h"
#import "rDump_DS.h"
#import "rProfilGraph.h"
#import "rCNC.h"
#import "rUtils.h"
//#import "datum.c"
#import "rEinstellungen.h"



#define USBTASTE              1
#define NEUTASTE              2
#define OBERKANTEANFAHREN     3
#define HOMETASTE             4
#define USBATTACHED           5
#define USBREMOVED            6
#define ANDERESEITEANFAHREN   10

#define CNC_STOP              1

#define VERSION "CNC_Interface 21.0"
#define DATUM  "26.02.2021"
/*
@interface rPfeiltasteCell : NSButtonCell 
{
   int richtung;
}
- (void)setRichtung:(int)dieRichtung;
@end
*/

int globalcounter = 0;

@interface rProfildruckView : rProfilGraph
{
   NSView*        Druckfeld;
   NSTextField*   Titelfeld;
   NSString* titel;
}

- (void)setTitel:(NSString*)titel;
- (void)drawRect:(NSRect)dirtyRect;
@end


@interface rPfeiltaste : NSButton 
{
   int richtung;
   IBOutlet id Taste;
}

- (IBAction)reportPfeiltaste:(id)sender;
- (void)setRichtung:(int)dieRichtung;
- (int)Richtung;
- (int)Tastestatus;
@end

@interface rCNCview:NSView
{
   
}
@end

@interface rTabview:NSTabView
{
   int nummer;
   
}
@end



@interface rAVRview:NSViewController <NSTableViewDataSource,NSTableViewDelegate,NSTabViewDelegate>
{
   // https://dev.iachieved.it/iachievedit/using-swift-in-an-existing-objective-c-project/
   rTSP_NN* nn;
   
   NSMutableDictionary*      CNC_PList;
   
//   IBOutlet id             BoardPop;
   
   IBOutlet id                StepperTab;
   
   IBOutlet rTabview*            TaskTab;
   IBOutlet   id               ProfilFeld;
   
   IBOutlet   id               GFKFeldA;
   IBOutlet   id               GFKFeldB;

   
   IBOutlet   id               ProfilTiefeFeldA;
   IBOutlet   id               ProfilTiefeFeldB;

   IBOutlet   id               Einlauflaenge;
   IBOutlet   id               Einlauftiefe;

   IBOutlet   id               Auslauflaenge;
   IBOutlet   id               Auslauftiefe;

   IBOutlet   id               ProfilBOffsetYFeld;
   IBOutlet   id               ProfilBOffsetXFeld;
   
   IBOutlet   id               ProfilWrenchFeld;// Schränkung
   IBOutlet   id               ProfilWrenchEinheitRadio;
   IBOutlet   id               HorizontalSchieberFeld;
   IBOutlet   id               VertikalSchieberFeld;
   IBOutlet   id               HorizontalSchieber;
   IBOutlet   id               VertikalSchieber;
   
   IBOutlet   id               SpeedStepper;
   IBOutlet   id               SpeedFeld;
   
   NSTableView*            ProfilTable;
   NSMutableArray*         ProfilDaten;
   NSArray*                  ProfilDatenOA;
   NSArray*                  ProfilDatenUA;
   IBOutlet   id               ProfilNameFeldA;

   NSArray*                  ProfilDatenOB;
   NSArray*                  ProfilDatenUB;
   IBOutlet   id               ProfilNameFeldB;
   
   
   IBOutlet   id               StopKoordinate;
   IBOutlet   id               StartKoordinate;
   IBOutlet   id               Adresse;
   IBOutlet   id               Cmd;
   IBOutlet   id               Drehgeber;
   IBOutlet   id               DrehgeberFeld;
   
// IBOutlet   id               StartKnopf;
// IBOutlet   id               StopKnopf;
   
   IBOutlet   id               CNCKnopf;
   IBOutlet   id               OberseiteCheckbox;
   IBOutlet   id               UnterseiteCheckbox;
   IBOutlet   id               OberseiteTaste;
   IBOutlet   id               UnterseiteTaste;
   IBOutlet id             EinlaufCheckbox;
   IBOutlet id             AuslaufCheckbox;
   
   IBOutlet id             AbbrandCheckbox;

   IBOutlet   id           ScalePop;
   IBOutlet   NSPopUpButton*           Profil1Pop;
   IBOutlet   NSPopUpButton*          Profil2Pop;
   IBOutlet   id           CNCPositionFeld;
   IBOutlet   id           CNCStepXFeld;
   IBOutlet   id           CNCStepYFeld;
   int                     Scale;
   int                     cncposition;
   int                     cncstatus;
   
   NSString*            ProfilLibPfad;
    
   NSString*               CNCdataPfad;
   NSMutableArray*         EEPROMArray;
   NSMutableArray*         KoordinatenTabelle;
   
   NSMutableArray*         UndoKoordinatenTabelle;
   NSMutableIndexSet*      UndoSet;

   NSMutableArray*         BlockKoordinatenTabelle;
   NSMutableArray*         BlockrahmenArray;

   NSMutableDictionary*     RumpfteilDic;
   
   NSPoint                 oldMauspunkt;
   
   rProfilGraph*           ProfilGraph;
  
   int                     GraphEnd;
   IBOutlet NSTableView*   CNCTable;
   IBOutlet NSScrollView*  CNCScroller;
   
   rCNC*                   CNC;
   int                     CNC_busy;
   
   NSTimer*                CNCTimer;
   
   int                     ProfilTiefe;
   float                   ProfilZoom;
   NSPoint                 ProfilNullpunkt;
   int                     mitOberseite;
   int                     mitUnterseite;
   int                     mitEinlauf;
   int                     mitAuslauf;
   int                     flipH;
   int                     flipV;
   int                     reverse;
   
   int einlauflaenge;
   int einlauftiefe;
   int einlaufrand;
   
   int auslauflaenge;
   int auslauftiefe;
   int auslaufrand;
   
   int motorsteps;
   int micro;
   
   NSMutableArray*         CNCDatenArray;
   NSMutableArray*         SchnittdatenArray;
   
   NSMutableArray*         debugArray;
    char*      newsendbuffer;
   int               Stepperposition;
   NSMutableIndexSet* HomeAnschlagSet;
   
   NSTimer*                  IOWTimer;
   int                     AnzahlDaten;
   int                     n;
   int                     aktuellerTag;
   int                     IOW_busy;
   int                     aktuelleMark;
   NSMutableDictionary*      StepperDic;
   rUtils*                  Utils;
   
   NSMutableArray*         Eingangsdaten;
   // TWI
   
   IBOutlet id               TWI_Statustaste;
   IBOutlet id               TWI_Sendtaste;
   
   // CNC
   IBOutlet id               CNC_Preparetaste;
   IBOutlet id               CNC_Starttaste;
   IBOutlet id               CNC_Stoptaste;
   IBOutlet id               CNC_Sendtaste;
   IBOutlet id               CNC_Terminatetaste;
   IBOutlet id               CNC_Neutaste;
   IBOutlet id               CNC_Halttaste;
   IBOutlet id                DC_Taste;
   IBOutlet id                DC_Stepper;
   IBOutlet id                DC_Slider;
   IBOutlet id                DC_PWM;
   IBOutlet id                CNC_Steps;
   IBOutlet id                CNC_micro;

   IBOutlet id               CNC_Uptaste;
   IBOutlet id               CNC_Downtaste;
   IBOutlet id               CNC_Lefttaste;
   IBOutlet id               CNC_busySpinner;
   
   IBOutlet id             CNC_Linkstaste;
   
   IBOutlet id               CNC_Righttaste;
   
   IBOutlet id               CNC_Seite1Check;
   IBOutlet id               CNC_Seite2Check;
   
   IBOutlet id               CNC_BlockKonfigurierenTaste;
   IBOutlet id               CNC_BlockAnfuegenTaste;

   
   IBOutlet rPfeiltaste*             TestPfeiltaste;
   
   IBOutlet id               IndexFeld;
   IBOutlet id               IndexStepper;

   IBOutlet id               WertAXFeld;
   IBOutlet id               WertAXStepper;
   IBOutlet id               WertAYFeld;
   IBOutlet id               WertAYStepper;
 
   IBOutlet id               WertBXFeld;
   IBOutlet id               WertBXStepper;
   IBOutlet id               WertBYFeld;
   IBOutlet id               WertBYStepper;
   
   IBOutlet id               ABBindCheck;

   IBOutlet id               LagePop;
   IBOutlet id               WinkelFeld;
   IBOutlet id               WinkelStepper;

   IBOutlet id               PWMFeld;
   IBOutlet id               PWMStepper;

   IBOutlet id               AbbrandFeld;
    
   IBOutlet  id              GleichesProfilRadioKnopf;
   IBOutlet id               WertFeld;
   
   IBOutlet id               PositionFeld;
   IBOutlet id               AnzahlFeld;
   IBOutlet id               PositionXFeld;
   IBOutlet id               PositionYFeld;
   
   IBOutlet id               SaveChangeTaste;
   IBOutlet id               ShiftAllTaste;
   
   IBOutlet id               Blockoberkante;
   IBOutlet id               OberkantenStepper;
   IBOutlet id               Blockbreite;
   IBOutlet id               Blockdicke;
   
   IBOutlet id                RumpfBlockbreite;
   IBOutlet id                RumpfBlockhoehe;

   
   IBOutlet id               Einlaufrand;
   IBOutlet id               Auslaufrand;
   IBOutlet id               AnschlagLinksIndikator;
   IBOutlet id               AnschlagUntenIndikator;
   
   IBOutlet id               Basisabstand; // Abstand CNC zu Block
   IBOutlet id               Portalabstand; 
   IBOutlet id               Spannweite; // 
   
   IBOutlet id               startdelayFeld; //
   
   IBOutlet id               USBKontrolle;
   
   IBOutlet id               HomeTaste;

   IBOutlet id               SeitenVertauschenTaste;
   IBOutlet id               NeuesElementTaste;
   
   IBOutlet   id               AbmessungX;
   IBOutlet   id               AbmessungY;
   
   IBOutlet   id               red_pwmFeld;
   int pwm;
   IBOutlet id               LinkeRechteSeite;

   NSMutableDictionary*      AnschlagDic;

   
   IBOutlet id               VersionFeld;
   IBOutlet id               DatumFeld;
   IBOutlet id            SlaveVersionFeld;
   int                     startwert;
   NSWindow*               window;
   int                     mausistdown;
   int                     quelle;
   
   rEinstellungen*         CNC_Eingabe;
  
   int                     AVR_USBStatus;
   IBOutlet id               ManufactorerFeld;
   IBOutlet id               ProductFeld;
   IBOutlet id               MinimaldistanzFeld;
   float                   minimaldistanz; // minimaler abstand zwischen 2  Punkten, um in den Array aufgenommen zu werden
   
   IBOutlet id             KoteFeld;
   IBOutlet id             KoteStepper;
   
   
   
   // Rumpf
   IBOutlet id               RandFeld;
   IBOutlet id               EinlaufFeld;
   IBOutlet id               BreiteAFeld;
   IBOutlet id               HoeheAFeld;
   IBOutlet id               RadiusAFeld;
   IBOutlet id               AuslaufFeld;
   IBOutlet id               BreiteBFeld;
   IBOutlet id               HoeheBFeld;
   IBOutlet id               RadiusBFeld;
   IBOutlet id               EinstichtiefeFeld;
   //IBOutlet id               RumpfblockhoeheFeld;
   IBOutlet id               RumpfabstandFeld; // Abstand CNC zu Block
   IBOutlet id               ElementlaengeFeld; // Laenge des Rumpfabschnittes
   IBOutlet id                RumpfOffsetXFeld;
   IBOutlet id                RumpfOffsetYFeld;
   IBOutlet id                RumpfportalabstandFeld;
   
   
   IBOutlet id                NutCheckbox;
   
    
   IBOutlet NSSegmentedControl* RumpfteilTaste;
   
   int anzahlRumpfteile;
   
   NSString*               PListPfad;
   
   NSMutableArray*         RumpfdatenArray;
   int                     aktuellerRumpfteil;
 
   //int                     _kote;
   int                     KoteWert;
   
   IBOutlet id             Schalendickefeld;
   
   rProfildruckView*       Profilfeld;
   
   int                     boardindex; // teensy""2: 0  teensy3: 1
   
   
   float einfahrtx;
   float einfahrty;

 
   }
   @property (nonatomic)  int    Kote;
   @property (nonatomic) BOOL wantsLayer;

   - (rTSP_NN*)returnSwiftClassInstance;


- (instancetype)init;
   - (void)setAVR;
   - (NSMutableDictionary*)readCNC_PList;
   - (NSArray*)readProfilLib;
   - (void)setRumpfteilDic:(NSDictionary*) rumpfteildic forPart:(int) rumpfteil;

   - (IBAction)reportUSB:(id)sender;
   - (void)setUSB_Device_Status:(int)status;

   - (IBAction)reportBoardPop:(id)sender;
   - (int)BoardPopIndex;
   - (IBAction)reportHorizontalSchieber:(id)sender;
   - (IBAction)reportVertikalSchieber:(id)sender;
   - (IBAction)reportDrehgeber:(id)sender;
   - (IBAction)reportStartKnopf:(id)sender;
   - (IBAction)reportStopKnopf:(id)sender;
   - (IBAction)reportMotorsteps:(id)sender;
   - (IBAction)reportMicrosteps:(id)sender;
   - (IBAction)reportRandlinks:(id)sender;

   - (IBAction)reportRumpfteilPop:(id)sender;
   - (void)updateRumpfdatenArray;

   - (NSDictionary*)RahmenDic;
   - (void)DC_ON:(int)pwm;
   - (int)pwm;
   - (int)pwm2save;
   - (float)mindist2save;
   - (void)setStepperstrom:(int)ein;
   - (void)setBusy:(int)busy;
   - (int)speed;
   - (int)saveSpeed;
   - (int)motorsteps;
   - (int)CNC_micro;


   - (int)saveProfileinstellungen;
   - (void)setUSBDaten:(NSDictionary*)datendic;
   - (void)ManRichtung:(int)richtung  mousestatus:(int)status pfeilstep:(int)step;
   - (IBAction)reportSpeedStepper:(id)sender;

//- (IBAction)reportCNCKnopf:(id)sender;
- (IBAction)reportOberseiteTaste:(id)sender;
- (IBAction)reportUnterseiteTaste:(id)sender;
- (IBAction)reportProfil:(id)sender;
- (IBAction)reportProfil1Pop:(id)sender;
- (IBAction)reportProfil2Pop:(id)sender;

- (IBAction)reportClearProfilTabelle:(id)sender;
- (IBAction)reportScalePop:(id)sender;
- (IBAction)reportRumpfteilTaste:(id)sender;
- (IBAction)reportHaltTaste:(id)sender;
- (IBAction)reportResetTaste:(id)sender;
- (IBAction)reportIndexStepper:(id)sender;
- (IBAction)reportWertAXStepper:(id)sender;
- (IBAction)reportWertAYStepper:(id)sender;
- (IBAction)reportPWMStepper:(id)sender;
- (IBAction)reportWertBXStepper:(id)sender;
- (IBAction)reportWertBYStepper:(id)sender;

- (IBAction)reportPWMSlider:(id)sender;
- (IBAction)reportNewElement:(id)sender;
- (IBAction)reportManLeft:(id)sender;
- (IBAction)reportManRight:(id)sender;
- (IBAction)reportManUp:(id)sender;
- (IBAction)reportManDown:(id)sender;
- (void)updateIndex;
- (IBAction)reportDauerpfeilTaste:(id)sender;
- (IBAction)reportOberkanteAnfahren:(id)sender;
- (IBAction)reportHome:(id)sender;
- (void)sendDelayedArrayWithDic:(NSDictionary*) schnittdatendic;

- (IBAction)reportElementSichern:(id)sender;

- (int)mausistdown;
- (int)PfeiltasteStatus;
- (IBAction)reportQuadrat:(id)sender;
- (IBAction)reportKreis:(id)sender;
- (IBAction)reportEllipse:(id)sender;
- (IBAction)reportHolm:(id)sender;

- (IBAction)reportRumpfrohrkonfigurieren:(id)sender;
- (IBAction)reportRumpfkern:(id)sender;
- (NSArray*)KoordinatenTabelle;
- (IBAction)reportSaveStepperDic:(id)sender;
- (IBAction)reportZeileWeg:(id)sender;
- (IBAction)reportNeueZeile:(id)sender;
- (void)setDatenVonZeile:(int)dieZeile;
- (IBAction)reportShiftLeft:(id)sender;
- (IBAction)reportShiftRight:(id)sender;
- (IBAction)reportShiftUp:(id)sender;
- (IBAction)reportShiftDown:(id)sender;
- (void)shiftX:(float)x Y:(float)y Schritt:(int)schritt;
- (IBAction)reportSeiteVertauschen:(id)sender;
- (IBAction)reportLinkeRechteSeite:(id)sender;
- (IBAction)reportLinkeRechteSeiteOffset:(id)sender;
- (IBAction)reportAndereSeiteAnfahren:(id)sender;
- (IBAction)reportVertikalSpiegeln:(id)sender;

- (IBAction)reportProfilTask:(id)sender;
- (IBAction)reportProfilOberseiteTask:(id)sender;
- (IBAction)reportProfilUnterseiteTask:(id)sender;
- (IBAction)reportEdgeTask:(id)sender;
// SPI


// TWI
//- (void)writeAVR:(int)i2cAdresse mitDaten:(NSArray*)dieDaten;
- (IBAction)reportUSB_sendArray:(id)sender;
- (IBAction)reportPrepareTaste:(id)sender;
- (IBAction)reportNeuTaste:(id)sender;
- (IBAction)terminateTransfer:(id)sender;

- (IBAction)reportPrint:(id)sender;
- (IBAction)ok:(id)sender;
- (void)HomebusAnlegen;
- (void)saveLabel:(NSString*)dasLabel forRaum:(int)derRaum forSegment:(int)dasSegment;
- (void)checkHomebus;
- (int)saveStepperDic;
- (int)sendData:(NSArray*)dieDaten;
- (int)sendReport:(NSString*)derReport mitDaten:(NSArray*)dieDaten;
- (NSString*)IntToBin:(int)dieZahl;
- (int)halt;
- (NSMutableArray*)readLib;
- (void)Blockeinfuegen;
- (IBAction)reportBlockkonfigurieren:(id)sender;
- (IBAction)reportBlockanfuegen:(id)sender;

- (int)saveStepperDic:(id)sender;
- (void)setStartRumpfteildic;

- (void)showEinstellungen;
- (void)printGraph;
   

//Convert Object(Dictionary,Array) to Plist(NSData)
-(NSData *) objToPlistAsData:(id)obj;
 
//Convert Object(Dictionary,Array) to Plist(NSString)
-(NSString *) objToPlistAsString:(id)obj;
 
//Convert Plist(NSData) to Object(Array,Dictionary)
-(id) plistToObjectFromData:(NSData *)data;
 
//Convert Plist(NSString) to Object(Array,Dictionary)
-(id) plistToObjectFromString:(NSString*)str;

   @end

