classdef SimpleQueue < handle   
    properties (SetAccess = public)
        capacity
        queue
    end
    
    methods
        function self = SimpleQueue(capacity)
            if nargin < 1
                self.capacity = 10000;
            else
                self.capacity = capacity;
            end
            self.queue = cell(1,0);
        end
        
        function push(self, x)
            self.queue{end+1} = x;
        end
        
        function [element] = pop(self)
            if isempty(self.queue)
                element = cell(0);
            else
                element = self.queue{1};
                self.queue = self.queue(2:end);
            end
        end
        
        function [element] = peek(self)
            if (isempty(self.queue))
                element = cell(0);
            else
                element = self.queue{1};
            end
        end
        
        function reset(self)
            self.queue = cell(0);
        end
        function [bempty] = isempty(self)
            bempty = isempty(self.queue);
        end
    end
end