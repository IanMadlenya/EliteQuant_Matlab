classdef Position < handle
   properties
      fullSymbol
      averagePrice
      size
      realizedPnL
      unrealizedPnL
   end
   methods (Access = public)
      function self = Position(fullSymbol, averagePrice, size)
          self.fullSymbol = fullSymbol;
          self.averagePrice = averagePrice;
          self.size = size;
          self.realizedPnL = 0;
          self.unrealizedPnL = 0;
      end
      
      function marktomarket(self, lastPrice)
          self.unrealizedPnL = (lastPrice - self.averagePrice) * self.size ...
              * retrievemultiplierfromfullsymbol(self.fullSymbol);
      end
      
      function onfill(self, fillEvent)
          if (self.fullSymbol ~= fillEvent.fullSymbol)
              disp('Position symbol does not match fill event symbol');
          end
          
          if (self.size > 0)  % exisiting long
              if (fillEvent.fillSize > 0)       % long more
                  self.averagePrice = (self.averagePrice * self.size + ...
                      fillEvent.fillPrice * fillEvent.fillSize + ...
                      fillEvent.commission / retrievemultiplierfromfullsymbol(self.fullSymbol)) ...
                      / (self.size + fillEvent.fillSize);
              else           % flat long
                  if (abs(self.size) >= abs(fillEvent.fillSize))  % stay long
                      self.realizedPnL = self.realizedPnL + (self.averagePrice - fillEvent.fillPrice) * fillEvent.fillSize ...
                          * retrievemultiplierfromfullsymbol(self.fullSymbol) - fillEvent.commission;
                  else  % flip to short
                      self.realizedPnL = self.realizedPnL + (fillEvent.fillSize - self.averagePrice) * self.size ...
                          * retrievemultiplierfromfullsymbol(self.fullSymbol) - fillEvent.commission;
                      self.averagePrice = fillEvent.fillPrice;
                  end
              end
          else         % exising short
              if (fillEvent.fillSize < 0)       % short more
                  self.averagePrice = (self.averagePrice * self.size + ...
                      fillEvent.fillPrice * fillEvent.fillSize + ...
                      fillEvent.commission / retrievemultiplierfromfullsymbol(self.fullSymbol)) ...
                      / (self.size + fillEvent.fillSize);
              else           % flat short
                  if (abs(self.size) >= abs(fillEvent.fillSize))  % stay short
                      self.realizedPnL = self.realizedPnL + (self.averagePrice - fillEvent.fillPrice) * fillEvent.fillSize ...
                          * retrievemultiplierfromfullsymbol(self.fullSymbol) - fillEvent.commission;
                  else  % flip to long
                      self.realizedPnL = self.realizedPnL + (fillEvent.fillPrice - self.averagePrice) * self.size ...
                          * retrievemultiplierfromfullsymbol(self.fullSymbol) - fillEvent.commission;
                      self.averagePrice = fillEvent.fillPrice;
                  end
              end
          end
          
          self.size = self.size + fillEvent.fillSize;
      end
   end
end