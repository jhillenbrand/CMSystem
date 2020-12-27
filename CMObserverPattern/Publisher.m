% AUTHOR: jonas.hillenbrand@kit.edu
% VERSION: v1.0
% DEPENDENCY:
classdef Publisher < handle
    %PUBLISHER See also https://refactoring.guru/design-patterns/observer
    
    properties
        id = '';
        name = '';
        subscribers = [];
        state = 'UNKNOWN';
    end
    
    properties (Access = private)
        subscriberCount = 0;
    end
    
    %% CONSTRUCTOR METHODS
    methods
        %% - Publisher Constructor
        function obj = Publisher(name)
            if nargin < 1
                name = 'Publisher-1';
            end
            obj.name = name;
            obj.id = string(java.util.UUID.randomUUID());
        end       
        
        function subscribe(obj, subscriber)
            obj.subscriberCount = obj.subscriberCount + 1;
            obj.subscribers(obj.subscriberCount, 1) = subscriber;
        end
        
        function unsubscribe(obj, subscriber)
            for s = 1 : length(obj.subscribers)
                if strcmp(subscriber.id, obj.subscribers(s, 1).id)
                    obj.subscribers(s, 1) = [];
                    obj.subscriberCount = obj.subscriberCount - 1;
                    break;
                end
            end
        end
    end
    %% PUBLISHING METHODS
    methods
        function notifySubscribers(obj)
            for s = 1 : length(obj.subscribers)
                obj.subscribers(s, 1).update(obj);
            end
        end
    end
    %% LOGIC
    methods
        function setState(obj, state)
            if ~strcmp(state, obj.state)
                obj.state = state;
                obj.notifySubscribers();
            end
        end
    end
end

