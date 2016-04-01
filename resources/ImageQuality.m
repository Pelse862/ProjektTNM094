function QualityValue = ImageQuality( originalImage, mosaicImage)
% Calculate the S-CIELab-value
% originalImage is the input image
% mosaic is the result image

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