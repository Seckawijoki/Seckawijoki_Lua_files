function string.trim(str)
    return string.gsub(str, "^%s*(.-)%s*$", "%1")
 end

--  function trim(sz)
--      if not sz then return "" end
--      local after = {}
--      for i=1, #sz do 
--        local c = sz:sub(i, i)
--        -- print(char)
--        if c ~= ' ' then
--          after[#after + 1] = c
--        end
--      end
--      return table.concat(after)
--  end
 
 function string.split(sz)
     local words = {}
     local start = 1;
     for i=1, #sz do 
         local c = sz:sub(i, i)
         -- print(char)
         if c == ' ' then
             if start ~= i then
                 words[#words + 1] = sz:sub(start, i - 1)
             end
             start = i + 1
         end
     end
     words[#words + 1] = sz:sub(start)
     return words
 end