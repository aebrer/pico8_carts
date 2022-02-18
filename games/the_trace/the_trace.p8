pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- init

-- todo
-- - item that lets you stack up vfx on the title page
-- - when dc chance to teleport to a set of dead god pages
-- - a page that can occur that is just a full screen vfx
--   and you can press any button to leave it
-- - put some mirror ideocartography somewhere
-- - add a credits page somewhere
--     and remember to thank your beta testers!
-- - new logo like burning gate

----
-- sounds todo
----
-- sound for flipping options
-- should be like a digital drop of blood
--

--!!
debug_mode=false
--!!

lib={} -- library of all pages: title,page
inventory={} -- player inventory
inv_chs={}
cursed=false
curr_page=nil -- current page
prev_page=nil -- previous page
bkmk=nil -- bookmark a page
debug={}  -- list of things to print for debug
pressed=nil -- if a button was pressed
pc=0  -- timer for button press
butt_pos={}
butt_pos[⬆️]={60,104}
butt_pos[⬇️]={60,116}
butt_pos[⬅️]={54,110}
butt_pos[➡️]={66,110}
dt=0 -- doom timer
dtm=888
obutt_ani=0
side=0
seed_reset_needed=true

-- logos
v9_static = {}
function v9_static.init(self)
 fillp(rnd({▥,█,▤}))
 curr_page.cls=true
 self.p={1,3}
 self.g=rnd(5)-3
 self.a=-1
 self.b=self.a*2
 self.z=2
 self.w=self.z+rnd(self.p)
 self.c=rnd(14)\1+2
 for i=1,14do pal(i,flr(rnd(33)-17),1)end
 dc_pal()
end

function v9_static.draw(self,x1,y1,w,h)
	for x=self.g+x1,self.g+x1+w,self.z do for y=self.g+y1,self.g+y1+h,self.w do
 circ(x,y,rnd(2),x*y%self.c)end end
end

dg_logo = {}
function dg_logo.init(self)
 fillp(rnd({▥,█,▤}))
 curr_page.cls=false
 for i=1,14do pal(i,flr(rnd(33)-17),1)end
 dc_pal()
end

function dg_logo.draw(self,x1,y1,w,h)
 poke(0x5f54,0x60)
 palt(0,false)
 if(rnd()>.1)sspr(x1,y1,w,h,x1+2,y1+2,w-4,h-4)
 for i=0,10 do 
  circ(rnd(128),rnd(128),rnd(64)+64,rnd(8))
  sspr(0,rnd(128),128,rnd(5),rnd(128),0,rnd(5),128)
  sspr(rnd(128),0,rnd(5),128,0,rnd(128),128,rnd(5))
 end
 poke(0x5f54,0x00)
 palt(0,true)
end


function _init() 
	music_start(true)
 cls()
 -- set current page to landing page
	curr_page=lib[title]
 if(debug_mode)curr_page=lib[p_debug]music_stop()
 bkmk=curr_page
end
-->8
-- update
function _update60()
-- srand(rnd(-1))
 if(curr_page.cls)cls()
 -- do the init for all pages
 if not curr_page.i then 
  curr_page.dc=dc()
 	if curr_page.dc then
  	pal(15,-8,1)
   music_state("dead god")
   if dc() then
    curr_page.logo=dg_logo
    if dc() then
     cls()
     glitch()
     curr_page.choices[rnd({⬆️,⬇️,➡️,⬅️})]=ch_breach
    end
 	 end
  else
 		pal(15,7,1)
   curr_page:music_reset()
		end
 	srand(curr_page.seed)
 	curr_page.logo:init()
 	curr_page.i=true
 end
 if lib[title].seed%17==0 then
  cursed=true
 else
  cursed=false
 end

 if(inventory["cursed"])srand(curr_page.seed)

 -- do callbacks for curr_page
 if(curr_page.cb)curr_page:cb()
 if(bkmk and bkmk.cb)bkmk:cb()
  
 -- check inputs for choices
 for b in all({⬆️,⬇️,⬅️,➡️}) do
	 if btnp(b) then
	  pressed=b
	  
   if side%2==0 then -- choices

    if curr_page.choices[b] then
 				-- callback for this choice 
     if(curr_page.choices[b].cb)curr_page.choices[b]:cb()
     -- callback for any choice
     if(curr_page.leave_cb)curr_page:leave_cb()
 		  if curr_page.choices[b].page then
 		  	sfx(16, 3) -- select option sound
      local target=curr_page.choices[b].page
      curr_page:on_leave()
 		  	prev_page=curr_page
 		  	curr_page=target
 		  	curr_page.i=false

 		  end
 	  end

   else  -- inventory
    if inv_chs[b] then
     inv_chs[b]:cb()
     if(curr_page.leave_cb)curr_page:leave_cb()
     if inv_chs[b].page then
      sfx(16, 3) -- select option sound
      local target=inv_chs[b].page
      curr_page:on_leave()
      prev_page=curr_page
      curr_page=target
      curr_page.i=false
     end
    end
    if (not (inv_chs[⬆️] or inv_chs[⬇️] or inv_chs[⬅️] or inv_chs[➡️])) then
     goto_prev_page()
    end
   end
  end
 end
 
 -- set bookmark
 if (bkmk and btnp(❎)) then 
  if curr_page==bkmk then 
   sfx(39, 3) -- remove bookmark sound
   bkmk=nil
  else
   sfx(40, 3) -- goto bookmark sound
   if(curr_page.leave_cb)curr_page:leave_cb()
   curr_page:on_leave()
   prev_page=curr_page
   curr_page=bkmk
   curr_page.i=false
  end
  
 elseif btnp(❎) then
  sfx(38, 3) -- place bookmark sound
  bkmk=curr_page
 end

 if btnp(🅾️) then
  sfx(41+obutt_ani%8,3)
  obutt_ani+=1
  if(obutt_ani%8==0)side+=1cls()
  doom_plus()
 end
end

function goto_prev_page()
 if prev_page then
  curr_page:on_leave()
  old_page=curr_page
  curr_page=prev_page
  curr_page.i=false
  prev_page=old_page
  if(curr_page.leave_cb)curr_page:leave_cb()
 end
end

function doom_plus()
 dt+=1
end

function dc()
 return rnd(dt/rnd(dtm))>1
end

function dc_pal()
 if(curr_page.dc)for i=1,14do pal(i,rnd({8,-16,-15,-14,-11,2,-8,-8}),1)end
end

-->8
-- classes

function new_page(title,text)
	local page = {}
	page.title = title
	page.seed = get_seed(page.title)
	page.text = text
	page.logo = v9_static
 page.cls=true
	page.cb = nil
 page.leave_cb = nil
 page.dc=false
 page.on_leave = function(pg)
  page.i=false
  obutt_ani=0
  side=0
  doom_plus()
 end
	page.choices = {}
 page.music=""
 page.music_reset = function(pg)
  music_state(pg.music)
 end
	
	-- method assignments
	page.dis_title = dis_title
	page.dis_text = dis_text
	page.dis_logo = dis_logo
	page.dis_choices = dis_choices
	
	-- finish
	lib[title]=page
	return page
end

function new_choice(title,page,cb)
 local choice = {}
 choice.title=title
 choice.page=page
 choice.cb=cb
 return(choice)
end
-->8
-- utils
function get_seed(w)
 s=1
 for i=1,#w do
	ch=ord(sub(w,i,i))s+=s*31+ch
	end
--	if(#w==0)s=r(-1) 
	return(s)
end

function hcenter(s,c)
  -- screen center minus the
  -- string length times the 
  -- pixels in a char's width,
  -- cut in half
  return c-#s*2
end

butt_key={[0]="⬅️","➡️","⬆️","⬇️"}
-->8
-- draw
function _draw()
 
 if(curr_page.i)curr_page:dis_logo() 
 if(curr_page.vfx)curr_page:vfx()
 if(bkmk and bkmk.vfx)bkmk:vfx() 
 if(bkmk)spr(2,120,0)
 if(curr_page==bkmk)spr(1,120,0)
 if(cursed)glitch()tear(lib[title])

 curr_page:dis_title()
 curr_page:dis_text()
 curr_page:dis_choices()
 
 -- debug
 for i=1,#debug do
  ?"\^#"..tostr(debug[i]),0,0+8*i,15
 end
end

function dis_title(page)
	?"\^#"..page.title,0,0,15
 -- ?"🐱: "..dt,0,123,15
end

function dis_logo(page)
 clip(0,8,128,32)
 page.logo:draw(0,8,128,32)
 clip()
end

function dis_text(page)
 if(page.text)?"\^#"..page.text,0,48,15
end

function butt_press()
 ?butt_key[pressed],butt_pos[pressed][1],butt_pos[pressed][2],0
 pc+=1
 if(pc>6)pc=0pressed=nil
end

function dis_choices(page)
 local c⬆️=page.choices[⬆️]
 local c⬇️=page.choices[⬇️]
 local c⬅️=page.choices[⬅️]
 local c➡️=page.choices[➡️]
	
 -- print o button
 sspr(24+obutt_ani%8*8,0,8,8,60,109,7,7)

 if side%2==0 then  -- display the options
  if c⬆️ then
   ?butt_key[⬆️],butt_pos[⬆️][1],butt_pos[⬆️][2],15
   ?"\^#"..c⬆️.title,hcenter(c⬆️.title,64),98,15
  end
  if c⬇️ then
   ?butt_key[⬇️],butt_pos[⬇️][1],butt_pos[⬇️][2],15
   ?"\^#"..c⬇️.title,hcenter(c⬇️.title,64),122,15
  end
  if c⬅️ then
   ?butt_key[⬅️],butt_pos[⬅️][1],butt_pos[⬅️][2],15
   ?"\^#"..c⬅️.title,hcenter(c⬅️.title,28),110,15
  end
  if c➡️ then
   ?butt_key[➡️],butt_pos[➡️][1],butt_pos[➡️][2],15
   ?"\^#"..c➡️.title,hcenter(c➡️.title,100),110,15
  end


  -- if there are no options, what do?
  if (not (c⬆️ or c⬇️ or c⬅️ or c➡️)) then
   chk_poc_msg="press ❎/x to use bookmark"
   ?chk_poc_msg,hcenter(chk_poc_msg,62),98,15
   chk_poc_msg="hold 🅾️/c/z to check pockets"
   ?chk_poc_msg,hcenter(chk_poc_msg,62),122,15
  end

  if page.choices[pressed] then
   butt_press()
  end

 else -- display the inventory

  if inventory["open mind"] then
   inv_chs[⬇️]=ch_look_around
   ?butt_key[⬇️],60,116,15
   ?"\^#"..inv_chs[⬇️].title,hcenter(inv_chs[⬇️].title,64),122,15
  end

  if inventory["blank card"] then
   inv_chs[➡️]=ch_read_card
   ?butt_key[➡️],66,110,15
   ?"\^#"..inv_chs[➡️].title,hcenter(inv_chs[➡️].title,100),110,15
  end

  if inv_chs[pressed] then
   butt_press()
  end

  if (not (inv_chs[⬆️] or inv_chs[⬇️] or inv_chs[⬅️] or inv_chs[➡️])) then
   chk_poc_msg="choose nothing to forget"
   ?chk_poc_msg,hcenter(chk_poc_msg,62),122,15
  end
 end
end

function glitch()
 local on=(t()*4.0)%13<0.1
 local gso=on and 0 or rnd(0x1fff)\1
 local gln=on and 0x1ffe or rnd(0x1fff-gso)\16
 for a=0x6000+gso,0x6000+gso+gln,rnd(16)\1 do
 poke(a,peek(a+2),peek(a-1)+(rnd(3)))
 end
end

function dither_noise(page)
 page.cls=false
 for i=0,400do
  pset(rnd(128),rnd(128),0)
 end
end

function tear(page)
 local x1=rnd(20)+70
 local w=rnd(15)+5
 clip(x1,0,w,128)
 page.logo:draw(x1,0,w,128)
 clip()
end

function zoom()
 poke(0x5f54,0x60)
 sspr(0,8,128,32,1,9,126,30)
 poke(0x5f54,0x00)
end

function more_art(page)
 clip(0,37,128,64)
 page.logo:draw(0,37,128,64)
 clip()
end

function newsy(page)
 for i=1,14do pal(i,rnd({7,6,7,6,5,0}),1)end
 dither_noise(page)
end

function dg_newsy(page)
 for i=1,14do pal(i,rnd({-8,8,-8,-8,2,-14,0}),1)end
 dither_noise(page)
end

-->8
-- pages

-- debug page
p_debug="debug page"
lib[p_debug]=new_page(
p_debug, 
"you're not even supposed\nto be here!!!\n\n    - albert einstein"
)
lib[p_debug].seed=42069
lib[p_debug].cb=function()
inventory["blank card"]=true
inventory["open mind"]=true
end

-- breach page
p_breach="containment_breach"
lib[p_breach]=new_page(
p_breach,
""
)
lib[p_breach].vfx=tear
lib[p_breach].logo=dg_logo
lib[p_breach].cb=function()
 inventory["cursed"]=true
 lib[p_breach].seed=rnd(-1)
end
lib[p_breach].music="dead god"


-- landing page
title="the trace gallery"
lib[title]=new_page(
title, 
"you find yourself looking at the\nstrange digital cosmology of \nthe trace, once again.\n\nyou swore you would give up.\n"
)
lib[title].seed=1
lib[title].vfx=function()sspr(18,7,11,15,110,-1,11,15)end
-- lib[title].logo=dg_logo

-- second page
tsp="the second page"
lib[tsp]=new_page(
tsp, 
"in this piece the artist\nintended to create an atmosphere\nof ominous intent.\n\nthis is your last chance to stop.\n\nexpect flashing lights."
)
--lib[tsp].vfx=dither_noise
lib[tsp].vfx=glitch

-- the open concept
toc="the open concept"
lib[toc]=new_page(
toc,
"the foyer stretches\nfar deeper than you realize\nand invites you in\n"
)
-- lib[toc].vfx=tear

-- another dead end
ade="another dead end"
lib[ade]=new_page(
ade,
"you didn't think it would\nbe that easy, did you?\n"
)
lib[ade].vfx=dither_noise

-- engineering regret
engreg="engineering regret"
lib[engreg]=new_page(
engreg,
"the artist is present\nin this work.\n\ncan't you feel it?\n"
)
lib[engreg].vfx=tear

-- read_card
read_card="what's on the card?"
lib[read_card]=new_page(
read_card,
"now you have to make a choice:\n"
)
lib[read_card].cb=function()
 if obutt_ani%8==0 and obutt_ani>0 then
  lib[read_card].choices[⬅️]=ch_a_threat
  lib[read_card].choices[⬆️]=ch_just_art
  lib[read_card].choices[➡️]=ch_news_report
  if cursed then 
   lib[read_card].choices[⬇️]=ch_dont_read
  end
 end
end


-- cursed card
p_curse="what were you thinking"
lib[p_curse]=new_page(
p_curse,
"i specifically said not to read\nthis card. did no one tell you\nhow this works? are you alone?\n\nit doesn't matter.\no.k. done! enjoy your curse."
)

-- threat card
p_threat="i know what you want"
lib[p_threat]=new_page(
p_threat,
"you think i don't know why\nyou came here? i know.\n\nyou won't find it, no matter\nhow hard you look.\n"
)


---------------------------------------
-- warning card
p_warn="hey, listen"
lib[p_warn]=new_page(
p_warn,
"you shouldn't be here.\nthis isn't a place for humans.\n\ndo you know what you're\nlooking for?\n"
)
---------------------------------------

-- warning card
p_news1="7 missing, 3 dead"
lib[p_news1]=new_page(
p_news1,
"mysteries abound today at the\ntrace gallery. after a success-\nful grand opening the second day\nquickly led to tragedy. those\nwho were present report seeing\na bright flash of red light.\n\nthe desert..."
)
lib[p_news1].vfx=newsy

p_news2="the desert"
lib[p_news2]=new_page(
p_news2,
"the desert opened its maw and\ntook what belonged to it.\nwe all dissolve eventually.\nthere will be no survivors.\nonly when you..."
)
lib[p_news2].vfx=dg_newsy

p_news3="only when you"
lib[p_news3]=new_page(
p_news3,
"only when you look at the\nevidence, it's even more strange\n\nthere is no registered owner\nfor the trace gallery.\nwhere did it come from?\nwe contacted..."
)
lib[p_news3].vfx=newsy

p_news4="we contacted"
lib[p_news4]=new_page(
p_news4,
"we contacted something out here.\nor something contacted us.\nwe never should have opened\nthat door. the light that poured\nout changed everything. it fills\nyou up. i think i need help.\ni don't feel right.\nhow did i get here?"
)
lib[p_news4].vfx=dg_newsy

p_stop_news="what the hell"
lib[p_stop_news]=new_page(
p_stop_news,
"there's something written on the\nback of the page. it says:\n'drift away until you see it'\n\nyou wonder what that means.\n\nit's in your handwriting."
)
lib[p_stop_news].vfx=dither_noise

-- art card
p_art="...it matches the walls"
lib[p_art]=new_page(
p_art
)
lib[p_art].vfx=more_art
-- lib[p_art].logo=dg_logo

-- good for you
p_g4u="good for you"
lib[p_g4u]=new_page(
p_g4u,
"maybe that was a test.\ndo you ever think that?\nbut there's no one watching.\n\nyou're alone here."
)
lib[p_g4u].music="peaceful"

-- fuck me?
fuck_me="fuck me?"
lib[fuck_me]=new_page(
fuck_me,
"fuck me? fuck me?!\nfuck you!\n\nyou're stuck here just like me.\nwe all dissolve here.\nyou're not special.\n"
)
lib[fuck_me].vfx=zoom
lib[fuck_me].music="angry"

-- choices

function no_trace()
 prev_page=nil
 -- bkmk=nil
end

ch_breach=new_choice(
 "containment_breach",
 lib[p_breach],
 function()
  d=rnd()
  bkmk=nil
  prev_page=nil
  lib[p_breach].text=lib[p_breach].text.."\ncontainment_breach "..d
  if(d>.88)containment_breach()
  doom_plus()
 end
)
lib[p_breach].choices[rnd({⬆️,⬇️,➡️,⬅️})]=ch_breach



ch_debug=new_choice(
"debug choice",
lib[p_debug]
)
lib[p_debug].choices[⬅️]=ch_debug
lib[p_debug].choices[➡️]=ch_debug
lib[p_debug].choices[⬆️]=ch_breach
lib[p_debug].choices[⬇️]=ch_debug


lib[title].choices[⬅️]=new_choice(
"go inside",
lib[tsp]
)

function seed_plus()
 sfx(17, 3) --scutter sound
 curr_page.i=false
 curr_page.seed+=1
 doom_plus() 
end

function seed_rnd()
 sfx(17, 3) --scutter sound
 curr_page.i=false
 curr_page.seed=rnd(-1)
 doom_plus()
end
lib[title].choices[➡️]=new_choice(
"drift away",
nil,
seed_plus
)

lib[tsp].choices[⬅️]=new_choice(
"go back",
lib[title]
)

lib[tsp].choices[➡️]=new_choice(
"go on",
lib[toc],
no_trace
)

ch_read_card=new_choice(
 "read card",
 lib[read_card],
 function()
  if cursed then 
   lib[read_card].choices[⬇️]=ch_dont_read
  end
 end
)

ch_dont_read=new_choice(
    "don't read",
    lib[p_curse],
    function()
    inventory["cursed"]=true
    end
   )

ch_look_around=new_choice(
"look around",
nil,
function() 
 if rnd()>0.8 then
  if not inventory["blank card"] then 
   curr_page.text = curr_page.text.."\nyou find a small blank card\nand pocket it."
   inventory["blank card"]=true
  end
 end
 if rnd()<.03 then
  if not inventory["open mind"] then
  	inventory["open mind"]=true
  	if(curr_page.text)curr_page.text=curr_page.text.."\nyou've got a pretty open mind."
 	end
 end
 seed_rnd()
end
)
lib[toc].choices[⬇️]=ch_look_around

lib[toc].choices[⬅️]=new_choice(
"go back",
lib[ade]
)
lib[toc].choices[➡️]=new_choice(
"deep breaths",
lib[engreg]
)

ch_a_threat=new_choice(
"a threat",
lib[p_threat],
function()
 for i in all({➡️,⬆️,⬇️}) do
 	lib[read_card].choices[i]=nil
 end
end
)
lib[read_card].choices[⬅️]=ch_a_threat


ch_just_art=new_choice(
"just art",
lib[p_art],
function()
 for i in all({➡️,⬅️,⬇️}) do
 	lib[read_card].choices[i]=nil
 end
end
)
lib[read_card].choices[⬆️]=ch_just_art


ch_news_report=new_choice(
"news report",
lib[p_news1],
function()
 for i in all({⬆️,⬅️,⬇️}) do
  lib[read_card].choices[i]=nil
 end
end
)
lib[read_card].choices[➡️]=ch_news_report


lib[p_news1].choices[➡️]=new_choice(
"keep reading",
lib[p_news2]
)

lib[p_news2].choices[➡️]=new_choice(
"keep reading",
lib[p_news3]
)
lib[p_news3].choices[➡️]=new_choice(
"keep reading",
lib[p_news4]
)

ch_stop_reading=new_choice(
"stop reading",
lib[p_stop_news]
)
lib[p_news1].choices[⬅️]=ch_stop_reading
lib[p_news2].choices[⬅️]=ch_stop_reading
lib[p_news3].choices[⬅️]=ch_stop_reading
lib[p_news4].choices[⬅️]=ch_stop_reading


lib[p_art].choices[⬇️]=ch_look_around
lib[p_art].choices[⬇️].text="look inside"

lib[p_threat].choices[⬆️]=new_choice(
"fuck you",
lib[fuck_me]
)

lib[p_threat].choices[⬅️]=new_choice(
"ignore it",
lib[p_g4u]
)

lib[p_g4u].choices[⬇️]=ch_look_around


-->8
-- music

function music_start(_reset)
	_reset = _reset or false
	if(_reset) music_reset()
	music(0)
end

function music_stop()
	lastmusicpat = stat(54)
	music(-1)
end

function music_resume()
	if lastmusicpat then
		music(lastmusicpat)
	else
		music_start()
	end
end

function music_reset()
	reload(0x3200, 0x3200, 0x10ff)
end

function music_state(_state)
	music_reset()
	if _state == "angry" then
		--angry
		swap_sfx(8,18)
		swap_sfx(9,19)
		swap_sfx(11,20)
		swap_sfx(13,21)
	elseif _state == "dead god" then
		--demon/dead god
		swap_sfx(8,22)
		swap_sfx(9,23)
		swap_sfx(11,24)
		swap_sfx(13,25)
		
		swap_sfx(12,26)
		swap_sfx(14,27)
		swap_sfx(15,28)
	elseif _state == "peaceful" then
		--peaceful/happy
		swap_sfx(10,34)
		swap_sfx(8,30)
		swap_sfx(9,31)
		swap_sfx(11,32)
		swap_sfx(13,33)
		
		swap_sfx(12,35)
		swap_sfx(14,36)
		swap_sfx(15,37)
	end
end

sfxaddr = 0x3200

-- the following is inspired by
-- https://www.lexaloffle.com/bbs/?tid=31326
-- credits to kittenm4ster
function swap_sfx(_a, _b)
	local _addr1 = 68 * _a
	local _addr2 = 68 * _b
	local _tmp = 0x4300
	local _len = 68
	
	memcpy(_tmp,sfxaddr+_addr1,_len)
	memcpy(sfxaddr+_addr1,sfxaddr+_addr2,_len)
	memcpy(sfxaddr+_addr2,_tmp,_len)
end





-->8
-- containment breach

function containment_breach()
 music(61)
 music_state("dead god")
 fillp(█)
 palt(0,false)
 pal()
 cls()
 camera(-64,-64)
 seed=rnd(-1)
 srand(seed)
 
 dither_modes = {
  "mixed",
  "burn_rect",
  "burn",
  "rect"
 } 
 dither_prob = 0.35
 dither_mode="burn"
 n_dither_modes = #dither_modes

 colors = {0,7,0,7,-3,2,-8,8}

 pal(colors,0)

 function draw_noise(amt)
  for i=0,amt*amt*amt do
   poke(0x6000+rnd(0x2000), peek(rnd(0x7fff)))
   poke(0x6000+rnd(0x2000),rnd(0xff))
  end
 end

 function draw_glitch(gr)
  local on=(t()*4.0)%gr<0.1
  gso=on and 0 or rnd(0x1fff)\1
  gln=on and 0x1ffe or rnd(0x1fff-gso)\16
  for a=0x6000+gso,0x6000+gso+gln,rnd(16)\1 do
   poke(a,peek(a+2),peek(a-1)+(rnd(3)))
  end
 end

 function vfx_smoothing()
  local pixel = rnd_pixel()
  c=abs(pget(pixel.x,pixel.y)-1) 
 end

 function rnd_pixel()
  local px_x = (flr(rnd(128)) + 1) - 64
  local px_y = (flr(rnd(128)) + 1) - 64
  local pixel = {
   x=px_x,
   y=px_y
  }
  return(pixel)
 end

 function dither(dm)
  if dm == "mixed" then
   while dm == "mixed" do
    dm = rnd(dither_modes)
   end
   dither(dm)
  elseif dm == "rect" then
   for i=1,6 do 
    local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
    local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
    --skip some nunber (12) pixels
    for x=128+fudge_x,0,-12 do
     for y=128+fudge_y,0,-12 do
      local pxl = rnd_pixel()
      if rnd(1) > dither_prob then
       rect(pxl.x-1,pxl.y-1,pxl.x+1,pxl.y+1,colors[0])
      end
     end
    end
   end
  elseif dm == "burn" then
   for i=1,4 do 
    local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
    local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
    --skip some nunber (12) pixels
    for x=128+fudge_x,0,-12 do
     for y=128+fudge_y,0,-12 do
      local pxl = rnd_pixel()
       c=pget(pxl.x,pxl.y)
       circ(pxl.x,pxl.y,1,burn(c))
     end
    end
   end
  elseif dm == "burn_rect" then
   for i=1,4 do 
    local fudge_x = (flr(rnd(4)) + 1) * rnd_sign()
    local fudge_y = (flr(rnd(4)) + 1) * rnd_sign()
    --skip some nunber (12) pixels
    for x=128+fudge_x,0,-12 do
     for y=128+fudge_y,0,-12 do
      local pxl = rnd_pixel()
       c=pget(pxl.x,pxl.y)
       rect(pxl.x-1,pxl.y-1,pxl.x+1,pxl.y+1,burn(c))
     end
    end
   end
  end
 end

 function burn(c)
  return abs(c-1)
 end

function rnd_sign()
 if(rnd(1)>.5)return(-1)
 return(1)
end

 function undither(loops,s)
  
  for i=-loops,1 do
   local x=rnd(128)-64
   local y=rnd(128)-64
   local c=min(abs(pget(x,y)-1),4)
   circfill(x*s,y*s,3,c)
   x=rnd(128)-64
   y=rnd(128)-64
   c=min(abs(pget(x,y)-1),colors[4])
   circ(x*s,y*s,8+rnd(3),c)
   circ(x*s,y*s,13+rnd(5),c)
   x=rnd(128)-64
   y=rnd(128)-64
   c=min(abs(pget(x,y)-1),colors[4])
   pset(x*s,y*s,c)
   -- circfill(x,y,2,c)
  end
 end

 seed_reset_needed = false

 function _update60()
  local loop_len =10
  local loop = flr(t())%loop_len == 0
  local srf = flr(t())%(loop_len/2) == 0
  local r = t()/loop_len
  local x,y=0,0

  if srf and seed_reset_needed then
   srand(seed)
   seed_reset_needed = false
  elseif not srf and not seed_reset_needed then
   seed_reset_needed = true
  end

  for i=0,20 do
   x=sin(r+i)*(20+(i*rnd(3)+1))
   y=(cos(r+i)*sin(r+i))*(20+(i*rnd(3)+1))
   
   pset(x*flr(rnd(3)+1),y,8)
   pset(-x*flr(rnd(3)+1),y,8)
   pset(x*flr(rnd(3)+1),-y,8)
   pset(-x*flr(rnd(3)+1),-y,8)

   pset(x/flr(rnd(3)+1),y*i,8)
   pset(-x/flr(rnd(3)+1),y*i,8)
   pset(x/flr(rnd(3)+1),-y*i,8)
   pset(-x/flr(rnd(3)+1),-y*i,8)

  end
  
  draw_noise(0.5)
  dither(dither_mode)
  undither(10,0.3)
  for i=-15,1 do
    x=5*sin(r)*cos(r)+max(5,rnd(14)+5)
    y=-5*sin(r)-min(-14,rnd(14)-14-5)
   oval(
    -x,-y,x,y,
    colors[0]
   )
  end

  for i=-2,1 do
   x=(5+rnd(30))*sin(r)*cos(r)+max(5,rnd(14)+5)
   y=(-5-rnd(30))*sin(r)-min(-14,rnd(14)-14-5)
   oval(
    -x,-y,x,y,
    colors[0]
   )
  end
  pal(colors,1)
 end

 function _draw()end

end
__gfx__
0000000000fffff000fffff000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff000000000000000000000000000000000000000000
0000000000fffff000f000f00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00000000000000000000000000000000000000000
0070070000fffff000f000f0ff0000ffff0ff0ffff00ffffff00ffffff00fffffff0ffffffffffffff0000ff0000000000000000000000000000000000000000
0007700000fffff000f000f0ff0ff0ffff0ff0ffff0fffffff0fffffff0ffffffffffffffff00fffff0000ff0000000000000000000000000000000000000000
0007700000fffff000f0f0f0ff0ff0ffff0ff0ffff0ff0ffff0ffffffffffffffffffffffff00fffff0000ff0000000000000000000000000000000000000000
0070070000ff0ff000ff0ff0ff0000ffff0000ffff0000ffff00ffffffffffffffffffffffffffffff0000ff0000000000000000000000000000000000000000
0000000000f000f000f000f00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00000000000000000000000000000000000000000
00000000000000000000000000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff000000000000000000000000000000000000000000
fff0000000000000000fffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f0f0fff00f000f00f0f00000f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff0f0f0f0f0f00f00f0f0f0f0ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f000f000f0000f00f0f00f00fffff000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f000f0000ff0f00f00f0f0f0f0ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000f00000f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000fffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
70707770700007700770777077700000777007700000777070707770000077707770777007707770000000000000000000000000000000000000000000000000
70707000700070007070777070000000070070700000070070707000000007007070707070007000000000000000000000000000000000000000000000000000
70707700700070007070707077000000070070700000070077707700000007007700777070007700000000000000000000000000000000000000000000000000
77707000700070007070707070000000070070700000070070707000000007007070707070007000000000000000000000000000000000000000000000000000
77707770777007707700707077700000070077000000070070707770000007007070707007707770000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000u000u00000u000u000u000u0000000000000000000000000000000000000000000u0u0u0u0u0u00000u00000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000uu0u0u0uu0uu0uu0uu0u0uuu0u0u0u0u0u0u00000000000000000000000000000000000000uu0u0u0u0u0u0u0uu0uu0uu0u0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000u0u0000000u00000u000u0u0u0u000u000u00000000000000000000000000000000000000000u00000u00000u00000000000u0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000u0u0000000u00000u000u0u0u0u000u000u00000000000000000000000000000000000000000u00000u00000u00000000000u0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000u0u0uu0u0uu0uu0u0uu0uu0u0u0u0uu0uu0u0000000000000000000000000000000000000u0uuu0uu0u0uu0uu0u0u0uu0u0u0uuu0u
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000u0u0u0u000u0u000u0u0u0000000u000u0u000000000000000000000000000000000000000u0u000u000u000u0u000u0u0u0000000u0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000u0u0u0u000u0u000u0u0u0000000u000u0u000000000000000000000000000000000000000u0u000u000u000u0u000u0u0u0000000u0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000uu0u0uuu0u0uu0u0u0u0uu0uuu0u0u0uuu0u0u00000000000000000000000000000000000u0uu0uu0uu0u0uu0u0u0uu0uu0uuu0u0u0u0uu0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000u000u0u000000000u000u000u0u0u000u0u00000000000000000000000000000000000000000u000u0000000u00000u000u0u0u00000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000u000u0u000000000u000u000u0u0u000u0u00000000000000000000000000000000000000000u000u0000000u00000u000u0u0u00000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000u0uu0u0u0u0u0u0uu0uu0u0u0u0u0u0u0uu0u0000000000000000000000000000000000000uu0uu0u0u0u0uu0uuu0u0uu0uu0u0u0u0uu0u0000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000u000u0000000u000u0u0000000u00000u0u000000000000000000000000000000000000000u0u0u000u0u0000000000000u000000000u0u000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000u000u0000000u000u0u0000000u00000u0u000000000000000000000000000000000000000u0u0u000u0u0000000000000u000000000u0u000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000u0u0uuu0u0u0uu0u0u0u0u0u0u0u0u0uu0uuu0u000000000000000000000000000000000000uu0uuu0u0u0uuu0uuu0u0uuu0u0u0uu0uu0uu0000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00u00000u000u0000000u0u0u0u0u0u000u0u000000000000000000000000000000000000000u00000u0u00000u000u000u000u00000u000u000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00u00000u000u0000000u0u0u0u0u0u000u0u000000000000000000000000000000000000000u00000u0u00000u000u000u000u00000u000u000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70700770707000007770777077007700000070700770707077700770777070007770000070000770077070707770770007700000777077700000777070707770
70707070707000007000070070707070000070707070707070707000700070007000000070007070707070700700707070000000707007000000070070707000
77707070707000007700070070707070000077707070707077007770770070007700000070007070707077000700707070000000777007000000070077707700
00707070707000007000070070707070000000707070707070700070700070007000000070007070707070700700707070700000707007000000070070707000
77707700077000007000777070707770000077707700077070707700777077707000000077707700770070707770707077700000707007000000070070707770
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07707770777077707700077077700000770077700770777077707770700000000770077007707770077070000770077070700000077077700000000000000000
70000700707070707070700070000000707007007000070007007070700000007000707070007770707070007070700070700000707070000000000000000000
77700700770077707070700077000000707007007000070007007770700000007000707077707070707070007070700077700000707077000000000000000000
00700700707070707070707070000000707007007070070007007070700000007000707000707070707070007070707000700000707070000000000000000000
77000700707070707070777077700000777077707770777007007070777000000770770077007070770077707700777077700000770070000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77707070777000007770777077700770777000000000077077000770777000007770077077707770770000000000000000000000000000000000000000000000
07007070700000000700707070707000700000000000707070707000700000007070700070700700707000000000000000000000000000000000000000000000
07007770770000000700770077707000770000000000707070707000770000007770700077700700707000000000000000000000000000000000000000000000
07007070700000000700707070707000700007000000707070707000700000007070707070700700707000000000000000000000000000000000000000000000
07007070777000000700707070700770777070000000770070700770777000007070777070707770707007000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70700770707000000770707007707770777000007070077070700000707007707070700077000000077077707070777000007070777000000000000000000000
70707070707000007000707070707070700000007070707070700000707070707070700070700000700007007070700000007070707000000000000000000000
77707070707000007770707070707700770000007770707070700000707070707070700070700000700007007070770000007070777000000000000000000000
00707070707000000070777070707070700000000070707070700000777070707070700070700000707007007770700000007070700000000000000000000000
77707700077000007700777077007070777000007770770007700000777077000770777077700000777077700700777000000770700007000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000070707770707077700000707077700000000000000000077777000777770000000000000770777077707070000077007770777077707770000000
00000000000070707070707070000000707070700000000000000000777007707700777000000000007000070070707070000070707070700070707770000000
00000000000070707770770077000000707077700000000000000000770007707700077000000000007770070077707770000070707700770077707070000000
00000000000077707070707070000000707070000000000000000000777007707700777000000000000070070070700070000070707070700070707070000000
00000000000077707070707077700000077070000000000000000000077777000777770000000000007700070070707770000077707070777070707070000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
010100200015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150
7d0100200015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150001500015000150
010100200055000550005500055000550005500055000550005500055000550005500055000550005500055000550005500055000550005500055000550005500055000550005500055000550005500055000550
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
093000200015400150001500015000140001300012000110001540015000150001500014000130001200011000154001500015000150001400013000120001100015400150001500015000140001300012000110
093000200015400150001500015000140001300012000110001540015000150001500014000130001200011005154051500515005150051400513005120051100415404150041500415004140041300412004110
011800200c033000330c615006150c6330061500000006150c000000130c615006150c633006150c615006150c033000330c615006150c6330061500000006150c000000130c615006150c633006150c61500615
091800201885418850188501885018850188501885018850188401884018830188301882018820188101881015854158501585015850158501585015850158501584015840158301583015820158201581015810
d5180000135120000200000000020c51200000000000000210512000020c512000021351200002000000000210512000020c51200002155120000210512000000000000002155120000210512000020c51200002
091800201185411850118501185011850118501185011850118401184011830118301182011820118101181013854138501385013850138501385013850138501384013840138301383013820138201381013810
911800000c51200002000000000211512000020000000002155120000211512000020c5120000200000000020e51200002175120000213512000020e51200002000000000213512000020e512000021751200002
91180010135120000200000000020c5120000200000000021051200002000000000213512000020000000002185121f5121c5121f512185121f5121c5121f512155021c502185021c502155021c502185021c502
000400002c4302c410033000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400
010800001b6451b645146250060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
713000201885418850188501885018840188301882018810188541885018850188501884018830188201881018854188501885018850188401883018820188101885418850188501885018840188301882018810
71300020188541885018850188501884018830188201881018854188501885018850188401883018820188101d8541d8501d8501d8501d8401d8301d8201d8101c8541c8501c8501c8501c8401c8301c8201c810
711800201885418850188501885018850188501885018850188401884018830188301882018820188101881015854158501585015850158501585015850158501584015840158301583015820158201581015810
711800201185411850118501185011850118501185011850118401184011830118301182011820118101181013854138501385013850138501385013850138501384013840138301383013820138201381013810
d13000200c9540c9500c9500c9500c9400c9300c9200c9100c9540c9500c9500c9500c9400c9300c9200c9100c9540c9500c9500c9500c9400c9300c9200c9100c9540c9500c9500c9500c9400c9300c9200c910
d13000200c9540c9500c9500c9500c9400c9300c9200c9100c9540c9500c9500c9500c9400c9300c9200c91011954119501195011950119401193011920119101095410950109501095010940109301092010910
d11800200c9540c9500c9500c9500c9500c9500c9500c9500c9400c9400c9300c9300c9200c9200c9100c91009954099500995009950099500995009950099500994009940099300993009920099200991009910
d11800200595405950059500595005950059500595005950059400594005930059300592005920059100591007954079500795007950079500795007950079500794007940079300793007920079200791007910
91180000131120c1020c1000c1020c1120c1000c10000102101120c1020c1120c102131120c1020c1000c102101120c1020c1120c102151120c102101120c1000c1000c102151120c102101120c1020c1120c102
911800000c1120c1020c1000c102111120c1020c1000c102151120c102111120c1020c1120c1020c1000c1020e1120c102171120c102131120c1020e1120c1020c1000c102131120c1020e1120c102171120c102
91180010131120c1020c1000c1020c1120c1020c1000c102101120c1020c1000c102131120c1020c10000102181121f1121c1121f112181121f1121c1121f112151021c102181021c102151021c102181021c102
01080000336551b6140060024600246002460024600246001d6001d60018600186001860018600186001860000600006000060000600006000060000600006000060000600006000060000600006000060000600
093000200055400550005500055000540005300052000510005540055000550005500054000530005200051000554005500055000550005400053000520005100055400550005500055000540005300052000510
093000200055400550005500055000540005300052000510005540055000550005500054000530005200051005554055500555005550055400553005520055100455404550045500455004540045300452004510
0918002018a5418a5018a5018a5018a5018a5018a5018a5018a4018a4018a3018a3018a2018a2018a1018a1015a5415a5015a5015a5015a5015a5015a5015a5015a4015a4015a3015a3015a2015a2015a1015a10
0918002011a5411a5011a5011a5011a5011a5011a5011a5011a4011a4011a3011a3011a2011a2011a1011a1013a5413a5013a5013a5013a5013a5013a5013a5013a4013a4013a3013a3013a2013a2013a1013a10
011800200c03300000000000c0330c6330000000000006150c000000000c615000000c633000000c615000000c03300000000000c0330c6330000000000006150c000000000c615000000c633000000c61500000
911800001f415184151f415184051f4151840518415184051c4151840518415184051f4151840518405184051c41521415184151840521415184051c41518405184051840521415184051c415184051841518405
91180000184151840518405184051d41518405184051840521415184051d41518405184151840518405184051a4151840523415184051f415184051a415184051840518405234151f4151a415184052341518405
911800101f415184051f41518405184151840518415184051c415184051c415184051f415184051f41500405184151f4151c4151f415184151f4151c4151f415154051c405184051c405154051c405184051c405
010800001b1231b635006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000000000000
010800001b6340f123006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600000000000000000
010800001b6340f1231b1231b13400600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600000000000000000
910800000c11300124001140060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
910800000c12300134001240060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
910800000c13300144001340060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
490800000c14300154001440060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
010800000c15300164001540060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
090800000c15300164001540060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
0d0800000c15300164001540060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
150800000c15300164001540060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000
__music__
01 08424344
01 090a4b44
00 090a4b44
01 0b0a0c44
00 0d0a0e44
00 0b0a0c44
00 0d0a0e44
00 080a0f44
02 090a4b44
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
01 08464344
00 090a4344
02 090a4344

