RPChatTweaks = {}
RPChatTweaks.SayChatRange = 30
RPChatTweaks.ShoutChatRange = 60
require "Chat/RPChatTweaks_Themes"
RPChatTweaks.KnownAuthors = {}
RPChatTweaks.PassedRangeCheck = {}
RPChatTweaks.NamePreferences = {"AlwaysFull", "AlwaysShort", "ShortenInSession", "Username"}

ISChat.allChatStreams[1].RPChatTweaks_Options = function()
    return {
        template = "Default",
        stripOverheadColors = true
    }
end

ISChat.allChatStreams[2].RPChatTweaks_Options = function()
    return {
        template = "Default",
        title = "Yelling",
        doNotRetainCommand = true,
        stripOverheadColors = true
    }
end

ISChat.allChatStreams[3].RPChatTweaks_Options = function()
    if SandboxVars.RPChatTweaks.ImmersiveWhispers then
        return {
            template = "Default",
            title = "Whisper",
            chatStreamName = "say",
            range = function() return RPChatTweaks.SayChatRange * SandboxVars.RPChatTweaks.ImmersiveWhisperRangeMultiplier, SandboxVars.RPChatTweaks.ImmersiveWhispersRoomBoundary end,
        }
    end
    return {
        template = "Default",
        enabled = function() return SandboxVars.RPChatTweaks.AllowPMs end,
        doNotEnrichMessage = true
    }
end

ISChat.allChatStreams[4].RPChatTweaks_Options = function()
    return {
        template = "Default"
    }
end

ISChat.allChatStreams[5].RPChatTweaks_Options = function()
    return {
        template = "Default"
    }
end

ISChat.allChatStreams[6].RPChatTweaks_Options = function()
    return {
        template = "Default",
        doNotRetainCommand = true
    }
end

ISChat.allChatStreams[7].RPChatTweaks_Options = function()
    return {
        template = "Default"
    }
end

table.insert(ISChat.allChatStreams, {name = "me", command = "/me ", shortCommand = "/me ", tabID = 1, RPChatTweaks_Options = function()
    return {
        template = "Emote",
        chatStreamName = "say",
        enabled = function() return SandboxVars.RPChatTweaks.AllowEmotes end,
        doNotRetainCommand = true
    }
end});

table.insert(ISChat.allChatStreams, {name = "wme", command = "/wme ", shortCommand = "/wme ", tabID = 1, RPChatTweaks_Options = function()
    return {
        template = "Emote",
        title = "Whisper",
        chatStreamName = "say",
        enabled = function() return SandboxVars.RPChatTweaks.AllowEmotes and SandboxVars.RPChatTweaks.ImmersiveWhispers end,
        range = function() return RPChatTweaks.SayChatRange * SandboxVars.RPChatTweaks.ImmersiveWhisperRangeMultiplier, SandboxVars.RPChatTweaks.ImmersiveWhispersRoomBoundary end,
    }
end});

table.insert(ISChat.allChatStreams, {name = "pm", command = "/pm ", shortCommand = "/pm ", tabID = 1, RPChatTweaks_Options = function()
    return {
        template = "Default",
        enabled = function() return SandboxVars.RPChatTweaks.AllowPMs end,
        outgoingHandler = function(command) 
            local username = proceedPM(command);
            ISChat.instance.chatText.lastChatCommand = ISChat.instance.chatText.lastChatCommand .. username .. " ";
            return command, false, "pm"
        end,
        doNotEnrichMessage = true
    }
end});

table.insert(ISChat.allChatStreams, {name = "ooc", command = "/ooc ", shortCommand = "/ooc ", tabID = 1, RPChatTweaks_Options = function()
    return {
        template = "OOC",
        chatStreamName = "say",
        enabled = function() return SandboxVars.RPChatTweaks.AllowOOC end,
        hideOverhead = true
    }
end});

table.insert(ISChat.allChatStreams, {name = "oocg", command = "/oocg ", shortCommand = "/oocg ", tabID = 1, RPChatTweaks_Options = function()
    return {
        template = "OOC",
        chatStreamName = "general",
        enabled = function() return SandboxVars.RPChatTweaks.AllowGlobalOOC end
    }
end});

table.insert(ISChat.allChatStreams, {name = "scene", command = "/scene ", shortCommand = "/sc ", tabID = 1, RPChatTweaks_Options = function()
    return {
        template = "Scene",
        chatStreamName = "say",
        hideOverhead = true,
        enabled = function() return SandboxVars.RPChatTweaks.AllowScenes end
    }
end});

table.insert(ISChat.allChatStreams, {name = "sceneg", command = "/sceneg ", shortCommand = "/scg ", tabID = 1, RPChatTweaks_Options = function()
    return {
        template = "Scene",
        chatStreamName = "general",
        hideOverhead = true,
        enabled = function() return SandboxVars.RPChatTweaks.AllowGlobalScenes and (not SandboxVars.RPChatTweaks.RestrictGlobalScenesToAdmins or RPChatTweaks.IsGmOrHigher(getPlayer())) end
    }
end});

function RPChatTweaks.IsGmOrHigher(player)
    local accessLevel = player and player:getAccessLevel()
    return accessLevel == "GM" or accessLevel == "Overseer" or accessLevel == "Moderator" or accessLevel == "Admin"
end

function RPChatTweaks.ConsumeToken(input, pattern, returnFullMatch)
    local start_pos, end_pos = string.find(input, pattern)
    local token = nil
    local rest = input

    if start_pos ~= nil then
        local skipped = string.sub(input, 1, start_pos - 1)
        -- if we skipped anything other than whitespaces, abort
        if string.find(skipped, "%S") ~= nil then
            return input, nil
        end

        if returnFullMatch then
            token = string.sub(input, start_pos, end_pos)
        else
            token = string.match(input, pattern)
        end
        rest = string.sub(input, end_pos + 1)
    end

    return rest, token
end

function RPChatTweaks.NumberToBinaryString(num)
    local bits = {}
    while num > 0 do
        local rest = num % 2
        table.insert(bits, 1, rest)
        num = (num - rest) / 2
    end
    return table.concat(bits)
end

function RPChatTweaks.EncodeBinary(number)
    local binaryString = RPChatTweaks.NumberToBinaryString(number)
    return binaryString:gsub("1", "�"):gsub("0", string.char(0))
end

function RPChatTweaks.DecodeBinary(str)
    local binaryString = str:gsub("�", "1"):gsub("%D", "0")
    return tonumber(binaryString, 2)
end

function RPChatTweaks.ParseMessage(line)
    local rest = line
    local tags = {}
    local mergedTags = ""
    local tag = true
    while tag do
        rest, tag = RPChatTweaks.ConsumeToken(rest, "<(.-)>", true)
        if tag then
            table.insert(tags, tag)
            mergedTags = mergedTags .. tag
        end
    end
    local timestamp
    if ISChat.instance.showTimestamp then
        rest, timestamp = RPChatTweaks.ConsumeToken(rest, "%[(%d+:%d+)%]")
    end
    local title
    if ISChat.instance.showTitle then
        rest, title = RPChatTweaks.ConsumeToken(rest, "%[(.-)%]")
    end
    local author
    rest, author = RPChatTweaks.ConsumeToken(rest, "%[(.-)%]")
    local channel
    rest, channel = RPChatTweaks.ConsumeToken(rest, "(Radio  %(.-%))")
    rest = RPChatTweaks.ConsumeToken(rest, ": ")
    local typeMetaRaw
    rest, typeMetaRaw = RPChatTweaks.ConsumeToken(rest, "�(%S+) ") -- invisible unicode character marks the start of the binary data
    local typeMeta = typeMetaRaw and RPChatTweaks.DecodeBinary(typeMetaRaw) or nil
    local message = rest:gsub("^%s*(.-)%s*$", "%1")
    return {
        tags = tags,
        mergedTags = mergedTags,
        timestamp = timestamp,
        title = title,
        author = author,
        channel = channel,
        messageType = typeMeta,
        message = message,
        possessive = message:sub(1, 2) == "'s"
    }
end

function RPChatTweaks.GetMessageTypeStream(parsedMessage)
    local messageType = parsedMessage.messageType or 1
    return ISChat.allChatStreams[messageType]
end

function RPChatTweaks.GetChatStreamOptions(stream)
    if stream and stream.RPChatTweaks_Options then
        local format = stream.RPChatTweaks_Options(message, line, parsedMessage)
        if format then
            return format
        end
    end
    return {
        template = "Default"
    }
end

function RPChatTweaks.GetAuthorColor(parsedMessage)
    local authorColorCode = ""
    if parsedMessage.authorPlayer then
        local authorColor = parsedMessage.authorPlayer:getSpeakColour()
        if authorColor then
            authorColorCode = string.format("<RGB:%.3f,%.3f,%.3f>", authorColor:getR(), authorColor:getG(), authorColor:getB())
        end
    end
    return authorColorCode
end

function RPChatTweaks.ExtractBaseColor(parsedMessage)
    local baseColor = parsedMessage.mergedTags:match("(<RGB:.->)")
    return (baseColor and baseColor ~= "<RGB:1.0,1.0,1.0>") and baseColor or nil
end

function RPChatTweaks.Colorize(input, color, baseColor)
    local resetColor = baseColor or "<RGB:1.0,1.0,1.0>"
    if not color then
        --return input
        color = baseColor or "<RGB:1.0,1.0,1.0>"
    end
    return "�" .. color .. " �" .. tostring(input) .. "� " .. resetColor .. "�" -- formatting tags eat any touching whitespaces, so we insert invisible chars to preserve them
end

function RPChatTweaks.FormatMessagePart(parsedMessage, input, pattern, value, innerFormatFunc, outerFormatFunc, color, options)
    if not value then
        return input:gsub(pattern, "")
    end
    local innerValue = innerFormatFunc and innerFormatFunc(value, parsedMessage) or value
    options.inclusiveColoring = true -- TODO not worth it right now as it breaks the anti-eating whitespace hack
    if not options.inclusiveColoring then
        innerValue = RPChatTweaks.Colorize(innerValue, color, parsedMessage.baseColor)
    end
    local outerValue = outerFormatFunc and outerFormatFunc(innerValue, parsedMessage) or innerValue
    if options.inclusiveColoring then
        outerValue = RPChatTweaks.Colorize(outerValue, color, parsedMessage.baseColor)
    end
    return input:gsub(pattern, outerValue)
end

function RPChatTweaks.FormatMessage(parsedMessage, messageThemeName, options)
    local templateName = parsedMessage.streamOptions.template or "Default"
    if parsedMessage.channel then
        templateName = "Radio"
    end
    local messageTheme = RPChatTweaks.messageThemes[messageThemeName] or RPChatTweaks.messageThemes.ProjectZomboid
    local formatter = messageTheme[templateName] or RPChatTweaks.messageThemes.ProjectZomboid[templateName]
    local streamTitle = parsedMessage.title and parsedMessage.streamOptions.title or parsedMessage.title
    local output = formatter.template
    output = output:gsub("%%tags", parsedMessage.mergedTags)
    output = RPChatTweaks.FormatMessagePart(parsedMessage, output, "%%title", streamTitle, formatter.title, formatter.titleOuter, RPChatTweaks.ResolveConfiguredColor(parsedMessage, options, "title"), options)
    local authorColor = RPChatTweaks.ResolveConfiguredColor(parsedMessage, options, "author")
    output = RPChatTweaks.FormatMessagePart(parsedMessage, output, "%%author", parsedMessage.displayAuthor, formatter.author, formatter.authorOuter, authorColor, options)
    output = RPChatTweaks.FormatMessagePart(parsedMessage, output, "%%channel", parsedMessage.channel, formatter.channel,formatter.channelOuter, RPChatTweaks.ResolveConfiguredColor(parsedMessage, options, "channel"), options)
    output = RPChatTweaks.FormatMessagePart(parsedMessage, output, "%%timestamp", parsedMessage.timestamp, formatter.timestamp, formatter.timestampOuter, RPChatTweaks.ResolveConfiguredColor(parsedMessage, options, "timestamp"), options)
    local messageColor = RPChatTweaks.ResolveConfiguredColor(parsedMessage, options, "message")
    output = RPChatTweaks.FormatMessagePart(parsedMessage, output, "%%message", parsedMessage.message, formatter.message, formatter.messageOuter, messageColor, options)
    local needColon = parsedMessage.author or parsedMessage.channel
    output = RPChatTweaks.FormatMessagePart(parsedMessage, output, "%%colon", needColon, formatter.colon, formatter.colon, authorColor, options)
    return output
end

function RPChatTweaks.GetEffectiveColor(parsedMessage, options, scope)
    if scope == "title" then
        return parsedMessage.titleColor or options:getColor(parsedMessage.streamName, "titleColor")
    elseif scope == "author" then
        return options:getColor(parsedMessage.streamName, "authorColor")
    elseif scope == "timestamp" then
        return parsedMessage.timestampColor or options:getColor(parsedMessage.streamName, "timestampColor")
    elseif scope == "channel" then
        return parsedMessage.channelColor or options:getColor(parsedMessage.streamName, "channelColor")
    elseif scope == "message" then
        return options:getColor(parsedMessage.streamName, "messageColor") or parsedMessage.messageColor
    else
        print("invalid color scope " .. scope)
        return nil
    end
end

function RPChatTweaks.ResolveColor(parsedMessage, options, scope, color)
    if color == "personal" then
        return parsedMessage.authorColor
    elseif color == nil or color == "none" or color == "base" then
        return parsedMessage.baseColor
    elseif color == "author" then
        return RPChatTweaks.ResolveConfiguredColor(parsedMessage, options, "author")
    elseif color:sub(1, 1) == "#" then
        local col = RPChatTweaks.FromHexColor(color)
        return string.format("<RGB:%.3f,%.3f,%.3f>", col:getR(), col:getG(), col:getB())
    elseif color:sub(1, 1) == "<" then
        return color
    end
    print("invalid color " .. color)
    return nil
end

function RPChatTweaks.ResolveConfiguredColor(parsedMessage, options, scope)
    local color = RPChatTweaks.GetEffectiveColor(parsedMessage, options, scope)
    return RPChatTweaks.ResolveColor(parsedMessage, options, scope, color)
end

function RPChatTweaks.ReformatColorsForOverhead(input)
    local function convertRGB(s)
        local r, g, b = s:match("<RGB:(%-?[%d%.]+),(%-?[%d%.]+),(%-?[%d%.]+)>")
        r, g, b = math.floor(tonumber(r) * 255), math.floor(tonumber(g) * 255), math.floor(tonumber(b) * 255)
        return "*"..r..","..g..","..b.."*"
    end
    return input:gsub("<RGB:[^>]+>", convertRGB):gsub("�", "")
end

function RPChatTweaks.StripColors(input)
    return input:gsub("<RGB:[^>]+>", "") --:gsub("%[col=([^%]]+)%]", " *%1* ")
end

function RPChatTweaks.GetDefaultChatOptions()
    return {
        messageTheme = "SimpleColon",
        colorTheme = "PersonalColors",
        customColors = {},
        namePreference = "ShortenInSession",
        inclusiveColoring = true
    }
end

function RPChatTweaks.FromHexColor(s)
    local r, g, b = s:match("#(%x%x)(%x%x)(%x%x)")
    r = r and tonumber(r, 16) / 255 or 1
    g = g and tonumber(g, 16) / 255 or 1
    b = b and tonumber(b, 16) / 255 or 1
    return Color.new(r, g, b, 1)
end

function RPChatTweaks.ToHexColor(color)
    return string.format("#%02x%02x%02x", (color.getR and color:getR() or color.r) * 255, (color.getG and color:getG() or color.g) * 255, (color.getB and color:getB() or color.b) * 255)
end

function RPChatTweaks.LoadChatOptions()
    local player = getPlayer()
    local modData = player:getModData()
    local options = modData["RPChatTweaks"] or RPChatTweaks.GetDefaultChatOptions()
    function options:getColor(stream, key)
        local colors = RPChatTweaks.colorThemes[self.colorTheme]
        if not colors or self.colorTheme == "Custom" then
            colors = self.customColors
        end
        local streamColors = colors[stream]
        local streamColor = streamColors and streamColors[key]
        local defaultColor = colors["default"] and colors["default"][key]
        if streamColor == "inherit" then
            return defaultColor
        end
        return streamColor or defaultColor
    end
    return options
end

function RPChatTweaks.StoreChatOptions(options)
    local player = getPlayer()
    local modData = player:getModData()
    modData["RPChatTweaks"] = options
    ISChat.instance:updateChatPrefixSettings()
end

function RPChatTweaks.PopulateOptionsMenu(context)
    local options = RPChatTweaks.LoadChatOptions()

    local colorThemeOption = context:addOption(getText("UI_chat_context_colorTheme_submenu_name"), ISChat.instance);
    local colorThemeSubMenu = context:getNew(context);
    context:addSubMenu(colorThemeOption, colorThemeSubMenu);
    for colorThemeName, _ in pairs(RPChatTweaks.colorThemes) do
        local option = colorThemeSubMenu:addOption(getText("UI_chat_context_colorTheme_" .. colorThemeName), ISChat.instance, RPChatTweaks.onColorThemeChange, colorThemeName);
        if options.colorTheme == colorThemeName then
            colorThemeSubMenu:setOptionChecked(option, true)
        end
    end

    local messageThemeOption = context:addOption(getText("UI_chat_context_messageTheme_submenu_name"), ISChat.instance);
    local messageThemeSubMenu = context:getNew(context);
    context:addSubMenu(messageThemeOption, messageThemeSubMenu);
    for messageThemeName, messageTheme in pairs(RPChatTweaks.messageThemes) do
        if not messageTheme.internalTheme then
            local option = messageThemeSubMenu:addOption(getText("UI_chat_context_messageTheme_" .. messageThemeName), ISChat.instance, RPChatTweaks.onMessageThemeChange, messageThemeName);
            if options.messageTheme == messageThemeName then
                messageThemeSubMenu:setOptionChecked(option, true)
            end
        end
    end

    local namePreferenceOption = context:addOption(getText("UI_chat_context_namePreference_submenu_name"), ISChat.instance);
    local namePreferenceSubMenu = context:getNew(context);
    context:addSubMenu(namePreferenceOption, namePreferenceSubMenu);
    for _, namePreference in pairs(RPChatTweaks.NamePreferences) do
        local option = namePreferenceSubMenu:addOption(getText("UI_chat_context_namePreference_" .. namePreference), ISChat.instance, RPChatTweaks.onNamePreferenceChange, namePreference);
        if options.namePreference == namePreference then
            namePreferenceSubMenu:setOptionChecked(option, true)
        end
    end
end

function RPChatTweaks.OpenAdvancedOptions()
    if ISRPChatTweaksOptions.instance then
		ISRPChatTweaksOptions.instance:removeFromUIManager();
	end
    local chat = ISChat.instance
	local modal = ISRPChatTweaksOptions:new(chat:getAbsoluteX() + chat:getWidth() / 2 - 250, math.max(0, chat:getAbsoluteY() - 500), 480, 300, getPlayer());
	modal:initialise()
	modal:addToUIManager()
end

function RPChatTweaks.onColorThemeChange(target, value)
    if value == "Custom" then
        RPChatTweaks.OpenAdvancedOptions()
    end

    local options = RPChatTweaks.LoadChatOptions();
    if options.colorTheme == value then
        return;
    end
    options.colorTheme = value;
    RPChatTweaks.StoreChatOptions(options);
    print("Color theme switched to " .. value);
end

function RPChatTweaks.onMessageThemeChange(target, value)
    local options = RPChatTweaks.LoadChatOptions();
    if options.messageTheme == value then
        return;
    end
    options.messageTheme = value;
    RPChatTweaks.StoreChatOptions(options);
    print("Message theme switched to " .. value);
end

function RPChatTweaks.onNamePreferenceChange(target, value)
    local options = RPChatTweaks.LoadChatOptions();
    if options.namePreference == value then
        return;
    end
    options.namePreference = value;
    RPChatTweaks.StoreChatOptions(options);
    print("Name preference switched to " .. value);
end

function RPChatTweaks.ResetChat()
    RPChatTweaks.KnownAuthors = {}
end

function RPChatTweaks.AvoidShortening(displayAuthorShort)
    -- Prevent abstract quest character names such as "The Silhouette in the Mist" from being shortened to "The"
    return displayAuthorShort == "The" or displayAuthorShort == "A" or displayAuthorShort == "An" or displayAuthorShort == "Something" or displayAuthorShort == "Someone"
end

function RPChatTweaks.PopulateAuthorName(parsedMessage, options)
    local descriptor = parsedMessage.authorPlayer and parsedMessage.authorPlayer:getDescriptor()
    parsedMessage.displayAuthorFull = descriptor and (descriptor:getForename() .. " " .. descriptor:getSurname()) or parsedMessage.author
    parsedMessage.displayAuthorShort = descriptor and descriptor:getForename() or parsedMessage.author
    if options.namePreference == "AlwaysFull" then
        parsedMessage.displayAuthor = parsedMessage.displayAuthorFull
    elseif options.namePreference == "AlwaysShort" then
        parsedMessage.displayAuthor = parsedMessage.displayAuthorShort
    elseif options.namePreference == "ShortenInSession" and parsedMessage.author then
        -- TODO in the future we should also keep track of which first name maps to which username and avoid shortening in case of duplicates
        RPChatTweaks.KnownAuthors[parsedMessage.author] = (RPChatTweaks.KnownAuthors[parsedMessage.author] or 0) + 1
        if RPChatTweaks.KnownAuthors[parsedMessage.author] > 5 and not RPChatTweaks.AvoidShortening(parsedMessage.displayAuthorShort) then
            parsedMessage.displayAuthor = parsedMessage.displayAuthorShort
        else
            parsedMessage.displayAuthor = parsedMessage.displayAuthorFull
        end
    elseif options.namePreference == "Username" then
        parsedMessage.displayAuthor = parsedMessage.author
    else
        parsedMessage.displayAuthor = parsedMessage.displayAuthorFull
    end
end

function RPChatTweaks.ProcessOutgoingMessage(command, commandProcessed, chatStreamName)
    if commandProcessed then
        return command, commandProcessed, chatStreamName
    end

    -- if trimmed command is blank, don't bother
    if command:gsub("^%s*(.-)%s*$", "%1") == "" then
        return command, commandProcessed, chatStreamName
    end

    local streamIndex
    local stream
    for i, s in ipairs(ISChat.allChatStreams) do
        if s.name == chatStreamName then
            streamIndex = i
            stream = s
            break
        end
    end

    if not stream then
        return command, commandProcessed, chatStreamName
    end

    local streamOptions = RPChatTweaks.GetChatStreamOptions(stream)
    if streamOptions.doNotRetainCommand then
        -- TODO doNotRetainCommand won't work on whispers right now since it alters lastChatCommand after the fact. Would need a hook in a later place to properly support this.
        -- TODO we probably have to override it anyways because it also thinks the unicode characters are the username and then retains them
        ISChat.instance.chatText.lastChatCommand = nil
    end
    
    if streamOptions.enabled and not streamOptions.enabled() then
        getPlayer():addLineChatElement(stream.command .. "has not been enabled on this server.", 1, 0, 0);
        ISChat.instance.chatText.lastChatCommand = nil
        return command, true, chatStreamName
    end

    local backingChatStream = streamOptions.chatStreamName or chatStreamName
    local enrichedMessage = streamOptions.doNotEnrichMessage and command or "�" .. RPChatTweaks.EncodeBinary(streamIndex) .. " " .. command
    if streamOptions.outgoingHandler then
        enrichedMessage, commandProcessed, backingChatStream = streamOptions.outgoingHandler(enrichedMessage, commandProcessed, backingChatStream)
    end

    if SandboxVars.RPChatTweaks.EnableLogs then
        local player = getPlayer()
        ISLogSystem.sendLog(player, "rpchat", "[" .. player:getUsername() .. "][" .. player:getDescriptor():getForename() .. "][".. player:getDescriptor():getSurname() .."][" .. chatStreamName .. "][" .. math.floor(player:getX()) .. "," .. math.floor(player:getY()) .. "," .. math.floor(player:getZ()) .. "] " .. command)
    end

    return enrichedMessage, commandProcessed, backingChatStream
end

function RPChatTweaks.GetMessageId(message)
    return tostring(message:getDatetime()) .. "-" .. tostring(message:getAuthor())
end

function RPChatTweaks.IsMessageInRange(parsedMessage)
    if parsedMessage.streamOptions.range then
        if not parsedMessage.authorPlayer then
            return false
        end
        local thisPlayer = getPlayer()
        local thisRoomId = thisPlayer:getCurrentSquare():getRoomID()
        local messageRoomId = parsedMessage.authorPlayer:getCurrentSquare():getRoomID()
        local distX = parsedMessage.authorPlayer:getX() - thisPlayer:getX()
        local distY = parsedMessage.authorPlayer:getY() - thisPlayer:getY()
        local distance = math.sqrt(distX * distX + distY * distY)
        local maxRange, boundToRoom = parsedMessage.streamOptions.range()
        return distance <= maxRange and (not boundToRoom or thisRoomId == messageRoomId)
    end
    return true
end

function RPChatTweaks.ProcessIncomingMessage(message, line, isReprocessing)
    local options = RPChatTweaks.LoadChatOptions()

    local parsedMessage = RPChatTweaks.ParseMessage(line)
    parsedMessage.originalMessage = message:clone()
    parsedMessage.authorPlayer = getPlayerFromUsername(message:getAuthor())

    RPChatTweaks.PopulateAuthorName(parsedMessage, options)
    local stream = RPChatTweaks.GetMessageTypeStream(parsedMessage)
    parsedMessage.streamName = stream.name
    parsedMessage.streamOptions = RPChatTweaks.GetChatStreamOptions(stream)
    parsedMessage.authorColor = RPChatTweaks.GetAuthorColor(parsedMessage)
    parsedMessage.baseColor = RPChatTweaks.ExtractBaseColor(parsedMessage)

    if parsedMessage.streamOptions.range then
        if isReprocessing then
            local messageId = RPChatTweaks.GetMessageId(parsedMessage.originalMessage)
            if not RPChatTweaks.PassedRangeCheck[messageId] then
                message:setOverHeadSpeech(false)
                return parsedMessage.originalMessage, nil
            end
        else
            if not RPChatTweaks.IsMessageInRange(parsedMessage) then
                message:setOverHeadSpeech(false)
                return parsedMessage.originalMessage, nil
            else
                local messageId = RPChatTweaks.GetMessageId(parsedMessage.originalMessage)
                RPChatTweaks.PassedRangeCheck[messageId] = true
            end
        end
    end

    if parsedMessage.streamOptions.hideOverhead then
        message:setOverHeadSpeech(false)
    end

    if message:isOverHeadSpeech() then
        local overheadMessage = RPChatTweaks.FormatMessage(parsedMessage, "Overhead", options)
        if parsedMessage.streamOptions.stripOverheadColors then
            overheadMessage = RPChatTweaks.StripColors(overheadMessage)
        else
            overheadMessage = RPChatTweaks.ReformatColorsForOverhead(overheadMessage)
        end

        -- TODO WIP
        -- if parsedMessage.authorPlayer then
        --     parsedMessage.authorPlayer:addLineChatElement(RPChatTweaks.ParseStringForChatBubble(overheadMessage))
        --     message:setOverHeadSpeech(false)
        -- end
    end

    if parsedMessage.authorPlayer and SandboxVars.RPChatTweaks.MentalHealthBuffs then
        local bodyDamage = parsedMessage.authorPlayer:getBodyDamage()
        bodyDamage:setBoredomLevel(bodyDamage:getBoredomLevel() - 1);
        bodyDamage:setUnhappynessLevel(bodyDamage:getUnhappynessLevel() - 1);
    end

    local chatMessage = RPChatTweaks.FormatMessage(parsedMessage, options.messageTheme, options)
    return parsedMessage.originalMessage, chatMessage
end

RPChatTweaks.AllowedChatIcons = {}

function RPChatTweaks.ParseStringForChatBubble(var0)
    local builder = ""
    local builderTest = ""
    var0 = var0:gsub("%[br/]", "")
    var0 = var0:gsub("%[cdt=", "")

    local var1 = var0
    local var2 = false
    local var3 = false
    local var4 = 0

    for i = 1, #var1 do
        local var6 = var1:sub(i,i)
        if var6 ~= '*' then
            if var2 then
                builderTest = builderTest .. var6
            else
                builder = builder .. var6
            end
        elseif not var2 then
            var2 = true
        else
            local var7 = builderTest
            builderTest = ""
            local var8 = RPChatTweaks.getColorString(var7, false)

            if var8 then
                if var3 then
                    builder = builder .. "[/]"
                end

                builder = builder .. "[col=" .. var8 .. "]"
                var2 = false
                var3 = true
            elseif var4 < 10 and (var7:lower() == "music" or RPChatTweaks.AllowedChatIcons[var7:lower()]) then
                if var3 then
                    builder = builder .. "[/]"
                    var3 = false
                end

                builder = builder .. "[img=" .. (var7:lower() == "music" and "music" or RPChatTweaks.AllowedChatIcons[var7:lower()]) .. "]"
                var2 = false
                var4 = var4 + 1
            else
                builder = builder .. '*' .. var7
            end
        end
    end

    if var2 then
        builder = builder .. '*'
        local var10 = builderTest
        if #var10 > 0 then
            builder = builder .. var10
        end

        if var3 then
            builder = builder .. "[/]"
        end
    end

    return builder
end

function RPChatTweaks.getColorString(var0, var1)
    if Colors.ColorExists(var0) then
        local var6 = Colors.GetColorByName(var0)
        if var1 then
            local var7 = var6:getRedFloat()
            return "" .. var7 .. "," .. var6:getGreenFloat() .. "," .. var6:getBlueFloat()
        else
            return "" .. var6:getRed() .. "," .. var6:getGreen() .. "," .. var6:getBlue()
        end
    elseif string.len(var0) <= 11 and string.find(var0, ",") then
        local var2 = {}
        for value in string.gmatch(var0, '([^,]+)') do
            table.insert(var2, value)
        end
        
        if #var2 == 3 then
            local var3 = parseColorInt(var2[1])
            local var4 = parseColorInt(var2[2])
            local var5 = parseColorInt(var2[3])
            
            if var3 ~= -1 and var4 ~= -1 and var5 ~= -1 then
                if var1 then
                    return var3 / 255.0 .. "," .. var4 / 255.0 .. "," .. var5 / 255.0
                end

                return "" .. var3 .. "," .. var4 .. "," .. var5
            end
        end
    end
    
    return nil
end