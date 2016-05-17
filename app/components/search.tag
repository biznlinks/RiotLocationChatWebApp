<search>
	<div id="ajax-example">
		<div class="">
			<input id="searchField" type="text" class="search-query form-control" placeholder="Search Questions in ICTD'16" />
		</div>

		<script>

			String.prototype.hashCode = function() {
				var hash = 0, i, chr, len;
				if (this.length === 0) return hash;
				for (i = 0, len = this.length; i < len; i++) {
					chr   = this.charCodeAt(i);
					hash  = ((hash << 5) - hash) + chr;
          hash |= 0; // Convert to 32bit integer
        }
        return hash;
      };

var objectDict = {};

var autoObj = false; 
var initData = [];

(function($) {
    $.fn.goTo = function() {
        $('html, body').animate({
            scrollTop: (this.offset().top - this.height()) + 'px'
        }, 'fast');
        return this; // for chaining...
    }
})(jQuery);


this.on('mount', function(){
  
  (function() {

    $.getJSON( "https://sophuschi.parseapp.com/get/all",
     function( data ) {
      initData = data;
      var list = data.map(function(i) {
        objectDict[i.content.replace(/(\r\n|\n|\r)/gm,"").hashCode()] = i; 
        return i.content;
      });
      autoObj = new Awesomplete(document.querySelector("#ajax-example input"),{list:list, filter: filterFunction, sort: sort});
      $( "#searchField" ).on('change keydown paste input', function() {
        $( "#ajax-example" ).goTo();
        var elem = $(this);
        var searchTerm = elem.val();
        if (searchTerm!= last_search){
          var lastchar = searchTerm.slice(-1)[0];
          if (lastchar == " "){
            console.log("call json");  
            resetAwesomplete(searchTerm);
          } 
          
        }
        
        last_search = searchTerm;
      });
    });
  })
  (); 
})


curData = [];
function resetAwesomplete(input) {
  console.log("making request");
  if (autoObj) {
   var url = 'https://api.mongolab.com/api/1/databases/sophus/collections/Post/?q={"$text":{"$search":"'+input+'"}}&f={"score":{"$meta":"textScore"}}&apiKey=zhmz80yjEQ7dgo_VK90d88fZ3vmEeIWE';
   $.getJSON(url, function (data) {
    console.log(data);
    if (data.length === 0){
     curdata = initData;
   } else {
       curData = data ;//.sort();
     }
   });
 }

 var list = curData.map(function(i) {
   objectDict[i.content.replace(/(\r\n|\n|\r)/gm,"").hashCode()] = i; 
   return i.content;
 });
 autoObj.list = list;

}



var last_search = "";

function getLastWord(text){
  last_word = text.split(" ").splice(-1)[0];
  if (last_word==" "){
   last_word = text.split(" ").splice(-1)[1]
 }
 return last_word;

}

function filterFunction(text, input) {
  var lastWord = getLastWord(input);
  // console.log(lastWord);
  return ContainsFilter(text, lastWord);

};

function ContainsFilter(a, b) {
	return RegExp(Awesomplete.$.regExpEscape(b.trim()),"i").test(a);
}

var last_search = "";



function sort(a,b){
	aob = objectDict[a.replace(/(\r\n|\n|\r)/gm,"").hashCode()];
	bob = objectDict[b.replace(/(\r\n|\n|\r)/gm,"").hashCode()];
	var keyA = aob.score,
	keyB = bob.score;
        // Compare the 2 dates
        if(keyA > keyB) return -1;
        if(keyA < keyB) return 1;
        return 0;

      }

      window.addEventListener("awesomplete-selectcomplete", function(e){
  // User made a selection from dropdown. This is fired after the selection is applied
  var content = e.target.value;
  console.log(content);
  var objectId = objectDict[content.replace(/(\r\n|\n|\r)/gm,"").hashCode()].objectId;
  console.log(objectId);
  $( "#searchField" ).val("")
  var to = "/post/"+objectId;
  riot.route(to)
}, false);

    </script>

    <style scoped>
     #searchField{
      text-align: center;
      height: 60px;
    }
    .awesomplete {
      width: 100%
    }
    ul {
    	margin-top: 2em !important
    }
    
    
    @media (min-width: 480px) {
      :scope {
        /*margin-right: 200px;*/
        margin-bottom: 0;
      }
    }
  </style>
</search>

