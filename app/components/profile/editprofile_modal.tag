<editprofile>

<div id="editprofileModal" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<div class="modal-content">
			<div class="modal-header">

			</div>

			<div class="modal-body">
				<div id="info" if={ screen=='INFO' }>
					<img src={ API.getCurrentUserProfilePicture() } class="img-circle profile-image" onclick={ this.showImage }>
					<input type="text" name="fullname" placeholder="What's your name?"></input>
					<input type="text" name="about" placeholder="Tell us something about yourself"></input>
					<button class="btn btn-default">Edit</button>
				</div>

				<div id="image-search" if={ screen == 'IMAGE-SEARCH'}>
					<input type="text" placeholder="Search" name="imageQuery" onkeyup={ this.keyUp }>
					<div class="image-grid" if={ searchResults && searchResults.length > 0 }>
						<div class={ fa:true, fa-chevron-left:searchStart != 0, arrows:true } onclick={ this.shift(-1) }></div>
						<div class="image-container" each={ image in searchResults.slice(searchStart, searchEnd) } onclick={ this.selectImage(image) } style="background-image: url('{ image.thumbnailUrl }')">
						</div>
						<div class={ fa:true, fa-chevron-right:searchEnd < searchResults.length, arrows:true } onclick={ this.shift(1) }></div>
					</div>

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

			</div>
		</div>

	</div>
</div>

<script>
	var self = this
	editprofileTag = this
	self.screen = 'INFO'

	this.on('mount', function() {
		$(document).on('change', '#imageFile', self.handleUploadedImage)

		$('#editprofileModal').on('shown.bs.modal', function() {
			self.fullname.value = Parse.User.current().get('firstName') + ' ' + Parse.User.current().get('lastName')
			self.about.value = Parse.User.current().get('about') ? Parse.User.current().get('about') : ''
			self.update()
		})
	})

	handleUploadedImage() {
		var file = $('#imageFile')[0].files[0]

		self.screen = 'IMAGE-EDIT'
		//$('#image-edit').attr('src', URL.createObjectURL(file))
		self.selectedImage = {contentUrl: URL.createObjectURL(file), thumbnailUrl: URL.createObjectURL(file)}
		self.update()
		self.createCropper()
		self.closeImage()
	}

	showImage() {
		self.screen = 'IMAGE-SEARCH'
		self.update()
	}

	closeImage() {
		self.screen = 'IMAGE-EDIT'
		self.update()
	}

	keyUp() {
		clearTimeout(self.searchTimer)
		if (self.imageQuery.value) {
			self.searchTimer = setTimeout(self.searchImage, 500)
		}
	}

	searchImage(offset) {
		if (!offset) {				// This is when the function is called from click event
			offset             = 0
			self.searchStart   = 0
			self.searchEnd     = 3
			self.update()
			self.searchResults = []
		}

		API.searchImage(self.imageQuery.value, 9, offset).then(function(data) {
			offset += 10
			data.value.forEach(function(image, index) {
				API.checkCORS(image.contentUrl).then(function (result) {
					if (result) {
						self.searchResults.push({thumbnailUrl: image.thumbnailUrl, contentUrl: result})
					}
					self.update()

					if (index == 8) {
						if (self.searchResults.length < 9) self.searchImage(offset)
					}
				})
			})
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

	uploadImage(file) {
		self.loading = true
		self.update()

		API.uploadImage(file).then(function(result) {
			if (result) {
				self.selectedImage = {thumbnailUrl: result, contentUrl: result}
				self.loading       = false
				self.screen        = 'INFO'
				self.update()
				self.showInfo()
			}
		})
	}

	createCropper() {
		self.cropper = new Cropper(document.getElementById('image-edit'), {
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
		self.cropper.destroy()
	}
</script>

<style scoped>
	.profile-image {
		width: 100px;
		height: 100px;
	}
</style>
</editprofile>