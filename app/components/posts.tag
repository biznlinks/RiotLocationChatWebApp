<posts>
	<div if={this.posts.length==0 || !postsVisible}>
		<span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span> Loading...
	</div>
	<div if={ postsVisible }>
		<div each={ post in posts }>
			<postitem post={post}></postitem>
		</div>
	</div>
	

	<script>
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

        getAnswerForPost(post){
        	API.getanswersforpost(post).then(function(answers){
        		post.postAnswer = answers[0].content
        		self.update()

        	})
        }

		getAuthorName(post) {
			if (post.get('anonymous'))
				return 'anonymous'
			else 
				return post.get('author').get('firstName') + ' ' + post.get('author').get('lastName')
		}
	</script>

	<style scoped>
	:scope{
		    font-family: Source Sans Pro,sans-serif;
    font-weight: 300;
    font-size: 24px;
    line-height: 1.2;
	}
		a {
			display: block;
			text-decoration: none;
			width: 100%;
			height: 100%;
			/*line-height: 150px;*/
			color: inherit;

		}
		a:hover {
			background: #eee;
			color: #000;
			text-decoration: none;
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
	</style>
</posts>