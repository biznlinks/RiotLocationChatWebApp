<posts>
	<div if={loading}>
		<span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span> Loading...
	</div>
	<div if={this.posts.length==0 }>
		No one has asked yet.
	</div>

	<div if={!loading}>
		<div class="post-item" each={ post in posts }>
			<postitem post={ post }></postitem>
		</div>
	</div>


<script>
	var self = this
	self.loading = opts.loading
	self.posts = opts.posts

	this.on('mount', function() {
		API.getallposts(20).then(function(results){
			self.update({posts:results, loading:false})
		})
	})
</script>
<style scoped>
</style>
</posts>