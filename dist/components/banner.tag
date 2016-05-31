<banner>

<div class="banner-container">
	<div class="row" align="center">
		<div class="timer-container text-center">
			<div class="timer-background">
				<div class="timer" name="timer">
					<span if={ days > 0 }>{days} day<span if={ days > 1}>s</span></span>
					<span if={ hours > 0 }>{hours} hour<span if={ hours > 1 }>s</span></span>
					<span if={ minutes > 0 }>{minutes} minute<span if={ minutes > 1 }>s</span></span>
					<span if={ seconds > 0 }>{seconds} second<span if={ seconds > 1 }>s</span></span>
				</div>
			</div>
			<div class="reminder-container" onclick={ this.showSignup }>
				<button class="reminder btn btn-primary"><i class="fa fa-star"></i>Stay Updated</button>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="event-info text-center">
				<div class="event-title">ICTD 2016</div>
				<div class="event-description" if={ open }>
					{containerTag.group.get('description')}
				</div>
				<div class="arrow pointer" onclick={ this.toggleOpen }>
					<div if={ open }><i class="fa fa-angle-up"></i></div>
					<div if={ !open }><i class="fa fa-angle-down"></i></div>
				</div>
		</div>
	</div>
</div>

<script>
	var self      = this
	self.open     = true
	self.days     = 0
	self.hours    = 0
	self.minutes  = 0
	self.seconds  = 0
	self.deadline = '2016-06-03T09:00:00-04:00'

	this.on('mount', function() {
		var timeinterval = setInterval(function() {
			self.setRemainingTime(self.deadline)
			self.update()
		}, 1000)
	})

	setRemainingTime(deadline) {
		var t = Date.parse(deadline) - Date.parse(new Date())
		var seconds = Math.floor( (t/1000) % 60 )
		var minutes = Math.floor( (t/1000/60) % 60 )
		var hours = Math.floor( (t/(1000*60*60)) % 24 )
		var days = Math.floor( t/(1000*60*60*24) )

		self.days    = days
		self.hours   = hours
		self.minutes = minutes
		self.seconds = seconds
	}

	toggleOpen() {
		self.open = !self.open
		self.update()
	}

	showSignup() {
		self.parent.tags.signupModal.update({stayUpdated: true})
		$('#signupModal').modal('show')
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

	.reminder-container {
		margin-top: 10px;
	}

	.reminder {
		font-weight: bold;
	}

	.fa-star {
		margin-right: 1rem;
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