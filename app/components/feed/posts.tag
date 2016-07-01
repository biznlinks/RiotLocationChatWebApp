<posts>
	<div if={loading} class="loader-container">
		<i class="fa fa-spinner fa-spin fa-3x fa-fw margin-bottom"></i>
		<span class="sr-only">Loading...</span>
	</div>
	<div if={this.posts.length==0 && profile!=true} class="zero-post">
		Be the first to post
	</div>
	<div if={this.posts.length==0 && profile==true} class="zero-post">
		No posts yet
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

		.loader-container {
			text-align: center;
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
			/*color: inherit;*/

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
		div.postitem:last-child {
			margin-bottom: 16px;
		}


		@media (min-width: 480px) {
			:scope {
				/*margin-right: 200px;*/
				margin-bottom: 0;
			}
		}
	</style>
</posts>