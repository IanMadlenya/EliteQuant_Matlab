% https://www.mathworks.com/help/matlab/matlab_oop/class-with-custom-event-data.html
classdef (ConstructOnLoad) TickEvent < event.EventData
   properties
      eventType
      tickType
      timeStamp
      fullSymbol
      price
      size
   end
   methods
       function self = TickEvent()
           self.eventType = EventType.TICK;
           self.tickType = TickType.TRADE;
       end
   end
end