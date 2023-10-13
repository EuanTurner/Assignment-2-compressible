-- Date: 2023-10-13
-- Author: Euan Turner

-- Specified ramp coordinates
Ax = 0.0
Ay = 0.541
Bx = 0.988
By = 0.386
Cx = 2.170
Cy = 0.057

Dx = 2.5 --free parameter (can be chosen)

a = Vector3:new{x=Ax, y=0.0}
b = Vector3:new{x=Bx, y=0.0}
c = Vector3:new{x=Cx, y=0.0}
d = Vector3:new{x=Dx, y=0.0}

e = Vector3:new{x=Ax, y=Ay}
f = Vector3:new{x=Bx, y=By}
g = Vector3:new{x=Cx, y=Cy}
h = Vector3:new{x=Dx, y=Cy} -- const height

-- First block
ab = Line:new{p0=a, p1=b}
ae = Line:new{p0=a, p1=e}
ef = Line:new{p0=e, p1=f}
bf = Line:new{p0=b, p1=f}

--second block (repeat for west i.e., bf)
fg = Line:new{p0=f, p1=g}
bc = Line:new{p0=b, p1=c}
cg = Line:new{p0=c, p1=g}

--third block (repeat for west i.e., cg)
gh = Line:new{p0=g, p1=h}
cd = Line:new{p0=c, p1=d}
dh = Line:new{p0=d, p1=h}

patch = {}
patch[0] = CoonsPatch:new{
    north = ef, east = bf,
    south = ab, west = ae
}
patch[1] = CoonsPatch:new{
    north = fg, east = cg,
    south = bc, west = bf
}
patch[2] = CoonsPatch:new{
    north = gh, east = dh,
    south = cd, west = cg
}

grid={}
grid[0] = StructuredGrid:new{psurface=patch[0], niv=21, njv=11}
grid[1] = StructuredGrid:new{psurface=patch[1], niv=21, njv=11}
grid[2] = StructuredGrid:new{psurface=patch[2], niv=21, njv=11}
for ib = 0, 2 do
    fileName = string.format("block-%d.vtk", ib)
    grid[ib]:write_to_vtk_file(fileName)
 end
