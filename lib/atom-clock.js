(function (console) { "use strict";
var Clock = function() { };
Clock.activate = function(state) {
	if(state != null) Clock.enabled = state.enabled; else Clock.enabled = true;
	if(Clock.enabled == null) Clock.enabled = true;
	Clock.showSeconds = atom.config.get("clock.seconds");
	var this1;
	var _this = window.document;
	this1 = _this.createElement("div");
	this1.classList.add("status-bar-clock");
	this1.classList.add("clock-status");
	this1.classList.add("inline-block");
	Clock.view = this1;
	if(Clock.enabled) Clock.show(); else Clock.hide();
	Clock.configChangeListener = atom.config.onDidChange("clock.seconds",{ },function(e) {
		Clock.showSeconds = e.newValue;
		Clock.update();
	});
};
Clock.deactivate = function() {
	Clock.configChangeListener.dispose();
	if(Clock.commandShow != null) Clock.commandShow.dispose();
	if(Clock.commandHide != null) Clock.commandHide.dispose();
	if(Clock.timer != null) {
		Clock.timer.stop();
		Clock.timer = null;
	}
};
Clock.serialize = function() {
	return { enabled : Clock.enabled};
};
Clock.show = function() {
	Clock.view.style.display = "inline-block";
	Clock.enabled = true;
	Clock.timer = new haxe_Timer(1000);
	Clock.timer.run = Clock.update;
	Clock.commandHide = atom.commands.add("atom-workspace","clock:hide",function(_) {
		Clock.hide();
	});
	if(Clock.commandShow != null) Clock.commandShow.dispose();
};
Clock.hide = function() {
	Clock.view.style.display = "none";
	Clock.enabled = false;
	if(Clock.timer != null) {
		Clock.timer.stop();
		Clock.timer = null;
	}
	Clock.commandShow = atom.commands.add("atom-workspace","clock:show",function(_) {
		Clock.show();
	});
	if(Clock.commandHide != null) Clock.commandHide.dispose();
};
Clock.update = function() {
	var time = new Date();
	var str = _$Clock_ClockView_$Impl_$.formatTimePart(time.getHours()) + ":" + _$Clock_ClockView_$Impl_$.formatTimePart(time.getMinutes());
	if(Clock.showSeconds) str += ":" + _$Clock_ClockView_$Impl_$.formatTimePart(time.getSeconds());
	Clock.view.textContent = str;
};
Clock.consumeStatusBar = function(bar) {
	bar.addRightTile({ item : Clock.view, priority : -100});
};
var _$Clock_ClockView_$Impl_$ = {};
_$Clock_ClockView_$Impl_$.formatTimePart = function(i) {
	if(i < 10) return "0" + i; else if(i == null) return "null"; else return "" + i;
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
