classdef StrategyBase < handle
   properties
      symbols
      eventsEngine
      name
      author
      initialized
   end
   methods (Access = public)
      function self = StrategyBase(symbols)
          self.symbols = symbols;
      end
      
      function onstart(self)
          self.initialized = true;
      end
      
      function onstop(self)
          self.initialized = false;
      end
      
      function ontick(self, tickEvent)
      end
      
      function onbar(self, barEvent)
      end
      
      function onorder(self, orderEvent)
      end
      
      function oncancel(self, cancelEvent)
      end
      
      function onfill(self, fillEvent)
      end
      
      function placeorder(self, orderEvent)
          self.eventsEngine.push(orderEvent);
      end
      
      function cancelorder(self, orderID)
      end
      
      function seteventsengine(self, eventsEngine)
          self.eventsEngine = eventsEngine;
      end
   end
end