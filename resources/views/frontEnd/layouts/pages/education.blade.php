                @php
				$color = \App\Color::first();
				@endphp

@extends('frontEnd.layouts.master')
@section('title','Education | Journey Forex')
@section('content')
<div class="container-fluid">
		<div class="row">
			<div class="col-lg-3 col-md-3 col-sm-12">
				@foreach($ecategories as $value)
				@php
				    $posts = App\Education::where(['ecategory_id'=>$value->id,'status'=>1])->get();
				@endphp
				<div class="esidebar">
					<div class="esidebar-head" style="background-color:{{$color->edutitle_background}}">
						<p><span style="color:{{$color->edu_font}};font-size:{{$color->edumenu_font}}px"><i class="fa fa-caret-right"></i> {{$value->name}}</span></p>
					</div>
					<ul style="background-color:{{$color->edusub_background}}">
					@foreach($posts as $key=>$value)
						<li>
		<a href="{{URL::to(''. rtrim($value->slug, "?").'/education-details/'.$value->id)}}"><span style="color:{{$color->dtex_color}};font-size:{{$color->edumenu_font}}px"><small><b>{{str_limit($value->title,99999)}}</b></small></span></a>
		</li>
					@endforeach
					</ul>
				</div>
				@endforeach
				
			</div>
			<div class="col-lg-9 col-md-9 col-sm-12">
				<div class="content">
					<div class="home-banner height66 mb-3">
						@foreach($educationadone as $value)
						<a href="{{$value->link}}" target="_blank">
						   <img class="w-100" src="{{asset($value->image)}}" alt="">
						 </a>
						@endforeach
					</div>
                    @foreach($educations as $value)
    					<div class="content-area sub-content edu-thumb">
    						<div class="title">
    							<p>{{str_limit($value->title,50)}}</p>
    						</div>
    						<p>{{$value->description}}
    						{!! $value->description2 !!}</p>
    					</div>
    					<!-- content area -->
        			@endforeach
        			<div class="home-banner height66">
						@foreach($educationbottom as $value)
						<a href="{{$value->link}}" target="_blank">
						   <img class="w-100" src="{{asset($value->image)}}" alt="">
						 </a>
						@endforeach
					</div>
				</div>
			</div>
		</div>
	</div>
@endsection