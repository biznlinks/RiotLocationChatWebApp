<groups>
<div class="outer-container">
	<!-- <div class="search-container row">
		<div class="col-sm-8 col-sm-offset-2">
			<textarea placeholder="Search Groups" class="search-groups" rows="1"></textarea>
		</div>
	</div> -->

	<div class="groups-container">
		<div id="groups-map"></div>

		<div if={ joinedGroups.length > 0 }>
			<div class="title">
				<i>Joined</i>
			</div>
			<div class="row">
				<div class="col-sm-1 col-xs-1 fa fa-chevron-left arrow pointer" if={ joinedStart!=0 } onclick={ this.shiftLeft }></div>
				<div style="padding: 0 -1rem;" class={col-sm-10: true, col-xs-10: true, col-sm-offset-1: joinedStart==0 || joinedGroups.length <= joinedLength, col-xs-offset-1: joinedStart==0 || joinedGroups.length <= joinedLength }>
					<div class="row">
						<div class="col-sm-3 col-xs-4 tile pointer" each={ group in joinedGroups.slice(joinedStart, joinedEnd) } onclick={ this.chooseGroup(group.get('group')) }>
							<img src={ API.getGroupImage(group.get('group')) } class="image-joined img-circle">
							<div class="group-title">
								{ group.get('group').get('name').slice(0,20) }
								<span if={ group.get('group').get('name').length > 20 }>...</span>
							</div>
						</div>
					</div>
				</div>

				<div class="col-sm-1 col-xs-1 fa fa-chevron-right arrow pointer" if={ joinedEnd < joinedGroups.length } onclick={ this.shiftRight }></div>
			</div>
		</div>
		<div if={ joinedGroups.length > 0 }>
			<hr>
		</div>
		<div class="title">
			<i>Nearby</i>
		</div>
		<div class="nearby">
			<ul>
				<li each={ group in groups } onclick={ this.chooseGroup(group) }>
					<div class="pointer">
						<img src={ API.getGroupImage(group) } class="image-nearby img-circle">
						<div class="info-box">
							<div class="group-title">{ group.get('name') }</div>
							<div class="desc">{ group.get('description') }</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
	</div>

	<button class="btn mfb-component--br" name="submit" onclick={ showCreateModal }>
		<svg width="20px" height="20px" viewBox="0 0 20 20" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <!-- Generator: Sketch 3.8.3 (29802) - http://www.bohemiancoding.com/sketch -->
    <title>Shape</title>
    <desc>Created with Sketch.</desc>
    <defs></defs>
    <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <polygon id="Shape" fill="#FFFFFF" points="20 11.4285714 11.4285714 11.4285714 11.4285714 20 8.57142857 20 8.57142857 11.4285714 0 11.4285714 0 8.57142857 8.57142857 8.57142857 8.57142857 0 11.4285714 0 11.4285714 8.57142857 20 8.57142857"></polygon>
    </g>
</svg>
	</button>
</div>


<script>
	var self          = this
	groupsTag         = this
	self.joinedStart  = 0
	self.joinedEnd    = 0
	self.joinedLength = 0

	this.on('mount', function() {
		if ($(window).width() > 543) self.joinedLength = 4
		else self.joinedLength = 3
		self.joinedEnd = self.joinedStart + self.joinedLength

		self.init()
	})

	init() {
		containerTag.group = null
		API.getjoinedgroups(Parse.User.current()).then(function(joinedGroups) {
			self.joinedGroups = joinedGroups
			API.getallgroups().then(function(groups) {		//TODO Add another filter to get the groups in joinedGroups UserGroup object
				self.groups = groups.filter(function(group) {
					for (var i = 0; i < self.joinedGroups.length; i++)
						if (group.id == self.joinedGroups[i].get('group').id) return false
					return true
				})
				self.initMap()
				self.update()
			})
		})
	}

	initMap() {
		self.gmap = new google.maps.Map(document.getElementById('groups-map'), {
			center: {lat: USER_POSITION.latitude, lng: USER_POSITION.longitude},
          	zoom: 13,
          	disableDefaultUI: true,
          	zoomControl: true,
          	styles: [{ featureType: "poi", elementType: "labels", stylers: [{ visibility: "off" }]},
          		{ featureType: "transit", elementType: "labels", stylers: [{ visibility: "off" }]}]
		})
		self.markers = []
		self.infoWindows = []
		for (var i = 0; i < self.joinedGroups.length; i++) {
			var groupLocation = {lat: self.joinedGroups[i].get('group').get('location').latitude,
				lng: self.joinedGroups[i].get('group').get('location').longitude}
			self.markers.push(new google.maps.Marker({
				map: self.gmap,
				position: groupLocation,
				title: self.joinedGroups[i].get('group').get('name'),
				//icon: '/images/marker-joined.png'
			}))
			self.infoWindows.push(new google.maps.InfoWindow({
				content: self.joinedGroups[i].get('group').get('name'),
			}))
		}
		for (var i = 0; i < self.groups.length; i++) {
			var groupLocation = {lat: self.groups[i].get('location').latitude,
				lng: self.groups[i].get('location').longitude}
			self.markers.push(new google.maps.Marker({
				map: self.gmap,
				position: groupLocation,
				title: self.groups[i].get('name'),
				//icon: '/images/marker-nearby.png'
			}))
		}

		$('#groups-map').css('height', 350)
	}

	showCreateModal() {
		$('#creategroupModal').modal('show')
	}

	chooseGroup(group) {
		return function() {
			containerTag.group = group
			riot.route(encodeURI(group.get('groupId')))
			self.update()
		}
	}

	shiftLeft() {
		self.joinedEnd = self.joinedStart
		self.joinedStart -= self.joinedLength
		self.update()
	}

	shiftRight() {
		self.joinedStart = self.joinedEnd
		self.joinedEnd += self.joinedLength
		self.update()
	}
</script>
<style scoped>

	.outer-container {
		padding-top: 10px;
		margin-top: 50px;
	}

	#map {
		width: 100%;
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

	.row > * {
		padding: 0;
	}

	.title {
		padding: 5px 10px;
	}

	.arrow {
		padding-top: 30px;
		padding-bottom: 70px;
	}

	.fa-chevron-right {
		text-align: center;
	}
	.fa-chevron-left {
		text-align: center;
	}

	.tile {
		vertical-align: top;
		text-align: center;
		display: inline-block;
	}

	.nearby li {
		padding-bottom: 20px;
	}

	.nearby ul {
		list-style: none;
		margin-bottom: 0;
		padding: 0;
	}

	.image-container {
		text-align: center;
	}

	.image-joined {
		height: 60px;
		width: 60px;
		object-fit: cover;
	}

	.image-nearby {
		height: 60px;
		width: 60px;
		object-fit: cover;
		margin: auto 10px;
	}

	.gray {
		border: none;
		background-image: url('/images/default_image.jpg');
		background-size: cover;
	}

	.nearby .group-title {
		margin-top: 0;
	}

	.info-box{
		display: inline-block;
		vertical-align: middle;
		width: calc(100% - 100px);
		display: inline-block;
		border-bottom: 1px solid #ccc;
		padding-top: 20px;
		padding-bottom: 20px;
	}

	.group-title {
		margin-top: 10px;
		font-size: 14px;
		font-weight: 500;
	}

	.desc{
		font-size: 12px;
	}

	@media (max-width: 480px) {
		.group-title > * {
			font-size: 12px;
		}

		.desc{

		}
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
</groups>