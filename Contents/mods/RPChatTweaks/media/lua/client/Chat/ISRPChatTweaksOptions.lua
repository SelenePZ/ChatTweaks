require "ISUI/ISPanel"

ISRPChatTweaksOptions = ISPanel:derive("ISRPChatTweaksOptions");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local FONT_HGT_LARGE = getTextManager():getFontHeight(UIFont.Large)

--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

function ISRPChatTweaksOptions:initialise()
    ISPanel.initialise(self);
    self:create();
end


function ISRPChatTweaksOptions:setVisible(visible)
    --    self.parent:setVisible(visible);
    self.javaObject:setVisible(visible);
end

function ISRPChatTweaksOptions:render()
    local z = 20;

    self:drawText(getText("UI_chat_customizeColors_title"), self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("UI_chat_customizeColors_title")) / 2), z, 1,1,1,1, UIFont.Medium);
    z = z + 30;
end

function ISRPChatTweaksOptions:create()
    self.panel = ISTabPanel:new(10, 50, self.width - 10 * 2, self.height - self.padBottom - self.btnHgt - self.padBottom - 50);
    self.panel:initialise();
    self.panel.borderColor = { r = 0, g = 0, b = 0, a = 0};
    self.panel.target = self;
    self.panel.equalTabWidth = false
    self:addChild(self.panel);

    local groups = {
        "default",
        "say",
        "me",
        "wme",
        "faction",
        "safehouse",
        "yell",
        "all",
        "ooc",
        "oocg",
        "scene",
        "sceneg"
    }
    local y = self.padTop
    for _, group in pairs(groups) do
        self:CreateColorOptionsPanel(group, self.padLeft, y)
        y = y + self.btnHgt + 2
        if group == "default" then
            y = y + 2
        end
    end

    y = y + 10

    self:CreateImportExportPanel(self.padLeft, y)

    y = y + self.btnHgt + 2
    
    self.cancel = ISButton:new(self.padLeft, y, self.btnWid, self.btnHgt, getText("UI_btn_close"), self, ISRPChatTweaksOptions.onOptionMouseDown);
    self.cancel.internal = "CANCEL";
    self.cancel:initialise();
    self.cancel:instantiate();
    self.cancel.borderColor = self.buttonBorderColor;
    self:addChild(self.cancel);
    y = y + self.btnHgt + 2

    self:setHeight(y + self.padBottom + 8)

    self.panels["default"]:setVisible(true)
    self.panels["default"]:setEnabled(true)
    self.currentPanel = "default"

    local options = RPChatTweaks.LoadChatOptions()
    if options.customColors then
        for scope, colors in pairs(options.customColors) do
            for name, color in pairs(colors) do
                print(scope .. " .. " .. name)
                self:UpdateUIFromOption(scope, name, color)
            end
        end
    end
end

function ISRPChatTweaksOptions:CreateImportExportPanel(x, y)
    local name = "IMPORT_EXPORT"
    local importExportButton = ISButton:new(x, y, self.btnWid, self.btnHgt, getText("UI_chat_customizeColors_importExport"), self, ISRPChatTweaksOptions.onPanelSelected);
    importExportButton.internal = name;
    importExportButton:initialise();
    importExportButton:instantiate();
    importExportButton.borderColor = self.buttonBorderColor;
    self:addChild(importExportButton);

    local panel = ISPanel:new(self.padLeft + self.btnWid + 10, self.padTop, self.width - self.padLeft - self.padRight - self.btnWid - 10, 388);
    panel.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    panel.backgroundColor = {r=0, g=0, b=0, a=0.6};
    panel:initialise();
    panel:setEnabled(false)
    panel:setVisible(false)
    self:addChild(panel);
    self.panels[name] = panel

    local content = ISTextEntryBox:new(self:ExportToText(), 2, 2, panel:getWidth() - 4, panel:getHeight() - 4 - self.btnHgt - 4 - 2);
    content:initialise();
    content:instantiate();
    content:setMultipleLine(true);
    content:setMaxLines(500)
    --content:setSelectable(true);
    panel:addChild(content);

    local importButton = ISButton:new(2, panel:getHeight() - self.btnHgt - 4, 47, self.btnHgt, getText("UI_chat_customizeColors_import"), self, ISRPChatTweaksOptions.onImport);
    importButton.internal = name;
    importButton:initialise();
    importButton:instantiate();
    importButton:setX(panel:getWidth() - importButton:getWidth() - 4)
    importButton.borderColor = self.buttonBorderColor;
    panel:addChild(importButton);

    local clipboardButton = ISButton:new(2, panel:getHeight() - self.btnHgt - 4, 47, self.btnHgt, getText("UI_chat_customizeColors_copyToClipboard"), self, ISRPChatTweaksOptions.onCopyToClipboard);
    clipboardButton.internal = name;
    clipboardButton:initialise();
    clipboardButton:instantiate();
    clipboardButton:setX(importButton:getX() - clipboardButton:getWidth() - 4)
    clipboardButton.borderColor = self.buttonBorderColor;
    panel:addChild(clipboardButton);

    self.importExportTextEntry = content
end

function ISRPChatTweaksOptions:onImport()
    self:ImportFromText(self.importExportTextEntry:getText())
end

function ISRPChatTweaksOptions:onCopyToClipboard()
	Clipboard.setClipboard(self.importExportTextEntry:getText())
    self.importExportTextEntry:focus()
    self.importExportTextEntry:selectAll()
end

function ISRPChatTweaksOptions:ExportToText()
    local options = RPChatTweaks.LoadChatOptions()
    local output = ""
    for scope, colors in pairs(options.customColors) do
        for name, color in pairs(colors) do
            output = output .. scope .. "." .. name .. "=" .. color .. "\n"
        end
    end
    return output
end

function ISRPChatTweaksOptions:ImportFromText(text)
    local options = RPChatTweaks.LoadChatOptions()
    local colors = {}
    for line in string.gmatch(text, "[^\r\n]+") do
        local scope, name, color = string.match(line, "(.+)%.(.+)%=(.+)")
        if scope and name and color then
            colors[scope] = colors[scope] or {}
            colors[scope][name] = color
        end
    end
    options.customColors = colors
    RPChatTweaks.StoreChatOptions(options)
end

function ISRPChatTweaksOptions:CreateColorOptionsPanel(name, x, y)
    local button = ISButton:new(x, y, self.btnWid, self.btnHgt, getText("UI_chat_customizeColors_" .. name), self, ISRPChatTweaksOptions.onPanelSelected);
    button.internal = name;
    button:initialise();
    button:instantiate();
    button.borderColor = self.buttonBorderColor;
    self:addChild(button);

    local panel = ISPanel:new(self.padLeft + self.btnWid + 10, self.padTop, self.width - self.padLeft - self.padRight - self.btnWid - 10, 270);
    panel.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    panel.backgroundColor = {r=0, g=0, b=0, a=0.6};
    panel:initialise();
    panel:setEnabled(false)
    panel:setVisible(false)
    self:addChild(panel);
    self.panels[name] = panel

    local rx = 10
    local ry = 10

    local title = ISLabel:new(rx, ry, FONT_HGT_MEDIUM, getText("UI_chat_customizeColors_" .. name), 1, 1, 1, 1, UIFont.Medium, true)
    panel:addChild(title)

    ry = ry + title:getHeight() + 4

    ry = self:CreateColorOption(panel, name, "messageColor", rx, ry)
    ry = self:CreateColorOption(panel, name, "authorColor", rx, ry)
    ry = self:CreateColorOption(panel, name, "timestampColor", rx, ry)
    ry = self:CreateColorOption(panel, name, "titleColor", rx, ry)
    ry = self:CreateColorOption(panel, name, "channelColor", rx, ry)
end

function ISRPChatTweaksOptions:CreateColorOption(panel, scope, name, x, y)
    local label = ISLabel:new(x, y, FONT_HGT_SMALL, getText("UI_chat_color_option_" .. name), 1, 1, 1, 1, UIFont.Small, true)
    panel:addChild(label)

    x = x + 5
    y = y + label:getHeight() + 4

    local colorPickerY = y

    local valueType = ISComboBox:new(x, y, 160, 20, self, ISRPChatTweaksOptions.onChangeColor, scope, name);
	valueType:initialise();
    if scope == "default" then
	    valueType:addOptionWithData(getText("UI_chat_color_none"), "none");
    else
	    valueType:addOptionWithData(getText("UI_chat_color_inherit"), "inherit");
    end
	valueType:addOptionWithData(getText("UI_chat_color_base"), "base");
	valueType:addOptionWithData(getText("UI_chat_color_personal"), "personal");
	valueType:addOptionWithData(getText("UI_chat_color_custom"), "#ffffff");
	valueType.selected	= 1;
	panel:addChild(valueType);

    local customTextEntry = ISTextEntryBox:new("#ffffff", x + valueType:getWidth() + 10, y, 60, 20);
    customTextEntry:initialise();
    customTextEntry:instantiate();
    customTextEntry:setEnabled(false);
    customTextEntry:setVisible(false);
    customTextEntry.onTextChange = function()
        local options = RPChatTweaks.LoadChatOptions()
        options.customColors = options.customColors or {}
        options.customColors[scope] = options.customColors[scope] or {}
        options.customColors[scope][name] = customTextEntry:getInternalText()
        RPChatTweaks.StoreChatOptions(options)
        self:UpdateUIFromOption(scope, name, options.customColors[scope][name], {
            skipText = true
        })
    end
    -- customTextEntry:setMaxTextLength(7); this clears the textbox instead of just accepting new characters lol
    panel:addChild(customTextEntry);

    --local pickButton = ISButton:new(customTextEntry:getX() + customTextEntry:getWidth(), y, 32, 20, getText("UI_chat_color_pick"), self, ISRPChatTweaksOptions.onPickColor);
    local pickButton = ISButton:new(customTextEntry:getX() + customTextEntry:getWidth() + 4, y, 20, 20, "", self, ISRPChatTweaksOptions.onPickColor);
    pickButton.internal = name;
    pickButton:initialise();
    pickButton:instantiate();
    pickButton:setEnabled(false);
    pickButton:setVisible(false);
    pickButton.borderColor = self.buttonBorderColor;
    panel:addChild(pickButton);

    local colorPicker = ISColorPicker:new(pickButton:getX() + pickButton:getWidth() + 4, colorPickerY)
    colorPicker:initialise()
    colorPicker:setPickedFunc(ISRPChatTweaksOptions.onPickColorPicked, scope, name)
    colorPicker.pickedTarget = self;
    colorPicker.resetFocusTo = panel;

    self.scopedElements[scope .. "." .. name] = {
        valueType = valueType,
        customTextEntry = customTextEntry,
        pickButton = pickButton,
        colorPicker = colorPicker,
        colorPickerPos = {x = pickButton:getX() + pickButton:getWidth() + 4, y = colorPickerY}
    }

    y = y + valueType:getHeight() + 8

    return y
end

function ISRPChatTweaksOptions:UpdateUIFromOption(scope, name, value, flags)
    local elements = self.scopedElements[scope .. "." .. name]
    if not elements then
        return
    end
    local customTextEntry = elements.customTextEntry
    local pickButton = elements.pickButton
    local valueType = elements.valueType

    local isCustom = value:sub(1, 1) == "#"
    pickButton:setVisible(isCustom)
    pickButton:setEnabled(isCustom)
    customTextEntry:setVisible(isCustom)
    customTextEntry:setEnabled(isCustom)
    if isCustom then
        local color = RPChatTweaks.FromHexColor(value)
        pickButton:setBackgroundRGBA(color:getR(), color:getG(), color:getB(), 1)
        pickButton:setBackgroundColorMouseOverRGBA(color:getR() * 0.8, color:getG() * 0.8, color:getB() * 0.8, 1)
        
        if not flags or not flags.skipText then
            customTextEntry:setText(value)
        end
        elements.colorPicker:setInitialColor(color)
    end

    local foundOption = #valueType.options
    for i, option in ipairs(valueType.options) do
        if option.data == value then
            foundOption = i
            break
        end
    end
    valueType.selected = foundOption
end

function ISRPChatTweaksOptions:onChangeColor(combo, scope, name)
    local selectedOption = combo.options[combo.selected].data
    local options = RPChatTweaks.LoadChatOptions()
    options.customColors = options.customColors or {}
    options.customColors[scope] = options.customColors[scope] or {}
    options.customColors[scope][name] = selectedOption
    RPChatTweaks.StoreChatOptions(options)
    self:UpdateUIFromOption(scope, name, options.customColors[scope][name])
end

function ISRPChatTweaksOptions:onPickColor(button, x, y)
    local scope = self.currentPanel
    local name = button.internal
    local panel = self.panels[scope]
    local elements = self.scopedElements[scope .. "." .. name]
    local colorPicker = elements.colorPicker
    colorPicker:setX(panel:getAbsoluteX() + elements.colorPickerPos.x)
    colorPicker:setY(panel:getAbsoluteY() + elements.colorPickerPos.y)
	colorPicker:addToUIManager()
end

function ISRPChatTweaksOptions:onPickColorPicked(color, mouseUp, scope, name)
    local options = RPChatTweaks.LoadChatOptions()
    options.customColors = options.customColors or {}
    options.customColors[scope] = options.customColors[scope] or {}
    options.customColors[scope][name] = RPChatTweaks.ToHexColor(color)
    RPChatTweaks.StoreChatOptions(options)
    self:UpdateUIFromOption(scope, name, options.customColors[scope][name])
end

function ISRPChatTweaksOptions:onPanelSelected(button, x, y)
    for _, panel in pairs(self.panels) do
        panel:setEnabled(false)
        panel:setVisible(false)
    end
    self.panels[button.internal]:setVisible(true)
    self.panels[button.internal]:setEnabled(true)
    self.currentPanel = button.internal
end

function ISRPChatTweaksOptions:onOptionMouseDown(button, x, y)
    if button.internal == "CANCEL" then
        self:close()
    end
end

function ISRPChatTweaksOptions:close()
    self:setVisible(false)
    self:removeFromUIManager()
    ISRPChatTweaksOptions.instance = nil;
end

function ISRPChatTweaksOptions:new(x, y, width, height, player)
    local o = {};
    o = ISPanel:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;
    self.player = player;
    o.variableColor={r=0.9, g=0.55, b=0.1, a=1};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5};
    o.zOffsetSmallFont = 25;
    o.moveWithMouse = true;
    o.panels = {}
    o.scopedElements = {}
    o.btnWid = 150
    o.btnHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
    o.padLeft = 10
    o.padRight = 10
    o.padTop = 50
    o.padBottom = 10
    ISRPChatTweaksOptions.instance = o
    return o;
end
