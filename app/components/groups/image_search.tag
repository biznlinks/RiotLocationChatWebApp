<imagesearch>

<div id="outer-container">
	<div if={loading} class="modal-body text-xs-center">
		<i class="fa fa-spinner fa-spin fa-3x fa-fw margin-bottom"></i>
		<span class="sr-only">Loading...</span>
	</div>

	<div id="image-search-container" if={ !loading }>
		<input type="text" placeholder="Search" name="imageQuery" oninput={ this.keyUp }>
		<div class="image-grid" if={ !searching && searchResults && searchResults.length > 0 }>
			<div class={ fa:true, fa-chevron-left:searchStart != 0, arrows:true } onclick={ this.shift(-1) }></div>
			<!-- <div class="image-container" onload="fadeIn(e)" each={ image in searchResults.slice(searchStart, searchEnd) } onclick={ this.selectImage(image) } style="background-image: url('{ image.thumbnailUrl }')">
			</div> -->
			<img class="image-container" onload="fadeIn(this)" each={ image in searchResults.slice(searchStart, searchEnd) } onclick={ this.selectImage(image) } src={ image.thumbnailUrl }/>
			<div class={ fa:true, fa-chevron-right:searchEnd < searchResults.length, arrows:true } onclick={ this.shift(1) }></div>
		</div>

		<div class="options" if={ !searchResults || searchResults.length == 0 || searching }>
			<div if={ searching }>
				<i class="fa fa-spinner fa-spin fa-3x fa-fw margin-bottom"></i>
				<span class="sr-only">Loading...</span>
			</div>

			<div if={ !searching }>
				<div>Search for image</div>
				or
			</div>
		</div>

		<div class="upload-container">
			<label for="imageFile"><span class="btn btn-primary">Upload your image</span></label>
			<input name="imageFile" id="imageFile" type="file" style="visibility: hidden; position: absolute;"></input>
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
	self.searching = false
	self.loading   = false


	this.on('mount', function() {
		$('#outer-container').slideUp({duration: 0})
		$('#image-search-container').slideUp({duration: 0})
		$('#image-edit-container').slideUp({duration: 0})

		$(document).on('change', '#imageFile', self.handleUpload)
	})

	this.on('unmount', function() {
		console.log('called')
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
		self.searchStart   = 0
		self.searchEnd     = 3
		self.searching     = true
		self.update()
		self.searchResults = []

		API.searchImage(self.imageQuery.value).then(function(data) {
			// Just get 9 images for now, the query returns 10
			for (var i = 0; i < 9; i++) {
				API.getImageThroughProxy(data[i]).then(function (result) {
					if (result) {
						self.searchResults.push(result)
						self.searching = false
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

	window.fadeIn = function(obj) {
		$(obj).fadeIn({duration: 1000})
	}

	selectImage(image) {
		return function() {
			self.selectedImage = image
			self.update()

			self.hideSearch().then(function(result) {
				self.showEdit().then(function(result) {
					if (!self.cropper) self.createCropper()
					else self.cropper.replace(self.selectedImage.contentUrl)
				})
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
		console.log(self.cropper.getCroppedCanvas({width: 200}))
		self.cropper.getCroppedCanvas({
			width: 800
		}).toBlob(function(blob) {
			self.loading = true
			self.update()
			var imageUrl     = undefined
			var thumbnailUrl = undefined

			API.uploadImage(blob).then(function(result) {
				if (result) {
					imageUrl = result
					if (thumbnailUrl) {
						self.loading = false
						self.callback({contentUrl: imageUrl, thumbnailUrl: thumbnailUrl})
					}
				}
			})

			API.resizeImage(blob).then(function(resized) {
				API.uploadImage(resized).then(function(result) {
					thumbnailUrl = result
					if (imageUrl) {
						self.loading = false
						self.callback({contentUrl: imageUrl, thumbnailUrl: thumbnailUrl})
					}
				})
			})
		})
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
		display: none;
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
		padding-bottom: 10px;
		text-align: center;
		font-size: 26px;
		font-weight: 600;
		color: #bbb;
	}

	.upload-container {
		padding-top: 20px;
	}

	@media screen and (max-width: 543px) {
		.image-container {
			height: 80px;
		}
	}
</style>
</imagesearch>