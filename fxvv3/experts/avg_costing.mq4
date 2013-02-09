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
   double val2, val3, val4, val5; int x;
   double history;
   double openPositionTotal;
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
      
      val2 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
      string testbox = "\naLookupSingle: " +aLookupSingle + ", aStrengthSingle: " + aStrengthSingle + ", Lots: "+lots+", val2: " + val2 + ", val3: " + val3 + "\n";
      if (
      val2 < val3 && 
      (indication == 1 || indication == 0) && aLookupSingle >= 8) {
         createorder(aPair[x], 1, lots, magic, "", 0, 0);
      } else if (
      val2 > val3 && 
      (indication == -1 && indication == 0) && aLookupSingle <= 1) {
         createorder(aPair[x], -1, lots, magic, "", 0, 0);
      }
   }
   Comment (testbox, infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+