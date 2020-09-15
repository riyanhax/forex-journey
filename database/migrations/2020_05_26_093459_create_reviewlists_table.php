<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateReviewlistsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('reviewlists', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedInteger('brokerreview_id');
            $table->string('actype')->nullable();
            $table->string('spreadform')->nullable();
            $table->string('commision')->nullable();
            $table->string('execution')->nullable();
            $table->string('mindiposit')->nullable();
            $table->string('chooseacount')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('reviewlists');
    }
}
