--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:0772f698ad094c897a234d30cbcc07da$
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
            -- button_close
            x=224,
            y=34,
            width=30,
            height=30,

        },
        {
            -- button_close_over
            x=224,
            y=2,
            width=30,
            height=30,

        },
        {
            -- button_delete
            x=22,
            y=228,
            width=18,
            height=18,

        },
        {
            -- button_delete_over
            x=2,
            y=228,
            width=18,
            height=18,

        },
        {
            -- corona_logo
            x=2,
            y=2,
            width=150,
            height=150,

        },
        {
            -- dash_achievements
            x=187,
            y=113,
            width=35,
            height=35,

        },
        {
            -- dash_achievements_over
            x=187,
            y=76,
            width=35,
            height=35,

        },
        {
            -- dash_friends
            x=187,
            y=39,
            width=35,
            height=35,

        },
        {
            -- dash_friends_over
            x=187,
            y=2,
            width=35,
            height=35,

        },
        {
            -- dash_leaderboards
            x=150,
            y=191,
            width=35,
            height=35,

        },
        {
            -- dash_leaderboards_over
            x=150,
            y=154,
            width=35,
            height=35,

        },
        {
            -- dash_messages
            x=113,
            y=191,
            width=35,
            height=35,

        },
        {
            -- dash_messages_over
            x=113,
            y=154,
            width=35,
            height=35,

        },
        {
            -- dash_news
            x=76,
            y=191,
            width=35,
            height=35,

        },
        {
            -- dash_news_over
            x=76,
            y=154,
            width=35,
            height=35,

        },
        {
            -- dash_notifications
            x=39,
            y=191,
            width=35,
            height=35,

        },
        {
            -- dash_notifications_over
            x=39,
            y=154,
            width=35,
            height=35,

        },
        {
            -- dash_social
            x=2,
            y=191,
            width=35,
            height=35,

        },
        {
            -- dash_social_over
            x=2,
            y=154,
            width=35,
            height=35,

        },
        {
            -- popup_cancel
            x=224,
            y=96,
            width=28,
            height=28,

        },
        {
            -- popup_confirm
            x=224,
            y=66,
            width=28,
            height=28,

        },
    },
    
    sheetContentWidth = 256,
    sheetContentHeight = 256
}

SheetInfo.frameIndex =
{

    ["button_close"] = 1,
    ["button_close_over"] = 2,
    ["button_delete"] = 3,
    ["button_delete_over"] = 4,
    ["corona_logo"] = 5,
    ["dash_achievements"] = 6,
    ["dash_achievements_over"] = 7,
    ["dash_friends"] = 8,
    ["dash_friends_over"] = 9,
    ["dash_leaderboards"] = 10,
    ["dash_leaderboards_over"] = 11,
    ["dash_messages"] = 12,
    ["dash_messages_over"] = 13,
    ["dash_news"] = 14,
    ["dash_news_over"] = 15,
    ["dash_notifications"] = 16,
    ["dash_notifications_over"] = 17,
    ["dash_social"] = 18,
    ["dash_social_over"] = 19,
    ["popup_cancel"] = 20,
    ["popup_confirm"] = 21,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
