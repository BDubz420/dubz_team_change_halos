AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Area Interactable"
ENT.Author = "BDubz420"
ENT.Category = "Other"
ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:SetupDataTables()
end

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
        self:DrawShadow(false)
        self:SetSolid(SOLID_NONE)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

        -- Default color (fallback)
        local col = self:GetNWVector("BlobColorVec", Vector(255, 0, 0))
        self:SetColor(Color(col.x, col.y, col.z))
    end

    function ENT:Think()
        -- Keep color synced if it changes from menu
        local col = self:GetNWVector("BlobColorVec", Vector(255, 0, 0))
        self:SetColor(Color(col.x, col.y, col.z))

        self:NextThink(CurTime() + 0.2) -- cheap update, no spam
        return true
    end
end

if CLIENT then
    function ENT:Draw()
        local center = self:GetPos() + Vector(0, 0, -6)

        -- Main controls
        local radius = 16        -- world-space radius of outer cylinder
        local height = 24         -- world-space height
        local segments = 32       -- more = smoother wall
        local scale = 0.2         -- same scale everywhere
        local color = self:GetColor() or Color(90, 190, 255, 255)

        -- Optional small center ring
        local innerRadius = 16

        -- Convert world radius to 3D2D radius so both circles match exactly
        local drawOuterRadius = radius / scale
        local drawInnerRadius = innerRadius / scale

        -- =========================
        -- Ground circles
        -- =========================
        cam.Start3D2D(center + Vector(0, 0, 0.1), Angle(0, 0, 0), scale)
            surface.SetDrawColor(color)

            for i = 0, segments - 1 do
                local a1 = math.rad((i / segments) * 360)
                local a2 = math.rad(((i + 1) / segments) * 360)

                local x1 = math.cos(a1) * drawOuterRadius
                local y1 = math.sin(a1) * drawOuterRadius
                local x2 = math.cos(a2) * drawOuterRadius
                local y2 = math.sin(a2) * drawOuterRadius

                surface.DrawLine(x1, y1, x2, y2)
            end
        cam.End3D2D()

        -- =========================
        -- Hollow cylinder wall
        -- =========================

        -- arc length per segment in WORLD units
        local circumference = 2 * math.pi * radius
        local arcLength = circumference / segments

        -- convert to 3D2D width and add overlap so no gaps
        local sliceWidth = (arcLength / scale) + 2
        local drawHeight = height / scale

        for i = 0, segments - 1 do
            local a = (i / segments) * math.pi * 2

            local dir = Vector(math.cos(a), math.sin(a), 0)
            local pos = center + dir * radius

            -- tangent-facing plane
            local ang = dir:Angle()
            ang:RotateAroundAxis(ang:Up(), 90)
            ang:RotateAroundAxis(ang:Forward(), 90)

            cam.Start3D2D(pos, ang, scale)
                local fadeSteps = 12
                local stepHeight = drawHeight / fadeSteps

                for j = 0, fadeSteps - 1 do
                    local t = j / fadeSteps
                    local alpha = 80 * t

                    surface.SetDrawColor(color.r, color.g, color.b, alpha)

                    surface.DrawRect(
                        -sliceWidth * 0.5,
                        -drawHeight + (j * stepHeight),
                        sliceWidth,
                        stepHeight + 1
                    )
                end
            cam.End3D2D()
        end
    end

    local triggerState = {}
    local nextCheck = 0

    hook.Add("Think", "Dubz_BlobInteractionCheck", function()
        if CurTime() < nextCheck then return end
        nextCheck = CurTime() + 0.1

        local ply = LocalPlayer()
        if not IsValid(ply) then return end

        for _, ent in ipairs(ents.FindByClass("dubz_blob")) do
            if not IsValid(ent) then continue end

            local id = ent:GetNWString("BlobID")
            if id == "" then continue end

            triggerState[id] = triggerState[id] or {
                inside = false,
                cooldown = 0
            }

            local state = triggerState[id]

            local radius = ent:GetNWFloat("BlobRadius", 100)
            local dist = ply:GetPos():DistToSqr(ent:GetPos())
            local inRange = dist <= (radius * radius)

            -- ENTER
            if inRange and not state.inside and CurTime() > state.cooldown then
                state.inside = true
                state.cooldown = CurTime() + 1

                -- prevent UI spam
                if IsValid(DubzActivePanel) then return end

                local msg = ent:GetNWString("BlobMsg", "Join?")
                local teamID = ent:GetNWInt("BlobTeam", 0)

                OpenInteractionPanel(
                    "Job Selection",
                    msg,
                    function()
                        RunConsoleCommand("join_blob_team", teamID)
                    end
                )
            end

            -- EXIT
            if not inRange and state.inside then
                state.inside = false

                -- auto close UI
                if IsValid(DubzActivePanel) then
                    DubzActivePanel:Remove()
                end
            end
        end
    end)
end