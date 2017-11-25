classdef (ConstructOnLoad) OrderEvent < event.EventData
   properties
      eventType
      internalOrderID
      brokerOrderID
      fullSymbol
      orderType
      orderStatus
      limitPrice
      stopPrice
      size
      fillPrice
      fillSize
   end
   methods
       function self = OrderEvent()
           self.eventType = EventType.ORDER;
           self.orderType = OrderType.MARKET;
           self.orderStatus = OrderStatus.NONE;
       end
   end
end