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
  <app-navi name="appNavi"></app-navi>
  <!-- Page Content -->
  <div class="">
    <!-- <h1>{ title }</h1> -->

    <signup name="signupModal"></signup>
    <login name="loginModal"></login>
    <forgot name="forgotModal"></forgot>
    <ask name="askModal"></ask>
    <search name="searchModal"></search>
    <creategroup name="creategroupModal"></creategroup>
    <loginsuccess name="loginSuccess"></loginsuccess>
    <signupsuccess name="signupSuccess"></signupsuccess>

    <banner if={ route=="posts" }></banner>
    <div class="">
      <div class="main col-md-10 col-md-offset-1 col-lg-8 col-lg-offset-2 text-center">
        <feed if={ route=="posts" }></feed>
        <topics if={ route=="schedule" || route=="live" }></topics>
        <postdetail if={ route=="postdetail" }></postdetail>
        <profile name="profile" if={ route=="profile" }></profile>
        <groups name="groups" if={ route=="groups" }></groups>
        <groupinfo name="groupinfo" if={ route=="groupinfo"}></groupinfo>
      </div>

      <topicsfeed if={ route=="topicsfeed" }></topicsfeed>
    </div>

    <!-- /.row -->
  </div>
  <!-- /.container -->

  <script>
    var self     = this
    containerTag = this
    self.title   = 'Now loading...'
    self.body    = ''
    self.group   = this.opts.group

    self.route   = "home"

    this.on("mount", function(){
      $('#signupSuccess').hide()
      $('#loginSuccess').hide()
    })

    var r = riot.route.create()
    r('#',       home       )
    r('groups',  groups)
    r('group/*', groupinfo)
    r('post/*', postdetail)
    r('topics',  topics )
    r('live/*',  live )
    r('schedule',  topics )
    r('schedule/*', topicsfeed)
    r('profile', profile)
    r(home)

    function home(id) {
      id = decodeURI(id)
      if (id == '' || id == 'groups') {
        groups()
      } else if (self.group) {
        feed()
      } else {
        API.fetchOne('Group', 'groupId', id).then(function(results) {
          self.group = results
          feed()
        }, function(err) {
          console.log('notfound')
        })
      }
    }
    function groups() {
      self.track('home')
      self.update({
        title: USER_LOCALE,
        body: "",
        route: "groups",
        selectedId: null
      })
      self.tags.groups.init()
      self.toTop()
    }
    function groupinfo(id) {
      if (!self.group) {
        API.fetchOne('Group', 'groupId', id).then(function(results) {
          self.group = results
          self.track('groupinfo')
          self.update({
            title: self.group.get('name'),
            body: "",
            route: "groupinfo",
            selectedId: null
          })
          self.tags.groupinfo.init()
          self.toTop()
        }, function(err) {
          console.log('notfound')
          return null
        })
      } else {
        self.track('groupinfo')
        self.update({
          title: self.group.get('name'),
          body: "",
          route: "groupinfo",
          selectedId: null
        })
        self.tags.groupinfo.init()
        self.toTop()
      }
    }
    function feed() {
      self.track('feed')
      self.update({
        title: "",
        body:  "This is the feed!",
        route: "posts",
        selectedId: null
      })
      self.tags.banner.init()
      self.tags.feed.init()
      self.toTop()
    }
    function postdetail(id) {
      self.track('postdetail')
      self.update({
        title: "SOPHUS",
        body: "",
        selectedId: id,
        route: "postdetail"
      })
      self.tags.postdetail.update({postid: id})
      self.tags.postdetail.init()
      self.toTop()
    }
    function topics() {
      self.track('topics')
      self.update({
        title: "SCHEDULE",
        body: "",
        selectedId: null,
        route: "schedule"
      })
      self.tags.topics.init()
      self.toTop()
    }
    function live(id) {
      self.track('live')
      self.update({
        title: "LIVE",
        body: "",
        selectedId: null,
        route: "live"
      })
      self.tags.topics.live(id)
      self.toTop()
    }
    function topicsfeed(id) {
      self.tags.topicsfeed.unmount()
      self.track('topicsfeed')
      self.update({
        title: "TOPIC",
        body: "",
        selectedId: null,
        selectedTopicId: id,
        route: "topicsfeed"
      })
      riot.mount('topicsfeed', {topicName: id})
      self.toTop()
    }
    function profile() {
      self.track('profile')
      self.tags.profile.updateInfo()
      self.update({
        title: "PROFILE",
        body: "",
        selectedId: null,
        route: "profile"
      })
      self.toTop()
    }

    requestLocation() {
      if (Navigatior.geolocation) {
        console.log('enabled')
      } else {
        console.log('disabled')
      }
    }

    toTop() {
      window.scrollTo(0,0)
    }

</script>

<style scoped>
  :scope {
    display: block;
    font-family: sans-serif;
    color: #666;


  }

  .main {
    padding-right: 0px;
    padding-left: 0px;
  }

  .card {
    border-radius: 0px;
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

