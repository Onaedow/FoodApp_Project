<?php

namespace App\Admin\Controllers;

use App\Models\DeliveryMan;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use \App\Models\Zone;

class DeliveryMenController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'DeliveryMan';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new DeliveryMan());
        $grid->Column('id', __('ID'));
        $grid->Column('name', __('Name'));
        $grid->Column('email', __('Email'));
        $grid->Column('phone', __('Phone'));
        
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
        $show = new Show(DeliveryMan::findOrFail($id));



        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new DeliveryMan());
        
  
     
        $form->text('name', __('Name'))->creationRules(['required',"min:4, unique:delivery_men, name"])->updateRules(['required',"min:4, unique:name"]);
        $form->email('email', __('email'));
        $form->text('phone', __('Phone'))->creationRules('required|min:11')->updateRules('required|min:11');
        $form->text('password', __('Password'))->creationRules('required|min:6')->updateRules('required|min:6');
        
        $form->number('identity_number', __('identity Number'))->creationRules('required|min:6')->updateRules('required|min:6');
        //$form->('zone_id', __('Zone'));
        $form->select('zone_id', __('Select zone'))->options(function(){
            $zones=Zone::all();
           // dd($zones);
            $selectedZone=[];
            foreach ($zones as $key => $zone){
                $selectedZone[$zone->id]=$zone->name;
             
            }
           // dd($selectedZone);
            return $selectedZone;
        });
        
        $form->saving(function (Form $form) {
           
              $isExist = DeliveryMan::where('phone', $form->phone)->get()->first();
              if($isExist){
               //   return redirect()->back()->with('alert','Phone number already exist');
              }
              $password = bcrypt($form->password);
              $form->password=$password;
              
        });
       
        return $form;
    }
}
