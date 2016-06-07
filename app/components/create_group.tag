<creategroup>

<div id="creategroupModal" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<!-- Modal content -->
		<div class="modal-content">
			<div if={loading} class="modal-body text-xs-center">
				<i class="fa fa-spinner fa-spin fa-3x fa-fw margin-bottom"></i>
				<span class="sr-only">Loading...</span>
			</div>

			<div class="header modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button></div>
			<div if={!loading} class="modal-body">
				<div class="groupname-container" onclick={ this.update() }>
					<input type="text" name="groupname" placeholder="New Group"></input>
				</div>

				<div id="map"></div>

				<div class="address">{ address }</div>

				<div class="confirm-container"><button class="btn btn-default" onclick={ this.submitGroup }>Submit</button></div>
				<div class="error text-warning" if={ isError }>{ error }</div>
			</div>
		</div>

	</div>
</div>

<script>
	var self     = this
	self.address = ''
	self.isError = false
	self.error   = ''

	this.on('mount', function() {
		self.map = new google.maps.Map(document.getElementById('map'), {
			center: {lat: USER_POSITION.latitude, lng: USER_POSITION.longitude},
          	zoom: 11
		})
		self.userMarker = new google.maps.Marker({
			map: self.map,
			position: {lat: USER_POSITION.latitude, lng: USER_POSITION.longitude},
			icon: '/images/user_marker.png'
		})
		self.marker  = new google.maps.Marker({ map: self.map })
		self.service = new google.maps.places.PlacesService(self.map);

		self.map.addListener('click', function(e) {
			self.marker.setMap(self.map)
			self.marker.setPosition(e.latLng)
			self.map.panTo(e.latLng)
			self.getStreetAddress(e.latLng)
		})

		$('#creategroupModal').on('shown.bs.modal', function() {
			// There is something with BS modals that requires
			// 'resize' event to be triggered to show the map
			google.maps.event.trigger(self.map, 'resize')
			self.map.setCenter(new google.maps.LatLng(USER_POSITION.latitude, USER_POSITION.longitude))
			self.map.setZoom(10)
		})
		$('#creategroupModal').on('hidden.bs.modal', function() {
			self.isError         = false
			self.error           = ''
			self.address         = ''
			self.groupname.value = ''
			self.marker.setMap(null)
			self.update()
		})
	})

	getStreetAddress(position) {
		var request = {
			location: position,
			radius: '5',
			types: 'administrative_area_level_2'
		}
		self.service.nearbySearch(request, function(results, status) {
			if (status == google.maps.places.PlacesServiceStatus.OK) {
				for (var i = 0; i < results.length && i < 4; i++) {
					if (results[i].name != 'United States' && results[i].name != results[i].vicinity) {
						self.address = results[i].name + ', ' + results[i].vicinity
					}
				}
				self.update()
			}
		})
	}

	submitGroup() {
		if (self.groupname.value.length < 3) {
			self.isError = true
			self.error = "Groups' names must be at least 3-character long"
			self.update()
			return null
		} else if (!self.marker.position) {
			self.isError = true
			self.error = "Choose group's position on the map"
			self.update()
			return null
		}

		var GroupObject = Parse.Object.extend('Group')
		var newGroup = new GroupObject()
		newGroup.save({
			location: new Parse.GeoPoint(self.marker.position.lat(), self.marker.position.lng()),
			name: self.groupname.value,
			type: 'group'
		},{
			success: function(group) {
				$('#creategroupModal').modal('hide')
			}, error: function(group, error) {
				self.isError = true
				self.error = error.message
				self.update()
			}
		})
	}
</script>

<style scoped>
	:scope {
		text-align: center;
	}

	.header {
		border: none;
		padding-bottom: 0;
	}

	.groupname-container input {
		text-align: center;
		font-size: large;
		border: none;
		border-bottom: 1px solid #eeeeee;
	}

	#map {
		margin-top: 20px;
		margin-bottom: 20px;
	}

	.confirm-container {
		margin-top: 10px;
		margin-bottom: 10px;
	}

	@media screen and (min-height: 1000px) {
		#map {
			height: 500px;
		}
	}
	@media screen and (max-height: 1000px) {
		#map {
			height: 300px;
		}
	}
</style>
</creategroup>