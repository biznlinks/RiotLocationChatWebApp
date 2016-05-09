
<feed>
	<div class="">
		<div class="row welcome">
			<div class="text-xs-center">
			<h4 class="card-title">Welcome to the CHI'16 community!</h4>
			<p class="card-text">Ask and Answer the people at CHI</p>
		
			<search></search>
		</div>
		
    
    </div>

	<posts name="homeFeedPosts"></posts>
	</div>
	
	<script>
	var self = this
	self.postsTag = this.tags.homeFeedPosts

		this.on('mount', function() {
			self.postsTag.update({loading:true})
			API.getallposts().then(function(results){
				self.postsTag.update({posts:results, loading:false})
			})
		})

		

	</script>
	<style scoped>
	.welcome {
		margin-bottom: 20px
	}
	</style>
</feed>