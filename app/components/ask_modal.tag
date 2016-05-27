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

        <div if={!loading} class="modal-body">
          <div class="profile-container">
            <img class="profile-image img-circle" src={ API.getCurrentUserProfilePicture() }>
            <div class="user-name text-muted" if={ !loggedIn }>Anonymous</div>
            <div class="user-name text-muted" if={ loggedIn }>{ Parse.User.current().get('firstName') } { Parse.User.current().get('lastName') }</div>
          </div>

          <div class="post-container info-btns">
            <textarea rows="5" autofocus name="searchField" placeholder="Post about ICTD" class="searchbox">{question}</textarea>
            <div class="text-muted" id="topic" if={ topic!='' }>#{topic}</div>
            <div class="handle-container">
              <input class="handle" type="text" name="name" placeholder= "Handle (Optional)" if={ !loggedIn }></input>
            </div>

          </div>
          <div class="go text-xs-center">
            <button type="button" class="btn btn-primary go-btn" onclick={createQuestion}>Post</button>
            <div class="error text-warning" if={ isError }>{ error }</div>
          </div>
        </div>

      </div>


    </div>
  </div>

  <script>
    askModalTag   = this
    var self      = this
    self.loggedIn = false
    self.loading  = false
    self.isError  = false
    self.error    = ""
    self.topic    = ""

    self.question = ""

    this.on('mount', function(){
      $('#askModal').on('hidden.bs.modal', function() {
        self.isError    = false
        self.error      = ""
        self.loading    = false
        self.question   = ""
        self.name.value = ""
      })
    })

    init(){
      self.topic    = ""
      self.question = ""
    }


    show(){
      $('#askModal').modal('show')
      self.searchField.focus()
      self.searchField.value= self.question

      if (Parse.User.current().get('type') == 'dummy') self.loggedIn = false
      else self.loggedIn = true

      self.update()
    }

    hide(){
      $('#askModal').modal('hide')
    }

    createQuestion(){
      self.loading = true

      var content = self.searchField.value
      if (content.length < 5) {
        self.isError = true
        self.error = "Posts must be at least 5 characters long"
        self.loading = false
        self.update()
        return
      }

      var post = new Post()

      var currentUser = Parse.User.current()

      post.set("content",content)
      post.set("author",currentUser)
      post.set("anonymous", false)
      post.set("newsFeedViewsBy",[])
      post.set("answerCount",0)
      post.set("viewcount",0)
      post.set("wannaknowCount",0)
      post.set("topic", self.topic)

      post.set("university","umich")
      post.set("group", containerTag.group)

      post.save().then(function(){
        var Wannaknow = Parse.Object.extend('WannaKnow')
        var wannaknow = new Wannaknow()
        wannaknow.save({
          post: post,
          user: Parse.User.current()
        },{
          success: function(post) {
            self.loading=false
            self.hide()
            self.init()
            self.trigger('posted')
          },
          error: function(post, error) {
            self.isError = true
            self.error = error.message
            self.update()
          }
        })
      })
    }

  </script>

  <style scoped>
    :scope{
      text-align: center;
    }

    .modal-content {
      background-color: #F5F5F5;
    }

    .modal-content{
      min-height: 300px
    }

    .profile-image {
      height: 80px;
      width: 80px;
    }

    .user-name {
      color: #616161;
      font-size: large;
      margin-top:15px;
    }

    .post-container {
      margin-top: 50px;
    }

    .searchbox{
      overflow:hidden;
      resize: none;
      text-align: left;
      min-height: 45px!important;
      margin-bottom: 10px;
      width: 100%;
      font-size: 24px;
      padding: 7px 15px;
      border: none;
      border-bottom: 1px solid #BBBBBB;
      background-color: #F5F5F5;
    }

    #topic {
      text-align: left;
      padding-left: 10px;
    }

    .handle-container {
      text-align: left;
      margin-top: 10px;
    }

    .handle {
      text-align: left;
      padding: 5px 10px;
      border: none;
      border-bottom: 1px solid #BBBBBB;
      background-color: #F5F5F5;
    }

    .go{
      margin-top: 20px;
      margin-bottom: 10px;
    }

    .go-btn {
      padding: 5px 20px;
    }

    .error {
      margin-top: 10px;
    }
  </style>

</ask>