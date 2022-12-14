--[[
 Copyright (c) 2012-2013, criado por Youka - refeito por tophf - corrigido e traduzido por Leinad4Mind
 All rights reserved®.
 
 Um grande agradecimento a todos os meus amigos
 que sempre me apoiaram, e a toda a comunidade
 de anime portuguesa.
--]]

script_name = "Desclocar Posicionamento"
script_description = "Deslocar Posições em linhas seleccionadas com \pos,\move,\org,\clip."
script_author = "Youka, tophf e Leinad4Mind"
script_version = "3.1"
script_modified = "20 de Outubro 2013"

re = require("re")

function pos_shift(subs, sel)
  local checkrunnable, execute, makedialog
  checkrunnable = function()
    local r = re.compile("\\{.*\\\\(?:pos|move|org|i?clip)\\s*\\(.*\\}", re.ICASE)
    for _index_0 = 1, #sel do
      local i = sel[_index_0]
      if r:match(subs[i].text) then
        return true
      end
    end
    aegisub.log("Deve seleccionar linhas que contenham \\pos ou \\move ou \\org ou \\clip")
    return aegisub.cancel()
  end
  execute = function()
    local btns = {
      ok = "&Deslocar",
      cancel = "&Cancelar"
    }
    local btn, cfg = aegisub.dialog.display(makedialog(), {
      btns.ok,
      btns.cancel
    }, btns)
    if not btn or btn == btns.cancel then
      aegisub.cancel()
    end
    do
      cfg.pos = {
        cfg.pos_x,
        cfg.pos_y
      }
      cfg.org = {
        cfg.org_x,
        cfg.org_y
      }
      cfg.move = {
        cfg.move_x1,
        cfg.move_y1,
        cfg.move_x2,
        cfg.move_y2
      }
      cfg.clip = {
        cfg.clip_x,
        cfg.clip_y,
        cfg.clip_x,
        cfg.clip_y
      }
    end
    local float2str
    float2str = function(f)
      return tostring(f):gsub("%.(%d-)0+$", "%.%1"):gsub("%.$", "")
    end
    local arraysum2str
    arraysum2str = function(arr1str, arr2)
      return unpack((function()
        local _accum_0 = { }
        local _len_0 = 1
        for i = 1, #arr1str do
          _accum_0[_len_0] = float2str(tonumber(arr1str[i]) + arr2[i])
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)())
    end
    for _index_0 = 1, #sel do
      local i = sel[_index_0]
      local line = subs[i]
      local s = line.text
      s = s:gsub("\\pos%((%s*%-?[%d%.]+%s*),(%s*%-?[%d%.]+%s*)%)", function(x, y)
        return ("\\pos(%s,%s)"):format(arraysum2str({
          x,
          y
        }, cfg.pos))
      end)
      s = s:gsub("\\move%((%s*%-?[%d%.]+%s*),(%s*%-?[%d%.]+%s*),(%s*%-?[%d%.]+%s*),(%s*%-?[%d%.]+%s*)", function(x, y, x2, y2)
        return ("\\move(%s,%s,%s,%s"):format(arraysum2str({
          x,
          y,
          x2,
          y2
        }, cfg.move))
      end)
      s = s:gsub("\\org%((%s*%-?[%d%.]+%s*),(%s*%-?[%d%.]+%s*)%)", function(x, y)
        return ("\\org(%s,%s)"):format(arraysum2str({
          x,
          y
        }, cfg.org))
      end)
      s = s:gsub("\\(i?clip)%((%s*%-?[%d%.]+%s*),(%s*%-?[%d%.]+%s*),(%s*%-?[%d%.]+%s*),(%s*%-?[%d%.]+%s*)%)", function(tag, x, y, x2, y2)
        return ("\\%s(%s,%s,%s,%s)"):format(tag, arraysum2str({
          x,
          y,
          x2,
          y2
        }, cfg.clip))
      end)
      s = s:gsub("\\(i?clip%(%s*%d*%s*%,?)([mlbsc%s%d%-]+)%)", function(tag, numbers)
        return ("\\%s%s)"):format(tag, numbers:gsub("(-?%d+)%s*(-?%d+)", function(x, y)
          return ("%d %d"):format(arraysum2str({
            x,
            y
          }, cfg.clip))
        end))
      end)
      line.text = s
      subs[i] = line
    end
  end
  makedialog = function()
    local dlg = {
      {
        "label",
        0,
        0,
        1,
        1,
        label = "\\pos"
      },
      {
        "floatedit",
        1,
        0,
        1,
        1,
        name = "pos_x",
        value = 0.00,
        hint = "Deslocar coordenada x de \pos"
      },
      {
        "floatedit",
        2,
        0,
        1,
        1,
        name = "pos_y",
        value = 0.00,
        hint = "Deslocar coordenada y de \pos"
      },
      {
        "label",
        0,
        1,
        1,
        1,
        label = "\\move"
      },
      {
        "floatedit",
        1,
        1,
        1,
        1,
        name = "move_x1",
        value = 0.00,
        hint = "Deslocar primeira coordenada x de \move"
      },
      {
        "floatedit",
        2,
        1,
        1,
        1,
        name = "move_y1",
        value = 0.00,
        hint = "Deslocar primeira coordenada y de \move"
      },
      {
        "floatedit",
        3,
        1,
        1,
        1,
        name = "move_x2",
        value = 0.00,
        hint = "Deslocar segunda coordenada x de \move"
      },
      {
        "floatedit",
        4,
        1,
        1,
        1,
        name = "move_y2",
        value = 0.00,
        hint = "Deslocar segunda coordenada y de \move"
      },
      {
        "label",
        0,
        2,
        1,
        1,
        label = "\\org"
      },
      {
        "floatedit",
        1,
        2,
        1,
        1,
        name = "org_x",
        value = 0.00,
        hint = "Deslocar coordenada x de \org"
      },
      {
        "floatedit",
        2,
        2,
        1,
        1,
        name = "org_y",
        value = 0.00,
        hint = "Deslocar coordenada y de \org"
      },
      {
        "label",
        0,
        3,
        1,
        1,
        label = "\\clip"
      },
      {
        "floatedit",
        1,
        3,
        1,
        1,
        name = "clip_x",
        value = 0.00,
        hint = "Deslocar coordenada x de \clip"
      },
      {
        "floatedit",
        2,
        3,
        1,
        1,
        name = "clip_y",
        value = 0.00,
        hint = "Deslocar coordenada y de \clip"
      }
    }
    for _index_0 = 1, #dlg do
      local c = dlg[_index_0]
      for i, k in ipairs({
        'class',
        'x',
        'y',
        'width',
        'height'
      }) do
        c[k] = c[i]
      end
    end
    return dlg
  end
  checkrunnable()
  execute()
  return sel
end

return aegisub.register_macro(script_name, script_description, pos_shift)
