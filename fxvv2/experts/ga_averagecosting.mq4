//+------------------------------------------------------------------+
//|                                            ga_averagecosting.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <ga_inc.mqh>

extern bool create_avg_orders = true;
int difference[ARRSIZE];
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
   custom_start();
   
   for (int i=0; i<ARRSIZE; i++) {
      difference[i] = get_difference(aPair[i], i);
      //Print(difference[i]);
      //closingonprofit(symbol);
      create_average_costing(aPair[i], i);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+

int get_difference(string symbol, int mode)
{
   double diff1, diff2, diff3, diff4, diff5, diff;
   diff1 = iHigh(symbol, PERIOD_D1, 1) - iLow(symbol, PERIOD_D1, 1);
   diff2 = iHigh(symbol, PERIOD_D1, 2) - iLow(symbol, PERIOD_D1, 2);
   diff3 = iHigh(symbol, PERIOD_D1, 3) - iLow(symbol, PERIOD_D1, 3);
   diff4 = iHigh(symbol, PERIOD_D1, 4) - iLow(symbol, PERIOD_D1, 4);
   diff5 = iHigh(symbol, PERIOD_D1, 5) - iLow(symbol, PERIOD_D1, 5);
   diff = (diff1 + diff2 + diff3 + diff4 + diff5) / 5;
   return (diff / point[mode]);
}




int create_average_costing(string symbol, int mode)
{
   return (0);
   int diff;
   if (totalprofit[mode] < 0) {
      diff = MathAbs(bid[mode] - averagecostingprice[mode]) / point[mode];
      infobox = infobox + "\nTotal Profit: " + totalprofit[mode] + 
         " - Total Average: " + averagecostingprice[mode] + " - Current Diff: " + diff + 
         " - Custom Diff: " + difference[mode] + " - Type: " + type[mode];
   
      if (diff > (difference[mode] * 1) && diff < (difference[mode] * 2) && create_avg_orders) {
         infobox = infobox + " - D1:" + (difference[mode] * 1);
         createorder(symbol, Period(), type[mode], TimeframeToString(Period()) + " Level 1", magic1, 1, mode);
      } 
      if (diff > (difference[mode] * 2) && diff < (difference[mode] * 3) && create_avg_orders) {
         infobox = infobox + " - D2:" + (difference[mode] * 2);
         createorder(symbol, Period(), type[mode], TimeframeToString(Period()) + " Level 2", magic2, 1, mode);
      } 
      if (diff > (difference[mode] * 3) && diff < (difference[mode] * 4) && create_avg_orders) {
         infobox = infobox + " - D3:" + (difference[mode] * 3);
         createorder(symbol, Period(), type[mode], TimeframeToString(Period()) + " Level 3", magic3, 1, mode);
      } 
      if (diff > (difference[mode] * 4) && create_avg_orders) {
         infobox = infobox + " - D4:" + (difference[mode] * 4);
         createorder(symbol, Period(), type[mode], TimeframeToString(Period()) + " Level 4", magic4, 1, mode);
      }
      //Print(symbol, " - ", totalprofit, " - ", returncost, " - ", diff, " - ", difference, " - ", type);
   }
}