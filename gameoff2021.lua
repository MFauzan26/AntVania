-- title:  AntVania
-- author: Muhammad Fauzan
-- desc:   Metroidvania Month 14
-- script: lua

scn=0
zClick=false

tim={--time
 inv=0,--invisible
 an=0--animation
}

pla={--player
	an=0,--animation
 f=0,--flip
 x=0,
 y=0,
 vx=0,
 vy=0,
 sp=1,--speed
 hl=3,--health
 wp=0,--weapon
 ab=0,--ability
 td=0,--time dead
 inv=false,--invisible
 eup=false,--power up effect
 grv=true,--gravity
}

swo={--sword
	x=0,
	y=0,
	t=0,
	ac=true--active
}

bwo={--bow
	x=0,
	y=0,
	t=0,
	sp=193,
	am=0,--amount
	ac=true--active
}

cam={--camera
 mx=0,
 my=0,
 x=0,
 y=0,
 a=1,
 ll=0,--left limit
 lr=0,--right limit
 lu=0,--up limit
 ld=0,--down limit
 sh=false--shake
}
shake=0

sav={--save
	px=0,
	py=0,
	hl=0,
	wp=0,
	bw=0,
	ab=0
}
isHeal=false
isSave=false

cir={}--circle
slh={}--sword slash
arw={}--arrow
eup={}--effect power up
edm={}--effect damage
exp={}--effect explosion
spw={}--spawn enemy
ebg={}--enemy bug
efl={}--enemy fly
ehg={}--enemy hedgehog
bhg={}--bullet hedgehog
ssl={}--spawn banaspati
esl={}--banaspati
glm={}--golem
clm={}--crimson golem
gpw={}--cGolem power
bos1={}--boss 1
bos1Ded=false
bos2={}--boss 2

dbg=false
function debug()
	local d=dbg local p=pla local c=cam local sav=isSave
	if keyp(4) then
  if not d then dbg=true
  else dbg=false end
 end
 if d then
 	print("playerX: "..p.x.."",8,16,12)
  print("playerY: "..p.y.."",8,24,12)
  print("cameraX: "..c.x.."",8,32,12)
  print("cameraY: "..c.y.."",8,40,12)
  print("camLimL: "..c.ll.."",8,48,12)
  print("camLimR: "..c.lr.."",8,56,12)
  print("camLimU: "..c.lu.."",8,64,12)
  print("camLimD: "..c.ld.."",8,72,12)
  print(sav,8,80,12)
 	print("pmem0(pX): "..pmem(0).."",8,88,12)
  print("pmem1(pY): "..pmem(1).."",8,96,12)
  print("pmem2(hl): "..pmem(2).."",8,104,12)
  print("pmem3(wp): "..pmem(3).."",8,112,12)
  print("pmem4(ab): "..pmem(4).."",8,120,12)
  print("pmem5(bw): "..pmem(5).."",8,128,12)
  --
  print("slash: "..#slh.."",96,16,12)
  print("arrow: "..#arw.."",96,24,12)
  print("effUp: "..#eup.."",96,32,12)
  print("effdm: "..#edm.."",96,40,12)
  print("irisS: "..#cir.."",96,48,12)
  print(p.inv,96,56,12)
  print("explosion: "..#exp.."",96,64,12)
  --
  print("spawn: "..#spw.."",176,16,12)
  print("bug: "..#ebg.."",176,24,12)
  print("fly: "..#efl.."",176,32,12)
  print("fly: "..#efl.."",176,32,12)
  print("hedge: "..#ehg.."",176,40,12)
  print("hedgeBul: "..#bhg.."",176,48,12)
  print("sSoul: "..#ssl.."",176,56,12)
  print("soul: "..#efl.."",176,64,12)
  print("golem: "..#glm.."",176,72,12)
  print("cGolem: "..#clm.."",176,80,12)
 	print("golemPow: "..#gpw.."",176,88,12)
  print("boss 1: "..#bos1.."",176,104,12)
  print("boss 2: "..#bos2.."",176,112,12)
 end
end

function TIC()
	render()debug()
end

--save & load
function save()
	local p=pla local sv=sav local bw=bwo
	local flr=math.floor
	sv.px=flr(p.x) sv.py=flr(p.y)
	sv.hl=p.hl
	sv.wp=p.wp sv.bw=bw.am sv.ab=p.ab
 pmem(0,sv.px)pmem(1,sv.py)
 pmem(2,sv.hl)
 pmem(3,sv.wp)pmem(5,sv.bw)pmem(4,sv.ab)
	isSave=true
end
function load()
	local p=pla local bw=bwo
	fade(32,-1)
	p.x=pmem(0)p.y=pmem(1)
	p.hl=pmem(2)
	p.wp=pmem(3)bw.am=pmem(5)p.ab=pmem(4)
end
function newGame()
	local p=pla local bw=bwo
	fade(32,-1)
	pmem(0,0)
	p.x=56 p.y=112 p.grv=true
	p.hl=3
	p.wp=0 bw.am=0 p.ab=0
end
------------

function render()
	local s=scn
	--title
	if s==0 then sTitle()
	--game
	elseif s==1 then sGame()
	--game over
	elseif s==2 then sOver()
	end
end

function sTitle()
	map(210,102)
	spr(240,56,40,0,2,0,0,8,1)
	print("Game by MFauzan",92,60,8,false,1,true)
	if not zClick then
		if time()%1000>500 then
		 print("PRESS     TO START",74,98,8)
		 print("PRESS     TO START",74,97,12)
		 spr(188,109,96)
		end
		if btnp(4) then sfx(48,'c-3',30) zClick=true end
	else
		local coC=14--continue color
		if pmem(0)>0 then coC=12 end
		spr(184,84,87)print("TO CONTINUE",96,88,coC)
		spr(185,84,103)print("TO NEW GAME",96,104,12)
		--continue
		if pmem(0)>0 and btnp(0) then sfx(48,'c-3',30)
			load()
			scn=1
		end
		--new game
		if btnp(1) then sfx(48,'c-3',30)
			newGame()
			scn=1
		end
	end
end

init=false
function sInit()
	Spawn(39,12,0)Spawn(15,29,0)Spawn(104,10,0)Spawn(169,6,0)Spawn(82,44,0)Spawn(156,45,0)Spawn(171,60,0)
	Spawn(84,56,1)Spawn(191,71,1)Spawn(145,73,1)Spawn(106,75,1)Spawn(75,74,1)Spawn(56,74,1)
	--Spawn(43,31,2)Spawn(46,25,2)
	Spawn(67,11,3)Spawn(101,28,3)Spawn(184,45,3)Spawn(126,79,3)
	--Spawn(22,28,4)Spawn(94,11,4)
	--SSoul(68,12)
	EBos1(194,115)
end
function sGame()
	local p=pla local c=cam local bw=bwo
	local rnd=math.random
	if not init then sInit()init=true end
	--change area
	if p.x>0 and p.x<1680 and ((p.y>0 and p.y<816) or (p.y>952 and p.y<1088)) then
		c.ll=0 c.lr=-1440 c.lu=(p.y//136)*-136 c.ld=c.lu
	elseif p.x>0 and p.x<1440 and p.y>816 and p.y<952 then
		c.ll=0 c.lr=-1200 c.lu=-816 c.ld=c.lu
	elseif (p.x>1440 and p.x<1680 and p.y>816 and p.y<952) or (p.x>1680 and p.x<1920 and p.y>952 and p.y<1088) then
		c.ll=(p.x//240)*-240 c.lr=c.ll c.lu=(p.y//136)*-136 c.ld=c.lu
	elseif p.x>1680 and p.x<1920 and p.y>0 and p.y<816 then
		c.ll=-1680 c.lr=c.ll c.lu=0 c.ld=-680
	end
	--camera
	c.x=112-p.x c.y=68-p.y
	if c.x>c.ll then c.x=c.ll end
	if c.x<c.lr then c.x=c.lr end
	if c.y>c.lu then c.y=c.lu end
	if c.y<c.ld then c.y=c.ld end
	map(0,0,240,136,c.x,c.y)
	--camera shake
 if c.sh then d=2
		if shake>0 then
			poke(0x3FF9,rnd(-d,d))
			poke(0x3FF9+1,rnd(-d,d))
			shake=shake-1
		 if shake==0 then memset(0x3FF9,0,2) c.sh=false end
		end
 end
	--object
	drawSpawn()
	drawEBug()
	drawEFly()
	drawEHedg()
	drawSSoul()
	drawESoul()
	drawEGolem()
	drawECGolem()
	drawEGPower()
	drawEBos1()
	drawEHgBul()
	if p.wp==0 then getSword(32,240) end
	if bw.am==0 then getBow(1708,160) end
	if bos1Ded then getGrav(1556,928) end
	hud()player()
	drawSlash()
	drawArrow()
	drawEffUp()
	drawEffDam()
	drawEffExplode()
	drawFade()
end

function sOver()
	init=false
	cls()
	print("GAME OVER",68,56,2,false,2)
	if time()%1000>500 then
		spr(188,90,87,0)print("CONTINUE",104,88,12)
	end
	if btnp(4) then sfx(48,'c-3',30)
		if pmem(0)>0 then	load()
		else newGame() end
		scn=1
	end
end

function solid(x,y)
 return mget(x//8,y//8)<80
end
function saveArea(x,y)
	local saveA={[160]=true,[161]=true}
	return saveA[(mget(x//8,y//8))]
end
function healArea(x,y)
	local healA={[162]=true,[163]=true}
	return healA[(mget(x//8,y//8))]
end
function shroom(x,y)
	local shrmA={[77]=true,[78]=true,[79]=true}
	return shrmA[(mget(x//8,y//8))]
end
function spike(x,y)
	local spikA={[97]=true,[98]=true}
	return spikA[(mget(x//8,y//8))]
end
function water(x,y)
	local watrA={[99]=true,[144]=true}
	return watrA[(mget(x//8,y//8))]
end
function dart(x,y)
	return mget(x//8,y//8)==64
end

function hud()
	local p=pla local h=p.hl*8
	--bg
	rect(0,0,240,14,0)
	--health
 for x=8,24,8 do spr(177,x,2,0) end
 for x=8,h,8 do spr(176,x,2,0) end
 --weapon
 spr(178,160,2,0)
 spr(179,176,2,0)
 if p.wp==0 then
 	spr(183,168,2,0)--?
 elseif p.wp==1 then
 	spr(189,152,2,0)--button
  spr(180,168,2,0)--sword
 elseif p.wp==2 then
 	spr(189,152,2,0)--button
  spr(181,168,2,0)--bow & arrow
 else
 end
 --power
 spr(178,208,2,0)
 spr(179,224,2,0)
 if p.ab>0 then
 	spr(190,200,2,0)--button
 	spr(182,216,2,0)--power up
 else spr(183,216,2,0)
 end
 --save
 local sav=isSave
 if saveArea(p.x+4,p.y+4) then
 	spr(164,48,2,0)
  if not sav then
  	sfx(49,'e-6',30)
   effUp(12)
   save()isSave=true
  end
 else isSave=false end
 --frame
 rectb(0,14,240,122,1)
end

--weapon
function getSword(x,y)
	local c=cam local p=pla
	spr(180,x+c.x,y+c.y,0)
	if p.x+4>x and p.x+4<x+8 and p.y+4>y and p.y+4<y+8 then
		sfx(49,'f-5',30)effUp(4)p.wp=1
	end
end
function sword(x,y,f)
	local c=cam local sw=swo
	if f==0 then sw.x=3 sw.y=-2
	elseif f==1 then sw.x=-3 sw.y=-2
	elseif f==2 then sw.x=3 sw.y=2
	elseif f==3 then sw.x=-3 sw.y=2
	end
	if sw.ac then
		sw.t=0
		spr(192,x+sw.x+c.x,y+sw.y+c.y,0,1,f)
	else
		sw.t=sw.t+1
		if sw.t>20 then sw.ac=true end
	end
	--attack
	if btnp(5) then
		if sw.ac then
			sfx(54,'c-5',10)
			slash(x+sw.x*3,y,f)
			sw.ac=false
		end
	end
end
function slash(mx,my,mf)
 local s={x=mx,y=my,f=mf,t=0}
 slh[#slh+1]=s
end
function drawSlash()
	local t=tim local c=cam local sl=slh
	for i,s in pairs(sl) do
		s.t=s.t+1
		spr(200+t.an%12//3,s.x+c.x,s.y+c.y,0,1,s.f)
		if s.t==12 then table.remove(slh,i) end
	end
end

function getBow(x,y)
	local p=pla local c=cam local bw=bwo
	spr(181,x+c.x,y+c.y,0)
	if p.x+4>x and p.x+4<x+8 and p.y+4>y and p.y+4<y+8 then
		sfx(49,'f-5',30)effUp(2)bw.am=1
	end
end
function bow(x,y,f)
	local c=cam local bw=bwo
	if f==0 then bw.x=3 --bw.y=-1
	elseif f==1 then bw.x=-3 --bw.y=-1
	elseif f==2 then bw.x=3 --bw.y=1
	elseif f==3 then bw.x=-3 --bw.y=1
	end
	if bw.ac then bw.t=0 bw.sp=193
	else bw.t=bw.t+1 if bw.t>15 then bw.ac=true end
	end
	spr(bw.sp,x+bw.x+c.x,y+bw.y+c.y,0,1,f)
	--attack
	if btnp(5) and bw.ac then
		sfx(53,'c-5',20)
		arrow(x+bw.x,y+4,bw.x)
		bw.sp=194 bw.ac=false
	end
end
function arrow(mx,my,mvx)
 local ar={x=mx,y=my,vx=mvx,t=0}
 arw[#arw+1]=ar
end
function drawArrow()
	local c=cam local ar=arw
	for i,ar in pairs(ar) do
		ar.t=ar.t+1
		ar.x=ar.x+ar.vx
		pix(ar.x+c.x,ar.y+c.y,12)
		if ar.t==20 or solid(ar.x,ar.y) then table.remove(arw,i) end
		if dart(ar.x,ar.y) then mset(ar.x//8,ar.y//8,81) end
	end
end

function getGrav(x,y)
	local p=pla local c=cam
	spr(165,x+c.x,y+c.y,0)
	if p.x+4>x and p.x+4<x+8 and p.y+4>y and p.y+4<y+8 then
		sfx(49,'f-5',30)effUp(3)p.ab=1
		bos1Ded=false
	end
end
-----

function player()
	local p=pla local t=tim local c=cam local bw=bwo
	local tn=t.an%28//7
	t.an=t.an+1
 --movement
 if btn(2) then--left
 	p.vx=-p.sp
 	p.an=tn
  if p.grv then p.f=1
  else p.f=3 end
 elseif btn(3) then--right
 	p.vx=p.sp
  p.an=tn
  if p.grv then p.f=0
  else p.f=2 end
 else p.an=0 p.vx=0 end
 --change weapon
 if btnp(7) and bw.am>0 then
 	if p.wp==1 then p.wp=2
  else p.wp=1 end
 end
 --active gravity ability
 if btnp(6) and p.ab==1 then
 	if p.grv then p.f=2 p.vy=-1 p.grv=false
  else p.f=0 p.grv=true end
 end
 --collision
 u=p.y+p.vy d=p.y+p.vy+8 l=p.x+p.vx r=p.x+p.vx+7
 if solid(l,u+1) or solid(l,d-1) or solid(r,u+1) or solid(r,d-1) then p.vx=0 end
 --gravity
 if solid(l+1,d) or solid(r-1,d) then p.vy=0
 else
 	if p.grv then p.vy=p.vy+0.2
  else p.vy=p.vy-0.1 end
 end
 --jump
 if p.vy==0 and btnp(4) then sfx(50,'c-3',30)p.vy=-3 end
 if shroom(l,d) or shroom(r,d) then p.vy=-4 end
 --collision up
 if p.vy<0 and (solid(l+2,u) or solid(r-2,u)) then p.vy=0 end
 --update movement
 p.x=p.x+p.vx
 p.y=p.y+p.vy
 --limit health
 if p.hl<0 then p.hl=0 end
 if p.hl>3 then p.hl=3 end
 --heal
 local heal=isHeal
 if healArea(l+4,u+4) then
 	if not heal then sfx(49,'e-6',30)effUp(5)p.hl=3 isHeal=true end
 else isHeal=false end
 --weapon
 if p.wp==1 then sword(l,u,p.f)
 elseif p.wp==2 then bow(l,u,p.f) end
 --invisible
 if p.inv then
  t.inv=t.inv+1
  --blink
  if time()%200>100 then
  	spr(208+p.an,p.x+c.x,p.y+c.y,0,1,p.f)
  end
  if t.inv==60*2 then t.inv=0 p.inv=false end
 --draw
 else
 	spr(208+p.an,p.x+c.x,p.y+c.y,0,1,p.f)
 end
 --damage by spike and water
 if not p.inv and spike(l+4,u+4) then EAtt2() end
 if water(l+4,u+4) then EAtt2() end
 --dead
 if p.hl<1 then
 	if #cir==0 then p.td=0 fade(0,1) end
 	p.td=p.td+1 if p.td==32 then scn=2 end
 end
end

--enemy
function ESolid(l,r,u,d)--enemy collision
	return solid(l-1,u+4) or solid(r+1,u+4) or not solid(l,d) or not solid(r,d)
end
function EAtt(l,r,u,d)--enemy attack
	local p=pla local c=cam
	if not p.inv and p.x+4>l and p.x+4<r and p.y+4>u and p.y+4<d then
	 sfx(52,'e-4',10)
		shake=20 c.sh=true
	 effDam(p.x+4,p.y+4)
	 p.hl=p.hl-1
	 p.inv=true
		return true
	end
end
function EAtt2()
	local p=pla local c=cam
	sfx(52,'e-4',10)
	shake=20 c.sh=true
 effDam(p.x+4,p.y+4)
 p.hl=p.hl-1
 p.inv=true
end
function EDam(x,y,w,h,dam)--enemy damage
	local u=y local d=y+h local l=x local r=x+w
	local sl=slh
	for i,sw in pairs(sl) do--sword
		return not dam and sw.x-2<r and sw.x+10>l and sw.y<d and sw.y+8>u
	end
	local ar=arw
	for j,ar in pairs(ar) do--arrow
		return not dam and ar.x>l and ar.x<r and ar.y>u and ar.y<d
	end
end
function EDed(mx,my)--enemy dead
	local c=cam
 sfx(51,'d-3',30)
 shake=20 c.sh=true
 for i=0,360,45 do effExplod(mx,my,i) end
end
function EWipe(x,y,h)--wipe enemy
	local p=pla
	return h<0 or p.x<x-240 or p.x>x+240 or p.y<y-136 or p.y>y+136
end

function Spawn(mx,my,me)
	local s={
		x=mx*8,
		y=my*8,
		e=me,--enemy
		a=false--active
	}
	spw[#spw+1]=s
end
function drawSpawn()
	local p=pla local c=cam local sp=spw
	for j,s in pairs(sp) do
		if p.x>s.x-240 and p.x<s.x+240 and p.y>s.y-136 and p.y<s.y+136 then
			if not s.a then
				if s.e==0 then EBug(s.x,s.y)
				elseif s.e==1 then EFly(s.x,s.y)
				elseif s.e==2 then EHedg(s.x,s.y)
				elseif s.e==3 then EGolem(s.x,s.y)
				elseif s.e==4 then ECGolem(s.x,s.y)
				end
				s.a=true
			end
		else s.a=false end
		if p.hl==0 then spw[j]=nil end
	end
end

function EBug(mx,my)
	local e={
		x=mx,
		y=my,
		vx=.3,
		sp=212,--sprite
		an=0,--animation
		h=1,--health
		t=0,--time
		d=false--damage
	}
	ebg[#ebg+1]=e
end
function drawEBug()
	local t=tim local p=pla local c=cam local bg=ebg
	for i,e in pairs(bg) do
		local u=e.y local d=e.y+9 local l=e.x local r=e.x+8
		--movement
		if ESolid(l,r,u,d) then e.vx=e.vx*-1 end
		e.x=e.x+e.vx
		--draw
		spr(e.sp+e.an,e.x+c.x,e.y+c.y,0)
		--attack
		EAtt(l,r,u,d)
		--damage
		if EDam(l,u,8,8,e.d) then e.h=e.h-1 e.d=true end
		if e.d then
			e.t=e.t+1 e.an=0 e.sp=214
			if e.t>12 then e.d=false end
		else e.an=t.an%24//12 e.sp=212 e.t=0
		end
		--dead
		if e.h<0 then EDed(l,u) end
		if EWipe(e.x,e.y,e.h) then table.remove(ebg,i) end
		if p.hl==0 then ebg[i]=nil end
	end
end

function EFly(mx,my)
	local e={x=mx,y=my,an=0,h=1,d=false}
	efl[#efl+1]=e
end
function drawEFly()
	local t=tim local p=pla local c=cam local fl=efl
	for i,e in pairs(fl) do
		local u=e.y+2 local d=e.y+6 local l=e.x+4 local r=e.x+6
		--movement
 	local dx=p.x-e.x local dy=p.y-e.y local sqrt=math.sqrt
  local dist=sqrt((dx*dx)+(dy*dy))
  if p.x>e.x-96 and p.x<e.x+96 and p.y>e.y-16 and p.x<e.x+96 then
  	e.x=e.x+(dx/dist*.5)e.y=e.y+(dy/dist*.5)
   e.an=t.an%10//5
  end
		--draw
		spr(215+e.an,e.x+c.x,e.y+c.y,0)
		--attack
		EAtt(l,r,u,d)
		--damage
		if EDam(l,u,8,8,e.d) then e.h=e.h-1 EDed(l,u) end
		--dead
		if EWipe(e.x,e.y,e.h) then table.remove(efl,i) end
		if p.hl==0 then efl[i]=nil end
	end
end

function EHgBul(mx,my,ma)
 local b={x=mx,y=my,a=ma,t=0}
 bhg[#bhg+1]=b
end
function drawEHgBul()
	local t=tim local c=cam local bg=bhg local p=pla
	local rad=math.rad local sin=math.sin local cos=math.cos
 for i,l in pairs(bg) do
 	local u=l.y-1 local d=l.y+3 local le=l.x-1 local r=l.x+3
 	--movement
  local dir=rad(l.a)
  l.x=l.x+sin(dir)*.7
  l.y=l.y-cos(dir)*.7
  --draw
  circ(l.x+c.x,l.y+c.y,2,11)
  --attack
  EAtt(le,r,u,d)
  --remove
  if solid(l.x,l.y) then table.remove(bhg,i) end
		if p.hl==0 then bhg[i]=nil end
	end
end

function EHedg(mx,my)
	local e={x=mx,y=my,vx=.3,f=0,h=1,t=0}
	ehg[#ehg+1]=e
end
function drawEHedg()
	local t=tim local p=pla local c=cam local hg=ehg
	for i,e in pairs(hg) do
		local u=e.y-1 local d=e.y+9 local l=e.x local r=e.x+8
		if solid(l,u) then f=2 
		elseif solid(l,d) then f=0 end
		--movement
		if f==2 and ESolid(l,r,u,u) then e.vx=e.vx*-1 end
		if f==0 and ESolid(l,r,u,d) then e.vx=e.vx*-1 end
		e.x=e.x+e.vx
		--draw
		spr(232+t.an%24//12,e.x+c.x,e.y+c.y,0,1,f)
		--attack
		e.t=e.t+1
		if e.t==60*5 then
			for i=0,360,45 do EHgBul(l+4,u+4,i) end
			e.t=0
		end
		EAtt(l,r,u,d)
		--damage
		if EDam(l,u,8,8,e.d) then e.h=e.h-1 EDed(l,u) end
		--dead
		if EWipe(e.x,e.y,e.h) then table.remove(ehg,i) end
		if p.hl==0 then ehg[i]=nil end
	end
end

function SSoul(mx,my)
	local s={x=mx*8,y=my*8,t=0,a=false}
	ssl[#ssl+1]=s
end
function drawSSoul()
	local p=pla local c=cam local ss=ssl
	for j,s in pairs(ss) do
		--spawn soul
		if p.x>s.x-120 and p.x<s.x+120 and p.y>s.y-64 and p.y<s.y+16 then
			if not s.a then ESoul(s.x,s.y) end
			s.a=true
		else a=false end
		if s.a then s.t=s.t+1
			if s.t==60*5 then ESoul(s.x,s.y) s.t=0 end
		else s.a=false end
		--draw
		spr(217,s.x+c.x,s.y+c.y,0)
		--remove
		if p.hl==0 then ssl[j]=nil end
	end
end

function ESoul(mx,my)
	local e={x=mx,y=my,h=1,f=0,d=false}
	esl[#esl+1]=e
end
function drawESoul()
	local t=tim local p=pla local c=cam local sl=esl
	for i,e in pairs(sl) do
		local u=e.y+2 local d=e.y+6 local l=e.x+4 local r=e.x+6
		--movement
 	local dx=p.x-e.x local dy=p.y-e.y local sqrt=math.sqrt
  local dist=sqrt((dx*dx)+(dy*dy))
  e.x=e.x+(dx/dist)
  e.y=e.y+(dy/dist)
		--draw
		if p.x>e.x+4 then e.f=0
		else e.f=1 end
		spr(228+t.an%24//6,e.x+c.x,e.y+c.y,0,1,e.f)
		--attack
		if EAtt(l,r,u,d) then table.remove(esl,i) end
		--damage
		if EDam(l,u,8,8,e.d) then e.h=e.h-1 EDed(l,u) end
		--dead
		if EWipe(e.x,e.y,e.h) then table.remove(esl,i) end
		if p.hl==0 then esl[i]=nil end
	end
end

function EGolem(mx,my)
	local e={
		x=mx,
		y=my,
		sp=256,--sprite
		f=0,--flip
		h=55,--health
		ta=0,--time attack
		td=0,--time damage
		te=0,--time explode
		c=0,--collision
		d=false--damage
	}
	glm[#glm+1]=e
end
function drawEGolem()
	local t=tim local p=pla local c=cam local gl=glm
	for i,e in pairs(gl) do
		local u=e.y local d=e.y+32 local l=e.x local r=e.x+32
		--draw
		if p.x>l+16 then e.f=0 e.c=32
		else e.f=1 e.c=0 end
		spr(e.sp,e.x+c.x,e.y+c.y,6,1,e.f,0,4,4)
		--attack
		if p.x+4>l+14 and p.x+4<r-14 and p.y+4>u and p.y+4<d then	EAtt2()end
		e.ta=e.ta+1
		if e.ta>60*2 and e.ta<60*3 then e.sp=260 
		elseif e.ta>60*3 and e.ta<60*3.5 then e.sp=264 EAtt(l-8,r+8,u,d)
		elseif e.ta==60*3.5 then e.ta=0
		else e.sp=256 end
		--damage
		if EDam(l+8,u,16,32,e.d) then effDam(l+16,u+16) e.h=e.h-1 e.d=true end
		if e.d then
			e.td=e.td+1
			if e.td>12 then e.d=false end
		else e.td=0	end
		--dead
		if e.h<0 then
			e.te=e.te+1
			if e.te==15 then EDed(l+16,u+16)
			elseif e.te==30 then EDed(l+16,u+16)
			elseif e.te==45 then EDed(l+16,u+16)table.remove(glm,i)
			end
		end
		if p.x<l-240 or p.x>l+240 or p.y<u-136 or p.y>u+136 then table.remove(glm,i) end
		if p.hl==0 then glm[i]=nil end
	end
end

function EGPower(mx,my,mf)
	local e={x=mx,y=my,vx=0,f=mf,t=0}
	gpw[#gpw+1]=e
end
function drawEGPower()
	local t=tim local p=pla local c=cam local pw=gpw
	for i,e in pairs(pw) do
		local u=e.y+8 local d=e.y+17 local l=e.x local r=e.x+16
		if e.f==0 then e.vx=2
		else e.vx=-2 end
		e.x=e.x+e.vx
		--draw
		spr(364+t.an%10//5*2,e.x+c.x,e.y+c.y,0,1,e.f,0,2,2)
		--attack
  EAtt(l,r,u,d)
  --remove
  e.t=e.t+1
  if e.t==60*2 or solid(l,u+1) or solid(r,u+1) or not solid(l,d) or not solid(r,d) then
  	table.remove(gpw,i)
  end
		if p.hl==0 then gpw[i]=nil end
	end
end

function ECGolem(mx,my)
	local e={
		x=mx,
		y=my,
		sp=320,--sprite
		f=0,--flip
		h=55,--health
		ta=0,--time attack
		td=0,--time damage
		te=0,--time explode
		c=0,--collision
		d=false--damage
	}
	clm[#clm+1]=e
end
function drawECGolem()
	local t=tim local p=pla local c=cam local gl=clm
	for i,e in pairs(gl) do
		local u=e.y local d=e.y+32 local l=e.x local r=e.x+32
		--draw
		if p.x>l+16 then e.f=0 e.c=32
		else e.f=1 e.c=0 end
		spr(e.sp,e.x+c.x,e.y+c.y,6,1,e.f,0,4,4)
		--attack
		if p.x+4>l+14 and p.x+4<r-14 and p.y+4>u and p.y+4<d then	EAtt2()end
		e.ta=e.ta+1
		if e.ta>60*2 and e.ta<60*3 then e.sp=324
		elseif e.ta==60*3 then EGPower(l+16,u+16,e.f)
		elseif e.ta>60*3 and e.ta<60*3.5 then e.sp=328 EAtt(l-8,r+8,u,d)
		elseif e.ta==60*3.5 then e.ta=0
		else e.sp=320 end
		--damage
		if EDam(l+8,u,16,32,e.d) then effDam(l+16,u+16) e.h=e.h-1 e.d=true end
		if e.d then
			e.td=e.td+1
			if e.td>12 then e.d=false end
		else e.td=0	end
		--dead
		if e.h<0 then
			e.te=e.te+1
			if e.te==15 then EDed(l+16,u+16)
			elseif e.te==30 then EDed(l+16,u+16)
			elseif e.te==45 then EDed(l+16,u+16)table.remove(clm,i)
			end
		end
		if p.x<l-240 or p.x>l+240 or p.y<u-136 or p.y>u+136 then table.remove(clm,i) end
		if p.hl==0 then clm[i]=nil end
	end
end

function EBos1(mx,my)
	local e={
		x=mx*8,
		y=my*8,
		vx=.7,
		vy=0,
		dx=1,
		sp=218,--sprite
		f=0,--flip
		h=33,--health
		ts=0,--time shoot
		tg=0,--time gravity
		te=0,--time explode
		a=false,--active
		d=false,--damage
		gr=true--gravity
	}
	bos1[#bos1+1]=e
end
function drawEBos1()
	local t=tim local p=pla local c=cam local bo=bos1
	for i,e in pairs(bo) do
		if p.x>1440 and p.x<1680 and p.y>816 and p.y<952 then
			local u=e.y local d=e.y+16 local l=e.x local r=e.x+16
			--movement
			if solid(l,u+8) or solid(r,u+8) then e.vx=e.vx*-1 end
			e.x=e.x+e.vx
			if e.vx>0 then e.dx=1
			elseif e.vx<0 then e.dx=-1
			else e.dx=e.dx end
			--gravity
			e.tg=e.tg+1
			if e.tg==60*12 then
				if e.gr then e.f=2 e.y=e.y-5 e.gr=false
				else e.f=0 e.y=e.y+5 e.gr=true end
				e.tg=0
			end
			if solid(l+8,d) or solid(l+8,u-4) then e.vy=0
			else
		 	if e.gr then e.vy=e.vy+0.1
		  else e.vy=e.vy-0.1 end
		 end
			e.y=e.y+e.vy
			--draw
			spr(e.sp+t.an%18//6*2,e.x+c.x,e.y+c.y,0,1,e.f,0,2,2)
			--attack
			e.ts=e.ts+1
			if e.ts>60*7 and e.ts<60*7.9 then e.vx=0
			elseif e.ts==60*8 then
				for i=0,360,45 do EHgBul(l+8,u+12,i) end
			elseif e.ts>60*9 then e.vx=.7*e.dx e.ts=0
			end
			EAtt(l+2,r-2,u+2,d)
			--damage
			if EDam(l,u,16,16,e.d) then effDam(l+8,u+8)e.h=e.h-1 e.d=true end
			if e.d then
				e.td=e.td+1
				if e.td>12 then e.d=false end
			else e.td=0	end
			--dead
			if e.h<0 then
				e.te=e.te+1
				if e.te==15 then EDed(l+8,u+8)
				elseif e.te==30 then EDed(l+8,u+8)
				elseif e.te==45 then EDed(l+8,u+8)table.remove(bos1,i)bos1Ded=true
				end
			end
		end
		if p.hl==0 then bos1[i]=nil end
	end
end

--misc
function effUp(mc)
 local e={x=0,y=0,c=mc,r=16}
 eup[#eup+1]=e
end
function drawEffUp()
	local p=pla local c=cam local up=eup
 for i,e in pairs(up) do
  e.x=p.x+4 e.y=p.y+4
  e.r=e.r-1
  circb(e.x+c.x,e.y+c.y,e.r,e.c)
  if e.r<0 then p.eup=false table.remove(eup,i) end
 end
end

function effDam(mx,my)
 local e={x=mx,y=my,r=0}
 edm[#edm+1]=e
end
function drawEffDam()
	local p=pla local c=cam local dm=edm
 for i,e in pairs(dm) do
  e.r=e.r+1
  circ(e.x+c.x,e.y+c.y,e.r,2)
  if e.r>8 then table.remove(edm,i) end
 end
end

function effExplod(mx,my,ma)
 local l={x=mx,y=my,a=ma,rd=0,t=0}
 exp[#exp+1]=l
end
function drawEffExplode()
	local t=tim local c=cam local xp=exp
	local rad=math.rad local sin=math.sin local cos=math.cos
 for i,l in pairs(xp) do
  local dir=rad(l.a)
  l.x=l.x+sin(dir)*2
  l.y=l.y-cos(dir)*2
  circ(l.x+c.x,l.y+c.y,l.rd+t.an%12//3,4)
  l.t=l.t+1
  if l.t==20 then table.remove(exp,i) end
	end
end

function fade(mrad,mz)
	local f={
		x=0,
 	y=0,
  z=mz,
		rad=mrad,--radius
 	min=-10,
 	max=32
 }
 cir[#cir+1]=f
end
function drawFade()
	local ci=cir
	for i,f in pairs(ci) do
		f.rad=f.rad+f.z
		for x=0,240,30 do
			for y=0,136,17 do
				circ(x,y,f.rad,0)
			end
		end
  if f.rad<f.min or f.rad>f.max then table.remove(cir,i) end
	end
end


-- <TILES>
-- 000:6666666666666666666666666666666666666666666666666666666666666666
-- 001:dddddddfdeeeeeefdeddddefdedeefefdedeefefdeffffefdeeeeeefffffffff
-- 002:7777777776666666766565657656565676666666766766671771777111121112
-- 003:7777777766666666656565655656565666666666666766677771777111121112
-- 004:7777777766666667656565675656566766666667666766677771777111121111
-- 005:0899998809999880009888000000080900900088099800000999800009998000
-- 006:0899998809999880009888009900080999980098888000000000000000000000
-- 007:0999998009999888008888880000008000000900000089900008999000089990
-- 008:5555555576666667077666709907770999980098888000000000000000000000
-- 009:0009980000089980000088800000000900000098000000000000000000000000
-- 010:0099900000999000009800009900000099980000888000000000000000000000
-- 011:0ddddddddeeeeeeedeeeeeeedeefffffdeef0000deef0f0fdeef00f0deef0f00
-- 012:ddddddddeeeeeeeeeeeeeeeeffffffff000000000f0f0f0ff0f0f0f000000000
-- 013:ddddddd0eeeeeeedeeeeeeedfffffeed0000feed0f00feedf0f0feed0f00feed
-- 014:dddffdddeeffdeeeeefdeeeeffffffff000000000f0f0f0ff0f0f0f000000000
-- 015:ddddddddeeeefeeeeeeffdeeffffdfff000000000f0f0f0ff0f0f0f000000000
-- 016:0eee00e0efffee00fffffff0fff0fff0effefff0effffff00effff0000000000
-- 017:eeeeeee0effffff0efeeeef0efeff0f0efeff0f0ef0000f0effffff000000000
-- 018:1222222212222222122222221222222212222222122222221222222212222222
-- 019:2222222222222222222222222222222222222222222222222222222222222222
-- 020:2222222122222221222222212222222122222221222222212222222122222221
-- 021:8009800098008000999800009988000099808000988098008809980000099800
-- 023:0008900800080089000089990000889900080899008908890089908800899000
-- 024:0000000000088000008800000880800008080000000000800000080000000000
-- 025:0000000000000000000000090000089900080899008908890089908800899000
-- 026:0000000000000000900000009980000099808000988098008809980000099800
-- 027:deef00f0deef0f00deef00f0deef0f00deef00f0deef0f00deef00f0deef0f00
-- 029:00f0feed0f00feed00f0feed0f00feed00f0feed0f00feed00f0feed0f00feed
-- 030:000000000f0f0f0ff0f0f0f000000000ffffffffeeeedfeeeeedffeedddffddd
-- 031:000000000f0f0f0ff0f0f0f000000000fffdffffeedffeeeeeefeeeedddddddd
-- 032:12222222122222221222222212222222122222221222222212222222a1111111
-- 033:222222212222222122222221222222212222222122222221222222211111111a
-- 034:1222222212222222122222221222222212222222122222221222222201111111
-- 035:2222222222222222222222222222222222222222222222222222222211111111
-- 036:2222222122222221222222212222222122222221222222212222222111111110
-- 037:0009990000009900900000009880088899808999998000998988000008880000
-- 038:0000000000000000988000009998008899000809009888000999988008999988
-- 039:0099900000990000000000098880088999980899990008990000889800008880
-- 040:0eeeeeeeeeeeeeeeeeefffffeef00000eef0eef0eef0eef0eef0ff00eef00000
-- 041:eeeeeeeeeeeeeeeeffffffff000000000eeeeef0eeeeeef0ffffff0000000000
-- 042:eeeeeee0eeeeeeeefffffeee00000fee0eee0feeeeee0feeffff0fee00000fee
-- 043:deef00f0deef0f0fdeef00f0deef0000deefffffdeeeeeeedeeeeeee0ddddddd
-- 044:000000000f0f0f0ff0f0f0f000000000ffffffffeeeeeeeeeeeeeeeedddddddd
-- 045:00f0feed0f00feedf0f0feed0000feedfffffeedeeeeeeedeeeeeeedddddddd0
-- 048:3333333122222231222222311111111100011100001110000222000022200000
-- 049:3333333122222231222222311111111100000000000000000000000000000000
-- 050:3333333122222231222222311111111100111000000111000000222000000222
-- 051:8888888887777777877676768767676787777777877877780880888000010001
-- 052:8888888877777777767676766767676777777777777877788880888000010001
-- 053:8888888877777778767676786767677877777778777877788880888000010000
-- 054:ef0f00eef00f0eee00f00fff000000000eeeeef0eeeeeef0ffffff0000000000
-- 055:eeef00feeeef000ffff00f00000000000eeeeef0eeeeeef0ffffff0000000000
-- 056:eef000eeeef00eeeeef00fffeef00000eef0eef0eef0eef0eef0ff00eef00000
-- 057:eeef00eeeeef0eeefff00fff000000000eeeeef0eeeeeef0ffffff0000000000
-- 058:eeef0feeeeef0feefff00fee00000fee0eee0feeeeee0feeffff0fee00000fee
-- 064:0222222022cccc222cc22cd12c2cd1d12c2dd1d12cc11dd111dddd1101111110
-- 067:0111111101111111011111110111111101111111011111110111111101111111
-- 068:1111111111111111111111111111111111111111111111111111111111111111
-- 069:1111111011111110111111101111111011111110111111101111111011111110
-- 070:eeef00eeeeef0eeefff00fff000000000eeeeef000eeeef0f00fff00ef000000
-- 071:eeef00eeeeef0eeefff00fff000000000eeeeef0eeeeef00fffff00f000000fe
-- 072:eef000eeeef00eeeeef00fffeef00000eef00000eeefffffeeeeeeee0eeeeeee
-- 073:eeef00eeeeef0eeefff00fff0000000000000000ffffffffeeeeeeeeeeeeeeee
-- 074:eeef0feeeeef0feefff00fee00000fee00000feefffffeeeeeeeeeeeeeeeeee0
-- 075:0000000000ffffff0ffffffffeedeef0fedeef00fedeef00fedeef000fedeef0
-- 076:00fedeef00fedeef0feedeeffeedeef0fedeef00fedeef00fedeef000fedeef0
-- 077:0002222202223333222322222222222221122222221111110222111100022222
-- 078:2222222233333333222222222222222222222222111111111111111122222222
-- 079:2222200032222220222222222222222222222112111111221111222022222000
-- 080:9999999999999999999999999999999999999999999999999999999999999999
-- 082:0880088008808880000000000000000000088800008880000000000000000000
-- 083:0008000000080000000870000788887078880888800800080008000000080000
-- 084:0007000000070000000760000677776067770777700700070007000000070000
-- 085:0000888000008880000008000000080000000000000000000000000000000000
-- 086:8888888088888880088888000888880000888000008880000008000000080000
-- 087:8880000088800000080000000800000000000000000000000000000000000000
-- 092:88998aa90a889888088898888888888088988800888888008898880008898880
-- 096:9999999999999999aaaaaaaa9999999999999999aaaaaaaa9999999999999999
-- 097:eeeeeeee0edeeeef00edeef0000eef000000f000000000000000000000000000
-- 098:0000000000000000000000000000f000000eef0000edeef00edeeeefeeeeeeee
-- 099:99aa9bba8b998899888888888888888888888888888888888888888888888888
-- 100:0000000000000000000000000000111000012110000111000001101100000001
-- 101:0011110001221110122111111211111111111111011111100000000000011000
-- 102:0000000000000000000000000111000001211000001110001101100010000000
-- 112:aaaaaaaaaaaaaaaa99999999aaaaaaaaaaaaaaaa99999999aaaaaaaaaaaaaaaa
-- 113:aaaaaaa9aaaaaa99aaaaa999aaaa9999aaa99999aa999999a999999999999999
-- 114:9aaaaaaa99aaaaaa999aaaaa9999aaaa99999aaa999999aa9999999a99999999
-- 115:8888888888888888888888888888888888888888888888888888888888888888
-- 116:ffffffff0000000f0000000f0000000fffffffff000f0000000f0000000f0000
-- 117:0088888808899999088888880888888808888888088888880888888000000000
-- 118:8888888899999999888888888888888888888888888888880000000000000000
-- 119:0888888809999999088888880888888808888888088888880000000000000000
-- 120:8888880099998880888888808888888088888880888888800888888000000000
-- 121:eeeeeeeeffefffffffffff0f00000000f000f000f000f000e000e000e000e000
-- 122:0000999900999999099900000990099899000000990000009909888899009999
-- 123:9999000099999900000088808880088000000088000000888888808899880088
-- 128:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 129:fffe0000effffff0e0fffeffe0f0feffe0f0fefee0f0fefee0f0fefee0f0fefe
-- 130:00000eff000ffffffffeff0ffffef00fef0ef00fef0ef00fef0ef00fef0ef00f
-- 131:e0f0fefee0f0fefee0f0fefee0f0fefee0f0feffe0fffeffeffffff0fffe0000
-- 132:ef0ef00fef0ef00fef0ef00fef0ef00ffffef00ffffeff0f000fffff00000eff
-- 133:0898888008988880089888800898888008988880089888800898888008988880
-- 134:0888888808888888088888880888888808888888008888880000000000000000
-- 135:8888888088888880888888808888888088888880888888000000000000000000
-- 136:0898888008988880089888800898888008988880088888800888888000888800
-- 137:e000e000e000e000f000f000f000f00000000000f0ffffffffffffefeeeeeeee
-- 138:9900000099000000990988888800999908800000088800000088888800008888
-- 139:0000008800000088888880889998008800000880000088808888880088880000
-- 144:88998aa90a880088000000000000000000000000000000000000000000000000
-- 145:e0f0fefee0f0fefee0f0fefee0f0fefee0f0fefee0f0fefee0f0fefee0f0fefe
-- 146:ef0ef00fef0ef00fef0ef00fef0ef00fef0ef00fef0ef00fef0ef00fef0ef00f
-- 147:88998aa99a888988908089899080898990808989908089899080898990808989
-- 148:88998aa99a888088980980089809800898098008980980089809800898098008
-- 149:0000000009888880098888800980880009888880000000000898888008988880
-- 150:8888888099999888888888888888888888888888888888800000000000000000
-- 151:0888888888899999888888888888888888888888088888880000000000000000
-- 152:0088880008888880088888800898888008988880089888800898888008988880
-- 153:0000000000002222211112222211112233311113000000000000000000000000
-- 154:0f000ff00f00fff00f000ff00f00fff00f000ff00f00fff00f000ff00f00fff0
-- 160:99dddde99ddddddedececedddeccceeddeeeeeeddeccceeddeeeeeeddddddddd
-- 161:00eeeef00eeeeeefefdfdfeeefdddffeeffffffeefdddffeeffffffeeeeeeeee
-- 162:959999995559cc99757c22c9c72222c9d12221d99d121d9999d1d999999d9999
-- 163:050000005550cc00757c22c0c72222c0d12221d00d121d0000d1d000000d0000
-- 164:99cc8c9099cccc9999999999988888899cccccc99cccccc98cccccc888888888
-- 165:0022330002333330233773332376673333766734333773340333334000334400
-- 176:0cc0cc00c22c22c0c22222c0d12221d00d121d0000d1d000000d000000000000
-- 177:0cc0cc00c00c00c0c00000c0d00000d00d000d0000d0d000000d000000000000
-- 178:000cc000000c0000000c0000000c0000000c0000000d0000000d0000000dd000
-- 179:000cc0000000c0000000c0000000c0000000c0000000d0000000d000000dd000
-- 180:00000ccc0000cddc000cdddc11cdddc0121ddc000121c0002312100022011000
-- 181:c00002220302200c003000c002030c0002003000200c030020c000c02c000000
-- 182:0006000000666000066666006666666000555000006660000055500000555000
-- 183:0000000000cccc000000cc00000dd00000000000000dd0000000000000000000
-- 184:0dddddd0dddddddddddeedddddeeeedddeeeeeedddddddddedddddde0eeeeee0
-- 185:0dddddd0dddddddddeeeeeedddeeeedddddeedddddddddddedddddde0eeeeee0
-- 186:0dddddd0ddddeddddddeedddddeeeddddddeedddddddedddedddddde0eeeeee0
-- 187:0dddddd0dddedddddddeeddddddeeedddddeeddddddeddddedddddde0eeeeee0
-- 188:0666666066666666667777666666766666676666667777667666666707777770
-- 189:0222222022122122221221222221122222122122221221221222222101111110
-- 190:0aaaaaa0aaa99aaaaa9aa9aaaa9999aaaa9aa9aaaa9aa9aa9aaaaaa909999990
-- 191:0333333033322233332333333332233333333233332223332333333202222220
-- 192:00000ccc0000cddc000cdddc11cdddc0121ddc000121c0002312100022011000
-- 193:000c200000c002000c0000203333333c0c00002000c00200000c200000000000
-- 194:0002000000c0200000c0020000c0020000c0020000c020000002000000000000
-- 200:00cc00000000cc0000000cc0000000cc00000ccc0cccccc0ccccccc00cccc000
-- 201:0000000000000000000000000000000c000000cc0cccccc0ccccccc00cccc000
-- 202:000000000000000000000000000000000000000000000000cccc00c00cccc000
-- 204:2666666266666666667777666666766666676666667777667666666727777772
-- 208:0000000000288020082282200882220008853500008333000082200000808000
-- 209:0028802008228220088222000885350000833300008220000082200000800800
-- 210:0000000000288020082282200882220008853500008333000082200008000800
-- 211:0028802008228220088222000885350000833300008220000082200008008000
-- 212:0000000000000000001001000011110003311330635225306322223600600006
-- 213:0000000000000000001001000011110003311330035225366322223660000600
-- 214:0000000000000000002002000022220002222220022222202222222220200202
-- 215:c000000cdc0000cd0dc77cd00075670000766700000770000000000000000000
-- 216:00000000000000000007700000756700007667000cd77dc0cd0000dcd000000d
-- 217:0f0ee0f0ffeddeff0ed22de0ed2431deed2331de0ed11de0ffeddeff0f0ee0f0
-- 218:0000000400000344000333440002221100033322000333220003332200033322
-- 219:4000000044100000441110001122200022111000221110002211100022111000
-- 220:0000000400000344000333440002221100033322000333220003332200033322
-- 221:4000000044100000441110001122200022111000221110002211100022111000
-- 222:0000000400000344000333440002221100033322000333220003332200033322
-- 223:4000000044100000441110001122200022111000221110002211100022111000
-- 228:0033000000033000003333000333333003333330033434300333333000333300
-- 229:0000000000030000000000000033330003333330033434300333333000333300
-- 230:0030000000000000003033000333333003343430033333300333333000333300
-- 231:0000000000033000003333000333333003343430033333300333333000333300
-- 232:002b2200b222222b22b22b22b222222b2222222222a88a288288882880800800
-- 233:0022b200b222222b22b22b22b222222b2222222282a88a228288882800800808
-- 234:000339c200033cc2060111115660033666600065666a9a650608886600000006
-- 235:2c9110002cc11000111110006220006066000665669a96666688866660000060
-- 236:000339c200033cc2000111360600036556600065666a9a666668888606000000
-- 237:2c9110002cc11000621110006620006066000665669a96666888866600000060
-- 238:000339c200033cc2000111110600033656600065666a9a656668886606000006
-- 239:2c9110002cc11000111110606220066566000666669a96666688806060000000
-- 240:0222220022222220228882203300033033333330228882202200022088000880
-- 241:2200022022200220222202203383333033083330220082202200022088000880
-- 242:2222222022222220882228800033300000333000002220000022200000888000
-- 243:2200022022000220220002203300033033303330822222800822280000888000
-- 244:0222220022222220228882203300033033333330228882202200022088000880
-- 245:2200022022200220222202203383333033083330220082202200022088000880
-- 246:0022200000888000000000000033300000333000002220000022200000888000
-- 247:0222220022222220228882203300033033333330228882202200022088000880
-- </TILES>

-- <SPRITES>
-- 000:6666666666666666666666666666666866666660666668886666889966668999
-- 001:6666666666666666668888888888999908888999000888998880088899880800
-- 002:6666666666666666886666669880886699880888999808988888089900000899
-- 003:6666666666666666666666666666666666666666866666668666666688666666
-- 004:6666688866688888666888996668899966888999668899996688999866888888
-- 005:8866666689866666988808889888009899888099889880998888808800888000
-- 006:6666666666666688666668888088000888088800980898808808998000089988
-- 007:6666666688886666888886660888866608888866008888660008886600008866
-- 008:6666666666666666666666666666666666666666666666666666666666666666
-- 009:6666666666666666666666666666666666666666666688886888889960088889
-- 010:6666666666666666666666666666666666666666888866669998808899998808
-- 011:6666666666666666666666666666666666666666666666666666666688666666
-- 012:0000000000000000000000000000000f000000fe00000fee0000feee000feeed
-- 013:000000000000000000ffffffffeeeeeeeeeeeeeeeeeeeeffeeeeefddddeefd00
-- 014:0000000000000000fff00000eeefff00eeeeeeffffffeeeeddddfeee0000dfee
-- 015:0000000000000000000000000000000000000000f0000000f0000000ef000000
-- 016:6668888966600888668800886888800088999880889999888899998888988888
-- 017:9998000199880011888001128880012200000122808001228080011280880011
-- 018:1110088922220088233220083343200833432000333320082332200822220089
-- 019:9866666698666666886666660066666688666666986666669866666698666666
-- 020:6668888066608880668800086689888066899998880888888880000089988880
-- 021:0008001100880122880001230001113380012233800122330001122398001122
-- 022:1008899822008898322008884320080043200088332008983220089822008998
-- 023:0888866600006666008866660088666608886666088666666666666666666666
-- 024:6666666866666688666668896666889966668889666600006666888066688988
-- 025:8800088898888008999988089999980099998800999980010088800180000001
-- 026:9999980888888808000000080111100811222200122332202233432022334320
-- 027:9886666699866666998866668998666688986666088866660800666600886666
-- 028:00feeedd00feeedd00feeeee00feeeee00feeeee00ffeeee00ffeeee00fffeee
-- 029:deefd007eefd0077efd00776efd00766efe00766efe00766efe00776eefe0077
-- 030:77700dfe666600df6556600d55c5600d55c5600e5555600e6556600e666600ef
-- 031:ef000000eef00000fef00000fef00000fef00000fef00000fff00000ff000000
-- 032:6888888066000000660888886608899966899998668999886689888066888800
-- 033:0088800180008800888000088000000000808888088089990880899988008999
-- 034:1110089900008899880088890080888880800880880000009880000899800008
-- 035:9866666680086666808866660008888688008888880088888880088888008888
-- 036:8899998068899980688888006660000966688888666888806666666066666666
-- 037:9980011199980000998008888800899980088888008800000000000088088888
-- 038:1008999800889986008889868088886680088666886666660066666608666666
-- 039:6666666666666666666666666666666666666666666666666666666666666666
-- 040:6688999966889998668998886889888068888800688880086888008868800888
-- 041:8880800188808001000098000880098088880998898800009800888880889980
-- 042:2233332012233220112222000111100800000088088800880880000000008888
-- 043:0898666608986666899866669998666699806666898088660000088688800888
-- 044:00ffffee000fffff000fffff0000ffff00000fff000000000000000000000000
-- 045:eeefe007ffffff00fffff00fffff00fffff00fff0000ff000000000000ff0fff
-- 046:77700eff0000ffffff00fffffff0fffffff00ff000ff000000000000ff0f0000
-- 047:ff000000f0000000f00000000000000000000000000000000000000000000000
-- 048:6680000866680089666660886666660066666680666666896666890866668880
-- 049:9808889998088989980898888808888800668888806666668866666688666666
-- 050:9980080899800886889088868880800886668008666608086666008066660808
-- 051:8000088880000088680000866688886666666666666666668866666688666666
-- 052:6666668066666898666689886666008866668808666600886668890866688880
-- 053:0800899808808880808008088080666680066666066666668666666686666666
-- 054:0808866680088866008888866600888866608088666608886666608066666808
-- 055:6666666666666666666666666666666666666666666666668866666688666666
-- 056:6660088866660880666660006666660066666680666666896666890866668880
-- 057:0889880088988008889800888888088908800089008800888008866688666666
-- 058:8880889988008899980888998808888988088898880889888808898866688888
-- 059:9988008899988008999980089999800899998008888890088888808688800666
-- 060:000000000000000f000000ff00000000000000ff000000ff0000ff0f0000fff0
-- 061:f00f00ffff0ff0ffff00f00ffff000000ff00000f0000000ff000000ff000000
-- 062:ff0f0f00f0f00ff00f00fff00000ff0f0000f0ff00000fff000000f000000f0f
-- 063:000000000000000000000000000000000000000000000000ff000000ff000000
-- 064:6666666666666666666666666666666166666660666661116666112266661222
-- 065:6666666666666666661111111111222201111222000111221110011122110100
-- 066:6666666666666666116666662110116622110111222101211111012200000122
-- 067:6666666666666666666666666666666666666666166666661666666611666666
-- 068:6666611166611111666111226661122266111222661122226611222166111111
-- 069:1166666612166666211101112111002122111022112110221111101100111000
-- 070:6666666666666611666661111011000111011100210121101101221000012211
-- 071:6666666611116666111116660111166601111166001111660001116600001166
-- 072:6666666666666666666666666666666666666666666666666666666666666666
-- 073:6666666666666666666666666666666666666666666611116111112260011112
-- 074:6666666666666666666666666666666666666666111166662221101122221101
-- 075:6666666666666666666666666666666666666666666666666666666611666666
-- 080:6661111266600111661100116111100011222110112222111122221111211111
-- 081:2221000f221100ff11100ffe11100fee00000fee10100fee10100ffe101100ff
-- 082:fff00112eeee0011eddee001ddcde001ddcde000dddde001eddee001eeee0012
-- 083:2166666621666666116666660066666611666666216666662166666621666666
-- 084:6661111066601110661100016612111066122221110111111110000012211110
-- 085:000100ff00110fee11000fed000fffdd100feedd100feedd000ffeed2100ffee
-- 086:f0011221ee001121dee00111cde00100cde00011dde00121dee00121ee001221
-- 087:0111166600006666001166660011666601116666011666666666666666666666
-- 088:6666666166666611666661126666112266661112666600006666111066611211
-- 089:11000111211110012222110122222100222211002222100f0011100f1000000f
-- 090:2222210111111101000000010ffff001ffeeee00feeddee0eeddcde0eeddcde0
-- 091:2116666622166666221166661221666611216666011166660100666600116666
-- 096:6111111066000000660111116601122266122221661222116612111066111100
-- 097:0011100f10001100111000011000000000101111011012220110122211001222
-- 098:fff0012200001122110011120010111110100110110000002110000122100001
-- 099:2166666610016666101166660001111611001111110011111110011111001111
-- 100:1122221061122210611111006660000266611111666111106666666066666666
-- 101:22100fff22210000221001111100122210011111001100000000000011011111
-- 102:f001222100112216001112161011116610011666116666660066666601666666
-- 103:6666666666666666666666666666666666666666666666666666666666666666
-- 104:6611222266112221661221116112111061111100611110016111001161100111
-- 105:1110100f1110100f000021000110021011110221121100002100111110112210
-- 106:eedddde0feeddee0ffeeee000ffff00100000011011100110110000000001111
-- 107:0121666601216666122166662221666622106666121011660000011611100111
-- 112:6610000166610012666660116666660066666610666666126666120166661110
-- 113:2101112221011212210121111101111100661111106666661166666611666666
-- 114:2210010122100116112011161110100116661001666601016666001066660101
-- 115:1000011110000011610000166611116666666666666666661166666611666666
-- 116:6666661066666121666612116666001166661101666600116661120166611110
-- 117:0100122101101110101001011010666610066666066666661666666616666666
-- 118:0101166610011166001111166600111166601011666601116666601066666101
-- 119:6666666666666666666666666666666666666666666666661166666611666666
-- 120:6660011166660110666660006666660066666610666666126666120166661110
-- 121:0112110011211001112100111111011201100012001100111001166611666666
-- 122:1110112211001122210111221101111211011121110112111101121166611111
-- 123:2211001122211001222210012222100122221001111120011111101611100666
-- 124:0000000000000000000000cc0000000c0000cc0000000ccc0000cccc0ccccccc
-- 125:cc0000000cc0000000cc0000c00cc000cc00cc00ccccccc0cccccccccccccccc
-- 126:000000000000000000000000000000cc000cc00c0000cccc00cccccccccccccc
-- 127:00000000000000000cc0000000cc00c0c00cc0cccccccccccccccccccccccccc
-- </SPRITES>

-- <MAP>
-- 000:410505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050583939393939393939393939393939393939393939393939393939393939393
-- 001:410505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050583939393939393939393939393939393939393939393939393939393939393
-- 002:410505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050583937494949494949494949494949494949494949494949494949494946493
-- 003:41050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505058374a425151525252525151515151515151515151515252525251515258464
-- 004:410505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505052030304005050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050583a32515151515252515151515151515151515151515152525151515152583
-- 005:410606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606203030303030402131314106060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060684a40313131313131313131313131313131313131313131313131313132383
-- 006:410707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707072040213131313131313131314140070707070707070707070707070707070707070707070707070720304007070720304007070707072030304007071007070704042515151515252515151515151515151515151515152525151515152583
-- 007:410808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080820402131313131313131313131313131204008080808080820303040080808080808080808080808204021314120304021314120400808080232321208080808080804042515151515252515151515151515151515151515152525151515152583
-- 008:410808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808081727080808080808080808080808080808080808080808080808080808080808080808080808172708080808080808080808080808080808080808080808080808080808082030303040080802323131313131313131313131313131314140080808204021313141204008172708081008081008023231313131313131313132120808080808080808080808204082929292a21515252515151515151515151515151582929292929292929263
-- 009:410808080808080808080808080808080808080808080808080808080808080808081727080808080808080808080808080808080808080808080808080808080808170505270808080808080808172708080808080808080808172708080808080808080808080817050527080808080808080808080808080808080808080808080808080808202131313141080808082131313131313131313131313131323212080808023131313131311217051027080808080808080802323232323232321208080808080808080808080820214183749494a41515252515151515151515151515151583939393939393939393
-- 010:410808080808080808080808080808080817270808080808080808080808080808170505270808172708080808080808080808172708080808080808080808080817050505052708080808172717050527080808080808080817050527080808080808172708081705050505270808080817270808080808080808080817270808080808080808213131313141400808080232313131313232323131313212080808081727080232323232121705050505270808080808080808080817050527080808080808080817270808172721314183a32515151515252515151515151515151515151584a41616168494949464
-- 011:410808172708080808080808080808081705052708080808172708080808080817050505052717050527080808080808080817050527080817270808080808081705050505050527080817050505050505271727080808081705050505270808080817050527172030400505052708081705052708081727080808081705052708081727082040213131313131410808172708213131411515152131410808081727170505271705050505050505050505052708080808172708081705050505270808080817271705052717052021314183a32515151515252515151515151515151515151515152525151515152583
-- 012:410817050527080817270808080808170505050527080817050527080808081705050505050505050505270808172708081705050505271705052708080808170505050505050505271705050520303040050505270808170505050505052708081705050505052131412030400527170505050527170505270808170505050527170505272131313131313131412040050527213131411515152232120808170505050505050505050505050505050505050527080817050527170505050505052708081705050505050505202131314183a32515151515252515151515151515151515151515152525151515152583
-- 013:411705050505271705052717272030400505050505271705050505271727170505050505050520303030402717050527170505050505050505050527172717050505050505050505050505204021313141204005052717050505050505050527170505052030402131313131410505050505050505050505052717050505050505050520402131313131313131313141050520213131411515150404042717050520303030303030303030303030303040050505271705050505050505050505050527170520303030303040213131314183a32515151515252515151515151515151515151515152525151515152583
-- 014:41050a052a05050505050505202131414005050505050505203040050505050505050505052021313131414005050505050505050505050505050505050505050505050505050505050505213131313131314105050505050505050505050505050505052131313131313131412030400505050505050505050505050505050505050521313131313131313131313212050521313131411515150404040505052021313131313131313131313131313141400505050505050505050505050505050505052021313131313131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 015:4120303030303030303030402131cc314120303030303040213141203030303030303030402131313131314120303030303030304005050505050505050520303030303030303030303040213131313131314120303030303030303030303030303030402131313131313131313131412030303030303030303030303030303030304021313131313131313131410505052021313131411515152030303030402131313131313131313131313131313131412030303030303030303030303030303030402131313131313131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 016:313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131314140050505050505050521313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313232420505052131313131411515152131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131314183739292929292929292929292929292929292929292929292a21515152583
-- 017:313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313141401515151515152021313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313232421545151515202131313131411515152131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131314183939393939393939393939393939393939393939393939393a31515152583
-- 018:3131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131314115151515151521313131313131313131313131313131313132323232323131313131313131313131313131313131313131313131313131313131313131313131313131313131313132323232323232324215351515451515152131313131314115151521313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313141837494949494949494949494949494949494a4161616168494a41515152583
-- 019:313232323232323232323232313131313131313132323232323232323232313131313131313131313131313131313131313131313131412040151515202131313131313131313131313131313232421515451515223231313131313131313132323231313131313131313131313131313131313131313131313131313131421515451535151545151535151515152040213131313131411515152131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131314183a3fb15151515252515151515151515151515151515152525151515152583
-- 020:411545153545153515451515223231313131324215351515451535154515213131323232313131323232313131313131313131313131323242151515213131313131313131323232323232424515351515451515153522323232323232324215351521313131313131313131313131313131313131313232323232323242351515451535151545151535151515152131313131313131411515152131313131313131313131313131313131313131313131313232323231313131313131313131313131313131313131313131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 021:411545153545153515451515351522323242154515351515451535154515213141153515223242154515223231313131313131313141154515151520213131313131313142154515351545151515351515451515153515153515451535154515351522323232323131313131313131313132323232421515351515451515351515451535151545151515151520402131313131313131411515152131313131313131323232313131313131313131313131421545153522323131313131313131313131313131313131313131313131314183a32510101010252515151515151515151515151515152525151515152583
-- 022:4115151535451535154515153515153515151545153515154515351545152232421535154515351545153515213131313131313232421545151515213131313131313141351545153515451515153515154515151535151535154515351545153515451535151522323131313232323242351515451515153515154515153515154515351515151515151515213131313131313131314115151521313131313132421515352232323232323232323232421515451535153522323231313131313131313131313131313131313131313141837392929292929292a2151515151515151515151515152525151515152583
-- 023:4115151515451535154515153515153515151545153515154515151545151535151535154515351515153515223131313131411535151515151520213131313131313141351545153515151515151515154515151535151535151515351545151515451535151545152232421515451515351515451515153515154515153515154515351515151515152040213131313131313131314115151521313131314215451515351515154515153515154515351515451535153515451522323232323232323131313131313131313131313141839393939393939393a3151515151515151515151515152525151515152583
-- 024:4115151515451535154515151515153515151545153515151515151545151535151515154515351515153515452232323232421535151515151521313131313131313142351545153515151515151515151515151515151535151515351545151515451535151545151545151515451515351515151515153515154515153515151515351515151515152131313131313131313131314115151521313131411515451515351515154515153515154515351515451535153515451515153515154515152231313131313131313131313141837494949494949494a4151515151515151515151515152525151515152583
-- 025:411515151515151515451515151515351515154515351515151515154515153515151515451535151515151545151535154515151515151520402131313131313131411535154515151515151515151515151515151515151515151535151515151545151515154515154515151515151535151515151515351515451515151515151535151515152040213131313131313131313131411515152232323242151545151535151515451515351515451535151515151515351545151515351515451515352231313131313131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 026:411515151515151515451515151515351515154515151515151515151515151515151515151535151515151545151535154515151515151521313131313131313131421535154515151515151515151515151515151515151515151515151515151545151515151515154515151515151515151515151515151515451515151515151515151515152131313131313131313131313131411515151515451535151515151535151515451515351515151535151515151515351545151515351515451515351522313131313131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 027:411515151515151515151515151515151515154515151515151515151515151515151515151515151515151515151535154515151515204021313131313131313141151535151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515451515151515151515151515202131313131313131313131313131411515151515451535151515151535151515451515351515151535151515151515351545151515351515451515351515223131313131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 028:41151515db151515151515151515151515151515151515151515151515151515151515151515151515151515151515351515151515152131313131313131313131421515351515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515152131313131313131313131313131314115151515154515351515151515351515151515153515151515151515151515153515151515153515154515153515153522323232313131313141837392a2151582929292929292a22626262682929292929292929292929263
-- 029:4115151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515152030402131313131313131313141451515351515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515152030402131313131313131313131313131314115151515151515351515151515151515151515151515151515151515151515153515151515151515154515151515153515451515223131313141836464a3151583646464646464739292929263646464646464646464646464
-- 030:4115151515151515151515151515203030401515151515151515151515152030401515151515151515151515151515151515152131313131313131313131313142451515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515152131313131313131313131313131313131314115151515151515351515151515151515151520304015151515151515151515151515151515151515154515151515153515451515352231313141837494a415158494a4161616168494949494a4161616168494949494949464
-- 031:411515101010151515151515204021313141204015151515151515151515213141151515203040151515151515151515203040213131313131313131313131421545151515151515151515151515151520304015151515203040151515151515151515151515151515151515151515151515151520304015151515151515151515203040213131313131313131313131313131313131411515151515151515151515151515151515202131414015151515151515151515151515151515151515151515151515351545151535152232314183a32515151515252515151515151515151515151515152525151515152583
-- 032:412030303030303030303040213131313131314120303030303030303040213141203040213141203030303030303040213131313131313131313131313142151545151515151515203030303030304021314120303040213141203030303030303030303030303030303030303030303030303021314130303030303030303040213131313131313131313131313131313131313131412030303030303030303030303030303040213131314120303030303030303030304015151515151515151515151515351545151535154515214183a32515151515252515151515151515151515151515152525151515152583
-- 033:313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131314235151545151515151520213131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131314140151515151515151515151515351515151535154515214183a32515151515252515151515151515151515151515152525151515152583
-- 034:313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131411535151515151515151521313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313141304015151515151515151515351515151515154515214183a32515151515252515151515151515151515151515152525151515152583
-- 035:313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131411535151515151515152021313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131314115151515151515151515351515151515154515214183a32515151515252515151515151515151515151515152525151515152583
-- 036:313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131411535151515151515202131313131313131313131313131313131323231313131313131313131313131313131313131313131313131313131313131313131313131313131313232323131313131313131313131313132323232313131313131313131313131313131313131313131313131313131313131313131313131314120304015151515151515151515151515151515214183a32515151515252515151515151515151515151515152525151515152583
-- 037:313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131411515151515151515213131313131323232323131313232323242153522323131313131313131313131313232323232323232323131313131313131313131313131313132421545152232323232323232323232324215351515323131313131313131323232323231313131313131313131313131313131313131323232323231314115151515151515151515151515151515214183a32515151515252515151515151515151515151515152525151515152583
-- 038:31313131313131313131313131313131313131313131313131313131313131313131313132323131313131313131313131313131313131313131313141151515151515152021313131314115351515223242153515451515351545223131313131313131313242151535151515451515223232323232323232313131313131423515154515153515154515351515351545151535151535223232323232324215351535152231313131313131313232323231313131314235151545152131412040151515151515151515153a151a15214183739292929292929292929292a22626262682929292929292a21515829263
-- 039:313131313131313131313131313131313131313131313131313131313131313131313142154522323231313131313131313131313131313131313131411515151515151521313131313142153515151545151535154515153515451522323232323232324215451515351515154515153515351515451515352232323232421535151545151535151545153515153515451515351515351545153515154515153515351515223232313131324215451515223232324215351515451522323131414015151515151515152030303030214183939393939393939393939393739292929263939393939393a31515839393
-- 040:31313131313131313131313131313131313131313131313131313131313132323232423515451515352232323232323232323232323232323231313141151515151515202131313132421515351515154515153515451515351545151515351535154515351545151535151515451515351535151545151535151545151535153515154515153515154515351515351545151535151535154515351515451515351535151545153522324215351545151535151545151535151545151545223131411515151515151515213131313131418374949494949494a4161616168494949494a4161616168494a41515849464
-- 041:313131313131313131313131313131313131313131313131313131313242451515351535154515153515154515153515451515351515451535213131414015151520402131313142154515153515151545151535151515153515451515153515351545153515451515351515154515153515351515451515351515451515351515151515151535151545151515153515451515351515351515153515154515151515351515451535154515153515451515351515451515351515451515451522314115151515203030402131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 042:313131313131313131313131313131313131313131313131313131411515451515351535154515153515154515153515451515351515451535223231314115151521313131324215154515153515151545151515151515153515451515153515151545153515451515351515151515153515151515451515351515451515351515151515151535151545151515153515151515351515151515153515154515151515151515451535154515153515151515351515451515351515451515451535224215151515213131313131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 043:313131313131313131313131313131313131313131313131313131411515451515351515151515153515154515153515151515351515451535151522314140151522323242153515154515151515151515151515151515151515451515153515151515153515451515151515151515153515151515151515351515451515151515151515151515151545151515153515151515151515151515153515151515151515151515451535154515151515151515351515451515151515151515451535154515151520213131313131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 044:313131313131313131313131313131313131313131313131313131411515451515351515151515153515154515153515151515351515451515151535223141151515154515153515154515151515151515151515151515151515151515153515151515153515151515151515151515151515151515151515351515451515151515151515151515151515151515151515151515151515151515151515151515151515151515151535154515151515151515151515451515151515151515151535154515151521313131313131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 045:313131313131313131313131313131313131313131313131313131411515151515351515151515151515151515153515151515151515451515151535152241401515154515153515151515151515151520303030401515151515151515153515151515151515151515151515151515151515151515151515351515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151535151515151515151515151515451515151515151515151535154515152021313131313131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 046:313131313131313131313131313131313131313131313131313131411515151515151515151515151515151515151515151515151515151515151535151522421015154515151515151515151515151521313131414015151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515152030304015151515151515151515152030303040151515151515151515151515151515151535151515152131313131313131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 047:313131313131313131313131313131313131313131313131313131411515151520303040151515151515151515151515151515151515151515151535151515151515151515151515151515203030304021313131314140151515151515151515151515151515151515151515203030304015151515151515151515151515151515151515151515151515151515152030304015151515151515202131314115151515152030303030402131313141204015151515151515151515151515151515151515202131313131313131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 048:313131313131313131313131313131313131313131313131313131411515152021313141401515151515151515151515151515151515151515151515152030303030401515151515151515213131313131313131313141203040151515151515151515151515151515203040213131314120304015151515151515151515151515151515151515151515151520402131314120401515152040213131314120303030402131313131313131313131314120304015151515151515151515151515151515213131313131313131313131314183a32515151515252515151515151515151515151515152525151515152583
-- 049:3131313131313131313131313131313131313131313131313131314120304021313131314120303030303030303040101515151510203030303030304021313131314120303030303030402131313131313131313131313131412030303030303030303030303030402131313131313131313141203030303030303030303030303030303030303030303040213131313131314120304021313131313131313131313131313131313131313131313131313141203030303030303030303030303030402131313131313131313131313141837392a2151582929292929292929292929292929292929292929292929263
-- 050:3131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313141101015151010213131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313141836464a3151583646464646464646464646464646464646493939393936464
-- 051:1515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151571101515151510511515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515837494a415158494a4161616168494949494a4161616168494949494949464
-- 052:151515151515151515811515151515151515151581151515151515151515151515151515151515151515151515157110151010151051151515811515151515151515151515158115151515151515151515151515151515811515151515151515151515151515158115151515151515151515151515811515151515151515158115151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151583a32515151515252515151515151515151515151515152525151515152583
-- 053:151515811515151515151515151515151515151515151515151515811515151515151515151515151515151515157110151515151051151515151515151581151515151515151515151515151515151515811515151515151515151515811515151515151515151515151515158115151591626262626262a115811515916262626262626262a1158115151515151581151515151515151515151515151515158115151515151515151515151515916262626262a11581151515151515151515158115916262626262626262a11581151583a32515151515252515151515151515151515151515152525151515152583
-- 054:15916262626262a1151515151515811591626262626262a115151515151515151515151515151515151591626262a0101015151010906262a115151515151515159162626262a1151515151581151515151515151515151515151515151515151581151591626262626262626262626262a01555651575555262626262721555651575157515906262626262a11515151515151515811515151581159162626262626262626262626262a1158115511515657515511515151515158115151591626262a01555651575157515511515151583a32515151515252515151515151515151515151515152525151515152583
-- 055:1571155515155590626262a115151515711565751575759062626262626262626262a115151591626262a055657515151515151515151575906262626262626262a015651575511515151515151515916262626262626262a115811515151515151515155115556575151565751515751515151515151515151565157515151515151515151515155565157590626262626262a11515151515151515511515556515155515156515551590626262a01515151515906262a11515151515151571156575151515151515151515906262151583a32515151515252515151515151515151515151515152525151515152583
-- 056:15711515151515155565159062626262a01515151515151515156515151565751515511515157115651515151515151515151515151515151555651515157515151515151515906262626262626262a01515156575151515511515151515159162626262a015151515151515151515151515151515151515151515151515151515151515151515151515151515151565751575906262626262626262a015151515151515151515151515151565151515151515151515159062626262626262a0151515151515151515151515151575511583a32515151515252515151515151515151515151515152525151515152583
-- 057:8171151515151515151515151555657515151515151515151515151515151515151590626262a01515151515151515151515151515151515151515151515151515151515151515151565151575157515151515151515151590626262626262a0556515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515155565151515151515151515151515151515151515151515151515151515151515151555155565155515151515151515151515151515151515511583a32515151515252515151515151515151515151515152525151515152583
-- 058:157115151515151515151515151515151515151515151515151515151515151515151555156515151515151515151515151515561515151515151515151515151515151515151515151515151515151515151515151515151515551565751515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515511583739292929292929292929292a21515151582929292929292929292929263
-- 059:157115151515151515151515151515151515151515151515151515151515151515151515151515151515151515151550808060807015151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515518183939393939393939393939393a31515151583939393939393939393939393
-- 060:1571151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515511515158171151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151546566615151515151515151515151515151515151515151515151515151515154656661515151515151515151515151515151515151515151515151515151515151515151515155115837494949494a4161684949494a41515151584949494a41616849494949464
-- 061:1571151515151515151515151515151515151515151515151515151515151515151515151515151515151515151550a081151515907015151515151515151515151515151515151515151515151515151515154656151515151515151515151515151515151515151515151515151515151515d4e4e4e4f4151515151515151515151515151550806080807015151515151515151515151515151515151515151515151515151550806080807015151515151515151515151515151515151515151515151515151515151515151515511583a32515151515252515151515151515151515151515152525151515152583
-- 062:817115151515151515151515151515151546561515151515151515151515151515151515151515151515151515155115151515151571151515151515151515151515151515151515151515151515151515155080807015151515151515151515151515151515151515151515151546566615151515b4151515151515151515d4e4e4e4f415155115151515711515d4e4f41515151515151515151515151515151515d4e4f4151551151515157115155666151515151515151515151515151515151515151515151515151515151515511583a32515151515252515151515151515151515151515152525151515152583
-- 063:15711515151515151515151515151550806060701515151515151515151515151515151515151515151515151550a015151515151590701515151515151515151515151515151515151515151515151515155115157156661515151515151515151515151515151515151515508080608070151515c415151515d4e4f415151515b415151515511581151571151515c4151515d4e4f415151515151515d4e4f4151515c415151551158115159060806080808060701515151515151515151515151515151515151515151515151556511583a32515151515252515151515151515151515151515152525151515152583
-- 064:15711515151515151515151515151551811515711515151515151515154656508070151515151515151515151551151515151581151571151515151515151515151515151515151515151515151515155080a015159060701515151515151515151515151515151515151515511515151571151515c41515151515b41515151515c415151515511515151571151515c415151515c4151515d4e4f4151515c415151515c415151551151515151515151515151515716615154656151515151515151515151515151515151515151550a01583a32515151515252515151515151515151515151515152525151515152583
-- 065:1571465666151a153a155666151550a0151515907015151515155615155060a015908070151515566615151550a015151515151515159070155666151515151515151556151515151515154656151515511515811515157115151515151515154656661515d4e4e4e4f41515511581151571151515c41515151515c41515151515c415151515511515151571151515c415151515c415151515c415151515c415151515c41515155115151515151515158115151590608080608060808080706615465666151515151515151515465115158373a2151515158292929292929292929292929292929292a2151515158263
-- 066:1590606060608080608060806060a01515158115906060808080606060a01515811515906060806060808060a01515811515151515811590606080606060606060808080606060608080606060806060a015151515151590608080606080808080606070151515b415151515511515151571151515c41515151515c41515151515c415151515511515811571151515c415151515c415151515c415151515c415151515c4151515511515811515151515151515151515151515151581151590608060608060701015151515105080a015158393a3151515158393939393939393939393939393939393a3151515158393
-- 067:15151515151515158115151515151515151515151515151581151515151515151515151515151581151515151515151515151515151515151515151515151581151515151515151515158115151515151515151515158115151515151515811515151571090909c509090909511515811571090909c50909090909c50909090909c509090909511515151571090909c509090909c509090909c509090909c509090909c50909095115151515151515151515151515158115151515151515151581151515157110151515151051151581158374a4151515158494a4161684949494949494a416168494a4151515158464
-- 068:151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515150000000000000000151515151515000000000000000000000000000000000000000015151515151500000000000000000000000000000000000000000000000000000015151515151515151515151515151515151515151515151515151515151571101515151510511515151583a32515151515252515151515151515151515151515152525151515152583
-- 069:1515151515151515151515151515151515151515151515151515151515151515158115151515151515151515151515151515811515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515811515151515158115151515151515151515151515158115151591626262a010151515151090a115151583a32515151515252515151515151515151515151515152525151515152583
-- 070:1515158115151515158115151515151515151581151515151515151515916262626262626262626262a1158115151515151515151515151515151515158115151515151515151515151515151581151515151515151515151515151515158115151515151515151515151515151515151581151515151515158115151515158115151515151515811515151515151515151515811515151515811515151515151515811515159162626262626262a1151515151515151581159162626262626262a055651515151515151515155181151583a32515151515252515151515151515151515151515152525151515152583
-- 071:15159162626262626262626262a11515811515151515151515158115157115651555151555651555159062626262626262a11515151515811515151515151515151515811515151515151515151515151515151581159162626262626262626262626262a11515151581151515151515151515151591626262626262626262626262a115151515151515151515158115151591626262626262626262a1151581151515916262a055151565155515511515811515151515151571156555156515151515151515151515151515155115151583a32515151515252515151515151515151515151515152525151515152583
-- 072:1591a05515155565151515551551151515151515159162626262626262a01515151515151515151515151555151565551551151515151515159162626262626262a11515151515151581151591626262626262626262a0156575151555151555651575155115811515151591626262626262626262a055151565155515155565151551151581159162626262626262626262a05515551515556515555115151515151571551515151515151515159062626262626262626262a0151515151515151515151515151515151515155115151583a32515151515252515151515151515151515151515152525151515152583
-- 073:157115151515151515151515159062626262626262a05515151565151515151515151515151515151515151515151515159062626262626262a0156515155515159062626262626262626262a05515155515156515551515151515151515151515151515511515151515157115651515551515657515151515151515151515151515511515151571151565751565155565151515151515151515151590626262626262a015151515151515151515151565155515156515551515151515151515151515151515151515151515155115151583739292929292929292929292a21515151582929292929292929292929263
-- 074:1571151515151515151515151515151555655515151515151515151515151515151515151515151515151515151515151515151555651555151515151515151515151515556515751515651515151515151515151515151515151515151515151515151590626262626262a0151515151515151515151515151515151515151515159062626262a01515151515151515151515151515151515151515151515556575151515151515151515151515151515151515151515151515151515151515151515151515151515151546565115811583749494949494949494949494a41515151584949494949494949494949464
-- 075:15711515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515155515657555151515151515151515151515151515151515151515151515151565155515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515155080806060808080a015151583a32515151515252515151515151515151515151515152525151515152583
-- 076:817115151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515155651151515151515151515151583a32515151515252515151515151515151515151515152525151515152583
-- 077:1571151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515155060a0158115151515151515151583a32515151515252515151515151515151515151515152525151515152583
-- 078:157115151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515d4e4e4e4f415151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515511515151515151515811515151583a32515151515252515151515151515151515151515152525151515152583
-- 079:1571151515151515151515151515151515151515151515151515151515151515151515151515151515151515151546566615151515151515151515151515151515151515b415151515151515151515151515151515151515151515d4e4e4e4e4e4f415151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515d4e4e4e4f415151515151515151515151515151515151515151515151515151515151515151515151515155080a01515151515151515151515151583a32515151515252515151515151515151515151515152525151515152583
-- 080:1571151515151515151515151515151515151515151515151515151515151515151515151515151515151515155060808070151515151515151515151515151515151515c415151515d4e4f4151515151515151515151515151515151515b415151515151515151515151515151515151515151515151515151515151515151515151515151515465666151515d4e4e4e4e4e4f415151515b4151515151515151515d4e4e4e4f415151515151515151515151515151515151515151515151515465115151515151515151515151515151583a32515151515252515151515151515151515151515152525151515152583
-- 081:1571151515151515151515151515151515151515151515151515508060701515151515151515151515151515465115151571661515151515465666151515d4e4f4151515c41515151515b4151515151515151515d4e4e4e4f41515151515c41515151515151515151515d4e4e4e4f4151515151515151515151515151515151515151515155080608080701515151515b415151515151515c415151515d4e4f415151515b415151515d4e4e4e4f415151515151515151515151515151515155060a015151515151581151515151581151583a32515151515252515151515151515151515151515152525151515152583
-- 082:157115154656661556661515151515151515151556151515465651151571151515151515465666151515155080a01581159060608060606080806070151515b415151515c41515151515c41515d4e4e4e4f415151515b415151515151515c415151515d4e4e4e4f415151515b415151515d4e4e4e4f41515151546566615151515151546565115151515711515151515c415151515151515c41515151515b41515151515c4151515151515b415151515d4e4f415151515465666151515154651151515151515151515151515151515151583a32515151515252515151515151515151515151515152525151515152583
-- 083:1590608060608080607010151515151515105080808060806060a015819060608080608060608080806060a015151515151515151581151515151571151515c415151515c41515151515c415151515b4151515151515c415151515151515c4151515151515b4151515151515c4151515151515b41515151550806060608080606060808080a015811515711515151515c415151515151515c41515151515c41515151515c4151515151515c41515151515b415155060806060608080606060a01515151581151515151515151515151515837392929292929292929292929292929292929292929292a2151515158263
-- 084:811515151515811515711010151515151010511515158115151515151515151515151515811515151581151515811515151515151515151515811571090909c509090909c50909090909c509090909c5090909090909c509090909090909c5090909090909c5090909090909c5090909090909c509090909511515158115151515158115151515151515710909090909c509090909090909c50909090909c50909090909c5090909090909c50909090909c509095115151515151581151515151515151515151515151515151515151515837494949494949494949494949494949494949494949494a4151515158464
-- 085:151515151515151515d11015151515151510b11515151515151515151515151515151515151515151515151515151515151515151515151515151515000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000151515151515151515151515151515151515150000000000000000000000000000000000000000000000000000000000000000000000000000000000151515151515151515151515151515151515d18393939393939393939393a32515151515252515151515151515151515151515152525151515152583
-- 086:151515151515151515d11015151010151510b11515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515d18393939393939393939393a32515151515252515151515151515151515151515152525151515152583
-- 087:151515151515151515d11015151515151510b11515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515d18393939393939393939393a32515151515252515151515151515151515151515152525151515152583
-- 088:c2e1f1c2c2f1c2e1c2d21010151515151010b2c2e1f1c2c2e1c2c2e1c2f1c2e1c2f1c2c2c2c2f1c2e1c2c2f1c2c2c2e1c2c2f1c2c2c2e1f1c2c2e1c2c2f1c2c2f1c2c2c2e1c2f1c2c2e1c2c2f1c2c2c2f1c2c2c2e1c2c2c2c2e1c2c2c2e1c2f1c2c2f1c2e1c2c2c2c2c2f1c2c2c2e1c2c2e1c2f1c2c2e1c2c2f1c2c2c2c2e1c2c2f1c2c2c2e1c2c2e1c2f1c2c2c2c2f1c2e1c2c2c2c2c2f1c2c2e1c2c2f1c2c2e1c2c2f1c2c2e1c2c2c2c2e1c2c2c2c2f1c2c2e1f1c2c2c2c2e1c2c2f1c2c2e1c2c2c2e1c2f1d28494949494949494949464a32515151515252515151515151515151515151515152525151515152583
-- 089:d1a91515151515591515a9151515151515a91558581515151515686777877767871515151515151515151515151557677778155777691515151515151557677767871515151515155767586777691559151515151515155815155767871515a9151515151515151515151515151515151515a9151557596787151515151515595767586915155767596915151515795987155815151515157977678759151515151515585767677767691558591557691515151579776767776767776767776787101015151515152525252515152525258373a215151515829292929292929292929292929292929292929292929263
-- 090:d1a97767677767781515a9151510101515a91559581515a7b71515585958676758871515a7b715151515a7b715155859676777676777871515a7b7151559155767596915a7b715155915591579677758871515a7b715155915155958881515a9151515151515151515151515151515151515a91515885815591515a7b71579676777678715155915581515a7b71515585815591515a7b71515581559581515a7b715155859155858151515585815591515a7b71515595867675887155858151559101015151515151525251515152525258374a415151515849494949494949494949494949494949494949494949464
-- 091:d1a91558581515151515a9151515151515a91558591515a8b81515595858151559581515a8b815151515a8b815155858155859581515591515a8b8151558155915581515a8b815155815581515151558591515a8b815155815155858151515a9151515151515151515151515151515151515a91515155815581515a8b81515585815585915155815581515a8b81515588815581515a8b81515591558581515a8b815155958155859151515598815581515a8b815155858151559581558591515581010151515151010252515151515252583a32515151515252515151515151515151515151515152525151515152583
-- 092:d1a91558591515151515a9101515151510a91558581515151515155858591515585915151515151515151515151559581559585915155815151515151558158815581515151515155815581515151559581515151515155815155859151515a9151515151515151515151515151515151515a91515155915581515151515155958155858151558155915151515151559155778151515151515581558591515151515155858156858677787581515581515151515155859151558591568778715581010151515151010252515151515252583a32515151515252515151515151515151515151515152525151515152583
-- 093:d1a99797979797979797a9151515151515a99797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797a9151515151515151515151515151515151515a99797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797971010151515151010252515151515252583739292929292929292a21515151515151515151515152525151515152583
-- 094:d1a99898989898989898a9151510101515a99898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898a9151515151515151515151515151515151515a99898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898981010151515151010252515151515252584949494949494949494a41515151515151515151515152525151515152583
-- 095:d1a99999999999999999a9151515151515a99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999a9151515151515151515151515151515151515a99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999991010151515151010252515151515252515152515151515252515151515151515151515151515152525151515152583
-- 096:d1a91515151515151515a9101515151510a91515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515a9151515151515151515151515151515151515a91515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151010151515151010252515151515252515152515151515252515151515151515151515151515152525151515152583
-- 097:d1a94747474747474747a9151515151515a94747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747a9151515151515151515151515151515151515a94747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747471010474747471010252515151582929292a22515151515252515151515151515151515151515152525153a151a2583
-- 098:d1a94747474747474747a9151510101515a94747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747a9151515151515151515151515151515151515a94747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747471010252515151584949464a32515151515252515151515151515151515151515152525101010101083
-- 099:d1a9471a473a47474747a9151515151515a94747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747a9151515151515151515151515151515151515a94747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747471010252515151515151583a30313131313131313131313131313131313131313131313131313132383
-- 100:c0c0c0e0c0c0c0c0f0c0c0c0c0f0c0c0c0c0e0f0c0c0c0c0e0c0c0c0e0c0c0c0e0f0c0c0f0c0c0c0e0c0c0f0c0e0c0c0c0c0f0c0c0c0e0c0c0f0c0c0e0c0c0c0f0c0c0e0c0c0f0c0c0e0f0c0c0c0e0c0c0f0c0c0f0c0c0e0c0c0f0c0e0c0f0d0151515151515151515151515151515151515b0f0c0e0c0c0c0f0c0c0e0c0c0c0f0c0c0c0e0c0c0c0c0f0c0c0e0c0c0c0f0c0c0c0c0e0c0c0c0f0c0c0c0c0f0c0c0e0c0f0c0c0c0e0c0c0c0c0f0c0c0c0c0e0c0c0f0c0c0c0e0c0f0c0c0f0c0c0e0c0f0c0c0f0c01010829292929292929263a32514141414252514141414141414141414141414142525141414142583
-- 101:1515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515d1151510151515151515151515151515101515b11515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151010839393939393939393a30909090909090909090909090909090909090909090909090909090983
-- 102:15151515151515151515d11515151515151515151515151515b1151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515d1151515151515151515151515151515151515b115151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515b1d11515151515151515151515151515151515151515151515151515151515151515151515811515151515151515151581151515151515151515811515
-- 103:15151515151515151515d11515151515151515151515151515b1151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515d1151515151510151515151515101515151515b115151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515b1d11515151515151515151515151515151515151515151515151515151515158191626262626262626262626262626262626262626262626262a11515
-- 104:15151515151515151515d1c2c2c2c2c2c2c2c2c2c2c2c2c2c2b1151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515d1151515151515151515151515151515151515b115151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515b1d115151515151515151515151515151515151515151515151515151515151591a015151515151515151515151515151515151515151515151590a115
-- 105:c2c2f1c2c2e1c2f1c2c2d21616161616161616161616161616b2c2e1c2c2c2f1c2c2c2c2e1c2c2c2f1c2c2c2f1c2e1c2c2c2e1c2c2c2f1c2c2c2c2e1c2c2c2f1c2c2f1e1c2c2c2e1c2c2c2f1c2e1c2c2e1c2f1c2e1c2c2f1c2c2f1e1c2f1c2d2151515151515151510101515151515151515b2c2e1c2f1c2e1c2c2c2f1c2e1c2c2f1c2e1c2c2f1c2c2e1c2c2e1c2f1c2f1c2c2e1f1c2c2f1c2c2e1c2c2c2f1c2c2c2e1f1c2c2e1c2f1c2c2e1f1c2c2f1c2e1c2b1d1c2e1c2f1c2e1c2c2f1c2e1c2f1c2e1c2c2c2f1c2e1c2f1c2c2e1c2f1c2157115151515151515151515151515151515151515151515151515155115
-- 106:d115576777676777871510151515151515a91515595767691510101579871515151515151515151515151515151515155957676777676787151515151579677767871559581515151515151515151515155867678715151515151557676915a9151515151515151515151515151515151515a915576767871515151515155915581559151515151515151515151579676787591515151515151557675867776767586915151515155857677787591515798715b1d115155767695815151515151515151515151515151515156867871515b1157115151515151515151515151515151515151515151515151515155115
-- 107:d115585868678715591510151515151515a91515585858151510101515591515a7b715151515a7b715151515a7b7157958595887151515591515a7b71515581515591558581515a7b715151515a7b71515581589591515a7b7151559581515a9151515151510151515151515101515151515a915881558591515a7b7151558155915581515a7b715151515a7b71515581559581515a7b715155759775969155958581515a7b715155859155859588715155915b2d215155958155815151515151515151515151515151515576758596915b1157115151515151515151515151515151515151515151515151515155115
-- 108:d115595815595815581510151515151515a91515585958151510101515581515a8b815151515a8b815151515a8b8151558885859151515581515a8b81515591515586778591515a8b815151515a8b81515591558581515a8b8151558581515a9151515151515151515151515151515151515a915151558581515a8b8151558155815581515a8b815151515a8b81515591558581515a8b815155958155815155858591515a8b815155958155858585915155815151515155858155915151515151515151515151515151515591558581515b1157115151515151515151515151515151515151515151515151515155115
-- 109:d115585915585915581510151515151515a91515585859151510101515881515151515101015151515151515151515155815595815151558151515151515581515581515581515151515151515151515155815595815151515151558591515a9151510151515151515151515151515101515a915151559581515151515155815581559151515151515151515151515581558591515151515155858156867776778581515151515155858155968585869155815151515155859155815151515151515151515151515151515581559581515b1157115151515151515151515151515151515151515151515151515155115
-- 110:d197979797979797979710151515151515a99797979797979710109797979797979797101097979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797a9151515151515151515151515151515151515a99797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797979797b0c0d09797b0d01515595815581515a7b71515151515151515a7b71515581558591515b1157115151515151515151515151515151515151515151515151515155181
-- 111:d198989898989898989810151515151515a99898989898989810109898989898989898101098989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898a9151515151510151515151515101515151515a9989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898989898b0c0d09898b115d19898b1d11515585815591515a8b81515151515151515a8b81515591558581515b1817115151515151515151515151515151515151515151515151515155115
-- 112:d199999999999999999910151515151515a99999999999999910109999999999999999101099999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999a9151515151515151515151515151515151515a999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999b0c0d09999b115d19999b115d19999b1d115155859155815151515151515151515151515151515581559581515b1157115151515151515151515151515151515151515151515151515155115
-- 113:d115151515151515151510151510101010101515151515151510101515151515151515101015151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515a9151515151515151510101515151515151515a91515151515151515151515151515151515151515151515151515151515151515151515151515151515151515b0c0d01515b1c1d11515b115d11515b115d11515b1d115155958155815151515151515151515151515151515581558591515b1157115151515151515151515151515151515151515151515151515155115
-- 114:d147474747474747474710151504041515104747474747474747474747474747474747101047474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747a9151515151515151515151515151515151515a9474747474747474747474747474747474747474747474747474747474747474747474747474747b0c0d04747b115d14747b115d14747b115d14747b115d14747b1d115155858155915151515151515151515151515151515581558581515b1157115151515151515151515151515151515151515151515151515155115
-- 115:d147474747474747474710151504041515104747474747474747474747474747474747101047474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747a9151515151510151515151515101515151515a947474747474747474747474747474747474747474747474747474747474747474747b0c0d04747b115d14747b115d14747b115d14747b115d14747b115d14747b1d115155859158815151515151515151515151515151515591559581515b1157115151828151515151515151515151515151515151515182815155115
-- 116:d147474747474747474710101010101515104747474747474747474747474747474747101047474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747a9151515151515151515151515151515151515a947474747474747473a471a474747474747474747474747474747474747b0c0d04747b1c1d14747b115d14747b115d14747b115d14747b115d14747b115d14747b1d115155958151515151515151515151515151515151515581558591515b1157115151929151515151515151515151515151515151515192915155115
-- 117:c0c0e0c0f0c0e0c0f0d01015151515151510b0f0e0c0f0c0c0c0e0c0c0f0c0c0c0c0e0f0c0c0f0c0c0e0c0c0c0f0c0c0f0c0e0c0f0c0c0f0c0c0c0e0c0c0c0f0c0c0e0c0f0c0c0e0c0c0f0c0c0c0f0c0c0f0e0c0f0c0c0e0c0f0c0e0c0c0c0f0c0c0c0c0e0f0c0c0c0c0f0c0e0c0f0c0c0f0c0e0f0c0c0d01515b0c0e0c0d01515b0c0d01515b0c0e0c0f0c0c0c0e0c0b1c1d10909b115d10909b115d10909b115d10909b115d10909b115d10909b115d10909b1d1f0c0e0c0f0c0c0e0c0c0f0c0c0e0c0f0c0c0c0e0c0f0c0c0e0f0c0e0c0157115151929151515334343434343434343434353151515192915155181
-- 118:151515151515151515d11015151515151510b115151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515d10909b1151515d10909b115d10909b1151515151515151515b115d11414b115d11414b115d11414b115d11414b115d11414b115d11414b115d11414b1d11515151515151515151515151515151515151515151515151515151515157109093949090909344444444444444444444454090909394909095115
-- 119:1515151515151515151510151515151515101515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515150000151515151500001515150000151515151515151515151515151515151515000015151500001515150000151515000015151500001515150000151515151515151515151515151515151515151515151515151515151515b1151515151515151515151515151515151515151515151515151515151515
-- 120:1515151515151515151510151515151515101515158115151515151515151515151515151515151515151515151515151515151515151515158115151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515811515151515151515151515158115151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515b1151515151515151515151515151515151515151515151515151515151515
-- 121:9162626262626262a115101515151515151015151515916262626262626262a1151515151515811515151581151515151515151581916262626262626262a11581151515151515151515158115151515151515151581151591626262a1151591626262a1158115151515151515151515151515151515151515151515158115151515159162626262a11515158115151515151515151515151581151515151515151515151515151581151515159162626262626262626262626262626262626262a1151515151515151515151581151515b1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1
-- 122:71153515151535159062101515151515151062626262a01515351515153515511515811515916262626262626262a1158115151515711535151515351535906262626262a11581151515151515158115151515151515151571153515906262a0151535906262626262626262a115811515151515151581159162626262626262626262a0151535155115151515151515916262626262626262626262a115158115151515159162626262a115157116161616161616161616161616161616161616906262a1158115151515151515151581b1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2
-- 123:71153515151535151515151515151515151515351515151515351515153515906262626262a01929153515151535511515151515157115351515153515351515192915355115159162626262a11515151515151515916262a015351515351515151535151515153515153515511515151515151515151515711515351515151535151515151535159062626262626262a01515153515151515151515511591626262a18191a016161616906262a01515151515151515151515151515151515151515351551151515151515159162626262b1d115151515151515151515151515151515151515151515151515151515b1
-- 124:7115351515153515151515151515151515151515151828151535151515351515151515351515384815351515153590626262626262a01535151515151535151519291535906262a01616161690626262a1151515157135151515351515351515151535151515153515153515906262a11515151515916262a015153515151515351515151515351515151515151535151515151535151515151515159062a01616169062a0151515151515351515151515151515151515151515151515151515151535159062626262626262a015351515b1d115151515151515151515151515151515151515151515151515151515b1
-- 125:71151515151535151515151515151515151515151519291515151515153515151515153515151515153515151515151535153848151515351515151515351515384815351515351515151515151535159062626262a035151515151515351515151535151515153515153515151535906262626262a015351515153515151515351515151515151515151515151535151518281535151515151515151535151515151535151515151515153515151515151515151515151515151515151515151515351515151515351515151515351515b2d215151515151515151515151515151515151515151515151515151515b1
-- 126:7115151515153515151515151515151515151515151929151515151515351515151515351515151515151515151515153515151515151535151515151515151515151535151535151515151515153515151535151515351515151515153515151515151515151535151515151515351515151515151515351515151515151515351515151515151515151515151535151519291515151515151515151535151515151535151515151515153515151515151515151515151515151515151515151515151515151515351515151515151515151515151515151515151515151515151515151515151515151515151515b1
-- 127:7115151515153515151515151515151515151515151929151515151515151515182815151515151515151515151515153515151515151515182815151515151515151515151535151515151515153515151535151515151515151515151515151515151518281535151515151515351515151515151515351515151515151515351518281515151515151515151515151519291515151515182815151535151515151535151515151515151515151515151515151515151515151515151515151515151515151515351515151515151515151515151515151515151515151515151515151515151515151515151515b1
-- 128:71151515151515151515151518281515151515151519291515151515151515151929151515151515151515151515151515151515151515151929151515151515151515151515151515151515182815151515351515151515151515151515151515151515192915151515151515153515151515151515151515151515151515151515192915151515151515151515151515192915151515151929151515351515151515351515151515151515151515151515151515151515151515151515151515151515151515151515151515b0c0c0c0c0d015151515151515151515151515151515151515151515151515151515b1
-- 129:71151515151515151515151519291515151515151519291515153a151a1515151929151515151828151515151515151515151515151515151929151515151515151515151518281515151515192915151515151515151515151515151515151515151515192915151515151515153515151515151515151515151518281515151515192915151515151515151515151515192915151515151929151515151515151515351515151828151515151515151515151515151515151515151515151515151828151515151515151515b2c2c2c2c2d115151515151515151515151515151515151515151515151515151515b1
-- 130:7115151515151515151515151929151515151515151929151533434343531515192915151515192915151515151515151515182815151515192915151515151515151515151929151515151519291515151515151515182815151515151515151515151519291515151515151515151515151828151515151515151929151515151519291515151515151515151515151519291515151515192915151515151515151515151515192915151515151515151515151515151515151515151515151515192915151515151515151515151515b1d115151515151515151515151515151515151515151515151515151515b1
-- 131:7115151515151515151515151929151515151515151929151534444444541515192915151515192915151515151515151515192915151515192915151515151515151515151010101010101010101515151515151515192915151515151515151515151519291515151515151515151515151929151515151515151929151515153343435315151515151515151515151519291515151515192915151515151515151515151515192915151515151515151515151515151515151515151515151515192915151515151515182815151515b1d115151515151515151515151515151515151515151515151515151515b1
-- 132:711518281515151515151515192915151515153343434343433444444454334343434353151519291515151515151515151519291515151519291515151515151515151515192915151515151929151515151515151519291515151515151515151515151929151515151515151515151515192915151515151515192915153353344444543353151515151515151515151929153a151a151929151515151515151515151515151929151515151515151515d4e4f415151515151515d4e4f4151515192915151515151515192915151515b1d115151515151515151515151515151515151515151515151515151515b1
-- 133:71151929151515151515151519291515151515344444444444444444444444444444445415151929151533434353151515151010101010101010151515151515151515151519291515151515192915151515151515151929151515151515151515151515192915151515151515151515151519291515151515151519291515344444444444445415151515151515151533434343434343434343531515151515151515151515151929151515d4e4f415151515b4151515d4e4f4151515b415151515192915151515151515192915151515b1d115151515151515151515151515151515151515151515151515151515b1
-- 134:7133434343434343434343434343434343434334444444444444444444444444444444543343434343533444445415151515192915151515192915151515151515151515151929151515151519291515151515151515192915151515151515151515151519291515151515151515151515151929151515153343434343435334444444444444543353262626262633533444444444444444444454435315151515151515151515192915151515b41515151515c415151515b415151515c415151533434343434343434343434343434353b1c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0
-- 135:7134444444444444444444444444444444444444444444444444444444444444444444444444444444444444445409090909394909090909394909090909090909090909093949090909090939490909090909090909394909090909090909090909090939490909090909090909090909093949090909093444444444444444444444444444444454334343435334444444444444444444444444445409090909090909090909394909090909c50909090909c509090909c509090909c509090934444444444444444444444444444454b1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 003:0000ffffffffffff0000ffffffffffff
-- </WAVES>

-- <SFX>
-- 000:f300c30063002300030003000300030003001300130013002300330033003300430f430d430d530f53006301630363036301630073007300730073002050000000fa
-- 001:040004003400540074009400a400c400d400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400204000000000
-- 002:c000b000b000a030a0309030900080008000800070007000700060006000500050005000500040003000200020001000100000000000000000000000374000000600
-- 003:0000000000000020202030205000600060007000800090009000a000a000b000b000c000c000d000d000e000f000f000f000f000f000f000f000f000309000000600
-- 004:c200b200b200a200a2019203920382018200820f720d720d720f6200620052005200520052004200320022002200120012000200020002000200020037600000003a
-- 005:018001800300030043005300630083009300a300c300d300d300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300b07000000000
-- 006:0240120022203240421052006200720082009200a200a200c200c200e200e200f200f200f200f200f200f200f200f200f200f200f200f200f200f200301000000500
-- 007:0400240063008300a300c300e300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300105000000000
-- 008:018001800300030043005300630063007300730083008300930093009300930093019303930393019300930f930d930d930f930093009300930093003000000000fa
-- 048:00400040004060a060a060a0f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000200000000000
-- 049:0060106020d030d0409050906000700080009000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000504000000600
-- 050:402030302040105010501050204030304020f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000200000000000
-- 051:3470147004b004b004b024b054b084b084a0a480b460c440c440c450d430d410d410e410e410d400c410d420d400e410d420d400c410d410d410f430202000000000
-- 052:04c024b0548074609440c420e410f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400302000000000
-- 053:9007a003b000c00dd008e000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000400000000000
-- 054:9400a400b400c400e400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400400000000000
-- </SFX>

-- <PATTERNS>
-- 001:400012000000000000000010400016000000000000000000400012000010400012000000400016000000000000000000400012000000000000000010400016000000000000000000400012000010400012000000400016000000000000000000400012000000000000000010400016000000000000000000400012000010400012000000400016000000000000000000400012000000000000000010400016000000000000000000400012000010400012000000400016000000000000000000
-- 002:daa124000000000000000000000000000000000000000000000020000000000000000000000020000000000000000000800024000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000b00024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f00024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:d00036000000000000000000000030000000d00036000000000030000000d00036000000000030000000000000000000b00036000000000030000000b00036000000000000000000b00036000000000000000000000000000000000000000000900036000030000000000000000030000000900036000000000000000000900036000000000000000000000000000000d00036000000000000000000d00036000000000000000000d00036000000000000000000000000000000000000000000
-- 004:d00044000000000000000000000000000000000000000000000020000000000000000000000020000000000000000000800044000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000b00044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f00044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:d88142000000000000000000000000000000000000000000000020000000000000000000000020000000000000000000800042000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000b00042000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f00042000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:d00056000000000000000000000030000000d00056000000000030000000d00056000000000030000000000000000000b00056000000000030000000b00056000000000000000000b00056000000000000000000000000000000000000000000900056000030000000000000000030000000900056000000000000000000900056000000000000000000000000000000d00056000000000000000000d00056000000000000000000d00056000000000000000000000000000000000000000000
-- 007:d00056000000000000000000800056000000d00056000000000050000000800056000000d00056000000000000000000d00056000000000050000000800056000000000050000050800056000000000000000000000000000050000050000000b00056000000000050000000400056000000b00056000000000050000000400056000000b00056000000000000000000b00056000000d00056000000000000000000d00056000000000000000000000000000000000000000000000000000000
-- 008:d00056000000000000000000000000000050800056000000000000000050000050000000000050000000000000000000d00056000000000050000000000000000000800056000000000000000000000000000000000000000000000000000000d00056000000000000000000000000000000800056000000000000000000800056000000d00056000000000000000000d00056000000800056000000000050000000800056000000000000000000000000000000000000000000000000000000
-- 009:d00056000000000000000000000000000050800056000000000000000050000050000000000050000000000000000000d00056000000000050000000000000000000800056000000000000000000000000000000000000000000000000000000d00056000000000000000000000000000000800056000000000000000000800056000000d00056000000000000000000800056000000d00056000000000050000000d00056000000000000000000000000000000000000000000000000000000
-- 010:900066000000000060600066000060900066000060000000000060800066000000600066000000800066000000900066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:400086000000000000000000000000000000000080000000d00084000000000080400086000080000080400086000000600086000000400086000000600086000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </PATTERNS>

-- <TRACKS>
-- 000:0c00002c00002c04002c04002416002416002416c12416c1241602241602241642241682241600200000000000000000000000
-- 001:b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010
-- 003:c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010
-- </TRACKS>

-- <SCREEN>
-- 001:000000000000000000000000000000000000000000000000000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000000000000000000880000000000000000000
-- 002:000000000000000000000000000000000000000000000000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000880000000000000000000000000000000000000000000000000000000000000000000000000000008800000000000000000000
-- 003:000000000000000000000000000000000000000000000000088080000000000000000000000000000000000000000000000000000000000000000000000000000000000008808000000000000000000000000000000000000000000000000000000000000000000000000000088080000000000000000000
-- 004:000000000000000000000000000000000000000000000000080800000000000000000000000000000000000000000000000000000000000000000000000000000000000008080000000000000000000000000000000000000000000000000000000000000000000000000000080800000000000000000000
-- 005:000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000
-- 006:000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000
-- 009:000000000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:000000000088000000000009988000009880000098800000988000009880000098800000988000009880000098800000988000009880000098800000988000009880000098800000988000009880000098800000988000009880000098800000988000009880000098800000900000000000000000000000
-- 011:000000000880800000000899999800889998008899980088999800889998008899980088999800889998008899980088999800889998008899980088999800889998008899980088999800889998008899980088999800889998008899980088999800889998008899980088998000000000000000000000
-- 012:000000000808000000080899990008099900080999000809990008099900080999000809990008099900080999000809990008099900080999000809990008099900080999000809990008099900080999000809990008099900080999000809990008099900080999000809998080000000000000000000
-- 013:000000000000008000890889009888000098880000988800009888000098880000988800009888000098880000988800009888000098880000988800009888000098880000988800009888000098880000988800009888000098880000988800009888000098880000988800988098000000000000000000
-- 014:000000000000080000899088099998800999988009999880099998800999988009999880099998800999988009999880099998800999988009999880099998800999988009999880099998800999988009999880099998800999988009999880099998800999988009999880880998000000000000000000
-- 015:000000000000000000899000089999880899998808999988089999880899998808999988089999880899998808999988089999880899998808999988089999880899998808999988089999880899998808999988089999880899998808999988089999880899998808999988000998000000000000000000
-- 016:000000000000000000999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000998000000000000000000
-- 017:000000000000000000999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000899800000000000000000
-- 018:000000000000000900980000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088809000000000000000
-- 019:000000000000089999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099980000000000000
-- 020:000000000008089999980000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000989980800000000000
-- 021:000000000089088988800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009880980000000000
-- 022:000000000089908800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008809980000000000
-- 023:000000000089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980000000000
-- 024:000000000008900800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008009800000000000
-- 025:000000000008008900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009800800000000000
-- 026:000000000000899900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009998000000000000
-- 027:000000000000889900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009988000000000000
-- 028:000000000008089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980800000000000
-- 029:000000000089088900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009880980000000000
-- 030:000000000089908800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008809980000000000
-- 031:000000000089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980000000000
-- 032:000000000008900800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008009800000000000
-- 033:000000000008008900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009800800000000000
-- 034:000000000000899900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009998000000000000
-- 035:000000000000889900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009988000000000000
-- 036:000000000008089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980800000000000
-- 037:000000000089088900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009880980000000000
-- 038:000000000089908800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008809980000000000
-- 039:000000000089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980000000000
-- 040:000000000008900800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008009800000000000
-- 041:000000000008008900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009800800000000000
-- 042:000000000000899900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009998000000000000
-- 043:000000000000889900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009988000000000000
-- 044:000000000008089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980800000000000
-- 045:000000000089088900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009880980000000000
-- 046:000000000089908800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008809980000000000
-- 047:000000000089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980000000000
-- 048:000000000008900800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008009800000000000
-- 049:000000000008008900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009800800000000000
-- 050:000000000000899900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009998000000000000
-- 051:000000000000889900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009988000000000000
-- 052:000000000008089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980800000000000
-- 053:000000000089088900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009880980000000000
-- 054:000000000089908800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008809980000000000
-- 055:000000000089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980000000000
-- 056:000000000008900800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008009800000000000
-- 057:000000000008008900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009800800000000000
-- 058:000000000000899900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009998000000000000
-- 059:000000000000889900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009988000000000000
-- 060:000000000008089900000000000000000000000000000000000000000022222222220000222200000022220022222222222222002222000000222200002222222222000022220000002222000000222222000000002222222222000000000000000000000000000000000000000000009980800000000000
-- 061:000000000089088900000000000000000000000000000000000000000022222222220000222200000022220022222222222222002222000000222200002222222222000022220000002222000000222222000000002222222222000000000000000000000000000000000000000000009880980000000000
-- 062:000000000089908800000000000000000000000000000000000000002222222222222200222222000022220022222222222222002222000000222200222222222222220022222200002222000000888888000000222222222222220000000000000000000000000000000000000000008809980000000000
-- 063:000000000089900000000000000000000000000000000000000000002222222222222200222222000022220022222222222222002222000000222200222222222222220022222200002222000000888888000000222222222222220000000000000000000000000000000000000000000009980000000000
-- 064:000000000008900800000000000000000000000000000000000000002222888888222200222222220022220088882222228888002222000000222200222288888822220022222222002222000000000000000000222288888822220000000000000000000000000000000000000000008009800000000000
-- 065:000000000008008900000000000000000000000000000000000000002222888888222200222222220022220088882222228888002222000000222200222288888822220022222222002222000000000000000000222288888822220000000000000000000000000000000000000000009800800000088000
-- 066:000000000000899900000000000000000000000000000000000000003333000000333300333388333333330000003333330000003333000000333300333300000033330033338833333333000000333333000000333300000033330000000000000000000000000000000000000000009998000000880000
-- 067:000000000000889900000000000000000000000000000000000000003333000000333300333388333333330000003333330000003333000000333300333300000033330033338833333333000000333333000000333300000033330000000000000000000000000000000000000000009988000008808000
-- 068:000000000008089900000000000000000000000000000000000000003333333333333300333300883333330000003333330000003333330033333300333333333333330033330088333333000000333333000000333333333333330000000000000000000000000000000000000000009980800008080000
-- 069:000000000089088900000000000000000000000000000000000000003333333333333300333300883333330000003333330000003333330033333300333333333333330033330088333333000000333333000000333333333333330000000000000000000000000000000000000000009880980000000080
-- 070:000000000089908800000000000000000000000000000000000000002222888888222200222200008822220000002222220000008822222222228800222288888822220022220000882222000000222222000000222288888822220000000000000000000000000000000000000000008809980000000800
-- 071:000000000089900000000000000000000000000000000000000000002222888888222200222200008822220000002222220000008822222222228800222288888822220022220000882222000000222222000000222288888822220000000000000000000000000000000000000000000009980000000000
-- 072:000000000008900800000000000000000000000000000000000000002222000000222200222200000022220000002222220000000088222222880000222200000022220022220000002222000000222222000000222200000022220000000000000000000000000000000000000000008009800000000000
-- 073:000880000008008900000000000000000000000000000000000000002222000000222200222200000022220000002222220000000088222222880000222200000022220022220000002222000000222222000000222200000022220000000000000000000000000000000000000000009800800000000000
-- 074:008800000000899900000000000000000000000000000000000000008888000000888800888800000088880000008888880000000000888888000000888800000088880088880000008888000000888888000000888800000088880000000000000000000000000000000000000000009998000000000000
-- 075:088080000000889900000000000000000000000000000000000000008888000000888800888800000088880000008888880000000000888888000000888800000088880088880000008888000000888888000000888800000088880000000000000000000000000000000000000000009988000000000000
-- 076:080800000008089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980800000000000
-- 077:000000800089088900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009880980000000000
-- 078:000008000089908800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008809980000000000
-- 079:000000000089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980000000000
-- 080:000000000008900800000000000000000000000000000000000000000000000000000000000000000000000000000880000000000000008000000000888088800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008009800000000000
-- 081:000000000008008900000000000000000000000000000000000000000000000000000000000000000000000000008000880088800880008800808000888080008800808088808800880000000000000000000000000000000000000000000000000000000000000000000000000000009800800000000000
-- 082:000000000000899900000000000000000000000000000000000000000000000000000000000000000000000000008080088088808080008080808000808088000880808008800880808000000000000000000000000000000000000000000000000000000000000000000000000000009998000000000000
-- 083:000000000000889900000000000000000000000000000000000000000000000000000000000000000000000000008080808080808800008080088000808080008080808080008080808000000000000000000000000000000000000000000000000000000000000000000000000000009988000000000000
-- 084:000000000008089900000000000000000000000000000000000000000000000000000000000000000000000000000880888080800880008800008000808080008880088088808880808000000000000000000000000000000000000000000000000000000000000000000000000000009980800000000000
-- 085:000000000089088900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009880980000000000
-- 086:000000000089908800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008809980000000000
-- 087:000000000089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980000000000
-- 088:000000000008900800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008009800000000000
-- 089:000000000008008900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009800800000000000
-- 090:000000000000899900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009998000000000000
-- 091:000000000000889900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009988000000000000
-- 092:000000000008089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980800000000000
-- 093:000000000089088900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009880980000000000
-- 094:000000000089908800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008809980000000000
-- 095:000000000089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980000000000
-- 096:000000000008900800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008009800000000000
-- 097:000000000008008900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009800800000000000
-- 098:000000000000899900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009998000000000000
-- 099:000000000000889900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009988000000000000
-- 100:000000000008089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980800000000000
-- 101:000000000089088900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009880980000000000
-- 102:000000000089908800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008809980000000000
-- 103:000000000089900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009980000000000
-- 104:00000000000890080000000000000000fffe000000000eff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fffe000000000eff00000000000000008009800000000000
-- 105:00000000000800890000000000000000effffff0000fffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000effffff0000fffff00000000000000009800800000000000
-- 106:00000000000089990000000000000000e0fffefffffeff0f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0fffefffffeff0f00000000000000009998000000000000
-- 107:00000000000088990000000000000000e0f0fefffffef00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0f0fefffffef00f00000000000000009988000000000000
-- 108:00000000000808990000000000000000e0f0fefeef0ef00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0f0fefeef0ef00f00000000000000009980800000000000
-- 109:00000000008908890000000000000000e0f0fefeef0ef00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0f0fefeef0ef00f00000000000000009880980000000000
-- 110:00000000008990880000000000000000e0f0fefeef0ef00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0f0fefeef0ef00f00000000000000008809980000000000
-- 111:00000000008990000000000000000000e0f0fefeef0ef00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0f0fefeef0ef00f00000000000000000009980000000000
-- 112:00000000000890080000000000000000e0f0fefeef0ef00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0f0fefeef0ef00f00000000000000008009800000000000
-- 113:00000000000800890000000000000000e0f0fefeef0ef00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0f0fefeef0ef00f00000000000000009800800000000000
-- 114:00000000000089990000000000000000e0f0fefeef0ef00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0f0fefeef0ef00f00000000000000009998000000000000
-- 115:00000000000088990000000000000000e0f0fefeef0ef00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0f0fefeef0ef00f00000000000000009988000000000000
-- 116:00000000000808990000000000000000e0f0fefeef0ef00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0f0fefeef0ef00f00000000000000009980800000000000
-- 117:00000000008908890000000000000000e0f0fefeef0ef00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0f0fefeef0ef00f00000000000000009880980000000000
-- 118:00000000008990880000000000000000e0f0fefeef0ef00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0f0fefeef0ef00f00000000000000008809980000000000
-- 119:00000000008990000000000000000000e0f0fefeef0ef00f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0f0fefeef0ef00f00000000000000000009980000000000
-- 120:00000000000890080000000000000000e0f0fefeef0ef00f000000000000000000000000888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888000000000000000000000000e0f0fefeef0ef00f00000000000000008009800000000000
-- 121:00000000000800890000000000000000e0f0fefeef0ef00f000000000000000000000000877777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777778000000000000000000000000e0f0fefeef0ef00f00000000000000009800800000088000
-- 122:00000000000089990000000000000000e0f0fefeef0ef00f000000000000000000000000877676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767678000000000000000000000000e0f0fefeef0ef00f00000000000000009998000000880000
-- 123:00000000000088990000000000000000e0f0fefeef0ef00f000000000000000000000000876767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676778000000000000000000000000e0f0fefeef0ef00f00000000000000009988000008808000
-- 124:00000000000808990000000000000000e0f0fefeef0ef00f000000000000000000000000877777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777778000000000000000000000000e0f0fefeef0ef00f00000000000000009980800008080000
-- 125:00000000008908890000000000000000e0f0fefeef0ef00f000000000000000000000000877877787778777877787778777877787778777877787778777877787778777877787778777877787778777877787778000000000000000000000000e0f0fefeef0ef00f00000000000000009880980000000080
-- 126:00000000008990880000000000000000e0f0fefeef0ef00f000000000000000000000000088088808880888088808880888088808880888088808880888088808880888088808880888088808880888088808880000000000000000000000000e0f0fefeef0ef00f00000000000000008809980000000800
-- 127:00000000008990000000000000000000e0f0fefeef0ef00f000000000000000000000000000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010000000000000000000000000000e0f0fefeef0ef00f00000000000000000009980000000000
-- 128:000000000008900888998aa988998aa988998aa988998aa988998aa988998aa988998aa901111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111088998aa988998aa988998aa988998aa988998aa988998aa988998aa98009800000000000
-- 129:00000000000800890a8800880a8800889a8889889a8880880a8800880a8800880a8800880111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111100a8800880a8800880a8800889a8889889a8880880a8800880a8800889800800000000000
-- 130:000000000000899900000000000000009080898998098008000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110000000000000000000000000908089899809800800000000000000009998000000000000
-- 131:000000000000889900000000000000009080898998098008000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110000000000000000000000000908089899809800800000000000000009988000000000000
-- 132:000000000008089900000000000000009080898998098008000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110000000000000000000000000908089899809800800000000000000009980800000000000
-- 133:000000000089088900000000000000009080898998098008000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110000000000000000000000000908089899809800800000000000000009880980000000000
-- 134:000000000089908800000000000000009080898998098008000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110000000000000000000000000908089899809800800000000000000008809980000000000
-- 135:000000000089900000000000000000009080898998098008000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110000000000000000000000000908089899809800800000000000000000009980000000000
-- </SCREEN>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

