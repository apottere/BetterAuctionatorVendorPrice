local addon, _ns = ...

local goldicon    = "|TInterface\\MoneyFrame\\UI-GoldIcon:12:12:4:0|t"
local silvericon  = "|TInterface\\MoneyFrame\\UI-SilverIcon:12:12:4:0|t"
local coppericon  = "|TInterface\\MoneyFrame\\UI-CopperIcon:12:12:4:0|t"

function round (v)
  return math.floor (v + 0.5);
end

function val2gsc (v)
  local rv = round(v)
  local g = math.floor (rv/10000);
  rv = rv - g*10000;
  local s = math.floor (rv/100);
  rv = rv - s*100;
  local c = rv;
  return g, s, c
end

function priceToMoneyString(val, noZeroCoppers)
  local gold, silver, copper  = val2gsc(val);
  local st = "";
  if (gold ~= 0) then
    st = gold .. goldicon.."  ";
  end

  if (st ~= "") then
    st = st .. format("%02i%s  ", silver, silvericon);
  elseif (silver ~= 0) then
    st = st .. silver .. silvericon .. "  ";
  end

  if (noZeroCoppers and copper == 0) then
    return st;
  end

  if (st ~= "") then
    st = st .. format("%02i%s", copper, coppericon);
  elseif (copper ~= 0) then
    st = st .. copper .. coppericon;
  end

  return st;
end


function ToolTipHook(tip)
  local name, link = tip:GetItem()
  if not link then
    return
  end

  local _, _, _, _, _, _, _, itemStackCount, _, _, itemSellPrice = GetItemInfo(link)
  if not itemSellPrice or itemSellPrice <= 0 or itemStackCount <= 1 then
    return
  end

  local c = GetMouseFocus()
  local count = 1
  if c then
    local bn = c:GetName() and (c:GetName() .. "Count")
    count = c.count or (c.Count and c.Count:GetText()) or (c.Quantity and c.Quantity:GetText())
    count = tonumber(count) or 1
    if count <= 1 then
      count = 1
    end
  end

  if count <= 1 then
      return
  end

  tip:AddDoubleLine("Vendor |cFFAAAAFFx" .. count .. "|r", "|cFFFFFFFF" .. priceToMoneyString(count * itemSellPrice))
  if count ~= itemStackCount then
      tip:AddDoubleLine("Vendor |cFFAAAAFFx" .. itemStackCount .. "|r", "|cFFFFFFFF" .. priceToMoneyString(itemStackCount * itemSellPrice))
  end

  return true
end

GameTooltip:HookScript("OnTooltipSetItem", ToolTipHook)
ItemRefTooltip:HookScript("OnTooltipSetItem", ToolTipHook)

