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
				<div class="groupinfo-container" id="info" if={ !chooseLocation }>
					<div><input type="text" name="groupname" id="groupname" placeholder="New Group"></div>
					<div><input type="text" name="desc" id="desc" placeholder="Short Description"></div>
				</div>

				<div id="map" class="hide"></div>
				<div class="address" onclick={ this.showMap }>{ address }</div>

				<div class="confirm-container" if={ !chooseLocation }><button class="btn btn-default" onclick={ this.submitGroup }>Create</button></div>
				<div class="confirm-container" if={ chooseLocation }><button class="btn btn-default" onclick={ this.closeMap }>OK</button></div>
				<div class="error text-warning" if={ isError }>{ error }</div>
			</div>
		</div>

	</div>
</div>

<script>
	var self     = this
	self.address = 'Choose Location'
	self.isError = false
	self.error   = ''
	self.chooseLocation = false

	this.on('mount', function() {
		$('#creategroupModal').on('shown.bs.modal', function() {
			// There is something with BS modals that requires
			// 'resize' event to be triggered to show the map
			/*google.maps.event.trigger(self.map, 'resize')
			self.map.setCenter(new google.maps.LatLng(USER_POSITION.latitude, USER_POSITION.longitude))
			self.map.setZoom(10)*/
		})
		$('#creategroupModal').on('hidden.bs.modal', function() {
			self.isError         = false
			self.error           = ''
			self.address         = 'Choose Location'
			self.groupname.value = ''

			self.chooseLocation  = false
			self.closeMap()
			self.gmap            = null
			if (self.marker) {
				self.marker.setPosition(null)
				self.groupCircle.setCenter(null)
			}
			self.update()
		})
	})

	initMap() {
		self.gmap = new google.maps.Map(document.getElementById('map'), {
			center: {lat: USER_POSITION.latitude, lng: USER_POSITION.longitude},
          	zoom: 13
		})
		self.userMarker = new google.maps.Marker({
			map: self.gmap,
			position: {lat: USER_POSITION.latitude, lng: USER_POSITION.longitude},
			icon: '/images/marker.png'
		})
		self.marker = new google.maps.Marker({
			map: self.gmap,
			icon: '/images/marker-filled.png'
		})
		self.groupCircle = new google.maps.Circle({
			strokeColor: '#282A6A',
			strokeOpacity: 0.8,
			strokeWeight: 1,
			fillColor: '#A9A9C3',
			fillOpacity: 0.3,
			map: self.gmap,
			radius: 1609,
			clickable: false
		})
		self.service = new google.maps.places.PlacesService(self.gmap);

		self.gmap.addListener('click', function(e) {
			self.marker.setPosition(e.latLng)
			self.gmap.panTo(e.latLng)
			self.getStreetAddress(e.latLng)
			self.groupCircle.setCenter(self.marker.position)
		})

		self.userMarker.addListener('click', function(e) {
			self.marker.setPosition(self.userMarker.position)
			self.getStreetAddress(e.latLng)
			self.groupCircle.setCenter(self.marker.position)
		})
	}

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
			self.error   = "Groups' names must be at least 3-character long"
			self.update()
			return null
		} else if (!self.marker.position) {
			self.isError = true
			self.error   = "Choose group's position on the map"
			self.update()
			return null
		}

		self.generateGroupId().then(function(results) {
			var groupId = results

			var GroupObject = Parse.Object.extend('Group')
			var newGroup    = new GroupObject()
			newGroup.save({
				location: new Parse.GeoPoint(self.marker.position.lat(), self.marker.position.lng()),
				name: self.groupname.value,
				groupId: groupId,
				type: 'group'
			},{
				success: function(group) {
					groupsTag.init()
					$('#creategroupModal').modal('hide')
				}, error: function(group, error) {
					self.isError = true
					self.error = error.message
					self.update()
				}
			})
		})
	}

	generateGroupId() {
		var promise = new Parse.Promise()
		var groupId = self.groupname.value.toLowerCase()
		groupId     = groupId.replace(new RegExp(' ','g'), '-')

		randomGroupId()

		function randomGroupId() {
			var randomId    = Math.round(Math.random() * 999 + 1)
			var tempGroupId = groupId + '-' + randomId
			var GroupObject = Parse.Object.extend('Group')
			var query       = new Parse.Query(GroupObject)
			query.equalTo('groupId', tempGroupId)
			query.find({
				success: function(groups) {
					if (groups.length == 0) promise.resolve(tempGroupId)
					else randomGroupId()
				},
				error: function(error) {
					randomGroupId()
				}
			})
		}

		return promise
	}

	showMap() {
		if (self.chooseLocation) return null;

		$('#info').slideUp({
			duration: 500,
			complete: function() {
				self.chooseLocation = true
				self.address = self.address == 'Choose Location' ? '' : self.address
				self.update()

				var height = $(window).height() >= 1000 ? 500 : 300;
				$('#map').animate({height: height}, {
					duration: 500,
					complete: function() {
						if (self.gmap == null)
							self.initMap()
					}
				}).removeClass('hide')
			}
		})
	}

	closeMap() {
		$('#map').animate({height: 0},{
			duration: 500,
			complete: function() {
				if (self.address == '') self.address = 'Choose Location'
				self.chooseLocation = false
				self.update()
				$('#info').slideDown({duration: 500})
			}
		}).addClass('hide')
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

	.groupinfo-container input {
		text-align: center;
		margin-top: 15px;
		border: none;
		border-bottom: 1px solid #eeeeee;
	}

	.groupinfo-container#groupname {
		font-size: x-large;
	}

	.groupinfo-container#desc {
		font-size: large;
	}

	#map {
		margin-top: 20px;
		margin-bottom: 20px;
	}

	#map.hide {
		height: 0;
		margin: 0;
	}

	.address {
		margin-top: 20px;
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