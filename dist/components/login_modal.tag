<login>

<!-- Modal -->
<div id="loginModal" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<!-- Modal content -->
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">Login</h4>
			</div>

			<div class="modal-body">
				Email: <input type="text" name="email" /> <br/>
				Password: <input type="password" name="password"/> <br/>
				<div name="submit" onclick={ this.submitLogin }>Submit</div>
				<div name="forgotPassword" onclick={ this.forgotPassword }>Forgot Password?</div>
				<div if={ isError }>{ error }</div>
			</div>

			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>

	</div>
</div>

<script>
	var self     = this
	self.isError = false
	self.error   = ""

	this.on('mount', function(){
		$('#loginModal').on('show.bs.modal', function() {
	    	self.track()
		})
		console.log('function called')
	})

	submitLogin() {
		var annonymous     = Parse.User.current().get('username')
		Parse.User.current().logOut()

		Parse.User.logIn(self.email, self.password, {
			success: function(user) {
				$('#loginModal').modal('hide')
			},
			error: function(error) {
				Parse.User.logIn(annonymous, annonymous)
				self.isError = true
				self.error   = error.message
				self.update()
			}
		})
	}

	forgotPassword() {
		$('#loginModal').modal('hide')
		$('#forgotModal').modal('show')
	}

</script>

<style scoped>
:scope{
	text-align: center;
}

</style>

</login>