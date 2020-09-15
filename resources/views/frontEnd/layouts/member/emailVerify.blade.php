@extends('frontEnd.layouts.master')
@section('title','Email Verification')
@section('content')
	<!-- content area start -->
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-4 col-sm-4"></div>
			<div class="col-lg-4 col-md-4 col-sm-4">
				<div class="login-register">
					<h4>Email Verification</h4>
					<!--<form action="{{url('member/email-verification')}}" method="POST">-->
						@csrf
						<!--<div class="form-group">-->
						<!--	<input type="text" placeholder="Verification Code" class="form-control{{$errors->has('verifytoken')? 'is-invalid' : ''}}" value="{{ old('verifytoken') }}" name="verifytoken">-->
						<!--	@if ($errors->has('verifytoken'))-->
      <!--                          <span class="invalid-feedback" role="alert">-->
      <!--                            <strong>{{ $errors->first('verifytoken') }}</strong>-->
      <!--                          </span>-->
      <!--                      @endif-->
						<!--</div>-->
						<div class="form-group">
							<!--<input type="submit" value="Submit" class="submit-btn">-->
						    <h3>	Your account has been activated successfully. </h3>
						</div>
						<!--<p>Not Send Code? <a href="{{url('member/resend/verify-code')}}">Send Again</a></p>-->
					<!--</form>-->
				</div>
			</div>
		</div>
	</div>
@endsection
