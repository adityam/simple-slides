if not modules then modules = { } end modules ['mtx-simplestyles'] = {
    version   = 0.1,
    comment   = "Show a particular style of simpleslides module",
    author    = "Aditya Mahajan and Thomas A. Schmitz",
    copyright = "Aditya Mahajan and Thomas A. Schmitz",
    license   = "GNU Public License v 2.0"
}

-- Usage: To generate all variations for BigNumber use
--      mtxrun --script simpleslides --style=BigNumber
-- To generate all variations of all styles use
--      mtxrun --script simpleslides --all
--
-- By default, luatex engine is used. If you want a specific engine, you can
-- pass --engine=pdftex or --engine=xetex to the program.

third        = third or {}
simpleslides = third.simpleslides or {}

simpleslides.options = {
  ["BigNumber"]         ={color={"blue", "red"}},
  ["BottomSquares"]     ={},
  ["Boxed"]             ={},
  ["BoxedTitle"]        ={},
  ["Ellipse"]           ={},
  ["Embossed"]          ={},
  ["Framed"]            ={alternative={"square", "stripe"}},
  ["FramedTitle"]       ={},
  ["HorizontalStripes"] ={color={"blue", "green", "red"}},
  ["NarrowStripes"]     ={color={"blue", "green", "red"}},
  ["PlainCounter"]      ={},
  ["RainbowStripe"]     ={},
  ["Rounded"]           ={},
  ["Shaded"]            ={color={"blue", "green", "bluered"}},
  ["SideSquares"]       ={},
  ["Split"]             ={},
  ["Sunrise"]           ={},
  ["Swoosh"]            ={},
  ["ThickStripes"]      ={},
}

function simpleslides.setup(style, color, alternative)
  local usemodule = "\\usemodule[simpleslides]\n"
  local options   = ""
  if style  then options = options .. "style=" ..style.. ",\n" end 
  if color  then options = options .. "color=" ..color.. ",\n" end
  if alternative then options = options .. "alternative="..alternative..",\n" end
  return usemodule .. "[" .. options .. "]\n"
end

simpleslides.body = [[
\setupTitle
  [title={Presentation Title},
   author={F.~Author, S.~Another},
   date={Date / Occasion}]

\setupexternalfigures[location={local,global,default}] 

\starttext

\placeTitle


\SlideTitle{Make Titles Informative}

\startitemize
  \item Use bullets points when appropriate.
  \item Use pictures when possible
  \item Do not put too much information on one slide
\stopitemize

\IncludePicture
  [horizontal]
  [cow] % Name of the image
  {A Dutch Cow} % Title of the slide

\IncludePicture
  [horizontal]
  [cow] % Name of the image
  [highlight=yes,
   grid=yes]
  {A Dutch Cow with a grid} % Title of the slide

\IncludePicture
  [horizontal]
  [cow] % Name of the image
  [highlight=yes,
   grid=yes,
   steps=5, % Each grid block is broken into these many parts.
   subgrid=yes]
  {A Dutch Cow with a fine grid} % Title of the slide

\IncludePicture
  [horizontal]
  [cow] % Name of the image
  [highlight=yes,
   grid=yes,
   subgrid=yes,
   alternative=circle,
   color=orange,
   x=1.4,
   y=8.2,
   xscale=1.5,
   shadow=bottomleft]
  {The head of a dutch cow}


\IncludePicture
  [horizontal]
  [cow] % Name of the image
  [highlight=yes,
   grid=no,
   subgrid=no,
   alternative=circle,
   color=orange,
   x=1.4,
   y=8.2,
   xscale=1.5,
   shadow=bottomleft]
   {The head of a dutch cow}

\IncludePicture
  [horizontal]
  [cow] % Name of the image
  [highlight=yes,
   grid=no,
   subgrid=no,
   alternative=arrow,
   color=orange,
   x=0.4,
   y=6.8,
   direction=-90, 
   length=3cm,
   shadow=topright]
   {The mouth of a dutch cow}

\IncludePicture
  [horizontal]
  [cow] % Name of the image
  [highlight=yes,
   grid=no,
   subgrid=no,
   alternative=focus,
   color=orange,
   x=1.4,
   y=8.2,
   xscale=1.5,
   opacity=0.5]
   {The head of a dutch cow}

\IncludePicture
  [vertical]
  [mill]
  [width=\NormalWidth]
  {The windmills are an example of a green energy source.}

\SlideTitle{Summary}

\startitemize
  \item The {\em first main message} of your talk in one or two lines.
  \item The {\em second main message} of your talk in one or two lines.
  \item Perhaps a {\em third message}, but not more than that.
\stopitemize

\stoptext
]]

local engine   = environment.argument("engine") or "luatex"
local command  = "context --" .. engine  -- .. " --batchmode"
local styles   = environment.argument("styles")
local filename = "styles/simpleslides-example.tex"

function simpleslides.create_test(style, color, alternative)
  local file = assert(io.open(filename, "w"))
  file:write(simpleslides.setup(style,color,alternative))
  file:write(simpleslides.body)
  assert(io.close(file))
  local result = "--result=styles/"..style
  if color  then result = result .. "-" .. color  end
  if alternative then result = result .. "-" .. alternative end 
  local str = command .. " " .. filename .. " " .. result
  logs.report("simpleslides", "executing " .. str)
  os.execute(str)
end

function simpleslides.show_style(style)
  if simpleslides.options[style] then
    local colors  = simpleslides.options[style].color
    local bottoms = simpleslides.options[style].alternative
    if colors then
      for i,color in pairs(colors) do
        if bottoms then
          for j,alternative in pairs(bottoms) do
            simpleslides.create_test(style,color,alternative)
          end
        else
          simpleslides.create_test(style,color,nil)
        end
      end
    else
      if bottoms then
        for j,alternative in pairs(bottoms) do
          simpleslides.create_test(style,nil,alternative)
        end
      else
        simpleslides.create_test(style,nil,nil)
      end
    end
  else 
    logs.report("simplestyles", "style \"" .. style .. "\" does not exist")
  end
end

if styles == "all" then
  for s,i in pairs(simpleslides.options) do
    simpleslides.show_style(s)
  end
else
  simpleslides.show_style(styles)
end
