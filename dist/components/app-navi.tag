<app-navi> <div class=container> <div class=row> <div class="col-lg-6 col-md-offset-3 text-center"> <nav class="navbar navbar-light bg-faded navbar-fixed-top">  <div class=navbar-toggleable-xs id=exCollapsingNavbar2> <a class=navbar-brand href="/"> <img id=logo alt=Logo src=/images/app_icon.png>CHI'16</a> <ul class="nav navbar-nav pull-xs-right"> <li class={ nav-item: true, active: parent.selectedid="==" url } each={links}> <a class=nav-link href="/{ url }">{name}</a> </li> </ul>  </div> </nav>  </div> </div> <script>
  var self = this

  this.links = [
  { name: "Posts", url: "post" },
  { name: "Topics", url: "topics" },
  { name: "SignUp", url: "login" }
  ]

  var r = riot.route.create()
    r(highlightCurrent)


    function highlightCurrent(id) {
      self.selectedId = id
      self.update()
    }
  </script> <style scoped>
    :scope {
      display: block;
      font-family: sans-serif;
      /*margin-right: 0;*/
      margin-bottom: 30px;
      /*margin-left: 50px;*/
      /*padding: 1em;*/
      /*text-align: center;*/
      color: #666;

    }

    #logo {
      height: 50px
    }
    
   
    @media (min-width: 480px) {
      :scope {
        /*margin-right: 200px;*/
        margin-bottom: 0;
      }
    }
  </style> </div></app-navi>