<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateEmployeeWalletsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('employee_wallets', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->bigInteger('employeeId');
            $table->string('bankname');
            $table->string('branchlocation');
            $table->string('acholderno');
            $table->string('acno');
            $table->string('bkashnumber');
            $table->string('roketnumber');
            $table->string('nagodnumber');
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
        Schema::dropIfExists('employee_wallets');
    }
}
