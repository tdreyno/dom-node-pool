# dom-node-pool

A simple pool for reusing DOM nodes (to avoid stuttering).


## Usage:

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