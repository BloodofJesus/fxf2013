//+------------------------------------------------------------------+
//|                                         cu_heiken_indication.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://www.mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://www.mkgalaxy.com"
#property indicator_chart_window
extern int gmt_offset = 3;
#define ARRSIZE  28
#define TABSIZE  10
string aPair[ARRSIZE]   = {
                        "USDCHF","GBPUSD","EURUSD","USDJPY","USDCAD","AUDUSD",
                        "EURGBP","EURAUD","EURCHF","EURJPY","GBPCHF","CADJPY",
                        "GBPJPY","AUDNZD","AUDCAD","AUDCHF","AUDJPY","CHFJPY",
                        "EURNZD","EURCAD","CADCHF","NZDJPY","NZDUSD","GBPCAD",
                        "GBPNZD","GBPAUD","NZDCHF","NZDCAD"
                        };
int openTime;
string infobox;
string impbox;
extern bool UseAlerts = false;
extern bool UseEmailAlerts = false; 
int hour;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   if (openTime != Time[0]) {
      Sleep(10000);
        hour = Hour() - gmt_offset;
         if (hour < 0) {
            hour = hour + 24;
         }

      infobox = "\n";
      impbox = "\n";
      int index;
      double ask, bid, digits, point, spread;
      impbox = impbox + "Server Time: (GMT +3 hours) " + TimeToStr(TimeCurrent()) + "\n";
      double val2, val3, val4, val5;
      double high, low;
      double aHigh[ARRSIZE];
      double aLow[ARRSIZE];
      double aHigh1[ARRSIZE];
      double aBid[ARRSIZE];
      double aAsk[ARRSIZE];
      double aRatio[ARRSIZE];
      double aRange[ARRSIZE];
      double aLookup[ARRSIZE];
      double aStrength[ARRSIZE];
      int z;
      int number = 4;
      string mySymbol;
      for (index = 0; index < ARRSIZE; index++) {
         mySymbol = aPair[index];
         infobox = infobox + "\n" + aPair[index];
         bid = MarketInfo(aPair[index], MODE_BID);
         ask = MarketInfo(aPair[index], MODE_ASK);
         point = MarketInfo(aPair[index], MODE_POINT);
         spread = MarketInfo(aPair[index], MODE_SPREAD);
         digits = MarketInfo(aPair[index], MODE_DIGITS);
         val2 = iCustom(aPair[index], PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
         val3 = iCustom(aPair[index], PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
         val4 = iCustom(aPair[index], PERIOD_H1, "Heiken_Ashi_Smoothed",2,2);
         val5 = iCustom(aPair[index], PERIOD_H1, "Heiken_Ashi_Smoothed",3,2);
         //Calculating the points:
         high = -1;
         low = -1;
         for (z=0; z<number; z++) {
            if (high == -1) {
               high = iHigh(mySymbol, PERIOD_H4, z);
            }
            if (iHigh(mySymbol, PERIOD_H4, z) > high) {
               high = iHigh(mySymbol, PERIOD_H4, z);
            }
            if (low == -1) {
               low = iLow(mySymbol, PERIOD_H4, z);
            }
            if (iLow(mySymbol, PERIOD_H4, z) < low) {
               low = iLow(mySymbol, PERIOD_H4, z);
            }
         }
         aHigh[index] = high;
         aLow[index]      = low; 
         aBid[index]      = bid;                 
         aAsk[index]      = ask;                 
         aRange[index]    = MathMax((aHigh[index]-aLow[index])/point,1);      // calculate range today  
         aRatio[index]    = (aBid[index]-aLow[index])/aRange[index]/point;     // calculate pair ratio
         aLookup[index]   = iLookup(aRatio[index]*100);                        // set a pair grade
         aStrength[index] = 9-aLookup[index]; 
         if (val2 < val3 && val4 > val5 ) { //&& aLookup[index] > aStrength[index]
            impbox = impbox + "\n" + aPair[index];
            impbox = impbox + ":BUY:Close Sell Position";
            SendAlert("Bullish", aPair[index], PERIOD_H1);
            if (hour == 20 || hour == 21 || hour == 22) {
               impbox = impbox + " Hour: " + hour + " SO DO NOT TRADE, NO TRADING BETWEEN (20 TO 22 HOUR)";
            }
         } else if (val2 > val3 && val4 < val5) {// && aLookup[index] < aStrength[index]
            impbox = impbox + "\n" + aPair[index];
            impbox = impbox + ":SELL:Close Buy Position";
            SendAlert("Bearish", aPair[index], PERIOD_H1);
            if (hour == 20 || hour == 21 || hour == 22) {
               impbox = impbox + " Hour: " + hour + " SO DO NOT TRADE, NO TRADING BETWEEN (20 TO 22 HOUR)";
            }
         }
         infobox = infobox + ", val2: "+ DoubleToStr(val2, digits)
          + ", val3: "+ DoubleToStr(val3, digits)
          + ", val4: "+ DoubleToStr(val4, digits)
          + ", val5: "+ DoubleToStr(val5, digits);
         infobox = infobox + ", Bid: "+ DoubleToStr(bid, digits)
          + ", Ask: "+ DoubleToStr(ask, digits)
           + ", Spread: "+ spread;
           infobox = infobox + ", Lookup: "+ aLookup[index]
          + ", Strength: "+ aStrength[index];
         if (val2 < val3) {
            infobox = infobox + ", Current Buy";
         } else if (val2 > val3) {
            infobox = infobox + ", Current Sell";         
         }
      }
      Comment(impbox, infobox);
      string filename = "indicator.txt";
      FileDelete(filename);
      FileAppend(filename,impbox + infobox);
      openTime = Time[0];
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+


string TimeframeToString(int P)
{
   switch(P)
   {
      case PERIOD_M1:  return("M1");
      case PERIOD_M5:  return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1:  return("H1");
      case PERIOD_H4:  return("H4");
      case PERIOD_D1:  return("D1");
      case PERIOD_W1:  return("W1");
      case PERIOD_MN1: return("MN1");
      case 0: return ("Any");
   }
}
void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}

void SendAlert(string dir, string symbol, int tp)
{
   string per = TimeframeToString(tp);
   if (UseAlerts)
   {
      Alert(dir + " Heiken on ", symbol, " @ ", per);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(symbol + " @ " + per + " - " + dir + " Heiken", dir + " Heiken on " + symbol + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
}
int iLookup(double ratio)                                                   // this function will return a grade value
  {                                                                         // based on its power.
   int    aTable[TABSIZE]  = {0,3,10,25,40,50,60,75,90,97};                 // grade table for currency's power
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