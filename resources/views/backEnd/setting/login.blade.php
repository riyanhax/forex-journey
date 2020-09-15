<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Journey Forex</title>

    <!-- Favicon -->
    <link rel="shortcut icon" href="{{asset('public/backEnd/')}}/assets/media/image/favicon.png"/>

    <!-- Plugin styles -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/vendors/bundle.css" type="text/css">

    <!-- App styles -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/assets/css/app.min.css" type="text/css">
</head>
<body class="form-membership dark">

<!-- begin::preloader-->
<div class="preloader">
    <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="50px" height="50px" viewBox="0 0 128 128"
         xml:space="preserve">
        <rect x="0" y="0" width="100%" height="100%" fill="#FFFFFF"/>
        <g>
            <path d="M75.4 126.63a11.43 11.43 0 0 1-2.1-22.65 40.9 40.9 0 0 0 30.5-30.6 11.4 11.4 0 1 1 22.27 4.87h.02a63.77 63.77 0 0 1-47.8 48.05v-.02a11.38 11.38 0 0 1-2.93.37z"
                  fill="#000000" fill-opacity="1"/>
            <animateTransform attributeName="transform" type="rotate" from="0 64 64" to="360 64 64"
                              dur="500ms" repeatCount="indefinite">
            </animateTransform>
        </g>
    </svg>
</div>
<!-- end::preloader -->

<div class="form-wrapper">

    <!-- logo -->
    <div id="logo">
        @foreach($whitelogo as $logo)
            <img class="logo-dark" src="{{asset($logo->image)}}" alt="dark logo">
         @endforeach
    </div>
    <!-- ./ logo -->

    <h5>Sign in</h5>

    <!-- form -->
    <form action="{{url('login')}}" method="post">
      @csrf
        <div class="form-group">
            <input type="text" class="form-control{{ $errors->has('email') ? ' is-invalid' : '' }}" name="email" value="{{ old('email') }}" placeholder="Enter Email Address" required autofocus>
            @if ($errors->has('email'))
                <span class="invalid-feedback" role="alert">
                    <strong>{{ $errors->first('email') }}</strong>
                </span>
            @endif
        </div>
        <div class="form-group">
            <input type="password" class="form-control {{ $errors->has('password') ? ' is-invalid' : '' }}" value="{{ old('password') }}" id="myInput" name="password" placeholder="Password" required />
             <span onclick="myFunction()"><i class="fa fa-eye"></i>  <a href="#" style="text-decoration:none">Show Password </a></span>
        </div>
        <div class="form-group d-flex justify-content-between">
            <div class="custom-control custom-checkbox">
                <input type="checkbox" class="custom-control-input" checked="" id="customCheck1">
                <label class="custom-control-label" for="customCheck1">Remember me</label>

            </div>
        </div>
        <button class="btn btn-primary btn-block">Sign in</button>
    </form>
    <!-- ./ form -->

</div>

<!-- Plugin scripts -->
<script src="{{asset('public/backEnd/')}}/vendors/bundle.js"></script>

<!-- App scripts -->
<script src="{{asset('public/backEnd/')}}/assets/js/app.min.js"></script>
<script type="text/javascript">
	function myFunction() {
  var x = document.getElementById("myInput");
  if (x.type === "password") {
    x.type = "text";
  } else {
    x.type = "password";
  }
}
	</script>
</body>
</html>