local addonName, ns = ...
local _G = _G

local debugFrame = tekDebug and tekDebug:GetFrame(addonName)

local debug
if debugFrame then
	function debug(a, ...) debugFrame:AddMessage( a:format( ... ) ) end
else
	function debug() end
end
local function no_insert(...) debug('%q %q', ...) end

local hooks = {}
local AddMessage = function(f, t, r, g, b, l, a, ...)
	return hooks[f]( f, t, r, g, b, l, nil, ... )
end

local function hookChatFrame(frame)
	if hooks[frame] then return frame end

	hooks[frame] = frame.AddMessage
	frame.AddMessage = AddMessage
	frame:SetInsertMode'TOP'

	-- null out the function
	frame.SetInsertMode = no_insert

	debug('messages for %s will be inserted at the %s and is hooked now.', frame:GetName(), frame:GetInsertMode():lower() )
	
	return frame
end


-- default frames
for i = 1, NUM_CHAT_WINDOWS do
	hookChatFrame( _G['ChatFrame'..i] )
end

-- stupid whisper windows
local fcf_otw = FCF_OpenTemporaryWindow
function FCF_OpenTemporaryWindow(...)
	return hookChatFrame( fcf_otw( ... ) )
end