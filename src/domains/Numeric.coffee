### Domain: Solved values

Merges values from all other domains, 
enables anonymous constraints on immutable values

###

Domain  = require('../concepts/Domain')
Selectors = require('../methods/Selectors')

class Numeric extends Domain
  priority: 10

  # Numeric domains usually dont use worker
  url: null

class Numeric::Methods extends Domain::Methods

  "&&": (a, b) ->
    return a && b

  "||": (a, b) ->
    return a || b

  "+": (a, b) ->
    return a + b

  "-": (a, b) ->
    return a - b

  "*": (a, b) ->
    return a * b

  "/": (a, b) ->
    return a / b

  'Math': Math
  'Infinity': Infinity
  'NaN': NaN


  isVariable: (object) ->
    return object[0] == 'get'

  isConstraint: (object) ->
    return @constraints[object[0]]

  get: 
    command: (operation, continuation, scope, meta, object, path, contd, scoped) ->
      path = @getPath(object, path)

      domain = @getVariableDomain(operation, true)
      if !domain || domain.priority < 0
        domain = @
      else if domain != @
        if domain.structured
          clone = ['get', null, path, @getContinuation(continuation || "")]
          if scope && scope != @scope
            clone.push(@identity.provide(scope))
          clone.parent = operation.parent
          clone.index = operation.index
          clone.domain = domain
          console.log('schedule', domain, [operation, clone], scope)
          @Update([clone])
          return
      if scoped
        scoped = @engine.identity.solve(scoped)
      else
        scoped = scope
      console.error('wtf', scoped)
      return domain.watch(null, path, operation, @getContinuation(continuation || contd || ""), scoped)

for property, value of Selectors::
  Numeric::Methods::[property] = value


Numeric::Methods::['*'].linear = false
Numeric::Methods::['/'].linear = false
module.exports = Numeric