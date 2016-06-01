<topics>

<div class="schedule-container">
	<div class="bd-example bd-example-tabs" role="tabpanel">
	  <ul class="nav nav-tabs" id="myTab" role="tablist">

	    <li class="nav-item" each={day in days}>
	      <a class= {"nav-link": true, "active": (day===activeDay)} id="home-tab" name={day} onclick={selectActiveDay}>{day}</a>
	    </li>
	  </ul>

	<div class="row session" each={sessions}>
		<div class="col-xs-3 session-hour">
			<h4 class="session-h4">{hour}</h4>
		</div>
		<div class="col-xs-9 session-detail">
			<a  class="session-title" href="/schedule/{ title }">
				<h4 class="session-h4">{title}</h4>
			</a>

			<div class="talk-container">
				<li each={talks} class="talk list-group-item">
					<a href="/schedule/{ title }">
					{title} <br>
					</a>
				</li>
			</div>

		</div>
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
		.schedule-container {
			background: white;
			padding: 10px;
		}

		#myTab {
			border: none;
		}

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
			border-top: 1px solid #b3b3b3;
		}

		.session-hour {
			padding: 30px 10px;
		}

		.session-detail {
			padding: 30px 0px;
		}

		.session-detail:hover {
			background: #dedede;
		}

		.session-detail:hover .session-title {
			color: black;
			text-decoration: none;
			background: #dedede;
		}

		.session-title {
			padding-left: 20px;
			padding-bottom: 30px;
		}

		.session-h4 {
			margin-bottom: 0;
		}

		.talk-container {
			margin-bottom: -30px;
		}

		.talk {
			border: none;
			border-top: 1px solid #b3b3b3;
		}

		.talk:hover {
			background: #eeeeee;
		}

		.talk:hover a {
			color: black;
			text-decoration: none;
			background: #eeeeee;
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
			color: #000;
			text-decoration: none;
		}

		ul {
			padding: 10px;
			list-style: none;
		}
		li {
			display: block;
		}

		@media (min-width: 480px) {
			:scope {
				margin-right: 200px;
				margin-bottom: 0;
			}
		}
		.nav-link {
			padding: 0.5em !important;
		}
	</style>
</topics>