<ask>
<!-- <button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#askModal">Ask a new Question</button> -->
<!-- Modal -->
<div id="askModal" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <!-- <h4 class="modal-title">Ask a new Question!</h4> -->
      </div>
      <div class="modal-body">
        <div class="info-btns">
        <search></search>
      </div>
      </div>
      <div class="modal-footer text-xs-center">
        <button type="button" class="btn btn-default" onclick={createQuestion}>Ask a new question</button>
      </div>
    </div>

  </div>
</div>

<script>
  this.on('mount', function(){
    
  })
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

</ask>