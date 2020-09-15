@extends('frontEnd.layouts.master')
@section('title','Forget Password')
@section('content')
	<!-- content area start -->
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-4 col-sm-4"></div>
			<div class="col-lg-4 col-md-4 col-sm-4">
				<div class="login-register login-page">
					<h4>Password Reset</h4>
					<form action="{{url('member/forget-password/reset')}}" method="POST">
						@csrf
						  <div class="form-group">
							<label for="verifycode">Verification Code</label>
							<input type="text" name="verifycode" id="verifycode" class="form-control{{$errors->has('verifycode')? 'is-invalid' : ''}}" value="{{ old('verifycode') }}">
							@if ($errors->has('verifycode'))
                                <span class="invalid-feedback" role="alert">
                                  <strong>{{ $errors->first('verifycode') }}</strong>
                                </span>
                            @endif
						</div>

						 <div class="form-group">
							<label for="newpassword">New Password</label>
							<input type="password" name="newpassword" id="newpassword" class="form-control{{$errors->has('newpassword')? 'is-invalid' : ''}}" value="{{ old('newpassword') }}">
							@if ($errors->has('newpassword'))
                                <span class="invalid-feedback" role="alert">
                                  <strong>{{ $errors->first('newpassword') }}</strong>
                                </span>
                            @endif
						</div>
						<div class="form-group">
							<input type="submit" class="form-control submit-btn" value="Update Password">
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
@endsection
