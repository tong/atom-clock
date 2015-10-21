(function (console) { "use strict";
var Clock = function() { };
Clock.activate = function(state) {
	Clock.enabled = state != null?state.enabled:true;
	if(Clock.enabled == null) Clock.enabled = true;
	Clock.showSeconds = atom.config.get("clock.seconds");
	Clock.format24 = atom.config.get("clock.format");
	Clock.amPmSuffix = atom.config.get("clock.am_pm_suffix");
	var tmp;
	var this1;
	var tmp1;
	var _this = window.document;
	tmp1 = _this.createElement("div");
	this1 = tmp1;
	this1.style.display = "inline-block";
	this1.classList.add("status-bar-clock","inline-block");
	tmp = this1;
	Clock.view = tmp;
	Clock.configChangeListener = atom.config.onDidChange("clock",{ },function(e) {
		Clock.showSeconds = e.newValue.seconds;
		Clock.format24 = e.newValue.format;
		Clock.amPmSuffix = e.newValue.am_pm_suffix;
		_$DigitalClockView_DigitalClockView_$Impl_$.setTime(Clock.view,new Date(),Clock.showSeconds,Clock.format24,Clock.amPmSuffix);
	});
	Clock.commandToggleSeconds = atom.commands.add("atom-workspace","clock:toggle-seconds",function(_) {
		Clock.showSeconds = !Clock.showSeconds;
	});
	if(Clock.enabled) Clock.show(); else Clock.hide();
};
Clock.deactivate = function() {
	if(Clock.timer != null) {
		Clock.timer.stop();
		Clock.timer = null;
	}
	if(Clock.configChangeListener != null) Clock.configChangeListener.dispose();
	if(Clock.commandShow != null) Clock.commandShow.dispose();
	if(Clock.commandHide != null) Clock.commandHide.dispose();
	Clock.commandToggleSeconds.dispose();
};
Clock.serialize = function() {
	return { enabled : Clock.enabled};
};
Clock.show = function() {
	Clock.view.style.display = "inline-block";
	true;
	Clock.enabled = true;
	Clock.timer = new haxe_Timer(1000);
	Clock.timer.run = Clock.update;
	Clock.commandHide = atom.commands.add("atom-workspace","clock:hide",function(_) {
		Clock.hide();
	});
	if(Clock.commandShow != null) {
		Clock.commandShow.dispose();
		Clock.commandShow = null;
	}
};
Clock.hide = function() {
	Clock.view.style.display = "none";
	false;
	Clock.enabled = false;
	if(Clock.timer != null) {
		Clock.timer.stop();
		Clock.timer = null;
	}
	Clock.commandShow = atom.commands.add("atom-workspace","clock:show",function(_) {
		Clock.show();
	});
	if(Clock.commandHide != null) {
		Clock.commandHide.dispose();
		Clock.commandHide = null;
	}
};
Clock.update = function() {
	_$DigitalClockView_DigitalClockView_$Impl_$.setTime(Clock.view,new Date(),Clock.showSeconds,Clock.format24,Clock.amPmSuffix);
};
Clock.consumeStatusBar = function(bar) {
	bar.addRightTile({ item : Clock.view, priority : -100});
};
var _$DigitalClockView_DigitalClockView_$Impl_$ = {};
_$DigitalClockView_DigitalClockView_$Impl_$.setTime = function(this1,time,showSeconds,format24,amPmSuffix) {
	var hours = time.getHours();
	if(!format24 && hours > 12) hours -= 12;
	var str = _$DigitalClockView_DigitalClockView_$Impl_$.formatTimePart(hours) + ":" + _$DigitalClockView_DigitalClockView_$Impl_$.formatTimePart(time.getMinutes());
	if(showSeconds) str += ":" + _$DigitalClockView_DigitalClockView_$Impl_$.formatTimePart(time.getSeconds());
	if(!format24 && amPmSuffix) str += time.getHours() > 12?" PM":" AM";
	this1.textContent = str;
};
_$DigitalClockView_DigitalClockView_$Impl_$.formatTimePart = function(i) {
	return i < 10?"0" + i:i == null?"null":"" + i;
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
Clock.config = { seconds : { 'title' : "Show seconds", 'type' : "boolean", 'description' : "Toggle show seconds", 'default' : true}, format : { 'title' : "24-hour format", 'type' : "boolean", 'description' : "Toggle 12/24 format", 'default' : true}, am_pm_suffix : { 'title' : "AM/PM suffix", 'type' : "boolean", 'description' : "Show AM/PM suffix when 12-hour format is selected", 'default' : true}};
})(typeof console != "undefined" ? console : {log:function(){}});
