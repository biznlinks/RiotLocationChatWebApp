<topicsfeed>
	<div class="card">
		<div class="card-block topic-title-container">
			<p class="card-title"><strong>{topicName}</strong></p>
			<p class="card-text">{talk.authors}</p>
			<!-- <p class="card-text"><small class="text-muted">{postCount} questions for this topic</small></p> -->


		</div>
	</div>

	<div class="row">
		<div class="main col-md-10 col-md-offset-1 col-lg-8 col-lg-offset-2 text-center">
			<postbar></postbar>
			<posts name="topicsFeedPosts"></posts>
	</div>

	<script>
		var self = this
		topicsfeedtag = this
		self.postsTag = this.tags.topicsFeedPosts
		self.topicName = decodeURI(this.opts.topicName)
		self.postCount = 0
		// self.topicName = decodeURI(this.parent.selectedTopicId)

		createQuestion(){
			console.log('creating a new question ');
			askModalTag.update({question: "", topic: self.topicName})
			askModalTag.show()
		}

		this.on('mount', function() {
			console.log("updating "+ self.topicName);
			this.fetchTopicDetails()
			self.postsTag.update({loading:true})
			self.loadTopics()
			askModalTag.on("posted", function(){
				self.loadTopics()
			})
		})

		loadTopics(){
			if (self.topicName){
				self.topicName = decodeURI(self.topicName)
				API.constructQuestionsForTopic(self.topicName).then(function(results) {
					self.update({postCount: results.length})
					self.postsTag.update({posts:results, loading:false})
				})
			}
		}

		getTopicImage(){
			if (!self.topic || !self.topic.get('image')){
				return '\\\\files.parsetfss.com/492fed6a-4a8e-4a1f-9286-b7ca075fbe93/tfss-b90ff825-9002-4feb-bc90-315dbc0bbf24-Pasted%20image%20at%202016_05_17%2001_46%20PM.png'

			}
			return self.topic.get('image').url()
			// else

		}

		// load information about the topic like picture/ video/ description/ etc
		fetchTopicDetails() {
			var schedule = containerTag.group.get('details').schedule
			self.talk = _.filter(_.flatten(_.pluck(schedule.sessions, 'talks')), function(talk){
				if (talk.title=== self.topicName){
					return true
				}
				return false
			})[0]


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
		.topic-title-container {
			text-align: center;
		}

		.main {
			margin-top: 0;
			padding-right: 0px;
			padding-left: 0px;
		}
	</style>
</topicsfeed>