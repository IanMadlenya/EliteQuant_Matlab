classdef MovingAverageCrossStrategy < StrategyBase
   properties
      shortWindow
      longWindow
      nBars
      invested
      prices
   end
   methods (Access = public)
      function self = MovingAverageCrossStrategy(symbols)
          self = self@StrategyBase(symbols);   % call base class
          
          self.shortWindow = 50;
          self.longWindow = 200;
          
          self.reset();
      end
      
      function reset(self)
          self.nBars = 0;
          self.invested = false;
          self.prices = [];
      end
      
      function onbar(self, barEvent)
          if (self.symbols{1} == barEvent.fullSymbol)
              self.prices = [self.prices, barEvent.adjClosePrice];
              self.nBars = self.nBars + 1;
              
              if (self.nBars >= self.longWindow)
                  shortSMA = mean(self.prices(end-self.shortWindow+1:end));
                  longSMA = mean(self.prices(end-self.longWindow+1:end));
                  
                  if ((shortSMA > longSMA) && (~self.invested))
                      disp(['long ' datestr(barEvent.barendtime()) ' short sma ' num2str(shortSMA) ' long sma ' num2str(longSMA)]);
                      
                      o = OrderEvent();
                      o.fullSymbol = self.symbols{1};
                      o.orderType = OrderType.MARKET;
                      o.size = 100;
                      self.placeorder(o);
                      self.invested = true;
                  elseif ((shortSMA < longSMA) && (self.invested))
                      disp(['short ' datestr(barEvent.barendtime()) ' short sma ' num2str(shortSMA) ' long sma ' num2str(longSMA)]);
                      
                      o = OrderEvent();
                      o.fullSymbol = self.symbols{1};
                      o.orderType = OrderType.MARKET;
                      o.size = -100;
                      self.placeorder(o);
                      self.invested = false;
                  end
              end
          end
      end
   end
end