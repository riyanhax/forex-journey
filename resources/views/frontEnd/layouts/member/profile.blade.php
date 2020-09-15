@extends('frontEnd.layouts.member.master')
@section('title','Member Profile')
@section('content')
<div class="container">
    <div class="row">
          <div class="col-md-12">
              <div class="card">
                  <div class="card-body text-center">
                      <figure class="avatar avatar-lg m-b-20">
                          <img src="{{asset($memberInfo->profilepic)}}" class="rounded-circle" alt="...">
                      </figure>
                      <h5 class="mb-1">{{$memberInfo->name}}</h5>
                      <p class="text-muted small"> {{$memberInfo->designation}} </p>
                      <p>{{$memberInfo->bio}}</p>
                      <a  class="btn btn-outline-primary" data-toggle="modal" data-target="#bioModal">
                          <i data-feather="edit-2" class="mr-2"></i> Edit Profile
                      </a>
                      <!-- Modal -->
                        <div class="modal fade custom-modal-one" id="bioModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                          <div class="modal-dialog" role="document">
                            <div class="modal-content">
                              <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">Edit Bio</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                  <span aria-hidden="true">&times;</span>
                                </button>
                              </div>
                              <div class="modal-body">
                                <div class="modal-form">
                                  <form action="{{url('member/bio/edit')}}" method="POST" enctype="multipart/form-data">
                                    @csrf
                                    <div class="form-group">
                                      <input type="file" class="form-control" name="profilepic" placeholder="Name" accept="image*">
                                      <img src="{{asset('profilepic')}}" alt="">
                                      <img src="{{asset($memberInfo->profilepic)}}"
                                               class="rounded-circle small-image" alt="...">
                                    </div>

                                    <div class="form-group">
                                      <input type="text" class="form-control" value="{{$memberInfo->name}}" name="name" placeholder="Name">
                                    </div>
                                    <div class="form-group">
                                      <input type="text" class="form-control" value="{{$memberInfo->designation}}" name="designation" placeholder="Designation">
                                    </div>
                                    <div class="form-group">
                                      <textarea name="bio" class="form-control" cols="15" placeholder="Write Bio, Maximum 150 letter">{{$memberInfo->bio}}</textarea>
                                    </div>
                                    <div class="form-group">
                                      <button class="btn btn-primary" class="form-control">Submit</button>
                                    </div>
                                  </form>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                        <!-- modal end -->
                  </div>
                  <hr class="m-0">
                  <div class="card-body">
                      <div class="row text-center">
                          <div class="col-4 text-info">
                              <h4 class="font-weight-bold">{{date('d F, Y', strtotime($memberInfo->created_at))}}</h4>
                              <span>Member Since</span>
                          </div>
                          <div class="col-4 text-success">
                              <h4 class="font-weight-bold">{{$totalpost}}</h4>
                              <span>Total Post</span>
                          </div>
                      </div>
                  </div>
              </div>

              <div class="card">
                  <div class="card-body">
                      <h6 class="card-title d-flex justify-content-between align-items-center">
                          Information
                          <a  class="btn btn-outline-light btn-sm" data-toggle="modal" data-target="#infoModal">
                              <i data-feather="edit-2" class="mr-2"></i> Edit
                          </a>

                        <!-- Modal -->
                          <div class="modal fade custom-modal-one" id="infoModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                              <div class="modal-content">
                                <div class="modal-header">
                                  <h5 class="modal-title" id="exampleModalLabel">Edit Information</h5>
                                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                  </button>
                                </div>
                                <div class="modal-body">
                                  <div class="modal-form">
                                    <form action="{{url('member/information/edit')}}" method="POST" name="editForm">
                                      @csrf
                                      <div class="form-group">
                                        <input type="text" class="form-control" value="{{$memberInfo->name}}" name="name" placeholder="Name">
                                      </div>
                                      <div class="form-group">
                                        <input type="text" class="form-control" value="{{$memberInfo->phone}}" name="phone" placeholder="Phone (Myself)">
                                      </div>
                                      <div class="form-group">
                                        <input type="text" class="form-control" value="{{$memberInfo->phone}}" name="phone" placeholder="Phone (Myself)">
                                      </div>
                                      <div class="form-group">
                                        <input type="date" class="form-control" value="{{$memberInfo->birthday}}" name="birthday" placeholder="Birthday">
                                      </div>
                                      <div class="form-group">
                                        <select class="form-control" name="gender" placeholder="Country">
                                          <option value="">Select...</option>
                                          <option value="male">Male</option>
                                          <option value="female">Female</option>
                                          <option value="other">Other</option>
                                        </select>
                                      </div>
                                      <div class="form-group">
                                        <input type="text" class="form-control" value="{{$memberInfo->district}}" name="district" placeholder="District">
                                      </div>
                                      <div class="form-group">
                                        <input type="text" class="form-control" value="{{$memberInfo->streetAddress}}" name="streetAddress" placeholder="Street Adress">
                                      </div>
                                      <div class="form-group">
                                        <input type="text" class="form-control" value="{{$memberInfo->postalCode}}" name="postalCode" placeholder="Postal Code">
                                      </div>
                                      <div class="form-group">
                                        <button class="btn btn-primary" class="form-control">Submit</button>
                                      </div>
                                    </form>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                      </h6>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Name:</div>
                          <div class="col-6">{{$memberInfo->name}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Position:</div>
                          <div class="col-6">{{$memberInfo->designation}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Gender:</div>
                          <div class="col-6">{{$memberInfo->gender}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Birthday:</div>
                          <div class="col-6">{{$memberInfo->birthday}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Phone(Myself):</div>
                          <div class="col-6">{{$memberInfo->phone}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Phone(Home):</div>
                          <div class="col-6">{{$memberInfo->phone2}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Employee Category:</div>
                          <div class="col-6">{{$memberInfo->employeetype}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Country:</div>
                          <div class="col-6">{{$memberInfo->country}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">District:</div>
                          <div class="col-6">{{$memberInfo->district}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Street Address:</div>
                          <div class="col-6">{{$memberInfo->streetAddress}}</div>
                      </div>
                      <div class="row mb-2">
                          <div class="col-6 text-muted">Postal Code:</div>
                          <div class="col-6">{{$memberInfo->postalCode}}</div>
                      </div>
                  </div>
              </div>
     


          </div>
          <div class="col-md-8">

    
              <div class="tab-content" id="myTabContent">
              </div>

          </div>
      </div>
 </div>
   <script type="text/javascript">
      document.forms['editForm'].elements['gender'].value="{{$memberInfo->gender}}"
    </script>
@endsection