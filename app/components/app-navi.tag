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
    </ul>



    <!-- <form class="form-inline pull-xs-right">
      <input class="form-control" type="text" placeholder="Search">
      <button class="btn btn-success-outline" type="submit">Search</button>
    </form> -->
  </div>
</nav> <!-- /navbar -->




<script>
  var self = this

  this.links = [
  { name: "Home", url: "post" },
  { name: "Topics", url: "topics" },
  //{ name: "Login", url: "login" }
  ]

  var r = riot.route.create()
  r(highlightCurrent)


  function highlightCurrent(id) {
    self.selectedId = id
    self.update()
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