function makeGif(XX, filename)

    figure(1)
    [~,~,n3] = size(XX);
    for ii = 1:n3
          imagesc(XX(:,:,ii))
          drawnow
          frame = getframe(1);
          im = frame2im(frame);
          [imind,cm] = rgb2ind(im,256);
          if ii == 1
              imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
          else
              imwrite(imind,cm,filename,'gif','WriteMode','append');
          end
    end
end