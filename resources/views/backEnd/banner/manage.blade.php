@extends('backEnd.layouts.master')
@section('title','Banner Manage')
@section('content')
<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>Banner Manage</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('superadmin/dashboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Banner Manage</li>
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
                     <h6 class="card-title">Banner Manage</h6>
                   </div>
                   <div class="col-sm-6">
                    <div class="shortcut-btn">
                       <a href="{{url('editor/banner/add')}}"><i data-feather="plus"></i> New</a>
                    </div>
                   </div>
                 </div>
                 <div class="row">
                    <div class="col-md-12">
                      <div class="manage-area">
                        <table id="myTable" class="table table-striped table-bordered table-responsive">
                        <thead>
                          <tr>
                            <th>SL</th>
                            <th>Image</th>
                            <th>Page</th>
                            <th>Status</th>
                            <th>Manage</th>
                          </tr>
                        </thead>
                        <tbody>
                          @foreach($show_data as $key=>$value)
                          <tr>
                            <td>{{$loop->iteration}}</td>
                            <td><img src="{{asset($value->image)}}" class="edit-img" alt=""></td>
                            <td>@if($value->type==1) Sign In @elseif($value->type==2) Sign Up @elseif($value->type==3) Email Verify @elseif($value->type==4) Forget Password @elseif($value->type==5) Password Reset @endif  </td>
                            <td>{{$value->status==1 ? "Active":"Inactive"}}</td>
                            <td><div class="dropdown">
                                <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                                  Select
                                </button>
                                <div class="dropdown-menu custom-action">

                                  @if($value->status==1)
                                    <li class="dropdown-item">
                                    <form action="{{url('editor/banner/inactive')}}" method="POST">
                                      @csrf
                                      <input type="hidden" name="hidden_id" value="{{$value->id}}">
                                      <button type="submit">Inactive</button>
                                    </form>
                                  </li>
                                   @else
                                   <li class="dropdown-item">
                                    <form action="{{url('editor/banner/active')}}" method="POST">
                                      @csrf
                                      <input type="hidden" name="hidden_id" value="{{$value->id}}">
                                      <button type="submit">Active</button>
                                    </form>
                                  </li>
                                  @endif
                                  <li>
                                    <a class="dropdown-item" href="{{url('editor/banner/edit/'.$value->id)}}">Edit</a>
                                  </li>
                                  <li class="dropdown-item">
                                    <form action="{{url('editor/banner/delete')}}" method="POST">
                                      @csrf
                                      <input type="hidden" name="hidden_id" value="{{$value->id}}">
                                      <button type="submit" onclick="return confirm('Are you delete this user?')" class="trash_icon">Delete</button>
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