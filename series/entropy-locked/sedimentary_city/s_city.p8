pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
r=rnd
p=srand
cls()
s=r(-1)
p(s)
for i=0,15do pal(i,r(33)-17,1)end
c=1
x=-8
y=-8
clip(16,16,96,96)
for i=0,2^13do
if(c>2)p(s)
x+=10
y+=r(.1)
c+=.01
x%=136
y%=136
c%=8
ovalfill(x,y,x+r(c*2),y+r(c*2),c)
if(c>6)rectfill(x,y,x+r(c*2),y+r(c*2),c+1)
end::_::goto _
