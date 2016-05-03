<postDetail>

	<div class="well">
			{opts.post.content}
	</div>

	<script>
		var self = this
		this.post = {}

		this.on('update', function() {
			this.getpost()
		})

		getpost() {
			var promise = new Parse.Promise();
			var query = new Parse.Query(Post);
			query.descending('createdAt');
			query.limit(20);
			query.find().then(function(results) {
				self.post =  _.map(results, function(res){
					res.content = res.get('content')
					return res
				} )
				self.update()
			},
			function() {
			});
		}

	</script>

	<style scoped>
    a {
      display: block;
      background: #f7f7f7;
      text-decoration: none;
      width: 100%;
      height: 100%;
      /*line-height: 150px;*/
      color: inherit;
    }
    a:hover {
      background: #eee;
      color: #000;
    }

    ul {
      padding: 10px;
      list-style: none;
    }
    li {
      display: block;
      margin: 5px;
    }
   
    @media (min-width: 480px) {
      :scope {
        margin-right: 200px;
        margin-bottom: 0;
      }
    }
  </style>
</postDetail>