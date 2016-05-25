<container>
  

  <div class="">
    <!-- <h1>{ title }</h1> -->

    <ask name="askModal"></ask>
    <div class="row">
      <div class="main col-md-10 col-md-offset-1 col-lg-8 col-lg-offset-2  text-center">
        <feed if={ route=="home" }></feed>
      </div>
    </div>

    <!-- /.row -->
  </div>
  <!-- /.container -->

  <script>
    var self     = this
    containerTag = this
    self.title   = 'Now loading...'
    self.body    = ''

    self.route   = "home"

    this.on("mount", function(){
      $('#signupSuccess').hide()
      $('#loginSuccess').hide()

      var groupName = "ICTD"
      API.fetchOne("Group", "name", groupName).then(function(group){
        Group = group
      })
    })

    var r = riot.route.create()
    r('#',       home       )
    r('post',   home      )
    
    function home() {
      self.track('home')
      self.update({
        title:  "Welcome to Sophus!",
        body:  "This is the feed!",
        route: "home",
        selectedId: null,
      })
      self.tags.feed.init()
    }
    
</script>
<style scoped>
  :scope {
    display: block;
    font-family: sans-serif;
    /*margin-right: 0;*/
    margin-bottom: 130px;
    /*margin-left: 50px;*/
    /*padding: 1em;*/
    /*text-align: center;*/
    color: #666;


  }
  .main {
        padding-right: 0px;
    padding-left: 0px;
  }

  .row {
         margin-right: 0px; 
     margin-left: 0px; 
  }


  @media (min-width: 480px) {
    :scope {
      /*margin-right: 200px;*/
      margin-bottom: 0;
    }
  }
</style>

</container>

