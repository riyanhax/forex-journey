@extends('frontEnd.layouts.member.master')
@section('title','Password Change')
@section('content')
	<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>Password Change</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('employee/dashboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Password Change</li>
                </ol>
            </nav>
        </div>
        <!-- end::page-header -->
		<div class="row">
			<div class="col-sm-12">
				<div class="card">
                    <div class="card-body">
                        <h6 class="card-title">Password Change</h6>
                         <div class="row">
                            <div class="col-md-8">
                                <form action="{{url('member/password-change')}}" method="POST">
                                    @csrf
                                    <div class="form-group">
                                        <label for="oldpassword">Old Password</label>
                                        <input type="password" name="oldpassword" class="form-control{{$errors->has('oldpassword')? 'is-invalid' : ''}}" value="{{ old('oldpassword') }}" id="oldpassword"
                                               placeholder="Old Password">
                                           @if ($errors->has('oldpassword'))
                                                        <span class="invalid-feedback" role="alert">
                                                  <strong>{{ $errors->first('oldpassword') }}</strong>
                                                </span>
                                            @endif
                                    </div>
                                    <div class="form-group">
                                        <label for="newpassword">New Password</label>
                                        <input type="password" name="newpassword" class="form-control{{$errors->has('newpassword')? 'is-invalid' : ''}}" value="{{ old('newpassword') }}" id="newpassword"
                                               placeholder="New Password">
                                           @if ($errors->has('newpassword'))
                                                        <span class="invalid-feedback" role="alert">
                                                  <strong>{{ $errors->first('newpassword') }}</strong>
                                                </span>
                                            @endif
                                    </div>
                                    <button type="submit" class="btn btn-primary">Submit</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
			</div>
		</div>
    </div>
@endsection