(function (console) { "use strict";
var Clock = function() { };
Clock.activate = function(state) {
	if(state != null) Clock.enabled = state.enabled; else Clock.enabled = true;
	Clock.showSeconds = atom.config.get("clock.seconds");
	var this1;
	var _this = window.document;
	this1 = _this.createElement("div");
	this1.classList.add("status-bar-clock");
	this1.classList.add("clock-status");
	this1.classList.add("inline-block");
	Clock.view = this1;
	atom.config.onDidChange("clock.seconds",{ },function(e) {
		Clock.showSeconds = e.newValue;
		Clock.update();
	});
	Clock.toggleCommand = atom.commands.add("atom-workspace","clock:toggle",function(_) {
		Clock.toggle();
	});
	if(Clock.enabled) {
		Clock.timer = new haxe_Timer(1000);
		Clock.timer.run = Clock.handleTimer;
	}
};
Clock.deactivate = function() {
	Clock.toggleCommand.dispose();
	if(Clock.timer != null) {
		Clock.timer.stop();
		Clock.timer = null;
	}
};
Clock.serialize = function() {
	return { enabled : Clock.enabled};
};
Clock.toggle = function() {
	if(Clock.enabled) {
		Clock.view.style.display = "none";
		Clock.enabled = false;
		if(Clock.timer != null) {
			Clock.timer.stop();
			Clock.timer = null;
		}
	} else {
		Clock.view.style.display = "inline-block";
		Clock.enabled = true;
		Clock.update();
		Clock.timer = new haxe_Timer(1000);
		Clock.timer.run = Clock.handleTimer;
	}
};
Clock.handleTimer = function() {
	Clock.update();
};
Clock.update = function() {
	var now = new Date();
	var str = Clock.formatTimePart(now.getHours()) + ":" + Clock.formatTimePart(now.getMinutes());
	if(Clock.showSeconds) str += ":" + Clock.formatTimePart(now.getSeconds());
	Clock.view.textContent = str;
};
Clock.formatTimePart = function(i) {
	if(i < 10) return "0" + i; else if(i == null) return "null"; else return "" + i;
};
Clock.consumeStatusBar = function(bar) {
	bar.addRightTile({ item : Clock.view, priority : -100});
};
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe_Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
};
module.exports = Clock;
Clock.config = { seconds : { 'title' : "Show seconds", 'type' : "boolean", 'default' : true}};
})(typeof console != "undefined" ? console : {log:function(){}});
