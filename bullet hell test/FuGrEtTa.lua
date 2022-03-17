--ceci est une biblioteque que j'ai creer et continue a construire contenant des Fonction portant sur les grilles et tables (FunctionGrilleEtTable)
-- donc svp ne modifier pas nimporte comment les fonction deja presentes qui marchent 
--ps  : vous pouvez en ajouter si cela a un raport de pres ou de loin avec les grilles et tables 
--ps2 : je ne suis pas extremenent bon alors si il y a des fautes dites le moi 




function AstarGrid(start,goal,murs,ligne,colonne) -- path finder A* : start et goal sont des tables a 2 valeur (x,y) et mur est une table de tables a 2 valeur 
  --retourne une table de tables a 2 valeur partant du debut vers la fin du chemin 
    function spot(tablee,i,j)
        tablee.x = i
        tablee.y = j
        tablee.f = 0
        tablee.g = 0
        tablee.h = 0
        tablee.voisin = {}
        tablee.CameFrom = {}
        
        function tablee.PlusDeVoisin(grid)
          local i2 = tablee.x
          local j2 = tablee.y
          if i2 > 1 then 
            tablee.voisin[#tablee.voisin+1] = grid[i-1][j]
          end
          if i2 < ligne then 
                  tablee.voisin[#tablee.voisin+1] = grid[i+1][j]
          end
          if j2 > 1 then
                  tablee.voisin[#tablee.voisin+1] = grid[i][j-1]
          end
          if j2 < colonne then
                  tablee.voisin[#tablee.voisin+1] = grid[i][j+1]
          end
        end
      end


    


    local grille = {} 
    for i = 1,colonne do
    grille[i] = {}
        for j = 1,ligne do 
            grille[i][j] = {}
            spot(grille[i][j],i,j)
        end 
    end 
    for i = 1,colonne do
        for j = 1,ligne do 
          grille[i][j].PlusDeVoisin(grille)
        end 
    end       
    
    local theWay = {}
    local openset = {}
    local closeset = {}
    for i  = 1,#murs do
        table.insert(closeset,grille[murs[i][1]][murs[i][2]])
    end
    

    local debut = grille[start[1]][start[2]]
    local fin = grille[goal[1]][goal[2]]

    openset[#openset+1] =  debut
    

    while #openset > 0 do
        theWay = {}
        winner = 1
        for i = 1,#openset do
            if openset[i].f < openset[winner].f then
            winner = i
            end
        end 
        current = openset[winner]
        table.remove(openset,winner)
        table.insert(closeset,current)

        for i = 1,#current.voisin do
            levoisin = current.voisin[i]
            
            if notVinT(closeset,levoisin) then
                tempG = current.g + 1
                
                levoisin.g = tempG
                levoisin.h = heuristic(levoisin,fin)
                levoisin.f = levoisin.g + levoisin.h
                levoisin.CameFrom = current
                if notVinT(openset,levoisin) then
                table.insert(openset,levoisin)
                end
            end
        end
        if current == fin then
            run = false
            test = true 
            while test do
                if type(current.CameFrom) == "nil" then
                    test = false
                else
                    theWay[#theWay+1] = current
                    current = current.CameFrom
                end
            end
            return theWay
        end
    end 
    return {} 
end



function heuristic(a,b) -- uttilisée par A*, mais pour l'instant c'est juste une fonction distance
    local varHeu =((b.x - a.x)^2 + (b.y - a.y)^2)^0.5
    --  local varHeu = b.x - a.x + b.y - a.y
    --  local varHeu =-((b.x - a.x)^2 + (b.y - a.y)^2)^0.5
    return varHeu
end


function notVinT(T,V) -- uttilisée par A*, test si un element n'est pas dans une table
    for i = 1,#T do
      if T[i].x == V.x and T[i].y == V.y then
      return false
      end
    end
    return true
end

function reversTable(tabl) -- retourne la table (fin vers debut)
  local rtabl = {}
  for i = 0,#tabl-1 do
    table.insert(rtabl,tabl[#tabl-i])
    --table.remove(tabl, #tabl)
  end
  return rtabl 
end


function LongAstarGrid(start,goal,murs,ligne,colonne) -- a star mais pour le plus long chemin
    function spot(tablee,i,j)
        tablee.x = i
        tablee.y = j
        tablee.f = 0
        tablee.g = 0
        tablee.h = 0
        tablee.voisin = {}
        tablee.CameFrom = {}
        
        function tablee.PlusDeVoisin(grid)
          local i2 = tablee.x
          local j2 = tablee.y
          if i2 > 1 then 
            tablee.voisin[#tablee.voisin+1] = grid[i-1][j]
          end
          if i2 < ligne then 
                  tablee.voisin[#tablee.voisin+1] = grid[i+1][j]
          end
          if j2 > 1 then
                  tablee.voisin[#tablee.voisin+1] = grid[i][j-1]
          end
          if j2 < colonne then
                  tablee.voisin[#tablee.voisin+1] = grid[i][j+1]
          end
        end
      end


    


    local grille = {} 
    for i = 1,colonne do
    grille[i] = {}
        for j = 1,ligne do 
            grille[i][j] = {}
            spot(grille[i][j],i,j)
        end 
    end 
    for i = 1,colonne do
        for j = 1,ligne do 
          grille[i][j].PlusDeVoisin(grille)
        end 
    end       
    
    local theWay = {}
    local openset = {}
    local closeset = {}
    for i  = 1,#murs do
        table.insert(closeset,grille[murs[i][1]][murs[i][2]])
    end
    

    local debut = grille[start[1]][start[2]]
    local fin = grille[goal[1]][goal[2]]

    openset[#openset+1] =  debut
    

    while #openset > 0 do
        theWay = {}
        winner = 1
        for i = 1,#openset do
            if openset[i].f > openset[winner].f then
            winner = i
            end
        end 
        current = openset[winner]
        table.remove(openset,winner)
        table.insert(closeset,current)

        for i = 1,#current.voisin do
            levoisin = current.voisin[i]
            
            if notVinT(closeset,levoisin) then
                tempG = current.g + 1
                
                levoisin.g = tempG
                levoisin.h = heuristic(levoisin,fin)
                levoisin.f = levoisin.g + levoisin.h
                levoisin.CameFrom = current
                if notVinT(openset,levoisin) then
                table.insert(openset,levoisin)
                end
            end
        end
        if current == fin then
            run = false
            test = true 
            while test do
                if type(current.CameFrom) == "nil" then
                    test = false
                else
                    theWay[#theWay+1] = current
                    current = current.CameFrom
                end
            end
            return theWay
        end
    end 
    return {}
end


function add2Table(a,b) --sert a concatener des tables simples (inutile depuis la fonction suivante)
  for i = 1,#b do
    a[#a+1] = b[i]
  end
  return a
end


function assingTableOld(AT) -- sert a faire : table = table, mais element par element ce qui fait que quand on modifie la 2eme table la premiere reste intacte 
  -- (crée 2 tables au lieu de la copier) 
  --ca marche qu'avec les table numerotés : {1,3,4,66,{567,2},"comme ça"} mais pas les autres : {r = 1, a = 55, 4 = 6,...}
  local NT = {}
  for i = 1,#AT do
    if type(AT[i]) == "table" then
      NT[#NT+1] = assingTable(AT[i])
    else
      NT[#NT+1] = AT[i]
    end 
  end
  return NT 
end

function assingTable(AT)-- sert a faire : table = table, mais element par element ce qui fait que quand on modifie la 2eme table la premiere reste intactes
  -- normalement ca marche mais je suis pas sur 
  local NT = {}
  for k,v in pairs(AT) do
    if type(k) == "number" then
      if type(v) == "table" then
        NT[#NT+1] = assingTable(AT[i])
      else
        NT[#NT+1] = v
      end 
    elseif type(k) == "string" then
      if type(v) == "table" then
        NT[k] = assingTable(v)
      else
        NT[k] = v
      end 
    end
  end
  return NT 
end

function TinT2Cmarchepas(E,T,p) -- yep ça marche pas
  local G = false
  local Path = p or {}
  if type(E) == "table" then
    EinT(E[1],v)
  else 
    for k,v in pairs(T) do
      if type(v) == "table" then
        G = EinT(E,v)
      end
      if E == v or G then
        return true
      end
    end
  end
end


function EinT(E,T) -- cherche si un element dans une table (ou dans une table elle meme dans la table) ( normalement ca marche mais je vois pas trop l'uttilité)
  -- (c'est surtout assez mal pensé )
  local G = false
  local emplacement = {}
  for k,v in pairs(T) do
    if type(v) == "table" then
      G , emplacement[#emplacement+1] = EinT(E,v)
    end
    if E == v or G then
      emplacement[#emplacement+1] = k
      return true, emplacement
    end
  end
  return false, {}
end



function tbprint(tbl)-- print une table (avec tout dedan) (sans doute la fonction la plus fiable car la seule pas directement coder par moi XD)
  if type(tbl) ~= "table" then 
    return tbl
  end 
  local toprint = "{"
  for k, v in pairs(tbl) do
--    if (type(k) == "number") then
--      toprint = toprint .. "[" .. k .. "] = "
    if (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ", "
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\", "
    elseif (type(v) == "table") then
      toprint = toprint .. tbprint(v) .. ",\n "
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\", "
    end
  end
  toprint = toprint  .. "}"
  return toprint -- retourne une chaine de charactaire il faut donc print(tbprint())
end

function sum(table) -- additione tous les elements d'une table
  local somme = 0
  for key,i in pairs(table) do
    somme = somme + i
  end 
  return somme
end

function lePlusGrandDe(table) -- dans le nom
  local lepp = table[1]
  local leppkey = 1
  for key,v in pairs(table) do
    if v > lepp then
      lepp = v
      leppkey = key
    end 
  end 
  return lepp,leppkey
end 


function lineEgual(list) -- test si tout les element d'une liste sont les mêmes (ne marche pas pour les tables d'1 element ou moins mais en meme temps ca sert pas a grand chose) 
  local test = true 
  for i=1,#list-1 do
    test = test == (list[i] == list [i+1])
    if test == false then
      return false 
    end 
  end 
  test = test == (list[1] == list [#list])
  if test == true and list[1] ~= 0 then
    return true 
  else 
    return false 
  end 
end 

function changeUntilYouCant(v,o,l,i) -- sous coté
  if i > 0 then
    if v >= l then 
      v = o 
    else
      v = v + i 
    end
  elseif i < 0 then
    if v <= l then 
      v = o 
    else
      v = v + i 
    end
  end
    
  return v
end 

function tableContains(table, element) for _, value in pairs(table) do if value == element then return true end end return false end

function mapContain(table, element, Key)
  for _,value in pairs(table) do
    for key2,value2 in pairs(value) do
      if value2 == element and key2 == Key then
        return true
      end
    end
  end
  return false
end


--function CaseVoisine(tabl,lignes,colonnes)
--  local TableVoisin = {}
--  for i = 1,#tabl do
--    if tabl[i][2] > 1 then
--      TableVoisin[#TableVoisin+1] = {tabl[i][1],tabl[i][2]-1}
--    end
--    if tabl[i][2] < colonnes then
--      TableVoisin[#TableVoisin+1] = {tabl[i][1],tabl[i][2]+1}
--    end
--    if tabl[i][1] > 1 then
--      TableVoisin[#TableVoisin+1] = {tabl[i][1]-1,tabl[i][2]}
--    end
--    if tabl[i][1] < lignes then
--      TableVoisin[#TableVoisin+1] = {tabl[i][1]+1,tabl[i][2]}
--    end
--  end
--  for i = 1,#TableVoisin do
--    print(TableVoisin[i][1])
--    print(TableVoisin[i][2])
--    print("----------------------------")
--  end
--  return TableVoisin
--end

----function removeVoTeEtQu(TaVo,tete,queue)
----  for i = 1,#TaVo do
----    if #TaVo > 0 then
----    if TaVo[i][1] == tete[1]+1 and TaVo[i][2] == tete[2] then
----      table.remove(TaVo,i)
----    end
----    end
----    if #TaVo > 0 then
----    if TaVo[i][1] == tete[1]-1 and TaVo[i][2] == tete[2] then
----      table.remove(TaVo,i)
----    end
----    end
----    if #TaVo > 0 then
----    if TaVo[i][1] == tete[1] and TaVo[i][2] == tete[2]+1 then
----      table.remove(TaVo,i)
----    end
----    end
----    if #TaVo > 0 then
----    if TaVo[i][1] == tete[1] and TaVo[i][2] == tete[2]-1 then
----      table.remove(TaVo,i)
----    end
----    end
    
----    if #TaVo > 0 then
----    if TaVo[i][1] == queue[1]+1 and TaVo[i][2] == queue[2] then
----      table.remove(TaVo,i)
----    end
----    end
----    if #TaVo > 0 then
----    if TaVo[i][1] == queue[1]-1 and TaVo[i][2] == queue[2] then
----      table.remove(TaVo,i)
----    end
----    end
----    if #TaVo > 0 then
----    if TaVo[i][1] == queue[1] and TaVo[i][2] == queue[2]+1 then
----      table.remove(TaVo,i)
----    end
----    end
----    if #TaVo > 0 then
----    if TaVo[i][1] == queue[1] and TaVo[i][2] == queue[2]-1 then
----      table.remove(TaVo,i)
----    end
----    end
----  end
  
----end