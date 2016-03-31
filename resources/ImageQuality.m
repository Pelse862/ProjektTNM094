function QualityValue = ImageQuality( originalImage, mosaicImage)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

load('illum.mat');
load('xyz.mat');

ill = CIED65*xyz;

pixels = sqrt(1920^2 + 1080^2);
screenInch = 12;
ppi = (pixels / screenInch) / (16*16);

% Distens (inch)
D = 19.7*4;

samplePerDegree = ppi*D*tan(pi/180);

xyzIm = rgb2xyz(originalImage);
xyzNewIm = rgb2xyz(mosaicImage);


scieVal = scielab(samplePerDegree,xyzIm,xyzNewIm,ill,'xyz');

QualityValue = mean(mean(scieVal))


end