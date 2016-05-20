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
				<div name="form" if={ !success }>
					Email: <input type="text" name="email" /> <br/>
					<div name="submit" onclick="{ this.submitForgot }">Submit</div>
					<div if={ isError }>{ error }</div>
				</div>
				<div name="successMsg" if={ success }>
					Successfully reset your password, please check your email
				</div>
			</div>

			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>

	</div>
</div>


<script>

	var self     = this
	self.success = false
	self.isError = false
	self.error   = ""

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

</style>

</forgot>