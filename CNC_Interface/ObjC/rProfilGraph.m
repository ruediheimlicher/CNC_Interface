//
//  rProfilGraph.m
//  IOW_Stepper
//
//  Created by Sysadmin on 26.April.11.
//  Copyright 2011 Ruedi Heimlicher. All rights reserved.
//

#import "rProfilGraph.h"
float
distance(NSPoint a, NSPoint b)
{
float
dX = a.x - b.x,
dY = a.y - b.y;
return sqrt(dX*dX + dY*dY);
}


@implementation rProfilGraph

- (id)initWithFrame:(NSRect)frame 

{
    self = [super initWithFrame:frame];
    if (self) 
	 {
       DatenArray=[[NSArray alloc ]init];
       RahmenArray=[[NSArray alloc ]init];
       oldMauspunkt = NSMakePoint(0,0);
       scale = 1;
       mausistdown=0;
       Klickpunkt=-1;
       startklickpunkt=-1;
       
       KlicksetA = [NSMutableIndexSet indexSet];
       
       Klickseite=-1;
       
       stepperposition = -1;
       GraphOffset = 0;
       anzahlmaschen = 28;
       graphstatus=0;
       screen = 0;
    }
   
    return self;
}
int (^add)(int,int) = ^(int number1, int number2){
   return number1+number2;
};


- (void)setScale:(float)derScalefaktor
{
	scale = derScalefaktor;
   //NSLog(@"Profilgraph scale: %.2f",scale);

}

- (void)setGraphOffset:(int)offset
{
   GraphOffset = offset;
   
}
- (int)GraphOffset
{
   return GraphOffset;
}

- (void)setAnzahlMaschen: (int)anzahl
{
   anzahlmaschen = anzahl;
}

- (BOOL)canBecomeKeyView
{
   //NSLog(@"canBecomeKeyView");
    return YES;
}

- (BOOL)acceptsFirstResponder 
{
	//NSLog(@"acceptsFirstResponder");
     return YES;
}


- (void)setDatenArray:(NSArray*)derDatenArray
{
	//NSLog(@"ProfilGraph setDatenArray: %@",[derDatenArray description]);
	DatenArray=derDatenArray;
}

- (void)setRahmenArray:(NSArray*)derRahmenArray
{
	//NSLog(@"ProfilGraph setRahmenArray: %@",[derRahmenArray description]);
	RahmenArray=derRahmenArray;
	//[RahmenArray release];
   //NSLog(@"ProfilGraph setRahmenArray: %@",[RahmenArray description]);

}

- (void)setAnschlagDic:(NSDictionary*)derAnschlagDic
{
	NSLog(@"ProfilGraph setAnschlagDic: %@",[derAnschlagDic description]);

}

- (NSArray*)DatenArray
{
	return DatenArray;
}

- (void)setKlickpunkt:(int)derPunkt
{
   Klickpunkt=derPunkt;
   startklickpunkt=derPunkt;
}

- (void)setStepperposition:(int)pos
{
   //NSLog(@"setStepperposition pos: %d",pos);
   stepperposition = pos;
   if ([DatenArray count] && pos < [DatenArray count])
   {
      //NSLog(@"setStepperposition ok");
      NSPoint PunktA=NSMakePoint([[[DatenArray objectAtIndex:pos]objectForKey:@"ax"]floatValue]*scale,[[[DatenArray objectAtIndex:pos]objectForKey:@"ay"]floatValue]*scale);
      //NSLog(@"i: %d Punkt.x: %.4f Punkt.y: %.4f",i,Punkt.x,Punkt.y);
      NSRect tempMarkARect=NSMakeRect(PunktA.x-4.1, PunktA.y-4.1, 8.2, 8.2);
      [self setNeedsDisplayInRect:tempMarkARect];
      
      /*
      NSPoint PunktB=NSMakePoint([[[DatenArray objectAtIndex:pos]objectForKey:@"bx"]floatValue]*scale,([[[DatenArray objectAtIndex:pos]objectForKey:@"by"]floatValue]+GraphOffset)*scale);
      //NSLog(@"i: %d Punkt.x: %.4f Punkt.y: %.4f",i,Punkt.x,Punkt.y);
      NSRect tempMarkBRect=NSMakeRect(PunktB.x-4.1, PunktB.y-4.1, 8.1, 8.1);
      [self setNeedsDisplayInRect:tempMarkBRect];
       */
   }
}

- (int)clickedPunktvonMaus:(NSPoint)derPunkt
{
	float delta=2;
	NSRect KlickFeld=NSMakeRect(derPunkt.x-delta/2, derPunkt.y-delta/2, delta, delta);
	int i;
	for(i=0;i<[DatenArray count];i++)
	{
		NSPoint tempPunktA=NSMakePoint([[[DatenArray objectAtIndex:i]objectForKey:@"ax"]floatValue], [[[DatenArray objectAtIndex:i]objectForKey:@"ay"]floatValue]);
		NSPoint tempPunktB=NSMakePoint([[[DatenArray objectAtIndex:i]objectForKey:@"bx"]floatValue], [[[DatenArray objectAtIndex:i]objectForKey:@"by"]floatValue]+GraphOffset);
		//NSLog(@"tempPunkt x: %2.2f y: %2.2f",tempPunkt.x,tempPunkt.y);
		//NSLog(@"derPunkt x: %2.2f y: %2.2f",derPunkt.x,derPunkt.y);
		//KlickFeld=NSMakeRect(derPunkt.x-3, derPunkt.y-3, 6, 6);
      
      if ([self mouse:tempPunktA inRect:KlickFeld])//||[self mouse:tempPunktB inRect:KlickFeld])
      {
         //NSLog(@"Seite 1 punkt: %d",i);
         return i;
      }
      if ([self mouse:tempPunktB inRect:KlickFeld])
      {
         //NSLog(@"Seite 2 punkt: %d",i);
         return i+0xF000;
      }

	}
	return -1;
}


- (void)setKlickrange:(NSRange)derRange
{
   klickrange = derRange;   

}

- (int)clickedAbschnittvonMaus:(NSPoint)derPunkt
{
   NSLog(@"clickedAbschnittvonMaus: x: %2.2f y: %2.2f",derPunkt.x,derPunkt.y);
   int index=-1;
   float delta=4;
   //NSRect KlickFeld=NSMakeRect(derPunkt.x-3, derPunkt.y-3, 6, 6);
   int i;
   // Abschnitte absuchen, Abstand zu derPunkt berechnen
   
	for(i=0;i<[DatenArray count]-1;i++)
	{
      if (i==135)
      {
         int a=0;
        
      }
       //NSDictionary* tempdic1 =[DatenArray objectAtIndex:i];
      if (i<[DatenArray count]-2)
      {
       //NSDictionary* tempdic2 =[DatenArray objectAtIndex:i+1];
      }
      //NSLog(@"clickedAbschnittvonMaus: i:%d",i);
		NSPoint tempPunktA=NSMakePoint([[[DatenArray objectAtIndex:i]objectForKey:@"ax"]floatValue], [[[DatenArray objectAtIndex:i]objectForKey:@"ay"]floatValue]);
		NSPoint tempPunktB=NSMakePoint([[[DatenArray objectAtIndex:i+1]objectForKey:@"ax"]floatValue], [[[DatenArray objectAtIndex:i+1]objectForKey:@"ay"]floatValue]);
      //NSLog(@"tempPunktA: x: %2.2f y: %2.2f",tempPunktA.x,tempPunktA.y);
      //NSLog(@"tempPunktB: x: %2.2f y: %2.2f",tempPunktB.x,tempPunktB.y);
//		float tanphi=(tempPunktA.y-tempPunktB.y)/(tempPunktA.x-tempPunktB.x);
      float dist= sqrt(pow((tempPunktA.y-tempPunktB.y),2)+pow((tempPunktA.x-tempPunktB.x),2));
      
      if (dist==0)
      {
         NSLog(@"dist ist null");
         continue;
      }
      
      //delta = dist*0.2;
      
      float sinphi=(tempPunktB.y-tempPunktA.y)/dist;
      float cosphi=(tempPunktB.x-tempPunktA.x)/dist;
      float deltax=delta*sinphi;
      float deltay=delta*cosphi;
      //NSLog(@"dist: %2.2f sinphi: %2.2f cosphi: %2.2f deltax: %2.2f deltay: %2.2f", dist, sinphi, cosphi, deltax, deltay);
      NSBezierPath* clickPfad=[NSBezierPath bezierPath];
      
      
      [clickPfad moveToPoint:NSMakePoint(tempPunktA.x+deltax,tempPunktA.y-deltay)];
      [clickPfad lineToPoint:NSMakePoint(tempPunktB.x+deltax,tempPunktB.y-deltay)];
      [clickPfad lineToPoint:NSMakePoint(tempPunktB.x-deltax,tempPunktB.y+deltay)];
      [clickPfad lineToPoint:NSMakePoint(tempPunktA.x-deltax,tempPunktA.y+deltay)];
      
      //[clickPfad stroke];
      
      BOOL hit=[clickPfad containsPoint:derPunkt];
      if (hit)
      {
         //NSLog(@"tempPunktA: x: %2.2f y: %2.2f",tempPunktA.x,tempPunktA.y);
         NSLog(@"clickPfad: %@",clickPfad );
         index=i;
         NSLog(@"clickedAbschnittvonMaus Abschnitt: %d ",i);
      }
      
      //NSLog(@"tempPunkt x: %2.2f y: %2.2f",tempPunkt.x,tempPunkt.y);
		//NSLog(@"derPunkt x: %2.2f y: %2.2f",derPunkt.x,derPunkt.y);
		//KlickFeld=NSMakeRect(derPunkt.x-3, derPunkt.y-3, 6, 6);
      

   } // for i
   
   return index;
}

- (void)mouseDown:(NSEvent*)derEvent
{
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];

	//NSLog(@"mouseDown: %@",[derEvent description]);
   //NSLog(@"mouseDown: modifierFlags: %d NSShiftKeyMask: %d",[derEvent modifierFlags],NSShiftKeyMask);
   unsigned int shift =[derEvent modifierFlags] & NSEventModifierFlagShift;
   if (shift)
   {
      NSLog(@"shift");
   }
   else
   {
      //NSLog(@"kein shift");
   }
   
	NSPoint location = [derEvent locationInWindow];
	NSPoint local_point = [self convertPoint:location fromView:nil];
   mausistdown=1;
   NSMutableDictionary* MausDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [MausDic setObject:[NSNumber numberWithInt:1] forKey:@"mausistdown"];
   [MausDic setObject:[NSNumber numberWithInt:GraphOffset] forKey:@"graphoffset"];
   //NSLog(@"mouseDown: notific mausdaten");
   [nc postNotificationName:@"mausdaten" object:self userInfo:MausDic];

	float x=local_point.x;
	local_point.x /= scale;
	float y=local_point.y;
	local_point.y /= scale;
	if ((oldMauspunkt.x==local_point.x)&&(oldMauspunkt.x==local_point.y))
	{
		//NSLog(@"oldmousepunkt = localpoint");
	}
	else 
	{
      //NSLog(@"Verschiebung: oldmousepunkt ist neuer  localpoint");
		oldMauspunkt = local_point;
      
	}
	
	//NSLog(@"mousdown x: %2.2f y: %2.2f",x,y);
	//NSLog(@"mousdown scale x: %2.2f y: %2.2f",local_point.x,local_point.y);
	
   int linehit=0;
   if ([DatenArray count]>3)
   {
      int clickAbschnitt=[self clickedAbschnittvonMaus:local_point];
 //     NSLog(@"clickAbschnitt: %d",clickAbschnitt);
      if (clickAbschnitt>=0)
      {
//         NSLog(@"Profilgraph clickAbschnitt :%d",clickAbschnitt);
         NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [NotificationDic setObject:NSStringFromPoint(local_point) forKey:@"mauspunkt"];
         [NotificationDic setObject:[NSNumber  numberWithInt:clickAbschnitt]forKey:@"klickabschnitt"];
         [NotificationDic setObject:[NSNumber numberWithInt:GraphOffset] forKey:@"graphoffset"];

         [nc postNotificationName:@"mausklick" object:self userInfo:NotificationDic];
         //return;
      }
      else
      {
         NSLog(@"kein Klick");
      }
      
   }
//	NSLog(@"B");
   //NSLog(@" ");
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];

   Klickpunkt=[self clickedPunktvonMaus:local_point];
	
   if (Klickpunkt >= 0x0FFF) 
   {
      Klickseite=2;
      
   }
   else {
      Klickseite = 1;
   }
   
   // Angeklickte Seite angeben
   [NotificationDic setObject:[NSNumber  numberWithInt:Klickseite]forKey:@"klickseite"];

//   NSLog(@"mousedown startklickpunkt: %d clickedPunkt: %d",startklickpunkt,Klickpunkt);
	if (Klickpunkt> -1) // Punkt angeklickt
	{
      
      if (shift) //&& (startklickpunkt >=0)&& (!(startklickpunkt == klickpunkt))) // schon vorher ein startklickpunkt markiert
      {
         //NSLog(@"shift");
         /*
         if (klickrange.length) // neu anfangen
         {
            NSLog(@"shift und range: %lu",klickrange.length);
            klickrange=NSMakeRange(0,0);
            startklickpunkt=-1;
         }
         */
         if ((startklickpunkt >=0)&& (!(startklickpunkt == Klickpunkt)))
         {
            //NSLog(@"mousedown range sichern startklickpunkt: %d clickedPunkt: %d length: %lu",startklickpunkt,klickpunkt,klickrange.length);
            if (klickrange.length)
            {
               //klickrange=NSMakeRange(0,0);
               //startklickpunkt=klickpunkt;
            }
            
            if (Klickpunkt > startklickpunkt)
            {
               klickrange = NSMakeRange(startklickpunkt, (Klickpunkt - startklickpunkt));
               
               [NotificationDic setObject:[NSNumber  numberWithInt:startklickpunkt]forKey:@"startklickpunkt"];
            }
            else
            {
               klickrange = NSMakeRange(Klickpunkt, (startklickpunkt - Klickpunkt));
               [NotificationDic setObject:[NSNumber  numberWithInt:Klickpunkt]forKey:@"startklickpunkt"];
            }
            
            [NotificationDic setObject:NSStringFromRange(klickrange) forKey:@"klickrange"];
            [KlicksetA addIndexesInRange:klickrange];
            
            //NSLog(@"klickset  %@",[klickset description]);
            [NotificationDic setObject:KlicksetA forKey:@"klickindexset"];
            klickrange=NSMakeRange(0,0);
            startklickpunkt=-1;
         }
         else
         {
            [KlicksetA removeAllIndexes];
            startklickpunkt=Klickpunkt;
            klickrange=NSMakeRange(0,0);
         
         }
      
      }
      else // Neuanfang, Vorbereitung fuer Aktion mit shift
      {
 //        NSLog(@"kein shift");
         [KlicksetA removeAllIndexes];
         startklickpunkt=Klickpunkt; // Punkt merken
         [NotificationDic setObject:NSStringFromRange(NSMakeRange(0,0)) forKey:@"klickrange"];
         [NotificationDic setObject:[NSNumber numberWithInt:GraphOffset] forKey:@"graphoffset"];

         klickrange=NSMakeRange(0,0);
         
         
      }
      
      // Koord Mauspunkt
      if (Klickseite == 2)
      {
         local_point.y -=GraphOffset;
      }
		[NotificationDic setObject:NSStringFromPoint(local_point) forKey:@"mauspunkt"];
      
      // Nummer des angeklickten Punktes
		[NotificationDic setObject:[NSNumber  numberWithInt:Klickpunkt]forKey:@"klickpunkt"];
      
		//NSLog(@"mousedown clickedPunkt: %d",klickpunkt);
      //NSLog(@"mousedown NotificationDic: %@",[NotificationDic description]);
		//[self setNeedsDisplay:YES];
//		NSLog(@"mouseDown: notific mausklick Punkt angeklickt");
      [nc postNotificationName:@"mausklick" object:self userInfo:NotificationDic];
	}
	else // Range reseten
	{
		//klickpunkt=-1;
      //NSLog(@"Profilgraph clickedPunkt -1");
		NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		[NotificationDic setObject:NSStringFromPoint(local_point) forKey:@"mauspunkt"];
      [MausDic setObject:[NSNumber numberWithInt:GraphOffset] forKey:@"graphoffset"];

		klickrange=NSMakeRange(0,0);
      startklickpunkt=-1;
		nc=[NSNotificationCenter defaultCenter];
//      NSLog(@"mouseDown: notific mauspunkt reset");
		[nc postNotificationName:@"mauspunkt" object:self userInfo:NotificationDic];
	}
//   NSLog(@"mouseDown  end");
}

- (void)mouseUp:(NSEvent*)derEvent
{
   //NSLog(@"mouseUp:");
   NSMutableDictionary* MausDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [MausDic setObject:[NSNumber numberWithInt:0] forKey:@"mausistdown"];
   [MausDic setObject:[NSNumber numberWithInt:GraphOffset] forKey:@"graphoffset"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"mausdaten" object:self userInfo:MausDic];

   mausistdown=0;
}

- (int)mausistdown
{
   return mausistdown;
}
- (void)keyDown:(NSEvent*)derEvent
{
	//NSLog(@"keyDown: %@",[derEvent description]);
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber  numberWithInt:[derEvent keyCode]]forKey:@"pfeiltaste"];
	[NotificationDic setObject:[NSNumber  numberWithInt:Klickpunkt]forKey:@"klickpunkt"];
	[NotificationDic setObject:[NSNumber  numberWithInt:Klickseite]forKey:@"klickseite"];
   [NotificationDic setObject:[NSNumber numberWithInt:GraphOffset] forKey:@"graphoffset"];

	
   NSLog(@"keyDown: %d",[derEvent keyCode]);

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

- (void)setgraphstatus:(int)status
{
   graphstatus = status;
}


- (void)GitterZeichnen
{
   
   
   float Gittermass = scale*10;
   
   float breite = [self frame].size.width;
   if ([[NSGraphicsContext currentContext]isDrawingToScreen])
   {
      //NSLog(@"ProfilGraph drawRect screen");
      screen=1;
      anzahlmaschen = [self frame].size.width/Gittermass;
   }
   else
   {
      NSLog(@"ProfilGraph GitterZeichnen print");
      anzahlmaschen = 28;
      breite = anzahlmaschen * Gittermass;
      screen=0;
      
   }
   
	NSBezierPath* HorizontaleLinie=[NSBezierPath bezierPath];
	int i=0;
   
   
   
   // waagrechte Linien
	for (i=0;i<[self frame].size.height/Gittermass;i++)

	{
      NSPoint A=NSMakePoint(0, 1+Gittermass*i);
      NSPoint B=NSMakePoint(breite,1+Gittermass*i);
      
      [HorizontaleLinie moveToPoint:A];
      [HorizontaleLinie lineToPoint:B];
	}
	[HorizontaleLinie setLineWidth:0.3];
	[[NSColor darkGrayColor]set];
	[HorizontaleLinie stroke];
   
   // senkrechte Linien
	NSBezierPath* VertikaleLinie=[NSBezierPath bezierPath];
	//for (i=0;i<[self frame].size.width/Gittermass;i++)
   for (i=0;i < anzahlmaschen+1;i++)
	{
      NSPoint A=NSMakePoint(1.1+Gittermass*i,0);
      NSPoint B=NSMakePoint(1.1+Gittermass*i,[self frame].size.height);
      
      [VertikaleLinie moveToPoint:A];
      [VertikaleLinie lineToPoint:B];
	}
	[VertikaleLinie setLineWidth:0.3];
	[[NSColor darkGrayColor]set];
	[VertikaleLinie stroke];
	
	
}

- (void)GitterZeichnenMitMaschen:(int)anzahl
{	
	NSBezierPath* HorizontaleLinie=[NSBezierPath bezierPath];
	int i=0;
   float Gittermass=scale*10;
   
   
	for (i=0;i<anzahl;i++)
	{
      NSPoint A=NSMakePoint(0, 1+Gittermass*i);
      NSPoint B=NSMakePoint([self frame].size.width,1+Gittermass*i);
      
      [HorizontaleLinie moveToPoint:A];
      [HorizontaleLinie lineToPoint:B];
	}
	[HorizontaleLinie setLineWidth:0.3];
	[[NSColor darkGrayColor]set];
	[HorizontaleLinie stroke];
   
	NSBezierPath* VertikaleLinie=[NSBezierPath bezierPath];
	for (i=0;i<[self frame].size.width/Gittermass;i++)
	{
      NSPoint A=NSMakePoint(1.1+Gittermass*i,0);
      NSPoint B=NSMakePoint(1.1+Gittermass*i,[self frame].size.height);
      
      [VertikaleLinie moveToPoint:A];
      [VertikaleLinie lineToPoint:B];
	}
	[VertikaleLinie setLineWidth:0.3];
	[[NSColor darkGrayColor]set];
	[VertikaleLinie stroke];
	
	
}



- (void)mouseDragged:(NSEvent *)derEvent
{
	//NSLog(@"mouseDragged: %@",[derEvent description]);
	NSPoint location = [derEvent locationInWindow];
	NSPoint local_point = [self convertPoint:location fromView:nil];
	float x=local_point.x;
	local_point.x /= scale;
	float y=local_point.y;
	local_point.y /= scale;
   
   
   if (Klickseite == 2)
   {
      local_point.y -=GraphOffset;
   }
   
   //NSLog(@"mouseDragged Klickseite: %d",Klickseite);
	if (Klickpunkt >=0 && [DatenArray count]> Klickpunkt)
	{
		NSPoint aktivPunkt=NSMakePoint([[[DatenArray objectAtIndex:Klickpunkt]objectForKey:@"ax"]floatValue]*scale, [[[DatenArray objectAtIndex:Klickpunkt]objectForKey:@"ay"]floatValue]*scale);
		NSRect aktivFeld=NSMakeRect(aktivPunkt.x-3, aktivPunkt.y-3, 6, 6);
		
		if ([self mouse:aktivPunkt inRect:aktivFeld])
		{
			NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[NotificationDic setObject:NSStringFromPoint(local_point) forKey:@"mauspunkt"];
			[NotificationDic setObject:[NSNumber numberWithInt:Klickpunkt] forKey:@"klickpunkt"];
			[NotificationDic setObject:[NSNumber numberWithInt:Klickseite] forKey:@"klickseite"];
         [NotificationDic setObject:[NSNumber numberWithInt:GraphOffset] forKey:@"graphoffset"];

			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"mausdrag" object:self userInfo:NotificationDic];
			
		}
		
	}
	
	else if (distance(oldMauspunkt, local_point)>4)
	{
		oldMauspunkt = local_point;
		//NSLog(@"mouseDragged x: %2.2f y: %2.2f",x,y);
		NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		[NotificationDic setObject:NSStringFromPoint(local_point) forKey:@"mauspunkt"];
      [NotificationDic setObject:[NSNumber numberWithInt:GraphOffset] forKey:@"graphoffset"];
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		
		[nc postNotificationName:@"mauspunkt" object:self userInfo:NotificationDic];
	}
	
}

- (void)drawRect:(NSRect)dirtyRect 
{
   NSColor* bgcolor = [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:1.0f];

    [bgcolor setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];

   if (scale == 0)
   {
      scale = 4;
   }
   int abbbranddelay=0;
	//NSLog(@"ProfilGraph drawRect start");
   
  
   if ([[NSGraphicsContext currentContext]isDrawingToScreen])
   {
      //NSLog(@"ProfilGraph drawRect screen");
      screen=1;
   }
   else
   {
      NSLog(@"ProfilGraph drawRect print ");
      screen=0;
   }
   
   
	int i=0;
   
    if (screen)
    {
       [self GitterZeichnen];
       //anzahlmaschen = [self frame].size.width/Gittermass;
    }
    else
    {
       anzahlmaschen = 28; // war 28
    }
   {
      // [self GitterZeichnen];
   }
	if ([DatenArray count])
	{
		int anz=[DatenArray count];
		StartPunktA=NSMakePoint([[[DatenArray objectAtIndex:0]objectForKey:@"ax"]floatValue]*scale,[[[DatenArray objectAtIndex:0]objectForKey:@"ay"]floatValue]*scale);
		//NSLog(@"drawRect startpunkt x: %.2f  y: %.2f",[[[DatenArray objectAtIndex:0]objectForKey:@"ax"]floatValue],[[[DatenArray objectAtIndex:0]objectForKey:@"ay"]floatValue]);
      int endpunktax = [[[DatenArray objectAtIndex:anz-1]objectForKey:@"ax"]floatValue];
      
      EndPunktA=NSMakePoint([[[DatenArray objectAtIndex:anz-1]objectForKey:@"ax"]floatValue],[[[DatenArray objectAtIndex:anz-1]objectForKey:@"ay"]floatValue]);
		
      
		StartPunktB=NSMakePoint([[[DatenArray objectAtIndex:0]objectForKey:@"bx"]floatValue]*scale,([[[DatenArray objectAtIndex:0]objectForKey:@"by"]floatValue]+GraphOffset)*scale);
		//NSLog(@"drawRect startpunkt x: %.2f  y: %.2f",[[[DatenArray objectAtIndex:0]objectForKey:@"ax"]floatValue],[[[DatenArray objectAtIndex:0]objectForKey:@"ay"]floatValue]);
      int startpunktbx = [[[DatenArray objectAtIndex:0]objectForKey:@"bx"]floatValue];
		EndPunktB=NSMakePoint([[[DatenArray objectAtIndex:anz-1]objectForKey:@"bx"]floatValue]*scale,([[[DatenArray objectAtIndex:anz-1]objectForKey:@"by"]floatValue]+GraphOffset)*scale);
      int endpunktbx = [[[DatenArray objectAtIndex:anz-1]objectForKey:@"bx"]floatValue];

      //NSLog(@"endpunktax: %d endpunktbx: %d",endpunktax,endpunktbx);
      if (screen)
      {
         
         NSPoint AA=NSMakePoint(0, [[[DatenArray objectAtIndex:0]objectForKey:@"ay"]floatValue]*scale);
        // NSPoint AB=NSMakePoint([self frame].size.width-2, [[[DatenArray objectAtIndex:0]objectForKey:@"ay"]floatValue]*scale);
         NSPoint AB=NSMakePoint([self frame].size.width -AA.x - 4, [[[DatenArray objectAtIndex:0]objectForKey:@"ay"]floatValue]*scale);

         NSBezierPath* GrundLinieA=[NSBezierPath bezierPath];
         [GrundLinieA moveToPoint:AA];
         [GrundLinieA lineToPoint:AB];
         [GrundLinieA setLineWidth:0.3];
         [[NSColor blueColor]set];
         
         
         
         NSPoint BA=NSMakePoint(0, ([[[DatenArray objectAtIndex:0]objectForKey:@"by"]floatValue]+GraphOffset)*scale);
         NSPoint BB=NSMakePoint([self frame].size.width-BA.x - 4, ([[[DatenArray objectAtIndex:0]objectForKey:@"by"]floatValue]+GraphOffset)*scale);
         NSBezierPath* GrundLinieB=[NSBezierPath bezierPath];
         [GrundLinieB moveToPoint:BA];
         [GrundLinieB lineToPoint:BB];
         [GrundLinieB setLineWidth:0.3];
         [[NSColor blueColor]set];
         
        [GrundLinieA stroke];
         [GrundLinieB stroke];
          
      }
      
      else
      {
         NSLog(@"screen=0");
      }
      
      NSRect StartMarkBRect=NSMakeRect(StartPunktB.x-1.5, StartPunktB.y-1, 3, 3);
      //NSLog(@"StartMarkBRect: x: %d y: %d ",StartMarkBRect.origin.x, StartMarkBRect.origin.y);
		NSBezierPath* StartMarkB=[NSBezierPath bezierPathWithOvalInRect:StartMarkBRect];
		[[NSColor grayColor]set];
		[StartMarkB stroke];
		NSBezierPath* LinieB=[NSBezierPath bezierPath];
      NSBezierPath* KlickLinieB=[NSBezierPath bezierPath];
		[LinieB moveToPoint:StartPunktB];
      
		NSRect StartMarkARect=NSMakeRect(StartPunktA.x-1.5, StartPunktA.y-1, 3, 3);
      //NSLog(@"StartMarkARect: x: %d y: %d ",StartMarkARect.origin.x, StartMarkARect.origin.y);
		NSBezierPath* StartMarkA=[NSBezierPath bezierPathWithOvalInRect:StartMarkARect];
		[[NSColor blueColor]set];
		[StartMarkA stroke];
		NSBezierPath* LinieA=[NSBezierPath bezierPath];
      NSBezierPath* KlickLinieA=[NSBezierPath bezierPath];
		[LinieA moveToPoint:StartPunktA];
      
      
		
      // Abbrand
      // Seite 1
      NSBezierPath* AbbrandLinieA=[NSBezierPath bezierPath];
      //NSLog(@"Start Abbrand");
      int startabbrandindexa=0;
      for (i=0;i<anz;i++)
      {
         
         if ([[DatenArray objectAtIndex:i]objectForKey:@"abrax"] && [[DatenArray objectAtIndex:i]objectForKey:@"abrax"] > 0)
         {
            //NSLog(@"Start Abbrand bei %d",i);
            startabbrandindexa=i;
            break;
         }
      }
      //NSLog(@"startabbrandindex: %d",startabbrandindex);
		NSPoint AbbrandStartPunktA=NSMakePoint([[[DatenArray objectAtIndex:startabbrandindexa]objectForKey:@"abrax"]floatValue]*scale,[[[DatenArray objectAtIndex:startabbrandindexa]objectForKey:@"abray"]floatValue]*scale);
      AbbrandStartPunktA.y +=abbbranddelay;
		
      NSPoint AbbrandEndPunktA=NSMakePoint(([[[DatenArray objectAtIndex:anz-1]objectForKey:@"abrax"]floatValue]),([[[DatenArray objectAtIndex:anz-1]objectForKey:@"abray"]floatValue]+GraphOffset));
		
      //NSLog(@"startabbrandindex: %d AbbrandStartPunktA.x %d AbbrandEndPunktA.y %d ",startabbrandindexa ,AbbrandStartPunktA.x,AbbrandEndPunktA.y);
      [AbbrandLinieA moveToPoint:AbbrandStartPunktA];
      //
      // Seite 2
      NSBezierPath* AbbrandLinieB=[NSBezierPath bezierPath];
      int startabbrandindexb=0;
      for (i=0;i<anz;i++)
      {
         if ([[DatenArray objectAtIndex:i]objectForKey:@"abrbx"] && [[DatenArray objectAtIndex:i]objectForKey:@"abrbx"]>0)
         {
            //NSLog(@"Start Abbrand bei %d",i);
            startabbrandindexb=i;
            break;
         }
      }
      //NSLog(@"startabbrandindexa: %d startabbrandindexb: %d",startabbrandindexa,startabbrandindexb);
      
		NSPoint AbbrandStartPunktB=NSMakePoint(([[[DatenArray objectAtIndex:startabbrandindexb]objectForKey:@"abrbx"]floatValue])*scale,([[[DatenArray objectAtIndex:startabbrandindexb]objectForKey:@"abrby"]floatValue]+GraphOffset)*scale);
      AbbrandStartPunktB.y +=abbbranddelay;
		NSPoint AbbrandEndPunktB=NSMakePoint([[[DatenArray objectAtIndex:anz-1]objectForKey:@"abrbx"]floatValue],[[[DatenArray objectAtIndex:anz-1]objectForKey:@"abrby"]floatValue]);
	
      //NSLog(@"startabbrandindexb: %d AbbrandStartPunktB.x %d AbbrandEndPunktB.y %d ",startabbrandindexb ,AbbrandStartPunktA.x,AbbrandEndPunktA.y);

      [AbbrandLinieB moveToPoint:AbbrandStartPunktB];
      
      
      //
      
   //   NSLog(@"*** klickpunkt: %d",Klickpunkt);
		for (i=0;i<anz;i++)
		{
			NSPoint PunktA=NSMakePoint([[[DatenArray objectAtIndex:i]objectForKey:@"ax"]floatValue]*scale,[[[DatenArray objectAtIndex:i]objectForKey:@"ay"]floatValue]*scale);
			//NSLog(@"i: %d PunktA.x: %.4f PunktA.y: %.4f",i,PunktA.x,PunktA.y);
			[LinieA lineToPoint:PunktA];
			NSBezierPath* tempMarkA;//=[NSBezierPath bezierPathWithOvalInRect:tempMarkRect];
         
         NSPoint PunktB=NSMakePoint([[[DatenArray objectAtIndex:i]objectForKey:@"bx"]floatValue]*scale,([[[DatenArray objectAtIndex:i]objectForKey:@"by"]floatValue]+GraphOffset)*scale);
			//NSLog(@"i: %d PunktB.x: %.4f PunktB.y: %.4f",i,PunktB.x,PunktB.y);
			[LinieB lineToPoint:PunktB];
			NSBezierPath* tempMarkB;//=[NSBezierPath bezierPathWithOvalInRect:tempMarkRect];
         
			if (i==Klickpunkt && screen)
			{
             NSRect tempMarkBRect=NSMakeRect(PunktB.x-1.5, PunktB.y-1.5, 3.1, 3.1);
				tempMarkB=[NSBezierPath bezierPathWithOvalInRect:tempMarkBRect];
				[[NSColor redColor]set];
				[tempMarkB stroke];
           
			//	NSLog(@"i=klickpunkt i: %d",i);
				NSRect tempMarkARect=NSMakeRect(PunktA.x-4.1, PunktA.y-4.1, 8.1, 8.1);
				tempMarkA=[NSBezierPath bezierPathWithOvalInRect:tempMarkARect];
				[[NSColor grayColor]set];
				[tempMarkA stroke];
            
            
            
         }
			else 
         {            
            NSRect tempMarkBRect=NSMakeRect(PunktB.x-1.5, PunktB.y-1.5, 3.1, 3.1);
            tempMarkB=[NSBezierPath bezierPathWithOvalInRect:tempMarkBRect];
            [[NSColor grayColor]set];
            [tempMarkB stroke];
          //  NSLog(@"not klickpunkt i: %d",i);
            NSRect tempMarkARect=NSMakeRect(PunktA.x-2.5, PunktA.y-2.5, 5.1, 5.1);
            tempMarkA=[NSBezierPath bezierPathWithOvalInRect:tempMarkARect];
            
            if (screen)
            {
               if (i>stepperposition ) // nur auf Screen farbig
               {
                  [[NSColor blueColor]set];
                  [tempMarkA stroke];
               }
               
               else
               {
                  
                  [[NSColor redColor]set];
                  //[tempMarkA fill];
                  //[tempMarkA stroke];
                  [NSBezierPath strokeLineFromPoint:NSMakePoint(PunktA.x-4.1, PunktA.y-4.1)toPoint:NSMakePoint(PunktA.x+4.1, PunktA.y+4.1)];
                  [NSBezierPath strokeLineFromPoint:NSMakePoint(PunktA.x+4.1, PunktA.y-4.1) toPoint:NSMakePoint(PunktA.x-4.1, PunktA.y+4.1)];
                  
               }
            } // if screen
            
         }
         
			//NSLog(@"in klickset i: %d Desc: %@",i,[klickset description]);
         
         if ([KlicksetA count] && screen)
         {
            if (i==[KlicksetA firstIndex])
            {
               [KlickLinieA moveToPoint:PunktA];
            }
            else
            {
               //[KlickLinie lineToPoint:Punkt];
            }
            
            if ([KlicksetA containsIndex:i] && screen)
            {
               //NSLog(@"in klickset i: %d",i);
               NSRect tempMarkRect=NSMakeRect(PunktA.x-1.5, PunktA.y-1.5, 3.1, 3.1);
               tempMarkA=[NSBezierPath bezierPathWithOvalInRect:tempMarkRect];
               [[NSColor blackColor]set];
               [tempMarkA fill];
               if ([KlicksetA count]>1 && i>[KlicksetA firstIndex])
               {
                  [KlickLinieA lineToPoint:PunktA];
               }
            }
         }
         
         // Abbrandlinien
         // Seite B
         
         
         if ([[DatenArray objectAtIndex:i]objectForKey:@"abrbx"]&& screen)
         {
            NSPoint AbbrandPunktB=NSMakePoint(([[[DatenArray objectAtIndex:i]objectForKey:@"abrbx"]floatValue])*scale,([[[DatenArray objectAtIndex:i]objectForKey:@"abrby"]floatValue]+GraphOffset)*scale);
            AbbrandPunktB.y +=abbbranddelay;
            [AbbrandLinieB lineToPoint:AbbrandPunktB];
            NSBezierPath* AbbranddeltaB=[NSBezierPath bezierPath];
            
            [AbbranddeltaB moveToPoint:PunktB];
            [AbbranddeltaB lineToPoint:AbbrandPunktB];
            [[NSColor grayColor]set];
            [AbbranddeltaB stroke];
			}
         
         // Seite A
         if ([[DatenArray objectAtIndex:i]objectForKey:@"abrax"]&& screen)
         {
            NSPoint AbbrandPunktA=NSMakePoint([[[DatenArray objectAtIndex:i]objectForKey:@"abrax"]floatValue]*scale,[[[DatenArray objectAtIndex:i]objectForKey:@"abray"]floatValue]*scale);
            AbbrandPunktA.y +=abbbranddelay;
            [AbbrandLinieA lineToPoint:AbbrandPunktA];
            NSBezierPath* AbbranddeltaA=[NSBezierPath bezierPath];
            
            [AbbranddeltaA moveToPoint:PunktA];
            [AbbranddeltaA lineToPoint:AbbrandPunktA];
            [AbbranddeltaA stroke];
			}
         
		}//for i
      
      [[NSColor grayColor]set];
		[LinieB stroke];
      
		[[NSColor blueColor]set];
		[LinieA stroke];
      
      
      if ([KlickLinieA isEmpty])
      {
         
      }
      else
      {
         [[NSColor greenColor]set];
         [KlickLinieA stroke];
      }
      
      
      [[NSColor grayColor]set];
      [AbbrandLinieB stroke];
      [AbbrandLinieA stroke];

      
      
	} // if Datenarray count

   if (RahmenArray &&[RahmenArray count])
   {
      int i=0;
      NSBezierPath* RahmenPath=[NSBezierPath bezierPath];
      //NSLog(@"Rahmen: %@",[RahmenArray description]);
      //NSLog(@"Rahmen 0: %@",[[RahmenArray objectAtIndex:0]description]);
      NSPoint Startpunkt = NSPointFromString([RahmenArray objectAtIndex:0]);
      Startpunkt.x *= scale;
      Startpunkt.y *= scale;
      
      [RahmenPath moveToPoint:Startpunkt];
      for (i=1; i<[RahmenArray count]; i++)
      {
         //NSLog(@"Rahmen index: %d: %@",i,[[RahmenArray objectAtIndex:i]description]);
         NSPoint Punkt = NSPointFromString([RahmenArray objectAtIndex:i]);
         
			//NSLog(@"i: %d Punkt.x: %.4f Punkt.y: %.4f",i,Punkt.x,Punkt.y);
         NSPoint temppunkt = NSPointFromString([RahmenArray objectAtIndex:i]);
         temppunkt.x *= scale;
         temppunkt.y *= scale;
         
         [RahmenPath lineToPoint:temppunkt];
         
      }
      [RahmenPath lineToPoint:Startpunkt];
      
      [[NSColor grayColor]set];
	[RahmenPath stroke];
   } // if Rahmenarray count
   //NSLog(@"ProfilGraph drawRect end");
}

- (void)dealloc
{
   
   //[super dealloc];
   
}
@end
