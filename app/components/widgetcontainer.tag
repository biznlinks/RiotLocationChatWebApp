<container>


  <div class="">
    <!-- <h1>{ title }</h1> -->

    <ask name="askModal"></ask>

    <div class="navigation">
      <ul class="nav nav-tabs" role="tablist">
        <li class="nav-item">
          <a class={ nav-link: true, active: sophusTab } href="" onclick={ this.toggleTab }>
            <img class="app-icon" src="/images/app_icon.png"> Sophus
          </a>
        </li>
        <li class="nav-item">
          <a class={ nav-link: true, active: !sophusTab } href="" onclick={ this.toggleTab }>
            <img class="twitter-icon" src="/images/twitter_logo.png"> Twitter
          </a>
        </li>
      </ul>
    </div>

    <div class="row">
      <div class="main col-md-10 col-md-offset-1 col-lg-8 col-lg-offset-2  text-center">
        <posts if={ sophusTab }></posts>
        <twitter if={ !sophusTab }></twitter>
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

    self.sophusTab = true

    this.on("mount", function(){
      $('#signupSuccess').hide()
      $('#loginSuccess').hide()
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

    toggleTab() {
      self.sophusTab = !self.sophusTab
      self.update()
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
      padding-top: 12px;
      background-color: #DBDBDB;
    }

    .nav-tabs .nav-link {
      padding: 0.4em;
    }

    .app-icon {
      width: 25px;
      height: 25px;
      margin-bottom: 2px;
    }

    .twitter-icon {
      width: 26px;
      height: 26px;
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

