classdef OrderStatus < int32
   enumeration
      NONE (-1)
      NEWBORN (0)
      PENDING_SUBMIT (1)
      PENDING_CANCEL (2)
      SUBMITTED (3)
      ACKNOWLEDGED (4)
      CANCELED (5)
      FILLED (6)
      PARTIALLY_FILLED (8)
   end
end