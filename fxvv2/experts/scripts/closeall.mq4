//+------------------------------------------------------------------+
//|                                                        close.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"
#property show_confirm

//+------------------------------------------------------------------+
//| script "close first market order if it is first in the list"     |
//+------------------------------------------------------------------+
int start()
  {
   bool   result;
   double price;
   int    cmd,error;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      cmd=OrderType();
      if(cmd==OP_BUY || cmd==OP_SELL)
        {
         if(cmd==OP_BUY) price=MarketInfo(OrderSymbol(), MODE_BID);
            else            price=MarketInfo(OrderSymbol(), MODE_ASK);
         result=OrderClose(OrderTicket(),OrderLots(),price,3,CLR_NONE);
         if(result!=TRUE) { error=GetLastError(); Print("LastError = ",error); }
            else error=0;
            if(error==135) RefreshRates();
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+