gm = require "gm"
fs = require "fs-extra"
completeSizeList = require "./AppAssets"
File = require("./../../../lib/model/Schema")("files")
extend = require('util')._extend

module.exports = (setting, cb)->
  sizeList = completeSizeList()
  formats = ["shelf", "launch", "icon"]
  icon= ''
  background= ''
  logo= ''
  File.find(relation: 'setting:'+setting._id).exec (err, files)->
    if err then return
    if files.length != 0
      for i, file of files
        if file.key is 'background' then background = process.cwd()+'/public/files/'+file.name
        if file.key is 'logo' then logo = process.cwd()+'/public/files/'+file.name
        if file.key is 'icon' then icon = process.cwd()+'/public/files/'+file.name

    if background is "" then background = __dirname+'/templates/bg.jpg'
    if logo is '' && icon is ''
      logo = __dirname+'/templates/logo.png'
      icon = __dirname+'/templates/icon.png'
    else if logo is "" then logo = icon
    else if icon is "" then icon = logo
    createIcons formats.pop()


  createIcons = (format)->
    #key = if format is "icon" then "icon" else "logo"
    #size = if key is "logo" then width:1024,height:640 else width:286,height:286
    image = gm()

    iconInfos = sizeList[format]
    createIcon = (imgData)->
      targetDir = process.cwd()+'/cache/publish-baker/Baker/BakerAssets.xcassets/'
      if format is "icon"

        image = gm(icon)
        image.size (err, iconSize)->
          if err then throw err
          image.in("-resize", imgData.w).in "-gravity", "center"
          # newstand workaround
          if imgData.h>imgData.w
            image.extent imgData.w, imgData.h
            targetDir += "newsstand-app-icon.imageset"
          # icon
          else
            image.extent imgData.w, imgData.h
            image.in "-background", "transparent"
            targetDir += "AppIcon.appiconset"

          writeImage image, imgData, targetDir
      else # NON Icon
        newImg = "tmpImg.png"
        newBg = "tmpBg.png"
        gm(logo).size (err, logoSize)->
          if logoSize.height > logoSize.width
            if logoSize.height < imgData.h/4 then sizeOfLogo = logoSize.height
            else sizeOfLogo = imgData.h/4
            logoH = sizeOfLogo
            logoW = (logoSize.width)*(sizeOfLogo/logoSize.height)
            topPos = (imgData.h/3.75)-sizeOfLogo
          else
            if logoSize.width < logoSize.height then sizeOfLogo = logoSize.width
            else sizeOfLogo = imgData.w/3
            logoW = sizeOfLogo
            logoH = (logoSize.height)*(sizeOfLogo/logoSize.width)
            topPos = (imgData.w/2.375)-sizeOfLogo

          gm(logo).in("-resize", sizeOfLogo).write process.cwd()+'/public/files/'+newImg, ->
            gm(background).size (err, bgSize)->
              if imgData.w>imgData.h
                sizeOfBg=imgData.w
                ww = sizeOfBg
                hh = (imgData.height)*(sizeOfBg/logoSize.width)
              else
                sizeOfBg=imgData.h
                ww = (imgData.width)*(sizeOfBg/logoSize.height)
                hh = sizeOfBg

              if format is "shelf"
                if imgData.n.indexOf("portrait")>1 then targetDir += "shelf-bg-portrait.imageset"
                else
                  targetDir += "shelf-bg-landscape.imageset"
                  if logoW==sizeOfLogo then topPos /= 2.5 else topPos *= 2.5
              else if format is "launch"
                topPos = (imgData.h-logoH)/2
                targetDir += "LaunchImage.launchimage"

              gm(background)
                #.resize(sizeOfBg)
                .crop(imgData.w, imgData.h)#, ((ww-sizeOfBg)/2), ((hh-sizeOfBg)/2))
                .write process.cwd()+'/public/files/'+newBg, ->
                  image
                    .in('-page', '+0+0').in(process.cwd()+'/public/files/'+newBg)
                    .in('-page', '+'+((imgData.w-logoW)/2)+'+'+topPos)
                    .in(process.cwd()+'/public/files/'+newImg).flatten()
                  writeImage image, imgData, targetDir


    # write the image
    writeImage = (image, imgData, targetDir) ->
      targetImageLink = targetDir+"/"+imgData.n+".png"
      image.write targetImageLink, (err)->
        if err then return console.error("WriteImage error...",err)
        # check if icon variation is left
        if iconInfos.length>0 then createIcon iconInfos.pop()
        else
          # check if format variation is left
          if formats.length>0 then createIcons formats.pop()
          # else all done
          else cb()

    # start it up
    createIcon iconInfos.pop()
  return
