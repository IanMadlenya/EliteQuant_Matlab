classdef OrderManager < handle
   properties
      internalOrderID
      orderDict
   end
   methods (Access = public)
      function self = OrderManager()
          self.internalOrderID = 0;
          self.orderDict = {};
      end
      
      function placeoder(self, o)
          if (o.internalOrderID < 0)    % internal_order_id not yet assigned
              o.internalOrderID = self.internalOrderID;
              self.internalOrderID = self.internalOrderID + 1;
              
              % append to cell array or override; 
              % use cell array as dictionary
              if isempty(self.orderDict)
                  self.orderDict(end+1,:) = {o.internalOrderID, o};
              else
                  idx = find([self.orderDict{:,1}] == o.internalOrderID);  % assuming id is integer
                  if isempty(idx)
                      self.orderDict(end+1,:) = {o.internalOrderID, o};
                  else
                      self.orderDict{idx,2} = o;
                  end
              end
          end
          
      end
   end
end