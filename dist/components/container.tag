<container>
  <app-navi></app-navi>
  <!-- Page Content -->
  <div class="container">
    <!-- <h1>{ title }</h1> -->


    

    <div class="row">
      <div class="col-lg-6 col-md-offset-3  text-center">
        <feed if={ route=="posts" }></feed>
        <topics if={ route=="topics" }></topics>
        <postDetail if={ route=="postDetail" }></postDetail>
        <topicsfeed if={ route=="topicsfeed" }></topicsfeed>
      </div>
    </div>

    <!-- /.row -->
  </div>
  <!-- /.container -->

  <script>
    var self = this
    containerTag = this
    self.title = 'Now loading...'
    self.body = ''
    
    self.route = "home"

    this.on("mount", function(){
      $.getJSON("/data/papers_with_youtube_id.json", function(json) {
        allTopics = json
      });
    })
    
    var r = riot.route.create()
    r('#',       home       )
    r('post',   post      )
    r('post/*', postDetail)
    r('topics',  topics     )
    r('topics/*', topicsfeed)
    r(           home       ) // `notfound` would be nicer!

    function home() {
      self.update({
        title:  "Welcome to Sophus!",
        body:  "This is the feed!",
        route: "posts",
        selectedId: null,
      })
    }
    function post() {
      self.update({
        title: "Recent Posts",
        body: "Lists of posts",
        route: "posts",
        selectedId: null,
      })
    }
    function postDetail(id) {
      self.update({
        title: "",
        body: "",
        selectedId: id,
        route: "postDetail"
      })
    }
    function topics() {

      self.update({
        title: "Trending Topics",
        body: "",
        selectedId: null,
        route: "topics"
      })
    }
    function topicsfeed(id) {
      self.tags.topicsfeed.unmount()
      self.update({
        title: "",
        body: "",
        selectedId: null,
        selectedTopicId: id,
        route: "topicsfeed"
      })
      riot.mount('topicsfeed', {topicName: id})
    }

</script>

<style scoped>
  :scope {
    display: block;
    font-family: sans-serif;
    /*margin-right: 0;*/
    margin-bottom: 130px;
    /*margin-left: 50px;*/
    padding: 1em;
    /*text-align: center;*/
    color: #666;

  }


  @media (min-width: 480px) {
    :scope {
      /*margin-right: 200px;*/
      margin-bottom: 0;
    }
  }
</style>

</container>

