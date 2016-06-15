<groupsmap>

<div class="map-container">
	<div id="groups-map"></div>
	<div class="group-info" if={ selectedGroup }>
		<img class="image" src={ API.getGroupImage(selectedGroup) }>
		<div class="info">
			<div class="name">{ selectedGroup.get('name') }</div>
			<div class="desc">{ selectedGroup.get('description') }</div>
		</div>
	</div>
</div>


<script>
	var self          = this
	self.joinedGroups = opts.joinedGroups
	self.groups       = opts.groups

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
		for (var i = 0; i < self.joinedGroups.length; i++) {
			var groupLocation = {lat: self.joinedGroups[i].get('group').get('location').latitude,
				lng: self.joinedGroups[i].get('group').get('location').longitude}
			self.markers.push(new google.maps.Marker({
				map: self.gmap,
				position: groupLocation,
				title: self.joinedGroups[i].get('group').get('name'),
				group:self.joinedGroups[i].get('group')
				//icon: '/images/marker-joined.png'
			}).addListener('click', function() {
				self.selectedGroup = this.group
				self.update()
			}))
		}
		for (var i = 0; i < self.groups.length; i++) {
			var groupLocation = {lat: self.groups[i].get('location').latitude,
				lng: self.groups[i].get('location').longitude}
			self.markers.push(new google.maps.Marker({
				map: self.gmap,
				position: groupLocation,
				title: self.groups[i].get('name'),
				group: self.groups[i]
				//icon: '/images/marker-nearby.png'
			}).addListener('click', function() {
				self.selectedGroup = this.group
				self.update()
			}))
		}

		$('#groups-map').css('height', 300)
	}

</script>

<style scoped>
	#map {
		width: 100%;
	}

	.group-info {
		padding: 5px;
	}

	.image {
		width: 100px;
		height: 100px;
		object-fit: cover;
	}

	.info {
		display: inline-block;
		padding-left: 10px;

		vertical-align: middle;
		width: calc(100% - 100px);
		display: inline-block;
		border-bottom: 1px solid #ccc;
		padding-top: 20px;
		padding-bottom: 20px;
	}

	.name {
		font-size: 20px;
	}
	.desc {
		font-size: 16px;
	}
</style>
</groupsmap>