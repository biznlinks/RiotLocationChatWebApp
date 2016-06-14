<creategroup>

<div id="creategroupModal" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<!-- Modal content -->
		<div class="modal-content">
			<div class="header modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button></div>

			<div if={loading} class="modal-body text-xs-center">
				<i class="fa fa-spinner fa-spin fa-3x fa-fw margin-bottom"></i>
				<span class="sr-only">Loading...</span>
			</div>

			<div if={!loading} class="modal-body">
				<div id="info-form" if={ screen == 'INFO' }>
					<div class="groupinfo-container" id="info">
						<div onclick={ showImage }>
							<div class="add-photo" if={ !selectedImage }>Add Image</div>
							<img class="img-circle group-photo" if={ selectedImage } src={ selectedImage.thumbnailUrl }>
						</div>
						<div><input type="text" name="groupname" id="groupname" placeholder="New Group"></div>
						<div><input type="text" name="desc" id="desc" placeholder="Short Description"></div>
					</div>

					<div id="map" class="hide"></div>
					<div class="address" onclick={ this.showMap }>{ address }</div>

					<div class="confirm-container" if={ !chooseLocation }><button class="btn btn-default" onclick={ this.submitGroup }>Create</button></div>
					<div class="confirm-container" if={ chooseLocation }><button class="btn btn-default" onclick={ this.closeMap }>OK</button></div>
				</div>

				<div id="image-search" if={ screen == 'IMAGE-SEARCH'}>
					<input type="text" placeholder="Search" name="imageQuery" onkeyup={ this.keyUp }>
					<div class="image-grid" if={ searchResults && searchResults.length > 0 }>
						<div class="image-container" each={ image in searchResults } onclick={ this.selectImage(image) } style="background-image: url('{ image.thumbnailUrl }')">
							<!-- <img src={ image.thumbnailUrl } class="tile"> -->
						</div>
					</div>
					<!-- <div class="uploaded-image" if={ uploadedImageUrl } >
						<label for="imageFile" style="background-image: url('{uploadedImageUrl}')"></label>
						<input name="imageFile" id="imageFile" type="file" style="visibility: hidden; position: absolute;"></input>
					</div> -->
					<div class="options" if={ !searchResults || searchResults.length == 0 }>
						<div>Search for your group's image</div>
						or
						<div>
							<label for="imageFile"><span class="btn btn-primary">Upload your image</span></label>
							<input name="imageFile" id="imageFile" type="file" style="visibility: hidden; position: absolute;"></input>
						</div>
					</div>
				</div>

				<div id="image-edit-container" if={ screen == 'IMAGE-EDIT'}>
					<img id="image-edit" src={ selectedImage.contentUrl }>
					<button class="btn btn-default fa fa-rotate-left" onclick={ this.rotate(-90) }></button>
					<button class="btn btn-default fa fa-rotate-right" onclick={ this.rotate(90) }></button>
					<button class="btn btn-default" onclick={ this.cropAndUpload }>OK</button>
				</div>

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
	self.screen  = 'INFO'

	creategroupTag = this

	this.on('mount', function() {
		self.initMap()
		self.getStreetAddress({lat: USER_POSITION.latitude, lng: USER_POSITION.longitude})

		$('#creategroupModal').on('shown.bs.modal', function() {
			self.initMap()
			if ($(window).width() <= 544) {
	          $('body').css('overflow', 'hidden')
	          $('body').css('position', 'fixed')
	        }
		})
		$('#creategroupModal').on('hidden.bs.modal', function() {
			$('body').css('overflow', 'scroll')
        	$('body').css('position', 'relative')

			self.closeMap()
        	self.closeImage()

			self.searchResults    = undefined
			self.selectedImage    = undefined
			self.imageQuery.value = ''

			self.isError         = false
			self.error           = ''
			self.address         = self.getStreetAddress({lat: USER_POSITION.latitude, lng: USER_POSITION.longitude})
			self.groupname.value = ''
			self.desc.value      = ''

			self.screen = 'INFO'
			self.update()

			self.showInfo()
		})

		$(document).on('change', '#imageFile', self.handleUploadedImage)
	})

	keyUp() {
		clearTimeout(self.searchTimer)
		if (self.imageQuery.value) {
			self.searchTimer = setTimeout(self.searchImage, 1000)
		}
	}

	handleUploadedImage() {
		var file = $('#imageFile')[0].files[0]

		self.screen = 'IMAGE-EDIT'
		self.update()
		$('#image-edit').attr('src', URL.createObjectURL(file))
		self.createCropper()
		self.closeImage()
	}

	uploadImage(file) {
		var serverUrl = 'https://api.parse.com/1/files/' + file.name;

		self.loading = true
		self.update()

		var image = new Image
		image.onload = function() {
			if (image.width >= 640) {
				$.ajax({
			        type: "POST",
			        beforeSend: function(request) {
			        	request.setRequestHeader("X-Parse-Application-Id", 'YDTZ5PlTlCy5pkxIUSd2S0RWareDqoaSqbnmNX11');
			        	request.setRequestHeader("X-Parse-REST-API-Key", 'TkCtS0607l5lfgiO65FbNc5zudsLcADDwPcQS1Va');
			        	request.setRequestHeader("Content-Type", file.type);
			        },
			        url: serverUrl,
			        data: file,
			        processData: false,
			        contentType: false,
			        success: function(data) {
			        	self.selectedImage = {thumbnailUrl: data.url, contentUrl: data.url}
			        	self.loading = false
			        	self.screen = 'INFO'
						self.update()
						self.showInfo()
			        },
			        error: function(data) {
			        }
			    });
			}
		}
		image.src = URL.createObjectURL(file)
	}

	initMap() {
		self.gmap = new google.maps.Map(document.getElementById('map'), {
			center: {lat: USER_POSITION.latitude, lng: USER_POSITION.longitude},
          	zoom: 13,
          	disableDefaultUI: true,
          	zoomControl: true,
          	styles: [{ featureType: "poi", elementType: "labels", stylers: [{ visibility: "off" }]},
          		{ featureType: "transit", elementType: "labels", stylers: [{ visibility: "off" }]}]
		})
		self.marker = new google.maps.Marker({
			map: self.gmap,
			position: {lat: USER_POSITION.latitude, lng: USER_POSITION.longitude},
			icon: '/images/marker-filled.png'
		})
		self.groupCircle = new google.maps.Circle({
			strokeColor: '#282A6A',
			strokeOpacity: 0.8,
			strokeWeight: 1,
			fillColor: '#A9A9C3',
			fillOpacity: 0.3,
			map: self.gmap,
			center: {lat: USER_POSITION.latitude, lng: USER_POSITION.longitude},
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
		}

		self.loading = true
		self.update()

		self.generateGroupId().then(function(results) {
			var groupId = results

			var GroupObject = Parse.Object.extend('Group')
			var newGroup    = new GroupObject()
			newGroup.save({
				location: new Parse.GeoPoint(self.marker.position.lat(), self.marker.position.lng()),
				name: self.groupname.value,
				description: self.desc.value,
				imageUrl: self.selectedImage ? self.selectedImage.contentUrl : undefined,
				groupId: groupId,
				memberCount: 1,
				type: 'group'
			},{
				success: function(group) {
					var UserGroupObject = Parse.Object.extend('UserGroup')
					var newUserGroup = new UserGroupObject()
					newUserGroup.save({
						user: Parse.User.current(),
						group: group
					}, {
						success: function(userGroup) {

						}, error: function(userGroup, error) {
							self.isError = true
							self.error = error.message
							self.update()
						}
					})

					var newPostContent = 'Welcome to ' + group.get('name')
					newPostContent += (group.get('description')) ? ', ' + group.get('description') : ''
					var PostObject = Parse.Object.extend('Post')
					var newPost = new PostObject()
					newPost.save({
						author: Parse.User.current(),
						group: group,
						content: newPostContent,
						newsFeedViewsBy: [],
						answerCount: 0,
						wannaknowCount: 0,
						anonymous: false
					}, {
						success: function(post) {
							var Wannaknow = Parse.Object.extend('WannaKnow')
					        var wannaknow = new Wannaknow()
					        wannaknow.save({
					          post: post,
					          user: Parse.User.current()
					      	}, {
					      		success: function(wannaknow) {
					      			self.loading = false
					      			$('#creategroupModal').modal('hide')
									containerTag.group = group
									riot.route(encodeURI(group.get('groupId')))
									self.update()
					      		}
					      	})
					    }
					})
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
		var groupId = self.groupname.value.toLowerCase().trim()
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
					else randomGroupId().then(function(results) { promise.resolve(results) })
				},
				error: function(error) {
					randomGroupId().then(function(results) { promise.resolve(results) })
				}
			})
		}

		return promise
	}

	searchImage() {
		$.ajax({
			url: 'https://bingapis.azure-api.net/api/v5/images/search?q='+self.imageQuery.value+'&count=9&offset=0&mkt=en-us&safeSearch=Moderate',
			headers: {"Ocp-Apim-Subscription-Key": "b7bef01565c343e492b34386142f0b68"}
		}).then(function(data){
			self.searchResults = data.value
			self.update()
		})
	}

	selectImage(image) {
		return function() {
			self.selectedImage = image
			self.screen = 'IMAGE-EDIT'
			self.update()
			self.createCropper()
			self.closeImage()
		}
	}

	showMap() {
		if (self.chooseLocation) return null;

		$('#info').slideUp({
			duration: 500,
			complete: function() {
				self.chooseLocation = true
				self.address = self.address == 'Change Location' ? '' : self.address
				self.update()

				var height = $(window).height() >= 1000 ? 500 : 300
				$('#map').animate({height: height}, {
					duration: 500,
					complete: function() {
						google.maps.event.trigger(self.gmap, 'resize')
						self.gmap.panTo(self.marker.position)
					}
				}).removeClass('hide')
			}
		})
	}

	closeMap() {
		$('#map').animate({height: 0},{
			duration: 500,
			complete: function() {
				if (self.address == '') self.address = 'Change Location'
				self.chooseLocation = false
				self.update()
				$('#info').slideDown({duration: 500})
			}
		}).addClass('hide')
	}

	showImage() {
		$('#info-form').slideUp({
			duration: 500,
			complete: function() {
				self.screen = 'IMAGE-SEARCH'
				self.update()
				$('#image-search').slideUp({duration: 0})
				$('#image-search').slideDown({duration: 500})
			}
		})
	}

	closeImage() {
		$('#image-search').slideUp({
			duration:500,
			complete: function() {
				self.screen = 'INFO'
				self.update()
				$('#info-form').slideDown({duration: 500})
			}
		})
	}

	showInfo() {
		$('#info-form').slideDown({duration: 500})
	}

	createCropper() {
		var image = document.getElementById('image-edit')
		self.cropper = new Cropper(image, {
			viewMode: 3,
			aspectRatio: 16/9,
			cropBoxResizable: false
		})
	}

	rotate(deg) {
		return function() {
			self.cropper.rotate(deg)
		}
	}
	cropAndUpload() {
		self.cropper.getCroppedCanvas({
			height: 400
		}).toBlob(function(blob) {
			self.uploadImage(blob)
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

	.add-photo {
		margin: 0 auto;
		height: 100px;
		width: 100px;
		padding-top: 35px;
		-webkit-border-radius: 50%;
    	-moz-border-radius: 50%;
    	border-radius: 50%;
    	border:1px dashed #00BFFF;
		color: #00BFFF;
	}
	.group-photo {
		height: 100px;
		width: 100px;
	}

	.groupinfo-container input {
		text-align: center;
		margin-top: 15px;
		border: none;
	}

	#groupname {
		font-size: x-large;
		width: 100%;
	}
	#groupname:focus, #desc:focus {
		outline: none;
	}

	#desc {
		font-size: large;
		width: 100%
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
		color: #00BFFF;
	}

	.confirm-container {
		margin-top: 10px;
		margin-bottom: 10px;
	}

	.options {
		padding-top: 70px;
		padding-bottom: 50px;
		text-align: center;
		font-size: 26px;
		font-weight: 600;
		color: #bbb;
	}

	#image-search input {
		margin-bottom: 10px;
		text-align: center;
		font-size: large;
		border: none;
	}

	#image-search input:focus {
		outline: none;
	}

	.image-grid {
		padding-top: 10px;
		border-top: 1px solid #ddd;
		border-bottom: 1px solid #ddd;
		line-height: 1;
	}

	.image-container {
		height: 110px;
		width: 28%;
		background-size: cover;
		margin: 5px;
		display: inline-block;
	}

	.uploaded-image label {
		width: 100%;
		height: 300px;
	}

	#image-edit {
		width: 100%;
		height: 300px;
	}

	@media screen and (max-width: 543px) {
		.image-container {
			height: 80px;
		}
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