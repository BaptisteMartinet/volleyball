//Copyright Imania (c) 2021
//Volleyball
//Trade URL: https://steamcommunity.com/tradeoffer/new/?partner=156107863&token=qmS76kKO (i only accept D.lore gift)

class Player {
	_ply = null;
	_ui = null;
	_playerTargetName = null;
	_eyeTraceName = null;
	_mesureMovement = null;
	_eyeTrace = null;

	_lastJumpTime = null;

	_HITBOX_RADIUS = 50;

	constructor (ply) {
		this._ply = ply;

		/* UI */
		this._ui = Entities.CreateByClassname("game_ui");
		this._ui.__KeyValueFromString("FieldOfView", "-1.0");
		this._ui.__KeyValueFromInt("spawnflags", 0);
		EntFireByHandle(this._ui, "AddOutput", "PressedAttack @script:RunScriptCode:performAction(0):0.0:-1", 0.00, null, null);
		EntFireByHandle(this._ui, "AddOutput", "PressedAttack2 @script:RunScriptCode:performAction(1):0.0:-1", 0.00, null, null);
		EntFireByHandle(this._ui, "Activate", "", 0.1, this._ply, null);

		/* EYE TRACE */
		this._playerTargetName = UniqueString("_ply");
		this._eyeTraceName = UniqueString("_trace");
		this._mesureMovement = Entities.CreateByClassname("logic_measure_movement");
		this._eyeTrace = Entities.CreateByClassname("info_target");
		//setup
		this._eyeTrace.__KeyValueFromString("targetname", this._eyeTraceName);
		this._ply.__KeyValueFromString("targetname", this._playerTargetName);
		this._mesureMovement.__KeyValueFromInt("measuretype", 1);
		this._mesureMovement.__KeyValueFromString("measurereference", "referenceTarget");
		this._mesureMovement.__KeyValueFromString("targetreference", "referenceTarget");
		this._mesureMovement.__KeyValueFromString("target", this._eyeTraceName);
		this._mesureMovement.__KeyValueFromString("measureretarget", "referenceTarget");
		this._mesureMovement.__KeyValueFromFloat("targetscale", 1.0);
		EntFireByHandle(this._mesureMovement,"setmeasurereference", "referenceTarget", 0, null, null);
		EntFireByHandle(this._mesureMovement,"setmeasuretarget", this._playerTargetName, 0, null, null);
		EntFireByHandle(this._mesureMovement,"enable", "", 0, null, null);

		this._lastJumpTime = Time();
	}

	function mb1(ball) {
		DebugDrawBox(this._ply.EyePosition(), Vector(-this._HITBOX_RADIUS/2, -this._HITBOX_RADIUS/2, -this._HITBOX_RADIUS/2), Vector(this._HITBOX_RADIUS/2, this._HITBOX_RADIUS/2, this._HITBOX_RADIUS/2), 255, 0, 0, 10, 10);
		if (distance3D(this._ply.EyePosition(), ball._pos) > this._HITBOX_RADIUS)
			return;
		ball._dir = clampVec(this._eyeTrace.GetForwardVector() + Vector(0, 0, 0.3) + (normalizeVec(this._ply.GetVelocity()) * 0.4), Vector(-1, -1, -1), Vector(1, 1, 1));
		ball._isMoving = true;
	}

	function mb2() {
		local currTime = Time();

		if (currTime - this._lastJumpTime < 1)
			return;
		this._lastJumpTime = currTime;

		this._ply.SetVelocity(this._ply.GetVelocity() + Vector(0, 0, 200));
	}
}
