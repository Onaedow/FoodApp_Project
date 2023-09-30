<?php

namespace App\Admin\Controllers;

use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Facades\Admin;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use \App\Models\Order;
use \App\Models\DeliveryMan;
use \App\Models\OrderTrack;
use Illuminate\Support\Facades\DB;
use App\CentralLogics\Helpers;

class OrderController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Order';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new Order());
        /*
        how many columns to show as fixed. First three and last two are fixed
        */
        $grid->model()->orderBy('id','desc');
        $grid->fixColumns(3, -2);
        $grid->column('id', __('Order Id'));
        $grid->column('user_id', __('User Id'));
        $grid->column('order_amount', __('Order amount'));
        $grid->column('payment_status', __('Payment status'));
        $grid->column('order_status', __('Order status'));
        $grid->column('confirmed', __('Confirmed'));
        $grid->column('accepted', __('Accepted'));
        $grid->column('scheduled', __('Scheduled'));
        $grid->column('processing', __('Processing'));
        $grid->column('handover', __('Handover'));
        $grid->column('failed', __('Failed'));
        $grid->column('scheduled_at', __('Scheduled at'));
     
        $grid->column('order_note', __('Order note'));
        $grid->column('created_at', __('Created at'));
        $grid->column('updated_at', __('Updated at'));
        $grid->column('delivery_charge', __('Delivery charge'));
     
        $grid->column('otp', __('Otp'));
        $grid->column('pending', __('Pending'));
        $grid->column('picked_up', __('Picked up'));
        $grid->column('delivered', __('Delivered'));
        $grid->column('canceled', __('Canceled'));



        return $grid;
    }

    /**
     * Make a show builder.
     *
     * @param mixed $id
     * @return Show
     */
    protected function detail($id)
    {
        $show = new Show(Order::findOrFail($id));

        $show->field('id', __('Order Id'));
        $show->field('user_id', __('User Id'));
        $show->field('order_amount', __('Order amount'));
        $show->field('payment_status', __('Payment status'));
        $show->field('order_status', __('Order status'));
        $show->field('confirmed', __('Confirmed'));
        $show->field('accepted', __('Accepted'));
        $show->field('scheduled', __('Scheduled'));
        $show->field('processing', __('Processing'));
        $show->field('handover', __('Handover'));
        $show->field('failed', __('Failed'));
        $show->field('scheduled_at', __('Scheduled at'));
       
        $show->field('order_note', __('Order note'));
        $show->field('created_at', __('Created at'));
        $show->field('updated_at', __('Updated at'));
        $show->field('delivery_charge', __('Delivery charge'));
  
       $res = $show->getModel()->getAttribute("delivery_address");
       if(!empty($res)){
           $end_res = json_decode($res,true);
           $show->field('contact_person_name', __('Contact Person Name'))->as(function ($item) use($end_res){
               return $end_res["contact_person_name"];
           });
           $show->field('contact_person_number', __('Contact Person Number'))->as(function ($item) use($end_res){
               return $end_res["contact_person_number"];
           });
           $show->field('address', __('address'))->as(function ($item) use($end_res){
               return $end_res["address"];
           });


           $show->field('Position')->latlong($end_res["latitude"],$end_res["longitude"], $height = 400, $zoom = 16);


       }



        $show->field('otp', __('Otp'));
        $show->field('pending', __('Pending'));
        $show->field('picked_up', __('Picked up'));
        $show->field('delivered', __('Delivered'));
        $show->field('canceled', __('Canceled'));


        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new Order());

        $form->text('user_id', __('User id'))->disable();
        $form->decimal('order_amount', __('Order amount'))->readonly();
        $form->text('payment_status', __('Payment status'))->default('pending');
        $form->text('order_status', __('Current status'))->disable();
        $form->select('status_id', __('Change status'))->options(function(){
            $list=[];
            $statuses = OrderTrack::all();
            foreach($statuses as $status){
                $list[$status->id]=$status->order_status;
            }
            return $list;
        });
          $form->select('delivery_man_id', __('Choose a delivery boy'))->options(function(){
            $men=[];
            $allMan = DeliveryMan::all();
            foreach($allMan as $man){
                $men[$man->id]=$man->name;
            }
            return $men;
        });
        $form->datetime('confirmed', __('Confirmed'))->default(date('Y-m-d H:i:s'));
        $form->datetime('accepted', __('Accepted'))->default(date('Y-m-d H:i:s'));
        $form->switch('scheduled', __('Scheduled'));
        $form->datetime('processing', __('Processing'))->default(date('Y-m-d H:i:s'));
        $form->datetime('handover', __('Handover'))->default(date('Y-m-d H:i:s'));
        $form->datetime('failed', __('Failed'))->default(date('Y-m-d H:i:s'));
        $form->datetime('scheduled_at', __('Scheduled at'))->default(date('Y-m-d H:i:s'));
        $form->number('delivery_address_id', __('Delivery address id'))->readonly();
        $form->textarea('order_note', __('Order note'));
        $form->decimal('delivery_charge', __('Delivery charge'));

        $path = Request()->getPathInfo();
        $paths = explode("/",$path);
        $id = $paths[3];
        $result = DB::table("orders")->where("id","=",$id)->value("delivery_address");
        if($result){
            $end_res = json_decode($result,true);
            $form->latlong('latitude', 'longitude', 'Position')->default(['lat' => $end_res["latitude"], 'lng' => $end_res["longitude"]]);
        }
        $form->text('otp', __('Otp'));
        $form->datetime('pending', __('Pending'))->default(date('Y-m-d H:i:s'));
        $form->datetime('picked_up', __('Picked up'))->default(date('Y-m-d H:i:s'));
        $form->datetime('delivered', __('Delivered'))->default(date('Y-m-d H:i:s'));
        $form->datetime('canceled', __('Canceled'))->default(date('Y-m-d H:i:s'));
         $form->hidden('delivery_address');
        $form->submitted(function (Form $form) {
            // $form->ignore('delivery_address');
             $form->ignore('latitude');
              $form->ignore('longitude');
        });
        $form->saving(function (Form $form) {
            

              $res_num = DB::table('order_tracks')->get();
              foreach($res_num as $res){
                if($form->status_id==$res->id){

                 $form->order_status=$res->order_status;
              }
              }
        });
        $form->saved(function (Form $form){
                    /*
                    with model() we can access all the property of the order table
                    $form->model()->id is the order id in this case
                    */
                    $status=$form->model()->order_status;
                    $order = Order::find($form->model()->id);
                 
                    if(!empty($order->user->cm_firebase_token)){
                           $fcm_token = $order->user->cm_firebase_token;
                      
                    $data = [
                        'title' =>trans('messages.order_push_title'),
                        'description' => Helpers::order_status_update_message($status),
                        'order_id' => $form->model()->id,
                        'image' => '',
                        'type'=> 'order_status'
                    ];

                    Helpers::send_push_notif_to_device($fcm_token, $data);
                 
                    if(!empty($order->delivery_man->fcm_token)){
                         $fcm_token = $order->delivery_man->fcm_token;

                         Helpers::send_push_notif_to_device($fcm_token, $data, 1);
                    }
                       
                    }
        });
        return $form;
    }
}
