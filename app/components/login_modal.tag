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
				<form>
					<div class="input-group">
						<span class="input-group-addon"><i class="fa fa-envelope-o fa-fw"></i></span>
						<input type="text" class="form-control" name="email" placeholder="Email" />
					</div>
					<div class="input-group">
						<span class="input-group-addon"><i class="fa fa-key fa-fw"></i></span>
						<input type="password" class="form-control" name="password" placeholder="Password" />
					</div>

					<br/>
					<button class="btn btn-sm" name="submit" onclick={ this.submitLogin }>Submit</button>
					<div class="text-warning info" if={ isError }>{ error }</div>
				</form>

				<div class="facebook-option">
					<button class="btn btn-default btn-primary" onclick={ this.submitFacebook }>
						<i class="fa fa-facebook-f" id="facebook-logo"></i> Log in with Facebook
					</button>
				</div>
				<div class="info">
					or
					<div class="text-info pointer inline" onclick={ this.showSignup }>Sign Up</div> |
					<div class="text-info pointer inline" onclick={ this.forgotPassword }>Reset Password</div>
				</div>

				<!-- <div class="info">
					Forgot Password?
					<div class="text-info pointer inline" name="forgotPassword" onclick={ this.forgotPassword }>Reset</div>
				</div>
				<div class="info">
					Don't have an account?
					<div class="text-info pointer inline" name="signup" onclick={ this.showSignup }>Sign Up</div>
				</div> -->
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

		$('#loginModal').on('hidden.bs.modal', function () {
			self.isError        = false
			self.error          = ""
			self.email.value    = ""
			self.password.value = ""
			self.update()
		})
	})

	submitLogin() {
		var annonymous     = Parse.User.current().get('username')
		Parse.User.logOut()

		Parse.User.logIn(self.email.value, self.password.value, {
			success: function(user) {
				$('#loginModal').modal('hide')
				$('#loginSuccess').show()
				self.parent.update()
			},
			error: function(user, error) {
				Parse.User.logIn(annonymous, annonymous, {
					success: function(user) {
					},
					error: function(error) {
					}
				})
				self.isError = true
				self.error   = "Incorrect email or password"
				self.update()
			}
		})
	}

	submitFacebook() {
		Parse.FacebookUtils.link(Parse.User.current(), 'public_profile, email, user_friends', {
			success: function(user) {
				FB.api('/me?fields=first_name, last_name, picture, email, friends', function(response) {
					Parse.User.current().set('firstName', response.first_name)
					Parse.User.current().set('lastName', response.last_name)
					Parse.User.current().set('email', response.email)
					Parse.User.current().set('username', response.email)
					Parse.User.current().set('profileImageURL', response.picture.data.url)
					Parse.User.current().set('friends', response.friends.data)
					Parse.User.current().set('type', 'actual')
					Parse.User.current().save(null, {
						success: function(user) {
							$('#loginModal').modal('hide')
							$('#signupSuccess').show()
						},
						error: function(user, error) {
							self.isError = true
							self.error = error.message
							self.update()
						}
					})
				})
			},
			error: function(user, error) {
				if (error.code == 208) {		// User has already signed up with Facebook
					Parse.FacebookUtils.logIn('public_profile, email, user_friends', {
						success: function(user) {
							$('#loginModal').modal('hide')
							$('#loginSuccess').show()
						},
						error: function(user, error) {
							self.isError = true
							self.error = error.message
							self.update()
						}
					})
				} else {
					self.isError = true
					self.error = error.message
					self.update()
				}
			}
		})
	}

	forgotPassword() {
		$('#loginModal').modal('hide')
		$('#forgotModal').modal('show')
	}

	showSignup() {
		$('#loginModal').modal('hide')
		$('#signupModal').modal('show')
	}

</script>

<style scoped>
	:scope{
		text-align: center;
	}

	.facebook-option {
		margin-top: 20px;
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

	.input-group {
		margin-top: 7px;
	}

	.info {
		margin-top: 20px;
		margin-bottom: 10px;
	}
</style>

</login>