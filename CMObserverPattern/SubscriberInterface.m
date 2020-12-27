% AUTHOR: jonas.hillenbrand@kit.edu
% VERSION: v1.0
% DEPENDENCY:
classdef SubscriberInterface < handle
    properties
        id
        name
    end
    methods (Abstract)
        update(obj, publisher)
    end
end