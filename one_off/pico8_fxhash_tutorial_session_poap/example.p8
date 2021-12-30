pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

-- playing with seeds for debug
s=rnd(-1)\1
srand(s)

-- setup starts here
_set_fps(60)
cls()  -- clear the screen
num_circles = flr(rnd(4)+1)

srand(s)

-- single pixel dither approach
function pix_dither(x,y,r,c)
	pset(
	x-1+rnd(2),
	y-1+rnd(2),
	c
	)
end

-- cicle based dither
function circ_dither(x,y,r,c)
	circ(
	x-1+rnd(2),
	y-1+rnd(2),
	r,
	c)
end

-- rectangle based dither
function sqr_dither(x,y,r,c)
	rect(
	x-r+rnd({-1,1}),
	y-r+rnd({-1,1}),
	x+r+rnd({-1,1}),
	y+r+rnd({-1,1}),
	c)
end

-- character based dither
function p8scii_dither(x,y,r,c)
 print(
  "\^p"..chr(rnd(240)\1+16),
  x-1+rnd(2)-5,
	 y-1+rnd(2)-4,
	 c
	)
end

-- select which dither to use
dither = rnd({
 pix_dither,
 circ_dither,
 sqr_dither,
 p8scii_dither
})

-- change the palette
pal({
 1,-14,-11,13,
 -3,2,-2,-7,
 7,6,12,-4,
 1,-15,0
},1)

-- how many times to dither
dither_loops = rnd(4901)+100

::😐:: -- draw loop start

-- draw some circles
for i=0,num_circles do
	local r=rnd(16)
	local x=rnd(40)+40
	local y=rnd(40)+40
 circ(x,y,r,rnd({13,14,15}))
end

-- call the dither function
for i=0,dither_loops do
	local x=rnd(128)
	local y=rnd(128)
	local c=max(pget(x,y)-1,0)
	dither(x,y,1,c)
end

-- do a seed loop
if(rnd()>.9)srand(s)

-- debug print seed
--?s,0,0,7

-- force draw to screen
flip()

goto 😐 -- draw loop end

