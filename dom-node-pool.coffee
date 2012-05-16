###

A simple pool for reusing DOM nodes (to avoid stuttering)

Usage:

  var onClick = function() { alert("Clicked " + this.name); };

  var linkPool = new DOMNodePool({
    tagName:     "a",
    initialSize: 10,
    autoInsert:  document.getElementById("my_links"),
    onPop:       function(a) { a.addEventListener("click", onClick); },
    onPush:      function(a) { a.removeEventListener("click", onClick); }
  });
  
  var aLink = linkPool.pop();
  aLink.name = "Hello";
  
  // User clicks aLink, alert shows "Clicked Hello"
  
  linkPool.push(aLink);

###
class DOMNodePool
  
  constructor: (options={})->
    {
      tagName:     @tagName
      autoInsert:  @autoInsert
      onGenerate:  @onGenerate
      onInsert:    @onInsert
      onPush:      @onPush
      onPull:      @onPull
      initialSize: initialSize
    } = options
    
    @tagName    ?= "div"
    @autoInsert ?= document.body
    initialSize ?= 5
    
    @onGenerate ?= (e) ->
    @onInsert   ?= (e) -> e.style.visibility = "hidden"
    @onPush     ?= (e) -> 
    @onPull     ?= (e) -> 
    
    @_pool = []
    @_generateNode() for i in [0...initialSize]
  
  _generateNode: ->  
    elem = document.createElement(@tagName)
    @onGenerate(elem)
    @push(elem)

    if @autoInsert
      @onInsert(elem)
      @autoInsert.appendChild(elem)
      
    undefined

  pop: ->
    @_generateNode() if !@_pool.length
    @onPop(@_pool[@_pool.length-1])
    @_pool.pop()

  push: (n) ->  
    @onPush(n)
    @_pool.push(n)
    undefined