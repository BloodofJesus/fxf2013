//+------------------------------------------------------------------+
//|                                                  avg_costing.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
extern int indication = 0;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
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
   infobox = "\n";
   string symbol;
   double val2, val3, val4, val5, val6, val7, val8, val9; int x;
   double history;
   double openPositionTotal;
   //lots = 0.01;
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      if (symbol != Symbol()) {
         continue;
      }
      history = history2(symbol);
      openPositionTotal = openPositionTotal(symbol);
      //history(symbol, x, magic);
      render_avg_costing(symbol, x, lots);
      getallinfoSingle(symbol);
      string testbox = "\naLookupSingle: " +aLookupSingle + ", aStrengthSingle: " + aStrengthSingle + ", Lots: "+lots+"\n";
      
      val2 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,1);
      val3 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,1);
      val4 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,2);
      val5 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,2);
      val6 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
      val7 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
      val8 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,2);
      val9 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,2);
      if (val2 < val3 || val6 < val7) {
         CheckForClose(aPair[x], x, magic, 1);
      } else if (val2 > val3 || val6 > val7) {
         CheckForClose(aPair[x], x, magic, -1);
      }
      if (
      (val2 < val3 && 
      val4 > val5 &&
      val6 < val7)
      ||
      (val2 < val3 &&
      val6 < val7 &&
      val8 > val9)
      ) {
         createorder(aPair[x], 1, lots, magic, "AvgCosting Heiken", 0, 0);
      } else if (
     (val2 > val3 && 
      val4 < val5 &&
      val6 > val7)
      ||
      (val2 > val3 &&
      val6 > val7 &&
      val8 < val9) 
      ) {
         createorder(aPair[x], -1, lots, magic, "AvgCosting Heiken", 0, 0);
      }
   }
   Comment (testbox, infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+