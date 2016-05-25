<banner>

<div>
	<div class="row" align="center">
		<div class="timer-container col-md-10 col-md-offset-1 col-lg-8 col-lg-offset-2 text-center">
			<div class="timer-background">
				<div class="timer" name="timer">
					<span class="hours" name="hours"></span> hr
					<span class="minutes" name="minutes"></span> m
					<span class="seconds" name="seconds"></span> s
				</div>
			</div>
			<div class="reminder-container">
				<button class="reminder btn btn-primary"><i class="fa fa-star"></i>Remind Me</button>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="event-info col-md-10 col-md-offset-1 col-lg-8 col-lg-offset-2 text-center">
				<div class="event-title">ICTD 2016</div>
				<div class="even-description" if={ open }>
					{Group.get('description')}
				</div>
				<div class="arrow pointer" onclick={ this.toggleOpen }>
					<div if={ open }><i class="fa fa-angle-up"></i></div>
					<div if={ !open }><i class="fa fa-angle-down"></i></div>
				</div>
		</div>
	</div>
</div>

<script>
	var self = this
	self.open = true
	self.deadline = '2016-06-03T09:00:00-04:00'

	this.on('mount', function() {
		var timeinterval = setInterval(function() {
			var t = self.getRemainingTime(self.deadline)
			self.hours.innerHTML = t.hours
			self.minutes.innerHTML = t.minutes
			self.seconds.innerHTML = t.seconds
		}, 1000)
	})

	getRemainingTime(deadline) {
		var t       = Date.parse(deadline) - Date.parse(new Date())
		t           /= 1000
		var hours   = Math.floor( (t/3600) )
		t           -= hours * 3600
		var minutes = Math.floor( (t/60) )
		t           -= minutes * 60
		var seconds = t

		return {
			'hours': hours,
			'minutes': minutes,
			'seconds': seconds
		}
	}

	toggleOpen() {
		self.open = !self.open
		self.update()
	}

</script>

<style scoped>
	.timer-container {
		background-image: url('/images/annarbor.jpg');
		height: 220px;
		background-size: cover;
    	background-repeat: no-repeat;
    	background-position: 50% 50%;
	}

	.timer-background {
		background-color: rgba(0,0,0,0.6);
		margin-top: 50px;
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
		margin-top: 8px;
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