<groupslist>

<div if={ joinedGroups.length > 0 }>
	<div class="title">
		Joined
	</div>

	<!-- Swiper -->
	<div class="swiper-container">
	    <div class="swiper-wrapper">
	        <div class="swiper-slide" each={ group in joinedGroups} onclick={ this.chooseGroup(group.get('group')) }>
					<img src={ API.getGroupThumbnail(group.get('group')) } class="image-joined">
					<div class="group-title">
						{ group.get('group').get('name').slice(0,20) }
						<span if={ group.get('group').get('name').length > 20 }>...</span>
					</div>
				</div>
	    </div>
	</div>

</div>
<div if={ joinedGroups.length > 0 }>
	<hr>
</div>
<div class="title">
	Nearby
</div>
<div class="nearby">
	<ul>
		<li each={ group in groups } onclick={ this.chooseGroup(group) }>
			<div class="pointer">
				<img src={ API.getGroupThumbnail(group) } class="image-nearby img-circle">
				<div class="info-box">
					<div class="group-title">{ group.get('name') }</div>
					<div class="desc">{ group.get('description') }</div>
				</div>
			</div>
		</li>
	</ul>
</div>


<script>
	var self = this
	self.joinedGroups = opts.joinedGroups
	self.groups = opts.groups

	this.on('mount', function() {
	})

	createSwiper() {
		var swiper = new Swiper('.swiper-container', {
	        slidesPerView: 2.1,
	        spaceBetween: 20,
	        freeMode: true
	    });
	}

	chooseGroup(group) {
		return function() {
			containerTag.group = group
			riot.route(encodeURI(group.get('groupId')))
			self.update()
		}
	}

	shiftLeft() {
		self.joinedEnd = self.joinedStart
		self.joinedStart -= self.joinedLength
		self.update()
	}

	shiftRight() {
		self.joinedStart = self.joinedEnd
		self.joinedEnd += self.joinedLength
		self.update()
	}
</script>

<style scoped>
	.row > * {
		padding: 0;
	}

	.title {
		font-size: 18px;
		font-weight: lighter;
		padding: 10px 10px;
		padding-top: 20px;
	}

	.arrow {
		padding-top: 30px;
		padding-bottom: 70px;
	}

	.fa-chevron-right {
		text-align: center;
	}
	.fa-chevron-left {
		text-align: center;
	}

	.tile {
		vertical-align: top;
		text-align: center;
		display: inline-block;
	}

	.nearby li {
		padding-top: 20px;
		padding-bottom: 20px;
	}

	.nearby ul {
		list-style: none;
		margin-bottom: 0;
		padding: 0;
	}

	.image-container {
		text-align: center;
	}

	.image-joined {
		width: 100%;
		height: calc(100% - 30px);
	}

	.image-nearby {
		height: 60px;
		width: 60px;
		object-fit: cover;
		margin: auto 10px;
	}

	.gray {
		border: none;
		background-image: url('/images/default_image.jpg');
		background-size: cover;
	}

	.nearby .group-title {
		margin-top: 0;
	}

	.info-box{
		display: inline-block;
		vertical-align: middle;
		width: calc(100% - 100px);
		display: inline-block;
		border-bottom: 1px solid #ccc;
		padding-top: 20px;
		padding-bottom: 20px;
	}

	.group-title {
		margin-top: 10px;
		font-size: 14px;
		font-weight: 500;
	}

	.desc{
		font-size: 12px;
	}

	@media (max-width: 480px) {
		.group-title > * {
			font-size: 12px;
		}
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

	.swiper-container {
		height: initial;
        margin: 20px auto;
    }
    .swiper-slide {
        text-align: center;
        font-size: 18px;
        background: #fff;

        /* Center slide text vertically */

        -webkit-box-pack: center;
        -ms-flex-pack: center;
        -webkit-justify-content: center;
        justify-content: center;
        -webkit-box-align: center;
        -ms-flex-align: center;
        -webkit-align-items: center;
        align-items: center;
    }

</style>
</groupslist>