<signup>
<!--  <button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#signupModal">Open Modal</button>
 -->
<!-- Modal -->
<div id="signupModal" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Join Sophus!</h4>
      </div>
      <div class="modal-body">
        <div class="info-btns">
        <ul>
          <li><a name="ios" onclick={clicked} href="https://itunes.apple.com/us/app/sophus/id958351164?mt=8&uo=4" target="itunes_store"> </a></li>
          <li><a name="android" onclick={clicked} href="https://play.google.com/store/apps/details?id=com.sophusapp.sophus&hl=en" target="google_play_store"> </a></li>
        </ul>
      </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>

<script>
self=this

this.on('mount', function(){
  $('#signupModal').on('show.bs.modal', function() {
        self.track()
    })
})
  

  clicked(e){
   self.track(e.target.name)
   window.open(e.target.href, e.target.target);
  }
</script>

<style scoped>
:scope{
  text-align: center;
}

/*---dowload buttons-----*/
.info-btns{
  margin-top: 1.3em;
}

.info-btns ul{
  padding: 0;
}

.info-btns ul li{
  display:inline-block;
}
.info-btns ul li:first-child{
  margin:0.5em;
}

.info-btns ul li:nth-child(2){
  margin:0.5em;
}

.info-btns ul li:first-child a{
  width: 170px;
  height: 50px;
  display: block;
  background: url(/images/apple_badge.png) no-repeat #F2F4F5;
}
.info-btns ul li:nth-child(2) a{
  width: 150px;
  height: 50px;
  display: block;
  background: url(../images/google_play_badge.png) no-repeat;
}

</style>

</signup>