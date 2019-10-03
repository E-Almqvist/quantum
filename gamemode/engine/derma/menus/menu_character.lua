--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local menu = {}

local net = Quantum.Client.Menu.GetAPI( "net" )
local page = Quantum.Client.Menu.GetAPI( "page" )
local theme = Quantum.Client.Menu.GetAPI( "theme" )

local resScale = Quantum.Client.ResolutionScale
local sw, sh = ScrW(), ScrH()
local padding = 10 * resScale
local padding_s = 4 * resScale


local pages = {
    charSelect = function( parent )
        local args = {
            CloseButtonText = "Quit",
            CloseButtonFont = "q_text2"
        }
        local p, c = page.New( parent, args )

        local clist = vgui.Create( "DScrollPanel", p )
        clist:SetSize( 380 * resScale, sh - padding*15 )
        clist.w, clist.h = clist:GetSize()
        clist:SetPos( (sw - clist.w) - padding*2, padding*6 )
        clist.x, clist.y = clist:GetPos()
        clist.Paint = function( self, w, h )
            theme.blurpanel( self, Color( 0, 0, 0, 200 ) )
        end

        local sbar = clist:GetVBar()
        sbar:SetSize( 0, 0 ) -- Remove the scroll bar

        --- Close/quit button stuff ---
        local cW, cH = c:GetSize()
        c:SetPos( (clist.x + clist.w) - cW, clist.y + clist.h + cH )
        c.Paint = function( self ) theme.button( self ) end
        c.DoClick = function() 
            surface.PlaySound( "UI/buttonclick.wav" )
            parent:Close() 
        end
        ---

        local header = vgui.Create( "DLabel", p )
        header:SetText( "Characters" )
        header:SetFont( "q_header" )
        header:SizeToContents()
        local headerW, headerH = header:GetSize()
        header:SetPos( clist.x + ( clist.w/2 - headerW/2 ), (clist.y - headerH) + padding/2 )
        header:SetTextColor( Color( 255, 255, 255, 255 ) )
        header.Paint = function( self, w, h ) end

        local chars = {
            {name="Vernull", lvl=81},
            {name="Devoe", lvl=22},
            {name="Leeroy", lvl=2}
        }
        
        local cpanels = {}
        local selectedChar 

        for k, v in pairs( chars ) do
            cpanels[k] = vgui.Create( "DButton", clist )

            cpanels[k].char = v -- give the panel it's character
            if( !selectedChar ) then selectedChar = cpanels[1] end -- select the first one

            cpanels[k]:SetText( "" )
            cpanels[k]:SetSize( clist.w - padding, 100 * resScale )
            cpanels[k].w, cpanels[k].h = cpanels[k]:GetSize()
            cpanels[k]:SetPos( padding/2, (padding)*k + (cpanels[k].h * (k-1)) )
            cpanels[k].Paint = function( self, w, h )
                surface.SetDrawColor( 0, 0, 0, 0 )
                surface.DrawRect( 0, 0, w, h )
                if( cpanels[k] == selectedChar ) then
                    surface.SetDrawColor( 252, 186, 3, 100 )
                    surface.DrawOutlinedRect( 0, 0, w, h )
                end
            end
            cpanels[k].DoClick = function( self ) -- if you press the char, then select it
                selectedChar = self
                surface.PlaySound( "UI/buttonclick.wav" )
            end

            local txt = vgui.Create( "DLabel", cpanels[k] )
            txt:SetText( v.name || "NAME" )
            txt:SetFont( "q_charNameText" )
            txt:SetTextColor( Color( 200, 200, 200, 220 ) )
            txt:SizeToContents()
            local txtW, txtH = txt:GetSize()
            txt:SetPos( padding, cpanels[k].h/4 - txtH/2 )
            local txtX, txtY = txt:GetPos()

            local lvl = vgui.Create( "DLabel", cpanels[k] )
            lvl:SetText( "Level " .. v.lvl .. " Citizen" )
            lvl:SetFont( "q_text2" )
            lvl:SetTextColor( Color( 180, 180, 180, 225 ) )
            lvl:SizeToContents()
            local lvlW, lvlH = lvl:GetSize()
            lvl:SetPos( txtX, txtY + lvlH )
        end

        -- create char button
        local cr = vgui.Create( "DButton", p )
        cr:SetText("Create New Character")
        cr:SetFont( "q_text2" )
        cr:SetTextColor( Color( 0, 0, 0, 255 ) )
        cr:SizeToContents()
        cr.w, cr.h = cr:GetSize()
        cr:SetPos( clist.x + ( clist.w/2 - cr.w/2 ), clist.y + ( ( clist.h - cr.h ) - padding*2 ) )
        cr.Paint = function( self ) 
            theme.button( self )
        end
        cr.DoClick = function()
            surface.PlaySound( "UI/buttonclick.wav" )
        end
        cr.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end

        return p
    end,
    charCreate = function( parent )
        local pW, pH = parent:GetSize()
        local args = {
            CloseButtonText = "Return",
            CloseButtonFont = "q_text",
        }
        local p, c = page.New( parent, args )

        c:SetSize( 85 * resScale, 25 * resScale )
        local closeW, closeH = c:GetSize()
        c:SetPos( padding*4, (pH - closeH) - padding*4 )

        return p
    end
}

function menu.open( dt )
    Quantum.Client.IsInMenu = true -- hide the hud
    if( !f ) then
        local f = vgui.Create( "DFrame" )
        f:SetTitle( "Character Menu" )
        f:SetSize( sw, sh )
        f.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 120 )
            surface.DrawRect( 0, 0, w, h )
        end
        f:SetDraggable( false )
        f:MakePopup()
        function f:OnClose()
            Quantum.Client.IsInMenu = false -- show the hud when closed
        end

        local charSel = pages.charSelect( f ) -- test
    end
end

return menu