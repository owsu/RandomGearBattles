local isPlaying = script:GetAttribute("Playing")

while isPlaying do
	task.wait(1)
	local isPlaying = script:GetAttribute("Playing")
	local musicTrack = script:GetChildren()
	local randomsong = math.random(1, #musicTrack)
	local currentsong = musicTrack[randomsong]
	
	if currentsong ~= nil and currentsong.Name ~= lastsong and currentsong.Name ~= twosongsago then
		twosongsago = lastsong
		lastsong = currentsong.Name
		currentsong:Play()
		task.wait(currentsong.TimeLength + 3)
		currentsong:Pause()
	end
	
end