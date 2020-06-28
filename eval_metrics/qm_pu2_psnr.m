function Q = qm_pu2_psnr( I1, I2 )
% PSNR using perceptually uniform space 
%
% Q = qm_pu2_psnr( I1, I2 )
%
% I1, I2 - two HDR images. They must contain absolute luminance values.
%
% This metric is meant to be used with display-referred images - the
% image values much correspond to the luminance emitted from the target 
% HDR display.
%
% The details on the metric can be found in:
%
% Aydın, T. O., Mantiuk, R., & Seidel, H.-P. (2008). Extending quality
% metrics to full luminance range images. Proceedings of SPIE (p. 68060B–10). 
% SPIE. doi:10.1117/12.765095
%
% Copyright (c) 2014, Rafal Mantiuk <mantiuk@gmail.com>

p_peak = pu2_encode(4000);

P1 = pu2_encode(get_luminance(I1));
P2 = pu2_encode(get_luminance(I2));

MSE = sum((P1(:)-P2(:)).^2)./numel(P1);
Q = 20 * log10( p_peak / sqrt(MSE) );

end

function Y = get_luminance( img )
% Return 2D matrix of luminance values for 3D matrix with an RGB image

dims = find(size(img)>1,1,'last');

if( dims == 3 )
    Y = img(:,:,1) * 0.212656 + img(:,:,2) * 0.715158 + img(:,:,3) * 0.072186;
elseif( dims == 1 || dims == 2 )
    Y = img;
else
    error( 'get_luminance: wrong matrix dimension' );
end

end
