classdef OrderType < int32
   enumeration
      MARKET (0)
      LIMIT  (2)
      STOP  (5)
      STOP_LIMIT (6)
      TRAIING_STOP (7)
   end
end