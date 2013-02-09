//+------------------------------------------------------------------+
//|                                                       ga_inc.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"


#include <stdlib.mqh>
#include <WinUser32.mqh>
string build = "Gmagic 1.1";
//external variables
extern double Lots = 0.10;
extern int buy_orders_cnt = 2;
extern int sell_orders_cnt = 2;
extern int max_orders_cnt = 4;
extern int maxspread = 50;
extern int sleeptime = 1000;
extern double pending_margin = 0;
extern int magic = 1230;
extern int magic1 = 1231;
extern int magic2 = 1232;
extern int magic3 = 1233;
extern int magic4 = 1234;

extern bool UseAlerts = true;
extern bool UseEmailAlerts = false;

string infobox, initbox, boxopen, boxaveragecosting, boxclose;
//point for each currency started
#define ARRSIZE  28
#define USD 0
#define EUR 1
#define GBP 2
#define CHF 3                                                                                      
#define CAD 4                                                                                      
#define AUD 5                                                                                      
#define JPY 6                                                                                      
#define NZD 7

#define PAIRSIZE 8


#define USDCHF 0
#define GBPUSD 1
#define EURUSD 2
#define USDJPY 3
#define USDCAD 4
#define AUDUSD 5
#define EURGBP 6
#define EURAUD 7
#define EURCHF 8
#define EURJPY 9
#define GBPCHF 10
#define CADJPY 11
#define GBPJPY 12
#define AUDNZD 13
#define AUDCAD 14
#define AUDCHF 15
#define AUDJPY 16
#define CHFJPY 17
#define EURNZD 18
#define EURCAD 19
#define CADCHF 20
#define NZDJPY 21
#define NZDUSD 22
#define GBPCAD 23
#define GBPNZD 24
#define GBPAUD 25
#define NZDCHF 26
#define NZDCAD 27
string aPair[ARRSIZE]   = {
                        "USDCHF","GBPUSD","EURUSD","USDJPY","USDCAD","AUDUSD",
                        "EURGBP","EURAUD","EURCHF","EURJPY","GBPCHF","CADJPY",
                        "GBPJPY","AUDNZD","AUDCAD","AUDCHF","AUDJPY","CHFJPY",
                        "EURNZD","EURCAD","CADCHF","NZDJPY","NZDUSD","GBPCAD",
                        "GBPNZD","GBPAUD","NZDCHF","NZDCAD"
                        };
string aMajor[PAIRSIZE] = {"USD","EUR","GBP","CHF","CAD","AUD","JPY","NZD"};
double aMeter[PAIRSIZE];
double prevaMeter[PAIRSIZE];
//point for each currency ended

int meter_direction;
double point[ARRSIZE];
double digit[ARRSIZE];
double bid[ARRSIZE];
double ask[ARRSIZE];
double spread[ARRSIZE];
string createbox;
double stoploss[ARRSIZE];


int type[ARRSIZE];
double totalcost[ARRSIZE];
int totalorders[ARRSIZE];
double lotsavg[ARRSIZE];
double averagecostingprice[ARRSIZE];
double totalprofit[ARRSIZE];
double returncost[ARRSIZE];

int custom_init()
{

}

int custom_start()
{
   infobox = "";
   string symbol;
   for (int i=0; i<ARRSIZE; i++) {
      symbol = aPair[i];
      ask[i] = MarketInfo(symbol, MODE_ASK);
      bid[i] = MarketInfo(symbol, MODE_BID);
      spread[i] = MarketInfo(symbol, MODE_SPREAD);
      point[i] = MarketInfo(symbol, MODE_POINT);
      digit[i] = MarketInfo(symbol, MODE_DIGITS);
      get_average_costing(symbol, i);
   }
}


int closeallorders(string symbol)
{
      for(int cnt=0;cnt<OrdersTotal();cnt++) {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==symbol
         ) {
            if(OrderType()==OP_BUY) {
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
               Sleep(sleeptime);
            } else if(OrderType()==OP_SELL) {
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
               Sleep(sleeptime);
            }
         }
      }
}

int change_stop_loss(string symbol, double sl)
{
      for(int cnt=0;cnt<OrdersTotal();cnt++) {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==symbol
         ) {
            if(OrderType()==OP_BUY) {
               OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0,Green);
               Sleep(sleeptime);
            } else if(OrderType()==OP_SELL) {
               OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0,Red);
               Sleep(sleeptime);
            }
         }
      }
}


int createorder(string symbol, int timeperiod, int type, string message, int magicnumber, int ignorespread, int mode)
{
   createbox = "\n" + symbol;
   if (IsTradeAllowed()==false) {
      createbox = createbox + " TRADING NOW ALLOWED";
      return (0);
   }
  
   if (MarketInfo(symbol, MODE_SPREAD) > maxspread && ignorespread == 0) {
      return (0);
   }
   int orders;
   int ordertype;
   double price;
   double val3;
   if (type == 1) {
      ordertype = OP_BUY;
      val3 = AccountFreeMarginCheck(symbol, OP_BUY, Lots);
      if (val3 < pending_margin) {
         createbox = createbox + " pending_margin: " + val3 + " NO TRADING";
         return (0);
      }
   } else if (type == -1) {
      ordertype = OP_SELL;
      val3 = AccountFreeMarginCheck(symbol, OP_SELL, Lots);
      if (val3 < pending_margin) {
         createbox = createbox + " pending_margin: " + val3 + " NO TRADING";
         return (0);
      }
   } else {
      return (0);
   }

   orders = CalculateCurrentOrders(symbol, magicnumber);//, ordertype
   if (orders > 0)
   {
      createbox = createbox + " orders: " + orders + " NO TRADING";
      //Print("order already created for symbol: ", symbol);
       return (0);
   }
   
   orders = CalculateCurrentOrdersType(ordertype, magicnumber);
   if (orders > 0 && orders >= buy_orders_cnt && type == 1)
   {
      createbox = createbox + " orders: buy " + orders + " NO TRADING";
       return (0);
   } else 
   if (orders > 0 && orders >= sell_orders_cnt && type == -1)
   {
      createbox = createbox + " orders: sell " + orders + " NO TRADING";
       return (0);
   }
   
   orders = CalculateMaxOrders(magicnumber);
   if (orders > 0 && orders >=max_orders_cnt) {
      return (0);
   }

   double bids, asks, pt, digit;
   bids = MarketInfo(symbol, MODE_BID);
   asks = MarketInfo(symbol, MODE_ASK);
   pt = MarketInfo(symbol, MODE_POINT);
   digit = MarketInfo(symbol, MODE_DIGITS);
   bids = NormalizeDouble(bids, digit);
   asks = NormalizeDouble(asks, digit);
   int ticket;
   double tp, sl;
   tp = 0;
   sl = 0;
   if (type == 1) {
      ticket=OrderSend(symbol,OP_BUY,Lots,asks,3,0,0,message+", "+build,magicnumber,0,Green);
      if(ticket>0)
         {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            stoploss[mode] = 0;
          }
         }
      else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks);
         Sleep(sleeptime);
         createorder(symbol, timeperiod, type, message, magicnumber, ignorespread, mode);
      }
      Sleep(sleeptime);
      return(0); 
   } else if (type == -1) {
       ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,0,0,message+", "+build,magicnumber,0,Red);
        if(ticket>0)
           {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            stoploss[mode] = 0;
          }
           
           }
           else {
               Print(symbol, " Error opening Sell order : ",ErrorDescription(GetLastError()), ", price: ", bids);       
               Sleep(sleeptime);
               createorder(symbol, timeperiod, type, message, magicnumber, ignorespread, mode);
            } 
      
         Sleep(sleeptime);
         return(0); 
   }
}


int CalculateCurrentOrders(string symbol, int magicnumber)//, int ordertype
  {
   int cnt=0;
   int i;
//----
  for(i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
         if(OrderSymbol()==symbol && OrderMagicNumber()==magicnumber)// && ordertype == OrderType()
           {
            cnt++;
           }
        }
   return (cnt);
  }

int CalculateCurrentOrdersType(int ordertype, int magicnumber)
  {
   int cnt=0;
   int i;
//----
  for(i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
         if(ordertype == OrderType() && OrderMagicNumber()==magicnumber)
           {
            cnt++;
           }
        }
   return (cnt);
  }


int CalculateMaxOrders(int magicnumber)
  {
   int cnt=0;
   int i;
//----
  for(i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
         if(OrderMagicNumber()==magicnumber)
           {
            cnt++;
           }
        }
   return (cnt);
  }
  
  
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


int get_average_costing(string symbol, int mode)
{
   int cnt;
   double openprice;
   double lotsize;
   int x = 0;
   lotsavg[mode] = 0.0;
   totalcost[mode] = 0.0;
   type[mode] = 0;
   totalorders[mode] = 0;
   totalprofit[mode] = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==symbol
         //&& (OrderMagicNumber() == magic || OrderMagicNumber() == magic1 || OrderMagicNumber() == magic2 || OrderMagicNumber() == magic3 || OrderMagicNumber() == magic4)
      ) {
         //Print(symbol, ", ", OrderMagicNumber());
         if (OrderMagicNumber() == magic || OrderMagicNumber() == 0) {
            averagecostingprice[mode] = OrderOpenPrice();
         }

         x++;
         totalprofit[mode] += OrderProfit();
         totalorders[mode]++;
         openprice = OrderOpenPrice();
         lotsize = OrderLots();
         lotsavg[mode] = lotsavg[mode] + lotsize;
         totalcost[mode] = totalcost[mode] + (lotsize * openprice);
         if(OrderType()==OP_BUY) {
            type[mode] = 1;            
         } else if(OrderType()==OP_SELL) {
            type[mode] = -1;            
         }
      }
   }

   returncost[mode] = 0;
   if (x == 0) {
      // no previous orders
   } else {
     double cost = 0.0;
     cost = totalcost[mode] / lotsavg[mode];
     returncost[mode] = cost;
  }
  if (totalorders[mode] > 0)
         infobox = infobox + StringConcatenate(symbol, "\nlotsavg[mode]: ", DoubleToStr(lotsavg[mode], 2), ", totalcost[mode]: ", totalcost[mode], ", type: ", type[mode], ", totalprofit[mode]: ", totalprofit[mode], ", returncost[mode]: ", returncost[mode]);
   
}


void SendAlert(string dir, string symbol, int period)
{
   string per = TimeframeToString(period);
   if (UseAlerts)
   {
      Alert(dir + " on ", symbol, " @ ", per);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(symbol + " @ " + per + " - " + dir + " ", dir + " on " + symbol + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
}