<loader>
  <div class="loader"></div>
  <style>
  .loader {
    border: 16px solid #f3f3f3; /* Light grey */
    border-top: 16px solid #3498db; /* Blue */
    border-radius: 50%;
    width: 120px;
    height: 120px;
    animation: spin 2s linear infinite;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
</style>
</loader>
<container>
  <app-navi></app-navi>
  <!-- Page Content -->
  <div class="">
    <!-- <h1>{ title }</h1> -->

    <signup name="signupModal"></signup>
    <ask name="askModal"></ask>
    <login name="loginModal"></login>
    <forgot name="forgotModal"></forgot>
    <loginsuccess name="loginSuccess"></loginsuccess>
    <signupsuccess name="signupSuccess"></signupsuccess>

    <banner if={ route=="posts" }></banner>
    <div class="row">
      <div class="main col-md-10 col-md-offset-1 col-lg-8 col-lg-offset-2  text-center">
        <feed if={ route=="posts" }></feed>
        <topics if={ route=="schedule" }></topics>
        <postdetail if={ route=="postdetail" }></postdetail>
        <topicsfeed if={ route=="topicsfeed" }></topicsfeed>
        <profile name="profile" if={ route=="profile" }></profile>
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
    self.group = this.opts.group

    self.route   = "home"

    this.on("mount", function(){
      $('#signupSuccess').hide()
      $('#loginSuccess').hide()
    })

    var r = riot.route.create()
    r('#',       home       )
    r('post',   home      )
    r('post/*', postdetail)
    r('topics',  topics )
    r('schedule',  topics )
    r('schedule/*', topicsfeed)
    r('profile', profile)
    r(           home       ) // `notfound` would be nicer!

    function home() {
      self.track('home')
      self.update({
        title:  "Welcome to Sophus!",
        body:  "This is the feed!",
        route: "posts",
        selectedId: null,
      })
      self.tags.feed.init()
    }
    function postdetail(id) {
      self.tags.postdetail.unmount()
      self.track('postdetail')
      self.update({
        title: "",
        body: "",
        selectedId: id,
        route: "postdetail"
      })
      riot.mount('postdetail', {postid: id})
    }
    function topics() {
      self.track('topics')
      self.update({
        title: "Trending Topics",
        body: "",
        selectedId: null,
        route: "schedule"
      })
    }
    function topicsfeed(id) {
      self.tags.topicsfeed.unmount()
      self.track('topicsfeed')
      self.update({
        title: "",
        body: "",
        selectedId: null,
        selectedTopicId: id,
        route: "topicsfeed"
      })
      riot.mount('topicsfeed', {topicName: id})
    }
    function profile() {
      self.track('profile')
      self.tags.profile.updateInfo()
      self.update({
        title: "",
        body: "",
        selectedId: null,
        route: "profile"
      })
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
    margin-top: 20px;
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

