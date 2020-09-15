<!DOCTYPE html>
<html lang="en">
<head>
    <title>@yield('title')</title>
	<!-- title of website -->
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=UA-174666745-1"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      gtag('config', 'UA-174666745-1');
    </script>
    
    <meta name="google-site-verification" content="d_MVwhz0hwUOyA1P6E2vR7SaR-DRy_YtnYUbhqffn9E" />
    <meta name="description" content="@yield('description')">
    <meta name="keywords" content="@yield('keywords')"> 
	<meta charset="UTF-8">
	
	<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
	<!-- responsive layout -->	
    <link rel="shortcut icon" href="{{asset('public/frontEnd/')}}/images/favicon.png"/>
	<link rel="stylesheet" href="{{asset('public/frontEnd/')}}/css/bootstrap.min.css">
	<link href="https://cdn.datatables.net/1.10.21/css/dataTables.bootstrap4.min.css">
	<!-- responsive framework -->
	<link rel="stylesheet" href="{{asset('public/frontEnd/')}}/css/font-awesome.min.css">
	<!-- font awesome css -->
	<link rel="stylesheet" href="{{asset('public/frontEnd/')}}/css/mobile-menu.css">
	<!-- js-offcanvas css -->
    <link rel="stylesheet" href="{{asset('public/backEnd')}}/assets/css/toastr.min.css">
    <!-- toastr -->
	<link rel="stylesheet" href="{{asset('public/frontEnd/')}}/css/style.css">
	<!-- custom css -->
	<link rel="stylesheet" href="{{asset('public/frontEnd/')}}/css/responsive.css">
	<!-- custom css -->
	<script src="{{asset('public/frontEnd/')}}/js/jquery-3.5.1.min.js"></script>
	
	<!-- This js is for richtext function on this page -->
    <script src="https://cdn.tiny.cloud/1/3v39fnf4cnmr4g78v19fe2mlqhttbmh9ze5uwg8ss2xtdqmd/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
	
	<!-- jquery library -->
	<style>
	    .tv-ticker-item-tape {
        	padding: 0 0 !important;
        	margin-top: -8px !important;
        }
	</style>
</head>
<body>
	<section class="mobile-header-design hidden-lg hidden-md hidden-sm">
        <div id="mobile-menu" class="hidden-lg hidden-md hidden-sm">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12">
                        <div id="main-nav" class="mobile-menu">
                            <ul class="first-nav">
                                <li>
                                  <a href="{{url('/')}}"><i class="fa fa-home"></i> Home</a>
                                </li>
								
                              <li class="parent">
							  <a href="{{url('/education')}}"><i class="fa fa-caret-right" aria-hidden="true"></i> Education </a></li>
							  
                              <li class="parent"><a href="{{url('/brokers')}}"><i class="fa fa-caret-right" aria-hidden="true"></i> Brokers </a></li>
							  
							  <li class="parent"><a href="{{url('/strategies')}}"><i class="fa fa-caret-right" aria-hidden="true"></i> Strategies </a></li>
							  
							  <li class="parent"><a href="{{url('/indicators')}}"><i class="fa fa-caret-right" aria-hidden="true"></i> Indicators </a></li>
							  
							  <li class="parent"><a href="{{url('/expert-advisors')}}"><i class="fa fa-caret-right" aria-hidden="true"></i> EA </a></li>
							  
							  <li class="parent"><a href="{{url('/signals')}}"><i class="fa fa-caret-right" aria-hidden="true"></i> Signals </a></li>

							  <li class="parent"><a href="{{url('/discussion')}}"><i class="fa fa-caret-right" aria-hidden="true"></i> Discussion </a></li>


								
						    @if(Session::get('memberId'))
						      @php
						        $memberdata = App\Member::find(Session::get('memberId'));
						      @endphp
						       <li><a href="{{url('member/dashboard')}}"> <i class="fa fa-user"></i> {{$memberdata->name}}</a></li>
						       @else
                              <li><a href="{{url('member/login')}}"> <i class="fa fa-sign-in"></i> Login</a></li>
                              <li><a href="{{url('member/register')}}"> <i class="fa fa-users"></i> Join</a></li>
                              @endif
                          </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- mobile header end -->
    <div class="mobile-header-top">
        <div class="container">
            <div class="row">
                <div class="col-6">
                  <div class="mobile-logo">
                      <a href="{{url('/')}}">
                       @foreach($whitelogo as $logo)
                        <img class="logo-dark" src="{{asset($logo->image)}}" alt="dark logo">
                       @endforeach
                      </a>
                  </div>
                </div>
                <div class="col-6">  
                    <span class="toggle hc-nav-trigger hc-nav-1"><i class="fa fa-bars"></i></span>    
                </div>
            </div>
        </div>
    </div>
    <div class="mobile-notice">
    	<div class="container">
    		<div class="row">
            <div class="col-sm-3">
            		<div class="top-notice">
							<!-- TradingView Widget BEGIN -->
                                <div class="tradingview-widget-container">
                                  <div class="tradingview-widget-container__widget"></div>
                                  <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-ticker-tape.js" async>
                                  {
                                  "symbols": [
                                    {
                                      "proName": "FOREXCOM:SPXUSD",
                                      "title": "S&P 500"
                                    },
                                    {
                                      "proName": "FOREXCOM:NSXUSD",
                                      "title": "Nasdaq 100"
                                    },
                                    {
                                      "proName": "FX_IDC:EURUSD",
                                      "title": "EUR/USD"
                                    },
                                    {
                                      "proName": "BITSTAMP:BTCUSD",
                                      "title": "BTC/USD"
                                    },
                                    {
                                      "proName": "BITSTAMP:ETHUSD",
                                      "title": "ETH/USD"
                                    }
                                  ],
                                  "colorTheme": "light",
                                  "isTransparent": true,
                                  "displayMode": "regular",
                                  "locale": "br"
                                }
                                  </script>
                                </div>
                                <!-- TradingView Widget END -->
					</div>
            	</div>
           </div>
    	</div>
    </div>
	<!-- header start -->
	<header class="mb-3">
	   <div class="container-fluid">
	       <div class="row">
	           <div class="col-md-12">
	               
	           
		<div class="header-body">
				<div class="header-left">
					<div class="logo">
						<a href="{{url('/')}}">                       
						@foreach($whitelogo as $logo)
                        <img class="logo-dark" src="{{asset($logo->image)}}" alt="dark logo">
                       @endforeach</a>
					</div>
				</div>
				@php
				$color = \App\Color::first();
				@endphp
				
				
				<!-- col-3 end -->
				<div class="header-right">
					<div class="header-right-top">
							<div class="header-top-left">
								<div class="main-menu">
									 <ul class="sidebar-menu">                       
										<li><a href="{{url('/')}}">
										<span style="color:{{$color->header_top}};font-size:{{$color->header_font}}px;"><i class="fa fa-home"></i></span> </a></li>
										
										
							 <li class="@php echo "active",(request()->path() != 'education')?:"";@endphp" style="background-color:{{$color->header_active}}">
							 <a href="{{url('/education')}}"><span style="color:{{$color->header_top}};font-size:{{$color->header_font}}px;">Education</span></a></li>
							 
                              <li class="@php echo "active",(request()->path() != 'brokers')?:"";@endphp" style="background-color:{{$color->header_active}}"><a href="{{url('/brokers')}}"><span style="color:{{$color->header_top}};font-size:{{$color->header_font}}px;">Brokers</span></a></li>
							  
							  <li class="@php echo "active",(request()->path() != 'strategies')?:"";@endphp" style="background-color:{{$color->header_active}}"><a href="{{url('/strategies')}}"><span style="color:{{$color->header_top}};font-size:{{$color->header_font}}px;">Strategies</span></a></li>
							  
							  <li class="@php echo "active",(request()->path() != 'indicators')?:"";@endphp" style="background-color:{{$color->header_active}}"><a href="{{url('/indicators')}}"><span style="color:{{$color->header_top}};font-size:{{$color->header_font}}px;">Indicators</span></a></li>
							  
							  <li class="@php echo "active",(request()->path() != 'expert-advisors')?:"";@endphp" style="background-color:{{$color->header_active}}"><a href="{{url('/expert-advisors')}}"><span style="color:{{$color->header_top}};font-size:{{$color->header_font}}px;">EA</span></a></li>
										
							  <li class="@php echo "active",(request()->path() != 'signals')?:"";@endphp" style="background-color:{{$color->header_active}}"><a href="{{url('/signals')}}"><span style="color:{{$color->header_top}};font-size:{{$color->header_font}}px;">Signals</span></a></li>

							  <li class="@php echo "active",(request()->path() != 'discussion')?:"";@endphp" style="background-color:{{$color->header_active}}"><a href="{{url('/discussion')}}"><span style="color:{{$color->header_top}};font-size:{{$color->header_font}}px;">Discussion</span></a></li>


									</ul>
								</div>
							</div>
							<div class="header-top-right">
								<div class="sign-in-area">
									<ul class="sidebar-menu">
									  @if(Session::get('memberId'))
        						      @php
        						        $memberdata = App\Member::find(Session::get('memberId'));
        						      @endphp
        						       <li><a href="{{url('member/dashboard')}}"> <i class="fa fa-user"></i> {{$memberdata->name}}</a></li>
        						       @else
                                      <li class="@php echo "active",(request()->path() != '')?:"";@endphp">
								  <a href="{{url('member/login')}}"> <i class="fa fa-sign-in"></i><span style="font-size:{{$color->header_font}}px;"> Login</span></a></li>
                                      
                                      <li class="@php echo "active",(request()->path() != '')?:"";@endphp">
								 <a href="{{url('member/register')}}"> 
								    <i class="fa fa-user"></i>
								    <span style="font-size:{{$color->header_font}}px;"> Register</span>
								    </a> 								    
								    </li>
                                      @endif										
									</ul>
								</div>
								<div class="header-search">
									<form action="">
										<input type="text" class="search_data" placeholder="Search">
										<i class="fa fa-search"></i>
									</form>
								</div>
							</div>
					</div>
					<div class="header-top-bottom">
						<div class="row">
							<div class="col-sm-3 col-xs-3 col-md-12 col-lg-12"  style="padding-left:6px !important; transform:skew(-1deg)">
								<div class="top-notice">
                                        <!-- TradingView Widget BEGIN -->
                                            <div class="tradingview-widget-container">
                                              <div class="tradingview-widget-container__widget"></div>
                                              <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-ticker-tape.js" async>
                                              {
                                              "symbols": [
                                                {
                                                  "proName": "FOREXCOM:SPXUSD",
                                                  "title": "S&P 500"
                                                },
                                                {
                                                  "proName": "FOREXCOM:NSXUSD",
                                                  "title": "Nasdaq 100"
                                                },
                                                {
                                                  "proName": "FX_IDC:EURUSD",
                                                  "title": "EUR/USD"
                                                        },
                                                        {
                                                          "proName": "BITSTAMP:BTCUSD",
                                                          "title": "BTC/USD"
                                                        },
                                                        {
                                                          "proName": "BITSTAMP:ETHUSD",
                                                          "title": "ETH/USD"
                                                        }
                                                      ],
                                                      "colorTheme": "light",
                                                      "isTransparent": true,
                                                      "displayMode": "regular",
                                                      "locale": "br"
                                                    }
                                                      </script>
                                                    </div>
                                                    <!-- TradingView Widget END -->
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- col-9 end -->
		</div>
		</div>
	  </div>
	</div>
	</header>
	<!-- header end -->
	<!-- content area start -->
	
	@yield('content')

	<div class="search-product-inner" id="live_data_show"></div> 
	
	<script src="{{asset('public/frontEnd/')}}/js/bootstrap.min.js"></script>
	<!-- bootstrap js -->

	<script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
	<script src="https://cdn.datatables.net/1.10.21/js/dataTables.bootstrap4.min.js"></script>
	<script>
	$(document).ready(function() {
     $('#example').DataTable({
         pageLength: -1,
     });
    } );
</script>
	<script src="{{asset('public/frontEnd/')}}/js/mobile-menu.js"></script>
	<!-- mobile menu js -->
	<script src="{{asset('public/backEnd')}}/assets/js/toastr.min.js"></script>
	<!-- toastr js -->
	{!! Toastr::message() !!}
	<script src="{{asset('public/frontEnd/')}}/js/script.js"></script>
	<!-- all custom js -->
	<script type="text/javascript">
    $(".search_data").on('keyup', function(){
        // alert('data');
       var keyword = $(this).val();
       $.ajax({
        type: "GET",
        url: "{{url('/')}}/search_data/" +keyword,
        data: { keyword: keyword },
        success: function (data) {
          console.log(data);
          $("#live_data_show").html('');
          $("#live_data_show").html(data);
        }
       });
    });



    <!-- Tinymce setup for comment and comment reply -->
    tinymce.init({
      selector: 'textarea.tinymce-for-comment',
      //content_css: '//www.tiny.cloud/css/codepen.min.css',
      


      height: 200,
      menubar: '',
      plugins: 'image imagetools quickbars',
      toolbar: '',
      quickbars_insert_toolbar: 'quickimage',
      
      file_picker_types: 'image',
      /* and here's our custom image picker*/
      file_picker_callback: function (cb, value, meta) {
        var input = document.createElement('input');
        input.setAttribute('type', 'file');
        input.setAttribute('accept', 'image/*');

        /*
          Note: In modern browsers input[type="file"] is functional without
          even adding it to the DOM, but that might not be the case in some older
          or quirky browsers like IE, so you might want to add it to the DOM
          just in case, and visually hide it. And do not forget do remove it
          once you do not need it anymore.
        */

        input.onchange = function () {
          var file = this.files[0];

          var reader = new FileReader();
          reader.onload = function () {
            /*
              Note: Now we need to register the blob in TinyMCEs image blob
              registry. In the next release this part hopefully won't be
              necessary, as we are looking to handle it internally.
            */
            var id = 'blobid' + (new Date()).getTime();
            var blobCache =  tinymce.activeEditor.editorUpload.blobCache;
            var base64 = reader.result.split(',')[1];
            var blobInfo = blobCache.create(id, file, base64);
            blobCache.add(blobInfo);

        /* call the callback and populate the Title field with the file name */
        cb(blobInfo.blobUri(), { title: file.name });
      };
      reader.readAsDataURL(file);
    };

    input.click();
  },
      automatic_uploads: false,
      branding: false,
      
      
     });
    
    
    
    

</script>
	

	
</body>
</html>