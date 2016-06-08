<feed>

	<div class="postfeed">
		<div>
			<postbar></postbar>
		</div>
		<div class="join-group" if={ !joined } onclick={ this.submitJoin }>Join</div>
		<posts name="homeFeedPosts"></posts>
	</div>

<script>
	var self         = this
	homefeedTag      = this
	self.searchFocus = false
	self.joined      = false

	self.postsTag = this.tags.homeFeedPosts

	init(){
		self.postsTag.update({loading:true})
		//self.tags.search.init()
		API.getallposts(20).then(function(results){
			self.postsTag.update({posts:results, loading:false})
		})
		API.getUserGroups(Parse.User.current()).then(function(groups) {
			groups = groups.filter(function(group) { group == containerTag.group })
			if (groups.length == 0) self.joined = false
			else self.joined = true
			self.update()
		})
	}

	this.on('mount', function() {
		askModalTag.on("posted", function(){
			self.init()
		})
		self.init()
	})

	submitJoin() {
		var UserGroup = Parse.Object.extend('UserGroup')
		var userGroup = new UserGroup()
		userGroup.save({
			user: Parse.User.current(),
			group: containerTag.group
		},{
			success: function(userGroup) {
				self.joined = true
				self.update()
			},
			error: function(userGroup, error) {
				console.error("Error saving UserGroup " + error.message)
			}
		})
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
	.postfeed{
	margin-top: 15px;
	}

	.join-group {
		text-align: center;
		padding: 10px 20px;
		font-size: x-large;
		color: white;
		background: #00BFFF;
	}
</style>
</feed>