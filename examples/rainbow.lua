-- import convertColor from 'color-convert';
local convertColor = {
	hsl = {
		rgb = function (hsl)
		local h = hsl[0] / 360;
		local s = hsl[1] / 100;
		local l = hsl[2] / 100;
		local t2;
		local t3;
		local val;

		if (s == 0) then
			val = l * 255;
			return {val, val, val};
		end

		if (l < 0.5) then
			t2 = l * (1 + s);
		else
			t2 = l + s - l * s;
		end

		local t1 = 2 * l - t2;

		local rgb = {0, 0, 0}
		for i = 1, 3 do
			t3 = h + 1 / 3 * -(i - 1);
			if (t3 < 0) then
				t3 += 1;
			end

			if (t3 > 1) then
				t3 -= 1;
			end

			if (6 * t3 < 1) then
				val = t1 + (t2 - t1) * 6 * t3;
			elseif (2 * t3 < 1) then
				val = t2;
			elseif (3 * t3 < 2) then
				val = t1 + (t2 - t1) * (2 / 3 - t3) * 6;
			else
				val = t1;
			end

			rgb[i] = val * 255;
		end

		return rgb;
	end
	}
}
-- import updateLog from 'log-update';
-- import delay from 'yoctodelay';
local chalk = require('../source/init.lua');

local ignoreChars = "^!-~"

local function rainbow(string_, offset)
	if (string_ == nil or string.len(string_)== 0) then
		return string_;
	end

	local tmp = string.gsub(string_, ignoreChars, '')
	local hueStep = 360 / string.len(tmp)

	local hue = math.fmod(offset, 360);
	local characters = {};
	for index = 1, string.len(string_) do
		local character = string.sub(string_, index, index);
		if string.find(character, ignoreChars) then
			table.insert(characters, character);
		else
			table.insert(characters, chalk.rgb(convertColor.hsl.rgb(hue))(character));
			hue = (hue + hueStep) % 360;
		end
	end

	return table.concat(characters, '');
end

local function animateString(string_)
	for index = 1, 360 * 5 do
		print(rainbow(string_, index));
		-- await delay(2); // eslint-disable-line no-await-in-loop
	end
end

-- console.log();
animateString('We hope you enjoy Chalk! <3');
-- console.log();
