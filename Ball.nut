//Copyright Imania (c) 2021
//Volleyball
//Trade URL: https://steamcommunity.com/tradeoffer/new/?partner=156107863&token=qmS76kKO (i only accept D.lore gift)

class Ball {
	_obj = null;
	_baseCircleObj = null;
	_pos = null;
	_dir = null;
	_isMoving = false;

	_SPEED = 350;
	_GRAVITY = 1.2;
	_RADIUS = 12;

	constructor (obj, baseCircle) {
	    this._obj = obj;
	    this._baseCircleObj = baseCircle;
	    this._pos = this._obj.GetOrigin();
	    this._dir = Vector(0, 0, 0);
	}

	function update(dt, boxes) {
		if (!this._isMoving)
			return;
		if ((this._dir.z -= this._GRAVITY * dt) < -1)
			this._dir.z = -1;
		this.manageColision(boxes);
		this._pos = this._pos + this._dir * (this._SPEED * dt);
		this._obj.SetOrigin(this._pos);
		this._baseCircleObj.SetOrigin(Vector(this._pos.x, this._pos.y, boxes[0]._topRight.z + 1));
	}

	function manageColision(boxes) {
		foreach (boxType, box in boxes) {
			local point = clampVec(this._pos, box._bottomLeft, box._topRight);

		    if (distance3D(this._pos, point) <= this._RADIUS) {
		    	switch (boxType) {
		    		/* GROUND collision */
		    	    case 0:
		    	    	if (this._dir.z < 0)
		    	    		if (this._dir.z > -0.1)
		    	    			this._dir.z = 0;
		    	    		else
		    	    			this._dir.z = -this._dir.z * 0.8;
		    	        break;
		    	    /* NET collision */
		    	    case 1: this._dir.x = 0;
		    	    	this._dir.y = 0;
		    	    	break;
		    	    default: break;
		    	}
		    }
		}
	}
}
