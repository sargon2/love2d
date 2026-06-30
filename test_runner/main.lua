lu = require('lib.luaunit.luaunit')

function testBasicPass()
    lu.assertEquals(1,1)
end

-- We have to have at least one command line argument for test discovery to work, because of how love2d invokes lua.
os.exit(lu.LuaUnit.run('--output', 'text'))