<banner>

<div class="banner-container">
	<div class="row" align="center">
		<div class="timer-container text-center">
			<div class="timer-background" if={ !live }>
				<div class="timer" name="timer">
					<span if={ days>0 }>{days}d</span>
					<span if={ days>0 || hours>0 }>{hours}h</span>
					<span if={ days>0 || hours>0 || minutes>0 }>{minutes}m</span>
					<span if={ days>0 || hours>0 || minutes>0 || seconds>0 }>{seconds}s</span>
				</div>
			</div>
			<div class="reminder-container" onclick={ this.showSignup } if={ !live && (Parse.User.current().get('type') == 'dummy' || !Parse.User.current()) }>
				<button class="reminder btn btn-primary"><i class="fa fa-star"></i>Stay Updated</button>
			</div>

			<div class="live-container text-center" if={ live }>
				<div class="live-text-container">
					<span class="fa fa-circle"></span><i class="live-text">Live</i>
				</div>

				<div class="live-session pointer" onclick={ this.gotoTopic }>
					{liveSession.title}
				</div>
			</div>
		</div>
	</div>

	<div class="row event-container">
			<div class="event-info text-center col-md-10 col-md-offset-1 col-lg-8 col-lg-offset-2">
					<div class="event-title">ICTD 2016</div>
					<div class="event-description" if={ open }>
						{containerTag.group.get('description')}
					</div>
					<!-- <div class="arrow pointer" onclick={ this.toggleOpen }>
						<div if={ open }><i class="fa fa-angle-up"></i></div>
						<div if={ !open }><i class="fa fa-angle-down"></i></div>
					</div> -->
			</div>
	</div>
</div>

<script>
	var self          = this
	self.live         = false
	self.open         = true
	self.days         = 0
	self.hours        = 0
	self.minutes      = 0
	self.seconds      = 0
	self.deadline   = '2016-06-03T09:00:00-04:00'
	self.liveSession  = null

	this.on('mount', function() {
		console.log(containerTag.group.get('details').schedule.sessions)
		if (Date.parse(self.deadline) - Date.parse(new Date()) > 0) {
			self.timeinterval = setInterval(function() {
				self.setRemainingTime(self.deadline)
				self.update()
			}, 1000)
		} else {
			self.timeinterval = setInterval(function() {
				self.setLiveSession()
				self.update()
			}, 1000)
			self.live = true
			self.update()
		}
	})

	setRemainingTime(deadline) {
		var t       = Date.parse(deadline) - Date.parse(new Date())
		var seconds = Math.floor( (t/1000) % 60 )
		var minutes = Math.floor( (t/1000/60) % 60 )
		var hours   = Math.floor( (t/(1000*60*60)) % 24 )
		var days    = Math.floor( t/(1000*60*60*24) )

		self.days    = days
		self.hours   = hours
		self.minutes = minutes
		self.seconds = seconds

		if (t <= 0) {
			clearInterval(self.timeinterval)
			self.mount()
		}
	}

	setLiveSession() {
		if (!self.live) return ''

		var sessions = containerTag.group.get('details').schedule.sessions
		for (var i = 0; i < sessions.length; i++) {
			var sessionStart = sessions[i].starttime
			var currentTime = new Date()

			sessionStart += "-04:00"

			if (Date.parse(sessionStart) - currentTime > 0) {
				self.liveSession = sessions[i-1]
				return
			}
		}
	}

	toggleOpen() {
		self.open = !self.open
		self.update()
	}

	showSignup() {
		self.parent.tags.signupModal.update({stayUpdated: true})
		$('#signupModal').modal('show')
	}

	gotoTopic() {
		var routeTo = '/schedule/' + encodeURIComponent(self.liveSession.title)
		riot.route(routeTo)
		self.update()
	}

</script>

<style scoped>
	.banner-container {
		margin-top: -50px;
	}

	.timer-container {
		background-image: url('/images/annarbor.jpg');
		height: 220px;
		background-size: cover;
    	background-repeat: no-repeat;
    	background-position: 50% 50%;
	}

	.timer-background {
		background: rgba(0,0,0,0.6);
		margin-top: 70px;
		padding: .5rem 1.2rem;
		-webkit-border-radius: 8px;
    	-moz-border-radius: 8px;
    	border-radius: 8px;
		display: inline-block;
	}

	.timer {
		color: white;
		font-size: x-large;
	}

	.btn {
		padding: .3rem .7rem;
	}

	.reminder-container {
		margin-top: 10px;
	}

	.reminder {
		font-weight: bold;
	}

	.live-container {
		background: rgba(0,0,0,0.6);
		padding-top: 50px;
		height: 100%;
	}

	.live-text-container {
		padding-bottom: 5px;
	}

	.fa-circle {
		color: #77de6d;
	}

	.live-text {
		color: white;
		font-weight: bolder;
		font-size: x-large;
		margin-left: 10px;
	}

	.live-session {
		color: white;
		font-size: xx-large;
		margin-top: 10px;
	}

	.fa-star {
		margin-right: 0.75rem;
	}

	.event-container {
		background-color: white;
	}

	.event-info {
		background-color: white;
		margin-bottom: 15px;
		padding: 0.5rem 1rem;
	}

	.event-title {
		text-align: center;
		font-size: xx-large;
	}

	.even-description {
		text-align: center;
		margin-top: 8px;
	}

	.arrow {
		margin-top: 7px;
		text-align: center;
		font-size: xx-large;
	}

	.inline {
		display: inline-block;
	}

	.pointer:hover {
		cursor: pointer;
		-webkit-touch-callout: none;
		-webkit-user-select: none;
		-khtml-user-select: none;
		-moz-user-select: none;
		-ms-user-select: none;
		user-select: none;
	}
</style>

</banner>