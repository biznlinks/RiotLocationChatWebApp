<topics>

<div class="bd-example bd-example-tabs" role="tabpanel">
  <ul class="nav nav-tabs" id="myTab" role="tablist">
    
    <li class="nav-item" each={day in days}>
      <a class= {"nav-link": true, "active": (day===activeDay)} id="home-tab" name={day} onclick={selectActiveDay}>{day}</a>
    </li>   
  </ul>
 
	<div class="row session" each={sessions}>
		<div class="col-xs-3">
			<h4 class="card-title">{hour}</h4>
		</div>
		<div class="col-xs-9">
			<a  href="/schedule/{ title }">
			<h4 class="card-title">{title}</h4>
			</a>
			
			<li each={talks} class="list-group-item">
			<a  href="/schedule/{ title }">
				{title} <br> <p class="text-muted authors">{authors}</p>
				</a>
			</li>
		
		</div>
	</div>
	
	<script>
		var self = this
		topicstag = this
		this.schedule = []

		selectActiveDay(e){
			console.log(e.item.day);
			self.activeDay = e.item.day
			self.updateSessionsForActiveDay()

		}

		this.on('mount', function() {
			self.schedule = containerTag.group.get('details').schedule
			
			self.days = _.uniq(_.pluck(self.schedule.sessions, 'day'))

			self.activeDay = self.days[0]

			self.updateSessionsForActiveDay()


			// Date(topicstag.schedule.sessions[0].starttime)
			self.update()
		})

		updateSessionsForActiveDay(){
			self.sessions = _.filter(self.schedule.sessions, function(session){
				if (session.day===self.activeDay)
					return true
			})

		}

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

		.session {
			padding: 10px;
		}

		a {
			display: block;
			/*background: #f7f7f7;*/
			text-decoration: none;
			width: 100%;
			height: 100%;
			/*line-height: 150px;*/
			color: inherit;

		}

		a:hover {
			background: #eee;
			color: #000;
			text-decoration: none;
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