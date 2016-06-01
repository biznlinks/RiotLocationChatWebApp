<miniposts>
	<div if={loading}>
		<span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span> Loading...
	</div>
	<div if={this.posts.length==0 } class="zero-post">
		0 posts for this topic.
	</div>
	<div if={ !loading }>
		<div class="postitem" each={ post in posts }>
			<minipostitem post={post} author={author}></minipostitem>
		</div>
	</div>


	<script>
		var self = this
		postsTag = this
		this.posts = opts.posts
		this.author = opts.author
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
			padding-left: 10px;
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
</miniposts>