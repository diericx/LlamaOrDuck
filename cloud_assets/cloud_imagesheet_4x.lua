--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:d3c136a25bc33cf9a06b639a1f3c6b4b$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- button_close@4x
            x=916,
            y=146,
            width=102,
            height=102,

            sourceX = 10,
            sourceY = 8,
            sourceWidth = 120,
            sourceHeight = 120
        },
        {
            -- button_close_over@4x
            x=812,
            y=146,
            width=102,
            height=102,

            sourceX = 10,
            sourceY = 8,
            sourceWidth = 120,
            sourceHeight = 120
        },
        {
            -- button_delete@4x
            x=960,
            y=64,
            width=60,
            height=60,

            sourceX = 6,
            sourceY = 6,
            sourceWidth = 72,
            sourceHeight = 72
        },
        {
            -- button_delete_over@4x
            x=960,
            y=2,
            width=60,
            height=60,

            sourceX = 6,
            sourceY = 6,
            sourceWidth = 72,
            sourceHeight = 72
        },
        {
            -- corona_logo@4x
            x=2,
            y=2,
            width=590,
            height=590,

            sourceX = 4,
            sourceY = 4,
            sourceWidth = 600,
            sourceHeight = 600
        },
        {
            -- dash_achievements@4x
            x=878,
            y=350,
            width=90,
            height=98,

            sourceX = 28,
            sourceY = 22,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- dash_achievements_over@4x
            x=786,
            y=350,
            width=90,
            height=98,

            sourceX = 28,
            sourceY = 22,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- dash_friends@4x
            x=720,
            y=2,
            width=124,
            height=92,

            sourceX = 8,
            sourceY = 22,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- dash_friends_over@4x
            x=594,
            y=2,
            width=124,
            height=92,

            sourceX = 8,
            sourceY = 22,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- dash_leaderboards@4x
            x=690,
            y=306,
            width=94,
            height=94,

            sourceX = 22,
            sourceY = 22,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- dash_leaderboards_over@4x
            x=594,
            y=306,
            width=94,
            height=94,

            sourceX = 22,
            sourceY = 22,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- dash_messages@4x
            x=846,
            y=74,
            width=112,
            height=70,

            sourceX = 14,
            sourceY = 34,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- dash_messages_over@4x
            x=846,
            y=2,
            width=112,
            height=70,

            sourceX = 14,
            sourceY = 34,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- dash_news@4x
            x=888,
            y=250,
            width=96,
            height=98,

            sourceX = 22,
            sourceY = 22,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- dash_news_over@4x
            x=790,
            y=250,
            width=96,
            height=98,

            sourceX = 22,
            sourceY = 22,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- dash_notifications@4x
            x=660,
            y=402,
            width=64,
            height=96,

            sourceX = 38,
            sourceY = 24,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- dash_notifications_over@4x
            x=594,
            y=402,
            width=64,
            height=96,

            sourceX = 38,
            sourceY = 24,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- dash_social@4x
            x=692,
            y=206,
            width=96,
            height=98,

            sourceX = 22,
            sourceY = 20,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- dash_social_over@4x
            x=594,
            y=206,
            width=96,
            height=98,

            sourceX = 22,
            sourceY = 20,
            sourceWidth = 140,
            sourceHeight = 140
        },
        {
            -- popup_cancel@4x
            x=704,
            y=96,
            width=106,
            height=108,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 112,
            sourceHeight = 112
        },
        {
            -- popup_confirm@4x
            x=594,
            y=96,
            width=108,
            height=108,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 112,
            sourceHeight = 112
        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 1024
}

SheetInfo.frameIndex =
{

    ["button_close@4x"] = 1,
    ["button_close_over@4x"] = 2,
    ["button_delete@4x"] = 3,
    ["button_delete_over@4x"] = 4,
    ["corona_logo@4x"] = 5,
    ["dash_achievements@4x"] = 6,
    ["dash_achievements_over@4x"] = 7,
    ["dash_friends@4x"] = 8,
    ["dash_friends_over@4x"] = 9,
    ["dash_leaderboards@4x"] = 10,
    ["dash_leaderboards_over@4x"] = 11,
    ["dash_messages@4x"] = 12,
    ["dash_messages_over@4x"] = 13,
    ["dash_news@4x"] = 14,
    ["dash_news_over@4x"] = 15,
    ["dash_notifications@4x"] = 16,
    ["dash_notifications_over@4x"] = 17,
    ["dash_social@4x"] = 18,
    ["dash_social_over@4x"] = 19,
    ["popup_cancel@4x"] = 20,
    ["popup_confirm@4x"] = 21,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
