assert = require "assert"

M = require "./matrix3"

describe "approxEq", ->
  it "must return true for equal matrices", ->
    assert.ok M.approxEq [0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0]

  it "must return false for significantly in equal matrices", ->
    m1 = [0,0,0,0,0,0,0,0,0]
    for i in [0...9]
      m2 = [0,0,0,0,0,0,0,0,0]
      m2[i] = 1.0
      assert.ok not M.approxEq m1, m2
      

describe "eye", ->
  it "msut equal unit matrix", ->
    m = (0.0 for i in [0...9])
    
    for i in [0...3]
      M.set m, i, i, 1.0

    assert.ok M.approxEq(m, M.eye())

describe "mul", ->
  it "must multiply eye to itself", ->
    assert.ok M.approxEq M.eye(), M.mul(M.eye(), M.eye())

  it "must return same non-eye matrix, if multiplied with eye", ->
    m = (i for i in [0...9])

    assert.ok M.approxEq m, M.mul(m, M.eye())
    assert.ok M.approxEq m, M.mul(M.eye(), m)

  it "must change non-eye matrix if squared", ->
    m = (i for i in [0...9])
    assert.ok not M.approxEq m, M.mul(m, m)


describe "rot", ->
  it "must return eye if rotation angle is 0", ->
    assert.ok M.approxEq M.eye(), M.rot(0,1,0.0)
    assert.ok M.approxEq M.eye(), M.rot(0,2,0.0)
    assert.ok M.approxEq M.eye(), M.rot(1,2,0.0)
  it "must return non-eye if rotation angle is not 0", ->
    assert.ok not M.approxEq M.eye(), M.rot(0,1,1.0)


describe "smul", ->
  it "must return 0 if multiplied by 0", ->
    assert.ok M.approxEq M.zero(), M.smul( 0.0, M.eye())

  it "must return same if multiplied by 1", ->
    assert.ok M.approxEq M.eye(), M.smul( 1.0, M.eye())
        