<?php

namespace App\Admin\Controllers;

use App\Models\BusinessSetting;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class BusinessSettingController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Business Setting';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new BusinessSetting());

        $grid->column('id', __('Id'));
        $grid->column('key', __('Key'));
        //$grid->column('value', __('Value'));//->width(500)->limit(200);
        $grid->value()->display(function($value){

                $val= $value;
                if(empty($val)){
                    return $value;
                }

            $count = count($val);
            $arrKeys = array_keys($val);
            $arrValues = array_values($val);
            $str_arr='';
            if($count>1){
                for($i=0; $i<$count; $i++){
                    if($arrValues[$i]==1){
                        $button=
                                'background-color: #4CAF50;
  border: none;
  color: white;
  padding: 10px 20px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 4px 2px;
  cursor: pointer;border-radius: 8px;';

                    }else{
                        $button='';
                    }

                    $str_arr .= "<div><span style ='background-color: #4CAF50;
  border: none;
  color: white;
  padding: 10px 20px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 4px 2px;
  cursor: pointer;border-radius: 8px;'>$arrKeys[$i]</span> <span style='$button'>$arrValues[$i]</span></div>";
                }
            }else{
              return  $arrValues[0];
            }

         return  $str_arr;

            //return "<h1>$val[1]</h1>";
        })->width(500);

        $grid->column('created_at', __('Created at'));
        $grid->column('updated_at', __('Updated at'));

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
        $show = new Show(BusinessSetting::findOrFail($id));

        $show->field('id', __('Id'));
        $show->field('key', __('Key'));
        $show->field('value', __('Value'))->label();
        $show->field('created_at', __('Created at'));
        $show->field('updated_at', __('Updated at'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new BusinessSetting());

        $form->text('key', __('Key'));
        $form->setcontent('value');

        /*
        create custom fields for value. Value is json format.
        we combine client id and secret id for value and convert it to json
        */
//        $form->embeds('value', function($form){
//
//           $form->number('status', __('Status'))->default(1)->max(1)->min(0);
//           $form->text('paypal_client_id', __('Client ID')) ;
//           $form->text('paypal_secret_id', __('Secret ID'));
//        });
        $form->saving(function (Form $form) {
            $value = $form->model()->getAttribute("value");
       
            $end_value = [];
            $end_str = "";
            foreach ($value as $k=>$v){
                if($k=="content"){
                    $end_str =  $form->$k;
                }else{
                    $end_value[$k]=$form->$k;
                }
                $form->ignore($k);
            }
         
            if(count($end_value)>0){
             $form->value = json_encode($end_value);
            }else{
             $form->value = $end_str;
            }
        });

        return $form;
    }
}
