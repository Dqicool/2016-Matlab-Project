vidObj = VideoWriter('bbb.avi');
open(vidObj);
for iii = 1:targett
    writeVideo(vidObj,ans(iii));
end
close(vidObj)
