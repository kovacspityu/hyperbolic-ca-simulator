{makeAppendRewrite, vdRule} = require "./vondyck_rewriter.coffee"
{parseChain, unity} = require "./vondyck_chain.coffee"
{RewriteRuleset, knuthBendix} = require "../core/knuth_bendix.coffee"
{CenteredVonDyck} = require "./triangle_group_representation.coffee"

#Top-level interface for vonDyck groups.
exports.VonDyck = class VonDyck
  constructor: (@n, @m, @k=2)->
    throw new Error "bad N" if @n <= 0
    throw new Error "bad M" if @m <= 0
    throw new Error "bad K" if @k <= 0

    @unity = unity

    #Matrix representation is only supported for hyperbolic groups at the moment.
    @representation = switch @type()
      when "hyperbolic"
        new CenteredVonDyck @n, @m, @k
      when "euclidean"
        null
      when "spheric"
        null

  #Return group type. One of "hyperbolic", "euclidean" or "spheric"
  type: ->
    #1/n+1/m+1/k  ?  1
    #
    # (nm+nk+mk) ? nmk
    num = @n*@m + @n*@k + @m*@k
    den = @n*@m*@k
    
    if num < den
      "hyperbolic"
    else if num is den
      "euclidean"
    else
      "spheric"

  toString: -> "VonDyck(#{@n}, #{@m}, #{@k})"
  
  parse: (s) -> parseChain s
  
  solve: ->
    rewriteRuleset = knuthBendix vdRule @n, @m, @k
    @appendRewrite = makeAppendRewrite rewriteRuleset
    #console.log "Solved group #{@} OK"
    
  appendRewrite: (chain, stack)->
    throw new Error "Group not solved"
  
  rewrite: (chain)->
    @appendRewrite @unity, chain.asStack()
  
  repr: (chain) -> chain.repr @representation
    
  inverse: (chain) -> @appendInverse unity, chain
    
  # appends c^-1 to a
  appendInverse: (a, c) ->
    elementsWithPowers = c.asStack()
    elementsWithPowers.reverse()
    for e_p in elementsWithPowers
      e_p[1] *= -1
    @appendRewrite a, elementsWithPowers

  append: (c1, c2) ->
    @appendRewrite c1, c2.asStack()    
