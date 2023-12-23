RPChatTweaks.messageThemes = {
    ProjectZomboid = {
        ["Default"] = {
            template = "%tags%timestamp%title%author%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            authorOuter = function(value) return "[" .. value .. "]" end,
            colon = function(value) return value and ": " or "" end
        },
        ["Emote"] = {
            template = "%tags%timestamp%title%author%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            authorOuter = function(value) return "[" .. value .. "]" end,
            message = function(value, parsedMessage) 
                if value:sub(-1) == "." and value:sub(-2) ~= ".." then
                    value = value:sub(1, -2)
                end
                return parsedMessage.possessive and parsedMessage.displayAuthorShort .. value or value 
            end,
            messageOuter = function(value) return "*" .. value .. "*" end,
            colon = function(value, parsedMessage) return ": " end
        },
        ["OOC"] = {
            template = "%tags%timestamp%title%author%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            authorOuter = function(value) return "[" .. value .. "]" end,
            messageOuter = function(value) return "(( " .. value .. " ))" end,
            colon = function(value) return value and ": " or "" end
        },
        ["Scene"] = {
            template = "%tags%timestamp%title%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            messageOuter = function(value) return "** " .. value .. " **" end
        },
        ["Radio"] = {
            template = "%tags%timestamp%title%channel%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            colon = function(value) return value and ": " or "" end
        }
    },
    ProjectZomboidExtended = {
        ["Default"] = {
            template = "%tags%timestamp%title%author%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            authorOuter = function(value) return "[" .. value .. "]" end,
            colon = function(value) return value and ": " or "" end
        },
        ["Emote"] = {
            template = "%tags%timestamp%title%author%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            colon = function(value, parsedMessage) return (value and parsedMessage.possessive) and "" or " " end
        },
        ["OOC"] = {
            template = "%tags%timestamp%title%author%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            authorOuter = function(value) return "[" .. value .. "]" end,
            messageOuter = function(value) return "(( " .. value .. " ))" end,
            colon = function(value) return value and ": " or "" end
        },
        ["Scene"] = {
            template = "%tags%timestamp%title%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            messageOuter = function(value) return "** " .. value .. " **" end
        },
        ["Radio"] = {
            template = "%tags%timestamp%title%channel%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            colon = function(value) return value and ": " or "" end
        }
    },
    SimpleColon = {
        ["Default"] = {
            template = "%tags%timestamp%title%author%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            colon = function(value) return value and ": " or "" end
        },
        ["Emote"] = {
            template = "%tags%timestamp%title%author%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            colon = function(value, parsedMessage) return (value and parsedMessage.possessive) and "" or " " end
        },
        ["OOC"] = {
            template = "%tags%timestamp%title%author%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            messageOuter = function(value) return "(( " .. value .. " ))" end,
            colon = function(value) return value and ": " or "" end
        },
        ["Scene"] = {
            template = "%tags%timestamp%title%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            messageOuter = function(value) return "** " .. value .. " **" end
        },
        ["Radio"] = {
            template = "%tags%timestamp%title%channel%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            colon = function(value) return value and ": " or "" end
        }
    },
    ["Minecraft"] = {
        ["Default"] = {
            template = "%tags%timestamp%title%author%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            authorOuter = function(value) return "&lt;" .. value .. "&gt;" end,
            colon = function(value) return value and " " or "" end
        },
        ["Emote"] = {
            template = "%tags%timestamp%title%author%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            colon = function(value, parsedMessage) return (value and parsedMessage.possessive) and "" or " " end
        },
        ["OOC"] = {
            template = "%tags%timestamp%title%author%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            authorOuter = function(value) return "&lt;" .. value .. "&gt;" end,
            messageOuter = function(value) return "(( " .. value .. " ))" end,
            colon = function(value) return value and " " or "" end
        },
        ["Scene"] = {
            template = "%tags%timestamp%title%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            messageOuter = function(value) return "** " .. value .. " **" end
        },
        ["Radio"] = {
            template = "%tags%timestamp%title%channel%colon%message",
            timestampOuter = function(value) return "[" .. value .. "] " end,
            titleOuter = function(value) return "[" .. value .. "] " end,
            channelOuter = function(value) return "&lt;" .. value .. "&gt;" end,
            colon = function(value) return value and " " or "" end
        }
    },
    ["Overhead"] = {
        internalTheme = true,
        ["Default"] = {
            template = "%message"
        },
        ["Emote"] = {
            template = "%message",
            message = function(value, parsedMessage) 
                if value:sub(-1) == "." and value:sub(-2) ~= ".." then
                    value = value:sub(1, -2)
                end
                return parsedMessage.possessive and parsedMessage.displayAuthorShort .. value or value 
            end,
            messageOuter = function(value, parsedMessage) return "*" .. value .. "*" end
        },
        ["OOC"] = {
            template = "%message",
            messageOuter = function(value) return "(( " .. value .. " ))" end
        },
    }
}

RPChatTweaks.colorThemes = {
    ProjectZomboid = {},
    BasicColors = {
        ["default"] = {
            authorColor = "personal",
            titleColor = "<RGB:0.5,0.5,0.5>",
            timestampColor = "<RGB:0.5,0.5,0.5>",
            channelColor = "<RGB:0.5,0.5,0.5>"
        },
        ["me"] = {
            authorColor = "<RGB:1.0,0.749,0.0>",
            messageColor = "author"
        },
        ["wme"] = {
            authorColor = "<RGB:0.7,0.7,0.6>",
            messageColor = "author",
        },
        ["whisper"] = {
            authorColor = "<RGB:0.6,0.6,0.6>",
            messageColor = "author"
        },
        ["faction"] = {
            authorColor = "base"
        },
        ["safehouse"] = {
            authorColor = "base"
        },
        ["yell"] = {
            authorColor = "<RGB:0.996,0.180,0.180>",
            messageColor = "author",
        },
        ["general"] = {
            authorColor = "base"
        },
        ["ooc"] = {
            authorColor = "<RGB:0.7,0.7,0.7>",
            messageColor = "author"
        },
        ["oocg"] = {
            authorColor = "base"
        },
        ["scene"] = {
            messageColor = "<RGB:0.529,0.961,0.200>"
        }
    },
    PersonalColors = {
        ["default"] = {
            authorColor = "personal",
            titleColor = "<RGB:0.5,0.5,0.5>",
            timestampColor = "<RGB:0.5,0.5,0.5>",
            channelColor = "<RGB:0.5,0.5,0.5>"
        },
        ["me"] = {
            messageColor = "author"
        },
        ["wme"] = {
            authorColor = "<RGB:0.7,0.7,0.6>", -- TODO it would be nice if we could apply some desaturation effect on the actual name color
            messageColor = "author",
        },
        ["whisper"] = {
            authorColor = "<RGB:0.6,0.6,0.6>",
            messageColor = "author"
        },
        ["yell"] = {
            authorColor = "personal",
            messageColor = "<RGB:0.996,0.180,0.180>",
        },
        ["faction"] = {
            authorColor = "base"
        },
        ["safehouse"] = {
            authorColor = "base"
        },
        ["oocg"] = {
            authorColor = "base"
        },
        ["general"] = {
            authorColor = "base"
        },
        ["scene"] = {
            messageColor = "<RGB:0.529,0.961,0.200>"
        }
    },
    Custom = {
        -- delegated to modData
    }
}