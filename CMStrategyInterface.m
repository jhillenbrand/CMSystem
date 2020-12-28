% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DEPENDENCY
% @DATE: 28.12.2020
classdef CMStrategyInterface < handle
    %CMSYSTEMINTERFACE
    
    methods (Abstract)
        execute(obj, cmSystem);
    end
end

