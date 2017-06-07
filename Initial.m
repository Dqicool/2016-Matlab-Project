    dt      = 0.1;
    G       = 0.01;
    r0      = 0.1;
    [X,Y]   = meshgrid(-20:20);
    sizee   = max(size(X));
    m       = ones(sizee);
    m(21,21)= 13.125;%1000;
    vx      = zeros(sizee);
    %vx(15,21) =  1;
    %vx(27,21) = -1;  
    vy      = zeros(sizee);
    %vy(21,15) = -1;
    %vy(21,27) =  1;  
    rr     = X.^2 + Y.^2;
    ResMat = (rr<=225) .* (rr ~= 0);
    %   resMat = [zeros(5,sizee);zeros(sizee - 10,5),ones(sizee - 10),zeros(sizee - 10,5);zeros(5,sizee)];
    %for kkk = 1:sizee^2
     %   if rr(kkk) ~= 0
      %      omega = 1.005 * (G .* m(21,21) ./ rr(kkk).^(3/2)).^(1/2);
       %     vy(kkk) = omega .* X(kkk);
        %    vx(kkk) = omega .* -Y(kkk);
        %end
    %end
    vx = vx .* ResMat;
    vy = vy .* ResMat;