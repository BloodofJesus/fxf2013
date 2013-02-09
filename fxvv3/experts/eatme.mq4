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
   double val2, val3, val4, val5, val6, val7, val8, val9, val10, val11; int x;
   double history;
   double openPositionTotal;
   double lotnew;
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      if (symbol != Symbol()) {
         continue;
      }
      history = history2(symbol);
      openPositionTotal = openPositionTotal(symbol);
      
      val2 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,1);
      val3 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,1);
      val4 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,2);
      val5 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,2);
      
      lotnew = NormalizeDouble(AccountBalance() / 10000, 2);
      if (lotnew < 0.01) lotnew = 0.01;
      infobox = infobox + "\nSymbol: " + symbol + " and Period: " + PERIOD_H4 + " and Lot New is: " + lotnew + "\n";
      if (
      val2 < val3 && val4 > val5
      ) {
         CheckForCloseWithoutProfit(symbol, x, magic, 1);
         createorder(aPair[x], 1, lotnew, magic, "", 0, 0);
      } else if (
      val2 > val3 && val4 < val5) {
         CheckForCloseWithoutProfit(symbol, x, magic, -1);
         createorder(aPair[x], -1, lotnew, magic, "", 0, 0);
      }
   }
   Comment (infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+