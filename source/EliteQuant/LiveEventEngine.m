classdef LiveEventEngine < handle   
    properties (SetAccess = public)
        active
        queue
        period
        eventTimer
    end
    events
        eTick
        eBar
        eOrder
        eFill
        eCancel
        eAccount
        ePosition
        eTimer
        eGeneral
    end
    
    methods
        function self = LiveEventEngine()
            self.active = true;
            self.queue = SimpleQueue();
            self.period = 1;
            self.eventTimer = timer('ExecutionMode','FixedRate',...
                'Period', self.period, 'TimerFcn',@(~,~) run(self));
        end
        
        function run(self)                      
            event = self.queue.pop();
            if (~isempty(event)) % call event listener
                switch event.eventType
                    case EventType.TICK
                        notify(self,'eTick',event);
                    case EventType.BAR
                        notify(self,'eBar',event);
                    case EventType.ORDER
                        notify(self,'eOrder',event);
                    case EventType.FILL
                        notify(self,'eFill',event);
                    case EventType.CANCEL
                        notify(self,'eCancel',event);
                    case EventType.ACCOUNT
                        notify(self,'eAccount',event);
                    case EventType.POSITION
                        notify(self,'ePosition',event);
                    case EventType.TIMER
                        notify(self,'eTimer',event);
                    case EventType.GENERAL
                        notify(self,'eGeneral',event);
                end
            end
        end
        
        function start(self)
            disp('Live trading event engine started');
            self.queue.reset();
            self.active = true;
            start(self.eventTimer);
        end
        
        function stop(self)
            disp('Live trading event engine stopped');
            self.active = false;
            stop(self.eventTimer);
        end
        
        function delete(self)
            disp('Live trading event engine deleted');
            self.active = false;
            delete(self.eventTimer);
        end
        
        function push(self, event)
            self.queue.push(event);
        end
    end
end