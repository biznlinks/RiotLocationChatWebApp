
<feed>
	<ask></ask>
	<div class="">
		<div if={!searchFocus} class="row welcome">
			<div class="text-xs-center">
				<h4 class="card-title">Welcome to the CHI'16 community!</h4>
				<p class="card-text">Ask and Answer the people at CHI</p>

				<!-- <button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#askModal">Ask a new Question</button> -->
			</div>


		</div>
		<div>
			<search></search>
		</div>

		<posts name="homeFeedPosts"></posts>
	</div>
	
	<script>
		var self = this
		homefeedTag = this
		self.searchFocus = false

		self.postsTag = this.tags.homeFeedPosts

		init(){
			self.postsTag.update({loading:true})
			self.tags.search.init()
			API.getallposts(20).then(function(results){
				self.postsTag.update({posts:results, loading:false})
			})
		}

		this.on('mount', function() {
			self.init()
		})

		onsearchclick(){
			$('#askModal').modal('show')
		}

		onSearchFocus(){
			console.log("hereonfocus");
			this.searchFocus = true
			self.update()
		}

	</script>
	<style scoped>
		.welcome {
			margin-bottom: 20px
		}
	</style>
</feed>