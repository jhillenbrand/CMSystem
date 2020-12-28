classdef FixedWindowSegmenter < Segmenter
    %FIXEDWINDOWSEGMENTER 
    
    properties
        windowSize = 0;
    end
    
    methods
        function obj = FixedWindowSegmenter(windowSize)
            %FIXEDWINDOWSEGMENTER(windowSize)
            obj.windowSize = windowSize;            
            funcHandle = @(x) SignalAnalysis.separateDataIntoWindows(x, windowSize);
            transform = SegmentationTransform(funcHandle, ['FixedWindowTransform[w=' num2str(windowSize) ']']);
            obj.addTransform(transform);
        end        
    end
end

