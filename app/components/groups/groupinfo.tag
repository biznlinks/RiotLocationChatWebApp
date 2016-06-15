<groupinfo>

<div>
	<div class="group-info">
		<div if={loading} class="modal-body text-xs-center">
			<i class="fa fa-spinner fa-spin fa-3x fa-fw margin-bottom"></i>
			<span class="sr-only">Loading...</span>
		</div>
		<div if={!loading}>
			<div id="group-pic" if={ !uploadedFile } style="background-image: url('{ API.getGroupImage(containerTag.group) }')">
				<label for="change-group-pic" class="edit-button btn btn-primary fa fa-pencil"></label>
				<input id="change-group-pic" type="file" style="visibility: hidden; position: absolute;"></input>
			</div>
			<div if={ uploadedFile }>
				<img id="uploaded-image" src={ URL.createObjectURL(uploadedFile) }>
				<button class="btn btn-default fa fa-rotate-left" onclick={ this.rotate(-90) }></button>
				<button class="btn btn-default fa fa-rotate-right" onclick={ this.rotate(90) }></button>
				<button class="btn btn-default" onclick={ this.cropAndUpload }>OK</button>
			</div>
		</div>
		<div class="group-name">{ containerTag.group.get('name') }</div>
		<div class="members text-muted">{ locale } • { containerTag.group.get('memberCount') } joined</div>
		<div class="group-desc">{ containerTag.group.get('description') }</div>
	</div>
</div>


<script>
	var self = this
	self.locale = ''

	this.on('mount', function() {
		$(document).on('change', '#change-group-pic', self.handleUpload)
	})

	init() {
		API.getusercity(containerTag.group.get('location')).then(function(result) {
			self.locale = result
			self.update()
		})
	}

	handleUpload() {
		self.uploadedFile = $('#change-group-pic')[0].files[0]
		self.update()

		self.createCropper()
	}

	uploadImage(file) {
		var serverUrl = 'https://api.parse.com/1/files/' + file.name

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
							containerTag.group.set('imageUrl', data.url)
							containerTag.group.save(null, {
								success: function(group) {
									self.loading = false
									self.uploadedFile = undefined
									self.update()
								}, error: function(group, error) {}
							})

						},
						error: function(data) {
						}
					});
				}
			}
			image.src = URL.createObjectURL(file)
	}

	createCropper() {
		var image = document.getElementById('uploaded-image')
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

	.group-info {
		margin-top: 5px;
		padding: 10px;
		border-bottom: 1px solid #ccc;
	}

	#group-pic {
		width: 100%;
		height:300px;
		object-fit: cover;
		background-position: 50% 30%;
		position: relative;
	}

	#uploaded-image {
		width: 100%;
		height: 300px;
	}

	.edit-button {
		position: absolute;
		bottom: 0;
		right: 0;
		margin-bottom: 0;
	}

	.group-name {
		font-size: x-large;
		font-weight: bolder;
	}

	.members {
		margin-bottom: 10px;
	}

	.group-desc {
		padding: 10px;
		font-size: large;
	}
</style>
</groupinfo>