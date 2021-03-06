local util = require("spec.util")

describe("assignment to nominal record field", function()
   it("passes", util.check [[
      local Node = record
         foo: boolean
      end
      local Type = record
         node: Node
      end
      local t: Type = {}
      t.node = {}
   ]])

   it("fails if mismatch", util.check_type_error([[
      local Node = record
         foo: boolean
      end
      local Type = record
         node: Node
      end
      local t: Type = {}
      t.node = 123
   ]], {
      { msg = "in assignment: got number, expected Node" }
   }))

   it("fails with incorrect literal index", util.check_type_error([[
      local Node = record
          f: string
      end

      local root: Node = {}
      root["a"] = ""
   ]], {
      { msg = "invalid key 'a' in record 'root' of type Node" }
   }))

   it("fails with variable index with arbitrary string", util.check_type_error([[
      local Node = record
          f: string
      end

      local root: Node = {}
      local a = "f"
      root[a] = "x"
   ]], {
      { msg = "cannot index object of type Node with a string, consider using an enum" }
   }))

   it("succeeds with variable index with enum", util.check [[
      local Node = record
          f: string
          g: string
      end

      local Keys = enum
         "f"
         "g"
      end

      local root: Node = {}
      local a: Keys = "f"
      root[a] = "x"
   ]])
end)
