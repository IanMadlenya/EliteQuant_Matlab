classdef DataBoard < handle
   properties
      symbols % { symbol, timeStamp, lastPrice, lastAdjPrice }
   end
   methods (Access = public)
      function self = DataBoard()
          self.symbols = {};
      end
      
      function ontick(self, tick)
          % append to cell array or override; 
          % use cell array as dictionary
          if isempty(self.symbols)
              self.symbols(end+1,:) = {tick.fullSymbol, tick.timeStamp, tick.Price, 0};
          else
              %idx = find([self.symbols{:,1}] == tick.fullSymbol);
			  idx = find(strcmp(self.symbols(:,1), tick.fullSymbol) == 1);
              if isempty(idx)
                  self.symbols(end+1,:) = {tick.fullSymbol, tick.timeStamp, tick.Price, 0};
              else
                  self.symbols{idx,2} = tick.timeStamp;
                  self.symbols{idx, 3} = tick.Price;
              end
          end
      end
      
      function onbar(self, bar)
          % append to cell array or override; 
          % use cell array as dictionary
          if isempty(self.symbols)
              self.symbols(end+1,:) = {bar.fullSymbol, bar.barendtime(), bar.closePrice, bar.adjClosePrice};
          else
              %idx = find([self.symbols{:,1}] == bar.fullSymbol);
			  idx = find(strcmp(self.symbols(:,1), bar.fullSymbol) == 1);
              if isempty(idx)
                  self.symbols(end+1,:) = {bar.fullSymbol, bar.barendtime(), bar.closePrice, bar.adjClosePrice};
              else
                  self.symbols{idx, 2} = bar.barendtime();
                  self.symbols{idx, 3} = bar.closePrice;
                  self.symbols{idx, 4} = bar.adjClosePrice;
              end
          end
      end
      
      function [price] = getlastprice(self, symbol)
          %idx = find([self.symbols{:,1}] == symbol);
		  idx = find(strcmp(self.symbols(:,1), symbol) == 1);
          if isempty(idx)
              price = NaN;
          else
              price = self.symbols{idx, 4};
          end
      end
      
      function [timeStamp] = getlasttimestamp(self, symbol)
          %idx = find([self.symbols{:,1}] == symbol);
		  idx = find(strcmp(self.symbols(:,1), symbol) == 1);
          if isempty(idx)
              timeStamp = NaN;
          else
              timeStamp = self.symbols{idx, 2};
          end
      end
   end
end