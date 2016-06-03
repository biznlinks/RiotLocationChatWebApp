<posts>
	<div if={loading}>
		<span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span> Loading...
	</div>
	<div if={this.posts.length==0 && profile!=true} class="zero-post">
		Be the first to post
	</div>
	<div if={this.posts.length==0 && profile==true} class="zero-post">
		No posts yet
	</div>
	</div>
	<div if={ !loading }>
		<div class="postitem" each={ post in posts }>
			<postitem post={post}></postitem>
		</div>
	</div>


	<script>
		var self = this
		postsTag = this
		self.profile = opts.profile
		this.posts = opts.posts
		this.postsVisible = true
		this.loading = false




	</script>

	<style scoped>
		:scope{
			/*font-family: Source Sans Pro,sans-serif;*/
			/*font-weight: 300;*/
			/*font-size: 24px;*/


		}

		.zero-post {
			padding-top: 150px;
			text-align: center;
			font-size: 30px;
			font-weight: 600;
			color: #bbb;
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