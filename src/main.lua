-- Consts
WINDOW_W = 800
WINDOW_H = 600

DIVE_INI = 0.1

ITER_INI = 100

function init()

  imageData = love.image.newImageData(WINDOW_W, WINDOW_H)
  img = love.graphics.newImage(imageData)
  
  xMin = -2
  xMax = 1
  yMin = -1
  yMax = 1

  targetCX = -0.743643887037151
  targetCY = 0.13182590420533

  maxIter = ITER_INI 
  
  diveSpeed = DIVE_INI
  
end

function love.load()

  love.window.setMode(WINDOW_W, WINDOW_H)
  love.window.setTitle('Mandelbrot’s fractal exploration')

  init()

end


function getCCoord(pX, pY)
  -- conversion :  pixel window coordinates  -> geometrical frame

  local c_coordX = (pX * (xMax - xMin) / WINDOW_W + xMin)
  local c_coordY = (pY * (yMax - yMin) / WINDOW_H + yMin)

  return c_coordX, c_coordY

end


function love.update(dt)

  imageData = love.image.newImageData(WINDOW_W, WINDOW_H)

  if love.keyboard.isDown('up') then
    maxIter = maxIter + 10 
  elseif love.keyboard.isDown('down') and maxIter > 10 then
    maxIter = maxIter - 10
  end

  if love.keyboard.isDown('left') then
    diveSpeed = diveSpeed - 0.05
  elseif love.keyboard.isDown('right') then
    diveSpeed = diveSpeed + 0.05
  end

  
  if love.mouse.isDown(1) then
    mousePosX, mousePosY = love.mouse.getPosition()
    targetCX, targetCY  = getCCoord(mousePosX, mousePosY)
  end
  
  for y = 0, WINDOW_H-1 do
    for x = 0, WINDOW_W-1 do

      cx, cy = getCCoord(x, y)

      -- center
      xN1 = 0
      yN1 = 0

      -- iteration index
      iter = 0

      while (xN1 * xN1 + yN1 * yN1) < 4 and iter < maxIter do

        xN = xN1
        yN = yN1
        xN1 = xN * xN - yN * yN + cx
        yN1 = 2 * xN * yN + cy

        iter = iter + 1
      end

      color = iter / maxIter 

      if iter <= maxIter then
        imageData:setPixel(x, y, color *0.4, color*0.5, color*0.6, 1)
      else
        imageData:setPixel(x,y, 0, 0, 0, 1)
      end

    end
  end

  img = love.graphics.newImage(imageData)

  xMax = xMax - math.abs(xMax - targetCX) * diveSpeed * dt
  xMin = xMin + math.abs(xMin - targetCX) * diveSpeed * dt
  yMax = yMax - math.abs(yMax - targetCY) * diveSpeed * dt
  yMin = yMin + math.abs(yMin - targetCY) * diveSpeed * dt

end


function love.draw()
  
  love.graphics.draw(img)
  love.graphics.print('Click to define a target point', 10, 10)
  love.graphics.print('Right/Left to change dive speed: '..tostring(diveSpeed), 10, 30)
  love.graphics.print('Up/Down to change max iterations: '..tostring(maxIter), 10, 50)
  love.graphics.print('r to reset, echap to quit', 10, 70)

end

function love.keypressed(key)

  if key == 'escape' then
    love.event.quit()
  end

  if key == 'r' then
    init()
  end

end
