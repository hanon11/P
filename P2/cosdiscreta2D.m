function [x,y,z] = cosdiscreta2D(Nx,Ny, Fsx, Fsy, A, Fx, Fy, Fase)
    fx = Fx/Fsx;
    nx = 0:Nx-1;
    fy = Fy/Fsy;
    ny = 0:Ny-1;
    x = nx * 1/Fsx;
    y = ny * 1/Fsy;
    [nX,nY] = meshgrid(nx,ny);
    wx = 2 * pi * fx;
    wy = 2 * pi * fy;
    z = A * cos (wx * nX + wy * nY + Fase);
end