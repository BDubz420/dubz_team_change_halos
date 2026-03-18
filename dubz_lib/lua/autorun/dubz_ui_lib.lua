--[[-------------------------------------------------------------------------
Dubz UI Lib
---------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------
Broadcast a center of the screen text

msg = The message you want to say
col = The color of the text
time = How long you want it to show for

Position options:
topleft
topcenter
topright
centerright
center
centerright
bottomleft
bottomcenter
bottomright

Usage:
On the server:

DrawBroadcastText("Hello!", "DermaLarge", Color(255,0,0), 5, "topright")
---------------------------------------------------------------------------]]
function DrawBroadcastText(msg, font, col, time, pos)
    local id = "BroadcastText_" .. math.random(1, 10000)

    local margin = 10

    local positions = {
        topleft     = { x = margin,         y = margin,         ax = TEXT_ALIGN_LEFT,   ay = TEXT_ALIGN_TOP },
        topcenter   = { x = ScrW() / 2,     y = margin,         ax = TEXT_ALIGN_CENTER, ay = TEXT_ALIGN_TOP },
        topright    = { x = ScrW() - margin,y = margin,         ax = TEXT_ALIGN_RIGHT,  ay = TEXT_ALIGN_TOP },

        centerleft  = { x = margin,         y = ScrH() / 2,     ax = TEXT_ALIGN_LEFT,   ay = TEXT_ALIGN_CENTER },
        center      = { x = ScrW() / 2,     y = ScrH() / 2,     ax = TEXT_ALIGN_CENTER, ay = TEXT_ALIGN_CENTER },
        centerright = { x = ScrW() - margin,y = ScrH() / 2,     ax = TEXT_ALIGN_RIGHT,  ay = TEXT_ALIGN_CENTER },

        bottomleft  = { x = margin,         y = ScrH() - margin,ax = TEXT_ALIGN_LEFT,   ay = TEXT_ALIGN_BOTTOM },
        bottomcenter= { x = ScrW() / 2,     y = ScrH() - margin,ax = TEXT_ALIGN_CENTER, ay = TEXT_ALIGN_BOTTOM },
        bottomright = { x = ScrW() - margin,y = ScrH() - margin,ax = TEXT_ALIGN_RIGHT,  ay = TEXT_ALIGN_BOTTOM }
    }

    local p = positions[string.lower(pos or "center")] or positions.center

    hook.Add("HUDPaint", id, function()
        draw.SimpleText(msg, font, p.x, p.y, col, p.ax, p.ay)
    end)

    timer.Simple(time, function()
        hook.Remove("HUDPaint", id)
    end)
end

--[[-------------------------------------------------------------------------
Broadcast Chat Text

ply = The player you want to see the text
msg = The message you want to say
col = The color you want it to display in

Usage:
On the server: 

BroadcastChatText(ply, "Hello world", Color(255, 0, 0))
---------------------------------------------------------------------------]]
if SERVER then
	util.AddNetworkString("BroadcastChatText")

	function BroadcastChatText(ply, msg, col)
	    net.Start("BroadcastChatText")
	        net.WriteEntity(ply)
	        net.WriteString(msg)
	        net.WriteColor(col)
	    net.Broadcast()
	end
end

if CLIENT then
	net.Receive("BroadcastChatText", function()
	    local ply = net.ReadEntity()
	    local msg = net.ReadString()
	    local col = net.ReadColor()

	    if not IsValid(ply) then return end

	    chat.AddText(
	        Color(100, 255, 100), ply:Nick() .. ": ",
	        col, msg
	    )
	end)
end

--[[-------------------------------------------------------------------------
Draw Banker HUD

bankerteam = The bankers job team id
header = Header Text
hfont = Header Font
col = Header Text Color
content = The content filling the bottom panel
cntfont = The font used for your content text
col2 = Content text color
bgcol = The color of the background boxes
x = How far from the left side of the screen should it draw?
y = How far from the top of the screen should it draw?
w = The width of the frame
h = The height of the frame

Usage:
call on the client:

DrawBankerHUD(TEAM_BANKER, "Bank Menu", "DermaLarge", Color(255,255,255), "Welcome to the bank!", "DermaDefault", Color(200,200,200), Color(20,20,20,200), 300, 200, "topright", 5)
---------------------------------------------------------------------------]]

function DrawBankerHUD(bankerteam, header, hfont, col, content, cntfont, col2, bgcol, w, h, pos, duration)
    if LocalPlayer():Team() ~= bankerteam then return end

    local id = "BankerHUD_" .. math.random(1, 10000)
    local margin = 20

    local positions = {
        topleft = {
            x = margin,
            y = margin
        },
        topcenter = {
            x = ScrW() / 2 - w / 2,
            y = margin
        },
        topright = {
            x = ScrW() - w - margin,
            y = margin
        },

        centerleft = {
            x = margin,
            y = ScrH() / 2 - h / 2
        },
        center = {
            x = ScrW() / 2 - w / 2,
            y = ScrH() / 2 - h / 2
        },
        centerright = {
            x = ScrW() - w - margin,
            y = ScrH() / 2 - h / 2
        },

        bottomleft = {
            x = margin,
            y = ScrH() - h - margin
        },
        bottomcenter = {
            x = ScrW() / 2 - w / 2,
            y = ScrH() - h - margin
        },
        bottomright = {
            x = ScrW() - w - margin,
            y = ScrH() - h - margin
        }
    }

    local p = positions[string.lower(pos or "center")] or positions.center

    hook.Add("HUDPaint", id, function()
        local x, y = p.x, p.y

        -- Background
        draw.RoundedBox(6, x, y, w, h, bgcol)

        -- Header
        local headerH = h * 0.2
        draw.RoundedBox(6, x + 1, y + 1, w - 2, headerH, Color(bgcol.r * 0.8, bgcol.g * 0.8, bgcol.b * 0.8))

        draw.SimpleText(
            header,
            hfont,
            x + w / 2,
            y + headerH / 2,
            col,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

        -- Body
        local bodyY = y + headerH
        local bodyH = h - headerH

        draw.RoundedBox(6, x + 1, bodyY, w - 2, bodyH - 1, bgcol)

        draw.SimpleText(
            content,
            cntfont,
            x + w / 2,
            bodyY + bodyH / 2,
            col2,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
    end)

    if duration then
        timer.Simple(duration, function()
            hook.Remove("HUDPaint", id)
        end)
    end
end



--[[-------------------------------------------------------------------------
Dubz Nudge

Usage: 


---------------------------------------------------------------------------]]

function Nudgeteam(team, msg)

end

function Nudgeply(ply, msg)

end

--[[-------------------------------------------------------------------------
Area Interactable Team Prompter
---------------------------------------------------------------------------]]
local ACTIVE_HINT_ID = "Dubz_HintUI"

function HintUI(col, content, cntfont, col2, bgcol, w, h, pos, duration)
    local margin = 20

    local positions = {
        topleft     = { x = margin,               y = margin },
        topcenter   = { x = ScrW()/2 - w/2,       y = margin },
        topright    = { x = ScrW() - w - margin,  y = margin },

        centerleft  = { x = margin,               y = ScrH()/2 - h/2 },
        center      = { x = ScrW()/2 - w/2,       y = ScrH()/2 - h/2 },
        centerright = { x = ScrW() - w - margin,  y = ScrH()/2 - h/2 },

        bottomleft  = { x = margin,               y = ScrH() - h - margin },
        bottomcenter= { x = ScrW()/2 - w/2,       y = ScrH() - h - margin },
        bottomright = { x = ScrW() - w - margin,  y = ScrH() - h - margin }
    }

    local p = positions[string.lower(pos or "center")] or positions.center

    -- remove old one (prevents stacking / leaking)
    hook.Remove("HUDPaint", ACTIVE_HINT_ID)

    local startTime = CurTime()
    local fadeTime = 0.15

    hook.Add("HUDPaint", ACTIVE_HINT_ID, function()
        local x, y = p.x, p.y

        -- fade in/out
        local alphaMul = 1

        if duration then
            local elapsed = CurTime() - startTime
            local remaining = duration - elapsed

            if elapsed < fadeTime then
                alphaMul = elapsed / fadeTime
            elseif remaining < fadeTime then
                alphaMul = math.Clamp(remaining / fadeTime, 0, 1)
            end

            if remaining <= 0 then
                hook.Remove("HUDPaint", ACTIVE_HINT_ID)
                return
            end
        end

        local function ApplyAlpha(c)
            return Color(c.r, c.g, c.b, c.a * alphaMul)
        end

        -- Background
        draw.RoundedBox(6, x, y, w, h, ApplyAlpha(bgcol))

        -- Body (no broken header anymore)
        draw.SimpleText(
            content,
            cntfont,
            x + w / 2,
            y + h / 2,
            ApplyAlpha(col2),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
    end)
end

-- GLOBAL (client)
if CLIENT then
    DubzActivePanel = DubzActivePanel or nil

    function OpenInteractionPanel(title, content, onAccept, onDecline)
        -- remove existing panel
        if IsValid(DubzActivePanel) then
            if IsValid(DubzActivePanel) then
                DubzActivePanel:Remove()
            end
        end

        local frame = vgui.Create("DFrame")
        DubzActivePanel = frame

        frame:SetSize(360, 180)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle("")
        frame:ShowCloseButton(false)
        frame:SetDraggable(false)

        frame.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(20, 20, 20, 230))

            -- Header
            draw.RoundedBox(8, 0, 0, w, 40, Color(30, 30, 30, 255))

            draw.SimpleText(
                title or "Interaction",
                "DermaLarge",
                w / 2,
                20,
                color_white,
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )
        end

        -- Content text
        local label = vgui.Create("DLabel", frame)
        label:SetText(content or "")
        label:SetFont("DermaDefault")
        label:SetTextColor(Color(200, 200, 200))
        label:SetWrap(true)
        label:SetAutoStretchVertical(true)
        label:SetWide(320)
        label:SetPos(20, 55)

        -- Accept button
        local accept = vgui.Create("DButton", frame)
        accept:SetSize(140, 36)
        accept:SetPos(20, 120)
        accept:SetText("Accept")

        accept.Paint = function(self, w, h)
            local col = self:IsHovered() and Color(70,160,70) or Color(50,130,50)
            draw.RoundedBox(6, 0, 0, w, h, col)
        end

        accept.DoClick = function()
            if onAccept then onAccept() end
            frame:Remove()
        end

        -- Decline button
        local decline = vgui.Create("DButton", frame)
        decline:SetSize(140, 36)
        decline:SetPos(200, 120)
        decline:SetText("Decline")

        decline.Paint = function(self, w, h)
            local col = self:IsHovered() and Color(160,70,70) or Color(130,50,50)
            draw.RoundedBox(6, 0, 0, w, h, col)
        end

        decline.DoClick = function()
            if onDecline then onDecline() end
            frame:Remove()
        end
    end
end

if SERVER then
    util.AddNetworkString("Dubz_OpenBlobMenu")
    util.AddNetworkString("Dubz_RequestBlobs")
    util.AddNetworkString("Dubz_SendBlobs")
    util.AddNetworkString("Dubz_CreateBlob")
    util.AddNetworkString("Dubz_DeleteBlob")
    util.AddNetworkString("Dubz_UpdateBlob")

    -- First is blob saving/loading/deleting

    local FILE_NAME = "dubz_blobs.txt"

    local function SaveBlobs()
    local data = {}

    for _, ent in ipairs(ents.FindByClass("dubz_blob")) do
        if not IsValid(ent) then continue end

            table.insert(data, {
                id = ent:GetNWString("BlobID"),
                pos = ent:GetPos(),
                team = ent:GetNWInt("BlobTeam"),
                radius = ent:GetNWFloat("BlobRadius"),
                msg = ent:GetNWString("BlobMsg"),
                color = {r = ent:GetColor().r, g = ent:GetColor().g, b = ent:GetColor().b},
                sound = ent:GetNWString("BlobSound", ""),
                playsound = ent:GetNWBool("BlobPlaySound", false)
            })
        end

        file.Write(FILE_NAME, util.TableToJSON(data, true))
        print("[Blob] Saved", #data, "blobs")
    end

    local function LoadBlobs()
        if not file.Exists(FILE_NAME, "DATA") then return end

        local data = util.JSONToTable(file.Read(FILE_NAME, "DATA") or "")
        if not data then return end

        for _, v in ipairs(data) do
            local ent = ents.Create("dubz_blob")
            if not IsValid(ent) then continue end

            ent:SetPos(Vector(v.pos.x, v.pos.y, v.pos.z))
            ent:SetNWString("BlobID", v.id)
            ent:SetNWInt("BlobTeam", v.team)
            ent:SetNWFloat("BlobRadius", v.radius)
            ent:SetNWString("BlobMsg", v.msg)
            ent:SetColor(Color(v.color.r, v.color.g, v.color.b, v.color.a))
            ent:SetNWString("BlobSound", v.sound or "")
            ent:SetNWBool("BlobPlaySound", v.playsound or false)

            ent:Spawn()
        end

        net.Start("Dubz_SendBlobs")
            net.WriteTable(data)
        net.Send(ply)

        print("[Blob] Loaded", #data, "blobs")
    end

    hook.Add("InitPostEntity", "Dubz_LoadBlobs", LoadBlobs)

    --Command for the menu
    concommand.Add("dubz_blob_menu", function(ply)
        if not ply:IsAdmin() then return end

        net.Start("Dubz_OpenBlobMenu")
        net.Send(ply)
    end)

    concommand.Add("join_blob_team", function(ply, cmd, args)
        if not IsValid(ply) then return end

        local teamID = tonumber(args[1])
        if not teamID then
            ply:ChatPrint("[Blob] Invalid teamID")
            return
        end

        if ply:Team() == teamID then
            ply:ChatPrint("[Blob] You are already on this team")
            return
        end

        if ply.NextTeamSwitch and ply.NextTeamSwitch > CurTime() then
            ply:ChatPrint("[Blob] Please wait before switching again")
            return
        end
        ply.NextTeamSwitch = CurTime() + 1

        -- 🔥 DarkRP proper way
        ply:changeTeam(teamID, false)
    end)

    net.Receive("Dubz_UpdateBlob", function(_, ply)
        if not ply:IsAdmin() then return end

        local id = net.ReadString()
        local team = net.ReadInt(16)
        local radius = net.ReadInt(16)
        local msg = net.ReadString()
        local color = net.ReadColor()
        local sound = net.ReadString()
        local playSound = net.ReadBool()

        for _, ent in ipairs(ents.FindByClass("dubz_blob")) do
            if ent:GetNWString("BlobID") == id then
                ent:SetNWInt("BlobTeam", team)
                ent:SetNWFloat("BlobRadius", radius)
                ent:SetNWString("BlobMsg", msg)
                ent:SetNWVector("BlobColorVec", Vector(color.r, color.g, color.b))
                ent:SetNWString("BlobSound", sound)
                ent:SetNWBool("BlobPlaySound", playSound)
            end
        end

        SaveBlobs()
    end)

    -- Send the data the client needs when they need it
    net.Receive("Dubz_RequestBlobs", function(_, ply)
        local data = {}

        for _, ent in ipairs(ents.FindByClass("dubz_blob")) do
            if not IsValid(ent) then continue end

            table.insert(data, {
                id = ent:GetNWString("BlobID"),
                pos = ent:GetPos(),
                team = ent:GetNWInt("BlobTeam"),
                radius = ent:GetNWFloat("BlobRadius"),
                msg = ent:GetNWString("BlobMsg")
            })
        end

        net.Start("Dubz_SendBlobs")
            net.WriteTable(data)
        net.Send(ply)
    end)

    local function GenerateBlobID()
        return "blob_" .. os.time() .. "_" .. math.random(1000, 9999)
    end

    net.Receive("Dubz_CreateBlob", function(_, ply)
        if not ply:IsAdmin() then return end

        local teamID = net.ReadInt(16)
        local radius = net.ReadInt(16)
        local msg = net.ReadString()
        local color = net.ReadColor()
        local sound = net.ReadString()
        local playSound = net.ReadBool()

        local pos = ply:GetPos()
        pos.z = pos.z - ply:OBBMins().z

        local ent = ents.Create("dubz_blob")
        if not IsValid(ent) then return end

        ent:SetPos(pos)
        ent:SetNWString("BlobID", GenerateBlobID())
        ent:SetNWInt("BlobTeam", teamID)
        ent:SetNWFloat("BlobRadius", radius)
        ent:SetNWString("BlobMsg", msg)
        ent:SetColor(color)
        ent:SetNWString("BlobSound", sound)
        ent:SetNWBool("BlobPlaySound", playSound)
        ent:Spawn()

        SaveBlobs()
    end)


    net.Receive("Dubz_DeleteBlob", function(_, ply)
        if not ply:IsAdmin() then return end

        local id = net.ReadString()

        for _, ent in ipairs(ents.FindByClass("dubz_blob")) do
            if ent:GetNWString("BlobID") == id then
                ent:Remove()
            end
        end
        SaveBlobs()
    end)
end

if CLIENT then
    local function RequestBlobRefresh()
        net.Start("Dubz_RequestBlobs")
        net.SendToServer()
    end

    local DubzBlobManagerFrame = nil
    local DubzBlobManagerList = nil

    net.Receive("Dubz_SendBlobs", function()
        local data = net.ReadTable()
        if not IsValid(DubzBlobManagerList) then return end

        DubzBlobManagerList:Clear()

        for _, v in ipairs(data) do
            local line = DubzBlobManagerList:AddLine(
                v.id or "",
                v.team or 0,
                v.radius or 100,
                v.msg or "",
                v.sound or "",
                v.playsound and "Yes" or "No"
            )

            line.blobData = v
        end
    end)

    -- Show the menu or anything else the client asked for
    net.Receive("Dubz_OpenBlobMenu", function()
        if IsValid(DubzBlobManagerFrame) then
            DubzBlobManagerFrame:Remove()
        end

        local frame = vgui.Create("DFrame")
        DubzBlobManagerFrame = frame
        frame:SetSize(900, 500)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle("Area Interactable Manager")

        local list = vgui.Create("DListView", frame)
        DubzBlobManagerList = list
        list:Dock(FILL)
        list:AddColumn("ID")
        list:AddColumn("Team")
        list:AddColumn("Radius")
        list:AddColumn("Message")
        list:AddColumn("Sound")
        list:AddColumn("Play Sound")

        local controls = vgui.Create("DPanel", frame)
        controls:Dock(BOTTOM)
        controls:SetTall(60)

        RequestBlobRefresh()

        -- Spawn button
        local spawnBtn = vgui.Create("DButton", controls)
        spawnBtn:SetText("Create Blob")
        spawnBtn:SetSize(120, 40)
        spawnBtn:SetPos(10, 10)

        spawnBtn.DoClick = function()
            local menu = vgui.Create("DFrame")
            menu:SetSize(320, 460)
            menu:Center()
            menu:MakePopup()
            menu:SetTitle("Create Blob")

            local teamBox = vgui.Create("DComboBox", menu)
            teamBox:SetPos(20, 40)
            teamBox:SetSize(280, 25)
            teamBox:SetValue("Select Job")

            for id, t in pairs(team.GetAllTeams()) do
                if t.Name then
                    teamBox:AddChoice(t.Name, id)
                end
            end

            local radius = vgui.Create("DTextEntry", menu)
            radius:SetPos(20, 80)
            radius:SetSize(280, 25)
            radius:SetText("100")

            local msg = vgui.Create("DTextEntry", menu)
            msg:SetPos(20, 120)
            msg:SetSize(280, 25)
            msg:SetText("Join this job?")

            local colorMixer = vgui.Create("DColorMixer", menu)
            colorMixer:SetPos(20, 160)
            colorMixer:SetSize(280, 120)
            colorMixer:SetPalette(true)
            colorMixer:SetAlphaBar(true)
            colorMixer:SetWangs(true)
            colorMixer:SetColor(Color(0, 150, 255, 255))

            local soundEntry = vgui.Create("DTextEntry", menu)
            soundEntry:SetPos(20, 295)
            soundEntry:SetSize(280, 25)
            soundEntry:SetText("buttons/button14.wav")

            local soundCheck = vgui.Create("DCheckBoxLabel", menu)
            soundCheck:SetPos(20, 330)
            soundCheck:SetText("Play Sound On Enter")
            soundCheck:SetValue(1)
            soundCheck:SizeToContents()

            local confirm = vgui.Create("DButton", menu)
            confirm:SetText("Create")
            confirm:SetSize(280, 32)
            confirm:SetPos(20, 380)

            confirm.DoClick = function()
                local _, teamID = teamBox:GetSelected()

                net.Start("Dubz_CreateBlob")
                    net.WriteInt(teamID or 0, 16)
                    net.WriteInt(tonumber(radius:GetValue()) or 100, 16)
                    net.WriteString(msg:GetValue() or "Join this job?")
                    net.WriteColor(colorMixer:GetColor())
                    net.WriteString(soundEntry:GetValue() or "")
                    net.WriteBool(soundCheck:GetChecked())
                net.SendToServer()

                timer.Simple(0.1, function()
                    if IsValid(frame) then
                        RequestBlobRefresh()
                    end
                end)

                menu:Close()
            end
        end

        -- Delete button
        local deleteBtn = vgui.Create("DButton", controls)
        deleteBtn:SetText("Delete Selected")
        deleteBtn:SetSize(140, 40)
        deleteBtn:SetPos(140, 10)

        deleteBtn.DoClick = function()
            local lineIndex = list:GetSelectedLine()
            if not lineIndex then return end

            local row = list:GetLine(lineIndex)
            if not row then return end

            local id = row:GetColumnText(1)
            if not id or id == "" then return end

            net.Start("Dubz_DeleteBlob")
                net.WriteString(id)
            net.SendToServer()

            timer.Simple(0.1, function()
                if IsValid(frame) then
                    RequestBlobRefresh()
                end
            end)
        end

        -- Edit button
        local editBtn = vgui.Create("DButton", controls)
        editBtn:SetText("Edit Selected")
        editBtn:SetSize(140, 40)
        editBtn:SetPos(290, 10)

        editBtn.DoClick = function()
            local lineIndex = list:GetSelectedLine()
            if not lineIndex then return end

            local row = list:GetLine(lineIndex)
            if not row or not row.blobData then return end

            local data = row.blobData

            local blobID = data.id or ""
            local currentTeam = tonumber(data.team) or 0
            local currentRadius = tonumber(data.radius) or 100
            local currentMsg = data.msg or "Join this job?"
            local currentColor = data.color or Color(0, 150, 255, 255)
            local currentSound = data.sound or ""
            local currentPlaySound = data.playsound or false

            local menu = vgui.Create("DFrame")
            menu:SetSize(320, 460)
            menu:Center()
            menu:MakePopup()
            menu:SetTitle("Edit Blob")

            local teamBox = vgui.Create("DComboBox", menu)
            teamBox:SetPos(20, 40)
            teamBox:SetSize(280, 25)

            for id2, t in pairs(team.GetAllTeams()) do
                if t.Name then
                    teamBox:AddChoice(t.Name, id2)
                    if id2 == currentTeam then
                        teamBox:SetValue(t.Name)
                    end
                end
            end

            local radius = vgui.Create("DTextEntry", menu)
            radius:SetPos(20, 80)
            radius:SetSize(280, 25)
            radius:SetText(tostring(currentRadius))

            local msg = vgui.Create("DTextEntry", menu)
            msg:SetPos(20, 120)
            msg:SetSize(280, 25)
            msg:SetText(currentMsg)

            local colorMixer = vgui.Create("DColorMixer", menu)
            colorMixer:SetPos(20, 160)
            colorMixer:SetSize(280, 120)
            colorMixer:SetPalette(true)
            colorMixer:SetAlphaBar(true)
            colorMixer:SetWangs(true)
            colorMixer:SetColor(currentColor)

            local soundEntry = vgui.Create("DTextEntry", menu)
            soundEntry:SetPos(20, 295)
            soundEntry:SetSize(280, 25)
            soundEntry:SetText(currentSound)

            local soundCheck = vgui.Create("DCheckBoxLabel", menu)
            soundCheck:SetPos(20, 330)
            soundCheck:SetText("Play Sound On Enter")
            soundCheck:SetValue(currentPlaySound and 1 or 0)
            soundCheck:SizeToContents()

            local confirm = vgui.Create("DButton", menu)
            confirm:SetText("Save")
            confirm:SetSize(280, 32)
            confirm:SetPos(20, 380)

            confirm.DoClick = function()
                local _, teamID = teamBox:GetSelected()
                teamID = teamID or currentTeam

                net.Start("Dubz_UpdateBlob")
                    net.WriteString(blobID)
                    net.WriteInt(teamID or 0, 16)
                    net.WriteInt(tonumber(radius:GetValue()) or 100, 16)
                    net.WriteString(msg:GetValue() or "Join this job?")
                    net.WriteColor(colorMixer:GetColor())
                    net.WriteString(soundEntry:GetValue() or "")
                    net.WriteBool(soundCheck:GetChecked())
                net.SendToServer()

                timer.Simple(0.1, function()
                    if IsValid(frame) then
                        RequestBlobRefresh()
                    end
                end)

                menu:Close()
            end
        end
    end)
end