-- POSTER
-- Author: Pwnlolz

local POSTER_shown = false
local POSTER_inited = false

local POSTER_refs = {}

local POSTER_notyetposted = true;
local POSTER_lastpost_ts = 0;

function POSTER_save_ref(self, variant)
	POSTER_refs[variant] = self;
end
function POSTER_get_ref(variant)
	return POSTER_refs[variant];
end

function POSTER_getChannels()
	local t={}
	for str in string.gmatch(POSTER_Settings.channels, "([^%s]+)") do
		table.insert(t, str)
	end
	return t
end

function disp_time(time)
  local hours = floor(mod(time, 86400)/3600)
  local minutes = floor(mod(time,3600)/60)
  local seconds = floor(mod(time,60))
  return format("%02d:%02d",minutes,seconds)
end

function POSTER_tick()
	if POSTER_notyetposted then
		LastPostElapsed:SetText("Not posted yet");
	else
		local cur = time();
		local post_elapsed = cur - POSTER_lastpost_ts;
		LastPostElapsed:SetText(disp_time(post_elapsed) .. " ago");
	end
end

function POSTER_tick_ex(self, elapsed)
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;
	if (self.TimeSinceLastUpdate < 1.0) then
		return
	end

	self.TimeSinceLastUpdate = 0;
	POSTER_tick();
end

function POSTER_dopost()
	POSTER_notyetposted = false;
	POSTER_lastpost_elapsed = 0;
	POSTER_lastpost_ts = time();
	local channels = POSTER_getChannels()
	for idx,channel in pairs(channels) do
		id = GetChannelName(tostring(channel))
		if id == 0 then
			print("Channel/ID not found:"..channel.."/"..id)
		else
			SendChatMessage(POSTER_Settings.message, "CHANNEL", nil, id)
		end
	end
end

function POSTER_reset()
	POSTER_notyetposted = true;
	POSTER_lastpost_ts = 0;
	LastPostElapsed:SetText("Not posted yet");
end

function POSTER_toggleShow()
	if POSTER_shown then
		POSTER_MainFrame:Hide()
		POSTER_shown = false
	else
		POSTER_MainFrame:Show()
		POSTER_shown = true
	end
end

function POSTER_welcome()
	print("Welcome to poster, use /poster to open/close the poster window")
end

function POSTER_init()
	if POSTER_inited then
		return
	end

	POSTER_inited = true
	POSTER_Settings = POSTER_Settings or {
		["channels"] = "trade world",
		["message"] = "LFM BRD - 2 dps",
	}

	SLASH_POSTER1 = "/poster"
	SlashCmdList["POSTER"] = POSTER_toggleShow

	POSTER_get_ref("channels"):SetText(POSTER_Settings.channels);
	POSTER_get_ref("message"):SetText(POSTER_Settings.message);
end
