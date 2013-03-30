--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:fa515d6eccc677ad9835e4c7b78e512a$
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
            -- button_close@2x
            x=64,
            y=448,
            width=60,
            height=60,

        },
        {
            -- button_close_over@2x
            x=2,
            y=448,
            width=60,
            height=60,

        },
        {
            -- button_delete@2x
            x=280,
            y=448,
            width=36,
            height=36,

        },
        {
            -- button_delete_over@2x
            x=242,
            y=448,
            width=36,
            height=36,

        },
        {
            -- corona_logo@2x
            x=2,
            y=2,
            width=300,
            height=300,

        },
        {
            -- dash_achievements@2x
            x=434,
            y=74,
            width=70,
            height=70,

        },
        {
            -- dash_achievements_over@2x
            x=362,
            y=74,
            width=70,
            height=70,

        },
        {
            -- dash_friends@2x
            x=434,
            y=2,
            width=70,
            height=70,

        },
        {
            -- dash_friends_over@2x
            x=362,
            y=2,
            width=70,
            height=70,

        },
        {
            -- dash_leaderboards@2x
            x=290,
            y=376,
            width=70,
            height=70,

        },
        {
            -- dash_leaderboards_over@2x
            x=290,
            y=304,
            width=70,
            height=70,

        },
        {
            -- dash_messages@2x
            x=218,
            y=376,
            width=70,
            height=70,

        },
        {
            -- dash_messages_over@2x
            x=218,
            y=304,
            width=70,
            height=70,

        },
        {
            -- dash_news@2x
            x=146,
            y=376,
            width=70,
            height=70,

        },
        {
            -- dash_news_over@2x
            x=146,
            y=304,
            width=70,
            height=70,

        },
        {
            -- dash_notifications@2x
            x=74,
            y=376,
            width=70,
            height=70,

        },
        {
            -- dash_notifications_over@2x
            x=74,
            y=304,
            width=70,
            height=70,

        },
        {
            -- dash_social@2x
            x=2,
            y=376,
            width=70,
            height=70,

        },
        {
            -- dash_social_over@2x
            x=2,
            y=304,
            width=70,
            height=70,

        },
        {
            -- popup_cancel@2x
            x=184,
            y=448,
            width=56,
            height=56,

        },
        {
            -- popup_confirm@2x
            x=126,
            y=448,
            width=56,
            height=56,

        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 512
}

SheetInfo.frameIndex =
{

    ["button_close@2x"] = 1,
    ["button_close_over@2x"] = 2,
    ["button_delete@2x"] = 3,
    ["button_delete_over@2x"] = 4,
    ["corona_logo@2x"] = 5,
    ["dash_achievements@2x"] = 6,
    ["dash_achievements_over@2x"] = 7,
    ["dash_friends@2x"] = 8,
    ["dash_friends_over@2x"] = 9,
    ["dash_leaderboards@2x"] = 10,
    ["dash_leaderboards_over@2x"] = 11,
    ["dash_messages@2x"] = 12,
    ["dash_messages_over@2x"] = 13,
    ["dash_news@2x"] = 14,
    ["dash_news_over@2x"] = 15,
    ["dash_notifications@2x"] = 16,
    ["dash_notifications_over@2x"] = 17,
    ["dash_social@2x"] = 18,
    ["dash_social_over@2x"] = 19,
    ["popup_cancel@2x"] = 20,
    ["popup_confirm@2x"] = 21,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
