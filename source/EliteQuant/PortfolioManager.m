classdef PortfolioManager < handle
   properties
      cash
      positions
   end
   methods (Access = public)
      function self = PortfolioManager(cash)
          self.cash = cash;
          self.positions = {};
      end
      
      function onposition(self, symbol, price, quantity)
          % append to cell array or override; 
          % use cell array as dictionary
          position = Position(symbol, price, quantity);
          if (isempty(self.positions))
              self.positions(end+1,:) = {bar.fullSymbol, position};
          else
              %idx = find([self.positions{:,1}] == symbol);
			  idx = find(strcmp(self.positions(:,1), symbol) == 1);
              if isempty(idx)
                  self.positions(end+1,:) = {bar.fullSymbol, position};
              else
                  disp(['Position ' symbol ' already exists']);
              end
          end
      end
      
      function onfill(self, fillEvent)
          self.cash = self.cash - (fillEvent.fillSize * fillEvent.fillPrice + fillEvent.commission);
          
          if (isempty(self.positions))
              self.positions(end+1,:) = {fillEvent.fullSymbol, fillEvent.toposition()};
          else
              %idx = find([self.positions{:,1}] == symbol);
			  idx = find(strcmp(self.positions(:,1), fillEvent.fullSymbol) == 1);
              if isempty(idx)
                  self.positions(end+1,:) = {fillEvent.fullSymbol, fillEvent.toposition()};
              else
                  self.positions{idx,2}.onfill(fillEvent);
              end
          end          
      end
      
      function marktomarket(self, currentTime, symbol, lastPrice)
          if (~isempty(self.positions))
              %idx = find([self.positions{:,1}] == symbol);
			  idx = find(strcmp(self.positions(:,1), symbol) == 1);
              if ~isempty(idx)
                  self.positions{idx,2}.marktomarket(lastPrice);
              end
          end    
      end
      
   end
end