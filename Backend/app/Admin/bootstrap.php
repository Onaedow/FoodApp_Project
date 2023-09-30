<?php

/**
 * Laravel-admin - admin builder based on Laravel.
 * @author z-song <https://github.com/z-song>
 *
 * Bootstraper for Admin.
 *
 * Here you can remove builtin form field:
 * Encore\Admin\Form::forget(['map', 'editor']);
 *
 * Or extend custom form field:
 * Encore\Admin\Form::extend('php', PHPEditor::class);
 *
 * Or require js and css assets:
 * Admin::css('/packages/prettydocs/css/styles.css');
 * Admin::js('/packages/prettydocs/js/main.js');
 *
 */

use Encore\Admin\Facades\Admin;

Encore\Admin\Form::forget(['map', 'editor']);
Encore\Admin\Form::extend('setcontent', \App\Admin\Extensions\SetContent::class);
Encore\Admin\Form::extend('zonecontent', \App\Admin\Extensions\ZoneContent::class);

$script = <<<EOT
$(document).ready(function() {
    setInterval(function (){
         getNewToOrder();
	},10*1000);
});


   function getNewToOrder(){
               $.ajax({
                url: "/api/v1/get_new_order",
                type: 'get',
                data: {lastid:1},
                success: function (response) {
                  //  console.log(response.code);
                    if(response.code==0){
                    // update
                      toastr.success('new order!');
                    let music = $("#order_notification")[0];
                    if (music.paused) {
                        music.play();
                    }else{
                        music.pause();
                    }
                      setTimeout(function(){window.location.href="/admin/orders/"+response.data;},"5000");

                    }

                },
                error: function (err) {
                     console.log("err---》"+err);
                },});

        }

EOT;

Admin::script($script);
Admin::html('<div><audio id="order_notification" src="/sound/notification.mp3"></audio>
</div>');
