<groups>

<div class="outer-container">
	<!-- <div class="user-locale">
		<span class="fa fa-map-marker"></span>
		<span class="city-name">{ USER_LOCALE }</span>
	</div> -->

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
				<div class="col-sm-3 col-xs-3 tile" each={ group in groups } onclick={ this.chooseGroup(group) }>
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

	<button class="btn mfb-component--br" name="submit" onclick={ showCreateModal }>
		<svg style="width:24px;height:24px" viewBox="0 0 24 24">
		    <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" stroke="white" stroke-width="2" fill="none"/>
		</svg>
	</button>
</div>


<script>
	var self = this
	groupsTag = this

	this.on('mount', function() {
		self.init()
	})

	init() {
		API.getallgroups().then(function(groups) {
			self.groups = groups
			self.update()
		})
	}

	showCreateModal() {
		$('#creategroupModal').modal('show')
	}

	chooseGroup(e) {
		return function() {
			containerTag.group = e
			riot.route(encodeURI(e.get('groupId')))
			self.update()
		}
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
		-webkit-border-radius: 25px;
    	-moz-border-radius: 25px;
    	border-radius: 25px;
	}

	.search-groups:focus {
		outline: none;
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

	.mfb-component--br {
		right: 0;
		bottom: 0;
		text-align: center;
	}
	.mfb-component--tl, .mfb-component--tr, .mfb-component--bl, .mfb-component--br {
		box-sizing: border-box;
		margin: 25px;
		position: fixed;
		white-space: nowrap;
		z-index: 30;
		list-style: none;
		border-radius: 50%;
		width: 55px;
		height: 55px;
		padding: 0px;
		background: #039be5;
		color: white;
		font-size: 1.6em;
		box-shadow: 0 2px 5px 0 rgba(0,0,0,0.16),0 2px 10px 0 rgba(0,0,0,0.12);
	}

</style>
</groups>