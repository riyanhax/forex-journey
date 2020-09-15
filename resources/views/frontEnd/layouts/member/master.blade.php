
<!DOCTYPE html>
<html lang="en">
<head>
    <style>
.note-editor .note-toolbar, .note-popover .popover-content {
    margin: 0;
    padding: 0 0 5px 5px;
    background-color: #fff;
    border-radius:5px;
}
.note-editor.note-airframe .note-editing-area .note-editable, .note-editor.note-frame .note-editing-area .note-editable {
    min-height:200px;
    overflow: auto;
    word-wrap: break-word;
    border: 1px solid gray;
    margin-top: 10px;
    border-radius:5px;
}
</style>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Journeyforex - @yield('title','Welcome To Journeyforex')</title>

    <!-- Favicon -->
    <link rel="shortcut icon" href="{{asset('public/backEnd/')}}/assets/media/image/favicon.png"/>

    <!-- Plugin styles -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/vendors/bundle.css" type="text/css">
    <!-- quill -->
    <link href="{{asset('public/backEnd/')}}/vendors/quill/quill.snow.css" rel="stylesheet" type="text/css">
    <!-- Tagsinput -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/vendors/tagsinput/bootstrap-tagsinput.css" type="text/css">
    <!-- Prism -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/vendors/prism/prism.css" type="text/css">
    <!-- App styles -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/assets/css/app.min.css" type="text/css">
    <!-- toastr styles -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/assets/css/toastr.min.css" type="text/css">
    <!-- custom style -->
      <link rel="stylesheet" href="{{asset('public/backEnd/')}}/vendors/select2/css/select2.min.css" type="text/css">
    <!-- dataTable styles -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/vendors/dataTable/dataTables.min.css" type="text/css">
    <!-- datepkrr -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="{{asset('public/frontEnd/')}}/css/member/circle.css" type="text/css">
    <!-- circle css -->
    <link rel="stylesheet" href="{{asset('public/backEnd/')}}/assets/css/custom.css" type="text/css">
    
    
    
    
    <!-- This js is for richtext function on this page -->
    <script src="https://cdn.tiny.cloud/1/3v39fnf4cnmr4g78v19fe2mlqhttbmh9ze5uwg8ss2xtdqmd/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
    
    
    
</head>
<body class="dark">

<!-- begin::preloader-->
<div class="preloader">
    <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="50px" height="50px" viewBox="0 0 128 128"
         xml:space="preserve">
        <rect x="0" y="0" width="100%" height="100%" fill="#FFFFFF"/>
        <g>
            <path d="M75.4 126.63a11.43 11.43 0 0 1-2.1-22.65 40.9 40.9 0 0 0 30.5-30.6 11.4 11.4 0 1 1 22.27 4.87h.02a63.77 63.77 0 0 1-47.8 48.05v-.02a11.38 11.38 0 0 1-2.93.37z"
                  fill="#000000" fill-opacity="1"/>
            <animateTransform attributeName="transform" type="rotate" from="0 64 64" to="360 64 64"
                              dur="500ms" repeatCount="indefinite">
            </animateTransform>
        </g>
    </svg>
</div>
<!-- end::preloader -->



<!-- begin::navigation -->
<div class="navigation">

    <!-- begin::logo -->
    <div id="logo">
        <a href="{{url('/')}}">
           @foreach($whitelogo as $logo)
            <img class="logo-dark" src="{{asset($logo->image)}}" alt="dark logo">
           @endforeach
        </a>
    </div>
    <!-- end::logo -->
    @php
        $memberInfo = App\Member::find(Session::get('memberId'));
    @endphp
    <!-- begin::navigation header -->
    <header class="navigation-header">
        <figure class="avatar avatar-state-success">
            <img src="{{asset($memberInfo->profilepic)}}" class="rounded-circle" alt="image">
        </figure>
        <div>
            <h5>{{$memberInfo->name}}</h5>
            <p class="text-muted">{{$memberInfo->designation}}</p>
            <ul class="nav">
                <li class="nav-item">
                    <a href="{{url('member/profile')}}" class="btn nav-link bg-info-bright" title="Profile" data-toggle="tooltip">
                        <i data-feather="user"></i>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="{{url('member/password-change')}}" class="btn nav-link bg-success-bright" title="Settings" data-toggle="tooltip">
                        <i data-feather="settings"></i>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="{{url('member/sign-out')}}" onclick="event.preventDefault();document.getElementById('logout-form').submit();"  class="btn nav-link bg-danger-bright" title="Logout" data-toggle="tooltip">
                        <i data-feather="log-out"></i>
                        <form id="logout-form" action="{{ url('member/sign-out') }}" method="POST" style="display: none;">
                          @csrf
                       </form>
                    </a>
                </li>
            </ul>
        </div>
    </header>
    <!-- end::navigation header -->

    <!-- begin::navigation menu -->
    <div class="navigation-menu-body">
        <ul>
            <li>
                <a href="{{url('member/dashboard')}}">
                     <i class="nav-link-icon" data-feather="bar-chart-2"></i>
                    <span>Dashboard</span>
                </a>
            </li>
 
            <li>
                <a href="{{url('member/profile')}}">
                    <i class="nav-link-icon" data-feather="user"></i>
                    <span>My Profile</span>
                </a>
            </li>
 
            <li>
                <a href="{{url('member/post/manage')}}">
                    <i class="nav-link-icon" data-feather="mail"></i>
                    <span>Post</span>
                </a>
            </li>
            
 
            <li>
                <a href="{{url('member/password-change')}}">
                    <i class="nav-link-icon" data-feather="key"></i>
                    <span>Change Password</span>
                </a>
            </li>
            <li>
                <a href="{{url('member/sign-out')}}" onclick="event.preventDefault();document.getElementById('logout-form').submit();" >
                     <form id="logout-form" action="{{ url('member/sign-out') }}" method="POST" style="display: none;">
                          @csrf
                       </form>
                    <i class="nav-link-icon" data-feather="log-out"></i>
                    <span>Logout</span>
                </a>
            </li>
        </ul>
    </div>
</div>
<div id="main">

    <!-- begin::header -->
    <div class="header">

        <!-- begin::header left -->
        <ul class="navbar-nav">

            <!-- begin::navigation-toggler -->
            <li class="nav-item navigation-toggler">
                <a href="#" class="nav-link">
                    <i data-feather="menu"></i>
                </a>
            </li>
            <!-- end::navigation-toggler -->

            <!-- begin::header-logo -->
            <li class="nav-item" id="header-logo">
                <a href="{{url('member/dashboard')}}">
                    <img class="logo" src="{{asset('public/backEnd/')}}/assets/media/image/logo.png" alt="logo">
                    <img class="logo-sm" src="{{asset('public/backEnd/')}}/assets/media/image/logo-sm.png" alt="small logo">
                    <img class="logo-dark" src="{{asset('public/backEnd/')}}/assets/media/image/logo-dark.png" alt="dark logo">
                </a>
            </li>
            <!-- end::header-logo -->
        </ul>
        <!-- end::header left -->

        <!-- begin::header-right -->
        <div class="header-right">
            <ul class="navbar-nav">

                <!-- begin::search-form -->
                <li class="nav-item search-form">
                    <div class="row">
                        <div class="col-md-6">
                            <form>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Search">
                                    <div class="input-group-append">
                                        <button class="btn btn-default" type="button">
                                            <i data-feather="search"></i>
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </li>
                <!-- end::search-form -->

                <!-- begin::header minimize/maximize -->
                <li class="nav-item dropdown">
                    <a href="#" class="nav-link" title="Fullscreen" data-toggle="fullscreen">
                        <i class="maximize" data-feather="maximize"></i>
                        <i class="minimize" data-feather="minimize"></i>
                    </a>
                </li>
                <!-- end::header minimize/maximize -->

                <!-- begin::header messages dropdown -->
                <li class="nav-item dropdown">
                    <a href="#" class="nav-link nav-link-notify" title="Log out" data-toggle="dropdown">
                        <i data-feather="log-out"></i>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right dropdown-menu-big">
                        <div>
                            <ul class="list-group list-group-flush">
                                <li>
                                    <a href="{{url('member/sign-out')}}" onclick="event.preventDefault();document.getElementById('logout-form').submit();"  class="list-group-item d-flex hide-show-toggler">
                                        <div>
                                            <figure class="avatar avatar-sm m-r-15">
                                                <img src="{{asset($memberInfo->profilepic)}}"
                                                     class="rounded-circle" alt="user">
                                            </figure>
                                        </div>
                                        <div class="flex-grow-1">
                                            <p class="mb-0 line-height-20 d-flex justify-content-between">
                                                {{$memberInfo->name}}
                                                <i title="Make unread" data-toggle="tooltip"
                                                   class="hide-show-toggler-item fa fa-circle-o font-size-11"></i>
                                            </p>
                                            <div class="small text-muted">
                                                <span>Logout</span>
                                            </div>
                                        </div>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </li>
                <!-- end::header messages dropdown -->

                
            </ul>

            <!-- begin::mobile header toggler -->
            <ul class="navbar-nav d-flex align-items-center">
                <li class="nav-item header-toggler">
                    <a href="#" class="nav-link">
                        <i data-feather="arrow-down"></i>
                    </a>
                </li>
            </ul>
            <!-- end::mobile header toggler -->
        </div>
        <!-- end::header-right -->
    </div>
    <!-- end::header -->

    <!-- begin::main-content -->
    <main class="main-content">

        @yield('content')

    </main>
    <!-- end::main-content -->

    <!-- begin::footer -->
    <footer>
        <div class="container-fluid">
            <div>© @php date('Y')@endphp Journeyforex</div>
            <div>
                <nav class="nav">
                    <a href="#" class="nav-link">Support</a>
                    <a href="#" class="nav-link">Visit Us</a>
                    <a href="#" class="nav-link">Get Help</a>
                </nav>
            </div>
        </div>
    </footer>
    <!-- end::footer -->

</div>
<!-- end::main -->

<div class="modal fade" tabindex="-1" role="dialog" id="compose">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Compose Email</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <i class="ti-close"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="d-flex justify-content-between m-b-20">
                    <div>
                        <a href="#" data-toggle="tooltip" title=""
                           class="btn btn-outline-light btn-sm mr-2"
                           data-original-title="Keep">
                            <i data-feather="save"></i>
                        </a>
                        <a href="#" data-toggle="tooltip" title=""
                           class="btn btn-outline-light btn-sm mr-2"
                           data-original-title="Delete">
                            <i data-feather="trash-2"></i>
                        </a>
                    </div>
                </div>
                <form>
                    <div class="form-group">
                        <input type="text" class="form-control tagsinput" placeholder="To"
                               value="example@test.com.tr" required>
                    </div>
                    <div class="form-group">
                        <input type="text" class="form-control" placeholder="Subject" required>
                    </div>
                    <div class="form-group">
                        <div class="custom-file">
                            <input type="file" class="custom-file-input" multiple id="customFileLangHTML">
                            <label class="custom-file-label" for="customFileLangHTML" data-browse="Select files">Voeg je document toe</label>
                        </div>
                    </div>
                    <div>
                        <div class="compose-quill-editor mb-3"></div>
                        <div class="d-flex justify-content-between">
                            <div class="compose-quill-toolbar">
                            <span class="ql-formats mr-0">
                                <button class="ql-bold"></button>
                                <button class="ql-italic"></button>
                                <button class="ql-underline"></button>
                                <button class="ql-link"></button>
                                <button class="ql-image"></button>
                            </span>
                            </div>
                            <button class="btn btn-primary">
                                <i data-feather="send" class="mr-2"></i>
                                Send
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Plugin scripts -->
<script src="{{asset('public/backEnd/')}}/vendors/bundle.js"></script>

<!-- Chartjs -->
<script src="{{asset('public/backEnd/')}}/vendors/charts/chartjs/chart.min.js"></script>
<!-- Circle progress -->
<script src="{{asset('public/backEnd/')}}/vendors/circle-progress/circle-progress.min.js"></script>

<!-- Apex Chart -->
<script src="{{asset('public/backEnd/')}}/../../apexcharts.com/samples/assets/irregular-data-series.js"></script>
<script src="{{asset('public/backEnd/')}}/vendors/charts/apex/apexcharts.min.js"></script>
<!-- Prism -->
<script src="{{asset('public/backEnd/')}}/vendors/prism/prism.js"></script>
<!-- Javascript -->
<script src="{{asset('public/backEnd/')}}/vendors/dataTable/jquery.dataTables.min.js"></script>
<!-- Bootstrap 4 and responsive compatibility -->
<script src="{{asset('public/backEnd/')}}/vendors/dataTable/dataTables.bootstrap4.min.js"></script>
<script src="{{asset('public/backEnd/')}}/vendors/dataTable/dataTables.responsive.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
    flatpickr("#flatpickr", {
        dateFormat: "Y m d",
    });
</script>
<!-- datepkr -->
<script src="{{asset('public/backEnd/')}}/assets/js/examples/dashboard.js"></script>
<script src="{{asset('public/backEnd/')}}/assets/js/toastr.min.js"></script>
 {!! Toastr::message() !!}
<div class="colors"> <!-- To use theme colors with Javascript -->
    <div class="bg-primary"></div>
    <div class="bg-primary-bright"></div>
    <div class="bg-secondary"></div>
    <div class="bg-secondary-bright"></div>
    <div class="bg-info"></div>
    <div class="bg-info-bright"></div>
    <div class="bg-success"></div>
    <div class="bg-success-bright"></div>
    <div class="bg-danger"></div>
    <div class="bg-danger-bright"></div>
    <div class="bg-warning"></div>
    <div class="bg-warning-bright"></div>
</div>

<!-- App scripts -->
<script src="{{asset('public/backEnd/')}}/assets/js/app.min.js"></script>

<script src="{{asset('public/backEnd/')}}/vendors/select2/js/select2.min.js"></script>



 
  <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
  
  <script>
    $(document).ready(function() {
        $('#summernote').summernote();
    });
  </script>
  
  
  
  
<script>
$('.select2').select2({
    placeholder: 'Select'
});

$(document).ready(function (){
    $('#myTable').DataTable();
});
tinymce.init({
  selector: 'textarea.full-featured-non-premium',
  


  plugins: 'print preview paste importcss searchreplace autolink autosave save directionality code visualblocks visualchars fullscreen image link media template codesample table charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount imagetools textpattern noneditable help charmap quickbars emoticons',
  imagetools_cors_hosts: ['picsum.photos'],
  menubar: 'file edit view insert format tools table help',
  toolbar: 'undo redo | bold italic underline strikethrough | fontselect fontsizeselect formatselect | alignleft aligncenter alignright alignjustify | outdent indent |  numlist bullist | forecolor backcolor removeformat | pagebreak | charmap emoticons | fullscreen  preview save print | insertfile image media template link anchor codesample | ltr rtl',
      toolbar_sticky: true,
      autosave_ask_before_unload: true,
      autosave_interval: "30s",
      autosave_prefix: "{path}{query}-{id}-",
      autosave_restore_when_empty: false,
      autosave_retention: "2m",
      image_advtab: true,
      content_css: '//www.tiny.cloud/css/codepen.min.css',
      link_list: [
        { title: 'My page 1', value: 'http://www.tinymce.com' },
        { title: 'My page 2', value: 'http://www.moxiecode.com' }
      ],
      image_list: [
        { title: 'My page 1', value: 'http://www.tinymce.com' },
        { title: 'My page 2', value: 'http://www.moxiecode.com' }
      ],
      image_class_list: [
        { title: 'None', value: '' },
        { title: 'Some class', value: 'class-name' }
      ],
      importcss_append: true,
      height: 200,
      file_picker_callback: function (callback, value, meta) {
        /* Provide file and text for the link dialog */
        if (meta.filetype === 'file') {
          callback('https://www.google.com/logos/google.jpg', { text: 'My text' });
        }

        /* Provide image and alt text for the image dialog */
        if (meta.filetype === 'image') {
          callback('https://www.google.com/logos/google.jpg', { alt: 'My alt text' });
        }

        /* Provide alternative source and posted for the media dialog */
        if (meta.filetype === 'media') {
          callback('movie.mp4', { source2: 'alt.ogg', poster: 'https://www.google.com/logos/google.jpg' });
        }
      },
      templates: [
            { title: 'New Table', description: 'creates a new table', content: '<div class="mceTmpl"><table width="98%%"  border="0" cellspacing="0" cellpadding="0"><tr><th scope="col"> </th><th scope="col"> </th></tr><tr><td> </td><td> </td></tr></table></div>' },
        { title: 'Starting my story', description: 'A cure for writers block', content: 'Once upon a time...' },
        { title: 'New list with dates', description: 'New List with dates', content: '<div class="mceTmpl"><span class="cdate">cdate</span><br /><span class="mdate">mdate</span><h2>My List</h2><ul><li></li><li></li></ul></div>' }
      ],
      template_cdate_format: '[Date Created (CDATE): %m/%d/%Y : %H:%M:%S]',
      template_mdate_format: '[Date Modified (MDATE): %m/%d/%Y : %H:%M:%S]',
      height: 600,
      image_caption: true,
      quickbars_selection_toolbar: 'bold italic | quicklink h2 h3 blockquote quickimage quicktable',
      noneditable_noneditable_class: "mceNonEditable",
      toolbar_mode: 'sliding',
      contextmenu: "link image imagetools table",
      
     });
</script>




 <script type="text/javascript">

    $(document).ready(function() {

      $(".btn-success").click(function(){ 
          var html = $(".clone").html();
          $(".increment").before(html);
      });

      $("body").on("click",".btn-danger",function(){ 
          $(this).parents(".control-group").remove();
      });

    });

</script>
@yield('extrajs')
</body>
</html>