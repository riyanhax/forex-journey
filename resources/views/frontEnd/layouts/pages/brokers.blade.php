                @php
				$color = \App\Color::first();
				@endphp

@extends('frontEnd.layouts.master')
@section('title','Top & Best Forex Brokers Reviews | Journey Forex')
@section('description', 'Journey Forex brokers reviews offer the best and top broker platforms for all type of Forex traders.')
@section('keywords', 'Top & Best Forex Brokers Reviews, Journey Forex,')
@section('content')
<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12 col-md-12 col-sm-3 col-xs-3">
				<div class="brokers-content">
					<div class="brokers-head" style="background-image: linear-gradient({{$color->title_background}}, {{$color->title_background2}})">
						<p>all forex brokers</p>
					</div>
					<div class="clearfix"></div>
					<div class="brokers-table table-responsive">
						<table id="example" class="table table-striped   custom-table">
							<thead style="background-color:{{$color->revtable_background}}">
								<tr>
									<th>Brokers</th>
									<th>Name</th>
									<th>Min. Deposit</th>
									<th>Min. Spread</th>
									<th>Max. Leverage</th>
									<th>Regulation</th>
									<th>Established</th>
									<th>Headquarter</th>
									<th>Review</th>
								</tr>
							</thead>
							<tbody>
								@foreach($brokers as $value)
								<tr>
									<td>
									    <a href="{{$value->visitlink}}" target="_blank"><img src="{{asset($value->image)}}" alt=""></a>
									</td>
									<td>
									    <a href="{{$value->visitlink}}" target="_blank"><span style="color: rgb(44, 130, 201);"><u>{{$value->broker_name}}</u></span></a>
									</td>
									<td>{{$value->mindiposit}}</td>
									<td>{{$value->minspread}}</td>
									<td>{{$value->maxleverage}}</td>
									<td>{{$value->regulatedby}}</td>
									<td>{{$value->established}}</td>
									<td>{{$value->headquater}}</td>
									<td>
									    <a href="{{$value->reviewlink}}" class="broker-review" target="_blank"><span style="color: rgb(44, 130, 201);"><u>Review</u></span></a>
									</td>

								</tr>
								@endforeach
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
@endsection