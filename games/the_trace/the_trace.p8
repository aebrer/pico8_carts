pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- init
lib={} -- library of all pages: title,page
curr_page=nil -- current page
debug={}  -- list of things to print for debug

function _init()
 
 cls()
 -- landing page
-- function lp_cb(page) return nil end
 lp=new_page("landing", "hello world",lp_cb)
	lp.choices["⬆️"]=new_choice()
	
	-- set current page to landing page
	curr_page=lp
	
	
end
-->8
-- update
function _update60()
 -- do callbacks for curr_page
 if(curr_page.cb)curr_page:cb()
 
 -- check inputs for choices
end
-->8
-- classes

function new_page(title,text,cb)
	local page = {}
	page.title = title
	page.seed = get_seed(page.title)
	page.text = text
	page.cb = cb
	page.choices = {}
	
	page.dis_title = dis_title
	page.dis_text = dis_text
	page.dis_logo = dis_logo
	page.dis_choices = dis_choices
	lib[title]=page
	return page
end

function new_choice(title,text,cb)
 local choice = {}
 choice.title=title
 choice.text=text
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
-->8
-- draw
function _draw()
 curr_page:dis_title()
 curr_page:dis_text()
 curr_page:dis_logo()
 curr_page:dis_choices()
 
 
 -- debug
 for i=1,#debug do
  print("\^#"..tostr(debug[i]),0,0+8*i,7)
 end
end

function dis_title(page)
	print(page.title,0,0,7)
end

function dis_logo(page)
 clip(0,8,128,32)
 for i=0,200 do
  pset(rnd(128),rnd(128),rnd(16))
 end
 clip()
end

function dis_text(page)
 print(page.text,0,48,7)
end

function dis_choices(page)
	for ch in all(page.choices) do
	 print(ch.title,0,90,7)
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
