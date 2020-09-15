                @php
				$color = \App\Color::first();
				@endphp

@extends('frontEnd.layouts.master')
@section('title','Post')
@section('content')
<div class="container-fluid">
    
    
    
    
    
    
    
		<div class="row">
			<div class="col-lg-10 col-md-9 col-sm-12">
			    <div class="home-banner">
		@foreach($detailsadone as $value)
		<a href="{{$value->link}}" target="_blank">
			<img class="w-100" src="{{asset($value->image)}}" style="max-height:66px;" alt="">
		</a>
		@endforeach
	</div>
				<div class="content">
					
				    	@php
    					    $memberInfo = App\Member::find($postdetails->memberid);
    					    $postfiles = App\PostFile::where('postId',$postdetails->id)->get();
    					@endphp
					<div class="post-page">
						<div class="post-user">
							<div class="post-user-logo">
								<img src="{{asset($memberInfo->profilepic)}}" alt="">
							</div>
							<div class="post-user-info">
								<p>{{$memberInfo->name}}</p>
								<span>Member</span>
							</div>
						</div>
						<div class="post-main-content" style="overflow:hidden">
							<div class="title">
								<p>{{$postdetails->title}}</p>
							</div>
							<p>{!!$postdetails->description2!!}
							</p>
							<br>
						</div>
						<div class="post-attach-file">
							<div class="title">
								<p>Attached Files:</p>
							</div>
							<div class="attached-file">
								<ul>
								    @foreach($postfiles as $postfile)
									<li>Download:<a href="{{asset($postfile->file)}}" download="{{asset($postfile->file)}}">{{File::name($postfile->file)}}.{{File::Extension($postfile->file)}} </a>
									
									@php
									$files = File::size($postfile->file)/1000;
									echo number_format("$files");
									@endphp																		
									Kb
									
									</li>
								   @endforeach
								</ul>
							</div>
						<span style="color:{{$color->post_author}}">  Posted By {{$memberInfo->name}}
					  : {{date('d F, Y', strtotime($postdetails->created_at))}}</span>	
						</div>						
					</div>
					<!-- content area -->
					<div class="related-post-area">
							<div class="row">
								<div class="col-sm-12">
									<div class="related-post-title">
										<h5>Related Article</h5>
									</div>
								</div>
							</div>
							<div class="row">
							    @foreach($relatedposts as $key=>$value)
								<div class="col-xl-4 col-md-4">
									<div class="related-post">
										<div class="title" style="height: 20px; overflow: hidden">
											<h6><a href="{{url('post/'.$value->slug.'/'.$value->id)}}">{!!str_limit($value->title,99999)!!}</a></h6>
										</div>
										
										<div class="rp-content" style="height: 50px; overflow: hidden">
											<p>{!!str_limit(strip_tags($value->description2),99999)!!} </p>
										</div>
										
									</div>
								</div>
								@endforeach
							</div>
					</div>
					<br>
					<div class="home-banner">
						@foreach($detailsadbottom as $value)
						<a href="{{$value->link}}" target="_blank">
    						<img class="w-100" src="{{asset($value->image)}}" style="max-height:66px;" alt="">
    					</a>
						@endforeach
					</div>
					
					
					<div class="postcomment">
					    <h5 style="margin-bottom:15px">Post your comment</h5>
					    <form action="{{url('member/post/comment')}}" method="POST" enctype="multipart/form-data">
					        @csrf
					        <input type="hidden" value="{{$postdetails->id}}" name="hidden_id">
					        <div class="form-group">
					            <textarea class="form-control tinymce-for-comment" name="comment" placeholder="Your Comment"></textarea>
					        </div>
					        
					       <div class="form-group">
					            <input type="file" name="file[]" class="form-control">
                          <div class="clone hide" style="display: none;">
                                  <div class="control-group input-group" >
                                    <input type="file" name="file[]" class="form-control">
                                    <div class="input-group-btn"> 
                                      <button class="btn btn-danger" id="comment-file-remove" type="button"><i class="fa fa-trash"></i></button>
                                    </div>
                                  </div>
                                </div>
                           <div class="input-group control-group comment-increment">
                                  <div class="input-group-btn"> 
                                  <div class="spacer" style="padding-bottom:10px"></div>
                                    <button class="btn btn-success" id="comment-file-add" type="button"><i class="fa fa-plus"></i> Add more file</button>
                                  </div>
                                </div>                                    
                            </div>  
                            
                            
					        <div class="form-group">
					            <input type="submit" class="btn btn-primary" value="Submit">
					        </div>
					    </form>
					</div>
					<!-- realated post end -->
					<div class="post-comment-area">
					    @foreach($postcomments as $postcomment)
					    @php
					        $cmemberInfo = App\Member::find($postcomment->memberid);
					        $cattachements = App\CommentFile::where('commentId',$postcomment->id)->get();
					    @endphp
						<div class="single-post-comment">
							<div class="comment-user">
								<div class="cuser-logo">
									<img src="{{asset($cmemberInfo->profilepic)}}" alt="">
								</div>
								<div class="cuser-link">
									<p>member</p>
									<a href="">{{$cmemberInfo->name}}</a>
								</div>
							</div>
					
					        
					
							<div class="post-comment row">
								<div class="col-sm-11">
								    @php
								        $replaycomments = App\CommentReplay::where('commentId',$postcomment->id)->get();
								    @endphp
								    @foreach($replaycomments as $replaycomment)
    								    
    								    @php
    								        $replayattachs = App\CommentReplayFile::where('commentId',$replaycomment->id)->get();
    								        $replaymember = App\Member::find($replaycomment->memberid);
    								    @endphp
    								    
								    <div class="replay-one">
    									<p><i>{{$replaymember->name}} said:</i></p>
    									<p>{{$replaycomment->comment}}</p>
    									<div class="attached-file">
    										<ul>
    										    
    											@foreach($replayattachs as $replayattach)
            								    	<li>Download:<a href="{{asset($replayattach->file)}}" download="{{asset($replayattach->file)}}">{{File::name($replayattach->file)}}.{{File::Extension($replayattach->file)}}</a>
													
									@php
									$files = File::size($replayattach->file)/1000;
									echo number_format("$files");
									@endphp																		
									Kb
													
													</li>
            									@endforeach
    										</ul>
    									</div>
    								</div>
    								@endforeach
								    <p>{!!$postcomment->comment!!}</p>
    								@if($cattachements->count()!=0)
    								<div class="post-attach-file replay-two">
    									<div class="title">
    										<p>Attached Files:</p>
    									</div>
    									<div class="attached-file">
    										<ul>
    											@foreach($cattachements as $cattachement)
            								    	<li>Download:<a href="{{asset($cattachement->file)}}" download="{{asset($cattachement->file)}}">{{File::name($cattachement->file)}}.{{File::Extension($cattachement->file)}}</a>
									@php
									$files = File::size($cattachement->file)/1000;
									echo number_format("$files");
									@endphp																		
									Kb</li>
            									@endforeach
    										</ul>
    									</div>
    								</div>
    								@else
    								<div class="height-gap"></div>
    								@endif
								</div>
								<div class="col-sm-1">
								    <button data-toggle="modal" data-target="#replayModal{{$postcomment->id}}" class="text-info">Replay</button>
								    <div class="mt-2">
								        <form action="/member/post/comment/edit" method="post">
    								        @csrf
    								        <input type="hidden" name="comment_owner_id" id="comment_owner_id" value="{{$cmemberInfo->id}}">
    								        <input type="hidden" name="commentId" id="commentId" value="{{$postcomment->id}}">
    								        <input type="hidden" name="post_id" id="post_id" value="{{$postdetails->id}}">
    								        <button type="submit">Delete</button>
    								    </form>
								    </div>
								    </div>
								    <div class="mt-2">
    								    <form action="/member/post/comment/delete" method="post">
    								        @csrf
    								        <input type="hidden" name="comment_owner_id" id="comment_owner_id" value="{{$cmemberInfo->id}}">
    								        <input type="hidden" name="commentId" id="commentId" value="{{$postcomment->id}}">
    								        <button type="submit">Delete</button>
    								    </form>
								    </div>
								</div>
								
								<!-- Modal -->
                                    <div id="replayModal{{$postcomment->id}}" class="modal fade replaymodal" role="dialog">
                                      <div class="modal-dialog">
                                    
                                        <!-- Modal content-->
                                        <div class="modal-content">
                                          <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                          </div>
                                          <div class="modal-body">
                                             <form action="{{url('member/post/comment-replay')}}" method="POST" enctype="multipart/form-data">
                    					        @csrf
                    					        <input type="hidden" value="{{$postcomment->id}}" name="hidden_id">
                    					        <div class="form-group">
                    					            <textarea class="form-control tinymce-for-comment" name="comment" placeholder="Your Comment"></textarea>
                    					        </div>
                    					        <div class="form-group" >
					                                <input type="file" name="file[]" class="form-control" >
                                                    <div class="clone hide" style="display: none;">
                                                        <div class="control-group input-group" id="comment-file-upload">
                                                            <input type="file" name="file[]" class="form-control">
                                                            <div class="input-group-btn"> 
                                                                <button class="btn btn-danger" id="reply-comment-file-remove" type="button"><i class="fa fa-trash"></i></button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="input-group control-group reply-comment-increment">
                                                    <div class="input-group-btn"> 
                                                    <div class="spacer" style="padding-bottom:10px"></div>
                                                    <button class="btn btn-success" id="reply-comment-file-add" type="button"><i class="fa fa-plus"></i>Add more file</button>
                                                    </div>
                                                    </div>                                    
                                                </div>  
                    					        <div class="form-group">
                    					            <input type="submit" class="btn btn-primary" value="Submit">
                    					        </div>
                    					    </form>
                                          </div>
                                        </div>
                                    
                                      </div>
                                    </div>
                                  
                          <span style="color:{{$color->post_author}}"> {{$cmemberInfo->name}}
					  : {{date('d F, Y', strtotime($postcomment->created_at))}}</span>	  
                                    
							</div>
						</div>
						@endforeach
						<!-- comment item end -->
					</div>
					{{ $postcomments->links() }}
						<br><br>
				</div>
			</div>
		
			<div class="col-lg-2 col-md-3 col-sm-12">
				<div class="esidebar">
					<div class="submit-strategy">
						<a href="{{url('/strategies')}}">submit {{$category->name}}</a>
					</div>
					<div class="esidebar-banner">
						@foreach($detailsadtwo as $value)
						<a href="{{$value->link}}" target="_blank">
    						<img src="{{asset($value->image)}}" alt="">
    					</a>
						@endforeach
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
	<script type="text/javascript">
    $(document).ready(function() {
        
       

      $("#comment-file-add").click(function(){ 
          var html = $(".clone").html();
          $(".comment-increment").before(html);
      });

      $("body").on("click","#comment-file-remove",function(){ 
          $(this).parents(".control-group").remove();
      });
      $("#reply-comment-file-add").click(function(){ 
          var html = $(".clone").html();
          $(".reply-comment-increment").before(html);
      });

      $("body").on("click","#reply-comment-file-remove",function(){ 
          $(this).parents(".control-group").remove();
      });
    });
    </script>
    
@endsection