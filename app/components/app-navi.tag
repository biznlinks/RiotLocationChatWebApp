<app-navi>

<nav class={navbar-gradient: home, navbar-nongradient: !home, navbar: true, navbar-static-top: containerTag.route!='groups', navbar-fixed-top: containerTag.route=='groups'}>
  <!-- <button class="navbar-toggler pull-xs-right hidden-sm-up" type="button" data-toggle="collapse" data-target="#exCollapsingNavbar2">
    &#9776;
  </button> -->
  <div class="navbar-toggleable-xs" id="exCollapsingNavbar2">
    <div class="navbar-brand"> <a href="/groups"><img id="logo" alt="Logo" src="/images/app_icon.png" ></a>  { title }</div>

    <ul class="nav navbar-nav pull-xs-right">
      <!-- <li class={ nav-item: true, active: parent.selectedId === url }>
        <a class="nav-icon nav-link" onclick={ this.showSearch }><i class="fa fa-search fa-4"></i></a>
      </li>
      <li class={ nav-item: true, active: parent.selectedId === url }>
        <a class="nav-icon nav-link" onclick={ this.gotoSchedule }><i class="fa fa-calendar fa-4"></i></a>
      </li> -->

      <li class={ nav-item: true } onclick={ this.update }>
        <div class="btn-group profile-container">
          <img src={ API.getCurrentUserProfilePicture() } class="img-circle dropdown-toggle profile-img pointer" data-toggle="dropdown"/>
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
            <li class="dropdown-item" onclick={ this.sendfeedback }>
              <a class="nav-link" href="#">Feedback</a>
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
  var self         = this
  self.signupAvail = true
  self.home        = true
  self.title       = opts.title

  var r = riot.route.create()
  r(highlightCurrent)


  function highlightCurrent(id) {
    self.selectedId = id
    self.update()
  }

  sendfeedback(){
    window.location.href = "mailto:team@sophusapp.com"
  }

  this.on('update', function() {
    self.signupAvail = !Parse.User.current() || Parse.User.current().get('type') === 'dummy'

    if (self.parent.route == 'posts') self.home = true
    else self.home = false
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

  showSearch() {
    $('#searchModal').modal('show')
  }

  gotoSchedule() {
    riot.route('schedule')
    self.update()
  }

  gotoProfile() {
    riot.route('profile')
    self.update()
  }

  logout() {
    Parse.User.logOut()
    self.update()
    riot.route('')
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

  .navbar-gradient {
    background: -webkit-linear-gradient(rgba(0,0,0,0.9), rgba(0,0,0,0));
    background: -o-linear-gradient(rgba(0,0,0,0.9), rgba(0,0,0,0));
    background: -moz-linear-gradient(rgba(0,0,0,0.9), rgba(0,0,0,0));
    background: linear-gradient(rgba(0,0,0,0.9), rgba(0,0,0,0));
  }

  .navbar-nongradient {
    background: rgba(0,0,0,0.9);
  }

  .navbar{
    /*position: absolute;*/
/*    top: 0px;
    width: 100%;
    left: 0px;
    -webkit-border-radius: 0;
    -moz-border-radius: 0;*/
    border-radius: 0;
  }

  .navbar-brand {
    color: white;
  }

  .nav {
    padding-top: 0.4rem;
  }

  .navbar-nav .nav-link {
    padding-top: .1rem;
    padding-bottom: 0;
  }

  .nav-icon {
    font-size: large;
    color: white;
  }

  .profile-img{
    width: 30px;
    height: 30px;
  }

  .dropdown-item {
    padding-top: .425rem;
    padding-bottom: .425rem;
    color: #EEEEEE;
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