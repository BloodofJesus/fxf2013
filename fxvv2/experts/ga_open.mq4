//+------------------------------------------------------------------+
//|                                                      ga_open.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <ga_inc.mqh>

extern double top = 5.9;
extern double bottom = 3.1;
extern bool create_new_orders = true;
extern int threshold = 5;

//remove this
double pts[ARRSIZE][3];
double cur_point[ARRSIZE];
double prev_point[ARRSIZE];

//dont remove this
double grade[ARRSIZE][30];
double condition[ARRSIZE];
int opentimegaopen[ARRSIZE];
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   custom_init();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   infobox = "";
   custom_start();
   strategy_1();
   strategy_2();
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+

int strategy_1()
{
   return (0);
   //point system
   infobox = infobox + "\nStrategy1:\n";
   for (int i=0; i<ARRSIZE; i++) {
      infobox = infobox + "\nSymbol: " + aPair[i] + ", Prev Point: " + prev_point[i];
      cur_point[i] = get_point_system(aPair[i], Period(), i);
      infobox = infobox + ", Current Point: " + cur_point[i];
      if (cur_point[i] >= threshold && prev_point[i] < threshold) {
         infobox = infobox + ", Buy";
         Alert(aPair[i], ", buy");
      } else if (cur_point[i] <= (-1*threshold) && prev_point[i] > (-1*threshold)) {
         infobox = infobox + ", Sell";
         Alert(aPair[i], ", sell");
      }
      prev_point[i] = cur_point[i];
   }
}

int strategy_2()
{
   infobox = infobox + "\nStrategy2:";
   for (int i=0; i<ARRSIZE; i++) {
      if (aPair[i] == "EURJPY" || aPair[i] == "CHFJPY" || aPair[i] == "CADJPY" || aPair[i] == "NZDJPY"
          || aPair[i] == "GBPJPY" || aPair[i] == "EURUSD"  || aPair[i] == "USDCHF"  || aPair[i] == "GBPUSD"
      ) {
         mathmurry(aPair[i], i);
      }
   }
}


double get_point_system(string symbol, int period, int mode)
{
   double points = 0;
   double pointsP = 0;
   double pointsM = 0;
   double totalpoints = 0;
   double increment = 1;
   double high = -1;
      double low = -1;
      double val, val2, val3, val4, val5, val6;
      string tmp;
      double h1,h2,h3,h4;
      int z;
      int number = get_number(period);
      for (z=mode; z<number; z++) {
         if (high == -1) {
            high = iHigh(symbol, period, z);
         }
         if (iHigh(symbol, period, z) > high) {
            high = iHigh(symbol, period, z);
         }
         if (low == -1) {
            low = iLow(symbol, period, z);
         }
         if (iLow(symbol, period, z) < low) {
            low = iLow(symbol, period, z);
         }
      }
      double aRange    = MathMax((high-low)/point[mode],1); 
      double aRatio    = (bid[mode]-low)/aRange/point[mode];
      double aLookup   = iLookup(aRatio*100); 
      double aStrength = 9-aLookup;
      totalpoints = totalpoints + increment;
      if (aLookup > aStrength) {
         points = points + increment;
         pointsP = pointsP + (increment * 1);
      } else if (aLookup < aStrength) {
         points = points - increment;
         pointsM = pointsM - (increment * 1);
      }
      //heiken
         h1 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,mode);
         h2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,mode);
         h3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,mode+1);
         h4 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,mode+1);
         totalpoints = totalpoints + increment;
         if (h1 < h2) {
            points = points + increment;
            pointsP = pointsP + (increment * 2);
         } else if (h1 > h2) {
            points = points - increment;
            pointsM = pointsM - (increment * 2);
         }
         
         val = iRSI(symbol, period,7,PRICE_CLOSE,mode);
         val2 = iRSI(symbol, period,7,PRICE_CLOSE,mode+1);
         totalpoints = totalpoints + increment;
         if (val > 70) {
            points = points + increment;
            pointsP = pointsP + (increment * 3);
         } else if (val < 30) {
            points = points - increment;
         pointsM = pointsM - (increment * 3);
         } 
         
         //macd
         val2 = iCustom(symbol, period, "MACD_Complete",1,mode);
         val3 = iCustom(symbol, period, "MACD_Complete",2,mode);
         val4 = iCustom(symbol, period, "MACD_Complete",1,mode+1);
         val5 = iCustom(symbol, period, "MACD_Complete",2,mode+1);
         totalpoints = totalpoints + increment;
         if (val2 > val3) {
            points = points + increment;
            pointsP = pointsP + (increment * 4);
         } else if (val2 < val3) {
            points = points - increment;
         pointsM = pointsM - (increment * 4);
         } 
         
         //ema
         val = iMA(symbol,period,17,0,MODE_EMA,PRICE_CLOSE,mode);
         val2 = iMA(symbol,period,43,0,MODE_EMA,PRICE_CLOSE,mode);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            pointsP = pointsP + (increment * 5);
         } else if (val < val2) {
            points = points - increment;
         pointsM = pointsM - (increment * 5);
         }
         
         //iStochastic
         val = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,mode);
         val2 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,mode);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            pointsP = pointsP + (increment * 6);
         } else if (val < val2) {
            points = points - increment;
         pointsM = pointsM - (increment * 6);
         }
         //parabolic
         val = iSAR(symbol,period,0.02,0.2,mode);
         totalpoints = totalpoints + increment;
         if (val < iOpen(symbol, period, mode)) {
            points = points + increment;
            pointsP = pointsP + (increment * 7);
         } else if (val > iOpen(symbol, period, mode)) {
            points = points - increment;
         pointsM = pointsM - (increment * 7);
         }
         
         //ichimoku      
         val=iIchimoku(symbol,period, 9, 26, 52, MODE_TENKANSEN, mode);
         val2=iIchimoku(symbol,period, 9, 26, 52, MODE_KIJUNSEN, mode);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            pointsP = pointsP + (increment * 8);
         } else if (val < val2) {
            points = points - increment;
         pointsM = pointsM - (increment * 8);
         } 
         
         //adx
         val = iADX(symbol,period,14,PRICE_CLOSE,MODE_MAIN,mode);
         val2 = iADX(symbol,period,14,PRICE_CLOSE,MODE_PLUSDI,mode);
         val3 = iADX(symbol,period,14,PRICE_CLOSE,MODE_MINUSDI,mode);
         totalpoints = totalpoints + increment;
         if (val > 20 && val2 > val3) {
            points = points + increment;
            pointsP = pointsP + (increment * 9);
         } else if (val > 20 && val2 < val3) {
            points = points - increment;
         pointsM = pointsM - (increment * 9);
         }
         infobox = infobox + ", Points: " + points + ", PointsP: " + pointsP + ", PointsM: " + pointsM;
    return (points);
}



int get_number(int P)
{
   switch(P)
   {
      case PERIOD_M1:  return(101);
      case PERIOD_M5:  return(76);
      case PERIOD_M15: return(51);
      case PERIOD_M30: return(25);
      case PERIOD_H1:  return(13);
      case PERIOD_H4:  return(4);
      case PERIOD_D1:  return(4);
      case PERIOD_W1:  return(4);
      case PERIOD_MN1: return(4);
      case 0: return (4);
   }
}


int iLookup(double ratio)                                                   // this function will return a grade value
  {                                                                         // based on its power.
   int    aTable[10]  = {0,3,10,25,40,50,60,75,90,97};                 // grade table for currency's power
   int   index;
   
   if      (ratio <= aTable[0]) index = 0;
   else if (ratio < aTable[1])  index = 0;
   else if (ratio < aTable[2])  index = 1;
   else if (ratio < aTable[3])  index = 2;
   else if (ratio < aTable[4])  index = 3;
   else if (ratio < aTable[5])  index = 4;
   else if (ratio < aTable[6])  index = 5;
   else if (ratio < aTable[7])  index = 6;
   else if (ratio < aTable[8])  index = 7;
   else if (ratio < aTable[9])  index = 8;
   else                         index = 9;
   return(index);                                                           // end of iLookup function
  }

//murry MathS

extern int P = 64;
extern int MMPeriod = 1440;
extern int StepBack = 0;

extern color  mml_clr_m_2_8 = White;       // [-2]/8
extern color  mml_clr_m_1_8 = White;       // [-1]/8
extern color  mml_clr_0_8   = Aqua;        //  [0]/8
extern color  mml_clr_1_8   = Yellow;      //  [1]/8
extern color  mml_clr_2_8   = Red;         //  [2]/8
extern color  mml_clr_3_8   = Green;       //  [3]/8
extern color  mml_clr_4_8   = Blue;        //  [4]/8
extern color  mml_clr_5_8   = Green;       //  [5]/8
extern color  mml_clr_6_8   = Red;         //  [6]/8
extern color  mml_clr_7_8   = Yellow;      //  [7]/8
extern color  mml_clr_8_8   = Aqua;        //  [8]/8
extern color  mml_clr_p_1_8 = White;       // [+1]/8
extern color  mml_clr_p_2_8 = White;       // [+2]/8

extern int    mml_wdth_m_2_8 = 2;        // [-2]/8
extern int    mml_wdth_m_1_8 = 1;       // [-1]/8
extern int    mml_wdth_0_8   = 1;        //  [0]/8
extern int    mml_wdth_1_8   = 1;      //  [1]/8
extern int    mml_wdth_2_8   = 1;         //  [2]/8
extern int    mml_wdth_3_8   = 1;       //  [3]/8
extern int    mml_wdth_4_8   = 1;        //  [4]/8
extern int    mml_wdth_5_8   = 1;       //  [5]/8
extern int    mml_wdth_6_8   = 1;         //  [6]/8
extern int    mml_wdth_7_8   = 1;      //  [7]/8
extern int    mml_wdth_8_8   = 1;        //  [8]/8
extern int    mml_wdth_p_1_8 = 1;       // [+1]/8
extern int    mml_wdth_p_2_8 = 2;       // [+2]/8

extern color  MarkColor   = Blue;
extern int    MarkNumber  = 217;


double  dmml = 0,
        dvtl = 0,
        sum  = 0,
        v1 = 0,
        v2 = 0,
        mn = 0,
        mx = 0,
        x1 = 0,
        x2 = 0,
        x3 = 0,
        x4 = 0,
        x5 = 0,
        x6 = 0,
        y1 = 0,
        y2 = 0,
        y3 = 0,
        y4 = 0,
        y5 = 0,
        y6 = 0,
        octave = 0,
        fractal = 0,
        range   = 0,
        finalH  = 0,
        finalL  = 0,
        mml[13];

string  ln_txt[13],        
        buff_str = "";
        
int     
        bn_v1   = 0,
        bn_v2   = 0,
        OctLinesCnt = 13,
        mml_thk = 8,
        mml_clr[13],
        mml_wdth[13],
        mml_shft = 35,
        nTime = 0,
        CurPeriod = 0,
        nDigits = 0,
        i = 0;
int NewPeriod=0;

int mathmurry(string symbol, int mode)
{
   if(MMPeriod>0)
      NewPeriod   = P*MathCeil(MMPeriod/Period());
   else NewPeriod = P;
   
   ln_txt[0]  = "[-2/8]P";// "extremely overshoot [-2/8]";// [-2/8]
   ln_txt[1]  = "[-1/8]P";// "overshoot [-1/8]";// [-1/8]
   ln_txt[2]  = "[0/8]P";// "Ultimate Support - extremely oversold [0/8]";// [0/8]
   ln_txt[3]  = "[1/8]P";// "Weak, Stall and Reverse - [1/8]";// [1/8]
   ln_txt[4]  = "[2/8]P";// "Pivot, Reverse - major [2/8]";// [2/8]
   ln_txt[5]  = "[3/8]P";// "Bottom of Trading Range - [3/8], if 10-12 bars then 40% Time. BUY Premium Zone";//[3/8]
   ln_txt[6]  = "[4/8]P";// "Major Support/Resistance Pivotal Point [4/8]- Best New BUY or SELL level";// [4/8]
   ln_txt[7]  = "[5/8]P";// "Top of Trading Range - [5/8], if 10-12 bars then 40% Time. SELL Premium Zone";//[5/8]
   ln_txt[8]  = "[6/8]P";// "Pivot, Reverse - major [6/8]";// [6/8]
   ln_txt[9]  = "[7/8]P";// "Weak, Stall and Reverse - [7/8]";// [7/8]
   ln_txt[10] = "[8/8]P";// "Ultimate Resistance - extremely overbought [8/8]";// [8/8]
   ln_txt[11] = "[+1/8]P";// "overshoot [+1/8]";// [+1/8]
   ln_txt[12] = "[+2/8]P";// "extremely overshoot [+2/8]";// [+2/8]

   //mml_shft = 3;
   mml_thk  = 3;


   mml_clr[0]  = mml_clr_m_2_8;   mml_wdth[0] = mml_wdth_m_2_8; // [-2]/8
   mml_clr[1]  = mml_clr_m_1_8;   mml_wdth[1] = mml_wdth_m_1_8; // [-1]/8
   mml_clr[2]  = mml_clr_0_8;     mml_wdth[2] = mml_wdth_0_8;   //  [0]/8
   mml_clr[3]  = mml_clr_1_8;     mml_wdth[3] = mml_wdth_1_8;   //  [1]/8
   mml_clr[4]  = mml_clr_2_8;     mml_wdth[4] = mml_wdth_2_8;   //  [2]/8
   mml_clr[5]  = mml_clr_3_8;     mml_wdth[5] = mml_wdth_3_8;   //  [3]/8
   mml_clr[6]  = mml_clr_4_8;     mml_wdth[6] = mml_wdth_4_8;   //  [4]/8
   mml_clr[7]  = mml_clr_5_8;     mml_wdth[7] = mml_wdth_5_8;   //  [5]/8
   mml_clr[8]  = mml_clr_6_8;     mml_wdth[8] = mml_wdth_6_8;   //  [6]/8
   mml_clr[9]  = mml_clr_7_8;     mml_wdth[9] = mml_wdth_7_8;   //  [7]/8
   mml_clr[10] = mml_clr_8_8;     mml_wdth[10]= mml_wdth_8_8;   //  [8]/8
   mml_clr[11] = mml_clr_p_1_8;   mml_wdth[11]= mml_wdth_p_1_8; // [+1]/8
   mml_clr[12] = mml_clr_p_2_8;   mml_wdth[12]= mml_wdth_p_2_8; // [+2]/8
   
   bn_v1 = Lowest(symbol, Period(),MODE_LOW,NewPeriod+StepBack,StepBack);
   bn_v2 = Highest(symbol, Period(),MODE_HIGH,NewPeriod+StepBack,StepBack);
   v1 = iLow(symbol, Period(), bn_v1);
   v2 = iHigh(symbol, Period(), bn_v2);
   if( v2<=250000 && v2>25000 )
   fractal=100000;
   else
     if( v2<=25000 && v2>2500 )
     fractal=10000;
     else
       if( v2<=2500 && v2>250 )
       fractal=1000;
       else
         if( v2<=250 && v2>25 )
         fractal=100;
         else
           if( v2<=25 && v2>12.5 )
           fractal=12.5;
           else
             if( v2<=12.5 && v2>6.25)
             fractal=12.5;
             else
               if( v2<=6.25 && v2>3.125 )
               fractal=6.25;
               else
                 if( v2<=3.125 && v2>1.5625 )
                 fractal=3.125;
                 else
                   if( v2<=1.5625 && v2>0.390625 )
                   fractal=1.5625;
                   else
                     if( v2<=0.390625 && v2>0)
                     fractal=0.1953125;
      
   range=(v2-v1);
   sum=MathFloor(MathLog(fractal/range)/MathLog(2));
   octave=fractal*(MathPow(0.5,sum));
   mn=MathFloor(v1/octave)*octave;
   if( (mn+octave)>v2 )
   mx=mn+octave; 
   else
     mx=mn+(2*octave);
     
   
// calculating xx
//x2
    if( (v1>=(3*(mx-mn)/16+mn)) && (v2<=(9*(mx-mn)/16+mn)) )
    x2=mn+(mx-mn)/2; 
    else x2=0;
//x1
    if( (v1>=(mn-(mx-mn)/8))&& (v2<=(5*(mx-mn)/8+mn)) && (x2==0) )
    x1=mn+(mx-mn)/2; 
    else x1=0;

//x4
    if( (v1>=(mn+7*(mx-mn)/16))&& (v2<=(13*(mx-mn)/16+mn)) )
    x4=mn+3*(mx-mn)/4; 
    else x4=0;

//x5
    if( (v1>=(mn+3*(mx-mn)/8))&& (v2<=(9*(mx-mn)/8+mn))&& (x4==0) )
    x5=mx; 
    else  x5=0;

//x3
    if( (v1>=(mn+(mx-mn)/8))&& (v2<=(7*(mx-mn)/8+mn))&& (x1==0) && (x2==0) && (x4==0) && (x5==0) )
    x3=mn+3*(mx-mn)/4; 
    else x3=0;

//x6
    if( (x1+x2+x3+x4+x5) ==0 )
    x6=mx; 
    else x6=0;

     finalH = x1+x2+x3+x4+x5+x6;
// calculating yy
//y1
    if( x1>0 )
    y1=mn; 
    else y1=0;

//y2
    if( x2>0 )
    y2=mn+(mx-mn)/4; 
    else y2=0;

//y3
    if( x3>0 )
    y3=mn+(mx-mn)/4; 
    else y3=0;

//y4
    if( x4>0 )
    y4=mn+(mx-mn)/2; 
    else y4=0;

//y5
    if( x5>0 )
    y5=mn+(mx-mn)/2; 
    else y5=0;

//y6
    if( (finalH>0) && ((y1+y2+y3+y4+y5)==0) )
    y6=mn; 
    else y6=0;

    finalL = y1+y2+y3+y4+y5+y6;

    for( i=0; i<OctLinesCnt; i++) {
         mml[i] = 0;
         }
         
   dmml = (finalH-finalL)/8;

   mml[0] =(finalL-dmml*2); //-2/8
   grade[mode][0] = mml[0];

   infobox = StringConcatenate(infobox, "\n", symbol);
   infobox = StringConcatenate(infobox, ", 0: ", DoubleToStr(grade[mode][0], MarketInfo(symbol, MODE_DIGITS)));
   for( i=1; i<OctLinesCnt; i++) {
        mml[i] = mml[i-1] + dmml;
        grade[mode][i] = mml[i];
        infobox = StringConcatenate(infobox, ", ", i, ": ", DoubleToStr(grade[mode][i], MarketInfo(symbol, MODE_DIGITS)));
        }
   int currentlevel = -1;
   if (bid[mode] < grade[mode][0]) {
      currentlevel = 0;
   } else if (bid[mode] > grade[mode][12]) {
      currentlevel = 13;
   } else {
      for ( i=0; i<OctLinesCnt-1; i++) {
         if (bid[mode] > grade[mode][i] && bid[mode] < grade[mode][i + 1]) {
            currentlevel = i+1;
         }
      }
   }
   infobox = StringConcatenate(infobox, " - ", DoubleToStr(((grade[mode][12] - grade[mode][0])/MarketInfo(symbol, MODE_POINT)), 0));
   infobox = StringConcatenate(infobox, " - Level: ", currentlevel);
   if (currentlevel >= 10) {
      condition[mode] = -1;
   } else if (currentlevel <= 2) {
      condition[mode] = 1;
   }
   // else if (currentlevel >= 4 || currentlevel < 8) {
     // condition[mode] = 0;
   //}
         bool condition_buy = false;
         bool condition_sell = false;
         double h1 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
         double h2 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
         double h3 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
         double h4 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
         
         double val=iIchimoku(symbol,PERIOD_H1, 9, 26, 52, MODE_TENKANSEN, mode);
         
         if (h1 < h2 && h3 > h4) {
            condition_buy = true;
         } else if (h1 > h2 && h3 < h4) {
            condition_sell = true;
         }
   if (condition[mode] == 1) {
      infobox = StringConcatenate(infobox, ", Buy");
      if (condition_buy) {
         infobox = StringConcatenate(infobox, " Strong");
         if (opentimegaopen[mode] != Time[0]) {
            SendAlert("Bullish", symbol, Period());
            opentimegaopen[mode] = Time[0];
         }
      }
   } else 
   if (condition[mode] == -1) {
      infobox = StringConcatenate(infobox, ", Sell");
      if (condition_sell) {
         infobox = StringConcatenate(infobox, " Strong");
         if (opentimegaopen[mode] != Time[0]) {
            SendAlert("Bearish", symbol, Period());
            opentimegaopen[mode] = Time[0];
         }
      }
   }
   
   if (h1 < h2) {
      infobox = StringConcatenate(infobox, ", HBuy");
   } else if (h1 > h2) {
      infobox = StringConcatenate(infobox, ", HSell");
   }
}