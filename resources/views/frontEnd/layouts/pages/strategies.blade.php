             	@php
				$color = \App\Color::first();
				@endphp

@extends('frontEnd.layouts.master')
@section('title','Strategies | Journey Forex')
@section('content')
<!-- content area start -->
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-10 col-md-9 col-sm-12">
				<div class="content">
					<div class="home-banner height66 mb-2">
						@foreach($strategiestop as $cadone)
						<a href="{{$cadone->link}}" target="_blank">
    						<img class="w-100" src="{{asset($cadone->image)}}" alt="">
    					</a>
						@endforeach
					</div>
					<div class="content-area">
						<div class="content-head" style="background-image: linear-gradient({{$color->title_background}}, {{$color->title_background2}})">
							<div class="row" style="background-image: linear-gradient({{$color->title_background}}, {{$color->title_background2}}); margin-right:15px;margin-left:15px">
								<div class="col-sm-6">
									<div class="content-head-left">
										<h6>Title</h6>
									</div>
								</div>
								<div class="col-sm-6">
									<div class="content-head-right">
										<h6>Description  Preview</h6>
									</div>
								</div>
							</div>
						</div>
						    @php
    						    $allposts = App\Post::where('category', 1)->orderBy('created_at','DESC')->paginate(20);
    						@endphp
						
						@foreach($allposts as $value)
						    @php
    						    $findMember = App\Member::where('id',$value->memberid)->first();
    						@endphp

						<div class="content-item">
							<div class="row">
								<div class="col-md-1 col-sm-2 col-12">
									<div class="content-img">
										<img src="{{asset($findMember->profilepic)}}" alt="">
									</div>
								</div>
								<div class="col-md-5 col-sm-5 col-12">
									<div class="content-title">
									    <div style="height: 25px; overflow: hidden">
									<a href="{{url(''.$value->slug.'/'.$value->id)}}">
										<span style="color:{{$color->title_color}};font-size:{{$color->title_font}}px">{!! str_limit($value->title,99999) !!}</span>
										</a>
										</div>
										<small><span style="color:{{$color->post_author}}">Posted by {{$findMember->name}}</span></small>
									</div>
								</div>
								<div class="col-md-6 col-sm-5 col-12">
									<div class="content-description" style="height: 50px; overflow: hidden">
										<p style="font-size:{{$color->descrip_preview}}px">{!! str_limit(strip_tags($value->description2),99999) !!}</p>
									</div>
								</div>
							</div>
						</div>
						@endforeach
						<!-- content item end -->
					</div>

					<div class="custom-paginate">
					    {{$allposts->links()}}
					</div>
						<br>
				    <div class="home-banner height66">
						@foreach($strategiesbottom as $cadone)
						<a href="{{$cadone->link}}" target="_blank">
    						<img class="w-100" src="{{asset($cadone->image)}}" alt="">
    					</a>
						@endforeach
					</div>
				</div>
			</div>
			<div class="col-lg-2 col-md-3 col-sm-12">
				<div class="esidebar d-inline">
					<div class="submit-strategy">
						<a href="{{url('member/post/create')}}">Share Your strategies</a>
					</div>
					<div class="esidebar-banner sticky-top">
						@foreach($strategiesright as $value)
						<a href="{{$value->link}}" target="_blank">
    						<img class="" src="{{asset($value->image)}}" alt="">
    					</a>
						@endforeach
					</div>
				</div>
			</div>
		</div>
	</div>
		<br><br><br>
@endsection