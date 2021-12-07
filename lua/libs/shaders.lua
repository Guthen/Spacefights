require "lua.libs.util"

--  colors
BLACK = rgb( 0, 0, 0 )
WHITE = rgb( 255, 255, 255 )
RED = rgb( 255, 0, 0 )
BLUE = rgb( 0, 0, 255 )
PURPLE = rgb( 255, 0, 255 )
ORANGE = rgb( 255, 121, 48 )
GREEN = rgb( 73, 170, 16 )

--  shaders
Shaders = {}

local path = "assets/shaders"
for i, v in ipairs( love.filesystem.getDirectoryItems( path ) ) do
    Shaders[v:gsub( "%.%w+$", "" ):upper()] = love.graphics.newShader( path .. "/" .. v )
end