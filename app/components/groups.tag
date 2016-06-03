<groups>

<div class="outer-container">
	<div class="user-locale">
		<span class="fa fa-map-marker"></span>
		<span class="city-name">{ USER_LOCALE }</span>
	</div>

	<div class="search-container row">
		<div class="col-sm-8 col-sm-offset-2">
			<textarea placeholder="Search Groups" class="search-groups" rows="1"></textarea>
		</div>
	</div>

	<div class="groups-container">
		<!-- <div class="title">
			<i>Events</i>
		</div> -->
		<div class="box">
			<div class="row">
				<div class="col-sm-3 col-xs-3 tile" each={ event in events }>
					<div>
						<img if={ typeof event.get('image')!='undefined' } src={ event.get('image').url() } class="image img-circle">
						<img if={ typeof event.get('image')=='undefined' } src="" class="image gray img-circle">
					</div>
					<div class="name">{ event.get('name') }</div>
				</div>
				<div class="col-sm-3 col-xs-3 tile" each={ group in groups }>
					<div>
						<img if={ typeof group.get('image')!='undefined' } src={ group.get('image').url() } class="image img-circle">
						<img if={ typeof group.get('image')=='undefined' } src="" class="image gray img-circle">
					</div>
					<div class="name">{ group.get('name') }</div>
				</div>
			</div>
		</div>
	</div>

	<!-- <div class="inner-container">
		<div class="title">
			<i>Interests</i>
		</div>
		<div class="box">
			<div class="row">

			</div>
		</div>
	</div> -->
</div>


<script>
	var self = this


	this.on('mount', function() {
		self.init()
	})

	init() {
		API.getallgroups().then(function(groups) {
			self.groups = groups
			API.getallevents().then(function(events) {
				self.events = events
				self.update()
			})
		})
	}
</script>
<style scoped>
	:scope {
		color: #909090;
	}

	.outer-container {
		background-color: white;
		padding: 10px;
	}

	.user-locale {
		text-align: center;
	}

	.search-container {
		text-align: center;
		margin-top: 25px;
	}

	.search-groups {
		resize: none;
		text-align: center;
		font-size: large;
		padding: 7px 0;
		width: 100%;
		-webkit-border-radius: 15px;
    	-moz-border-radius: 15px;
    	border-radius: 15px;
	}

	.groups-container {
		margin-top: 20px;
	}

	.title {
		padding: 5px 10px;
		border-bottom: 1px solid #909090;
	}

	.box {
		margin-top: 20px;
	}

	.tile {
		text-align: center;
		margin-bottom: 15px;
	}

	.image {
		height: 50px;
		width: 50px;
	}

	.gray {
		background-color: #b5b5b5;
	}

	.name {
		margin-top: 10px;
	}

</style>
</groups>