@extends('frontEnd.layouts.master')
@section('title','Member Login')
@section('content')
	<!-- content area start -->
	<div class="container-fluid home-page">
		<div class="row">
			<div class="col-lg-4 col-sm-4"></div>
			<div class="col-lg-4 col-md-4 col-sm-4">
				<div class="login-register login-page">
					<h4>Member Login</h4>
					<form action="{{url('member/login')}}" method="POST">
						@csrf
						<input type="hidden" name="previous_url" value="<?=url()->previous()?>" />
						<div class="form-group">
							<input type="email" placeholder="Email" class="form-control{{$errors->has('email')? 'is-invalid' : ''}}" name="email" value="{{ old('email') }}" required="">
							@if ($errors->has('email'))
                                <span class="invalid-feedback" role="alert">
                                  <strong>{{ $errors->first('email') }}</strong>
                                </span>
                            @endif
						</div>
						<div class="form-group">
							<input type="password" name="password" placeholder="Password" class="form-control{{$errors->has('password')? 'is-invalid' : ''}}" value="{{ old('password') }}" id="myInput" required="">
							<span onclick="myFunction()"><i class="fa fa-eye"></i>  <a href="#" style="text-decoration:none">Show Password </a></span>
							@if ($errors->has('password'))
                                <span class="invalid-feedback" role="alert">
                                  <strong>{{ $errors->first('password') }}</strong>
                                </span>
                            @endif
						</div>						
						<div class="form-group row">
							<div class="col-sm-7">
								<input type="checkbox" class="checkbox" id="remember"> <label for="remember">Remember Me</label>
							</div>
							<div class="col-sm-5">
								<input type="submit" value="Login" class="submit-btn">
							</div>
						</div>
						<ul>
							<li class="first-child"><a href="{{url('member/register')}}">Register Now</a></li>
							<li class="last-child"><a href="{{url('member/forget-password')}}">Forget Password</a></li>
						</ul>
					</form>
				</div>
			</div>
		</div>
	</div>
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
@endsection
