//
//  spline.h
//  CNC_Interface
//
//  Created by Ruedi Heimlicher on 09.01.2023.
//  Copyright © 2023 Ruedi Heimlicher. All rights reserved.
//

#ifndef spline_h
#define spline_h

#include <stdio.h>

extern void gaussEliminationLS(int m, int n, double a[m][n], double x[n-1]);


extern void splinefunc();

#endif /* spline_h */
