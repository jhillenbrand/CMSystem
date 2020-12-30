% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DEPENDENCY
% @DATE: 28.12.2020
classdef CMSystemInterface < handle
    %CMSYSTEMINTERFACE 
    
    %% Abstract Methods    
    methods (Abstract)        
        start(obj);       
    end    
end

