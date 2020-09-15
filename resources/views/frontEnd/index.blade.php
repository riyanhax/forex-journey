                @php
				$color = \App\Color::first();
				@endphp

@extends('frontEnd.layouts.master')
@section('title','Journey Forex | Trading Strategies, Market Analysis & Trading Tools')
@section('description', 'Journey Forex is the best free discussion community for trading market that covering Forex education, broker reviews, strategies, indicators, expert advisors & market analysis.')
@section('keywords', 'Trading Strategies, Market Analysis, Trading Tools')
@section('content')
<div class="container-fluid">

		<div class="row">
		    
			<div class="col-lg-7 col-md-7 col-sm-12">
			    	<div class="home-banner mb-2">
		@foreach($homeadone as $value)
		    <a href="{{$value->link}}" target="_blank">
		        <img class="w-100" src="{{asset($value->image)}}" style="max-height:89px;" alt="">
		    </a>
		@endforeach
	</div>
				<div class="content">
					
					@foreach($categories as $category)
    					@php
    					    $posts = App\Post::where(['category'=>$category->id,'status'=>1])->orderBy('created_at','desc')->limit(5)->get();
    					@endphp
					<div class="content-area mt-3">
						<div class="content-head" style="background-image: linear-gradient({{$color->title_background}}, {{$color->title_background2}})">
						<div class="row">
							<div class="col-sm-6">
								<div class="content-head-left">
									<h6>Latest {{$category->name}}</h6>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="content-head-right">
									<h6>Description Preview</h6>
								</div>
							</div>
						</div>
					</div>
						@foreach($posts as $key=>$value)
    						@php
    						    $memberInfo = App\Member::find($value->memberid);
    						@endphp
						<div class="content-item" style="overflow:hidden">
						<div class="row">
							<div class="col-md-1 col-sm-2 col-12">
								<div class="content-img">
									<img src="{{asset($memberInfo->profilepic)}}" alt="">
								</div>
							</div>
							<div class="col-md-5 col-sm-5 col-12">
								<div class="content-title" style="height: 25px; overflow: hidden">
									<a href="{{url(''.$value->slug.'/'.$value->id)}}">
										<span style="color:{{$color->title_color}};font-size:{{$color->title_font}}px">{!! str_limit($value->title,99999)!!}</span></a>
								</div>
								<div><small><span style="color:{{$color->post_author}}">Posted by {{$memberInfo->name}}  </span></small></div>
							</div>
							<div class="col-md-6 col-sm-5 col-12">
								<div class="content-description d-block" style="font-size:{{$color->descrip_preview}}px; height: 50px; overflow: hidden">
									<p>{!! str_limit(strip_tags($value->description2),99999)!!}</p>
								</div>
							</div>
						</div>
					</div>
						@endforeach
						<!-- content item end -->
					</div>
					<!-- content -->
					@endforeach
				</div>
				
			</div>
			<div class="col-lg-5 col-md-5 col-sm-12">
				<div class="content-right-bar">
				    @foreach($categories as $category)
				        @if ($category->name != 'Signals')
				        @php
				            $latestposts = App\Post::where(['status'=>1,'category'=>$category->id])->orderBy('hitcount','DESC')->limit(5)->get();
				        @endphp
				    	<div class="content-area mb-3">
					  <div class="content-head" style="background-image: linear-gradient({{$color->title_background}}, {{$color->title_background2}})">
						<div class="row">
							<div class="col-sm-7">
								<div class="content-head-left">
									<h6>Hottest {{$category->name}}</h6>
								</div>
							</div>
							<div class="col-sm-5" style="margin-left: -20px;">
								<div class="content-head-right">
									<h6>Description Preview</h6>
								</div>
							</div>
						</div>
					</div>
					@foreach($latestposts as $key=>$value)
    					@php
    					    $memberInfo = App\Member::find($value->memberid);
    					@endphp
					<div class="content-item" style="overflow:hidden">
						<div class="row">
							<div class="col-sm-2">
								<div class="content-img">
									<img src="{{asset($memberInfo->profilepic)}}" alt="">
								</div>
							</div>
							<div class="col-sm-5 mr-3">
								<div class="content-title" style="margin-left:-28px ">
								    <div style="height: 25px; overflow: hidden">
									<a href="{{url(''.$value->slug.'/'.$value->id)}}"><span style="color:{{$color->header_hover}};font-size:{{$color->title_font}}px">{{str_limit($value->title,99999)}}</span></a>
									</div>
									<small><span style="color:{{$color->post_author}}">Posted by {{$memberInfo->name}} </span></small>
								</div>
								
							</div>
							<div class="col-sm-5" style="margin-left: -32px;">
								<div class="content-description d-block"  style="font-size:{{$color->descrip_preview}}px; height: 50px; overflow: hidden">
									<p>{!! str_limit(strip_tags($value->description2),99999) !!}</p>
								</div>
							</div>
						</div>
					</div>
					@endforeach
					<!-- content item end -->
				</div>
				
				    @endif
				    @endforeach
				    
				    
				    <div>
				        
<!-- TradingView Widget BEGIN -->
<div class="tradingview-widget-container">
  <div class="tradingview-widget-container__widget"></div>

  <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-market-quotes.js" async>
  {
  "width": "100%",
  "height": "362",
  "symbolsGroups": [
    {
      "name": "Indices",
      "originalName": "Indices",
      "symbols": [
        {
          "name": "FOREXCOM:SPXUSD",
          "displayName": "S&P 500"
        },
        {
          "name": "FOREXCOM:NSXUSD",
          "displayName": "Nasdaq 100"
        },
        {
          "name": "FOREXCOM:DJI",
          "displayName": "Dow 30"
        },
        {
          "name": "INDEX:NKY",
          "displayName": "Nikkei 225"
        },
        {
          "name": "INDEX:DEU30",
          "displayName": "DAX Index"
        },
        {
          "name": "FOREXCOM:UKXGBP",
          "displayName": "FTSE 100"
        }
      ]
    },
    {
      "name": "Commodities",
      "originalName": "Commodities",
      "symbols": [
        {
          "name": "CME_MINI:ES1!",
          "displayName": "E-Mini S&P"
        },
        {
          "name": "CME:6E1!",
          "displayName": "Euro"
        },
        {
          "name": "COMEX:GC1!",
          "displayName": "Gold"
        },
        {
          "name": "NYMEX:CL1!",
          "displayName": "Crude Oil"
        },
        {
          "name": "NYMEX:NG1!",
          "displayName": "Natural Gas"
        },
        {
          "name": "CBOT:ZC1!",
          "displayName": "Corn"
        }
      ]
    },
    {
      "name": "Bonds",
      "originalName": "Bonds",
      "symbols": [
        {
          "name": "CME:GE1!",
          "displayName": "Eurodollar"
        },
        {
          "name": "CBOT:ZB1!",
          "displayName": "T-Bond"
        },
        {
          "name": "CBOT:UB1!",
          "displayName": "Ultra T-Bond"
        },
        {
          "name": "EUREX:FGBL1!",
          "displayName": "Euro Bund"
        },
        {
          "name": "EUREX:FBTP1!",
          "displayName": "Euro BTP"
        },
        {
          "name": "EUREX:FGBM1!",
          "displayName": "Euro BOBL"
        }
      ]
    },
    {
      "name": "Forex",
      "originalName": "Forex",
      "symbols": [
        {
          "name": "FX:EURUSD"
        },
        {
          "name": "FX:GBPUSD"
        },
        {
          "name": "FX:USDJPY"
        },
        {
          "name": "FX:USDCHF"
        },
        {
          "name": "FX:AUDUSD"
        },
        {
          "name": "FX:USDCAD"
        }
      ]
    }
  ],
  "colorTheme": "light",
  "isTransparent": false,
  "locale": "en"
}
  </script>
</div>
<!-- TradingView Widget END -->				        
				        
				        
				        
				        
				    </div>
				    
				    
				    
				    
				    
				    
				    
				    
				    
				    
				    
				    
				    
				<!-- content -->
			
				</div>
				<div class="home-banner mt-3">
						@foreach($bottomad as $value)
						    <a href="{{$value->link}}" target="_blank">
						        <img class="w-100" src="{{asset($value->image)}}" style="max-height:67px;" alt="">
						    </a>
						@endforeach
					</div>
			</div>
		</div>
		
	</div>
	<br><br>
@endsection