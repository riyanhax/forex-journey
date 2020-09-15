@extends('frontEnd.layouts.master')
@section('title','Forget Password')
@section('content')
	<!-- content area start -->
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-4 col-sm-4"></div>
			<div class="col-lg-4 col-md-4 col-sm-4">
				<div class="login-register login-page">
					<h4>Forget Password</h4>
					<form action="{{url('member/forget-password')}}" method="POST">
						@csrf
						 <div class="form-group">
							<label for="email">Email Address</label>
							<input type="email" name="email" id="email" class="form-control{{$errors->has('email')? 'is-invalid' : ''}}" value="{{ old('email') }}">
							@if ($errors->has('email'))
                                <span class="invalid-feedback" role="alert">
                                  <strong>{{ $errors->first('email') }}</strong>
                                </span>
                            @endif
						</div>
						<div class="form-group">
							<input type="submit" class="form-control submit-btn" value="Send">
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
@endsection
