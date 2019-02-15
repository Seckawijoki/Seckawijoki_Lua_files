require("deep_copy_table")

local szSrcFile = "AndroidManifest.xml"
local fileInput = io.open(szSrcFile, "r")
if not fileInput then 
    return
end
io.input(fileInput)
local szFileContent = io.read("*a")
-- print(szFileContent)
-- local tXmlParser = require("xmlSimple").newParser();
-- local tXml = tXmlParser:ParseXmlText(szFileContent);
-- print(table.tostring(tXml))

-- print(tXml.manifest["@package"])
-- print(tXml.meta["@package"])