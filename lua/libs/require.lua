local cache = {}

local _require = require
function require( path, use_cache )
    use_cache = use_cache == nil and true or use_cache

    if path:match( "%*$" ) then
        path = path:gsub( "%.%*$", "" ):gsub( "%.", "/" )
        for i, v in ipairs( love.filesystem.getDirectoryItems( path ) ) do
            local no_extension = v:gsub( "%.lua$", "" )
            local file_path = path .. "/" .. no_extension
            if not ( no_extension == v ) and ( not use_cache or not cache[file_path] ) then
                require( file_path, use_cache )
            end
        end
    else
        path = path:gsub( "%.", "/" )
        if use_cache then
            if not cache[path] then
                cache[path] = _require( path )
            end

            return cache[path]
        end

        return _require( path )
    end
end