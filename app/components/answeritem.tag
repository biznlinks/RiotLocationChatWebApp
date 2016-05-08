<answeritem>
	<div class="row">
		<div class="col-xs-1">
			<img src = "{this.getProfilePic()}" class = "profile img-circle"></img>
		</div>
		<div class="col-xs-11" >
			<span class="author">{answer.get('author').get('firstName')} {answer.get('author').get('lastName')}</span> 
			<span>
				{answer.get('answer')}
			</span>
		</div>
	</div>

	<script>
		var self = this
		this.answer = opts.answer



		this.on('update', function() {
			console.log(this.answer);
			answer = this.answer
		})

		getProfilePic(){
			var author= self.answer.get('author')
			if (author.get('profilePic')){
				profilePic = author.get('profilePic').url()
				if (profilePic){
					return profilePic
				}
			}else {
				return 'https://files.parsetfss.com/135e5227-e041-4147-8248-a5eafaf852ef/tfss-6f1e964e-d7fc-4750-8ffb-43d5a76b136e-kangdo@umich.edu.png'
			}
		}

	</script>


	<style scoped>
		:scope {
			font-family: helvetica, arial, sans-serif;
			font-size: small;
			color: black;
			font-weight: normal

		}
		.row{
			margin-bottom: 10px;
		}
		.author{
			font-weight: bold;
		}
		.profile {
			width: 30px;
			height: 30px;
			margin-right: 10px;
		}


		@media (min-width: 480px) {
			:scope {
				/*margin-right: 200px;*/
				margin-bottom: 0;
			}
		}
	</style>
</answeritem>