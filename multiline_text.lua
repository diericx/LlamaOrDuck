local display = display 
local native = native 
 
 
local screenW = display.contentWidth 
local screenH = display.contentHeight 
local sW = screenW*.5 
local sH = screenH*.5 
 
 
local SPACE_BETWEEN_LINES = 8
 
local function addText(params)
        local group = params.group 
        local str = params.str 
        local textY = params.y or 0
        local fontName = params.fontName 
        local finalSize = params.finalSize
        local color = params.color 
        
        
        if str and str:sub(1,1)==" " then       --delete a single space. to rectify single space which may occur when splitting 
                str = str:sub(2,-1)
        end 
        
        
        local text
        if group then 
                text = display.newText(group,str,sW,sH,fontName,finalSize)      
        else
                text = display.newText(str,sW,sH,fontName,finalSize)    
        end 
        
        local spaceBetweenLines = SPACE_BETWEEN_LINES 
        text.x = sW
        text.y = textY + spaceBetweenLines
        
        
        
        text.isText = true                                      
 
        text:setTextColor(color[1],color[2],color[3])
        text.fontName = fontName
        text.clr = color
        text.fsize = finalSize
        text.finalText = str 
                                                
        return text 
end 
        
local function findLastSpaceBeforeCurrentChar(params)
        local fontName = params.fontName 
        local finalSize = params.finalSize
        local color = params.color
        local text = params.text 
        local original_line = params.original_line 
        local i = params.index 
        local textY = params.textY
        local multiTextgroup = params.group
        
        local toCut
        local rev = original_line:reverse()
        local space = rev:find(" ",i)
        if space then 
                toCut = space + 1
                toCut = -toCut
                
                local txt1 = original_line:sub(1,toCut)
                text:removeSelf()
                
                text = addText
                {
                group = multiTextgroup,
                str = txt1,
                y = textY,
                color = color,
                fontName = fontName,
                finalSize = finalSize,
                }                                                                       
 
                toCut = toCut + 2
        else 
                toCut = -i
        end 
        
        return text,toCut
end 
        
        
local function splitText(params)
        local line = params.line 
        local multiTextgroup = params.group 
        local textY = params.textY
        local text = params.text 
        local texts = params.texts
        local fontName = params.fontName 
        local finalSize = params.finalSize
        local color = params.color
        local lineLength = params.lineLength
 
        
        local original_line = line 
        local i = 0
        
        local text1,text2 
        while (text.contentBounds.xMax-text.contentBounds.xMin) > lineLength do 
                text:removeSelf()
                line = line:sub(1,-2)
                
                text = addText
                {
                group = multiTextgroup,
                str = line,
                y = textY,
                color = color,
                fontName = fontName,
                finalSize = finalSize,
                }                                                                       
                i = i + 1 
        end 
        
 
 
        local toCut
        text,toCut = findLastSpaceBeforeCurrentChar
                {
                textY = textY,
                text = text,
                original_line = original_line,
                index = i,
                color = color,
                fontName = fontName,
                finalSize = finalSize,
                group = multiTextgroup,
                }
 
        
        
        local text1YMax = text.contentBounds.yMax
        textY = text1YMax
        
        local remainingLine = original_line:sub(toCut,-1)
        local text1 = text 
        local text2 = addText
                                        {
                                        group = multiTextgroup,
                                        str = remainingLine,
                                        y = textY,
                                        color = color,
                                        fontName = fontName,
                                        finalSize = finalSize,
                                        }
        textY = text2.contentBounds.yMax
        texts[#texts+1] = text1 
        
        if (text2.contentBounds.xMax-text2.contentBounds.xMin) > lineLength then 
                        textY = splitText
                                {
                                text = text2,
                                group = multiTextgroup,
                                line = remainingLine,
                                textY = text1YMax,
                                texts = texts,
                                color = color,
                                fontName = fontName,
                                finalSize = finalSize,
                                lineLength = lineLength,
                                }                                               
        else 
                texts[#texts+1] = text2
        end
                                                        
        return textY
end             
 
 
 
 
 
function processTextWithNewLine(params)
        local finalText = params.finalText
        local fontName = params.fontName
        local finalSize = params.finalSize
        local color = params.color
        local lineLength = params.lineLength
        local group = params.group 
        local align = params.align
        
        local multiTextgroup = display.newGroup()
        if group then 
                group:insert(multiTextgroup)
        end 
        
        local textY = 0
        local texts = {}
        
        for line in string.gmatch(finalText, "[^\n]+") do
 
 
                local text = addText
                        {
                        group = multiTextgroup,
                        str = line,
                        y = textY,
                        fontName = fontName,
                        finalSize = finalSize,
                        color = color,
                        }
                local original_textY = textY
                local original_line = line 
                texts[#texts+1] = text 
                textY = text.contentBounds.yMax
                
                
                if (text.contentBounds.xMax-text.contentBounds.xMin) > lineLength then 
                        texts[#texts] = nil
                        textY = splitText
                                {
                                fontName = fontName,
                                finalSize = finalSize,
                                text = text,
                                group = multiTextgroup,
                                line = original_line,
                                textY = original_textY,
                                texts = texts,
                                color = color,
                                lineLength = lineLength,
                                }                                                                                       
                end 
                
        end
        multiTextgroup:setReferencePoint(display.CenterReferencePoint)
        multiTextgroup.y = sH
        
        --left align
        if align == "left" then
                local firstRowXMin = multiTextgroup[1].contentBounds.xMin
                for i=1,multiTextgroup.numChildren do 
                        multiTextgroup[i].x = firstRowXMin + multiTextgroup[i].width/2
                end
        elseif align == "right" then 
                local firstRowXMax = multiTextgroup[1].contentBounds.xMax
                for i=1,multiTextgroup.numChildren do 
                        multiTextgroup[i].x = firstRowXMax - multiTextgroup[i].width/2
                end
        end 
        
        
        --remove underscores which we inserted to replace \n\n with \n_\n 
        for i=1,#texts do 
                if texts[i].text == "_" then 
                        texts[i].text = " "
                end 
        end 
        
        
        
        --store in group
        for i=1,#texts do 
                group.__singleLineTexts[#group.__singleLineTexts+1] = texts[i]
        end 
end 
 
 
function processTextWithoutNewLine(params)
        local finalText = params.finalText
        local fontName = params.fontName
        local finalSize = params.finalSize
        local color = params.color
        local lineLength = params.lineLength
        local group = params.group 
        local align = params.align
 
        local text = addText
                                        {
                                        str = finalText,
                                        fontName = fontName,
                                        finalSize = finalSize,
                                        color = color,
                                        group = group,
                                        }
        text.y = sH     
        
 
        
        if (text.contentBounds.xMax-text.contentBounds.xMin) <= lineLength then 
                group.__singleLineTexts[1] = text
        else 
                local multiTextgroup = display.newGroup()
                group:insert(multiTextgroup)
                
                local textY = 0
                local texts = {}
                textY = splitText
                        {
                        text = text,
                        group = multiTextgroup,
                        line = finalText,
                        textY = textY,
                        texts = texts,
                        fontName = fontName,
                        finalSize = finalSize,
                        color = color,
                        lineLength = lineLength,
                        }       
                multiTextgroup:setReferencePoint(display.CenterReferencePoint)
                multiTextgroup.y = sH
                
                --align
                if align == "left" then
                        local firstRowXMin = multiTextgroup[1].contentBounds.xMin
                        for i=1,multiTextgroup.numChildren do 
                                multiTextgroup[i].x = firstRowXMin + multiTextgroup[i].width/2
                        end 
                elseif align == "right" then 
                        local firstRowXMax = multiTextgroup[1].contentBounds.xMax
                        for i=1,multiTextgroup.numChildren do 
                                multiTextgroup[i].x = firstRowXMax - multiTextgroup[i].width/2
                        end
                end 
                
                
                --store in group
                for i=1,#texts do 
                        group.__singleLineTexts[#group.__singleLineTexts+1] = texts[i]
                end 
        end 
end 
 
 
 
 
 
 
 
function display.newMultiLineText(params)
        
        local text = params.text or ""
        local width = params.width 
        local l = params.left or 0 
        local t = params.top or 0
        local font = params.font or native.systemFont 
        local fontSize = params.fontSize or 14
        local color = params.color or {0,0,0}
        local align = params.align
        
        
        local group = display.newGroup()
        group.__singleLineTexts = {}
        
        if (not width) and (not text:find("\n")) then 
                local textObject = display.newText(group,text,l,t,font,fontSize)
                textObject:setTextColor(color[1],color[2],color[3])
                group.__singleLineTexts[1] = textObject
                return group
        end 
        
        
        if text:find("\n") then 
                processTextWithNewLine
                        {
                        finalText = text,
                        fontName = font,
                        finalSize = fontSize,
                        color = color,
                        lineLength = width,
                        group = group,
                        align = align,
                        }
                
        else 
                processTextWithoutNewLine
                        {
                        finalText = text,
                        fontName = font,
                        finalSize = fontSize,
                        color = color,
                        lineLength = width,
                        group = group,
                        align = align,
                        }                                                               
        end 
        
        group:setReferencePoint(display.CenterReferencePoint)
        group.x = l + group.width/2 
        group.y = t + group.height/2 
        
        return group 
        
end 