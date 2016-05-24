<app-navi>

<nav class="navbar navbar-light bg-faded navbar-static-top">
  <!-- <button class="navbar-toggler pull-xs-right hidden-sm-up" type="button" data-toggle="collapse" data-target="#exCollapsingNavbar2">
    &#9776;
  </button> -->
  <div class="navbar-toggleable-xs" id="exCollapsingNavbar2">
    <a class="navbar-brand" href="/"> <img id="logo" alt="Logo" src="/images/app_icon.png" > SOPHUS </a>

    <ul class="nav navbar-nav pull-xs-right">
      <li class={ nav-item: true, active: parent.selectedId === url } each= {links}>
        <a class="nav-link" href="/{ url }" >{name}</a>
      </li>
      <li class={ nav-item: true } onclick={ this.update }>
        <div class="btn-group">
          <img src={ this.getProfilePic() } class="img-circle dropdown-toggle profile-img pointer" data-toggle="dropdown"/>
          <ul class="dropdown-menu dropdown-menu-right">
            <li class="dropdown-item" if={ signupAvail } onclick={ this.showLogin }>
              <a class="nav-link" href="#">Log In</a>
            </li>
            <li class="dropdown-item" if={ signupAvail } onclick={ this.showSignup }>
              <a class="nav-link" href="#">Sign Up</a>
            </li>
            <li class="dropdown-item" if={ !signupAvail }>
              <a class="nav-link" href="#" onclick={ this.gotoProfile }>Profile</a>
            </li>
            <li class="dropdown-item" if={ !signupAvail } onclick={ this.logout }>
              <a class="nav-link" href="#">Logout</a>
            </li>
          </ul>
        </div>
      </li>
    </ul>



    <!-- <form class="form-inline pull-xs-right">
      <input class="form-control" type="text" placeholder="Search">
      <button class="btn btn-success-outline" type="submit">Search</button>
    </form> -->
  </div>
</nav> <!-- /navbar -->




<script>
  var self = this
  self.signupAvail = true

  this.links = [
  { name: "Home", url: "post" },
  { name: "Schedule", url: "topics" }
  ]

  var r = riot.route.create()
  r(highlightCurrent)


  function highlightCurrent(id) {
    self.selectedId = id
    self.update()
  }

  this.on('update', function() {
    self.signupAvail = !Parse.User.current() || Parse.User.current().get('type') === 'dummy'
  })

  getProfilePic(){
    var user = Parse.User.current()
    var profilePic = user.get('profileImageURL')
    if (profilePic){
      return profilePic
    }
  }

  showSignup() {
    $('#signupModal').modal('show')
  }

  showLogin() {
    $('#loginModal').modal('show')
  }

  gotoProfile() {
    riot.route('/profile')
  }

  logout() {
    Parse.User.logOut()
    self.update()
    riot.route('/')
    window.location.reload()
  }
</script>

<style scoped>
  :scope {
    display: block;
    font-family: sans-serif;
    /*margin-right: 0;*/
    /*margin-bottom: 30px;*/
    /*margin-left: 50px;*/
    /*padding: 1em;*/
    /*text-align: center;*/
    color: #666;

  }

  .navbar{
    position: absolute;
    top: 0px;
    width: 100%;
    left: 0px;
  }

  .profile-img{
    width: 35px;
    height: 35px;
  }

  .pointer:hover {
    cursor: pointer;
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
  }

  #logo {
    height: 35px;
    display: inline-block;

  }


  @media (min-width: 480px) {
    :scope {
      /*margin-right: 200px;*/
      margin-bottom: 0;
    }
  }
</style>

</app-navi>