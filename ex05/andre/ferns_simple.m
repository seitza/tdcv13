classdef ferns_simple < handle
    
    properties
        classifier
        samples
        class2point %XY
    end %properties
    
    methods
        function F = ferns_simple(number, depth, classes)
            F.classifier = zeros(number,2^depth,classes);
            F.samples = rand(number,depth,2);
        end %constructor
        
        function train_one(F,class,patch)
            for n = 1:size(F.classifier,1)
                dep = 0;
                for d = 1:size(F.samples,2)
                    p1 = patch(round(F.samples(n,d,1)*(numel(patch)-1))+1);
                    p2 = patch(round(F.samples(n,d,2)*(numel(patch)-1))+1);
                    if p1 <= p2
                        dep = dep+2^(d-1);
                    end
                end
                F.classifier(n,dep+1,class) = F.classifier(n,dep+1,class)+1;
            end
        end %train one
        
        function [point,prob] = recognize(F,patch)
            decision = ones(1,size(F.classifier,3));
            for n = 1:size(F.classifier,1)
                dep = 0;
                for d = 1:size(F.samples,2)
                    p1 = patch(round(F.samples(n,d,1)*(numel(patch)-1))+1);
                    p2 = patch(round(F.samples(n,d,2)*(numel(patch)-1))+1);
                    if p1 <= p2
                        dep = dep+2^(d-1);
                    end
                end
                decision = decision.*reshape(F.classifier(n,dep+1,:),1,size(F.classifier,3));
            end
            [prob,class] = max(decision(:));
            %disp(class)
            if prob == 0
                point = [-1,-1];
            else
                point = F.class2point(class,:);%XY
            end
        end %recognize
        
        function train_many(F,im, stable_points, patchsize, train_iter)
            %DEBUG
            %figure;
            
            %set stable point coordinate as "class properties"
            F.class2point = stable_points; %XY
            
            half = floor(patchsize/2);
            for i = 1:train_iter
                %DEBUG
                disp(['ITERATION ',num2str(i),' of ',num2str(train_iter)]);
                
                %generate random transformation matrix
                random = rand(4,1);
                random = random.*[360;360;0.9;0.9]+[0;0;0.6;0.6];
                H = gen_transform(random(1),random(2),random(3),random(4));
                %warp image
                tform = affine2d(H);
                T = imwarp(im,tform,'FillValues',-1);
                [xlim,ylim] = outputLimits(tform, [0 size(im,2)-1],[0 size(im,1)-1]);
                %fill outer area with noise
                T = padarray(T,[half, half], -1);
                N = imnoise(zeros(size(T)),'gaussian')*2*255;
                T(T(:)==-1) = N(T(:)==-1);
                
                %disp(['size of transformed T -> ', num2str(size(T,1)),' ' num2str(size(T,2))]);
                %DEBUG
                %imagesc(T);
                %drawnow();
                
                for c = 1:size(stable_points,1)
                    
                    %calculate right point
                    p = stable_points(c,:); %XY
                    [ptx pty] = transformPointsForward(tform,p(1),p(2));%XY
                    ptc = round([ptx;pty]-[xlim(1);ylim(1)]); %XY
                    
                    %get patch
                    %disp(['patch x dim -> ',num2str(ptc(1)-half+half),' ',num2str(ptc(1)+half+half),' y -> ',num2str(ptc(2)-half+half),' ',num2str(ptc(2)+half+half)]);
                    if ptc(2)-half+half > 0 & ptc(2)+half+half < size(T,1) & ptc(1)-half+half > 0 & ptc(1)+half+half < size(T,2)
                        patch = T(ptc(2)-half+half:ptc(2)+half+half,ptc(1)-half+half:ptc(1)+half+half);
                    else
                        %DEBUG
                        disp(['ERROR skipped ptc xy',num2str(ptc(1)),' ',num2str(ptc(2))]);
                        continue
                    end
                    %DEBUG
                    %imagesc(patch);
                    %drawnow();
                    
                    %finally rain the fern with the patch
                    F.train_one(c,patch);
                end % training iteratins for every patch
            end %stable points
        end %train many
        
        function normalize(F)
            %sum every class in every fern over all histograms
            normsum = sum(F.classifier,2);
            for n = 1:size(F.classifier,1)
                for h = 1:size(F.classifier,3)
                    for d = 1:size(F.classifier,2)
                        F.classifier(n,d,h) = F.classifier(n,d,h)/normsum(n,1,h);
                    end
                end
            end
        end
        
        function saveFile(F,filename)
            save(filename,'F');
            
        end %save
        
    end %methods
    
    methods(Static)
        function F = loadFile(filename)
            F = load(filename);
        end %load
    end %static methods
    
end %classdef

