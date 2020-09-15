                @php
				$color = \App\Color::first();
				@endphp

@extends('frontEnd.layouts.master')
@section('title', $educationdtails->title)
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
					<ul style="background-color:{{$color->edusub_background}}" class='navlinks'>
					@foreach($posts as $key=>$value)
				    	<li>
		<a href="{{URL::to(''.rtrim($value->slug, "?").'/education-details/'.$value->id )}}"><span style="color:{{$color->dtex_color}};font-size:{{$color->edumenu_font}}px"><small><b>{{str_limit($value->title,40)}}</b></small></span></a></li>
					@endforeach
					</ul>
				</div>
				@endforeach
			</div>
		<div class="col-lg-9 col-md-9 col-sm-12">
				<div class="content" id="myDIV">
					<div class="home-banner height66 mb-2">
					    @foreach($edetailsad as $value)
						<a href="{{$value->link}}" target="_blank">
						        <img class="w-100" src="{{asset($value->image)}}" alt="">
						    </a>
						@endforeach
					</div>
					<div class="content-area sub-content">
						<div class="title">
							<a style="font-size:18px; font-weight: 800;">{{$educationdtails->title}}</a>
						</div>
			<p>{{$educationdtails->description}} {!! $educationdtails->description2 !!}</p>
					</div>
				<div class="home-banner height66 mt-3">
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
	
	
	
	
<script>
    let ul = document.getElementsByClassName('navlinks');
    for (let i=0; i<ul.length;i++){
    
        let links = ul[i].getElementsByTagName('li');
        let thisAddress = window.location.href;
        for (let i = 0; i < links.length; i++) {
            let atag = links[i].getElementsByTagName('a');
            let mayBeThisLocation = atag[0].getAttribute('href');
           
            if (thisAddress == mayBeThisLocation) {
                console.log(atag[0].getAttribute('href'));
                links[i].classList.add('active');
                let spanTag = atag[0].getElementsByTagName('span');
                spanTag[0].style.color = 'white';
            }
        
        }
    }
</script>
@endsection