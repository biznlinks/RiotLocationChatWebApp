<app-navi>

  
   <!-- Navigation -->
        <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
            <div class="container">
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="/">Sophus</a>
                </div>
                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">
                    <li each= { links }>
                       <a  href="/{ url }" class={ selected: parent.selectedId === url }>
                        { name }
                      </a>
                    </li>
                    </ul>
                </div>
                <!-- /.navbar-collapse -->
            </div>
            <!-- /.container -->
        </nav>

  
  
  <script>
    var self = this

    this.links = [
      { name: "Posts", url: "post" },
      { name: "Topics", url: "topics" },
      { name: "SignUp", url: "login" }
    ]

    var r = riot.route.create()
    r(highlightCurrent)

    var plunkrRandomUrl = location.pathname.replace(new RegExp('/', 'g'), '')

    function highlightCurrent(id) {
      // Plunker confuses routing initially
      if ( plunkrRandomUrl == id ) { id = '' }
      
      self.selectedId = id
      self.update()
    }
  </script>

  <style scoped>
    :scope {
      position: fixed;
      top: 0;
      left: 0;
      height: 50px;
      box-sizing: border-box;
      font-family: sans-serif;
      text-align: center;
      color: #666;
      background: #333;
      width: 0px;
      transition: height .2s;
    }
    :scope:hover {
      height: 60px;
    }
    a {
      display: block;
      box-sizing: border-box;
      /*width: 100%;*/
      height: 50px;
      line-height: 50px;
      padding: 0 .8em;
      color: white;
      text-decoration: none;
      background: #444;
    }
    a:hover {
      background: #666;
    }
    a.selected {
      background: teal;
    }
  </style>

</app-navi>