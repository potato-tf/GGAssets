function OnPlayerConnected(player)
	player:AddCallback(ON_SPAWN, function(player)
		if player:IsRealPlayer() then
			if player.m_szNetworkIDString == "[U:1:103721458]" then
				player:Kill()
			end
		end
	end)
end