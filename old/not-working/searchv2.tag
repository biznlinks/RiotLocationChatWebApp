<search>
	<div id="ajax-example">
		<div class="">
      <textarea name="searchField" id="searchField" oninput={onkeyup} placeholder="Ask ICTD!" class="searchbox" onfocus={this.searchonfocus}></textarea>
    </div>
    <div if={ searchField.value.length>0} class="text-xs-center">
    <button type="button" class="btn btn-primary " onclick={createQuestion}>Ask a new question</button>
   </div>

   <div show={ filtered.length } class="card ">
    <div class="card-block" each={post,i in filtered.slice(0,5)} onclick="{ parent.selected }">

      <span class={ active: parent.active==i}>{this.getHighlightedContent(post.content.slice(0,140))}</span>

    </div>

  </div>


</div>
<script>
  searchtag = this

  this.min = opts.min || 1
  this.filtered  = []
  this.active = -1
  var self = this

  this.lastWord = ""

  this.choices = ['test','mark','chi','ictd in europe']

  this.on("mount", function(){

    API.getallposts().then(function(posts){
      self.initChoices = posts
      self.choices = posts
      _.each(self.choices, function(post){
        post.content = post.get('content')
      })
    })
  })

  init(){
    self.searchField.value = ""
    self.filtered = []
    self.update()
  }

  searchonfocus(){
   this.parent.onSearchFocus()
 }


 createQuestion(){
  console.log('creating a new question '+self.searchField.value);
  askModalTag.update({question: self.searchField.value, topic:""})
  self.init()
  askModalTag.show()
}

scrollToTop(){
  $('html, body').animate({
    scrollTop: (this.searchField.offsetTop ) + 'px'
  }, 'fast');
}



getHighlightedContent(content){
  var res = content.split(" ");
        // res = _.map(res, function(word){
        //   if (self.searchField.value.toLowerCase().includes(word.toLowerCase())){
        //     console.log('wrd ' + word);
        //     return "<strong>"+word+"</strong>"
        //   } 
        //   return word
        // })
        return res.join(' ')
      }

      onkeyup(e){

        var searchText = this.searchField.value
        
        this.scrollToTop()
        
        var lastWord = getLastWord(searchText)
        if (lastWord === "")
          this.getMongoResults()
        else 
          this.lastWord = lastWord

        if(e.target.value.length < this.min) {
          this.filtered = []
          this.active = -1
          return
        }

        this.filtered = this.choices.filter(function(c) {

          return c.content.toLowerCase().match(self.re(e))
        })


            if(e.which == 13) { // enter
              this.filtered.length && this.selection(this.filtered[this.active])
            }

            if(e.which == 27) { // escape
              this.selection('')
            }
          }


          function getLastWord(text){
            last_word = text.split(" ").splice(-1)[0];
            if (last_word==" "){
             last_word = text.split(" ").splice(-1)[1]
           }
           return last_word;

         }


         re(e) {
          return RegExp(self.lastWord.toLowerCase(),'i')
        }



        selected(s) {
          // $('#askModal').modal('hide')
          var postId = s.item.post.id
          if(typeof postId === "object")
            postId = s.item.post.objectId

          self.init()

          var to = "/post/"+ postId
          riot.route(to)
        }

        selection(txt) {
          console.log('outnow');
          this.active = -1
        }

        getMongoResults(input) {
          console.log("making request");

          var url = 'https://api.mongolab.com/api/1/databases/sophus/collections/Post/?q={"$text":{"$search":"'+ self.searchField.value +'"}}&f={"score":{"$meta":"textScore"}}&apiKey=zhmz80yjEQ7dgo_VK90d88fZ3vmEeIWE';

          $.getJSON(url, function (data) {
            if (data.length === 0){
              self.choices = self.initChoices
            } else {
              _.each(data, function(d){d.id = d._id;})
              self.choices = data ;
              self.filtered = data;
            }
            self.update()


          });
        }




      </script>

      <style scoped>
       #searchField{
        overflow:hidden;
        resize: none;
        text-align: center;
        min-height: 45px!important;
        margin-bottom: 0;
        width: 100%;
        height: 62px;
        font-size: 24px;
        padding: 0 15px;
        line-height: 62px;
        border: none;

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
