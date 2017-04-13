function OnPlayerUsingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType)
    local getAccess = PlayerHasBlockAccess(Player, BlockX, BlockY, BlockZ)
    if getAccess == false then
        Player:SendMessage(cChatColor.Rose .. "You do not have permission to open this")
                                         --[[ "You have no permission to open this" or
                                              "You're not permitted to open this" or
                                              "You're not allowed to open this" ]]
                                         --[[ "Erlaubnis zum Öffnen verweigert" ]]
        return true
    end
end

function OnPlayerBreakingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType)
    local World = Player:GetWorld()
    local getAccess = PlayerHasBlockAccess(Player, BlockX, BlockY, BlockZ)

    if World:GetBlock(BlockX, BlockY, BlockZ) == 68 and getAccess ~= true then
        getAccess = CheckSignPermission({ World:GetSignLines(BlockX, BlockY, BlockZ) }, Player)
    end
    if getAccess == false then
        Player:SendMessage(cChatColor.Rose .. "You do not have permission to destroy this");
                                         --[[ "You have no permission to destroy this" or
                                              "You're not permitted to destroy this" or
                                              "You're not allowed to destroy this" ]]
                                         --[[ "Erlaubnis zum Zerstören verweigert" ]]
        return true;
    end
end

function OnUpdatingSign(World, BlockX, BlockY, BlockZ, Line1, Line2, Line3, Line4, Player)
    if Line1 == "[P]" or Line1 == "[Private]" then
        if not Player:HasPermission("SignLock.Create") then
            Player:SendMessage(cChatColor.Rose .. "You are not Allowed to Protect Chests")
                                             --[[ "You're not allowed to protect chests" or
                                                  "You're not permitted to protect chests" ]]
                                             --[[ "Erlaubnis zum schützen von Kisten verweigert" ]]            
            return false
        end
        if CheckBlock(World:GetBlock(BlockX + 1, BlockY, BlockZ)) then
            if CheckProtect(BlockX + 1, BlockY, BlockZ, World) then
                Player:SendMessage(cChatColor.Green .. "This block is already protected")
                                                  --[[ "Dieser Block ist bereits geschützt" ]]                 
                return false, "[?]", "Already", "Protected"
            end
            SetSide(BlockX, BlockY, BlockZ, "+X", World)
        end
        if CheckBlock(World:GetBlock(BlockX - 1, BlockY, BlockZ)) then
            if CheckProtect(BlockX - 1, BlockY, BlockZ, World) then
                Player:SendMessage(cChatColor.Green .. "This block is already protected")
                                                  --[[ "Dieser Block ist bereits geschützt" ]]                
                return false, "[?]", "Already", "Protected"
            end
            SetSide(BlockX, BlockY, BlockZ, "-X", World)
        end
        if CheckBlock(World:GetBlock(BlockX, BlockY, BlockZ + 1)) then
            if CheckProtect(BlockX, BlockY, BlockZ + 1, World) then
                Player:SendMessage(cChatColor.Green .. "This block is already protected")
                                                  --[[ "Dieser Block ist bereits geschützt" ]]                 
                return false, "[?]", "Already", "Protected"
            end
            SetSide(BlockX, BlockY, BlockZ, "+Z", World)
        end
        if CheckBlock(World:GetBlock(BlockX, BlockY, BlockZ - 1)) then
            if CheckProtect(BlockX, BlockY, BlockZ - 1, World) then
                Player:SendMessage(cChatColor.Green .. "This block is already protected")
                                                  --[[ "Dieser Block ist bereits geschützt" ]]                 
                return false, "[?]", "Already", "Protected"
            end
            SetSide(BlockX, BlockY, BlockZ, "-Z", World)
        end
        Player:SendMessage(cChatColor.Green .. "You successfully protected your block")
                                          --[[ "Du hast deinen Block erfolgreich geschützt" ]]         
        if Line2 == "" and Line3 == "" and Line4 == "" then
            return false, Line1, Player:GetName(), Line3, Line4
        end
    end
    if Line1 == "" and Line2 == "" and Line3 == "" and Line4 == "" then
        return false, "[Private]", Player:GetName(), Line3, Line4
    end
end
