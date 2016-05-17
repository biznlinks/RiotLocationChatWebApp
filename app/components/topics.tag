<topics>
	<ul class="list-group list-group-flush">
		<div class="card" each={topics}>
			<a  href="/topics/{ topic }">
				<li class="list-group-item"><span class="topic-type"></span> <span class="">{topic}</span> <span class="score">{count}</span></li>
			</a>
		</div>
	</ul>

	

	<script>
		var self = this
		topicstag = this
		this.topics = []

		this.on('mount', function() {
			this.gettopics()
		})

		gettopics() {
			Parse.Cloud.run("constructTopics").then(function(res) { 
				self.topics = res
				self.update()
			})
		}

	</script>

	<style scoped>
		.score {
			float: right;
		}
		.cardtitle {
			float: left;
		}
		.topic-type{
			font-size: small;
		}

		a {
			display: block;
			background: #f7f7f7;
			text-decoration: none;
			width: 100%;
			height: 100%;
			/*line-height: 150px;*/
			color: inherit;
		}
		a:hover {
			background: #eee;
			color: #000;
		}

		ul {
			padding: 10px;
			list-style: none;
		}
		li {
			display: block;
			margin: 5px;
		}

		@media (min-width: 480px) {
			:scope {
				margin-right: 200px;
				margin-bottom: 0;
			}
		}
	</style>
</topics>