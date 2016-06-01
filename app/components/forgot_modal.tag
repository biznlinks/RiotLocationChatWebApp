<forgot>

<!-- Modal -->
<div id="forgotModal" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<!-- Modal content -->
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">Password Reset</h4>
			</div>

			<div class="modal-body">
				<form if={ !success }>
					<div class="input-group">
						<span class="input-group-addon"><i class="fa fa-envelope-o fa-fw"></i></span>
						<input type="text" class="form-control" name="email" placeholder="Email" />
					</div>

					<br/>
					<button class="btn btn-sm" name="submit" onclick="{ this.submitForgot }">Submit</button>
					<div class="text-warning info" if={ isError }>{ error }</div>
				</form>
				<div class="text-muted" name="successMsg" if={ success }>
					Successfully reset your password, please check your email
				</div>
			</div>
		</div>

	</div>
</div>


<script>

	var self     = this
	self.success = false
	self.isError = false
	self.error   = ""

	this.on('mount', function() {
		$('#forgotModal').on('hidden.bs.modal', function () {
			self.isError     = false
			self.error       = ""
			self.email.value = ""
			self.update()
		})
	})

	submitForgot(){
		var userEmail = self.email.value
		Parse.User.requestPasswordReset(userEmail, {
			success: function(user) {
				self.success = true
				self.update()
			},
			error: function(error) {
				self.isError = true
				self.error   = "Invalid email"
				self.update()
			}
		})
	}

</script>

<style scoped>
	:scope{
		text-align: center;
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

	.inline {
		display: inline-block;
	}

	.info {
		margin-top: 7px;
	}
</style>

</forgot>