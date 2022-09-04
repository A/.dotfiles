local function has_prop(packages, hook, callback)
  for _,p in pairs(packages) do
    local package = require(p)

    if package[hook]~=nil then
      callback(package)
    end
  end
end


return {
  has_prop = has_prop,
}
