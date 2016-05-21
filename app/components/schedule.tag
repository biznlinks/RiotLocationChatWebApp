<topics>
	<div each={schedule.sessions} class="card">
		<a  href="/topics/{ title }">
		<div class="card-block">
			<h4 class="card-title">{title}</h4>
			<p class="card-text">{time}</p>
		</div>
		</a>
		<ul class="list-group list-group-flush">
			<li each={talks} class="list-group-item">
			<a  href="/topics/{ title }">
				{title} <br> <p class="text-muted authors">{authors}</p>
				</a>
			</li>
		</ul>
	</div>
	<script>
		var self = this
		topicstag = this
		this.topics = []

		this.on('mount', function() {
			self.schedule = Group.get('details').schedule
			self.update()
		})

		showTopic(e){
			console.log(e.item.title);
		}

	</script>

	<style scoped>
		.authors{
			font-size: small;
		}
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