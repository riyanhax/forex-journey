@extends('backEnd.layouts.master')
@section('title','User Manage')
@section('content')
<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>User Manage</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('superadmin/dashboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">User Manage</li>
                </ol>
            </nav>
        </div>
        <!-- end::page-header -->
		<div class="row">
			<div class="col-sm-12">
				<div class="card">
            <div class="card-body">
                 <div class="row">
                   <div class="col-sm-6">
                     <h6 class="card-title">User Manage</h6>
                   </div>
                   <div class="col-sm-6">
                    <div class="shortcut-btn">
                       <a href="{{url('superadmin/user/add')}}"><i data-feather="plus"></i> New</a>
                    </div>
                   </div>
                 </div>
                 <div class="row">
                    <div class="col-md-12">
                      <div class="manage-area">
                        <table id="myTable" class="table table-striped table-bordered table-responsive">
                        <thead>
                          <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Designation</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Manage</th>
                          </tr>
                        </thead>
                        <tbody>
                          @foreach($show_datas as $key=>$value)
                          <tr>
                            <td>{{$value->name}}</td>
                            <td>{{$value->email}}</td>
                            <td>{{$value->phone}}</td>
                            <td>{{$value->designation}}</td>
                            <td>{{$value->user_role}}</td>
                            <td>{{$value->status==1 ? "Active":"Inactive"}}</td>
                            <td><div class="dropdown">
                                <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                                  Select
                                </button>
                                <div class="dropdown-menu custom-action">

                                  @if($value->status==1)
                                    <li class="dropdown-item">
                                    <form action="{{url('superadmin/user/inactive')}}" method="POST">
                                      @csrf
                                      <input type="hidden" name="hidden_id" value="{{$value->id}}">
                                      <button type="submit">Inactive</button>
                                    </form>
                                  </li>
                                   @else
                                   <li class="dropdown-item">
                                    <form action="{{url('superadmin/user/active')}}" method="POST">
                                      @csrf
                                      <input type="hidden" name="hidden_id" value="{{$value->id}}">
                                      <button type="submit">Active</button>
                                    </form>
                                  </li>
                                  @endif
                                  <li>
                                    <a class="dropdown-item" href="{{url('superadmin/user/edit/'.$value->id)}}">Edit</a>
                                  </li>
                                  <li class="dropdown-item">
                                    <form action="{{url('superadmin/user/delete')}}" method="POST">
                                      @csrf
                                      <input type="hidden" name="hidden_id" value="{{$value->id}}">
                                      <button type="submit" onclick="return confirm('Are you delete this user?')" class="trash_icon"></button>
                                    </form>
                                  </li>
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
			</div>
		</div>
 </div>
@endsection