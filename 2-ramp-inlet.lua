-- Date: 2023-10-13
-- Author: Euan Turner

config.title = "Ramjet Inlet (non-curved)"
config.dimensions = 2
config.axisymmetric = false

-- Set gas model and flow parameters
setGasModel('ideal-air.gas')

M_inf = 6.42
p_inf = 1354 -- Pa
T_inf = 273.0 -- K (subject to change, currently placeholder)

initial = FlowState:new{p=p_inf, T=T_inf}
inflow = FlowState:new{p=p_inf, T=T_inf, velx=M_inf*initial.a, vely=0.0}

-- Specified ramp coordinates
Ax = 0.0
Ay = 0.454
Bx = 0.988
By = 0.299
Cx = 1.807
Cy = 0.045

Dx = 2 --free parameter (can be chosen)

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
grid[0] = StructuredGrid:new{psurface=patch[0], niv=21, njv=11} --21, 11 double each time
grid[1] = StructuredGrid:new{psurface=patch[1], niv=21, njv=11}
grid[2] = StructuredGrid:new{psurface=patch[2], niv=21, njv=11}

blk0 = FluidBlock:new{grid=grid[0], initialState=inflow,
                        bcList={west=InFlowBC_Supersonic:new{flowState=inflow}}    
}
blk1 = FluidBlock:new{grid=grid[1], initialState=inflow,
                        bcList={}    
} 
blk2 = FluidBlock:new{grid=grid[2], initialState=inflow,
                        bcList={east=OutFlowBC_Simple:new{}}    
} 
identifyBlockConnections() -- internal connections dealt with

-- set solver settings (preliminary)
config.max_time = 5.0e-3 -- s
config.max_step = 100000
config.cfl_value = 0.5
config.dt_init = 1.0e-6 
config.flux_calculator = "ausmdv"
config.dt_plot = config.max_time/100 --100 frames?
config.dt_history = 1.0e-5

setHistoryPoint{x=e.x, y=e.y} --at the inflow wall top left
setHistoryPoint{x=h.x, y=h.y} --at the outflow wall top
setHistoryPoint{x=g.x+(h.x - g.x)/2, y=g.y/2} -- capture the pressure inside of the throat

