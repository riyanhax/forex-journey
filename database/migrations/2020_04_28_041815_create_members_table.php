<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateMembersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('members', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name');
            $table->string('slug');
            $table->string('email')->length('30')->unique();
            $table->string('phone')->length('30')->unique()->nullable();
            $table->string('profilepic')->default('public/frontEnd/images/member-profile.png');
            $table->string('password');
            $table->string('designation')->length('40')->nullable();
            $table->string('phone2')->length('25')->nullable();
            $table->string('country')->length('55')->nullable();
            $table->string('district')->length('55')->nullable();
            $table->text('streetAddress')->length('150')->nullable();
            $table->string('postalCode')->length('55')->nullable();
            $table->text('bio')->length('150')->nullable();
            $table->string('passResetToken')->length('40')->nullable();
            $table->string('verifyToken')->length('30');
            $table->tinyInteger('agree')->length('2');
            $table->tinyInteger('online')->length('2')->default('0');
            $table->tinyInteger('status')->length('2')->default('0');
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
        Schema::dropIfExists('members');
    }
}
