classdef FixedBufferHistorian < Historian
    %FixedBufferHistorian 
    
    properties
        bufferSize = 100;
        bufferModel = 1;
    end
    
    methods
        function obj = FixedBufferHistorian(bufferSize)
            %FixedBufferHistorian Construct an instance of this class
            obj.bufferSize = bufferSize;
        end
    end
    
    %% Interface Methods
    methods
        function newData = transform(obj, data)
            obj.report(data);
            newData = obj.dataBuffer;
        end
        
        function report(obj, data)
            if isempty(obj.dataBuffer)
                obj.dataBuffer = [obj.dataBuffer; data];
            elseif size(obj.dataBuffer, 2) == size(data, 2)
                obj.dataBuffer = [obj.dataBuffer; data];
            else
                error('oops');
            end
            if size(obj.dataBuffer, 1) > obj.bufferSize
                obj.reduceSize()
            end
        end
    end
    
    %% Helper Methods
    methods
        function reduceSize(obj)
            switch (obj.bufferModel)
                
                case 1
                    % merge center
                    centerInd = ceil(obj.bufferSize / 2);
                    centerRight = centerInd + 1;
                    d1 = obj.dataBuffer(centerInd, :);
                    d2 = obj.dataBuffer(centerRight, :);
                    d = (d1 + d2) ./ 2;                    
                    obj.dataBuffer(centerRight, :) = [];
                    obj.dataBuffer(centerInd, :) = d;
                    
            end
        end
    end
end

