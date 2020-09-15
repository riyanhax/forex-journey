@extends('frontEnd.layouts.master')
@section('title','Quick Signup')
@section('content')
	<!-- content area start -->
	<div class="container-fluid home-page">
		<div class="row">
			<div class="col-lg-4 col-sm-4"></div>
			<div class="col-lg-4 col-md-4 col-sm-4">
				<div class="login-register">
					<h4>Quick Signup</h4>
					<form action="{{url('member/register')}}" method="POST">
						@csrf
						<div class="form-group">
							<input type="text" placeholder="Username" class="form-control{{$errors->has('username')? 'is-invalid' : ''}}" value="{{ old('username') }}" name="username">
							@if ($errors->has('username'))
                                <span class="invalid-feedback" role="alert">
                                  <strong>{{ $errors->first('username') }}</strong>
                                </span>
                            @endif
						</div>
						<div class="form-group">
							<input type="email" placeholder="Email" class="form-control{{$errors->has('email')? 'is-invalid' : ''}}" value="{{ old('email') }}" name="email">
							@if ($errors->has('email'))
                                <span class="invalid-feedback" role="alert">
                                  <strong>{{ $errors->first('email') }}</strong>
                                </span>
                            @endif
						</div>
						<div class="form-group">
							<input type="password" placeholder="Password" class="form-control{{$errors->has('password')? 'is-invalid' : ''}}" value="{{ old('password') }}" name="password">
							@if ($errors->has('password'))
                                <span class="invalid-feedback" role="alert">
                                  <strong>{{ $errors->first('password') }}</strong>
                                </span>
                            @endif
						</div>
						<div class="form-group">
							<input type="password" placeholder="Confirm Password" class="form-control{{$errors->has('confirmpass')? 'is-invalid' : ''}}" value="{{ old('confirmpass') }}" name="confirmpass">
							@if ($errors->has('confirmpass'))
                                <span class="invalid-feedback" role="alert">
                                  <strong>{{ $errors->first('confirmpass') }}</strong>
                                </span>
                            @endif
						</div>
						<div class="form-group">
							<input type="submit" value="Register" class="submit-btn">
						</div>
						<p>Have already an account ? <a href="{{url('member/login')}}">Login here</a></p>
					</form>
				</div>
			</div>
		</div>
	</div>
@endsection