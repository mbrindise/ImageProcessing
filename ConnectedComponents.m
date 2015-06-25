%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            PURDUE UNIVERSITY
%                               AETHER LAB
%                  Code Created By:  Melissa Brindise
%                  Code Created On:  November 1, 2015
%
%   ------------------------- CODE INFORMATION-----------------------------
%   TITLE:  ConnectedComponents.m
%
%   PURPOSE:  Given a pix location and threshold, finds all pixels that
%   within a 4-point neighborhood that are within threshold.  Threshold is
%   evaluated between neighboring pixels at all times.  For more
%   information on Connected Components refer to:
%   https://engineering.purdue.edu/~bouman/ece637/notes/pdf/ConnectComp.pdf
%
%   ---------------------------- INPUTS -----------------------------------
%   im : The image being evaluated (should be a double)
%   T : The threshold in pixel intensity (0-255)
%   pixX: The row of the pixel to build the Connected Components off of
%   pixY: The column of the pixel to build the Connected Components off of
%   mask : Binary mask that indicates regions to check for connected 
%          components (1 indicates regions to check, 0 indicates regions 
%          not to check)
%
%   ---------------------------- OUTPUTS ----------------------------------
%   neighborIm : Binary image of the same size as the input image im that 
%                contains 1's for the original pixel and all connected
%                pixels and 0's for all unconnected pixels
%
%   -----------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [neighborIm] = ConnectedComponents(im,T,pixX,pixY,mask)

% CONNECTED COMPONENTS SETUP
[hgt,wdt] = size(im);
neighborIm = zeros(hgt,wdt);
pix2chk = zeros(1000,2);    % Matrix contains (x,y) data of neighboring 
                            % pixels that a connected pixel whose neighbors
                            % must be checked

% Remove the masked regions by setting the masked pixels to "checked"
mask = uint8(mask);
appmask = imcomplement(mask);
neighborIm = neighborIm + double(appmask);

% Set initial pixel to "Connected" and add neighboring pixels to pix2chk
neighborIm(pixX,pixY) = 255;
pix2chk(1,1) = pixX-1;
pix2chk(1,2) = pixY;
pix2chk(2,1) = pixX+1;
pix2chk(2,2) = pixY;
pix2chk(3,1) = pixX;
pix2chk(3,2) = pixY-1;
pix2chk(4,1) = pixX;
pix2chk(4,2) = pixY+1;

% INITIALIZE COUNTERS
% Function stops when all neighboring pixels have been checked, i.e. when
% number of pixels to check = number of pixels checked.  To keep pix2chk
% matrix from extending too largely, this code uses and index which
% indicates number of pixels to check, the while loop counter i, which
% indicates number of pixels checked, a count1 which indicates how many
% times the index variable has been reset (index is reset to 0 once it 
% reaches 1000) and count2 which indicates how many times the i variable
% has been reset

num2chk = 4;  % OBSOLETE VARIABLE
index = 4;
i = 1;
count1 = 0;
count2 = 0;

% RUN CONNECTED COMPONENTS

while (index ~= i) || (count1 ~= count2)
    w = 0;
    currpix = [pix2chk(i,1),pix2chk(i,2)]; % Get current pixel being checked
    pixVal = im(currpix(1),currpix(2)); % Get pixel intensity of current pixel
    if (currpix(1)-1) > 0   % Check if pixel above is in image range
        if neighborIm(currpix(1)-1,currpix(2)) == 0  % Check that pix above hasn't been checked
            if abs(im(currpix(1)-1,currpix(2)) - pixVal) <= T  % Check if pix above is connected
                neighborIm(currpix(1)-1,currpix(2)) = 255; % Set pixel to connected on output image
                pix2chk(index,1) = currpix(1)-1;  % Add pixel to pix2chk matrix
                pix2chk(index,2) = currpix(2);    %
                w = w+1;
                index = index+1;  % Increment index indicating another pixel must be checked
                if index == 1001  % Due to size of pix2chk, reset index once it hits 1000
                    index = index-1000;
                    count1 = count1 + 1;
                end
            end
        end
    end
    if (currpix(1)+1) <= hgt  % Check if pixel below is in image range
        if neighborIm(currpix(1)+1,currpix(2)) == 0  % Check that pix below hasn't been checked
            if abs(im(currpix(1)+1,currpix(2)) - pixVal) <= T  % Check if pix below is connected
                neighborIm(currpix(1)+1,currpix(2)) = 255;
                pix2chk(index,1) = currpix(1)+1;
                pix2chk(index,2) = currpix(2);
                w = w+1;
                index = index + 1;
                if index == 1001  % Due to size of pix2chk, reset index once it hits 1000
                    index = index-1000;
                    count1 = count1 + 1;
                end
            end
        end
    end
    if (currpix(2)-1) > 0   % Check if pixel to left is in image range
        if neighborIm(currpix(1),currpix(2)-1) == 0 % Check that pix to left hasn't been checked
            if abs(im(currpix(1),currpix(2)-1) - pixVal) <= T % Check if pix to left is connected
                neighborIm(currpix(1),currpix(2)-1) = 255;
                pix2chk(index,1) = currpix(1);
                pix2chk(index,2) = currpix(2)-1;
                w = w+1;
                index = index+1;
                if index == 1001  % Due to size of pix2chk, reset index once it hits 1000
                    index = index-1000;
                    count1 = count1 + 1;
                end
            end
        end
    end
    if (currpix(2)+1) <= wdt   % Check if pixel to right is in image range
        if neighborIm(currpix(1),currpix(2)+1) == 0 % Check that pix to right hasn't been checked
            if abs(im(currpix(1),currpix(2)+1) - pixVal) <= T % Check if pix to right is connected
                neighborIm(currpix(1),currpix(2)+1) = 255;
                pix2chk(index,1) = currpix(1);
                pix2chk(index,2) = currpix(2)+1;
                w = w+1;
                index = index+1;
                if index == 1001  % Due to size of pix2chk, reset index once it hits 1000
                    index = index-1000;
                    count1 = count1 + 1;
                end
            end
        end
    end
    num2chk = num2chk+w;
    i = i+1;  % Increment i indicating another pixel has been checked
    if i == 1001 % If i reached 1000, reset to 0 and increment count
        i = i-1000;
        count2 = count2 + 1;
    end
    %fprintf('\ni = %f  index = %f count1= %f  count2= %f',i,index,count1,count2)
end

neighborIm = neighborIm - double(appmask); % remove masked regions from connected region
%fprintf('\n\n')

end

        
        
        