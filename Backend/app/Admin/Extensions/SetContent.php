<?php


namespace App\Admin\Extensions;
use Encore\Admin\Form\Field;
use Illuminate\Support\Facades\Log;

class SetContent extends Field
{
    protected $view = 'admin.setcontent';

    protected static $css = [];

    protected static $js = [];

    public function render()
    {
        $this->script = <<<EOT

EOT;
        return parent::render();
    }
}
