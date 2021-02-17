% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DEPENDENCY SignalAnalysis.m
% @DATE 30.12.2020
classdef FixedWindowSegmenter < Segmenter
    %FIXEDWINDOWSEGMENTER creates fixed sized windows based on config and
    %   input data
    
    properties
        windowSize = 0; % number of samples per window
    end
    
    methods
        function obj = FixedWindowSegmenter(windowSize)
            %FIXEDWINDOWSEGMENTER(windowSize) creates a Transformation with a fixed window size
            %   the interface method apply returns a data matrix containing
            %   the segmented windows based on
            %   SignalAnalysis.separateDataIntoWindows
            obj.windowSize = windowSize;            
            funcHandle = @(x) SignalAnalysis.separateDataIntoWindows(x, windowSize);
            trafo = SegmentationTransformation(['FixedWindowSegmentation [ws=' num2str(windowSize) ']'], funcHandle);
            obj.addTransformation(trafo);
        end        
    end
end

