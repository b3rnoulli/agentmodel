function movie_recorder(state, movieName, step, frames_in_single_scene)

data_length = size(state,3);
i=1;
frame_rate = 15;
scene_counter = 1;
writerObj = VideoWriter(strcat(movieName,'_part',num2str(scene_counter),'.avi'));
writerObj.FrameRate = frame_rate;
open(writerObj);
current_scene_frames=0;
while i < data_length
    h =  figure('units','normalized','outerposition',[0 0 1 1]);
    spy(state(:,:,i) == -1,'r');
    hold on
    spy(state(:,:,i) == 1, 'g');
    hold off
    frame = getframe(h);
    fprintf('recording data %d \n', i);
    writeVideo(writerObj,frame);
    close(h);
    if current_scene_frames > frames_in_single_scene
        fprintf('Closed writer for part %d \n', scene_counter);
        scene_counter = scene_counter + 1;
        close(writerObj);
        writerObj = VideoWriter(strcat(movieName,'_part',num2str(scene_counter),'.avi'));
        writerObj.FrameRate = frame_rate;
        open(writerObj);
        %save current write object adn create new scene
        current_scene_frames=0;
    end

    current_scene_frames= current_scene_frames+1;
    i = i+step;
end

close(writerObj);


end

