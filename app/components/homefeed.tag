
<feed>
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