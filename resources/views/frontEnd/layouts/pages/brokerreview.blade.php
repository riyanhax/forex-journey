@extends('frontEnd.layouts.master')
@section('title', $brokersreview->title)
@section('content')
<!-- content area start -->
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-10 col-md-9 col-sm-12">
				<div class="content">
					<div class="home-banner height-66">
					    @foreach($brokertop as $value)
						 <a href="{{$value->link}}" target="_blank">
						   <img class="w-100" src="{{asset($value->image)}}" alt="">
						 </a>
						@endforeach
					</div>
					<div class="review-page">
						<div class="title">
							<p style="padding:15px;font-size:30px">{{$brokersreview->title}}</p>
						</div>
						<div class="review-table">
							<table id="example" class="table table-striped table-bordered broker-review-table" style="width:100%">
                                

                               
                                     @foreach($reviewlists as $reviewlist)
									<tr>
										<td>{{$reviewlist->actype}}</td>
										<td>{{$reviewlist->spreadform}}</td>
										<td>{{$reviewlist->commision}}</td>
										<td>{{$reviewlist->execution}}</td>
										<td>{{$reviewlist->mindiposit}}</td>
										<td><a href="{{$reviewlist->chooseacount}}"  class="chosse-acount" target="_blank">Choose Account</a></td>
									</tr>
									@endforeach
                                
                            </table>
						<div class="post-main-content">

							<p style="padding:0px;font-size:20px">{!!$brokersreview->description!!}</p>
						</div>
					</div>
				</div>
				<!-- content area -->
				</div>
				<br>
				<div class="home-banner height-66">
					    @foreach($brokerbottom as $value)
						 <a href="{{$value->link}}" target="_blank">
						   <img class="w-100" src="{{asset($value->image)}}" alt="">
						 </a>
						@endforeach
					</div>
			</div>
			<div class="col-lg-2 col-md-3 col-sm-12">
				<div class="small-banner">
				    @foreach($brokercorner as $value)
					<a href="{{$value->link}}" target="_blank">
						<img src="{{asset($value->image)}}" style="max-height:120px;" alt="">
					</a>
					@endforeach
				</div>
				<div class="esidebar-banner sticky-top">
					@foreach($brokerright as $value)
					<a href="{{$value->link}}" target="_blank">
						<img src="{{asset($value->image)}}" alt="">
					</a>
					@endforeach
				 </div>
			</div>
		</div>
	</div>
	<br><br><br>
@endsection