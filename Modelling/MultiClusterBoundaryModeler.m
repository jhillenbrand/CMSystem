classdef MultiClusterBoundaryModeler < Modeler
    %MultiClusterBoundaryModeler
        
    properties
        boundaryClusterers = {};
    end
    
    methods
        function obj = MultiClusterBoundaryModeler()
            obj@Modeler();
        end
    end
    
    %% Interface Methods
    methods
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            
             if iscell(data)
                if ~isempty(data)
                    % iterate all mse fields speed/Segmentation                   
                    for i = 1 : size(data, 1)
                        for j = 1 : size(data, 2)
                            clusterer = [];
                            try 
                                clusterer = obj.boundaryClusterers{i, j};
                            catch e
                                warning([e.message newline 'attempted to access boundaryClusterer out of bounds (in ' obj.name ')'])
                            end
                            if isempty(clusterer)
                                clusterer = obj.createClusterer();
                            end                                
                            clusterer.processNewData(data{i, j});
                            obj.boundaryClusterers{i, j} = clusterer;                                
                        end
                    end
                    % return the whole clusterBoundaryTrackingObj for connected
                    %   observers, logic is contained in connected observers
                    newData = obj.boundaryClusterers;
                else
                    warning(['data was empty in ' obj.name])
                end
            else
               error(['data[' class(data) '] must be of type cell']) 
            end
        end
    end
    
    %% Private Helper Methods
    methods (Access = private)
        function clusterer = createClusterer(obj)
            clusterer = SimpleBoundaryClusterer();
            clusterer.normalizer = Normalizer('none');
            clusterer.hyperparameters.MinSizeDataPoints = 25;
            clusterer.hyperparameters.NormalizeDataPoints = false;                       
        end
    end
end

