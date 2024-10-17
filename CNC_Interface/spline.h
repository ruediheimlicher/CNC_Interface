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
#include <MacTypes.h>

struct Punkt {
   float x;
   float y;
};
extern void gaussEliminationLS(int m, int n, double a[m][n], double x[n-1]);


extern void splinefunc();
extern void makespline();
extern void tridiagonalCubicSplineGen(int n, double h[n], double a[n-1][n], double y[n+1]);
extern void plotBasicBezier(int x0, int y0, int x1, int y1, int x2, int y2) ;
extern void plotBasicBezier2(int x0, int y0, int x1, int y1, int x2, int y2) ;
extern void plotQuadBezierSeg(int x0, int y0, int x1, int y1, int x2, int y2);
extern void quadraticBezierCurve(double x0, double y0, double x1, double y1, double x2, double y2);
extern void splinearrayfunc(double* x, double* y, int m, double* a, double* b, double* c, double* d);
extern void plotCircle(int xm, int ym, int r);

extern int orientation(struct Punkt p1, struct  Punkt p2, struct Punkt p3);
extern bool onSegment(struct Punkt p, struct Punkt q, struct Punkt r) ;
#endif /* spline_h */
