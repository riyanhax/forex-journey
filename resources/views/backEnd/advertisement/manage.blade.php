@extends('backEnd.layouts.master')
@section('title','Advertisement Manage')
@section('content')
<div class="container">
        <!-- begin::page-header -->
        <div class="page-header">
            <h4>Advertisement Manage</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="{{url('superadmin/dashboard')}}">Home</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Advertisement Manage</li>
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
                     <h6 class="card-title">Advertisement Manage</h6>
                   </div>
                   <div class="col-sm-6">
                    <div class="shortcut-btn">
                       <a href="{{url('editor/advertisement/add')}}"><i data-feather="plus"></i> New</a>
                    </div>
                   </div>
                 </div>
                 <div class="row">
                    <div class="col-md-12">
                      <div class="manage-area">
                        <table id="myTable" class="table table-striped table-bordered">
                        <thead>
                          <tr>
                            <th>SL</th>
                            <th>Adcategory</th>
                            <th>Image</th>
                            <th>Link</th>
                            <th>Status</th>
                            <th>Manage</th>
                          </tr>
                        </thead>
                        <tbody>
                          @foreach($show_data as $key=>$value)
                          <tr>
                            <td>{{$loop->iteration}}</td>
                            <td>{{$value->name}}</td>
                             <td><img src="{{asset($value->image)}}" class="edit-img" alt=""></td>
                            <td>{{str_limit($value->link,30)}}</td>
                            <td>{{$value->status==1 ? "Active":"Inactive"}}</td>
                            <td><div class="dropdown">
                                <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                                  Select
                                </button>
                                <div class="dropdown-menu custom-action">

                                  @if($value->status==1)
                                    <li class="dropdown-item">
                                    <form action="{{url('editor/advertisement/inactive')}}" method="POST">
                                      @csrf
                                      <input type="hidden" name="hidden_id" value="{{$value->id}}">
                                      <button type="submit">Inactive</button>
                                    </form>
                                  </li>
                                   @else
                                   <li class="dropdown-item">
                                    <form action="{{url('editor/advertisement/active')}}" method="POST">
                                      @csrf
                                      <input type="hidden" name="hidden_id" value="{{$value->id}}">
                                      <button type="submit">Active</button>
                                    </form>
                                  </li>
                                  @endif
                                  <li>
                                    <a class="dropdown-item" href="{{url('editor/advertisement/edit/'.$value->id)}}">Edit</a>
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