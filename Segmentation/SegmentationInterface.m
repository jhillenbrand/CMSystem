classdef SegmentationInterface < handle
    %SEGMENTATIONINTERFACE
    methods (Abstract)
        newData = segment(obj, data) 
    end
end

