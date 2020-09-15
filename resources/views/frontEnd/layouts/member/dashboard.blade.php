@extends('frontEnd.layouts.member.master')
@section('title','Member Dashboard')
@section('content')
	<div class="container">
            @php
                $memberInfo = App\Member::find(Session::get('memberId'));
            @endphp
            <div class="page-header mb-5">
                <h4>Member Dashboard</h4>
                <small class="">Welcome, <span class="text-primary">{{$memberInfo->name}}</span></small>
            </div>

            <div class="row">
                <div class="col-md-12">

                    <div class="row">
                        <div class="col-md-4">
                            <div class="card border mb-3">
                                <div class="card-body p-3">
                                    <div class="d-flex align-items-center">
                                        <div class="icon-block mr-3 icon-block-lg icon-block-outline-success text-success">
                                            <i class="fa fa-bar-chart"></i>
                                        </div>
                                        <div>
                                            <h6 class="text-uppercase font-size-11">Total Post</h6>
                                            <h4 class="mb-0">{{$totalpost}}</h4>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card border mb-3">
                                <div class="card-body p-3">
                                    <div class="d-flex align-items-center">
                                        <div class="icon-block mr-3 icon-block-lg icon-block-outline-info text-info">
                                            <i class="fa fa-thumbs-up"></i>
                                        </div>
                                        <div>
                                            <h6 class="text-uppercase font-size-11">Active Post</h6>
                                            <h4 class="mb-0">{{$activetotalpost}}</h4>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card border mb-3">
                                <div class="card-body p-3">
                                    <div class="d-flex align-items-center">
                                        <div class="icon-block mr-3 icon-block-lg icon-block-outline-danger  text-danger">
                                            <i class="fa fa-thumbs-down"></i>
                                        </div>
                                        <div>
                                            <h6 class="text-uppercase font-size-11">Inactive Post</h6>
                                            <h4 class="mb-0">{{$inactivetotalpost}}</h4>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="dpost-manage">
                                        <table id="myTable" class="table table-striped table-bordered table-responsive-stack">
                                      
                                          <tr>
                                            <th>SL</th>
                                            <th>Title</th>
                                            <th>Status</th>
                                            <th>Manage</th>
                                          </tr>
                                       
										
											@foreach($thismonthposts as $key=>$thismonthpost)
											<tr> 
											<td>{{$loop->iteration}}</td>
											<td>{{$thismonthpost->title}}</td>
											<td> @if($thismonthpost->status == 1)
											Active 
											@else
											Inactive
											@endif
											</td>
                                               <td><div class="dropdown">
                                                <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                                                  Select
                                                </button>
                                                <div class="dropdown-menu custom-action">
                
                                                  @if($thismonthpost->status==1)
                                                    <li class="dropdown-item">
                                                    <form action="{{url('member/post/inactive')}}" method="POST">
                                                      @csrf
                                                      <input type="hidden" name="hidden_id" value="{{$thismonthpost->id}}">
                                                      <button type="submit">Inactive</button>
                                                    </form>
                                                  </li>
                                                   @else
                                                   <li class="dropdown-item">
                                                    <form action="{{url('member/post/active')}}" method="POST">
                                                      @csrf
                                                      <input type="hidden" name="hidden_id" value="{{$thismonthpost->id}}">
                                                      <button type="submit">Active</button>
                                                    </form>
                                                  </li>
                                                  @endif
                                                  <li>
                                                    <a class="dropdown-item" href="{{url('member/post/edit/'.$thismonthpost->id)}}">Edit</a>
                                                  </li>
                                                  <li class="dropdown-item">
                                                    <form action="{{url('member/post/delete')}}" method="POST">
                                                      @csrf
                                                      <input type="hidden" name="hidden_id" value="{{$thismonthpost->id}}">
                                                      <button type="submit" onclick="return confirm('Are you want to delete this post?')" class="trash_icon"></button>
                                                    </form>
                                                  </li>
                                                </td>
                                         
                                          </tr>
                                        
										@endforeach
                                      </table>
									  
											<div class="float-right">
											{{$thismonthposts->links()}}
											</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

@endsection