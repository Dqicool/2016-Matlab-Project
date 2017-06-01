function [vx, vy] = PosCheck(vx, vy, X, Y, r0, m)
    sizee   = 41;
    for ii0 = 1:sizee
        for jj0 = 1:sizee
            M   = 0; %黏在一起整体的质量
            px  = 0; %zongdongliang
            py  = 0;
            rr = (X - X(ii0,jj0)).^2 + (Y - Y(ii0,jj0)).^2;
            nian = find((rr < 2*r0^2)); % 找到重叠的角标
            if length(nian) > 1
                for kk = 1:length(nian)
                    M   = m(nian(kk)) + M;
                    px  = m(nian(kk)) .* vx(nian(kk)) + px;
                    py  = m(nian(kk)) .* vy(nian(kk)) + py;
                end
                vxnian = px ./ M;
                vynian = py ./ M;
                for ll = 1:length(nian)
                    vx(nian(ll)) = vxnian;
                    vy(nian(ll)) = vynian;
                end
            end
        end
    end
end