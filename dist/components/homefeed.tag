
<feed>
	<div class="card card-block text-xs-center">
	<h4 class="card-title">Welcome to the Sophus CHI'16 community!</h4>
	<p class="card-text">Ask and Answer the people at CHI</p>
    <search></search>
    </div>

	<posts name="homeFeedPosts"></posts>
	<script>
	var self = this
	self.postsTag = this.tags.homeFeedPosts

		this.on('mount', function() {
			API.getallposts().then(function(results){
				self.postsTag.update({posts:results})
			})
		})

		

	</script>
</feed>