@extends('frontEnd.layouts.master')
@section('title','Education')
@section('content')
<div class="container-fluid">
		<div class="row">
			<div class="col-lg-2 col-md-2 col-sm-12">
				@foreach($ecategories as $value)
				<div class="esidebar">
					<div class="esidebar-head">
						<p><i class="fa fa-caret-right"></i> {{$value->name}}</p>
					</div>
					<ul>
						@foreach($value->esubcategories as $esubcategory)
						<li><a href="{{url('education-category/'.$esubcategory->slug.'/'.$esubcategory->id)}}">{{$esubcategory->esubname}}</a></li>
						@endforeach
						
					</ul>
				</div>
				@endforeach
				
			</div>
			<div class="col-lg-10 col-md-10 col-sm-12">
				<div class="content">
					<div class="home-banner height66">
						<img src="{{asset('public/frontEnd')}}/images/1024x66banner.jpg" alt="">
					</div>
					<div class="row">
                       @foreach($educations as $value)
					    <div class="col-sm-4">
        					<div class="content-area sub-content edu-thumb">
        						<div class="title">
        							<a href="{{url('education-details/'.$value->slug.'/'.$value->id)}}" style="font-size:18px; font-weight: 800;">{{str_limit($value->title,50)}}</a>
        						</div>
        						<p>{{str_limit($value->description,150)}}</p>
        						<a href="{{url('education-details/'.$value->slug.'/'.$value->id)}}" class="ebtn">Read More</a>
        					</div>
        					<!-- content area -->					    
					    </div>
            			@endforeach
					</div>
				</div>
			</div>
		</div>
	</div>
@endsection