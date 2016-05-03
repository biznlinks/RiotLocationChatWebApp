<container>
     <!-- Page Content -->
    <div class="container">
    <h1>{ title }</h1>
    <p>{ body }</p>
    <p>{ route }</p>
    


    <div if={this.posts.length==0}>
          <span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span> Loading...
    </div>

        <div class="row">
            <div class="col-lg-12 text-center">
                <posts if={ route=="posts" }></posts>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 text-center">
                <topics if={ route=="topics" }></topics>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 text-center">
                <postDetail if={ route=="postDetail" }></postDetail>
            </div>
        </div>
        
        <!-- /.row -->
    </div>
    <!-- /.container -->





  <script>
    var self = this
    self.title = 'Now loading...'
    self.body = ''
    


    self.route = "home"

    state = {
      selected: null
    }

    var r = riot.route.create()
    r('#',       home       )
    r('post',   post      )
    r('post/*', postDetail)
    r('topics',  topics     )
    r(           home       ) // `notfound` would be nicer!

    function home() {
      self.update({
        title:  "Welcome to Sophus!",
        body:  "This is the feed!",
        route: "posts"
      })
    }
    function post() {
      self.update({
        title: "These are the posts",
        body: "Lists of posts",
        route: "posts"
      })
    }
    function postDetail(id) {
      state.selected = id
      self.update({
        title: selected.content,
        body: selected.title,
        route: "postDetail"
      })
    }
    function topics() {
      self.update({
        title: "Second feature of your app",
        body: "It could be a config page for example.",
        route: "topics"
      })
    }
  </script>

  <style scoped>
    :scope {
      display: block;
      font-family: sans-serif;
      margin-right: 0;
      margin-bottom: 130px;
      margin-left: 50px;
      padding: 1em;
      text-align: center;
      color: #666;
    }
    
   
    @media (min-width: 480px) {
      :scope {
        margin-right: 200px;
        margin-bottom: 0;
      }
    }
  </style>

</container>

