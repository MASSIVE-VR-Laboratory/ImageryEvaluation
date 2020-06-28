subplot(1, 3, 1);
boxplot([tbl_psnr.Kov_RT, tbl_psnr.Huo_RT, tbl_psnr.HDRCNN_RT, tbl_psnr.HDREXPANDNET_RT], ...
    'Notch', 'on', 'Labels', {'kov', 'huo', 'hdrcnn', 'hdrexpandnet'})
ylabel('PSNR-RGB [dB]');

subplot(1, 3, 2);
boxplot([tbl_pussim.Kov_RT, tbl_pussim.Huo_RT, tbl_pussim.HDRCNN_RT, tbl_pussim.HDREXPANDNET_RT], ...
    'Notch', 'on', 'Labels', {'kov', 'huo', 'hdrcnn', 'hdrexpandnet'})
xlabel('HDR Prediction Techniques');
ylabel('puSSIM');

subplot(1, 3, 3);
boxplot([tbl_pupsnr.Kov_RT, tbl_pupsnr.Huo_RT, tbl_pupsnr.HDRCNN_RT, tbl_pupsnr.HDREXPANDNET_RT], ...
    'Notch', 'on', 'Labels', {'kov', 'huo', 'hdrcnn', 'hdrexpandnet'})
ylabel('puPSNR [dB]');