<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title><?php echo e(config('admin.title'), false); ?> | <?php echo e(trans('admin.login'), false); ?></title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

  <?php if(!is_null($favicon = Admin::favicon())): ?>
  <link rel="shortcut icon" href="<?php echo e($favicon, false); ?>">
  <?php endif; ?>

  <!-- Bootstrap 3.3.5 -->
  <link rel="stylesheet" href="<?php echo e(admin_asset("vendor/laravel-admin/AdminLTE/bootstrap/css/bootstrap.min.css"), false); ?>">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="<?php echo e(admin_asset("vendor/laravel-admin/font-awesome/css/font-awesome.min.css"), false); ?>">
  <!-- Theme style -->
  <link rel="stylesheet" href="<?php echo e(admin_asset("vendor/laravel-admin/AdminLTE/dist/css/AdminLTE.min.css"), false); ?>">
  <!-- iCheck -->
  <link rel="stylesheet" href="<?php echo e(admin_asset("vendor/laravel-admin/AdminLTE/plugins/iCheck/square/blue.css"), false); ?>">

  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="//oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="//oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
</head>
<body class="hold-transition login-page" <?php if(config('admin.login_background_image')): ?>style="background: url(<?php echo e(config('admin.login_background_image'), false); ?>) no-repeat;background-size: cover;"<?php endif; ?>>
<div class="login-box">
  <div class="login-logo">
    <a href="<?php echo e(admin_url('/'), false); ?>"><b><?php echo e(config('admin.name'), false); ?></b></a>
  </div>
  <!-- /.login-logo -->
  <div class="login-box-body">
    <p class="login-box-msg"><?php echo e(trans('admin.login'), false); ?></p>

    <form action="<?php echo e(admin_url('auth/login'), false); ?>" method="post">
      <div class="form-group has-feedback <?php echo !$errors->has('username') ?: 'has-error'; ?>">

        <?php if($errors->has('username')): ?>
          <?php $__currentLoopData = $errors->get('username'); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $message): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
            <label class="control-label" for="inputError"><i class="fa fa-times-circle-o"></i><?php echo e($message, false); ?></label><br>
          <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
        <?php endif; ?>

        <input type="text" class="form-control" placeholder="<?php echo e(trans('admin.username'), false); ?>" name="username" value="<?php echo e(old('username'), false); ?>">
        <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback <?php echo !$errors->has('password') ?: 'has-error'; ?>">

        <?php if($errors->has('password')): ?>
          <?php $__currentLoopData = $errors->get('password'); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $message): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
            <label class="control-label" for="inputError"><i class="fa fa-times-circle-o"></i><?php echo e($message, false); ?></label><br>
          <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
        <?php endif; ?>

        <input type="password" class="form-control" placeholder="<?php echo e(trans('admin.password'), false); ?>" name="password">
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
      </div>
      <div class="row">
        <div class="col-xs-8">
          <?php if(config('admin.auth.remember')): ?>
          <div class="checkbox icheck">
            <label>
              <input type="checkbox" name="remember" value="1" <?php echo e((!old('username') || old('remember')) ? 'checked' : '', false); ?>>
              <?php echo e(trans('admin.remember_me'), false); ?>

            </label>
          </div>
          <?php endif; ?>
        </div>
        <!-- /.col -->
        <div class="col-xs-4">
          <input type="hidden" name="_token" value="<?php echo e(csrf_token(), false); ?>">
          <button type="submit" class="btn btn-primary btn-block btn-flat"><?php echo e(trans('admin.login'), false); ?></button>
        </div>
        <!-- /.col -->
      </div>
    </form>

  </div>
  <!-- /.login-box-body -->
</div>
<!-- /.login-box -->

<!-- jQuery 2.1.4 -->
<script src="<?php echo e(admin_asset("vendor/laravel-admin/AdminLTE/plugins/jQuery/jQuery-2.1.4.min.js"), false); ?> "></script>
<!-- Bootstrap 3.3.5 -->
<script src="<?php echo e(admin_asset("vendor/laravel-admin/AdminLTE/bootstrap/js/bootstrap.min.js"), false); ?>"></script>
<!-- iCheck -->
<script src="<?php echo e(admin_asset("vendor/laravel-admin/AdminLTE/plugins/iCheck/icheck.min.js"), false); ?>"></script>
<script>
  $(function () {
    $('input').iCheck({
      checkboxClass: 'icheckbox_square-blue',
      radioClass: 'iradio_square-blue',
      increaseArea: '20%' // optional
    });
  });
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<script type="module" src="/firebase-messaging-sw.js"></script>
<script type="module">
    // Import the functions you need from the SDKs you need
    import { initializeApp } from "https://www.gstatic.com/firebasejs/9.8.3/firebase-app.js"
    import { getMessaging,onMessage,getToken } from "https://www.gstatic.com/firebasejs/9.8.3/firebase-messaging.js"


    // TODO: Add SDKs for Firebase products that you want to use
    // https://firebase.google.com/docs/web/setup#available-libraries

    // Your web app's Firebase configuration
    // For Firebase JS SDK v7.20.0 and later, measurementId is optional
   const firebaseConfig = {
    apiKey: "AIzaSyDqMKCEvSxrusxvJQN22qwH-W2rmt10VSI",
    authDomain: "dbestech-food-app-commercial.firebaseapp.com",
    projectId: "dbestech-food-app-commercial",
    storageBucket: "dbestech-food-app-commercial.appspot.com",
    messagingSenderId: "542490378494",
    appId: "1:542490378494:web:beca27ddb1df27b05de5af"
  };

    // Initialize Firebase
    const app = initializeApp(firebaseConfig);
    const messaging = getMessaging(app);

    getStartToken();
    function getStartToken(){
        getToken(messaging, { vapidKey: 'BP-wFkN56uHU1j95xPsHJiLaYp8jMYxbOsDewi4nz-qOTIwHymLlaqRXG400KsSYDOZjH-JgjEMUcgcjRiCn-ic' }).then((currentToken) => {
            if (currentToken) {
                console.log("currentToken--->"+currentToken);
                sendTokenToServer(currentToken);
            } else {
// Show permission request.
                RequestPermission();
                setTokenSentToServer(false);
            }

        }).catch((err) => {
            console.log("currentToken --err--err--->"+err);
            setTokenSentToServer(false);
        });


    }
    function RequestPermission(){
        messaging.requestPermission().then(function(permission){
            if (permission === 'granted') {
                console.log("have Permission");//calls method again and to sent token to server
                getStartToken();
            }
            else{
                console.log("Permission Denied");
            }
        }).catch(function(err){
            console.log(err);
        })
    }
    function sendTokenToServer(token){
        //   if (!isTokensendTokenToServer()) {
        $.ajax({
            url: "/api/v1/send_token",
            type: 'get',
            data: {push_token:token},
            success: function (response) {
                console.log("token_response"+response);
                setTokenSentToServer(true);
            },
            error: function (err) {
                setTokenSentToServer(false);
            },});
        // }
    }
    function isTokensendTokenToServer() {
        return window.localStorage.getItem('sendTokenToServer') === '1';
    }
    function setTokenSentToServer(sent) {
        window.localStorage.setItem('sendTokenToServer', sent ? '1' : '0');
    }

    // Message received
    onMessage(messaging, (payload) => {
        console.log('Message received. ', payload);
        // ...
    });



</script>
</body>
</html>
<?php /**PATH /www/wwwroot/dbf.dbestech.com/vendor/encore/laravel-admin/src/../resources/views/login.blade.php ENDPATH**/ ?>