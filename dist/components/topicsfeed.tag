
<topicsfeed>
	<div class="card">
		<img class="card-img-top" src="{this.getTopicImage()}" alt="Card image cap"></img>
		<div class="card-block">
			<h4 class="card-title">#{topicName}</h4>
			<p class="card-text"></p>
			<p class="card-text"><small class="text-muted">{postCount} questions for this topic</small></p>
		</div>
	</div>
	<posts name="topicsFeedPosts"></posts>


	<script>
		var self = this
		topicsfeedtag = this
		self.postsTag = this.tags.topicsFeedPosts
		self.topicName = decodeURI(this.opts.topicName)
		self.postCount = 0
		// self.topicName = decodeURI(this.parent.selectedTopicId)

		this.on('mount', function() {
			console.log("updating "+ self.topicName);
			this.fetchTopicDetails()
			self.postsTag.update({loading:true})
			if (self.topicName){
				self.topicName = decodeURI(self.topicName)
				API.constructQuestionsForTopics(self.topicName).then(function(results) { 
					self.update({postCount: results.length})
					self.postsTag.update({posts:results, loading:false})
				})
			}
		})

		getTopicImage(){
			if (!self.topic || !self.topic.get('image')){
				return '\\\\files.parsetfss.com/492fed6a-4a8e-4a1f-9286-b7ca075fbe93/tfss-b90ff825-9002-4feb-bc90-315dbc0bbf24-Pasted%20image%20at%202016_05_17%2001_46%20PM.png'
				
			}
			return self.topic.get('image').url()
			// else

		}

		// load information about the topic like picture/ video/ description/ etc
		fetchTopicDetails() {
			if (self.topicName){
				self.topicName = decodeURI(self.topicName)
				API.getObjectForTopic(self.topicName.toLowerCase()).then(function(topic){
					self.topic = topic
					self.update()
				})
			}
			
		}

	</script>

	<style scoped>
		.card-img-top{
			width: 100%;
		}
	</style>
</topicsfeed>