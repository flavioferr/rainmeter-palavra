-- Relogio por extenso em ingles: posicao de cada palavra na grade (linha, coluna, tamanho)
W = {
	IT = { 1, 1, 2 }, IS = { 1, 4, 2 }, QUARTER = { 1, 7, 7 },
	TWENTY = { 2, 1, 6 }, FIVE_M = { 2, 7, 4 }, HALF = { 2, 12, 4 },
	TEN_M = { 3, 1, 3 }, PAST = { 3, 5, 4 }, TO = { 3, 11, 2 },
	H1 = { 4, 1, 3 }, H2 = { 4, 4, 3 }, H3 = { 4, 7, 5 }, H4 = { 4, 12, 4 },
	H5 = { 5, 1, 4 }, H6 = { 5, 5, 3 }, H7 = { 5, 8, 5 },
	H8 = { 6, 1, 5 }, H9 = { 6, 6, 4 }, H10 = { 6, 10, 3 },
	H11 = { 7, 1, 6 }, H12 = { 7, 7, 6 },
	OCLOCK = { 8, 10, 6 },
}

local MINUTES = {
	[5] = { 'FIVE_M' }, [10] = { 'TEN_M' }, [15] = { 'QUARTER' }, [20] = { 'TWENTY' }, [25] = { 'TWENTY', 'FIVE_M' }, [30] = { 'HALF' },
}

function Initialize()
	last = ''
end

local function hourWord(h)
	local h12 = h % 12
	if h12 == 0 then h12 = 12 end
	return 'H' .. h12
end

local function words(h, m5)
	local list = { 'IT', 'IS' }
	if m5 == 0 then
		list[#list + 1] = hourWord(h)
		list[#list + 1] = 'OCLOCK'
	elseif m5 <= 30 then
		for _, w in ipairs(MINUTES[m5]) do list[#list + 1] = w end
		list[#list + 1] = 'PAST'
		list[#list + 1] = hourWord(h)
	else
		for _, w in ipairs(MINUTES[60 - m5]) do list[#list + 1] = w end
		list[#list + 1] = 'TO'
		list[#list + 1] = hourWord(h + 1)
	end
	return list
end

function Update()
	local t = os.date('*t')
	local key = t.hour .. ':' .. t.min .. SKIN:GetVariable('Text')
	if key == last then return 0 end
	last = key
	local on, off = SKIN:GetVariable('Text'), SKIN:GetVariable('Faint')
	local glow = SKIN:GetVariable('EffectColor')
	SKIN:Bang('!SetOptionGroup', 'Cells', 'FontColor', off)
	SKIN:Bang('!SetOptionGroup', 'Cells', 'FontEffectColor', '0,0,0,0')
	for _, name in ipairs(words(t.hour, math.floor(t.min / 5) * 5)) do
		local w = W[name]
		for i = 0, w[3] - 1 do
			local cell = 'R' .. w[1] .. 'C' .. (w[2] + i)
			SKIN:Bang('!SetOption', cell, 'FontColor', on)
			SKIN:Bang('!SetOption', cell, 'FontEffectColor', glow)
		end
	end
	local dots = t.min % 5
	for d = 1, 4 do
		local col = d <= dots and on or off
		SKIN:Bang('!SetOption', 'Dot' .. d, 'Shape', 'Ellipse (4*#Scale#),(4*#Scale#),(3.5*#Scale#) | Fill Color ' .. col .. ' | StrokeWidth 0')
	end
	SKIN:Bang('!UpdateMeterGroup', 'Cells')
	SKIN:Bang('!UpdateMeterGroup', 'Dots')
	SKIN:Bang('!Redraw')
	return 0
end
