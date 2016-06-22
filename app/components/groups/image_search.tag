<imagesearch>

<div id="outer-container">
	<div if={loading} class="modal-body text-xs-center">
		<i class="fa fa-spinner fa-spin fa-3x fa-fw margin-bottom"></i>
		<span class="sr-only">Loading...</span>
	</div>

	<div id="image-search-container" if={ !loading }>
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

	<div id="image-edit-container" if={ !loading }>
		<img id="image-edit" src={ selectedImage.contentUrl }>
		<button class="btn btn-default fa fa-rotate-left" onclick={ this.rotate(-90) }></button>
		<button class="btn btn-default fa fa-rotate-right" onclick={ this.rotate(90) }></button>
		<button class="btn btn-default" onclick={ this.cropAndUpload }>OK</button>
	</div>
</div>

<script>
	var self       = this
	imagesearchTag = this
	self.callback  = opts.callback


	this.on('mount', function() {
		$('#outer-container').slideUp({duration: 0})
		$('#image-search-container').slideUp({duration: 0})
		$('#image-edit-container').slideUp({duration: 0})

		$(document).on('change', '#imageFile', self.handleUpload)
	})

	handleUpload() {
		var file = $('#imageFile')[0].files[0]
		var image = {contentUrl: URL.createObjectURL(file), thumbnailUrl: URL.createObjectURL(file)}
		self.selectedImage = image
		self.update()
		self.hideSearch().then(function(result) {
			self.showEdit().then(function(result) { self.createCropper() })
		})
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

		API.searchImage(self.imageQuery.value).then(function(data) {
			console.log(data)
			// Just get 9 images for now, the query returns 10
			for (var i = 0; i < 9; i++) {
				API.getImageThroughProxy(data[i]).then(function (result) {
					if (result) {
						self.searchResults.push(result)
					}
					self.update()
				})
			}
		})
	}

	shift(direction) {
		return function() {
			switch(direction) {
				case -1:
					self.searchEnd   = self.searchStart
					self.searchStart -= 3
					self.update()
					break
				case 1:
					self.searchStart = self.searchEnd
					self.searchEnd   += 3
					self.update()
					break
			}
		}
	}

	selectImage(image) {
		return function() {
			self.selectedImage = image
			self.update()
			self.hideSearch().then(function(result) {
				self.showEdit().then(function(result) { self.createCropper() })
			})
		}
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
		console.log(self.cropper)
		self.cropper.getCroppedCanvas({
			width: 800
		}).toBlob(function(blob) {
			self.loading = true
			self.update()
			API.uploadImage(blob).then(function(result) {
				if (result) {
					self.callback({contentUrl: result, thumbnailUrl: result})
				}
			})
		})
		self.cropper.destroy()
	}

	show() {
		var promise = new Parse.Promise()
		$('#outer-container').slideDown({duration: 0})
		self.showSearch().then(function(result) { promise.resolve(true) })

		return promise
	}

	hide() {
		var promise  = new Parse.Promise()

		$('#outer-container').slideUp({
			duration: 500,
			complete: function() { promise.resolve(true) }
		})

		self.loading = false
		self.update()
		$('#image-search-container').slideUp({duration: 0})
		$('#image-edit-container').slideUp({duration: 0})

		self.searchResults    = undefined
		self.selectedImage    = undefined
		self.imageQuery.value = ''
		if (self.cropper) self.cropper.destroy()
		self.update()

		return promise
	}

	showSearch() {
		var promise = new Parse.Promise()
		$('#image-search-container').slideDown({
			duration: 500,
			complete: function() { promise.resolve(true) }
		})

		return promise
	}

	hideSearch() {
		var promise = new Parse.Promise()
		$('#image-search-container').slideUp({
			duration: 500,
			complete: function() { promise.resolve(true) }
		})

		return promise
	}

	showEdit() {
		var promise = new Parse.Promise()
		$('#image-edit-container').slideDown({
			duration: 500,
			complete: function() { promise.resolve(true) }
		})

		return promise
	}

	hideEdit() {
		var promise = new Parse.Promise()
		self.cropper.destroy()
		$('#image-edit-container').slideUp({
			duration: 500,
			complete: function() { promise.resolve(true) }
		})

		return promise
	}
</script>

<style scoped>
	:scope {
		text-align: center;
	}

	#image-search-container input {
		margin-bottom: 10px;
		text-align: center;
		font-size: large;
		border: none;
	}

	#image-search-container input:focus {
		outline: none;
	}

	.image-grid {
		padding-top: 10px;
		border-top: 1px solid #ddd;
		border-bottom: 1px solid #ddd;
		line-height: 1;
	}

	.arrows {
		width: 5%;
		vertical-align: top;
		margin-top: 50px;
	}

	.image-container {
		height: 110px;
		width: 25%;
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

	.options {
		padding-top: 70px;
		padding-bottom: 50px;
		text-align: center;
		font-size: 26px;
		font-weight: 600;
		color: #bbb;
	}

	@media screen and (max-width: 543px) {
		.image-container {
			height: 80px;
		}
	}
</style>
</imagesearch>