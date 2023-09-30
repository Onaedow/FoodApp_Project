<?php ($currency=\App\Models\BusinessSetting::where(['key'=>'currency'])->first()->value); ?>

    <!DOCTYPE html>
<html lang="<?php echo e(str_replace('_', '-', app()->getLocale()), false); ?>">
<head>
    <meta charset="utf-8">
    <title>
        <?php echo $__env->yieldContent('title'); ?>
    </title>
    <!-- SEO Meta Tags-->
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="author" content="">
    <!-- Viewport-->
    
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Favicon and Touch Icons-->
    <link rel="shortcut icon" href="favicon.ico">
    <!-- Font -->
    <!-- CSS Implementing Plugins -->
    <link rel="stylesheet" href="<?php echo e(asset('assets/admin'), false); ?>/css/vendor.min.css">
    <link rel="stylesheet" href="<?php echo e(asset('assets/admin'), false); ?>/vendor/icon-set/style.css">
    <link rel="stylesheet" href="<?php echo e(asset('assets/admin'), false); ?>/css/custom.css">
    <!-- CSS Front Template -->
    <link rel="stylesheet" href="<?php echo e(asset('assets/admin'), false); ?>/css/theme.minc619.css?v=1.0">

    <style>
        .stripe-button-el {
            display: none !important;
        }

        .razorpay-payment-button {
            display: none !important;
        }
    </style>
    <script
        src="<?php echo e(asset('assets/admin'), false); ?>/vendor/hs-navbar-vertical-aside/hs-navbar-vertical-aside-mini-cache.js"></script>
    <link rel="stylesheet" href="<?php echo e(asset('assets/admin'), false); ?>/css/toastr.css">

</head>
<!-- Body-->
<body class="toolbar-enabled">
<!-- Page Content-->
<div class="container pb-5 mb-2 mb-md-4">
    <div class="row">
        <div class="col-md-12 mb-5 pt-5">
            <center class="">
                <h1>Payment method</h1>
            </center>
        </div>
        <?php ($order=\App\Models\Order::find(session('order_id'))); ?>
        <section class="col-lg-12">
            <div class="checkout_details mt-3">
                <div class="row">


                    <?php ($config=\App\CentralLogics\Helpers::get_business_settings('paypal')); ?>
                    <?php if($config['status']): ?>
                        <div class="col-md-6 mb-4" style="cursor: pointer">
                            <div class="card">
                                <div class="card-body pb-0 pt-1" style="height: 70px">
                                    <form class="needs-validation" method="POST" id="payment-form"
                                          action="<?php echo e(route('pay-paypal'), false); ?>">
                                        <?php echo e(csrf_field(), false); ?>

                                        <button class="btn btn-block" type="submit">
                                            <img width="100"
                                                 src="<?php echo e(asset('assets/admin/img/paypal.png'), false); ?>"/>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    <?php endif; ?>


                </div>
            </div>
        </section>
    </div>
</div>

<!-- JS Front -->
<script src="<?php echo e(asset('assets/admin'), false); ?>/js/custom.js"></script>
<script src="<?php echo e(asset('assets/admin'), false); ?>/js/vendor.min.js"></script>
<script src="<?php echo e(asset('assets/admin'), false); ?>/js/theme.min.js"></script>
<script src="<?php echo e(asset('assets/admin'), false); ?>/js/sweet_alert.js"></script>
<script src="<?php echo e(asset('assets/admin'), false); ?>/js/toastr.js"></script>
<script src="<?php echo e(asset('assets/admin'), false); ?>/js/bootstrap.min.js"></script>




<?php echo Toastr::message(); ?>


</body>
</html>
<?php /**PATH /www/wwwroot/dbf.dbestech.com/resources/views/payment-view.blade.php ENDPATH**/ ?>