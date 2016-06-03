<feed>

	<div class="postfeed">
		<div>
			<postbar></postbar>
		</div>

		<posts name="homeFeedPosts"></posts>
	</div>

	<script>
		var self = this
		homefeedTag = this
		self.searchFocus = false

		self.postsTag = this.tags.homeFeedPosts

		self.timer = setInterval(function(){ self.reloadTimer() }, 3000);

		reloadTimer() {
		    API.getallposts(20).then(function(results){
		    	if (self.postsTag.posts.length!=results.length){
		    		self.postsTag.update({posts:results, loading:false})
		    	}
			})
		}

		init(){
			self.postsTag.update({loading:true})
			//self.tags.search.init()
			API.getallposts(20).then(function(results){
				self.postsTag.update({posts:results, loading:false})
			})
		}

		this.on('mount', function() {
			askModalTag.on("posted", function(){
				self.init()
			})
			self.init()
		})

		onsearchclick(){
			askModalTag.show()
		}

		onSearchFocus(){
			this.searchFocus = true
			self.update()
		}

	</script>
	<style scoped>
	.postfeed{
    margin-top: 15px;
  }
	</style>
</feed>