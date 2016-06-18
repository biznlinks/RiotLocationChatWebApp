<feed>
<div id="feed-background" onmouseover={ enableScroll } onmouseout={ disableScroll }>
	<div class="postfeed">
		<postbar></postbar>

		<div class="update-feed" if={ newPost } onclick={ this.updateFeed }>
			Update feed
		</div>

		<posts name="homeFeedPosts"></posts>
	</div>
</div>

<script>
	var self         = this
	homefeedTag      = this
	self.searchFocus = false
	self.joined      = false
	self.newPost     = false

	self.postsTag = this.tags.homeFeedPosts


	this.on('mount', function() {
		askModalTag.on("posted", function(){
			self.init()
		})
		self.init()
	})

	init(){
		self.newPost = false
		self.update()
		self.postsTag.update({loading:true})
		//self.tags.search.init()
		API.getallposts(20).then(function(results){
			self.currentPosts = results
			self.postsTag.update({posts:results, loading:false})

			self.latestUpdate = new Date()
			self.checkUpdate = setInterval(function() {
				self.checkNewPosts()
			}, 15000)
		})
	}

	checkNewPosts() {
		API.getallposts(20).then(function(results){
			results = results.filter(function(result) {
				if (Date.parse(result.get('createdAt')) - Date.parse(self.latestUpdate) > 0) return true
				else false
			})
			if (results.length > 0) {
				self.newPost = true
				self.updatedPosts = results
			}
			self.update()
		})
	}

	updateFeed() {
		for (var i = 0; i < self.updatedPosts.length; i++) self.currentPosts.push(self.updatedPosts[i])
		console.log(self.currentPosts)
		self.postsTag.update({posts: self.currentPosts, loading: false})
		self.latestUpdate = new Date()
		self.newPost = false
		self.update()
	}

	enableScroll() {
		$('body').css('overflow', 'hidden')
		$('#feed-background').css('overflow-y', 'auto')
	}

	disableScroll() {
		$('#feed-background').css('overflow-y', 'hidden')
		$('body').css('overflow', 'auto')
	}

	onsearchclick(){
		askModalTag.show()
	}

	onSearchFocus(){
		this.searchFocus = true
		self.update()
	}

</script>
<style scoped>
	#feed-background {
		height: 600px;
		overflow-y: hidden;
	}

	.postfeed{
	margin: 15px auto;
	max-width: 700px;
	}

	.update-feed {
		text-align: center;
		padding: 10px;
		background-color: #039be5;
		color: white;
		font-size: large;
	}

	@media screen and (max-width: 550px) {
		#feed-background {
			overflow-y: auto;
		}
	}
</style>
</feed>