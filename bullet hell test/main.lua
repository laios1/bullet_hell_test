io.stdout:setvbuf('no')
love.window.setMode(500,700)
math.randomseed(os.time())

require("FuGrEtTa")

function createPlayer()
  local myPlayer = {}
  
  myPlayer.x = 250
  myPlayer.y = 550
  myPlayer.w = 10
  myPlayer.h = 20
  
  myPlayer.timerInterne = 0
  
  
  
  function myPlayer.move(dt)
    if love.keyboard.isDown('s') then
      myPlayer.y = myPlayer.y + 6
    end 
    if love.keyboard.isDown('z') then
      myPlayer.y = myPlayer.y - 6
    end
    if love.keyboard.isDown('d') then
      myPlayer.x = myPlayer.x + 6
    end 
    if love.keyboard.isDown('q') then
      myPlayer.x = myPlayer.x - 6
    end 
    
    if myPlayer.y > 690 then 
      myPlayer.y = 690 
    elseif myPlayer.y < 10 then
      myPlayer.y = 10
    end 
    if myPlayer.x > 495 then 
      myPlayer.x = 495 
    elseif myPlayer.x < 5 then
      myPlayer.x = 5
    end 
  end
  
  function myPlayer.shoot(dt,list)
    -- shoot la putain de ta mere 
    
    
    if love.keyboard.isDown('space') and myPlayer.timerInterne >= 8 then
      if isSpamingSpace then
      list[#list+1] = createSimpleBullet(myPlayer.x,myPlayer.y,6,-math.pi/2,10,0,0,0,{0,0,1})
      
      myPlayer.timerInterne = 0 
      else
      
      end
      isSpamingSpace = true
    else 
      local isSpamingSpace = false
    end 
  end 
  
  function myPlayer.update(dt,list)
    myPlayer.timerInterne = myPlayer.timerInterne + 1
    myPlayer.move(dt)
    myPlayer.shoot(dt,list)
  end 
  
  function myPlayer.die(list)
    for i = 1, #list do
      if math.sqrt((list[i].x-myPlayer.x)^2 + (list[i].y-myPlayer.y)^2) < list[i].r+2 then
        return true 
      end
    end
    return false
  end 
  
  function myPlayer.draw()
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill",myPlayer.x-myPlayer.w/2,myPlayer.y-myPlayer.h/2,myPlayer.w,myPlayer.h)
    love.graphics.setColor(1,0,0)
    love.graphics.circle("fill",myPlayer.x,myPlayer.y,2)
  end 
  
  
  return myPlayer
end 

function createSimpleBullet(x,y,r,vo,vr,ao,ar,lim,color)
  local mybullet = {}
  
  mybullet.x = x
  mybullet.y = y 
  mybullet.r = r
  
  mybullet.vo = vo
  mybullet.vr = vr
  
  mybullet.ao = ao or 0
  mybullet.ar = ar or 0 
  
  mybullet.time = 0
  mybullet.timeLimit = lim or 0 
  
  mybullet.color = color or {1,1,1}
  
  function mybullet.update(dt)
    if mybullet.time < mybullet.timeLimit then
      mybullet.time = mybullet.time + 1 
    else
      mybullet.vo = mybullet.vo + mybullet.ao
      mybullet.vr = mybullet.vr + mybullet.ar
      
      mybullet.x = mybullet.x + math.cos(mybullet.vo) * mybullet.vr
      mybullet.y = mybullet.y + math.sin(mybullet.vo) * mybullet.vr
    end 
    --print(mybullet.x,mybullet.y)
  end 
  
  function mybullet.draw()
    
    love.graphics.setColor(mybullet.color)
    love.graphics.circle("fill",mybullet.x,mybullet.y,mybullet.r)
  end 
  
  return mybullet
end 

function monster1(x,y,player)
  local myFirstMonster = {}
  
  myFirstMonster.x = x
  myFirstMonster.y = y 
  myFirstMonster.w = 10
  myFirstMonster.h = 20
  myFirstMonster.distance = 0
  myFirstMonster.back = false
  myFirstMonster.r = ((player.x-x)^2 + (player.y-y)^2)^0.5
  myFirstMonster.o = math.acos((player.x-x)/myFirstMonster.r)
  if player.y < y then
    myFirstMonster.o = -myFirstMonster.o
  end 
  myFirstMonster.dead = false
  
--  function myFirstMonster.getHit(friendlyBullet)
--    local i = 1
--    while i <= #friendlyBullet do
--      if friendlyBullet[i].x  > myFirstMonster.x  and friendlyBullet[i].x  < myFirstMonster.x + myFirstMonster.w and friendlyBullet[i].y  > myFirstMonster.y  and friendlyBullet[i].y < myFirstMonster.y + myFirstMonster.h then 
--        myFirstMonster.dead = true
--        table.remove(friendlyBullet,i)
--        i = i - 1 
--      end 
--      i = i + 1 
--    end 
--  end 
--  function myBoss.getHit(friendlyBullet)
--    local i = 1
--    while i <= #friendlyBullet do
--      if friendlyBullet[i].x  > myBoss.x - 100/2 and friendlyBullet[i].x  < myBoss.x - 100/2 + myBoss.w and friendlyBullet[i].y  > myBoss.y - 73/2 and friendlyBullet[i].y < myBoss.y - 73/2 + myBoss.h then 
--        myBoss.life = myBoss.life - 1
--        table.remove(friendlyBullet,i)
--        i = i - 1 
--      end 
--      i = i + 1 
--    end 
--  end 
  
  function myFirstMonster.update(dt,BL,player) -- BL = bullet list 
    myFirstMonster.r = ((player.x-myFirstMonster.x)^2 + (player.y-myFirstMonster.y)^2)^0.5
    myFirstMonster.o = math.acos((player.x-myFirstMonster.x)/myFirstMonster.r)
    if player.y < myFirstMonster.y then
      myFirstMonster.o = -myFirstMonster.o
    end 
    
    if not myFirstMonster.back then
      myFirstMonster.x = myFirstMonster.x + math.cos(myFirstMonster.o) * 1.33
      myFirstMonster.y = myFirstMonster.y + math.sin(myFirstMonster.o) * 1.33
      myFirstMonster.distance = myFirstMonster.distance + 1 
      if myFirstMonster.distance >= 50 then
        BL[#BL+1] = createSimpleBullet(myFirstMonster.x,myFirstMonster.y,6,myFirstMonster.o,15)
        myFirstMonster.back = true
      end 
    else
      myFirstMonster.y = myFirstMonster.y - 6
    end 
  end 
  
  function myFirstMonster.draw()
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill",myFirstMonster.x-myFirstMonster.w/2,myFirstMonster.y-myFirstMonster.h/2,myFirstMonster.w,myFirstMonster.h)
  end 
  
  return myFirstMonster
end 

function createMechantBlob(x,y)
  local myBoss = {}
  myBoss.x = x
  myBoss.y = y 
  myBoss.w = 100
  myBoss.h = 73 
  myBoss.coefGrandeur = 0.1 
  myBoss.phase = 1
  
  myBoss.life = 200
  
  myBoss.internTimer = 0 
  
  myBoss.currentFrame = 0
  myBoss.image = love.graphics.newImage("images/mechankifepeur.png")
  myBoss.quad = love.graphics.newQuad(0,0,100,73,3600,73)
  
  myBoss.modif = {}
  myBoss.modif.o = 0
  myBoss.modif.r = 0
  myBoss.modif.ao = 0
  myBoss.modif.ar = 0
  myBoss.modif.back = false
  
  function myBoss.getHit(friendlyBullet)
    --local delBullet = false 
    --for i = 1,#friendlyBullet do
    local i = 1
    while i <= #friendlyBullet do
      if friendlyBullet[i].x  > myBoss.x - 100/2 and friendlyBullet[i].x  < myBoss.x - 100/2 + myBoss.w and friendlyBullet[i].y  > myBoss.y - 73/2 and friendlyBullet[i].y < myBoss.y - 73/2 + myBoss.h then 
        myBoss.life = myBoss.life - 1
        table.remove(friendlyBullet,i)
        i = i - 1 
      end 
      i = i + 1 
    end 
  end 
  
  function myBoss.update(dt,friendlyBullet)
    myBoss.getHit(friendlyBullet)
    myBoss.internTimer = myBoss.internTimer + 1
    if myBoss.phase == 1 then 
      myBoss.coefGrandeur = math.max(myBoss.coefGrandeur+ 0.1,1)
      
      if myBoss.coefGrandeur == 1 then 
        myBoss.phase = 2 
        myBoss.internTimer = 0 
      end 
    elseif myBoss.phase == 2 then
       
      
      if myBoss.internTimer >= 60 then
        myBoss.internTimer = 0
        myBoss.phase = 3 
      end 
    elseif myBoss.phase == 3 then
      myBoss.y = math.max(73,myBoss.y - 3)
      
      if myBoss.y == 73 then 
        myBoss.internTimer = 0 
        myBoss.phase = 4 
      end 
    elseif myBoss.phase == 4 then
      if myBoss.internTimer >= 60 then
        myBoss.internTimer = 0
        myBoss.phase = 5 
      end 
    elseif myBoss.phase == 5 then
      
      if myBoss.modif.back == false then
        if myBoss.internTimer % 5 == 0 then
        bulletList[#bulletList+1] = createSimpleBullet(myBoss.x,myBoss.y,5,5*math.pi/18 + myBoss.modif.o,5)
        bulletList[#bulletList+1] = createSimpleBullet(myBoss.x,myBoss.y,5,7*math.pi/18 + myBoss.modif.o,5)
        bulletList[#bulletList+1] = createSimpleBullet(myBoss.x,myBoss.y,5,11*math.pi/18 + myBoss.modif.o,5)
        bulletList[#bulletList+1] = createSimpleBullet(myBoss.x,myBoss.y,5,13*math.pi/18 + myBoss.modif.o,5)
        end 
        myBoss.modif.o = myBoss.modif.o - 0.01 
      else
        if myBoss.internTimer % 3 == 0 then
        bulletList[#bulletList+1] = createSimpleBullet(myBoss.x,myBoss.y,5,5*math.pi/18 + myBoss.modif.o,10)
        bulletList[#bulletList+1] = createSimpleBullet(myBoss.x,myBoss.y,5,7*math.pi/18 + myBoss.modif.o,10)
        bulletList[#bulletList+1] = createSimpleBullet(myBoss.x,myBoss.y,5,11*math.pi/18 + myBoss.modif.o,10)
        bulletList[#bulletList+1] = createSimpleBullet(myBoss.x,myBoss.y,5,13*math.pi/18 + myBoss.modif.o,10)
        end
        myBoss.modif.o = myBoss.modif.o + 0.05 
      end 
      
      if 13*math.pi/18 + myBoss.modif.o < 5*math.pi/18 then
        myBoss.modif.back = true
      elseif 5*math.pi/18 + myBoss.modif.o > 13*math.pi/18 then
        myBoss.modif.back = false
        myBoss.phase = 6
        myBoss.internTimer = 0 
      end
      
    elseif myBoss.phase == 6 then 
      
      if myBoss.internTimer % 5 == 0 then
        createSimpleBullet(myBoss.x,myBoss.y,10,vo,16,ao,ar)
        -- TODO : comprendre kes ke sé ke cette merde
        createSimpleBullet(myBoss.x,myBoss.y,10,vo,vr,ao,ar,lim,color)
      end 
      
      
      if myBoss.internTimer >= 100 then
        myBoss.internTimer = 0 
        myBoss.phase = 7
      end 
      
    elseif myBoss.phase == 7 then 
      
      
      
      if myBoss.internTimer >= 200 then
        myBoss.internTimer = 0 
        myBoss.phase = 5 
      end 
    end
  end 
  
  function myBoss.draw()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill',0,0,500,10)
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle('fill',0,0,500*(myBoss.life/200),10)
    love.graphics.setColor(1,1,1)
    myBoss.currentFrame = changeUntilYouCant(myBoss.currentFrame,0,35,1)
    myBoss.quad = love.graphics.newQuad(100*myBoss.currentFrame,0,100,73,3600,73)
    love.graphics.draw(myBoss.image,myBoss.quad,myBoss.x,myBoss.y,0,myBoss.coefGrandeur,myBoss.coefGrandeur,100/2,73/2)
  end 
  
  return myBoss 
end 


GameOver = false

bulletList = {}
friendlyBulletList = {}
monsterList = {}
bossList = {}
p = createPlayer()
timer = 0
speed = 100


function gameEvent(dt,timer)
  if timer == 100 then
    monsterList[#monsterList+1] = monster1(-7,100,p)
    monsterList[#monsterList+1] = monster1(-5,-10,p)
    monsterList[#monsterList+1] = monster1(250,-10,p)
    monsterList[#monsterList+1] = monster1(505,-10,p)
    monsterList[#monsterList+1] = monster1(507,100,p)
  elseif timer == 200 then
    for i = 1,9 do
      bulletList[#bulletList+1] = createSimpleBullet(520,(350/9)*i-350/18,8,math.pi,7,0,-1/21)
      bulletList[#bulletList+1] = createSimpleBullet(-20,((350/9)*i)+350-350/18,8,0,7,0,-1/21)
    end 
    for i = 1,7 do 
      bulletList[#bulletList+1] = createSimpleBullet(250/7*(i-0.5),-10,8,math.pi/2,10,0,-1/14)
      bulletList[#bulletList+1] = createSimpleBullet(250/7*(i-0.5) + 250 ,710,8,-math.pi/2,10,0,-1/14)
    end 
  elseif timer == 450 then
    monsterList[#monsterList+1] = monster1(-5,140,p)
    monsterList[#monsterList+1] = monster1(505,140,p)
  elseif timer == 470 then
    monsterList[#monsterList+1] = monster1(-5,280,p)
    monsterList[#monsterList+1] = monster1(505,280,p)
  elseif timer == 500 then
    monsterList[#monsterList+1] = monster1(-5,420,p)
    monsterList[#monsterList+1] = monster1(505,420,p)
  elseif timer == 530 then
    monsterList[#monsterList+1] = monster1(-5,560,p)
    monsterList[#monsterList+1] = monster1(505,560,p)
  elseif timer > 550 and timer < 650 then
    monsterList[#monsterList+1] = monster1(math.random() *500,math.random()*100,p)
  elseif timer >= 670 and timer < 1298 then
    local leOdu670 = math.acos(math.cos((timer-670)*math.pi/314))--y vien la ru la vré
    if  math.sin((timer-670)*math.pi/314)*100 < 0 then
      leOdu670 = -leOdu670
    end 
    if timer % 10 == 0 then
      bulletList[#bulletList+1] = createSimpleBullet(math.cos((timer-670)*math.pi/314)*100+250,math.sin((timer-670)*math.pi/314)*100+350,5,leOdu670,1,0,0,628-(timer-670))
    end 
  elseif timer == 1298 then
    bossList[#bossList+1] = createMechantBlob(250,350)
  end 
end 

function love.update(dt)
  if GameOver == false then
    timer = timer + 1
    p.update(dt,friendlyBulletList)

    gameEvent(dt,timer)
    
    for i = 1, #bossList do
      bossList[i].update(dt,friendlyBulletList,p)
    end
    for i = 1, #bossList do
      if bossList[i].life <= 0 then 
        table.remove(bossList,i)
        i = i - 1 
      end 
    end
    for i = 1, #monsterList do
      monsterList[i].update(dt,bulletList,p)
    end
    for i = 1, #friendlyBulletList do
      friendlyBulletList[i].update(dt)
    end
    for i = 1, #bulletList do
      bulletList[i].update(dt)
    end
    GameOver = p.die(bulletList)
  end 
  if #bulletList >= 3000 then
    table.remove(bulletList,1)
  end 
  if #monsterList >= 3000 then
    table.remove(monsterList,1)
  end 
end 


function love.draw()
  for i = 1, #friendlyBulletList do
    friendlyBulletList[i].draw()
  end
  for i = 1, #bulletList do
    bulletList[i].draw()
  end
  for i = 1, #bossList do
    bossList[i].draw()
  end
  for i = 1, #monsterList do
    monsterList[i].draw()
  end
  
  p.draw()
end 

function love.keypressed(key)
  if key == 'n' then
    --bulletList[#bulletList+1] = createBulletStraight(100,50,5,0,5)
    monsterList[#monsterList+1] = monster1(math.random() *500,math.random()*100,p)
  end 
  if key == 'r' then
    GameOver = false
    bulletList = {}
    monsterList = {}
    bossList = {}
    p.x = 250
    p.y = 550
    speed = 600
    timer = 0
  end 
end 

