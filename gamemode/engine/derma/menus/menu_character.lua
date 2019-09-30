--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local menu = {}

local net = Quantum.Client.Menu.GetAPI( "net" )
local page = Quantum.Client.Menu.GetAPI( "page" )

local resScale = Quantum.Client.ResolutionScale

local pages = {
    charSelect = function()
        local args = {
            CloseButtonPaint = function( self, w, h )
                surface.SetDrawColor( 100, 100, 100, 255 )
                surface.DrawRect( 0, 0, w, h )
            end,
            OnClose = function() print("close test") end
        }
        local p = page.New( args )

        local clist = vgui.Create( "DPanel", p )
        clist:SetSize( 200 * resScale, sh - padding*10 )
        clist.w, clist.h = clist:GetSize()
        clist:SetPos( (sw - clist.w) - padding*2, sh/2 - clist.h/2 )
        clist.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 200 )
            surface.DrawRect( 0, 0, w, h )
        end

        return p
    end
}

function menu.open( dt )
    local sw, sh = ScrW(), ScrH()
    local padding = 10 * resScale
    if( !f ) then
        local f = vgui.Create( "DFrame" )
        f:SetTitle( "Character Menu" )
        f:SetSize( sw, sh )
        f.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 190 )
            surface.DrawRect( 0, 0, w, h )
        end
        f:MakePopup()

        pages.charSelect() -- test

        

        -- local txt = vgui.Create( "DTextEntry", f )
        -- txt:SetText( "Enter name here" )
        -- txt:SetSize( 250, 25 )
        -- local txtW, txtH = txt:GetSize()
        -- txt:SetPos( sw/2 - txtW/2, sh/2 - txtH/2 )
        -- local txtX, txtY = txt:GetPos()

        -- local b = vgui.Create( "DButton", f )
        -- b:SetText( "Create Char" )
        -- b:SizeToContents()
        -- local bW, bH = b:GetSize()
        -- b:SetPos( sw/2 - bW/2, txtY - bH )
        -- b.DoClick = function()
        --     net.RunNetworkedFunc( "createChar", { name = txt:GetValue() } )
        -- end
    end
end

return menu