<ask>
  <!-- <button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#askModal">Ask a new Question</button> -->
  <!-- Modal -->

  <div id="askModal" class="modal fade" role="dialog">

    <div  class="modal-dialog">

      <!-- Modal content-->
      <div class="modal-content">
        <div if={loading} class="modal-body text-xs-center">
          <i class="fa fa-spinner fa-spin fa-3x fa-fw margin-bottom"></i>
          <span class="sr-only">Loading...</span>
        </div>
        <div class="modal-header">
          <h4 class="modal-title">Ask a new question</h4>
        </div>

        <div if={!loading} class="modal-body">

          <div class="info-btns">
            <textarea rows=2 autofocus name="searchField" placeholder="Ask ICTD!" class="searchbox">{question}</textarea>
            <div id="topic">#{topic}</div>
            <input class="text-xs-center" type="text" name="name" placeholder= "Handle (Optional)"></input>

          </div>
          <div class="go text-xs-center">
            <button type="button" class="btn btn-primary" onclick={createQuestion}>Go!</button>
          </div>
        </div>

      </div>


    </div>
  </div>

  <script>
    askModalTag = this
    self = this
    this.loading= false
    this.topic = ""

    this.question=""

    this.on('mount', function(){

    })

    init(){
      self.topic = ""
      self.question = ""
    }


    show(){
      $('#askModal').modal('show')
      this.searchField.focus()
      this.searchField.value= self.question
      self.update()
    }

    hide(){
      $('#askModal').modal('hide')
    }

    createQuestion(){
      self.loading = true

      var content = self.searchField.value;
      var post = new Post();

      var currentUser = Parse.User.current();

      post.set("content",content)
      post.set("author",currentUser)
      post.set("anonymous", false)
      post.set("newsFeedViewsBy",[])
      post.set("answerCount",0)
      post.set("viewcount",0)
      post.set("wannaknowCount",1)
      post.set("topic", self.topic)

      post.set("university","umich")

      post.save().then(function(){
        console.log("Successfully added a post ")
        self.loading=false
        self.hide()
        self.init()
        self.trigger('posted')
      })
    }

  </script>

  <style scoped>
    :scope{
      text-align: center;
    }
    .modal-content{
      min-height: 300px
    }

    .searchbox{
      overflow:hidden;
      resize: none;
      text-align: center;
      min-height: 45px!important;
      margin-bottom: 0;
      width: 100%;
      font-size: 24px;
      padding: 0 15px;

      box-shadow: 0 2px 9px 0 rgba(0,0,0,.29);

    }
    .go{
      margin-top: 10px;
    }
  </style>

</ask>