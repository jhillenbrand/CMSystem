% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY TransformationInterface.m
classdef FFTExtractor < FeatureExtractor
    %FEATUREEXTRACTOR 
    
    properties
        sampleRate = 0;
    end
    
    %% constructor
    methods
        function obj = FFTExtractor(sampleRate)
            obj@FeatureExtractor();
            obj.sampleRate = sampleRate;
            
            funcHandle = @(x) SignalAnalysis.fftPowerSpectrum(x, obj.sampleRate);
            obj.transformations = Transformation('FFT-Trafo', funcHandle);
        end
    end
    
    %% Interface Methods
    methods
        function newData = transform(obj, data)
            
            trafo = obj.transformations(1);
            if isvector(data)
                [f, p, t] = trafo.apply(data);            
                newData = [f, p];
            elseif ismatrix(data)
                [f, p, t] = trafo.apply(data);            
                newData = [f(:, 1), p];
            else
                error(['unsupported input type ' class(data) ' of data'])
            end
            
        end
    end  
    
    %% Override methods
    methods
        function addTransformation(obj, trafo)
            % does not add any trafo, as the fft trafo is already defined
            % in constructor
            warning('only transformation allowed is built in fft, the passed Transformation will be ignored!');            
        end
    end
end

