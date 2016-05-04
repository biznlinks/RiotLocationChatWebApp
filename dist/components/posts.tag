<posts> <div if="{this.posts.length==0" || !postsvisible}> <span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span> Loading... </div> <div if={ postsvisible }> <div each={ post in posts }> <a href="/post/{ post.id }"> <div class="card card-block">  <p class=card-text>{post.get('content')}</p> </div> </a> </div> </div> <script>
		var self = this
		postsTag = this
		this.posts = opts.posts
		this.postsVisible = true

		loader.on('start', function() {
                console.log('starting to load')
                self.postsVisible = false
                self.update()

            })
              loader.on('done', function() {
                console.log('done loading posts')
                self.postsVisible = true
                self.update()
            })

		getAuthorName(post) {
			if (post.get('anonymous'))
				return 'anonymous'
			else 
				return post.get('author').get('firstName') + ' ' + post.get('author').get('lastName')
		}
	</script> <style scoped>
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
				/*margin-right: 200px;*/
				margin-bottom: 0;
			}
		}
	</style> </posts>