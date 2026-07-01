ComponentDefs = {}

ComponentDefs.Position = {
  defaults = { x = 0, y = 0 },

  create = function(data)
    data = data or {}
    return {
      x = data.x or 0,
      y = data.y or 0,
    }
  end
}