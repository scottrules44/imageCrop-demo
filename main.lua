local imageCrop = require "plugin.imageCrop"
---file moving
local function doesFileExist( fname, path )
 
    local results = false
 
    -- Path for the file
    local filePath = system.pathForFile( fname, path )
 
    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" )
 
        if not file then
            -- Error occurred; output the cause
            print( "File error: " .. errorString )
        else
            -- File exists!
            print( "File found: " .. fname )
            results = true
            -- Close the file handle
            file:close()
        end
    end
 
    return results
end
local function copyFile( srcName, srcPath, dstName, dstPath, overwrite )
 
    local results = false
 
    local fileExists = doesFileExist( srcName, srcPath )
    if ( fileExists == false ) then
        return nil  -- nil = Source file not found
    end
 
    -- Check to see if destination file already exists
    if not ( overwrite ) then
        if ( fileLib.doesFileExist( dstName, dstPath ) ) then
            return 1  -- 1 = File already exists (don't overwrite)
        end
    end
 
    -- Copy the source file to the destination file
    local rFilePath = system.pathForFile( srcName, srcPath )
    local wFilePath = system.pathForFile( dstName, dstPath )
 
    local rfh = io.open( rFilePath, "rb" )
    local wfh, errorString = io.open( wFilePath, "wb" )
 
    if not ( wfh ) then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Read the file and write to the destination directory
        local data = rfh:read( "*a" )
        if not ( data ) then
            print( "Read error!" )
            return false
        else
            if not ( wfh:write( data ) ) then
                print( "Write error!" )
                return false
            end
        end
    end
 
    results = 2  -- 2 = File copied successfully!
 
    -- Close file handles
    rfh:close()
    wfh:close()
 
    return results
end
copyFile( "coronaLogo.png.txt", nil, "coronaLogo.png", system.DocumentsDirectory, true )
---
local orginalImage = display.newImage( "coronaLogo.png", system.DocumentsDirectory, display.contentCenterX, display.contentCenterY-20 )

timer.performWithDelay( 1000, function (  )
    --scale down
    local pathForScaleDown = system.pathForFile( "coronaLogoScaleDown.png", system.DocumentsDirectory)
    imageCrop.setResolution( system.pathForFile( "coronaLogo.png", system.DocumentsDirectory ), orginalImage.width/2, orginalImage.height/2, pathForScaleDown)
    local scaleDownImage = display.newImage( "coronaLogoScaleDown.png", system.DocumentsDirectory, display.contentCenterX, display.contentCenterY+20 )

    --crop image (this case it will only say corona)
    local pathForCrop = system.pathForFile( "coronaLogoCrop.png", system.DocumentsDirectory)
    imageCrop.crop( system.pathForFile( "coronaLogo.png", system.DocumentsDirectory ), 42, 0, 85, 40, pathForCrop)
    local cropImage = display.newImage( "coronaLogoCrop.png", system.DocumentsDirectory, display.contentCenterX, display.contentCenterY+60 )
end )
