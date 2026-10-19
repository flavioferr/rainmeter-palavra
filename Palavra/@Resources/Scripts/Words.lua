-- Gerado por gen_palavra.py: posicao de cada palavra na grade (linha, coluna, tamanho)
W = {
	E_UMA = { 1, 1, 1 },
	SAO = { 1, 3, 3 },
	H1 = { 1, 7, 3 },
	H2 = { 1, 11, 4 },
	H3 = { 2, 1, 4 },
	H4 = { 2, 6, 6 },
	H5 = { 3, 1, 5 },
	H6 = { 3, 7, 4 },
	H7 = { 3, 12, 4 },
	H8 = { 4, 1, 4 },
	H9 = { 4, 6, 4 },
	H10 = { 4, 11, 3 },
	H11 = { 5, 1, 4 },
	MEIO = { 5, 11, 4 },
	DIA = { 6, 1, 3 },
	MEIA_N = { 6, 5, 4 },
	NOITE = { 6, 10, 5 },
	E1 = { 7, 1, 1 },
	M40 = { 7, 3, 8 },
	M10 = { 7, 12, 3 },
	M50 = { 8, 1, 9 },
	M20 = { 8, 11, 5 },
	M15 = { 9, 1, 6 },
	M30T = { 9, 8, 6 },
	M30 = { 10, 1, 4 },
	E2 = { 10, 6, 1 },
	M5 = { 10, 8, 5 },
	EM = { 11, 1, 2 },
	PONTO = { 11, 4, 5 },
}

local HOURS = { 'H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'H7', 'H8', 'H9', 'H10', 'H11' }
local MINUTES = {
	[0] = { 'EM', 'PONTO' }, [5] = { 'E1', 'M5' }, [10] = { 'E1', 'M10' }, [15] = { 'E1', 'M15' },
	[20] = { 'E1', 'M20' }, [25] = { 'E1', 'M20', 'E2', 'M5' }, [30] = { 'E1', 'M30' },
	[35] = { 'E1', 'M30T', 'E2', 'M5' }, [40] = { 'E1', 'M40' }, [45] = { 'E1', 'M40', 'E2', 'M5' },
	[50] = { 'E1', 'M50' }, [55] = { 'E1', 'M50', 'E2', 'M5' },
}

function Initialize()
	last = ''
end

local function words(h, m5)
	local list = {}
	if h == 0 then
		list = { 'E_UMA', 'MEIA_N', 'NOITE' }
	elseif h == 12 then
		list = { 'E_UMA', 'MEIO', 'DIA' }
	else
		local h12 = h % 12
		list = { h12 == 1 and 'E_UMA' or 'SAO', HOURS[h12] }
	end
	for _, w in ipairs(MINUTES[m5]) do list[#list + 1] = w end
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
